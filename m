Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbYGJSsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbYGJSsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYGJSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:47644 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920AbYGJSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="589105647"
Message-Id: <20080710182237.489115000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:45 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 11/26] x64, x2apic/intr-remap: generic irq migration support from process context
Content-Disposition: inline; filename=irq_migration_from_process_context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic infrastructure for migrating the irq from the process context in the
presence of CONFIG_GENERIC_PENDING_IRQ.

This will be used later for migrating irq in the presence of
interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/include/linux/irq.h
===================================================================
--- tree-x86.orig/include/linux/irq.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/linux/irq.h	2008-07-10 09:52:07.000000000 -0700
@@ -62,6 +62,7 @@
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
+#define IRQ_MOVE_PCNTXT	0x01000000	/* IRQ migration from process context */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: tree-x86/kernel/irq/manage.c
===================================================================
--- tree-x86.orig/kernel/irq/manage.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/kernel/irq/manage.c	2008-07-10 09:52:07.000000000 -0700
@@ -89,7 +89,14 @@
 	set_balance_irq_affinity(irq, cpumask);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	set_pending_irq(irq, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&desc->lock, flags);
+		desc->chip->set_affinity(irq, cpumask);
+		spin_unlock_irqrestore(&desc->lock, flags);
+	} else
+		set_pending_irq(irq, cpumask);
 #else
 	desc->affinity = cpumask;
 	desc->chip->set_affinity(irq, cpumask);

-- 

