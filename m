Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXGLUZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXGLUZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbXGLUZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:25:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1492 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbXGLUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:25:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=idm6S8T32UBLwlcE86MylVBhX8r9Rd8/QW9ZDO9PaVMTA+qERw+PkZO9RdAJZL7sF
	SbTmQhYEtROwc0kJWKJzQ==
Date: Thu, 12 Jul 2007 13:24:36 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: ak@suse.de, akpm@google.com, linux-kernel@vger.kernel.org
cc: Tim Hockin <thockin@google.com>, Mike Waychison <mikew@google.com>
Subject: [x86_64 MCE] [RFC] mce.c race condition (or: when evil hacks are
 the only options)
Message-ID: <Pine.LNX.4.64.0707121309520.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="313268086-418146021-1184271876=:617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--313268086-418146021-1184271876=:617
Content-Type: TEXT/PLAIN; charset=US-ASCII

Some time after my first[1] patch to mce.c, I had continued testing using
the test method described there (inject hundreds of thousands of single-bit
errors while reading from /dev/mcelog), and I came across a strange issue. 
Once every couple test cycles (i.e., every hundred-thousand injects), the
system would begin behaving very strangely. The serial port would stop
responding entirely, and my SSH sessions would respond, but to one keystroke
behind what I had typed. After two minutes, the watchdog timer would reboot
the system.

These seemed to be fairly classic cases of missing interrupts, so in one of
my remaining sessions, I did a 'cat /proc/interrupts' after the machine had
entered this state. Sure enough, interrupt counts on CPU0 were not
incrementing, although my network interrupts on CPU1 were.

After some diagnostics, it appears that there is a race condition between
mce_log() and mce_read() that can lead to cpu0 spinning forever in mce_log's
loop that tries to claim a next entry.

The race requires a large number of machine checks to be occurring in order
for it to happen. Consider the case in which we take a machine check that
was, as the comment in mce.c:518 (mce_read) might describe, was still
getting written before the synchronize. We are presently in
synchronize_sched. The system, at this time, looks like this:

mcelog.next: 0
mcelog.entry: {0} {0} {1} {0} {0} {0} {0} {0}

(For the sake of simplicity, a mcelog entry in my little world here has only
one property -- finished. 1 means that it is finished, and 0 means that it
isn't.)

In the normal case, the rest would get cleaned up by the subsequent loop,
looping from i = next to MCE_LOG_LEN. But, what happens if we take another
three machine checks while we're still in synchronize_sched()?
synchronize_sched() isn't just waiting for all mce_log()s to finish, but in
fact is waiting for all CPUs to be done, which could take up to a tick -- or
in the case of our very slow interrupt handler, longer. So, although on a
normally functioning system, this is unlikely, it is possible that we might
take another three machine checks in that span of time.

So, let's watch what happens. After the first machine check, we get:

mcelog.next: 1
mcelog.entry: {1} {0} {1} {0} {0} {0} {0} {0}

And after the second one, we get:

mcelog.next: 2
mcelog.entry: {1} {1} {1} {0} {0} {0} {0} {0}

But what happens on the third one? The third one will loop waiting for the
finished bit on the third entry (mcelog.entry[2]) to be cleared, since that
is what the loop under the synchronize_sched() is supposed to do. So,
normally, it'd be a sane assumption to say that eventually that bit would
get cleared.

But, in this case, we're looping forever in an interrupt. Even though the
synchronize_sched() will have finished, the on_each_cpu() will be looping
forever as well, waiting for the CPU that's processing the exception to get
around to running the collect_tscs() routine.

At this point, mce_read() and mce_log() are blocking on each other, and will
be for all eternity. mce_log() is waiting for the on_each_cpu() to complete
so that the loop can complete, and on_each_cpu() (from mce_read()) is
waiting for mce_log() to finish.

We've researched this recently, and we've come up with a few possible
solutions for this.

The first option is to make mce_log() time out if it has looped too many
times in the outer loop. I've instrumented this and found that it's
possible for the loop to run over ten million times in normal operation, but
it almost never goes above that. The net result, though, is that if we go
above that magic number, we should probably bail out, since it's unlikely
that we'll ever come back to life.

I don't really like this solution, though. It's obviously a nasty hack, and
doesn't solve the underlying condition. And, on top of that, we lose MCEs
when it breaks. Now, if we're under this much MCE load, we probably won't
miss them, but still, we lose one.

The other option is to give mce_log and mce_read a complete rewrite, it
seems. The code looks like it has been through quite a few iterations to fix
edge cases just like this one -- there may be other edge cases other than
this one. I'm actually surprised that this wasn't a ring buffer to start
with -- it certainly seems like it wanted to be one. The obvious
disadvantage to that is that new code is just as likely to be broken in
subtle ways as the old code originally was. It may end up cleaner in the
long run, but in the short run, it's a new codebase with different
properties than what we're used to.

I'm not quite sure what to do here. I'm leaning towards the mce_log timeout
method, just fixing this symptom for the time being. I don't like it much,
but in the absence of an option to not be evil[2], I guess we should go with
the least evil option possible.

I've come up with a patch that does this (inlined and attached), and I've
been banging on a system for the past 12 hours trying to break it like this.
It seems to be stable, although it's sill ugly.

Thoughts?

joshua

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f84e4be53a04a65d97bf0faa0c8f99e29bc0170

[2] http://investor.google.com/conduct.html

--

From: Joshua Wise <jwise@google.com>

Background:
 In some situations, mce_log would race against mce_read and deadlock. This
 race condition is described in more detail in the body of the associated
 e-mail.

Description:
 This patch allows the machine check exception handler to time out after
 spinning for too long waiting for the deadlock to finish. This may lose a
 machine check exception from time to time, but it's certainly better than
 bringing down the system.

Remaining issues:
 * Should the whole log structure just be rewritten as a ring buffer?

Testing:
 I injected single bit errors on CPU0 in a while loop overnight while
 running mced on CPU1. Previously, this would crash the system after some
 minutes, but the system survived the entire night this way.

Credits:
 Thanks to Tim Hockin <thockin@google.com> and Mike Waychison
 <mikew@google.com> for sitting down with me and combing through this to
 help me find the race.

Patch:
 This patch is against git 0471448f4d017470995d8a2272dc8c06dbed3b77.

Signed-off-by: Joshua Wise <joshua@joshuawise.com>

--

diff --git a/arch/x86_64/kernel/mce.c b/arch/x86_64/kernel/mce.c
index aa1d159..87ff9dd 100644
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -30,6 +30,8 @@ #include <asm/smp.h>
 #define MISC_MCELOG_MINOR 227
 #define NR_BANKS 6
 
+#define MCE_LOG_RETRIES 100000000 /* if we retry 100,000,000 times, we are probably in the synchronize_sched race */
+
 atomic_t mce_entry;
 
 static int mce_dont_init;
@@ -61,7 +63,7 @@ struct mce_log mcelog = { 
 
 void mce_log(struct mce *mce)
 {
-	unsigned next, entry;
+	unsigned next, entry, attempts = 0;
 	atomic_inc(&mce_events);
 	mce->finished = 0;
 	wmb();
@@ -70,6 +72,13 @@ void mce_log(struct mce *mce)
 		/* The rmb forces the compiler to reload next in each
 		    iteration */
 		rmb();
+		
+		/* Deal with the synchronize_sched race */
+		if (attempts++ > MCE_LOG_RETRIES) {
+			set_bit(MCE_OVERFLOW, &mcelog.flags);
+			return;
+		}
+		
 		for (;;) {
 			/* When the buffer fills up discard new entries. Assume
 			   that the earlier errors are the more interesting. */
--313268086-418146021-1184271876=:617
Content-Type: TEXT/plain; charset=US-ASCII; name=mce-retries-race.diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0707121324360.617@internets.corp.google.com>
Content-Description: 
Content-Disposition: attachment; filename=mce-retries-race.diff

RnJvbTogSm9zaHVhIFdpc2UgPGp3aXNlQGdvb2dsZS5jb20+DQoNCkJhY2tn
cm91bmQ6DQogSW4gc29tZSBzaXR1YXRpb25zLCBtY2VfbG9nIHdvdWxkIHJh
Y2UgYWdhaW5zdCBtY2VfcmVhZCBhbmQgZGVhZGxvY2suIFRoaXMNCiByYWNl
IGNvbmRpdGlvbiBpcyBkZXNjcmliZWQgaW4gbW9yZSBkZXRhaWwgaW4gdGhl
IGJvZHkgb2YgdGhlIGFzc29jaWF0ZWQNCiBlLW1haWwuDQoNCkRlc2NyaXB0
aW9uOg0KIFRoaXMgcGF0Y2ggYWxsb3dzIHRoZSBtYWNoaW5lIGNoZWNrIGV4
Y2VwdGlvbiBoYW5kbGVyIHRvIHRpbWUgb3V0IGFmdGVyDQogc3Bpbm5pbmcg
Zm9yIHRvbyBsb25nIHdhaXRpbmcgZm9yIHRoZSBkZWFkbG9jayB0byBmaW5p
c2guIFRoaXMgbWF5IGxvc2UgYQ0KIG1hY2hpbmUgY2hlY2sgZXhjZXB0aW9u
IGZyb20gdGltZSB0byB0aW1lLCBidXQgaXQncyBjZXJ0YWlubHkgYmV0dGVy
IHRoYW4NCiBicmluZ2luZyBkb3duIHRoZSBzeXN0ZW0uDQoNClJlbWFpbmlu
ZyBpc3N1ZXM6DQogKiBTaG91bGQgdGhlIHdob2xlIGxvZyBzdHJ1Y3R1cmUg
anVzdCBiZSByZXdyaXR0ZW4gYXMgYSByaW5nIGJ1ZmZlcj8NCg0KVGVzdGlu
ZzoNCiBJIGluamVjdGVkIHNpbmdsZSBiaXQgZXJyb3JzIG9uIENQVTAgaW4g
YSB3aGlsZSBsb29wIG92ZXJuaWdodCB3aGlsZQ0KIHJ1bm5pbmcgbWNlZCBv
biBDUFUxLiBQcmV2aW91c2x5LCB0aGlzIHdvdWxkIGNyYXNoIHRoZSBzeXN0
ZW0gYWZ0ZXIgc29tZQ0KIG1pbnV0ZXMsIGJ1dCB0aGUgc3lzdGVtIHN1cnZp
dmVkIHRoZSBlbnRpcmUgbmlnaHQgdGhpcyB3YXkuDQoNCkNyZWRpdHM6DQog
VGhhbmtzIHRvIFRpbSBIb2NraW4gPHRob2NraW5AZ29vZ2xlLmNvbT4gYW5k
IE1pa2UgV2F5Y2hpc29uDQogPG1pa2V3QGdvb2dsZS5jb20+IGZvciBzaXR0
aW5nIGRvd24gd2l0aCBtZSBhbmQgY29tYmluZyB0aHJvdWdoIHRoaXMgdG8N
CiBoZWxwIG1lIGZpbmQgdGhlIHJhY2UuDQoNClBhdGNoOg0KIFRoaXMgcGF0
Y2ggaXMgYWdhaW5zdCBnaXQgMDQ3MTQ0OGY0ZDAxNzQ3MDk5NWQ4YTIyNzJk
YzhjMDZkYmVkM2I3Ny4NCg0KU2lnbmVkLW9mZi1ieTogSm9zaHVhIFdpc2Ug
PGpvc2h1YUBqb3NodWF3aXNlLmNvbT4NCg0KLS0NCg0KZGlmZiAtLWdpdCBh
L2FyY2gveDg2XzY0L2tlcm5lbC9tY2UuYyBiL2FyY2gveDg2XzY0L2tlcm5l
bC9tY2UuYw0KaW5kZXggYWExZDE1OS4uODdmZjlkZCAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2XzY0L2tlcm5lbC9tY2UuYw0KKysrIGIvYXJjaC94ODZfNjQv
a2VybmVsL21jZS5jDQpAQCAtMzAsNiArMzAsOCBAQCAjaW5jbHVkZSA8YXNt
L3NtcC5oPg0KICNkZWZpbmUgTUlTQ19NQ0VMT0dfTUlOT1IgMjI3DQogI2Rl
ZmluZSBOUl9CQU5LUyA2DQogDQorI2RlZmluZSBNQ0VfTE9HX1JFVFJJRVMg
MTAwMDAwMDAwIC8qIGlmIHdlIHJldHJ5IDEwMCwwMDAsMDAwIHRpbWVzLCB3
ZSBhcmUgcHJvYmFibHkgaW4gdGhlIHN5bmNocm9uaXplX3NjaGVkIHJhY2Ug
Ki8NCisNCiBhdG9taWNfdCBtY2VfZW50cnk7DQogDQogc3RhdGljIGludCBt
Y2VfZG9udF9pbml0Ow0KQEAgLTYxLDcgKzYzLDcgQEAgc3RydWN0IG1jZV9s
b2cgbWNlbG9nID0geyANCiANCiB2b2lkIG1jZV9sb2coc3RydWN0IG1jZSAq
bWNlKQ0KIHsNCi0JdW5zaWduZWQgbmV4dCwgZW50cnk7DQorCXVuc2lnbmVk
IG5leHQsIGVudHJ5LCBhdHRlbXB0cyA9IDA7DQogCWF0b21pY19pbmMoJm1j
ZV9ldmVudHMpOw0KIAltY2UtPmZpbmlzaGVkID0gMDsNCiAJd21iKCk7DQpA
QCAtNzAsNiArNzIsMTMgQEAgdm9pZCBtY2VfbG9nKHN0cnVjdCBtY2UgKm1j
ZSkNCiAJCS8qIFRoZSBybWIgZm9yY2VzIHRoZSBjb21waWxlciB0byByZWxv
YWQgbmV4dCBpbiBlYWNoDQogCQkgICAgaXRlcmF0aW9uICovDQogCQlybWIo
KTsNCisJCQ0KKwkJLyogRGVhbCB3aXRoIHRoZSBzeW5jaHJvbml6ZV9zY2hl
ZCByYWNlICovDQorCQlpZiAoYXR0ZW1wdHMrKyA+IE1DRV9MT0dfUkVUUklF
Uykgew0KKwkJCXNldF9iaXQoTUNFX09WRVJGTE9XLCAmbWNlbG9nLmZsYWdz
KTsNCisJCQlyZXR1cm47DQorCQl9DQorCQkNCiAJCWZvciAoOzspIHsNCiAJ
CQkvKiBXaGVuIHRoZSBidWZmZXIgZmlsbHMgdXAgZGlzY2FyZCBuZXcgZW50
cmllcy4gQXNzdW1lDQogCQkJICAgdGhhdCB0aGUgZWFybGllciBlcnJvcnMg
YXJlIHRoZSBtb3JlIGludGVyZXN0aW5nLiAqLw0K

--313268086-418146021-1184271876=:617--
