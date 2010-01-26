Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004Ab0AZKJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0AZKJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268Ab0AZKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:09:37 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:52388 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0AZKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:09:36 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 05:09:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b/nR7woj6PpbMNcYkJLNwC72vqwr9oXbHnsXFO9usgJddIVkXENcxBAI4V1LyGyoom
         oMimkOKNwma6ghgBdnKJ12wI5wIPyU/0V2E4Xw/BUlN32w6GIzT7fv/vZ9fEywOcLtQE
         NJfxxcEAAvAHvR3aeKaKSCG7Aw0oe1POe9PJ8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001260946530.5926@localhost.localdomain>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
	 <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
	 <20100126092234.77b363d4@mschwide.boeblingen.de.ibm.com>
	 <alpine.LFD.2.00.1001260946530.5926@localhost.localdomain>
Date: Tue, 26 Jan 2010 18:01:42 +0800
Message-ID: <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel 
	debugger
From: Dongdong Deng <libfetion@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Content-Type: multipart/mixed; boundary=00504502af1770193e047e0e5fe7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502af1770193e047e0e5fe7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2010 at 4:50 PM, Thomas Gleixner <tglx@linutronix.de> wrote=
:
> On Tue, 26 Jan 2010, Martin Schwidefsky wrote:
>> On Mon, 25 Jan 2010 22:26:39 -0600
>> Jason Wessel <jason.wessel@windriver.com> wrote:
>>
>> > This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277=
a8e4
>> >
>> > Spin locks were added to the clocksource_resume_watchdog() which cause
>> > the kernel debugger to deadlock on an SMP system frequently.
>> >
>> > The kernel debugger can try for the lock, but if it fails it should
>> > continue to touch the clocksource watchdog anyway, else it will trip
>> > if the general kernel execution has been paused for too long.
>> >
>> > This introduces an possible race condition where the kernel debugger
>> > might not process the list correctly if a clocksource is being added
>> > or removed at the time of this call. =C2=A0This race is sufficiently r=
are vs
>> > having the kernel debugger hang the kernel
>> >
>> > CC: Thomas Gleixner <tglx@linutronix.de>
>> > CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> > CC: John Stultz <johnstul@us.ibm.com>
>> > CC: Andrew Morton <akpm@linux-foundation.org>
>> > CC: Magnus Damm <damm@igel.co.jp>
>> > Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>>
>> The first question I would ask is why does the kernel deadlock? Can we
>> have a backchain of a deadlock please?
>
> The problem arises when the kernel is stopped inside the watchdog code
> with watchdog_lock held. When kgdb restarts execution then it touches
> the watchdog to avoid that TSC gets marked unstable.
>
>> Hmm, there are all kinds of races if the watchdog code gets interrupted
>> by the kernel debugger. Wouldn't it be better to just disable the
>> watchdog while the kernel debugger is active?
>
> No, we can keep it and in most cases it clocksource_touch_watchdog()
> helps to keep TSC alive. A simple "if (!trylock) return;" should solve
> the deadlock problem for kgdb without opening a can of worms.

Is it possible that we reset the clocksource watchdog during in
clocksource_watchdog() ?

>From the code view, The action of reset clocksource watchdog is just
set the CLOCK_SOURCE_WATCHDOG flag.
thus if we reset it before using, I think the logic will be right.


---

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..0590983 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -187,6 +187,8 @@ static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static int watchdog_running;

+static int volatile clocksource_resume_watchdog;
+
 static int clocksource_watchdog_kthread(void *data);
 static void __clocksource_change_rating(struct clocksource *cs, int rating=
);

@@ -253,6 +255,11 @@ static void clocksource_watchdog(unsigned long data)
        if (!watchdog_running)
                goto out;

+       if (unlikely(clocksource_resume_watchdog)) {
+               clocksource_reset_watchdog();
+               clocksource_resume_watchdog =3D 0;
+       }
+
        wdnow =3D watchdog->read(watchdog);
        wd_nsec =3D clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->=
mask,
                                     watchdog->mult, watchdog->shift);
@@ -341,11 +348,7 @@ static inline void clocksource_reset_watchdog(void)

 static void clocksource_resume_watchdog(void)
 {
-       unsigned long flags;
-
-       spin_lock_irqsave(&watchdog_lock, flags);
-       clocksource_reset_watchdog();
-       spin_unlock_irqrestore(&watchdog_lock, flags);
+       clocksource_resume_watchdog =3D 1;
 }

 static void clocksource_enqueue_watchdog(struct clocksource *cs)



>
> Thanks,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>

--00504502af1770193e047e0e5fe7
Content-Type: text/x-patch; charset=US-ASCII; name="clocksource_resume_watchdog.patch"
Content-Disposition: attachment; 
	filename="clocksource_resume_watchdog.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4wirxof0

ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL2Nsb2Nrc291cmNlLmMgYi9rZXJuZWwvdGltZS9jbG9j
a3NvdXJjZS5jCmluZGV4IGU4NWMyMzQuLjA1OTA5ODMgMTAwNjQ0Ci0tLSBhL2tlcm5lbC90aW1l
L2Nsb2Nrc291cmNlLmMKKysrIGIva2VybmVsL3RpbWUvY2xvY2tzb3VyY2UuYwpAQCAtMTg3LDYg
KzE4Nyw4IEBAIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0sod2F0Y2hkb2dfbG9jayk7CiBzdGF0aWMg
Y3ljbGVfdCB3YXRjaGRvZ19sYXN0Owogc3RhdGljIGludCB3YXRjaGRvZ19ydW5uaW5nOwogCitz
dGF0aWMgaW50IHZvbGF0aWxlIGNsb2Nrc291cmNlX3Jlc3VtZV93YXRjaGRvZzsKKwogc3RhdGlj
IGludCBjbG9ja3NvdXJjZV93YXRjaGRvZ19rdGhyZWFkKHZvaWQgKmRhdGEpOwogc3RhdGljIHZv
aWQgX19jbG9ja3NvdXJjZV9jaGFuZ2VfcmF0aW5nKHN0cnVjdCBjbG9ja3NvdXJjZSAqY3MsIGlu
dCByYXRpbmcpOwogCkBAIC0yNTMsNiArMjU1LDExIEBAIHN0YXRpYyB2b2lkIGNsb2Nrc291cmNl
X3dhdGNoZG9nKHVuc2lnbmVkIGxvbmcgZGF0YSkKIAlpZiAoIXdhdGNoZG9nX3J1bm5pbmcpCiAJ
CWdvdG8gb3V0OwogCisJaWYgKHVubGlrZWx5KGNsb2Nrc291cmNlX3Jlc3VtZV93YXRjaGRvZykp
IHsKKwkJY2xvY2tzb3VyY2VfcmVzZXRfd2F0Y2hkb2coKTsKKwkJY2xvY2tzb3VyY2VfcmVzdW1l
X3dhdGNoZG9nID0gMDsKKwl9CisKIAl3ZG5vdyA9IHdhdGNoZG9nLT5yZWFkKHdhdGNoZG9nKTsK
IAl3ZF9uc2VjID0gY2xvY2tzb3VyY2VfY3ljMm5zKCh3ZG5vdyAtIHdhdGNoZG9nX2xhc3QpICYg
d2F0Y2hkb2ctPm1hc2ssCiAJCQkJICAgICB3YXRjaGRvZy0+bXVsdCwgd2F0Y2hkb2ctPnNoaWZ0
KTsKQEAgLTM0MSwxMSArMzQ4LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGNsb2Nrc291cmNlX3Jl
c2V0X3dhdGNoZG9nKHZvaWQpCiAKIHN0YXRpYyB2b2lkIGNsb2Nrc291cmNlX3Jlc3VtZV93YXRj
aGRvZyh2b2lkKQogewotCXVuc2lnbmVkIGxvbmcgZmxhZ3M7Ci0KLQlzcGluX2xvY2tfaXJxc2F2
ZSgmd2F0Y2hkb2dfbG9jaywgZmxhZ3MpOwotCWNsb2Nrc291cmNlX3Jlc2V0X3dhdGNoZG9nKCk7
Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmd2F0Y2hkb2dfbG9jaywgZmxhZ3MpOworCWNsb2Nr
c291cmNlX3Jlc3VtZV93YXRjaGRvZyA9IDE7CiB9CiAKIHN0YXRpYyB2b2lkIGNsb2Nrc291cmNl
X2VucXVldWVfd2F0Y2hkb2coc3RydWN0IGNsb2Nrc291cmNlICpjcykK
--00504502af1770193e047e0e5fe7--
