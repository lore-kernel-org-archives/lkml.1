Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbXKTVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbXKTVsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXKTVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:48:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:29367 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbXKTVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=QKWuiKwE1lMxiHLWRf5WZkusE4SfFWrHw9R6gJ1Oz6i8cs9awIcbkDiC5X/ewT+yWmS5wdRkD6RQtu+NCoET8FJtAj3mYbW81oxyUqq5GnkK17AI1E9GWK1jf4JJBB55aiqFX/5glfNmUSuQ3K04HurZpP4nHPYY1mU/a7oj/f0=
Message-ID: <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com>
Date: Tue, 20 Nov 2007 22:47:52 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071120180643.GD4736@vmware.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_31884_4581532.1195595277739"
References: <20071116060700.GD16273@elte.hu>
	 <20071116221404.GC31527@vmware.com>
	 <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
	 <20071117010352.GA13666@vmware.com>
	 <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
	 <20071119185116.GA28173@vmware.com>
	 <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
	 <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu>
	 <20071120180643.GD4736@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_31884_4581532.1195595277739
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 20/11/2007, Micah Dowty <micah@vmware.com> wrote:
> On Tue, Nov 20, 2007 at 06:57:55AM +0100, Ingo Molnar wrote:
> >
> > * Micah Dowty <micah@vmware.com> wrote:
> >
> > > > this one is being triggered whenever a cpu becomes idle (schedule()
> > > > --> idle_balance() --> load_balance_newidle()).
> > > >
> > > > (this flag is a bit #1 == 2)
> > > >
> > > > cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
> > >
> > > Hmm. I don't have this file on my system:
> > >
> > > root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# ls
> > > busy_factor  busy_idx  forkexec_idx  idle_idx  imbalance_pct  max_interval  min_interval  newidle_idx  wake_idx
> > > root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# uname -a
> > > Linux micah-64 2.6.23.1 #1 SMP Fri Nov 2 12:25:47 PDT 2007 x86_64 GNU/Linux
> > >
> > > Is there a config option I'm missing?
> >
> > yes, CONFIG_SCHED_DEBUG.
>
> I have that one. I even posted the /proc/sched_debug output :)

ah ok, try applying this patch on top of 2.6.23.1.

btw., what's your system? If I recall right, SD_BALANCE_NEWIDLE is on
by default for all configs, except for NUMA nodes.

(attached a white-space non-damaged version)

---

--- kernel/sched.c-old  2007-11-20 22:33:22.000000000 +0100
+++ kernel/sched.c      2007-11-20 22:37:07.000000000 +0100
@@ -5306,7 +5306,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-       struct ctl_table *table = sd_alloc_ctl_entry(14);
+       struct ctl_table *table = sd_alloc_ctl_entry(12);

        set_table_entry(&table[0], "min_interval", &sd->min_interval,
                sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5326,10 +5326,10 @@ sd_alloc_ctl_domain_table(struct sched_d
                sizeof(int), 0644, proc_dointvec_minmax);
        set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
                sizeof(int), 0644, proc_dointvec_minmax);
-       set_table_entry(&table[10], "cache_nice_tries",
+       set_table_entry(&table[9], "cache_nice_tries",
                &sd->cache_nice_tries,
                sizeof(int), 0644, proc_dointvec_minmax);
-       set_table_entry(&table[12], "flags", &sd->flags,
+       set_table_entry(&table[10], "flags", &sd->flags,
                sizeof(int), 0644, proc_dointvec_minmax);

        return table;

---

>
> --Micah
>
>


-- 
Best regards,
Dmitry Adamushko

------=_Part_31884_4581532.1195595277739
Content-Type: text/x-patch; name=sd_alloc.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f98yjaw0
Content-Disposition: attachment; filename=sd_alloc.patch

LS0tIGtlcm5lbC9zY2hlZC5jLW9sZAkyMDA3LTExLTIwIDIyOjMzOjIyLjAwMDAwMDAwMCArMDEw
MAorKysga2VybmVsL3NjaGVkLmMJMjAwNy0xMS0yMCAyMjozNzowNy4wMDAwMDAwMDAgKzAxMDAK
QEAgLTUzMDYsNyArNTMwNiw3IEBAIHNldF90YWJsZV9lbnRyeShzdHJ1Y3QgY3RsX3RhYmxlICpl
bnRyeSwKIHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlICoKIHNkX2FsbG9jX2N0bF9kb21haW5fdGFi
bGUoc3RydWN0IHNjaGVkX2RvbWFpbiAqc2QpCiB7Ci0Jc3RydWN0IGN0bF90YWJsZSAqdGFibGUg
PSBzZF9hbGxvY19jdGxfZW50cnkoMTQpOworCXN0cnVjdCBjdGxfdGFibGUgKnRhYmxlID0gc2Rf
YWxsb2NfY3RsX2VudHJ5KDEyKTsKIAogCXNldF90YWJsZV9lbnRyeSgmdGFibGVbMF0sICJtaW5f
aW50ZXJ2YWwiLCAmc2QtPm1pbl9pbnRlcnZhbCwKIAkJc2l6ZW9mKGxvbmcpLCAwNjQ0LCBwcm9j
X2RvdWxvbmd2ZWNfbWlubWF4KTsKQEAgLTUzMjYsMTAgKzUzMjYsMTAgQEAgc2RfYWxsb2NfY3Rs
X2RvbWFpbl90YWJsZShzdHJ1Y3Qgc2NoZWRfZAogCQlzaXplb2YoaW50KSwgMDY0NCwgcHJvY19k
b2ludHZlY19taW5tYXgpOwogCXNldF90YWJsZV9lbnRyeSgmdGFibGVbOF0sICJpbWJhbGFuY2Vf
cGN0IiwgJnNkLT5pbWJhbGFuY2VfcGN0LAogCQlzaXplb2YoaW50KSwgMDY0NCwgcHJvY19kb2lu
dHZlY19taW5tYXgpOwotCXNldF90YWJsZV9lbnRyeSgmdGFibGVbMTBdLCAiY2FjaGVfbmljZV90
cmllcyIsCisJc2V0X3RhYmxlX2VudHJ5KCZ0YWJsZVs5XSwgImNhY2hlX25pY2VfdHJpZXMiLAog
CQkmc2QtPmNhY2hlX25pY2VfdHJpZXMsCiAJCXNpemVvZihpbnQpLCAwNjQ0LCBwcm9jX2RvaW50
dmVjX21pbm1heCk7Ci0Jc2V0X3RhYmxlX2VudHJ5KCZ0YWJsZVsxMl0sICJmbGFncyIsICZzZC0+
ZmxhZ3MsCisJc2V0X3RhYmxlX2VudHJ5KCZ0YWJsZVsxMF0sICJmbGFncyIsICZzZC0+ZmxhZ3Ms
CiAJCXNpemVvZihpbnQpLCAwNjQ0LCBwcm9jX2RvaW50dmVjX21pbm1heCk7CiAKIAlyZXR1cm4g
dGFibGU7Cg==
------=_Part_31884_4581532.1195595277739--
