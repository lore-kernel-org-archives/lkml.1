Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYHOXoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYHOXoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYHOXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:43:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYHOXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Yf1nI55S5OiYLhkr1g2CW8RhVo4pWz04mfpDpNfHyDIaUAv2QQhXSenAk8u/LpDzUF
         +8xamFHnkUtI4wS30YiizUW/JtxeEb2vQfWDlu+4khJhvh4lpfKs3/H4Esz16aJowmnp
         RBqgNUdKCY/9iNRVbkAk+5jc0o0SUp3eASFY0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/7] x86: make headers files the smae in io_apic_xx.c
Date: Fri, 15 Aug 2008 16:42:37 -0700
Message-Id: <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also make no_timer_check to be global on 64 bit, because vmi_32 is using that.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_32.c |   15 ++++++++++++---
 arch/x86/kernel/io_apic_64.c |   12 +++++++++---
 2 files changed, 21 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_32.c
+++ linux-2.6/arch/x86/kernel/io_apic_32.c
@@ -25,28 +25,37 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
-#include <linux/bootmem.h>
+#include <linux/pci.h>
 #include <linux/mc146818rtc.h>
 #include <linux/compiler.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/sysdev.h>
-#include <linux/pci.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
-#include <linux/jiffies.h>	/* time_after() */
+#include <linux/jiffies.h>      /* time_after() */
+#ifdef CONFIG_ACPI
+#include <acpi/acpi_bus.h>
+#endif
+#include <linux/bootmem.h>
+#include <linux/dmar.h>
 
+#include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/desc.h>
+#include <asm/proto.h>
+#include <asm/acpi.h>
+#include <asm/dma.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
+#include <asm/irq_remapping.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -27,12 +27,15 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/mc146818rtc.h>
+#include <linux/compiler.h>
 #include <linux/acpi.h>
+#include <linux/module.h>
 #include <linux/sysdev.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
-#include <linux/dmar.h>
-#include <linux/jiffies.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/jiffies.h>	/* time_after() */
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -46,14 +49,17 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 #include <asm/dma.h>
+#include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/setup.h>
 #include <asm/irq_remapping.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
+#include <mach_apicdef.h>
 
 #define __apicdebuginit(type) static type __init
 
@@ -1683,7 +1689,7 @@ void disable_IO_APIC(void)
 	disconnect_bsp_APIC(ioapic_i8259.pin != -1);
 }
 
-static int no_timer_check;
+int no_timer_check __initdata;
 
 static int __init notimercheck(char *s)
 {
