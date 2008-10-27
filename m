Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYJ0QmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYJ0QmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYJ0Ql0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:41:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYJ0QlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:41:25 -0400
Message-Id: <20081027164234.927398000@napanee.usersys.redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 27 Oct 2008 12:42:35 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] NMI watchdog: disable NMIs on LVT0 in case NMI watchdog is not working
Content-Disposition: inline; filename=nmi-disable_nmi_delivery_on_lint0_if_nmi_watchdog_is_not_functional.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the NMI watchdog fails using IOAPIC method, it'll only disable
interrupts on 8259 if the timer is passing thru it. This patch disables
NMI delivery on LINT0 if the NMI watchdog initial test fails, just for safety.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 arch/x86/kernel/nmi.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- linus-2.6.orig/arch/x86/kernel/nmi.c	2008-10-27 11:59:49.000000000 -0400
+++ linus-2.6/arch/x86/kernel/nmi.c	2008-10-27 11:59:49.000000000 -0400
@@ -131,6 +131,11 @@ static void report_broken_nmi(int cpu, i
 	atomic_dec(&nmi_active);
 }
 
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
 int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -179,8 +184,12 @@ int __init check_nmi_watchdog(void)
 	kfree(prev_nmi_count);
 	return 0;
 error:
-	if (nmi_watchdog == NMI_IO_APIC && !timer_through_8259)
-		disable_8259A_irq(0);
+	if (nmi_watchdog == NMI_IO_APIC) {
+		if (!timer_through_8259)
+			disable_8259A_irq(0);
+		on_each_cpu(__acpi_nmi_disable, NULL, 1);
+	}
+
 #ifdef CONFIG_X86_32
 	timer_ack = 0;
 #endif
@@ -285,11 +294,6 @@ void acpi_nmi_enable(void)
 		on_each_cpu(__acpi_nmi_enable, NULL, 1);
 }
 
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
 /*
  * Disable timer based NMIs on all CPUs:
  */

-- 
Aristeu

