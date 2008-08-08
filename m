Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYHHSP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYHHSP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYHHSPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:15:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:56034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYHHSPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:15:47 -0400
Subject: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	 <1206382547.6437.131.camel@lappy>
	 <20080324115738.85c72bb5.akpm@linux-foundation.org>
	 <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	 <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 20:14:28 +0200
Message-Id: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid deadlocks against rq->lock and xtime_lock by using RCU to defer
the klogd wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <srostedt@redhat.com>
---
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..8870c2e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 
@@ -982,10 +983,37 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+struct klogd_wakeup_state {
+	struct rcu_head head;
+	int pending;
+};
+
+DEFINE_PER_CPU(struct klogd_wakeup_state, kws);
+
+void __wake_up_klogd(struct rcu_head *head)
+{
+	struct klogd_wakeup_state *kws = 
+		container_of(head, struct klogd_wakeup_state, head);
+
+	wake_up_interruptible(&log_wait);
+	kws->pending = 0;
+}
+
 void wake_up_klogd(void)
 {
-	if (!oops_in_progress && waitqueue_active(&log_wait))
-		wake_up_interruptible(&log_wait);
+	unsigned long flags;
+	struct klogd_wakeup_state *kws;
+
+	if (!waitqueue_active(&log_wait))
+		return;
+
+	local_irq_save(flags);
+	kws = &__get_cpu_var(kws);
+	if (!kws->pending) {
+		kws->pending = 1;
+		call_rcu(&kws->head, __wake_up_klogd);
+	}
+	local_irq_restore(flags);
 }
 
 /**


