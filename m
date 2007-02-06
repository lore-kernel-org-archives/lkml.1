Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbXBFR0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbXBFR0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXBFR0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:26:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:25571 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbXBFR0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:26:49 -0500
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: mingo@elte.hu
Subject: [PATCH] (2.6.20-rt3) PowerPC: convert spinlocks into raw
Date: Tue, 6 Feb 2007 20:26:40 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, dwalker@mvista.com,
       mgreer@mvista.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702062026.40875.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the spinlocks in the PowerPC interrupt related code into the raw ones,
also convert the PURR and PMC related spinlocks...

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -392,7 +392,7 @@ EXPORT_SYMBOL(do_softirq);
 #ifdef CONFIG_PPC_MERGE
 
 static LIST_HEAD(irq_hosts);
-static spinlock_t irq_big_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_RAW_SPINLOCK(irq_big_lock);
 static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
 static unsigned int irq_radix_writer;
 struct irq_map_entry irq_map[NR_IRQS];
Index: linux-2.6/arch/powerpc/kernel/pmc.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/pmc.c
+++ linux-2.6/arch/powerpc/kernel/pmc.c
@@ -52,7 +52,7 @@ static void dummy_perf(struct pt_regs *r
 }
 #endif
 
-static DEFINE_SPINLOCK(pmc_owner_lock);
+static DEFINE_RAW_SPINLOCK(pmc_owner_lock);
 static void *pmc_owner_caller; /* mostly for debugging */
 perf_irq_t perf_irq = dummy_perf;
 
Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -223,7 +223,7 @@ struct cpu_purr_data {
 	int	initialized;			/* thread is running */
 	u64	tb;			/* last TB value read */
 	u64	purr;			/* last PURR value read */
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 static DEFINE_PER_CPU(struct cpu_purr_data, cpu_purr_data);
Index: linux-2.6/arch/powerpc/sysdev/i8259.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/i8259.c
+++ linux-2.6/arch/powerpc/sysdev/i8259.c
@@ -23,7 +23,7 @@ static unsigned char cached_8259[2] = { 
 #define cached_A1 (cached_8259[0])
 #define cached_21 (cached_8259[1])
 
-static DEFINE_SPINLOCK(i8259_lock);
+static DEFINE_RAW_SPINLOCK(i8259_lock);
 
 static struct device_node *i8259_node;
 static struct irq_host *i8259_host;
Index: linux-2.6/arch/powerpc/sysdev/ipic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ipic.c
+++ linux-2.6/arch/powerpc/sysdev/ipic.c
@@ -30,7 +30,7 @@
 #include "ipic.h"
 
 static struct ipic * primary_ipic;
-static DEFINE_SPINLOCK(ipic_lock);
+static DEFINE_RAW_SPINLOCK(ipic_lock);
 
 static struct ipic_info ipic_info[] = {
 	[9] = {
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -44,7 +44,7 @@
 
 static struct mpic *mpics;
 static struct mpic *mpic_primary;
-static DEFINE_SPINLOCK(mpic_lock);
+static DEFINE_RAW_SPINLOCK(mpic_lock);
 
 #ifdef CONFIG_PPC32	/* XXX for now */
 #ifdef CONFIG_IRQ_ALL_CPUS
Index: linux-2.6/include/asm-powerpc/mpic.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/mpic.h
+++ linux-2.6/include/asm-powerpc/mpic.h
@@ -279,7 +279,7 @@ struct mpic
 #ifdef CONFIG_MPIC_BROKEN_U3
 	/* The fixup table */
 	struct mpic_irq_fixup	*fixups;
-	spinlock_t		fixup_lock;
+	raw_spinlock_t		fixup_lock;
 #endif
 
 	/* Register access method */

