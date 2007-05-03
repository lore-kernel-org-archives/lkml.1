Return-Path: <linux-kernel-owner+w=401wt.eu-S1031229AbXECM4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031229AbXECM4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031231AbXECM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:56:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33816 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031229AbXECM4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:56:06 -0400
From: John Keller <jpk@sgi.com>
To: linux-ia64@vger.kernel.org
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, John Keller <jpk@sgi.com>
Date: Thu, 03 May 2007 07:56:02 -0500
Message-Id: <20070503125602.12552.4152.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH] - SN: validate smp_affinity mask on intr redirect
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On SN, only allow one bit to be set in the smp_affinty mask
when redirecting an interrupt. Currently setting multiple
bits is allowed, but only the first bit is used in
determining the CPU to redirect to. This has caused confusion
among some customers.

Signed-off-by: John Keller <jpk@sgi.com>
---

 arch/ia64/kernel/irq.c |   11 +++++++++++
 include/asm-ia64/irq.h |    5 +++++
 include/linux/irq.h    |    4 ++++
 kernel/irq/proc.c      |    3 +++
 4 files changed, 23 insertions(+)


Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c	2007-05-01 15:47:01.656642577 -0500
+++ linux-2.6/kernel/irq/proc.c	2007-05-01 15:48:42.725254306 -0500
@@ -42,6 +42,9 @@ static int irq_affinity_write_proc(struc
 	if (err)
 		return err;
 
+	if (!is_affinity_mask_valid(new_value))
+		return -EINVAL;
+
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
Index: linux-2.6/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq.c	2007-05-01 15:47:01.660643076 -0500
+++ linux-2.6/arch/ia64/kernel/irq.c	2007-05-01 15:48:42.729254805 -0500
@@ -104,6 +104,17 @@ void set_irq_affinity_info (unsigned int
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
+
+int is_affinity_mask_valid(cpumask_t cpumask)
+{
+	if (ia64_platform_is("sn2")) {
+		/* Only allow one CPU to be specified in the smp_affinity mask */
+		if (cpus_weight(cpumask) != 1)
+			return 0;
+	}
+	return 1;
+}
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_HOTPLUG_CPU
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h	2007-05-01 15:47:01.660643076 -0500
+++ linux-2.6/include/linux/irq.h	2007-05-01 15:48:42.729254805 -0500
@@ -228,6 +228,10 @@ static inline void set_pending_irq(unsig
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
+#ifndef ARCH_HAS_IRQ_AFFINITY_VALIDATION
+#define is_irq_affinity_mask_valid(cpumask)         1
+#endif
+
 extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 
Index: linux-2.6/include/asm-ia64/irq.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/irq.h	2007-05-01 15:47:01.660643076 -0500
+++ linux-2.6/include/asm-ia64/irq.h	2007-05-01 15:48:42.729254805 -0500
@@ -11,6 +11,8 @@
  * 02/29/00     D.Mosberger	moved most things into hw_irq.h
  */
 
+#include <linux/cpumask.h>
+
 #define NR_IRQS		256
 #define NR_IRQ_VECTORS	NR_IRQS
 
@@ -30,4 +32,7 @@ extern void disable_irq_nosync (unsigned
 extern void enable_irq (unsigned int);
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
 
+#define ARCH_HAS_IRQ_AFFINITY_VALIDATION
+extern int is_affinity_mask_valid(cpumask_t cpumask);
+
 #endif /* _ASM_IA64_IRQ_H */
