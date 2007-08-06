Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXHFPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXHFPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764390AbXHFPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:18:33 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:49474 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbXHFPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:18:32 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 11:18:29 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=RaKxkL0bjUpsaVJGQdIgKpyjPvF5hyOjcqa4xyx9CSOX2aEd6oMV/JfTjNStDx7ynIUmzSC9Z2wrerYTrVwi3/x+MdLwhc7w4Zc7pBstp8AYYKLbqIuH4S9NRCOl0ixf;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,225,1183327200"; 
   d="diff'?scan'208";a="79228275"
Message-ID: <46B73955.2080007@fujitsu-siemens.com>
Date: Mon, 06 Aug 2007 17:08:05 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: PATCH/RFC: [kdump] fix APIC shutdown sequence
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060306010309070707030809"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060306010309070707030809
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

PATCH/RFC: [kdump] fix APIC shutdown sequence

This patch fixes a problem that we have encountered
with kdump under high I/O load on some machines.
The machines showing the errors have an Intel ICH7
chip set with a 6702PXH  PCI Express-to-PCI Bridge
(8086:032c) containing an IO-APIC.

The bug symptom is that certain controllers connected
to the 6702PXH bridge wouldn't receive any IRQs in the
kdump kernel. In the error case (which is about 20% of
all cases) the IRR bit of the IO-APIC pin for that
controller is always set after the start of the kdump
kernel, indicating an IRQ in progress. We haven't found
a way to recover from this situation when it has once
occured, except for a system reset.

The error is caused by IRQs arriving while the APIC
subsystem is deactivated in machine_crash_shutdown().

Apparently, the IO-APIC gets stuck if it sends an IRQ
message to a Local APIC and never receives an EOI for that
message. This can have several possible reasons:

1. If, under SMP, the IO-APIC logical destination field is
   set by the IRQ balancing code to one of the "other"
   CPUs (i.e. not the crashing_cpu), and an IRQ arrives
   on the respective pin after that CPU has shut down
   its local APIC (but before the IO-APIC pin is masked)
   the IRQ message can't be delivered.

2. The crashing CPU itself disables its local APIC
   before the IO-APIC, leaving a short time window
   where the IOAPIC can receive IRQs, but not
   deliver them.

3. An IRQ is received and delivered to a local APIC, but
   no CPU ever executes the IRQ handler and therefore no
   EOI is sent.

After a lot of failed attempts, i have come up with the
following patch, which fixes the problem.

The patch first masks all IO-Apic pins to avoid a sitation
where the IO-Apic can receive, but not deliver, the IRQs.
Moreover, it enables interrupts for a short period before
eventually starting the kdump kernel, so that EOIs can be
sent to the APICs as necessary.

Notes:
a) Simply calling disable_IO_APIC() early doesn't
work, probably because that also clears the IRQ vector
information, so that arriving EOI messages can't be
associated with pins by the IO-APIC.
b) We have tried patches that avoid re-enabling interrupts,
but so far without success. Re-enabling IRQs is of course
dangerous while dumping, and I'd rather find a way to avoid it.
c) There are indications that besides the EOI, it's also
necessary that the PCI IRQ pin is deasserted at least for
a short time. That usually requires that the driver IRQ
handler is called and tells the FW that the IRQ was received.
Whether or not this is a requirement hasn't been finally
clarified yet.
d) The problem is only seen with the IO-APIC in the 6702PXH
PCI bridge, which is the system's secondary IO-APIC. On the
system's main IO-APIC, we see other IRQs (timer etc) arrive
and never get an EOI, but we see no errors.

The patch below is against 2.6.23-rc1. The problem was
originally analyzed and the patch developed against the
Red Hat EL5 kernel (2.6.18-8.el5). I verified that the
problem still occurs with 2.6.23-rc1, and that the patch
below fixes the problem.

Regards
Martin

PS: patch attached ain MIME format because it'd be mangled
quoted-printable by my Mail relay.

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html


--------------060306010309070707030809
Content-Type: text/x-patch;
 name="kdump.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kdump.diff"

PATCH/RFC: [kdump] fix APIC shutdown sequence

This patch fixes a problem that we have encountered
with kdump under high I/O load on some machines.
The machines showing the errors have an Intel ICH7 
chip set with a 6702PXH  PCI Express-to-PCI Bridge 
(8086:032c) containing an IO-APIC.

The bug symptom is that certain controllers connected
to the 6702PXH bridge wouldn't receive any IRQs in the 
kdump kernel. In the error case (which is about 20% of 
all cases) the IRR bit of the IO-APIC pin for that 
controller is always set after the start of the kdump 
kernel, indicating an IRQ in progress. We haven't found
a way to recover from this situation when it has once 
occured, except for a system reset.

The error is caused by IRQs arriving while the APIC 
subsystem is deactivated in machine_crash_shutdown().

Apparently, the IO-APIC gets stuck if it sends an IRQ
message to a Local APIC and never receives an EOI for that
message. This can have several possible reasons: 

1. If, under SMP, the IO-APIC logical destination field is
   set by the IRQ balancing code to one of the "other"
   CPUs (i.e. not the crashing_cpu), and an IRQ arrives
   on the respective pin after that CPU has shut down
   its local APIC (but before the IO-APIC pin is masked)
   the IRQ message can't be delivered.

2. The crashing CPU itself disables its local APIC 
   before the IO-APIC, leaving a short time window
   where the IOAPIC can receive IRQs, but not 
   deliver them.

3. An IRQ is received and delivered to a local APIC, but 
   no CPU ever executes the IRQ handler and therefore no 
   EOI is sent.

After a lot of failed attempts, i have come up with the
following patch, which fixes the problem. 

The patch first masks all IO-Apic pins to avoid a sitation 
where the IO-Apic can receive, but not deliver, the IRQs. 
Moreover, it enables interrupts for a short period before 
eventually starting the kdump kernel, so that EOIs can be
sent to the APICs as necessary.

Notes: 
a) Simply calling disable_IO_APIC() early doesn't
work, probably because that also clears the IRQ vector
information, so that arriving EOI messages can't be 
associated with pins by the IO-APIC.
b) We have tried patches that avoid re-enabling interrupts,
but so far without success. Re-enabling IRQs is of course
dangerous while dumping, and I'd rather find a way to avoid it.
c) There are indications that besides the EOI, it's also
necessary that the PCI IRQ pin is deasserted at least for
a short time. That usually requires that the driver IRQ 
handler is called and tells the FW that the IRQ was received.
Whether or not this is a requirement hasn't been finally
clarified yet.
d) The problem is only seen with the IO-APIC in the 6702PXH
PCI bridge, which is the system's secondary IO-APIC. On the
system's main IO-APIC, we see other IRQs (timer etc) arrive 
and never get an EOI, but we see no errors.

The patch below is against 2.6.23-rc1. The problem was 
originally analyzed and the patch developed against the 
Red Hat EL5 kernel (2.6.18-8.el5). I verified that the 
problem still occurs with 2.6.23-rc1, and that the patch 
below fixes the problem.

Regards
Martin

Signed-off-by: Martin Wilck <Martin.Wilck@fujitsu-siemens.com>


--- 2.6.23-rc1/arch/x86_64/kernel/crash.c.orig	2007-06-05 11:19:07.000000000 +0200
+++ 2.6.23-rc1/arch/x86_64/kernel/crash.c	2007-08-02 12:38:05.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/elf.h>
 #include <linux/elfcore.h>
 #include <linux/kdebug.h>
+#include <linux/interrupt.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
@@ -30,6 +31,11 @@ static int crashing_cpu;
 
 #ifdef CONFIG_SMP
 static atomic_t waiting_for_crash_ipi;
+static atomic_t crash_ipi_stage2 = ATOMIC_INIT(0);
+
+extern void remove_siblinginfo(int);
+extern void remove_cpu_from_maps(void);
+extern void crash_mask_IO_APIC(int);
 
 static int crash_nmi_callback(struct notifier_block *self,
 				unsigned long val, void *data)
@@ -53,13 +59,30 @@ static int crash_nmi_callback(struct not
 	local_irq_disable();
 
 	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
+	disable_APIC_timer();
+        atomic_dec(&waiting_for_crash_ipi);
+
+	while(atomic_read(&crash_ipi_stage2) == 0)
+		cpu_relax();
+ 
+ 	/* Send EOI for pending IRQs */
+ 	local_irq_enable();
+ 	udelay(10000);
+ 	local_irq_disable();
+ 
+ 	remove_siblinginfo(cpu);
+ 	cpu_clear(cpu, cpu_online_map);
+ 	remove_cpu_from_maps();
+ 
+ 	disable_local_APIC();
+ 	atomic_dec(&crash_ipi_stage2);
+ 
+
 	/* Assume hlt works */
 	for(;;)
 		halt();
 
-	return 1;
+	return NOTIFY_OK;
 }
 
 static void smp_send_nmi_allbutself(void)
@@ -79,7 +102,7 @@ static struct notifier_block crash_nmi_n
 
 static void nmi_shootdown_cpus(void)
 {
-	unsigned long msecs;
+	unsigned long usecs;
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	if (register_die_notifier(&crash_nmi_nb))
@@ -93,19 +116,33 @@ static void nmi_shootdown_cpus(void)
 
 	smp_send_nmi_allbutself();
 
+	usecs = 1000000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && usecs) {
+		udelay(1);
+		usecs--;
+	}
+}
+
+static void nmi_shootdown_cpus_stage2(void)
+{
+	
+	unsigned long msecs;
+	atomic_set(&crash_ipi_stage2, num_online_cpus());
+
 	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+	while ((atomic_read(&crash_ipi_stage2) > 1) && msecs) {
 		mdelay(1);
 		msecs--;
 	}
-	/* Leave the nmi callback set */
-	disable_local_APIC();
 }
 #else
 static void nmi_shootdown_cpus(void)
 {
 	/* There are no cpus to shootdown */
 }
+static void nmi_shootdown_cpus_stage2(void)
+{
+}
 #endif
 
 void machine_crash_shutdown(struct pt_regs *regs)
@@ -121,15 +158,27 @@ void machine_crash_shutdown(struct pt_re
 	 */
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
-
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = smp_processor_id();
+	crash_save_cpu(regs, crashing_cpu);
+
+ 	/* disable timer interrupts */
+ 	disable_irq_nosync(0);
+ 	disable_APIC_timer();	
+ 
 	nmi_shootdown_cpus();
 
+ 	/* Mask all IRQs, and make sure they are delivered to this CPU */
+ 	crash_mask_IO_APIC(crashing_cpu);
+ 	nmi_shootdown_cpus_stage2();
+ 
 	if(cpu_has_apic)
 		 disable_local_APIC();
 
+ 	/* Send EOI for pending IRQs */
+ 	local_irq_enable();
+ 	udelay(10000);
+ 	local_irq_disable();
+ 
 	disable_IO_APIC();
-
-	crash_save_cpu(regs, smp_processor_id());
 }
--- 2.6.23-rc1/arch/x86_64/kernel/io_apic.c.orig	2007-07-25 17:50:05.000000000 +0200
+++ 2.6.23-rc1/arch/x86_64/kernel/io_apic.c	2007-08-02 12:17:57.000000000 +0200
@@ -371,6 +371,50 @@ static void unmask_IO_APIC_irq (unsigned
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+static void crash_mask_IO_APIC_pin(unsigned int apic, unsigned int pin, int reg1)
+{
+	struct IO_APIC_route_entry entry;
+	unsigned long flags;
+
+	/* Check delivery_mode to be sure we're not clearing an SMI pin
+	 * Don't bother disabling masked pins 
+	 */
+	spin_lock_irqsave(&ioapic_lock, flags);
+	*(((int*)&entry) + 0) = io_apic_read(apic, 0x10 + 2 * pin);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+	if (entry.delivery_mode == dest_SMI || entry.mask)
+		return;
+
+	entry.mask = 1;
+	*(((int*)&entry) + 1) = reg1;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	io_apic_write(apic, 0x10 + 2 * pin, *(((int *)&entry) + 0));
+	io_apic_write(apic, 0x11 + 2 * pin, *(((int *)&entry) + 1));
+	io_apic_sync(apic);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+/*
+ * This function is used for kdump to mask all IO-APIC IRQs, and reset
+ * the destination apic ID.
+ */
+void crash_mask_IO_APIC(int cpu)
+{
+	int apic, pin;
+	int reg1;	
+	cpumask_t mask;
+
+	cpus_clear(mask);
+	cpu_set(cpu, mask);
+	reg1 = SET_APIC_LOGICAL_ID(cpu_mask_to_apicid(mask));
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+			crash_mask_IO_APIC_pin(apic, pin, reg1);
+	}
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
--- 2.6.23-rc1/arch/x86_64/kernel/smpboot.c.orig	2007-06-05 11:19:07.000000000 +0200
+++ 2.6.23-rc1/arch/x86_64/kernel/smpboot.c	2007-08-02 12:17:57.000000000 +0200
@@ -973,7 +973,7 @@ void __init smp_cpus_done(unsigned int m
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void remove_siblinginfo(int cpu)
+void remove_siblinginfo(int cpu)
 {
 	int sibling;
 	struct cpuinfo_x86 *c = cpu_data;

--------------060306010309070707030809--
