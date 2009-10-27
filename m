Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZJ0IAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZJ0IAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZJ0IAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:00:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbZJ0IAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:00:31 -0400
Message-ID: <4AE6A88B.8000004@cn.fujitsu.com>
Date: Tue, 27 Oct 2009 16:00:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sofirq: make rcu_irq_enter()/rcu_irq_exit() called in pairs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


irq_enter() calls rcu_irq_enter() unconditionally,
the same as irq_exit() calls rcu_irq_exit().

It does not change the binary because rcu_irq_enter()
is dummy when !CONFIG_NO_HZ.

It's just a cleanup.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
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

