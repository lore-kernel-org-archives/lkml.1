Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZKPFdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZKPFdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZKPFdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:33:54 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:47835 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZKPFdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mJAMhUJ6nRc3q3Q0LGBuMrK0+vSx3HumkhGXIPDf+0yyZq4t2Al/ZeYHrxJv4X/5PM
         rHAq41mEzvCQygrwKYmmpg4rMoIZFcSUzjBIK6nyD7QnSE1m+Mh6fnpzXdiu/xY92OmZ
         s7HkUndT5WKqfAw1m/+XS3+QBAzxgfzuXM2Ys=
From: Jupyung Lee <jupyung@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jupyung Lee <jupyung@gmail.com>
Subject: [PATCH -rt 1/1] sched_rt: change spinlock primitive in post_schedule_rt()
Date: Mon, 16 Nov 2009 14:33:39 +0900
Message-Id: <1258349619-7267-1-git-send-email-jupyung@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function post_schedule_rt() of the current preempt-rt kernel,
push_rt_task() is surrounded by atomic_spin_lock_irq(&rq->lock) and
atomic_spin_unlock_irq(&rq->lock), which means that the function is
called with the runqueue lock held and the interrupt disabled.

A problem is that after finishing post_schedule_rt(), interrupt is always
re-enabled regardless of the previous condition. In practice, the function
post_schedule_rt() is called by finish_task_switch() with the interrupt disabled.
Thus, the interrupt should not be re-enabled at the moment.

The problem can simply be resolved by replacing atomic_spin_lock_irq() and
atomic_spin_unlock_irq() with atomic_spin_lock_irqsave() and
atomic_spin_unlock_irqrestore().

As a sidenote, the other way to resolve the problem might be to modify codes
in accordance with commit 3f029d3c6d62068d59301d90c18dbde8ee402107, titled
"sched: Enhance the pre/post scheduling logic", in the vanilla tree.

Signed-off-by: Jupyung Lee <jupyung@gmail.com>
---
 kernel/sched_rt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 274c976..bd16998 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1536,9 +1536,10 @@ static void post_schedule_rt(struct rq *rq)
 	 * This is only called if needs_post_schedule_rt() indicates that
 	 * we need to push tasks away
 	 */
-	atomic_spin_lock_irq(&rq->lock);
+	unsigned long flags;
+	atomic_spin_lock_irqsave(&rq->lock, flags);
 	push_rt_tasks(rq);
-	atomic_spin_unlock_irq(&rq->lock);
+	atomic_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
-- 
1.6.5.GIT

