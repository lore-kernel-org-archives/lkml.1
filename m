Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXBWLUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXBWLUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbXBWLUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:20:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50684 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbXBWLUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:20:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 05/14] x86_64 irq: Refactor setup_IO_APIC_irq
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:19:08 -0700
In-Reply-To: <m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:16:31 -0700")
Message-ID: <m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we have two routines that do practically the same thing
setup_IO_APIC_irq and io_apic_set_pci_routing.  This patch makes
setup_IO_APIC_irq the common factor of these two previous routines.
For setup_IO_APIC_irq all that was needed was to pass the trigger
and polarity to make the code a proper subset of io_apic_set_pci_routing.

Hopefully consolidating these two routines will improve maintenance
there were several differences that simply appear to be one routine
or the other getting it wrong.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |  126 +++++++++++------------------------------
 1 files changed, 34 insertions(+), 92 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index a69c38b..e064838 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -615,22 +615,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
-static inline int IO_APIC_irq_trigger(int irq)
-{
-	int apic, idx, pin;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
-			idx = find_irq_entry(apic,pin,mp_INT);
-			if ((idx != -1) && (irq == pin_2_irq(idx,apic,pin)))
-				return irq_trigger(idx);
-		}
-	}
-	/*
-	 * nonexistent IRQs are edge default
-	 */
-	return 0;
-}
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
 static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = {
@@ -795,26 +779,36 @@ void __setup_vector_irq(int cpu)
 
 static struct irq_chip ioapic_chip;
 
-#define IOAPIC_AUTO	-1
-#define IOAPIC_EDGE	0
-#define IOAPIC_LEVEL	1
-
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-			trigger == IOAPIC_LEVEL)
+	if (trigger)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq, "fasteoi");
 	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
 }
-static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
+
+static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
+			      int trigger, int polarity)
 {
 	struct IO_APIC_route_entry entry;
+	cpumask_t mask;
 	int vector;
 	unsigned long flags;
 
+	if (!IO_APIC_IRQ(irq))
+		return;
+
+	vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
+	if (vector < 0)
+		return;
+
+	apic_printk(APIC_VERBOSE,KERN_DEBUG
+		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
+		    "IRQ %d Mode:%i Active:%i)\n",
+		    apic, mp_ioapics[apic].mpc_apicid, pin, vector,
+		    irq, trigger, polarity);
 
 	/*
 	 * add it to the IO-APIC irq-routing table:
@@ -823,41 +817,27 @@ static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
+	entry.dest = cpu_mask_to_apicid(mask);
 	entry.mask = 0;				/* enable IRQ */
-	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
-
-	entry.trigger = irq_trigger(idx);
-	entry.polarity = irq_polarity(idx);
+	entry.trigger = trigger;
+	entry.polarity = polarity;
+	entry.vector = vector;
 
-	if (irq_trigger(idx)) {
-		entry.trigger = 1;
+	/* Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (trigger)
 		entry.mask = 1;
-		entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
-	}
-
-	if (!apic && !IO_APIC_IRQ(irq))
-		return;
 
-	if (IO_APIC_IRQ(irq)) {
-		cpumask_t mask;
-		vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
-		if (vector < 0)
-			return;
-
-		entry.dest = cpu_mask_to_apicid(mask);
-		entry.vector = vector;
-
-		ioapic_register_intr(irq, IOAPIC_AUTO);
-		if (!apic && (irq < 16))
-			disable_8259A_irq(irq);
-	}
+	ioapic_register_intr(irq, trigger);
+	if (irq < 16)
+		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	irq_desc[irq].affinity = TARGET_CPUS;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
-
 }
 
 static void __init setup_IO_APIC_irqs(void)
@@ -882,8 +862,8 @@ static void __init setup_IO_APIC_irqs(void)
 		irq = pin_2_irq(idx, apic, pin);
 		add_pin_to_irq(irq, apic, pin);
 
-		setup_IO_APIC_irq(apic, pin, idx, irq);
-
+		setup_IO_APIC_irq(apic, pin, irq,
+				  irq_trigger(idx), irq_polarity(idx));
 	}
 	}
 
@@ -2090,11 +2070,6 @@ int __init io_apic_get_redir_entries (int ioapic)
 
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
-	struct IO_APIC_route_entry entry;
-	unsigned long flags;
-	int vector;
-	cpumask_t mask;
-
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
@@ -2107,42 +2082,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	if (irq >= 16)
 		add_pin_to_irq(irq, ioapic, pin);
 
-
-	vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
-	if (vector < 0)
-		return vector;
-
-	/*
-	 * Generate a PCI IRQ routing entry and program the IOAPIC accordingly.
-	 * Note that we mask (disable) IRQs now -- these get enabled when the
-	 * corresponding device driver registers for this IRQ.
-	 */
-
-	memset(&entry,0,sizeof(entry));
-
-	entry.delivery_mode = INT_DELIVERY_MODE;
-	entry.dest_mode = INT_DEST_MODE;
-	entry.dest = cpu_mask_to_apicid(mask);
-	entry.trigger = triggering;
-	entry.polarity = polarity;
-	entry.mask = 1;					 /* Disabled (masked) */
-	entry.vector = vector & 0xff;
-
-	apic_printk(APIC_VERBOSE,KERN_DEBUG "IOAPIC[%d]: Set PCI routing entry (%d-%d -> 0x%x -> "
-		"IRQ %d Mode:%i Active:%i)\n", ioapic, 
-	       mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
-	       triggering, polarity);
-
-	ioapic_register_intr(irq, triggering);
-
-	if (!ioapic && (irq < 16))
-		disable_8259A_irq(irq);
-
-	ioapic_write_entry(ioapic, pin, entry);
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	irq_desc[irq].affinity = TARGET_CPUS;
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
 
 	return 0;
 }
@@ -2175,7 +2115,9 @@ void __init setup_ioapic_dest(void)
 			 * cpu is online.
 			 */
 			if(!irq_vector[irq])
-				setup_IO_APIC_irq(ioapic, pin, irq_entry, irq);
+				setup_IO_APIC_irq(ioapic, pin, irq,
+						  irq_trigger(irq_entry),
+						  irq_polarity(irq_entry));
 			else
 				set_ioapic_affinity_irq(irq, TARGET_CPUS);
 		}
-- 
1.5.0.g53756

