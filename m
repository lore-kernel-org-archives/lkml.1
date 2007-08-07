Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbXHGUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbXHGUOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbXHGUN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:13:57 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45185 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbXHGUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:13:56 -0400
Date: Tue, 07 Aug 2007 13:19:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: clear IO_APIC before enabing apic error vector.
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071319.35423.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 900ff38..a2ae138 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -436,6 +436,14 @@ void __cpuinit setup_local_APIC (void)
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
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 050141c..a537c2f 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1165,7 +1165,7 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -1774,7 +1774,10 @@ __setup("no_timer_check", notimercheck);
 
 void __init setup_IO_APIC(void)
 {
-	enable_IO_APIC();
+
+	/*
+	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 */
 
 	if (acpi_ioapic)
 		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 09dfc18..31aa656 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -135,6 +135,7 @@ extern void init_8259A(int aeoi);
 extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
 extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
