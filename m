Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbYENNF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbYENNF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYENNFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:05:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:3993 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYENNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=dhZMpo/H/Fm3d4DUW+Anxtoy/8vm82l8AYaca+OuS/oQmtWS6IvboJ0vsCJJYvOelBooIF5N9pntLLcmBRyLXaMO+y84S1XhsARIohFlWixvVg62aj5mlInJdGk+KXsMdU7qTdjmW7ifbtmq0qPpkSbFx4VYzu+8cFdZt+tBKfk=
Message-ID: <b647ffbd0805140605j5ed43b73t557983ece879c552@mail.gmail.com>
Date: Wed, 14 May 2008 15:05:45 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [BUG] cpu hotplug vs scheduler
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>
In-Reply-To: <482ADB69.8010305@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_30_16923690.1210770345621"
References: <4829A6A0.5040208@qumranet.com>
	 <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
	 <482ADB69.8010305@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_30_16923690.1210770345621
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/5/14 Avi Kivity <avi@qumranet.com>:

> [ ... ]
>
>  [4302727.900184] Call Trace:
>  [4302727.900184]  [<ffffffff803249de>] spin_bug+0x9e/0xe9
>  [4302727.900184]  [<ffffffff80324af4>] _raw_spin_lock+0x41/0x123
>  [4302727.900184]  [<ffffffff80439638>] _spin_lock_irqsave+0x2f/0x37
>  [4302727.900184]  [<ffffffff8022ef7c>] print_cfs_rq+0xca/0x46a
>  [4302727.900184]  [<ffffffff80231f97>] sched_debug_show+0x7a3/0xb8c
>  [4302727.900184]  [<ffffffff8023238d>] sysrq_sched_debug_show+0xd/0xf
>  [4302727.900184]  [<ffffffff802323ee>] pick_next_task_fair+0x5f/0x86


Err... sorry for the broken patch. The patch below on top of the
previous one should address this issue (ugly, but should be ok for
debugging).
'tasklist_lock' shouldn't cause a double lock, I guess.

Sorry for rather 'blind' attempts. If no, then I'll
prepare/test/take-a-closer-look at it later today when I'm at home.

TIA,


------ kernel/sched_debug-prev.c   2008-05-14 14:53:28.000000000 +0200
+++ kernel/sched_debug.c        2008-05-14 14:58:12.000000000 +0200
@@ -125,6 +125,7 @@ void print_cfs_rq(struct seq_file *m, in
        char path[128] = "";
        struct cgroup *cgroup = NULL;
        struct task_group *tg = cfs_rq->tg;
+       int was_locked;

        if (tg)
                cgroup = tg->css.cgroup;
@@ -138,7 +139,11 @@ void print_cfs_rq(struct seq_file *m, in
        SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
                        SPLIT_NS(cfs_rq->exec_clock));

-       spin_lock_irqsave(&rq->lock, flags);
+       was_locked = spin_is_locked(&rq->lock);
+
+       if (!was_locked)
+               spin_lock_irqsave(&rq->lock, flags);
+
        if (cfs_rq->rb_leftmost)
                MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
        last = __pick_last_entity(cfs_rq);
@@ -146,7 +151,10 @@ void print_cfs_rq(struct seq_file *m, in
                max_vruntime = last->vruntime;
        min_vruntime = rq->cfs.min_vruntime;
        rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
-       spin_unlock_irqrestore(&rq->lock, flags);
+
+       if (!was_locked)
+               spin_unlock_irqrestore(&rq->lock, flags);
+
        SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
                        SPLIT_NS(MIN_vruntime));
        SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",

---


-- 
Best regards,
Dmitry Adamushko

------=_Part_30_16923690.1210770345621
Content-Type: text/x-patch; name=is_locked.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fg7x8fps0
Content-Disposition: attachment; filename=is_locked.diff

LS0tIGtlcm5lbC9zY2hlZF9kZWJ1Zy1wcmV2LmMJMjAwOC0wNS0xNCAxNDo1MzoyOC4wMDAwMDAw
MDAgKzAyMDAKKysrIGtlcm5lbC9zY2hlZF9kZWJ1Zy5jCTIwMDgtMDUtMTQgMTQ6NTg6MTIuMDAw
MDAwMDAwICswMjAwCkBAIC0xMjUsNiArMTI1LDcgQEAgdm9pZCBwcmludF9jZnNfcnEoc3RydWN0
IHNlcV9maWxlICptLCBpbgogCWNoYXIgcGF0aFsxMjhdID0gIiI7CiAJc3RydWN0IGNncm91cCAq
Y2dyb3VwID0gTlVMTDsKIAlzdHJ1Y3QgdGFza19ncm91cCAqdGcgPSBjZnNfcnEtPnRnOworCWlu
dCB3YXNfbG9ja2VkOwogCiAJaWYgKHRnKQogCQljZ3JvdXAgPSB0Zy0+Y3NzLmNncm91cDsKQEAg
LTEzOCw3ICsxMzksMTEgQEAgdm9pZCBwcmludF9jZnNfcnEoc3RydWN0IHNlcV9maWxlICptLCBp
bgogCVNFUV9wcmludGYobSwgIiAgLiUtMzBzOiAlTGQuJTA2bGRcbiIsICJleGVjX2Nsb2NrIiwK
IAkJCVNQTElUX05TKGNmc19ycS0+ZXhlY19jbG9jaykpOwogCi0Jc3Bpbl9sb2NrX2lycXNhdmUo
JnJxLT5sb2NrLCBmbGFncyk7CisJd2FzX2xvY2tlZCA9IHNwaW5faXNfbG9ja2VkKCZycS0+bG9j
ayk7CisKKwlpZiAoIXdhc19sb2NrZWQpCisJCXNwaW5fbG9ja19pcnFzYXZlKCZycS0+bG9jaywg
ZmxhZ3MpOworCQogCWlmIChjZnNfcnEtPnJiX2xlZnRtb3N0KQogCQlNSU5fdnJ1bnRpbWUgPSAo
X19waWNrX25leHRfZW50aXR5KGNmc19ycSkpLT52cnVudGltZTsKIAlsYXN0ID0gX19waWNrX2xh
c3RfZW50aXR5KGNmc19ycSk7CkBAIC0xNDYsNyArMTUxLDEwIEBAIHZvaWQgcHJpbnRfY2ZzX3Jx
KHN0cnVjdCBzZXFfZmlsZSAqbSwgaW4KIAkJbWF4X3ZydW50aW1lID0gbGFzdC0+dnJ1bnRpbWU7
CiAJbWluX3ZydW50aW1lID0gcnEtPmNmcy5taW5fdnJ1bnRpbWU7CiAJcnEwX21pbl92cnVudGlt
ZSA9IHBlcl9jcHUocnVucXVldWVzLCAwKS5jZnMubWluX3ZydW50aW1lOwotCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJnJxLT5sb2NrLCBmbGFncyk7CisKKwlpZiAoIXdhc19sb2NrZWQpCisJCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJnJxLT5sb2NrLCBmbGFncyk7CisKIAlTRVFfcHJpbnRmKG0s
ICIgIC4lLTMwczogJUxkLiUwNmxkXG4iLCAiTUlOX3ZydW50aW1lIiwKIAkJCVNQTElUX05TKE1J
Tl92cnVudGltZSkpOwogCVNFUV9wcmludGYobSwgIiAgLiUtMzBzOiAlTGQuJTA2bGRcbiIsICJt
aW5fdnJ1bnRpbWUiLAo=
------=_Part_30_16923690.1210770345621--
