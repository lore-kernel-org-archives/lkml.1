Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYCNOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYCNOqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYCNOqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:46:03 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:48898 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYCNOqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:46:01 -0400
Date: Fri, 14 Mar 2008 10:45:47 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-smp@vger.kernel.org
Subject: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20080314144547.GD4620@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend)
This patch includes code to handle NMI_IO_APIC enabling/disabling by
nmi_watchdog proc file.

Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

---
 arch/x86/kernel/nmi_32.c |   25 +++++++++++++++++++++++++
 arch/x86/kernel/nmi_64.c |   25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

--- nmi.orig/arch/x86/kernel/nmi_64.c	2008-03-12 17:02:36.000000000 -0400
+++ nmi/arch/x86/kernel/nmi_64.c	2008-03-12 17:47:35.000000000 -0400
@@ -274,6 +274,8 @@ void stop_apic_nmi_watchdog(void *unused
 		return;
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		lapic_watchdog_stop();
+	else
+		__acpi_nmi_disable(NULL);
 	__get_cpu_var(wd_enabled) = 0;
 	atomic_dec(&nmi_active);
 }
@@ -405,6 +407,24 @@ void restart_nmi(void)
 
 #ifdef CONFIG_SYSCTL
 
+static void enable_ioapic_nmi_watchdog_single(void *unused)
+{
+	__get_cpu_var(wd_enabled) = 1;
+	atomic_inc(&nmi_active);
+	__acpi_nmi_enable(NULL);
+}
+
+static void enable_ioapic_nmi_watchdog(void)
+{
+	on_each_cpu(enable_ioapic_nmi_watchdog_single, NULL, 0, 1);
+	touch_nmi_watchdog();
+}
+
+static void disable_ioapic_nmi_watchdog(void)
+{
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+}
+
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
 {
 	unsigned char reason = get_nmi_reason();
@@ -442,6 +462,11 @@ int proc_nmi_enabled(struct ctl_table *t
 			enable_lapic_nmi_watchdog();
 		else
 			disable_lapic_nmi_watchdog();
+	} else if (nmi_watchdog == NMI_IO_APIC) {
+		if (nmi_watchdog_enabled)
+			enable_ioapic_nmi_watchdog();
+		else
+			disable_ioapic_nmi_watchdog();
 	} else {
 		printk( KERN_WARNING
 			"NMI watchdog doesn't know what hardware to touch\n");
--- nmi.orig/arch/x86/kernel/nmi_32.c	2008-03-12 15:16:30.000000000 -0400
+++ nmi/arch/x86/kernel/nmi_32.c	2008-03-12 17:50:55.000000000 -0400
@@ -270,6 +270,8 @@ void stop_apic_nmi_watchdog(void *unused
 		return;
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		lapic_watchdog_stop();
+	else
+		__acpi_nmi_disable(NULL);
 	__get_cpu_var(wd_enabled) = 0;
 	atomic_dec(&nmi_active);
 }
@@ -390,6 +392,24 @@ __kprobes int nmi_watchdog_tick(struct p
 
 #ifdef CONFIG_SYSCTL
 
+static void enable_ioapic_nmi_watchdog_single(void *unused)
+{
+	__get_cpu_var(wd_enabled) = 1;
+	atomic_inc(&nmi_active);
+	__acpi_nmi_enable(NULL);
+}
+
+static void enable_ioapic_nmi_watchdog(void)
+{
+	on_each_cpu(enable_ioapic_nmi_watchdog_single, NULL, 0, 1);
+	touch_nmi_watchdog();
+}
+
+static void disable_ioapic_nmi_watchdog(void)
+{
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+}
+
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
 {
 	unsigned char reason = get_nmi_reason();
@@ -431,6 +451,11 @@ int proc_nmi_enabled(struct ctl_table *t
 			enable_lapic_nmi_watchdog();
 		else
 			disable_lapic_nmi_watchdog();
+	} else if (nmi_watchdog == NMI_IO_APIC) {
+		if (nmi_watchdog_enabled)
+			enable_ioapic_nmi_watchdog();
+		else
+			disable_ioapic_nmi_watchdog();
 	} else {
 		printk( KERN_WARNING
 			"NMI watchdog doesn't know what hardware to touch\n");
