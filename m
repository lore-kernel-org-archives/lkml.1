Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbZKBQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbZKBQTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbZKBQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:19:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:53736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbZKBQTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:19:15 -0500
Date: Mon, 2 Nov 2009 16:18:29 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <12567428891605-git-send-email->
References: <12567428891605-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Cleanup: balance rcu_irq_enter()/rcu_irq_exit() calls
Message-ID: <tip-c5e0cb3ddc5f14cedcfc50c0fb3b5fc6b56576da@git.kernel.org>
Git-Commit-ID: c5e0cb3ddc5f14cedcfc50c0fb3b5fc6b56576da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5e0cb3ddc5f14cedcfc50c0fb3b5fc6b56576da
Gitweb:     http://git.kernel.org/tip/c5e0cb3ddc5f14cedcfc50c0fb3b5fc6b56576da
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 28 Oct 2009 08:14:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 16:06:37 +0100

rcu: Cleanup: balance rcu_irq_enter()/rcu_irq_exit() calls

Currently, rcu_irq_exit() is invoked only for CONFIG_NO_HZ,
while rcu_irq_enter() is invoked unconditionally.  This patch
moves rcu_irq_exit() out from under CONFIG_NO_HZ so that the
calls are balanced.

This patch has no effect on the behavior of the kernel because
both rcu_irq_enter() and rcu_irq_exit() are empty for
!CONFIG_NO_HZ, but the code is easier to understand if the calls
are obviously balanced in all cases.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12567428891605-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f8749e5..21939d9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -302,9 +302,9 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	rcu_irq_exit();
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
 		tick_nohz_stop_sched_tick(0);
 #endif
