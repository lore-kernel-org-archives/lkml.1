Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbZJFOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbZJFOl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbZJFOl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:41:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38669 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbZJFOl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:41:58 -0400
Message-Id: <20091006144035.668169139@polymtl.ca>
References: <20091006143727.868480435@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 10:37:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/4] kernel call_rcu usage: initialize rcu_head structures
Content-Disposition: inline; filename=rcu-init-null.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  6 Oct 2009 14:40:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize rcu_head structures before passing them to call_rcu() to eliminate
false positives in DEBUG_RCU_HEAD.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: akpm@linux-foundation.org
---
 kernel/exit.c     |    1 +
 kernel/pid.c      |    1 +
 kernel/rcupdate.c |    1 +
 3 files changed, 3 insertions(+)

Index: linux-2.6-lttng/kernel/rcupdate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcupdate.c	2009-10-06 09:00:06.000000000 -0400
+++ linux-2.6-lttng/kernel/rcupdate.c	2009-10-06 09:01:14.000000000 -0400
@@ -92,6 +92,7 @@ void synchronize_rcu(void)
 
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
+	INIT_RCU_HEAD(&rcu.head);
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
Index: linux-2.6-lttng/kernel/exit.c
===================================================================
--- linux-2.6-lttng.orig/kernel/exit.c	2009-10-06 09:05:21.000000000 -0400
+++ linux-2.6-lttng/kernel/exit.c	2009-10-06 09:05:34.000000000 -0400
@@ -208,6 +208,7 @@ repeat:
 
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
+	INIT_RCU_HEAD(&p->rcu);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
 	p = leader;
Index: linux-2.6-lttng/kernel/pid.c
===================================================================
--- linux-2.6-lttng.orig/kernel/pid.c	2009-10-06 09:10:59.000000000 -0400
+++ linux-2.6-lttng/kernel/pid.c	2009-10-06 09:11:43.000000000 -0400
@@ -236,6 +236,7 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++)
 		free_pidmap(pid->numbers + i);
 
+	INIT_RCU_HEAD(&pid->rcu);
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
