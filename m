Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbXBLQxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbXBLQxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXBLQwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:53645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965001AbXBLQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:46 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Benjamin Romer <benjamin.romer@unisys.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [7/29] x86_64: update IO-APIC dest field to 8-bit for xAPIC
Message-Id: <20070212165127.1790A13FAE@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Benjamin Romer <benjamin.romer@unisys.com>

On the Unisys ES7000/ONE system, we encountered a problem where performing
a kexec reboot or dump on any cell other than cell 0 causes the system
timer to stop working, resulting in a hang during timer calibration in the
new kernel.

We traced the problem to one line of code in disable_IO_APIC(), which needs
to restore the timer's IO-APIC configuration before rebooting.  The code is
currently using the 4-bit physical destination field, rather than using the
8-bit logical destination field, and it cuts off the upper 4 bits of the
timer's APIC ID.  If we change this to use the logical destination field,
the timer works and we can kexec on the upper cells.  This was tested on
two different cells (0 and 2) in an ES7000/ONE system.

For reference, the relevant Intel xAPIC spec is kept at
ftp://download.intel.com/design/chipsets/e8501/datashts/30962001.pdf,
specifically on page 334.

Signed-off-by: Benjamin M Romer <benjamin.romer@unisys.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   24 +++++++++++-------------
 include/asm-x86_64/io_apic.h |   14 ++------------
 2 files changed, 13 insertions(+), 25 deletions(-)

Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -831,7 +831,7 @@ static void __init setup_IO_APIC_irq(int
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;				/* enable IRQ */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 
 	entry.trigger = irq_trigger(idx);
 	entry.polarity = irq_polarity(idx);
@@ -839,7 +839,7 @@ static void __init setup_IO_APIC_irq(int
 	if (irq_trigger(idx)) {
 		entry.trigger = 1;
 		entry.mask = 1;
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+		entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	}
 
 	if (!apic && !IO_APIC_IRQ(irq))
@@ -851,7 +851,7 @@ static void __init setup_IO_APIC_irq(int
 		if (vector < 0)
 			return;
 
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+		entry.dest = cpu_mask_to_apicid(mask);
 		entry.vector = vector;
 
 		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
@@ -920,7 +920,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;					/* unmask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1020,18 +1020,17 @@ void __apicdebuginit print_IO_APIC(void)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Log Phy Mask Trig IRR Pol"
-			  " Stat Dest Deli Vect:   \n");
+	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+			  " Stat Dmod Deli Vect:   \n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X %02X  ",
+		printk(KERN_DEBUG " %02x %03X ",
 			i,
-			entry.dest.logical.logical_dest,
-			entry.dest.physical.physical_dest
+			entry.dest
 		);
 
 		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
@@ -1293,8 +1292,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest.physical.physical_dest =
-					GET_APIC_ID(apic_read(APIC_ID));
+		entry.dest          = GET_APIC_ID(apic_read(APIC_ID));
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1556,7 +1554,7 @@ static inline void unlock_ExtINT_logic(v
 
 	entry1.dest_mode = 0;			/* physical delivery */
 	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
+	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = 0;
@@ -2131,7 +2129,7 @@ int io_apic_set_pci_routing (int ioapic,
 
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+	entry.dest = cpu_mask_to_apicid(mask);
 	entry.trigger = triggering;
 	entry.polarity = polarity;
 	entry.mask = 1;					 /* Disabled (masked) */
Index: linux/include/asm-x86_64/io_apic.h
===================================================================
--- linux.orig/include/asm-x86_64/io_apic.h
+++ linux/include/asm-x86_64/io_apic.h
@@ -85,18 +85,8 @@ struct IO_APIC_route_entry {
 		mask		:  1,	/* 0: enabled, 1: disabled */
 		__reserved_2	: 15;
 
-	union {		struct { __u32
-					__reserved_1	: 24,
-					physical_dest	:  4,
-					__reserved_2	:  4;
-			} physical;
-
-			struct { __u32
-					__reserved_1	: 24,
-					logical_dest	:  8;
-			} logical;
-	} dest;
-
+	__u32	__reserved_3	: 24,
+		dest		:  8;
 } __attribute__ ((packed));
 
 /*
