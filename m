Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZLJBzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZLJBzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbZLJBzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:55:09 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36471 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205AbZLJBzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ZJjzTMbSSU1LUROMl554+IwHL7F8ZpuB1/h0PExfSjJ6Ix1ETq9kGjm2sOwofk11Si
         LuczT5Tob9QjvcblLjfrQOy4XItuIv6Z4XjeCYAC+FRcQ+RqVeOvRnSpwjVbT43sfsLJ
         Ga8rhSq+mkkiCE6ioifivnJQgK2dCcJGIlGHs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sched: Fix rq lock use through wrong spinlock api
Date: Thu, 10 Dec 2009 02:55:10 +0100
Message-Id: <1260410110-15267-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rq lock is a raw spinlock, it needs to be manipulated
using appropriate helpers.

This fixes the following warning:

kernel/sched_fair.c: In function ‘task_fork_fair’:
kernel/sched_fair.c:1958: attention : passing argument 1 of ‘spinlock_check’ from incompatible pointer type
kernel/sched_fair.c:1978: attention : passing argument 1 of ‘spin_unlock_irqrestore’ from incompatible pointer type

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 804a411..5bedf6e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1955,7 +1955,7 @@ static void task_fork_fair(struct task_struct *p)
 	struct rq *rq = this_rq();
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
@@ -1975,7 +1975,7 @@ static void task_fork_fair(struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
-	spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
-- 
1.6.2.3

