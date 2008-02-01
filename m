Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYBAU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYBAU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYBAU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:56:54 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58289 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYBAU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:56:53 -0500
Date: Fri, 1 Feb 2008 20:30:46 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: unionfs_copy_attr_times oopses
Message-ID: <Pine.LNX.4.64.0802011905230.32485@blonde.site>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1949175734-1201897846=:32485"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1949175734-1201897846=:32485
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Erez,

Aside from the occasional "unionfs: new lower inode mtime" messages
on directories (which I've got into the habit of ignoring now), the
only problem I'm still suffering with unionfs over tmpfs (not tested
any other fs's below it recently) is oops in unionfs_copy_attr_times.

I believe I'm working with your latest: 2.6.24-rc8-mm1 plus the four
patches you posted to lkml on 26 Jan.  But this problem has been around
for a while before that: I'd been hoping to debug it myself, but taken
too long to make too little progress, so now handing over to you.

The oops occurs while doing repeated "make -j20" kernel builds in a
unionfs mount of a tmpfs (though I doubt tmpfs is relevant): most of
my testing was while swapping, but today I find that's irrelevant,
and it should happen much quicker without.  SMP kernels (4 cpus),
I haven't tried UP; happens with or without PREEMPT, may just be
coincidence that it happens quicker on the machines with PREEMPT.

Most commonly it's unionfs_copy_attr_times called from unionfs_create,
but that's probably just the most common route in this workload:
I've seen it also when called from unionfs_rename or unionfs_open or
unionfs_unlink.  It looks like there's a locking or refcounting bug,
hence a race: the unionfs_inode_info which unionfs_copy_attr_times
is working on gets changed underneath it, so it oopses on NULL
lower_inodes.  It took me far too long to realize that ibstart
(and ibend) are -1 when it oopses, yet the function returns
immediately if ibstart is negative on entry.  I've not a clue
what it is that's changing it.

What I did make progress with yesterday was a workaround patch, which
additionally makes the problem more manifest: by WARNing in much more
common cases which were invisible (didn't go so far as to oops) before.
The oops had typically taken 12 hours to happen, but I'm getting like
one warning per hour (varies from machine to machine) with the patch
while swapping, and now much more frequently giving it more memory.

I've two patches.  The first isn't interesting, so I just attached
it.  It moves unionfs_copy_attr_times (and unionfs_copy_attr_all)
from inline in fanout.h to out-of-line in copyup.c: the function's
too big and too widely used to be suitable for inlining, this reduces
kernel text by about 6k.  But since making that patch, I've seen that
copyup.c is really about copying up the data, and you may well prefer
to move the functions to subr.c or elsewhere.

The patch to go on top of that is appended below: makes unionfs_copy
_attr_times more paranoid about the fields it's accessing; but this
can only be a temporary workaround - so long as there's such a race,
it could be accessing freed/reused memory with unpredictable results.

Most of the warnings I see with this patch are the first, on bend < 0:
the old "bindex <= ibend(upper)" condition would often have terminated
the loop in that case, without noticing the discrepancy that ibend
had gone negative.  Occasionally I'm seeing the second warning, on
lower_inodes, which would correspond to the oops: here's a trace
(cutting out the ? lines, just stale addresses left on the stack):

WARNING: at fs/unionfs/copyup.c:906 unionfs_copy_attr_times+0x5f/0xcc()
Modules linked in: acpi_cpufreq snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device thermal button processor
Pid: 13791, comm: cc1 Not tainted 2.6.24-rc8-mm1 #19
 [<c0124ce6>] warn_on_slowpath+0x3e/0x51
 [<c01d5f63>] unionfs_copy_attr_times+0x5f/0xcc
 [<c01d169d>] unionfs_create+0x160/0x1e7
 [<c0173b8f>] vfs_create+0x62/0xa8
 [<c0173d85>] __open_namei_create+0x44/0x8e
 [<c0173f55>] open_pathname+0x14d/0x55c
 [<c016b7d9>] do_sys_open+0x41/0xbd
 [<c016b868>] sys_open+0x13/0x15
 [<c01040ee>] sysenter_past_esp+0x5f/0x85

--- a/fs/unionfs/copyup.c	2008-01-29 16:59:13.000000000 +0000
+++ b/fs/unionfs/copyup.c	2008-01-31 12:24:58.000000000 +0000
@@ -887,13 +887,25 @@ void unionfs_postcopyup_release(struct d
 /* copy a/m/ctime from the lower branch with the newest times */
 void unionfs_copy_attr_times(struct inode *upper)
 {
-	int bindex;
+	int bindex, bend;
 	struct inode *lower;
+	struct inode **lower_inodes;
 
-	if (!upper || ibstart(upper) < 0)
+	if (!upper)
 		return;
-	for (bindex = ibstart(upper); bindex <= ibend(upper); bindex++) {
-		lower = unionfs_lower_inode_idx(upper, bindex);
+	bindex = ibstart(upper);
+	if (bindex < 0)
+		return;
+	while (1) {
+		bend = ibend(upper);
+		if (WARN_ON(bend < 0))
+			break;
+		if (bindex > bend)
+			break;
+		lower_inodes = UNIONFS_I(upper)->lower_inodes;
+		if (WARN_ON(!lower_inodes))
+			break;
+		lower = lower_inodes[bindex++];
 		if (!lower)
 			continue; /* not all lower dir objects may exist */
 		if (unlikely(timespec_compare(&upper->i_mtime,
--8323584-1949175734-1201897846=:32485
Content-Type: TEXT/x-patch; charset=US-ASCII; name=copyup1.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0802012030460.32485@blonde.site>
Content-Description: out-of-lining
Content-Disposition: attachment; filename=copyup1.patch

LS0tIGEvZnMvdW5pb25mcy9jb3B5dXAuYwkyMDA4LTAxLTI3IDEzOjAwOjI0
LjAwMDAwMDAwMCArMDAwMA0KKysrIGIvZnMvdW5pb25mcy9jb3B5dXAuYwky
MDA4LTAxLTI3IDE2OjUwOjM0LjAwMDAwMDAwMCArMDAwMA0KQEAgLTg4Mywz
ICs4ODMsNTIgQEAgdm9pZCB1bmlvbmZzX3Bvc3Rjb3B5dXBfcmVsZWFzZShz
dHJ1Y3QgZA0KIAlzZXRfZGJlbmQoZGVudHJ5LCBiaW5kZXgpOw0KIAlpYmVu
ZChkZW50cnktPmRfaW5vZGUpID0gaWJzdGFydChkZW50cnktPmRfaW5vZGUp
ID0gYmluZGV4Ow0KIH0NCisNCisvKiBjb3B5IGEvbS9jdGltZSBmcm9tIHRo
ZSBsb3dlciBicmFuY2ggd2l0aCB0aGUgbmV3ZXN0IHRpbWVzICovDQordm9p
ZCB1bmlvbmZzX2NvcHlfYXR0cl90aW1lcyhzdHJ1Y3QgaW5vZGUgKnVwcGVy
KQ0KK3sNCisJaW50IGJpbmRleDsNCisJc3RydWN0IGlub2RlICpsb3dlcjsN
CisNCisJaWYgKCF1cHBlciB8fCBpYnN0YXJ0KHVwcGVyKSA8IDApDQorCQly
ZXR1cm47DQorCWZvciAoYmluZGV4ID0gaWJzdGFydCh1cHBlcik7IGJpbmRl
eCA8PSBpYmVuZCh1cHBlcik7IGJpbmRleCsrKSB7DQorCQlsb3dlciA9IHVu
aW9uZnNfbG93ZXJfaW5vZGVfaWR4KHVwcGVyLCBiaW5kZXgpOw0KKwkJaWYg
KCFsb3dlcikNCisJCQljb250aW51ZTsgLyogbm90IGFsbCBsb3dlciBkaXIg
b2JqZWN0cyBtYXkgZXhpc3QgKi8NCisJCWlmICh1bmxpa2VseSh0aW1lc3Bl
Y19jb21wYXJlKCZ1cHBlci0+aV9tdGltZSwNCisJCQkJCSAgICAgICZsb3dl
ci0+aV9tdGltZSkgPCAwKSkNCisJCQl1cHBlci0+aV9tdGltZSA9IGxvd2Vy
LT5pX210aW1lOw0KKwkJaWYgKHVubGlrZWx5KHRpbWVzcGVjX2NvbXBhcmUo
JnVwcGVyLT5pX2N0aW1lLA0KKwkJCQkJICAgICAgJmxvd2VyLT5pX2N0aW1l
KSA8IDApKQ0KKwkJCXVwcGVyLT5pX2N0aW1lID0gbG93ZXItPmlfY3RpbWU7
DQorCQlpZiAodW5saWtlbHkodGltZXNwZWNfY29tcGFyZSgmdXBwZXItPmlf
YXRpbWUsDQorCQkJCQkgICAgICAmbG93ZXItPmlfYXRpbWUpIDwgMCkpDQor
CQkJdXBwZXItPmlfYXRpbWUgPSBsb3dlci0+aV9hdGltZTsNCisJfQ0KK30N
CisNCisvKg0KKyAqIEEgdW5pb25mcy9mYW5vdXQgdmVyc2lvbiBvZiBmc3N0
YWNrX2NvcHlfYXR0cl9hbGwuICBVc2VzIGENCisgKiB1bmlvbmZzX2dldF9u
bGlua3MgdG8gcHJvcGVybHkgY2FsY2x1YXRlIHRoZSBudW1iZXIgb2YgbGlu
a3MgdG8gYSBmaWxlLg0KKyAqIEFsc28sIGNvcGllcyB0aGUgbWF4KCkgb2Yg
YWxsIGEvbS9jdGltZXMgZm9yIGFsbCBsb3dlciBpbm9kZXMgKHdoaWNoIGlz
DQorICogaW1wb3J0YW50IGlmIHRoZSBsb3dlciBpbm9kZSBpcyBhIGRpcmVj
dG9yeSB0eXBlKQ0KKyAqLw0KK3ZvaWQgdW5pb25mc19jb3B5X2F0dHJfYWxs
KHN0cnVjdCBpbm9kZSAqZGVzdCwgY29uc3Qgc3RydWN0IGlub2RlICpzcmMp
DQorew0KKwlkZXN0LT5pX21vZGUgPSBzcmMtPmlfbW9kZTsNCisJZGVzdC0+
aV91aWQgPSBzcmMtPmlfdWlkOw0KKwlkZXN0LT5pX2dpZCA9IHNyYy0+aV9n
aWQ7DQorCWRlc3QtPmlfcmRldiA9IHNyYy0+aV9yZGV2Ow0KKw0KKwl1bmlv
bmZzX2NvcHlfYXR0cl90aW1lcyhkZXN0KTsNCisNCisJZGVzdC0+aV9ibGti
aXRzID0gc3JjLT5pX2Jsa2JpdHM7DQorCWRlc3QtPmlfZmxhZ3MgPSBzcmMt
PmlfZmxhZ3M7DQorDQorCS8qDQorCSAqIFVwZGF0ZSB0aGUgbmxpbmtzIEFG
VEVSIHVwZGF0aW5nIHRoZSBhYm92ZSBmaWVsZHMsIGJlY2F1c2UgdGhlDQor
CSAqIGdldF9saW5rcyBjYWxsYmFjayBtYXkgZGVwZW5kIG9uIHRoZW0uDQor
CSAqLw0KKwlkZXN0LT5pX25saW5rID0gdW5pb25mc19nZXRfbmxpbmtzKGRl
c3QpOw0KK30NCi0tLSBhL2ZzL3VuaW9uZnMvZmFub3V0LmgJMjAwOC0wMS0x
NyAxNjo1MToxNC4wMDAwMDAwMDAgKzAwMDANCisrKyBiL2ZzL3VuaW9uZnMv
ZmFub3V0LmgJMjAwOC0wMS0yNyAxNjo0ODoxMi4wMDAwMDAwMDAgKzAwMDAN
CkBAIC0zMTQsNTMgKzMxNCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB2ZXJp
ZnlfbG9ja2VkKHN0cnVjdCANCiB9DQogDQogLyogY29weSBhL20vY3RpbWUg
ZnJvbSB0aGUgbG93ZXIgYnJhbmNoIHdpdGggdGhlIG5ld2VzdCB0aW1lcyAq
Lw0KLXN0YXRpYyBpbmxpbmUgdm9pZCB1bmlvbmZzX2NvcHlfYXR0cl90aW1l
cyhzdHJ1Y3QgaW5vZGUgKnVwcGVyKQ0KLXsNCi0JaW50IGJpbmRleDsNCi0J
c3RydWN0IGlub2RlICpsb3dlcjsNCi0NCi0JaWYgKCF1cHBlciB8fCBpYnN0
YXJ0KHVwcGVyKSA8IDApDQotCQlyZXR1cm47DQotCWZvciAoYmluZGV4ID0g
aWJzdGFydCh1cHBlcik7IGJpbmRleCA8PSBpYmVuZCh1cHBlcik7IGJpbmRl
eCsrKSB7DQotCQlsb3dlciA9IHVuaW9uZnNfbG93ZXJfaW5vZGVfaWR4KHVw
cGVyLCBiaW5kZXgpOw0KLQkJaWYgKCFsb3dlcikNCi0JCQljb250aW51ZTsg
Lyogbm90IGFsbCBsb3dlciBkaXIgb2JqZWN0cyBtYXkgZXhpc3QgKi8NCi0J
CWlmICh1bmxpa2VseSh0aW1lc3BlY19jb21wYXJlKCZ1cHBlci0+aV9tdGlt
ZSwNCi0JCQkJCSAgICAgICZsb3dlci0+aV9tdGltZSkgPCAwKSkNCi0JCQl1
cHBlci0+aV9tdGltZSA9IGxvd2VyLT5pX210aW1lOw0KLQkJaWYgKHVubGlr
ZWx5KHRpbWVzcGVjX2NvbXBhcmUoJnVwcGVyLT5pX2N0aW1lLA0KLQkJCQkJ
ICAgICAgJmxvd2VyLT5pX2N0aW1lKSA8IDApKQ0KLQkJCXVwcGVyLT5pX2N0
aW1lID0gbG93ZXItPmlfY3RpbWU7DQotCQlpZiAodW5saWtlbHkodGltZXNw
ZWNfY29tcGFyZSgmdXBwZXItPmlfYXRpbWUsDQotCQkJCQkgICAgICAmbG93
ZXItPmlfYXRpbWUpIDwgMCkpDQotCQkJdXBwZXItPmlfYXRpbWUgPSBsb3dl
ci0+aV9hdGltZTsNCi0JfQ0KLX0NCi0NCi0vKg0KLSAqIEEgdW5pb25mcy9m
YW5vdXQgdmVyc2lvbiBvZiBmc3N0YWNrX2NvcHlfYXR0cl9hbGwuICBVc2Vz
IGENCi0gKiB1bmlvbmZzX2dldF9ubGlua3MgdG8gcHJvcGVybHkgY2FsY2x1
YXRlIHRoZSBudW1iZXIgb2YgbGlua3MgdG8gYSBmaWxlLg0KLSAqIEFsc28s
IGNvcGllcyB0aGUgbWF4KCkgb2YgYWxsIGEvbS9jdGltZXMgZm9yIGFsbCBs
b3dlciBpbm9kZXMgKHdoaWNoIGlzDQotICogaW1wb3J0YW50IGlmIHRoZSBs
b3dlciBpbm9kZSBpcyBhIGRpcmVjdG9yeSB0eXBlKQ0KLSAqLw0KLXN0YXRp
YyBpbmxpbmUgdm9pZCB1bmlvbmZzX2NvcHlfYXR0cl9hbGwoc3RydWN0IGlu
b2RlICpkZXN0LA0KLQkJCQkJIGNvbnN0IHN0cnVjdCBpbm9kZSAqc3JjKQ0K
LXsNCi0JZGVzdC0+aV9tb2RlID0gc3JjLT5pX21vZGU7DQotCWRlc3QtPmlf
dWlkID0gc3JjLT5pX3VpZDsNCi0JZGVzdC0+aV9naWQgPSBzcmMtPmlfZ2lk
Ow0KLQlkZXN0LT5pX3JkZXYgPSBzcmMtPmlfcmRldjsNCi0NCi0JdW5pb25m
c19jb3B5X2F0dHJfdGltZXMoZGVzdCk7DQotDQotCWRlc3QtPmlfYmxrYml0
cyA9IHNyYy0+aV9ibGtiaXRzOw0KLQlkZXN0LT5pX2ZsYWdzID0gc3JjLT5p
X2ZsYWdzOw0KLQ0KLQkvKg0KLQkgKiBVcGRhdGUgdGhlIG5saW5rcyBBRlRF
UiB1cGRhdGluZyB0aGUgYWJvdmUgZmllbGRzLCBiZWNhdXNlIHRoZQ0KLQkg
KiBnZXRfbGlua3MgY2FsbGJhY2sgbWF5IGRlcGVuZCBvbiB0aGVtLg0KLQkg
Ki8NCi0JZGVzdC0+aV9ubGluayA9IHVuaW9uZnNfZ2V0X25saW5rcyhkZXN0
KTsNCi19DQordm9pZCB1bmlvbmZzX2NvcHlfYXR0cl90aW1lcyhzdHJ1Y3Qg
aW5vZGUgKnVwcGVyKTsNCit2b2lkIHVuaW9uZnNfY29weV9hdHRyX2FsbChz
dHJ1Y3QgaW5vZGUgKmRlc3QsIGNvbnN0IHN0cnVjdCBpbm9kZSAqc3JjKTsN
CiANCiAjZW5kaWYJLyogbm90IF9GQU5PVVRfSCAqLw0K

--8323584-1949175734-1201897846=:32485--
