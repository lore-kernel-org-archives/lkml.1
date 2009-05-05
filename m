Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZEEShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZEEShE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZEESgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:36:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459AbZEESgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:36:21 -0400
Date: Tue, 5 May 2009 18:35:07 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu
In-Reply-To: <20090503211118.GA22973@redhat.com>
References: <20090503211118.GA22973@redhat.com>
Subject: [tip:core/rcu] rcu: rcu_sched_grace_period(): kill the bogus flush_signals()
Message-ID: <tip-41c51c98f588edcdf6141cff1895df738e03ddd4@git.kernel.org>
Git-Commit-ID: 41c51c98f588edcdf6141cff1895df738e03ddd4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:35:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41c51c98f588edcdf6141cff1895df738e03ddd4
Gitweb:     http://git.kernel.org/tip/41c51c98f588edcdf6141cff1895df738e03ddd4
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 3 May 2009 23:11:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:28:05 +0200

rcu: rcu_sched_grace_period(): kill the bogus flush_signals()

As a kernel thread, rcu_sched_grace_period() runs with all signals ignored.
It can never receive a signal even if it sleeps in TASK_INTERRUPTIBLE, it
needs the explicit allow_signal() to be visible for signals.

[ Impact: reduce kernel size, remove dead code ]

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090503211118.GA22973@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupreempt.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ce97a4d..beb0e65 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1356,17 +1356,11 @@ static int rcu_sched_grace_period(void *arg)
 
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
