Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbZDGRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbZDGRea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZDGReI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:34:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:38825 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608AbZDGReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:34:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] x86: unify trivial differences in irqinit_{32,64}.c
Date: Tue,  7 Apr 2009 16:48:36 +0300
Message-Id: <1239112120-676-9-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |   20 ++++++++++++++++++++
 arch/x86/kernel/irqinit_64.c |    4 ++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index a780de3..72ce942 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -1,20 +1,24 @@
+#include <linux/linkage.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
+#include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/delay.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/timer.h>
+#include <asm/hw_irq.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
@@ -22,6 +26,22 @@
 #include <asm/i8259.h>
 #include <asm/traps.h>
 
+/*
+ * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
+ * (these are usually mapped to vectors 0x30-0x3f)
+ */
+
+/*
+ * The IO-APIC gives us many more interrupt sources. Most of these
+ * are unused but an SMP system is supposed to have enough memory ...
+ * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
+ * across the spectrum, so we really want to be prepared to get all
+ * of these. Plus, more powerful systems might have more than 64
+ * IO-APIC registers.
+ *
+ * (these are usually mapped into the 0x30-0xff vector range)
+ */
+
 #ifdef CONFIG_X86_32
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index ed50e35..687b6c3 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -17,11 +17,14 @@
 
 #include <asm/atomic.h>
 #include <asm/system.h>
+#include <asm/timer.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/setup.h>
 #include <asm/i8259.h>
+#include <asm/traps.h>
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
@@ -136,6 +139,7 @@ static void __init init_ISA_irqs(void)
 	}
 }
 
+/* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
 static void __init smp_intr_init(void)
-- 
1.5.6.3

