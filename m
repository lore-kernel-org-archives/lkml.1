Return-Path: <linux-kernel-owner+w=401wt.eu-S1764075AbXGQKKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764075AbXGQKKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXGQKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:10:00 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:38405 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbXGQKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:10:00 -0400
Subject: [PATCH RFC] Debug handling of early spurious interrupts
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 17 Jul 2007 19:09:57 +0900
Message-Id: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the advent of kdump it is possible that device drivers receive
interrupts generated in the context of a previous kernel. Ideally
quiescing the underlying devices should suffice but not all drivers
do this, either because it is not possible or because they did not
contemplate this case. Thus drivers ought to be able to handle
interrupts coming in as soon as the interrupt handler is registered.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22/kernel/irq/manage.c
--- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/kernel/irq/manage.c	2007-07-17 18:37:24.000000000 +0900
@@ -537,6 +537,29 @@ int request_irq(unsigned int irq, irq_ha
 
 	select_smp_affinity(irq);
 
+#if defined(CONFIG_DEBUG_PENDING_IRQ) || defined(CONFIG_DEBUG_SHIRQ)
+#ifndef CONFIG_DEBUG_PENDING_IRQ
+	if (irqflags & IRQF_SHARED) {
+		/*
+		 * It's a shared IRQ -- the driver ought to be prepared for it
+		 * to happen immediately, so let's make sure....
+		 * We do this before actually registering it, to make sure that
+		 * a 'real' IRQ doesn't run in parallel with our fake.
+		 */
+#endif /* !CONFIG_DEBUG_PENDING_IRQ */
+		if (irqflags & IRQF_DISABLED) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			handler(irq, dev_id);
+			local_irq_restore(flags);
+		} else
+			handler(irq, dev_id);
+#ifndef CONFIG_DEBUG_PENDING_IRQ
+	}
+#endif /* !CONFIG_DEBUG_PENDING_IRQ */
+#endif /* CONFIG_DEBUG_PENDING_IRQ || CONFIG_DEBUG_SHIRQ */
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
diff -urNp linux-2.6.22-orig/lib/Kconfig.debug linux-2.6.22/lib/Kconfig.debug
--- linux-2.6.22-orig/lib/Kconfig.debug	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/lib/Kconfig.debug	2007-07-17 18:52:00.000000000 +0900
@@ -77,6 +77,17 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config DEBUG_PENDING_IRQ
+	bool "Debug handling of early spurious interrupts"
+	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	help
+	  With the advent of kdump it is possible that device drivers receive
+	  interrupts generated in the context of a previous kernel. Ideally
+	  quiescing the underlying devices should suffice but not all drivers
+	  do this, either because it is not possible or because they did not
+	  contemplate this case. Thus drivers ought to be able to handle
+	  interrupts coming in as soon as the interrupt handler is registered.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL && GENERIC_HARDIRQS


