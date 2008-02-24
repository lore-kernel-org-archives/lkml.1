Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYBXEJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYBXEJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYBXEIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:08:49 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:44160 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYBXEIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=Wp/2lNFjcOVc4zaRblUCJ7Ms72Ck7kCKBr8IUB6gBB2HrFWkeFjnZm90A1JaDKqPQHagNny4yUfCALH5uqNm+dv/obypapkkeewDsgDR7TgugYTljQp1zxcV9b9Q0t0pdEPNsBnA+Q8IqbRrlhh/OqvgWG/r5nvHyMeXEzNBKUE=
Message-ID: <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
Date: Sun, 24 Feb 2008 05:08:46 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Rik van Riel" <riel@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt switch.
In-Reply-To: <20080223221750.429cf0d9@bree.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5372_25562095.1203826126145"
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	 <20080223221750.429cf0d9@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5372_25562095.1203826126145
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 2008/2/24, Rik van Riel <riel@redhat.com> wrote:
> On Sun, 24 Feb 2008 04:08:38 +0100
>  "J.C. Pizarro" <jcpiza@gmail.com> wrote:
>
>  > We will need 64 bit counters of the slow context switches,
>  >   one counter for each new created task (e.g. u64 ctxt_switch_counts;)
>
>
> Please send a patch ...

diff -ur linux-2.6_git-20080224.orig/include/linux/sched.h
linux-2.6_git-20080224/include/linux/sched.h
--- linux-2.6_git-20080224.orig/include/linux/sched.h   2008-02-24
01:04:18.000000000 +0100
+++ linux-2.6_git-20080224/include/linux/sched.h        2008-02-24
04:50:18.000000000 +0100
@@ -1007,6 +1007,12 @@
        struct hlist_head preempt_notifiers;
 #endif

+       unsigned long long ctxt_switch_counts; /* 64-bit switches' count */
+       /* ToDo:
+        *  To implement a poller/clock for CPU-scheduler that only reads
+        *   these counts of context switches of the runqueue's tasks.
+        *  No problem if this poller/clock is not implemented. */
+
        /*
         * fpu_counter contains the number of consecutive context switches
         * that the FPU is used. If this is over a threshold, the lazy fpu
diff -ur linux-2.6_git-20080224.orig/kernel/sched.c
linux-2.6_git-20080224/kernel/sched.c
--- linux-2.6_git-20080224.orig/kernel/sched.c  2008-02-24
01:04:19.000000000 +0100
+++ linux-2.6_git-20080224/kernel/sched.c       2008-02-24
04:33:57.000000000 +0100
@@ -2008,6 +2008,8 @@
        BUG_ON(p->state != TASK_RUNNING);
        update_rq_clock(rq);

+       p->ctxt_switch_counts = 0ULL; /* task's 64-bit counter inited 0 */
+
        p->prio = effective_prio(p);

        if (!p->sched_class->task_new || !current->se.on_rq) {
@@ -2189,8 +2191,14 @@
 context_switch(struct rq *rq, struct task_struct *prev,
               struct task_struct *next)
 {
+       unsigned long flags;
+       struct rq *rq_prev;
        struct mm_struct *mm, *oldmm;

+       rq_prev = task_rq_lock(prev, &flags); /* locking the prev task */
+       prev->ctxt_switch_counts++; /* incr.+1 the task's 64-bit counter */
+       task_rq_unlock(rq_prev, &flags); /* unlocking the prev task */
+
        prepare_task_switch(rq, prev, next);
        mm = next->mm;
        oldmm = prev->active_mm;

>  > I will explain your later why of it.
>
>
> ... and explain exactly why the kernel needs this extra code.

One reason: for the objective of gain interactivity, it's an issue that
 CFS fair scheduler lacks it.

    o:)

------=_Part_5372_25562095.1203826126145
Content-Type: application/octet-stream;
 name=linux-2.6_git-20080224_ctxt_switch_counts.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fd12gtrc
Content-Disposition: attachment;
 filename=linux-2.6_git-20080224_ctxt_switch_counts.patch

ZGlmZiAtdXIgbGludXgtMi42X2dpdC0yMDA4MDIyNC5vcmlnL2luY2x1ZGUvbGludXgvc2NoZWQu
aCBsaW51eC0yLjZfZ2l0LTIwMDgwMjI0L2luY2x1ZGUvbGludXgvc2NoZWQuaAotLS0gbGludXgt
Mi42X2dpdC0yMDA4MDIyNC5vcmlnL2luY2x1ZGUvbGludXgvc2NoZWQuaAkyMDA4LTAyLTI0IDAx
OjA0OjE4LjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42X2dpdC0yMDA4MDIyNC9pbmNsdWRl
L2xpbnV4L3NjaGVkLmgJMjAwOC0wMi0yNCAwNDo1MDoxOC4wMDAwMDAwMDAgKzAxMDAKQEAgLTEw
MDcsNiArMTAwNywxMiBAQAogCXN0cnVjdCBobGlzdF9oZWFkIHByZWVtcHRfbm90aWZpZXJzOwog
I2VuZGlmCiAKKwl1bnNpZ25lZCBsb25nIGxvbmcgY3R4dF9zd2l0Y2hfY291bnRzOyAvKiA2NC1i
aXQgc3dpdGNoZXMnIGNvdW50ICovCisJLyogVG9EbzoKKwkgKiAgVG8gaW1wbGVtZW50IGEgcG9s
bGVyL2Nsb2NrIGZvciBDUFUtc2NoZWR1bGVyIHRoYXQgb25seSByZWFkcworCSAqICAgdGhlc2Ug
Y291bnRzIG9mIGNvbnRleHQgc3dpdGNoZXMgb2YgdGhlIHJ1bnF1ZXVlJ3MgdGFza3MuCisJICog
IE5vIHByb2JsZW0gaWYgdGhpcyBwb2xsZXIvY2xvY2sgaXMgbm90IGltcGxlbWVudGVkLiAqLwor
CQogCS8qCiAJICogZnB1X2NvdW50ZXIgY29udGFpbnMgdGhlIG51bWJlciBvZiBjb25zZWN1dGl2
ZSBjb250ZXh0IHN3aXRjaGVzCiAJICogdGhhdCB0aGUgRlBVIGlzIHVzZWQuIElmIHRoaXMgaXMg
b3ZlciBhIHRocmVzaG9sZCwgdGhlIGxhenkgZnB1CmRpZmYgLXVyIGxpbnV4LTIuNl9naXQtMjAw
ODAyMjQub3JpZy9rZXJuZWwvc2NoZWQuYyBsaW51eC0yLjZfZ2l0LTIwMDgwMjI0L2tlcm5lbC9z
Y2hlZC5jCi0tLSBsaW51eC0yLjZfZ2l0LTIwMDgwMjI0Lm9yaWcva2VybmVsL3NjaGVkLmMJMjAw
OC0wMi0yNCAwMTowNDoxOS4wMDAwMDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNl9naXQtMjAwODAy
MjQva2VybmVsL3NjaGVkLmMJMjAwOC0wMi0yNCAwNDozMzo1Ny4wMDAwMDAwMDAgKzAxMDAKQEAg
LTIwMDgsNiArMjAwOCw4IEBACiAJQlVHX09OKHAtPnN0YXRlICE9IFRBU0tfUlVOTklORyk7CiAJ
dXBkYXRlX3JxX2Nsb2NrKHJxKTsKIAorCXAtPmN0eHRfc3dpdGNoX2NvdW50cyA9IDBVTEw7IC8q
IHRhc2sncyA2NC1iaXQgY291bnRlciBpbml0ZWQgMCAqLworCQogCXAtPnByaW8gPSBlZmZlY3Rp
dmVfcHJpbyhwKTsKIAogCWlmICghcC0+c2NoZWRfY2xhc3MtPnRhc2tfbmV3IHx8ICFjdXJyZW50
LT5zZS5vbl9ycSkgewpAQCAtMjE4OSw4ICsyMTkxLDE0IEBACiBjb250ZXh0X3N3aXRjaChzdHJ1
Y3QgcnEgKnJxLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnByZXYsCiAJICAgICAgIHN0cnVjdCB0YXNr
X3N0cnVjdCAqbmV4dCkKIHsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCXN0cnVjdCBycSAqcnFf
cHJldjsKIAlzdHJ1Y3QgbW1fc3RydWN0ICptbSwgKm9sZG1tOwogCisJcnFfcHJldiA9IHRhc2tf
cnFfbG9jayhwcmV2LCAmZmxhZ3MpOyAvKiBsb2NraW5nIHRoZSBwcmV2IHRhc2sgKi8KKwlwcmV2
LT5jdHh0X3N3aXRjaF9jb3VudHMrKzsgLyogaW5jci4rMSB0aGUgdGFzaydzIDY0LWJpdCBjb3Vu
dGVyICovCisJdGFza19ycV91bmxvY2socnFfcHJldiwgJmZsYWdzKTsgLyogdW5sb2NraW5nIHRo
ZSBwcmV2IHRhc2sgKi8KKwkKIAlwcmVwYXJlX3Rhc2tfc3dpdGNoKHJxLCBwcmV2LCBuZXh0KTsK
IAltbSA9IG5leHQtPm1tOwogCW9sZG1tID0gcHJldi0+YWN0aXZlX21tOwo=
------=_Part_5372_25562095.1203826126145--
