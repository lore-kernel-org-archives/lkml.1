Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYCQUaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYCQUaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYCQU3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:29:53 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56582 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYCQU3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:29:52 -0400
Date: Mon, 17 Mar 2008 22:29:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: remove the write-only timer_uses_ioapic_pin_0
Message-ID: <20080317202932.GD9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the write-only timer_uses_ioapic_pin_0
(gsi can't be <= 15 in the line of it's fake usage in mpparse_32.c).

Spotted by the GNU C compiler.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/io_apic_32.c |    5 -----
 arch/x86/kernel/mpparse_32.c |    3 +--
 include/asm-x86/io_apic.h    |    1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

5869ec6906fdb6d786284c599c862061f601ac6a diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 4ca5486..fb1e378 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2156,8 +2156,6 @@ static inline void unlock_ExtINT_logic(void)
 	ioapic_write_entry(apic, pin, entry0);
 }
 
-int timer_uses_ioapic_pin_0;
-
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2197,9 +2195,6 @@ static inline void __init check_timer(void)
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	if (pin1 == 0)
-		timer_uses_ioapic_pin_0 = 1;
-
 	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		vector, apic1, pin1, apic2, pin2);
 
diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index f349e68..07c5ee2 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -1115,8 +1115,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 			 * So test for this condition, and if necessary, avoid
 			 * the pin collision.
 			 */
-			if (gsi > 15 || (gsi == 0 && !timer_uses_ioapic_pin_0))
-				gsi = pci_irq++;
+			gsi = pci_irq++;
 			/*
 			 * Don't assign IRQ used by ACPI SCI
 			 */
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 0f5b3fe..095e8e3 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -146,7 +146,6 @@ extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
 extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
 				   int edge_level, int active_high_low);
-extern int timer_uses_ioapic_pin_0;
 #endif /* CONFIG_ACPI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);

