Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYJ0Qlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYJ0Qlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0QlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:41:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59126 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYJ0QlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:41:23 -0400
Message-Id: <20081027164234.679734000@napanee.usersys.redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 27 Oct 2008 12:42:34 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] NMI watchdog: add support to enable and disable IOAPIC NMI
Content-Disposition: inline; filename=nmi-add_support_for_ioapic_nmi_watchdog_on_nmi_enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to enable/disable IOAPIC NMI watchdog in runtime via
procfs.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 arch/x86/kernel/nmi.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- linus-2.6.orig/arch/x86/kernel/nmi.c	2008-10-27 11:31:56.000000000 -0400
+++ linus-2.6/arch/x86/kernel/nmi.c	2008-10-27 11:43:49.000000000 -0400
@@ -340,6 +340,8 @@ void stop_apic_nmi_watchdog(void *unused
 		return;
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		lapic_watchdog_stop();
+	else
+		__acpi_nmi_disable(NULL);
 	__get_cpu_var(wd_enabled) = 0;
 	atomic_dec(&nmi_active);
 }
@@ -465,6 +467,24 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 
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
+	on_each_cpu(enable_ioapic_nmi_watchdog_single, NULL, 1);
+	touch_nmi_watchdog();
+}
+
+static void disable_ioapic_nmi_watchdog(void)
+{
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
+}
+
 static int __init setup_unknown_nmi_panic(char *str)
 {
 	unknown_nmi_panic = 1;
@@ -507,6 +527,11 @@ int proc_nmi_enabled(struct ctl_table *t
 			enable_lapic_nmi_watchdog();
 		else
 			disable_lapic_nmi_watchdog();
+	} else if (nmi_watchdog == NMI_IO_APIC) {
+		if (nmi_watchdog_enabled)
+			enable_ioapic_nmi_watchdog();
+		else
+			disable_ioapic_nmi_watchdog();
 	} else {
 		printk(KERN_WARNING
 			"NMI watchdog doesn't know what hardware to touch\n");

-- 
Aristeu

