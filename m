Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbXJJMQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbXJJMQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXJJMQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:16:24 -0400
Received: from saeurebad.de ([85.214.36.134]:58102 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbXJJMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:16:23 -0400
Date: Wed, 10 Oct 2007 14:16:19 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] __do_softirq() loop cleanup
Message-ID: <20071010121619.GA32677@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This changes __do_softirq() to use a C looping construct instead of
simulating one by means of goto.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0f546dd..bacee6b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -212,38 +212,37 @@ asmlinkage void __do_softirq(void)
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
 
-	pending = local_softirq_pending();
 	account_system_vtime(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
 	trace_softirq_enter();
 
 	cpu = smp_processor_id();
-restart:
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
 
-	local_irq_enable();
+	while ((pending = local_softirq_pending())) {
+		if (!max_restart--) {
+			wakeup_softirqd();
+			break;
+		}
 
-	h = softirq_vec;
+		/* Reset the pending bitmask before enabling irqs */
+		set_softirq_pending(0);
 
-	do {
-		if (pending & 1) {
-			h->action(h);
-			rcu_bh_qsctr_inc(cpu);
-		}
-		h++;
-		pending >>= 1;
-	} while (pending);
+		local_irq_enable();
 
-	local_irq_disable();
+		h = softirq_vec;
 
-	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+		do {
+			if (pending & 1) {
+				h->action(h);
+				rcu_bh_qsctr_inc(cpu);
+			}
+			h++;
+			pending >>= 1;
+		} while (pending);
 
-	if (pending)
-		wakeup_softirqd();
+		local_irq_disable();
+	}
 
 	trace_softirq_exit();
