Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYENIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYENIOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761201AbYENIOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:14:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:12364 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164AbYENIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=UFpdO1kl3Nv2y/oTt6DD+/AvLGyohfyP4fElej7LMOJhidW2boSc9cRvNRkz6RBedHC14agtTtPHblvunMROgZD5WKBG/IMBCeKd2ndK3AI2U6uMMkm5K55NThyzE4tHWa8rmTTgI+xmSWlhdLWHCfJv0fZ1hOW/hlOBf0QrgIY=
Message-ID: <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
Date: Wed, 14 May 2008 10:13:55 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [BUG] cpu hotplug vs scheduler
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>
In-Reply-To: <4829A6A0.5040208@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12159_33231502.1210752835517"
References: <4829A6A0.5040208@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12159_33231502.1210752835517
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

> [ ... ]
>
>  [4298303.713901] Call Trace:
>  [4298303.713901]  [<ffffffff804373fe>] schedule+0x414/0x6ab
>  [4298303.713901]  [<ffffffff8023060a>] ? hrtick_set+0x9d/0xe8
>  [4298303.713901]  [<ffffffff8043772f>] ? thread_return+0x9a/0xbf
>  [4298303.713901]  [<ffffffff80231652>] migration_thread+0x185/0x22d
>  [4298303.713901]  [<ffffffff802314cd>] ? migration_thread+0x0/0x22d
>  [4298303.713901]  [<ffffffff8024afe6>] kthread+0x49/0x77
>  [4298303.713901]  [<ffffffff8020d228>] child_rip+0xa/0x12
>  [4298303.713901]  [<ffffffff8024af9d>] ? kthread+0x0/0x77
>  [4298303.713901]  [<ffffffff8020d21e>] ? child_rip+0x0/0x12
>  [4298303.713901]
>  [4298303.713901]
>  [4298303.713901] Code: c0 74 28 48 8b 7b 58 4c 8d 60 f0 48 85 ff 74 10 4c
> 89 e6 e8 df cc ff ff 85 c0 75 04 4c 8b 63 58 4c 89 e6 48 89 df e8 4a e5 ff
> ff <49> 8b 9c 24 58 01 00 00 48 85 db 75 bf 49 83 ec 38 4c 89 ef 4c
>  [4298303.713901] RIP  [<ffffffff8022e722>] pick_next_task_fair+0x55/0x7c
>
>  This seems to be the assignment to cfs_rq after pick_next_entity().

[ cc'ed a few folks. ]


So the cfs-tree likely gets out-of-sync. I pressume, it won't be
reproducible with CONFIG_SCHED_GROUP options being disabled.

Anyway, would you try one of these debug-patches (not sure about the
workability of the second one though :-/)

Let's check what are the values for 'cfs_rq->weight.load/nr_running'.

thanks in advance,

(non-whitespace-damaged versions are enclosed)

---
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1291,6 +1291,12 @@ static struct task_struct
*pick_next_task_fair(struct rq *rq)

        do {
                se = pick_next_entity(cfs_rq);
+
+               if (unlikely(!se))
+                       printk(KERN_ERR "BUG: se == NULL but
nr_running (%ld), load (%ld),"
+                                       " rq-nr_running (%ld), rq-load (%ld)\n",
+                               cfs_rq->nr_running,
cfs_rq->load.weight, rq->nr_running, rq->load.weight);
+
                cfs_rq = group_cfs_rq(se);
        } while (cfs_rq);


---

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1280,6 +1280,8 @@ static void check_preempt_wakeup(struct rq *rq,
struct task_str uct *p)
                resched_task(curr);
 }

+static void sysrq_sched_debug_show(void);
+
 static struct task_struct *pick_next_task_fair(struct rq *rq)
 {
        struct task_struct *p;
@@ -1291,6 +1293,10 @@ static struct task_struct
*pick_next_task_fair(struct rq *rq)

        do {
                se = pick_next_entity(cfs_rq);
+
+               if (unlikely(!se))
+                       sysrq_sched_debug_show();
+
                cfs_rq = group_cfs_rq(se);
        } while (cfs_rq);


---

-- 
Best regards,
Dmitry Adamushko

------=_Part_12159_33231502.1210752835517
Content-Type: text/x-patch; name=cfs_rq-debug-2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fg7mxgei0
Content-Disposition: attachment; filename=cfs_rq-debug-2.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9mYWlyLmMgYi9rZXJuZWwvc2NoZWRfZmFpci5jCmlu
ZGV4IGUyNGVjZDMuLjFkY2M0NzAgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zY2hlZF9mYWlyLmMKKysr
IGIva2VybmVsL3NjaGVkX2ZhaXIuYwpAQCAtMTI4MCw2ICsxMjgwLDggQEAgc3RhdGljIHZvaWQg
Y2hlY2tfcHJlZW1wdF93YWtldXAoc3RydWN0IHJxICpycSwgc3RydWN0IHRhc2tfc3RydWN0ICpw
KQogCQlyZXNjaGVkX3Rhc2soY3Vycik7CiB9CiAKK3N0YXRpYyB2b2lkIHN5c3JxX3NjaGVkX2Rl
YnVnX3Nob3codm9pZCk7CisKIHN0YXRpYyBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnBpY2tfbmV4dF90
YXNrX2ZhaXIoc3RydWN0IHJxICpycSkKIHsKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnA7CkBAIC0x
MjkxLDYgKzEyOTMsMTAgQEAgc3RhdGljIHN0cnVjdCB0YXNrX3N0cnVjdCAqcGlja19uZXh0X3Rh
c2tfZmFpcihzdHJ1Y3QgcnEgKnJxKQogCiAJZG8gewogCQlzZSA9IHBpY2tfbmV4dF9lbnRpdHko
Y2ZzX3JxKTsKKworCQlpZiAodW5saWtlbHkoIXNlKSkKKwkJCXN5c3JxX3NjaGVkX2RlYnVnX3No
b3coKTsKKwogCQljZnNfcnEgPSBncm91cF9jZnNfcnEoc2UpOwogCX0gd2hpbGUgKGNmc19ycSk7
CiAK
------=_Part_12159_33231502.1210752835517
Content-Type: text/x-patch; name=cfs_rq-debug-3.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fg7mxsm31
Content-Disposition: attachment; filename=cfs_rq-debug-3.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9mYWlyLmMgYi9rZXJuZWwvc2NoZWRfZmFpci5jCmlu
ZGV4IGUyNGVjZDMuLmUyMWUwMjAgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zY2hlZF9mYWlyLmMKKysr
IGIva2VybmVsL3NjaGVkX2ZhaXIuYwpAQCAtMTI5MSw2ICsxMjkxLDEyIEBAIHN0YXRpYyBzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnBpY2tfbmV4dF90YXNrX2ZhaXIoc3RydWN0IHJxICpycSkKIAogCWRv
IHsKIAkJc2UgPSBwaWNrX25leHRfZW50aXR5KGNmc19ycSk7CisKKwkJaWYgKHVubGlrZWx5KCFz
ZSkpCisJCQlwcmludGsoS0VSTl9FUlIgIkJVRzogc2UgPT0gTlVMTCBidXQgbnJfcnVubmluZyAo
JWxkKSwgbG9hZCAoJWxkKSwiCisJCQkJCSIgcnEtbnJfcnVubmluZyAoJWxkKSwgcnEtbG9hZCAo
JWxkKVxuIiwKKwkJCQljZnNfcnEtPm5yX3J1bm5pbmcsIGNmc19ycS0+bG9hZC53ZWlnaHQsIHJx
LT5ucl9ydW5uaW5nLCBycS0+bG9hZC53ZWlnaHQpOworCiAJCWNmc19ycSA9IGdyb3VwX2Nmc19y
cShzZSk7CiAJfSB3aGlsZSAoY2ZzX3JxKTsKIAo=
------=_Part_12159_33231502.1210752835517--
