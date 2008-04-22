Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbYDVPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbYDVPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759124AbYDVP3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:29:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16280 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbYDVP3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:29:45 -0400
Message-Id: <480E2093.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:29:55 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: constify data in reboot.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/reboot.c           |   18 +++++++++---------
 arch/x86/kernel/reboot_fixups_32.c |    4 ++--
 include/asm-x86/reboot.h           |    2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

--- linux-2.6.25/arch/x86/kernel/reboot.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-reboot-const/arch/x86/kernel/reboot.c	2008-04-02 15:26:49.000000000 +0200
@@ -27,7 +27,7 @@
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-static long no_idt[3];
+static const struct desc_ptr no_idt = {};
 static int reboot_mode;
 enum reboot_type reboot_type = BOOT_KBD;
 int reboot_force;
@@ -202,15 +202,15 @@ core_initcall(reboot_init);
    controller to pulse the CPU reset line, which is more thorough, but
    doesn't work with at least one type of 486 motherboard.  It is easy
    to stop this code working; hence the copious comments. */
-static unsigned long long
+static const unsigned long long
 real_mode_gdt_entries [3] =
 {
 	0x0000000000000000ULL,	/* Null descriptor */
-	0x00009a000000ffffULL,	/* 16-bit real-mode 64k code at 0x00000000 */
-	0x000092000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
+	0x00009b000000ffffULL,	/* 16-bit real-mode 64k code at 0x00000000 */
+	0x000093000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
 };
 
-static struct desc_ptr
+static const struct desc_ptr
 real_mode_gdt = { sizeof (real_mode_gdt_entries) - 1, (long)real_mode_gdt_entries },
 real_mode_idt = { 0x3ff, 0 };
 
@@ -232,7 +232,7 @@ real_mode_idt = { 0x3ff, 0 };
 
    More could be done here to set up the registers as if a CPU reset had
    occurred; hopefully real BIOSs don't assume much. */
-static unsigned char real_mode_switch [] =
+static const unsigned char real_mode_switch [] =
 {
 	0x66, 0x0f, 0x20, 0xc0,			/*    movl  %cr0,%eax        */
 	0x66, 0x83, 0xe0, 0x11,			/*    andl  $0x00000011,%eax */
@@ -246,7 +246,7 @@ static unsigned char real_mode_switch []
 	0x24, 0x10,				/* f: andb  $0x10,al         */
 	0x66, 0x0f, 0x22, 0xc0			/*    movl  %eax,%cr0        */
 };
-static unsigned char jump_to_bios [] =
+static const unsigned char jump_to_bios [] =
 {
 	0xea, 0x00, 0x00, 0xff, 0xff		/*    ljmp  $0xffff,$0x0000  */
 };
@@ -256,7 +256,7 @@ static unsigned char jump_to_bios [] =
  * specified by the code and length parameters.
  * We assume that length will aways be less that 100!
  */
-void machine_real_restart(unsigned char *code, int length)
+void machine_real_restart(const unsigned char *code, int length)
 {
 	local_irq_disable();
 
@@ -369,7 +369,7 @@ static void native_machine_emergency_res
 			}
 
 		case BOOT_TRIPLE:
-			load_idt((const struct desc_ptr *)&no_idt);
+			load_idt(&no_idt);
 			__asm__ __volatile__("int3");
 
 			reboot_type = BOOT_KBD;
--- linux-2.6.25/arch/x86/kernel/reboot_fixups_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-reboot-const/arch/x86/kernel/reboot_fixups_32.c	2008-04-08 10:04:36.000000000 +0200
@@ -49,7 +49,7 @@ struct device_fixup {
 	void (*reboot_fixup)(struct pci_dev *);
 };
 
-static struct device_fixup fixups_table[] = {
+static const struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 { PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE, cs5530a_warm_reset },
@@ -64,7 +64,7 @@ static struct device_fixup fixups_table[
  */
 void mach_reboot_fixups(void)
 {
-	struct device_fixup *cur;
+	const struct device_fixup *cur;
 	struct pci_dev *dev;
 	int i;
 
--- linux-2.6.25/include/asm-x86/reboot.h	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.25-x86-reboot-const/include/asm-x86/reboot.h	2008-04-02 15:26:49.000000000 +0200
@@ -15,6 +15,6 @@ struct machine_ops
 
 extern struct machine_ops machine_ops;
 
-void machine_real_restart(unsigned char *code, int length);
+void machine_real_restart(const unsigned char *code, int length);
 
 #endif	/* _ASM_REBOOT_H */


