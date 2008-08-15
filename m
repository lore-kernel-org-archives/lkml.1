Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYHOCWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYHOCWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYHOCVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:23170 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYHOCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sK2k5GApR9owkn2899+ABmxyFf2R3mTJu3bas6IJOy2xC1yFIi12uOGR412pUTvQUc
         vHK2RSvVs0hJj7r329yXu3OrFsuTE6ihpsiv0yAasV8DsR8SqP12Xd3iTsaCiFExQx0f
         yTEbU5IrDjuHwwld53EENs3bl2/EEjgNEACWo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/7] x86: remove union about dest for log/phy
Date: Thu, 14 Aug 2008 19:20:27 -0700
Message-Id: <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let user decide the bits.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |   18 +++++++-----------
 include/asm-x86/io_apic.h    |   16 ----------------
 2 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 429889d..2d504fa 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1230,7 +1230,7 @@ static int setup_ioapic_entry(int apic, int irq,
 
 	entry->delivery_mode = INT_DELIVERY_MODE;
 	entry->dest_mode = INT_DEST_MODE;
-	entry->dest.logical.logical_dest = destination;
+	entry->dest = destination;
 
 	entry->mask = 0;                                /* enable IRQ */
 	entry->trigger = trigger;
@@ -1342,7 +1342,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1431,19 +1431,15 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Log Phy Mask Trig IRR Pol"
-			  " Stat Dest Deli Vect:   \n");
+	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+			  " Stat Dmod Deli Vect:   \n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X %02X  ",
-			i,
-			entry.dest.logical.logical_dest,
-			entry.dest.physical.physical_dest
-		);
+		printk(KERN_DEBUG " %02x %02X  ", i, entry.dest);
 
 		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
 			entry.mask,
@@ -1723,7 +1719,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest.physical.physical_dest = read_apic_id();
+		entry.dest	      = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -2188,7 +2184,7 @@ static inline void __init unlock_ExtINT_logic(void)
 
 	entry1.dest_mode = 0;			/* physical delivery */
 	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
+	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = 0;
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 3b297e4..bdb64c3 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -87,24 +87,8 @@ struct IO_APIC_route_entry {
 		mask		:  1,	/* 0: enabled, 1: disabled */
 		__reserved_2	: 15;
 
-#ifdef CONFIG_X86_32
-	union {
-		struct {
-			__u32	__reserved_1	: 24,
-				physical_dest	:  4,
-				__reserved_2	:  4;
-		} physical;
-
-		struct {
-			__u32	__reserved_1	: 24,
-				logical_dest	:  8;
-		} logical;
-	} dest;
-#else
 	__u32	__reserved_3	: 24,
 		dest		:  8;
-#endif
-
 } __attribute__ ((packed));
 
 struct IR_IO_APIC_route_entry {
-- 
1.5.4.5

