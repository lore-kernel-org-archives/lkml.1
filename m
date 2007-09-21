Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbXIUUxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbXIUUxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762878AbXIUUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761776AbXIUUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:09 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: Yinghai.Lu@Sun.COM, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/45] x86_64: clear IO_APIC before enabing apic error vector.
Message-Id: <20070921204508.81AE314EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>
[PATCH] x86_64: clear IO_APIC before enabing apic error vector.

some apic id lifting system: 4 socket quad core, 8 socket quad core will do apic id lifting for BSP.

but io-apic regs for ExtINT still use 0 as dest.

so when we enable apic error vector in BSP, we will get one APIC error.

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ESR value after enabling vector: 00000000, after 0000000c
APIC error on CPU0: 0c(08)
ENABLING IO-APIC IRQs
Synchronizing Arb IDs.

So move enable_IO_APIC from setup_IO_APIC into setup_local_APIC and call it
before enabling apic error vector.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/apic.c    |    8 ++++++++
 arch/x86_64/kernel/io_apic.c |    7 +++++--
 include/asm-x86_64/hw_irq.h  |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -419,6 +419,14 @@ void __cpuinit setup_local_APIC (void)
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
 	apic_write(APIC_LVT1, value);
 
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (!smp_processor_id())
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+
 	{
 		unsigned oldvalue;
 		maxlvt = get_maxlvt();
Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -1166,7 +1166,7 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -1775,7 +1775,10 @@ __setup("no_timer_check", notimercheck);
 
 void __init setup_IO_APIC(void)
 {
-	enable_IO_APIC();
+
+	/*
+	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 */
 
 	if (acpi_ioapic)
 		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
Index: linux/include/asm-x86_64/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86_64/hw_irq.h
+++ linux/include/asm-x86_64/hw_irq.h
@@ -135,6 +135,7 @@ extern void init_8259A(int aeoi);
 extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
 extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
