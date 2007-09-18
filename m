Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbXIRTgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbXIRTgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXIRTgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:36:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18741 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXIRTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=atX6sUvq/+HUaZOLoAybxZZ+ulc8e3+J3QiuehOP43FENI8XiHJCsnWs8B/rQWrEQwZl6nMu5hC1vgWN2WHYvkQV0mOOgAmVdt8/Ib/vaw9BE7Hl0PXtVeeBx+F0uPuRJdLFyX4ld6AyyZaUcNFX80k+Dkj8ihCUHSpvYAnQFAk=
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: dimm <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 21:36:30 +0200
Message-Id: <1190144190.5204.24.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ well, don't expect to find here anything like RDCFS
(no, 'D' does not stand for 'dumb'!). I was focused
on more prosaic things in the mean time so just
didn't have time for writing it.. ]

here is a few cleanup/simplification/optimization(s)
based on the recent modifications in the sched-dev tree.

(1) optimize task_new_fair()
(2) simplify yield_task()
(3) rework enqueue/dequeue_entity() to get rid of
sched_class::set_curr_task()

additionally, the changes somewhat decrease code size:

   text    data     bss     dec     hex filename
  43538    5398      48   48984    bf58 build/kernel/sched.o.before
  43250    5390      48   48688    be30 build/kernel/sched.o

(SMP + lots of debugging options but, I guess, in this case the diff
should remain visible for any combination).

---

(1)

due to the fact that we no longer keep the 'current' within the tree,
dequeue/enqueue_entity() is useless for the 'current' in task_new_fair().
We are about to reschedule and sched_class->put_prev_task() will put
the 'current' back into the tree, based on its new key.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6e52d5a..5a244e2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -969,10 +969,11 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 
 	if (sysctl_sched_child_runs_first &&
 			curr->vruntime < se->vruntime) {
-
-		dequeue_entity(cfs_rq, curr, 0);
+		/*
+ 		 * Upon rescheduling, sched_class::put_prev_task() will place
+ 		 * 'current' within the tree based on its new key value.
+ 		 */
 		swap(curr->vruntime, se->vruntime);
-		enqueue_entity(cfs_rq, curr, 0);
 	}
 
 	update_stats_enqueue(cfs_rq, se);

---

Dmitry



