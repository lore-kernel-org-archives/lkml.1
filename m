Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZC2UWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZC2UWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZC2UVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZC2UVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Gd2QTmIgd7DghDlRAszDnAMQ0mPXiMjiu51o9kXh1uF2GNG5VnLCy1M3EiwmqqjT2w
         DqMrIpcOmiO5kpAgGhbMdo65CNd7ZU4JGID6eFxrBDWxhUcCBEsuePX3XQGfH9SQqDGf
         5GRmRJ6MqT34GujTBjxRStdIVdFtqvARl71e0=
Message-Id: <20090329202208.295033740@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:50 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 5/6] x86: irqinit - merge math_error_irq and headers
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-math_error_irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though the #include's are to be cleaned up.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |    8 ++++++--
 arch/x86/kernel/irqinit_64.c |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -1,19 +1,23 @@
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
+#include <asm/hw_irq.h>
 #include <asm/timer.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
@@ -22,7 +26,7 @@
 #include <asm/i8259.h>
 #include <asm/traps.h>
 
-
+#ifdef CONFIG_X86_32
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
  * as the irq is unreliable, and exception 16 works correctly
@@ -34,7 +38,6 @@
  * leads to races. IBM designers who came up with it should
  * be shot.
  */
-
 static irqreturn_t math_error_irq(int cpl, void *dev_id)
 {
 	outb(0, 0xF0);
@@ -53,6 +56,7 @@ static struct irqaction fpu_irq = {
 	.mask = CPU_MASK_NONE,
 	.name = "fpu",
 };
+#endif /* CONFIG_X86_32 */
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
+#include <linux/kprobes.h>
 #include <linux/timex.h>
 #include <linux/slab.h>
 #include <linux/random.h>
@@ -18,11 +19,45 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/hw_irq.h>
+#include <asm/timer.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/i8259.h>
+#include <asm/traps.h>
+
+#ifdef CONFIG_X86_32
+/*
+ * Note that on a 486, we don't want to do a SIGFPE on an irq13
+ * as the irq is unreliable, and exception 16 works correctly
+ * (ie as explained in the intel literature). On a 386, you
+ * can't use exception 16 due to bad IBM design, so we have to
+ * rely on the less exact irq13.
+ *
+ * Careful.. Not only is IRQ13 unreliable, but it is also
+ * leads to races. IBM designers who came up with it should
+ * be shot.
+ */
+static irqreturn_t math_error_irq(int cpl, void *dev_id)
+{
+	outb(0, 0xF0);
+	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
+		return IRQ_NONE;
+	math_error((void __user *)get_irq_regs()->ip);
+	return IRQ_HANDLED;
+}
+
+/*
+ * New motherboards sometimes make IRQ 13 be a PCI interrupt,
+ * so allow interrupt sharing.
+ */
+static struct irqaction fpu_irq = {
+	.handler = math_error_irq,
+	.mask = CPU_MASK_NONE,
+	.name = "fpu",
+};
+#endif /* CONFIG_X86_32 */
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:

