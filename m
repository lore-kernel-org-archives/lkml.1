Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZECVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZECVQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZECVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:16:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZECVQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:16:03 -0400
Date: Sun, 3 May 2009 23:11:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rcu_sched_grace_period: kill the bogus flush_signals()
Message-ID: <20090503211118.GA22973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a kernel thread, rcu_sched_grace_period() runs with all signals ignored.
It can never receive a signal even if it sleeps in TASK_INTERRUPTIBLE, it
needs the explicit allow_signal() to be visible for signals.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/rcupreempt.c~	2009-04-09 00:39:10.000000000 +0200
+++ PTRACE/kernel/rcupreempt.c	2009-05-03 02:17:11.000000000 +0200
@@ -1356,17 +1356,11 @@ static int rcu_sched_grace_period(void *
 
 		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
 		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		ret = 0;
+		ret = 0; /* unused */
 		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
 			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
 			ret);
 
-		/*
-		 * Signals would prevent us from sleeping, and we cannot
-		 * do much with them in any case.  So flush them.
-		 */
-		if (ret)
-			flush_signals(current);
 		couldsleepnext = 0;
 
 	} while (!kthread_should_stop());

