Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbZD2UFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbZD2UFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZD2UFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:05:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbZD2UFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:05:06 -0400
Message-ID: <49F8B2D9.3080903@kernel.org>
Date: Wed, 29 Apr 2009 13:04:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] x86: don't print strange not connect ioapic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in setup_IO_APIC_irqs(), we only need to go with ioapic that handle legacy irqs,
because at that points we only have those irq in mp_irqs[]

will not print out those strange not connected pin warning.

[ Impact: don't go with not used ioapic yet ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1477,10 +1477,27 @@ static void __init setup_IO_APIC_irqs(vo
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int node = cpu_to_node(boot_cpu_id);
+	int ioapic_start = 0, ioapic_end = nr_ioapics;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
+#ifdef CONFIG_ACPI
+	/*
+	 * when acpi is used, at this point, we only have legacy entries
+	 * in mp_irqs[] by mp_config_acpi_legacy_irqs/mp_override_legacy_irq
+	 * so only setup for that ioapic, and will not print out those strange
+	 * not connected on other ioapic
+	 */
+	if (!acpi_disabled && acpi_ioapic) {
+		ioapic_start = mp_find_ioapic(0);
+		if (ioapic_start < 0)
+			ioapic_start = 0;
+		else
+			ioapic_end = ioapic_start + 1;
+	}
+#endif
+
+	for (apic_id = ioapic_start; apic_id < ioapic_end; apic_id++) {
 		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 
 			idx = find_irq_entry(apic_id, pin, mp_INT);
