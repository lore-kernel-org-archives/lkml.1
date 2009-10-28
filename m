Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZJ1PQw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 28 Oct 2009 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZJ1PQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:16:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36322 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbZJ1PQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:16:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: cleanup: balance rcu_irq_enter()/rcu_irq_exit() calls
Date: Wed, 28 Oct 2009 08:14:48 -0700
Message-Id: <12567428891605-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091028151419.GA7838@linux.vnet.ibm.com>
References: <20091028151419.GA7838@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Currently, rcu_irq_exit() is invoked only for CONFIG_NO_HZ, while
rcu_irq_enter() is invoked unconditionally.  This patch moves
rcu_irq_exit() out from under CONFIG_NO_HZ so that the calls are
balanced.

This patch has no effect on the behavior of the kernel because
both rcu_irq_enter() and rcu_irq_exit() are empty for !CONFIG_NO_HZ,
but the code is easier to understand if the calls are obviously
balanced in all cases.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.5.2.5

