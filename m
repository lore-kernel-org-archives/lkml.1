Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbXBNHT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbXBNHT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbXBNHTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:19:23 -0500
Received: from koto.vergenet.net ([210.128.90.7]:33708 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXBNHTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:19:19 -0500
Date: Wed, 14 Feb 2007 15:25:50 +0900
From: Horms <horms@verge.net.au>
To: Benjamin Romer <benjamin.romer@unisys.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, fastboot@lists.osdl.org
Subject: Re: [PATCH 2.6.19.2 1/1] kexec: update IO-APIC dest field to 8-bit for APIC
Message-ID: <20070214062550.GA14397@verge.net.au>
References: <1169226749.6467.14.camel@ustr-romerbm-2.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169226749.6467.14.camel@ustr-romerbm-2.na.uis.unisys.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 19, 2007 at 12:12:28PM -0500, Benjamin Romer wrote:
> On the Unisys ES7000/ONE system, we encountered a problem where performing
> a kexec reboot or dump on any cell other than cell 0 causes the system
> timer to stop working, resulting in a hang during timer calibration in the
> new kernel.
> 
> We traced the problem to one line of code in disable_IO_APIC(), which needs
> to restore the timer's IO-APIC configuration before rebooting.  The code is
> currently using the 4-bit physical destination field, rather than using the
> 8-bit logical destination field, and it cuts off the upper 4 bits of the
> timer's APIC ID.  If we change this to use the logical destination field,
> the timer works and we can kexec on the upper cells.  This was tested on
> two different cells (0 and 2) in an ES7000/ONE system.
> 
> For reference, the relevant Intel xAPIC spec is kept at
> ftp://download.intel.com/design/chipsets/e8501/datashts/30962001.pdf,
> specifically on page 334.
> 
> Signed-off-by: Benjamin M Romer <benjamin.romer@unisys.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@in.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi,

I don't seem to be able to get this patch to apply 
(to the current Linus tree) due to some whitespace issues
in the 6th Fragment.

This is resolved in the version of the patch below.

*** Only whitespace changes + rediff ***

 arch/x86_64/kernel/io_apic.c |   24 +++++++++++-------------
 include/asm-x86_64/io_apic.h |   14 ++------------
 2 files changed, 13 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/io_apic.c	2007-02-14 15:17:18.000000000 +0900
+++ linux-2.6/arch/x86_64/kernel/io_apic.c	2007-02-14 15:19:02.000000000 +0900
@@ -831,7 +831,7 @@
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;				/* enable IRQ */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 
 	entry.trigger = irq_trigger(idx);
 	entry.polarity = irq_polarity(idx);
@@ -839,7 +839,7 @@
 	if (irq_trigger(idx)) {
 		entry.trigger = 1;
 		entry.mask = 1;
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+		entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	}
 
 	if (!apic && !IO_APIC_IRQ(irq))
@@ -851,7 +851,7 @@
 		if (vector < 0)
 			return;
 
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+		entry.dest = cpu_mask_to_apicid(mask);
 		entry.vector = vector;
 
 		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
@@ -920,7 +920,7 @@
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;					/* unmask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1020,18 +1020,17 @@
 
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
@@ -1293,8 +1292,7 @@
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest.physical.physical_dest =
-					GET_APIC_ID(apic_read(APIC_ID));
+		entry.dest            = GET_APIC_ID(apic_read(APIC_ID));
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1556,7 +1554,7 @@
 
 	entry1.dest_mode = 0;			/* physical delivery */
 	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
+	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = 0;
@@ -2131,7 +2129,7 @@
 
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+	entry.dest = cpu_mask_to_apicid(mask);
 	entry.trigger = triggering;
 	entry.polarity = polarity;
 	entry.mask = 1;					 /* Disabled (masked) */
Index: linux-2.6/include/asm-x86_64/io_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/io_apic.h	2007-02-14 15:17:18.000000000 +0900
+++ linux-2.6/include/asm-x86_64/io_apic.h	2007-02-14 15:19:02.000000000 +0900
@@ -85,18 +85,8 @@
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

