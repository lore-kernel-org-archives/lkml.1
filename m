Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbZJFPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbZJFPT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbZJFPTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:19:55 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:56716 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757795AbZJFPTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:19:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAD75ykpMROOX/2dsb2JhbACBUdF6hCoE
Date: Tue, 6 Oct 2009 11:19:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 1/4] kernel call_rcu usage: initialize rcu_head
	structures (v2)
Message-ID: <20091006151914.GB12530@Krystal>
References: <20091006143727.868480435@polymtl.ca> <20091006144035.668169139@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091006144035.668169139@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:17:57 up 49 days,  2:07,  2 users,  load average: 0.06, 0.25,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu_head structures before passing them to call_rcu() to eliminate
false positives in DEBUG_RCU_HEAD.

Update: init at structure allocation time rather than just before
calling call_rcu(). Ensures we do not void the debug race test.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: akpm@linux-foundation.org
---
 kernel/fork.c     |    1 +
 kernel/pid.c      |    1 +
 kernel/rcupdate.c |    1 +
 3 files changed, 3 insertions(+)

Index: linux-2.6-lttng/kernel/rcupdate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcupdate.c	2009-10-06 10:34:25.000000000 -0400
+++ linux-2.6-lttng/kernel/rcupdate.c	2009-10-06 11:17:16.000000000 -0400
@@ -90,6 +90,7 @@ void synchronize_rcu(void)
 	if (rcu_blocking_is_gp())
 		return;
 
+	INIT_RCU_HEAD(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
Index: linux-2.6-lttng/kernel/pid.c
===================================================================
--- linux-2.6-lttng.orig/kernel/pid.c	2009-10-06 10:34:25.000000000 -0400
+++ linux-2.6-lttng/kernel/pid.c	2009-10-06 11:12:46.000000000 -0400
@@ -264,6 +264,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	get_pid_ns(ns);
 	pid->level = ns->level;
+	INIT_RCU_HEAD(&pid->rcu);
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2009-10-06 11:11:10.000000000 -0400
+++ linux-2.6-lttng/kernel/fork.c	2009-10-06 11:11:54.000000000 -0400
@@ -1012,6 +1012,7 @@ static struct task_struct *copy_process(
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_flipctr_idx = 0;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
+	INIT_RCU_HEAD(&p->rcu);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
