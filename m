Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZCJNEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZCJNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZCJNDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:03:22 -0400
Received: from cmpxchg.org ([85.214.51.133]:38759 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZCJNDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:03:21 -0400
Message-Id: <20090310120631.350359642@emlix.com>
References: <20090310115643.653120649@emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 12:56:46 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/8] xtensa: variant irq set callbacks
Content-Disposition: inline; filename=0003-xtensa-variant-irq-set-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the core variant code to provide irq enable/disable callbacks.

The s6000 has a crossbar that multiplexes peripheral IRQ lines to a
smaller number of core lines.  These callbacks allow the s6000 variant
to program the crossbar when core lines are toggled.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/Kconfig           |    3 +++
 arch/xtensa/include/asm/irq.h |    7 +++++++
 arch/xtensa/kernel/irq.c      |   14 ++++++++++++++
 3 files changed, 24 insertions(+)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -51,6 +51,9 @@ source "kernel/Kconfig.freezer"
 config MMU
 	def_bool n
 
+config VARIANT_IRQ_SWITCH
+	def_bool n
+
 menu "Processor type and features"
 
 choice
--- a/arch/xtensa/include/asm/irq.h
+++ b/arch/xtensa/include/asm/irq.h
@@ -14,6 +14,13 @@
 #include <platform/hardware.h>
 #include <variant/core.h>
 
+#ifdef CONFIG_VARIANT_IRQ_SWITCH
+#include <variant/irq.h>
+#else
+static inline void variant_irq_enable(unsigned int irq) { }
+static inline void variant_irq_disable(unsigned int irq) { }
+#endif
+
 #ifndef PLATFORM_NR_IRQS
 # define PLATFORM_NR_IRQS 0
 #endif
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -132,6 +132,18 @@ static void xtensa_irq_unmask(unsigned i
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
+static void xtensa_irq_enable(unsigned int irq)
+{
+	variant_irq_enable(irq);
+	xtensa_irq_unmask(irq);
+}
+
+static void xtensa_irq_disable(unsigned int irq)
+{
+	xtensa_irq_mask(irq);
+	variant_irq_disable(irq);
+}
+
 static void xtensa_irq_ack(unsigned int irq)
 {
 	set_sr(1 << irq, INTCLEAR);
@@ -146,6 +158,8 @@ static int xtensa_irq_retrigger(unsigned
 
 static struct irq_chip xtensa_irq_chip = {
 	.name		= "xtensa",
+	.enable		= xtensa_irq_enable,
+	.disable	= xtensa_irq_disable,
 	.mask		= xtensa_irq_mask,
 	.unmask		= xtensa_irq_unmask,
 	.ack		= xtensa_irq_ack,

-- 

