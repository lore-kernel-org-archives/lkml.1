Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYDENuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYDENuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYDENuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:12 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:52619 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYDENuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=m8+qbLtP8H9uF+oLBuxPKOzdnQt3Nez9MjkDyHT5xPU/Wa3Wtxs+9GCfsiMjG6+PDftrpTsOOTCGNUVV1WCvY8RLpg6T2u4H7CsplX7Taxng+2FuxDYvXFIOUjOahKnHbbVKO92eSLXu30UgXzPfoh8Tbo7LDEIdNyiOo4Y7jvw=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:05 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 2/9] x86: use ioapic_read_entry() and ioapic_write_entry()
Content-Disposition: inline; filename=x86-use-ioapic_write_entry.patch
Message-ID: <47f78390.0c86460a.1ef8.7960@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code by using ioapic_read_entry() and ioapic_write_entry()
in io_apic_{32,64}.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |   10 ++--------
 arch/x86/kernel/io_apic_64.c |   25 ++++++-------------------
 2 files changed, 8 insertions(+), 27 deletions(-)

Index: 2.6-git/arch/x86/kernel/io_apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_64.c
+++ 2.6-git/arch/x86/kernel/io_apic_64.c
@@ -905,9 +905,8 @@ static void __init setup_IO_APIC_irqs(vo
 static void __init setup_ExtINT_IRQ0_pin(unsigned int apic, unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
-	unsigned long flags;
 
-	memset(&entry,0,sizeof(entry));
+	memset(&entry, 0, sizeof(entry));
 
 	disable_8259A_irq(0);
 
@@ -935,10 +934,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	/*
 	 * Add it to the IO-APIC irq-routing table:
 	 */
-	spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x11+2*pin, *(((int *)&entry)+1));
-	io_apic_write(apic, 0x10+2*pin, *(((int *)&entry)+0));
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	ioapic_write_entry(apic, pin, entry);
 
 	enable_8259A_irq(0);
 }
@@ -1600,17 +1596,14 @@ static inline void unlock_ExtINT_logic(v
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
 	unsigned char save_control, save_freq_select;
-	unsigned long flags;
 
 	pin  = find_isa_irq_pin(8, mp_INT);
 	apic = find_isa_irq_apic(8, mp_INT);
 	if (pin == -1)
 		return;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
-	*(((int *)&entry0) + 1) = io_apic_read(apic, 0x11 + 2 * pin);
-	*(((int *)&entry0) + 0) = io_apic_read(apic, 0x10 + 2 * pin);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	entry0 = ioapic_read_entry(apic, pin);
+
 	clear_IO_APIC_pin(apic, pin);
 
 	memset(&entry1, 0, sizeof(entry1));
@@ -1623,10 +1616,7 @@ static inline void unlock_ExtINT_logic(v
 	entry1.trigger = 0;
 	entry1.vector = 0;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x11 + 2 * pin, *(((int *)&entry1) + 1));
-	io_apic_write(apic, 0x10 + 2 * pin, *(((int *)&entry1) + 0));
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	ioapic_write_entry(apic, pin, entry1);
 
 	save_control = CMOS_READ(RTC_CONTROL);
 	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
@@ -1645,10 +1635,7 @@ static inline void unlock_ExtINT_logic(v
 	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
 	clear_IO_APIC_pin(apic, pin);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x11 + 2 * pin, *(((int *)&entry0) + 1));
-	io_apic_write(apic, 0x10 + 2 * pin, *(((int *)&entry0) + 0));
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	ioapic_write_entry(apic, pin, entry0);
 }
 
 /*
Index: 2.6-git/arch/x86/kernel/io_apic_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_32.c
+++ 2.6-git/arch/x86/kernel/io_apic_32.c
@@ -1260,7 +1260,6 @@ static void __init setup_IO_APIC_irqs(vo
 {
 	struct IO_APIC_route_entry entry;
 	int apic, pin, idx, irq, first_notcon = 1, vector;
-	unsigned long flags;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1326,9 +1325,7 @@ static void __init setup_IO_APIC_irqs(vo
 			if (!apic && (irq < 16))
 				disable_8259A_irq(irq);
 		}
-		spin_lock_irqsave(&ioapic_lock, flags);
-		__ioapic_write_entry(apic, pin, entry);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		ioapic_write_entry(apic, pin, entry);
 	}
 	}
 
@@ -2789,7 +2786,6 @@ int __init io_apic_get_redir_entries (in
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int active_high_low)
 {
 	struct IO_APIC_route_entry entry;
-	unsigned long flags;
 
 	if (!IO_APIC_IRQ(irq)) {
 		printk(KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -2830,9 +2826,7 @@ int io_apic_set_pci_routing (int ioapic,
 	if (!ioapic && (irq < 16))
 		disable_8259A_irq(irq);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__ioapic_write_entry(ioapic, pin, entry);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	ioapic_write_entry(ioapic, pin, entry);
 
 	return 0;
 }

-- 
