Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYKLAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYKLAct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYKLA0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYKLA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:21 -0500
Message-ID: <491A225F.4090407@zytor.com>
Date: Tue, 11 Nov 2008 16:25:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Avi Kivity <avi@redhat.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Attempt rebooting via port CF9 if it seems to be available
References: <007e7d616a5d1c2e16ad627d03f8b97799445e71.1226032943.git.len.brown@intel.com> <200811080930.21462.arvidjaar@mail.ru> <alpine.LFD.2.00.0811080208590.3092@localhost.localdomain> <200811081050.25477.arvidjaar@mail.ru> <20081108115956.GE8354@elte.hu> <4916B38B.7050905@redhat.com> <4916B4DB.90602@zytor.com> <20081110083938.GD22392@elte.hu> <20081110115732.GA30181@srcf.ucam.org> <20081110125630.GC28643@elte.hu> <20081110130029.GC30894@srcf.ucam.org> <alpine.LFD.2.00.0811111802440.4480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811111802440.4480@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------070803000805070905080002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070803000805070905080002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looking at doing the port CF9 fallback, I stumbled onto something fishy.

I wonder if anyone here happens to have any idea why we turn off
caching in machine_real_restart()?  Jumping to the BIOS is *not* a
reset; we jump to the decompressed BIOS on low memory which is usually
shadowed, not to the BIOS entry point.  In that way, it's more of an
INIT than a reset, and disabling caching seems broken.

Either way, here is a preliminary patch to do the CF9 if safe, and then
falling back to keyboard reboot.  I'm a bit concerned about how to test
it, of course; this stuff is sensitive and just about impossible to test
except on millions of machines at once...

If you have any machines (especially problematic ones) and find that
this patch either helps or hurts or do nothing, please do let me know so
I have any idea of the extent of coverage.

	-hpa


--------------070803000805070905080002
Content-Type: text/x-patch;
 name="0001-x86-attempt-reboot-via-port-CF9-if-we-have-standard.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-attempt-reboot-via-port-CF9-if-we-have-standard.pat";
 filename*1="ch"

>From 14d7ca5c575853664d8fe4f225a77b8df1b7de7d Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 11 Nov 2008 16:19:48 -0800
Subject: [PATCH] x86: attempt reboot via port CF9 if we have standard PCI ports

Impact: Changes reboot behavior.

If port CF9 seems to be safe to touch, attempt it before trying the
keyboard controller.  Port CF9 is not available on all chipsets (a
significant but decreasing number of modern chipsets don't implement
it), but port CF9 itself should in general be safe to poke (no ill
effects if unimplemented) on any system which has PCI Configuration
Method #1 or #2, as it falls inside the PCI configuration port range
in both cases.  No chipset without PCI is known to have port CF9,
either, although an explicit "pci=bios" would mean we miss this and
therefore don't use port CF9.  An explicit "reboot=pci" can be used to
force the use of port CF9.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/emergency-restart.h |    4 ++-
 arch/x86/kernel/reboot.c                 |   34 +++++++++++++++++++++++------
 arch/x86/pci/direct.c                    |    4 ++-
 arch/x86/pci/pci.h                       |    1 +
 4 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/emergency-restart.h b/arch/x86/include/asm/emergency-restart.h
index 94826cf..cc70c1c 100644
--- a/arch/x86/include/asm/emergency-restart.h
+++ b/arch/x86/include/asm/emergency-restart.h
@@ -8,7 +8,9 @@ enum reboot_type {
 	BOOT_BIOS = 'b',
 #endif
 	BOOT_ACPI = 'a',
-	BOOT_EFI = 'e'
+	BOOT_EFI = 'e',
+	BOOT_CF9 = 'p',
+	BOOT_CF9_COND = 'q',
 };
 
 extern enum reboot_type reboot_type;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 34f8d37..ddc9389 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -29,14 +29,17 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_CF9_COND;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
 static int reboot_cpu = -1;
 #endif
 
-/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
+/* This is set by the PCI code if either type 1 or type 2 PCI is detected */
+bool port_cf9_safe = false;
+
+/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    bios   Reboot by jumping through the BIOS (only for X86_32)
@@ -45,6 +48,7 @@ static int reboot_cpu = -1;
    kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the RESET_REG in the FADT
    efi    Use efi reset_system runtime service
+   pci    Use the so-called "PCI reset register", CF9
    force  Avoid anything that could hang.
  */
 static int __init reboot_setup(char *str)
@@ -79,6 +83,7 @@ static int __init reboot_setup(char *str)
 		case 'k':
 		case 't':
 		case 'e':
+		case 'p':
 			reboot_type = *str;
 			break;
 
@@ -379,28 +384,43 @@ static void native_machine_emergency_restart(void)
 			load_idt(&no_idt);
 			__asm__ __volatile__("int3");
 
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
 #ifdef CONFIG_X86_32
 		case BOOT_BIOS:
 			machine_real_restart(jump_to_bios, sizeof(jump_to_bios));
 
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 #endif
 
 		case BOOT_ACPI:
 			acpi_reboot();
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
-
 		case BOOT_EFI:
 			if (efi_enabled)
-				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+				efi.reset_system(reboot_mode ?
+						 EFI_RESET_WARM :
+						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_CF9_COND;
+			break;
+
+		case BOOT_CF9:
+			port_cf9_safe = true;
+			/* fall through */
 
+		case BOOT_CF9_COND:
+			if (port_cf9_safe) {
+				u8 cf9 = inb(0xcf9) & ~6;
+				outb(cf9|2, 0xcf9); /* Request hard reset */
+				udelay(50);
+				outb(cf9|6, 0xcf9); /* Actually do the reset */
+				udelay(50);
+			}
 			reboot_type = BOOT_KBD;
 			break;
 		}
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 9915293..9a5af6c 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -173,7 +173,7 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 
 #undef PCI_CONF2_ADDRESS
 
-static struct pci_raw_ops pci_direct_conf2 = {
+struct pci_raw_ops pci_direct_conf2 = {
 	.read =		pci_conf2_read,
 	.write =	pci_conf2_write,
 };
@@ -289,6 +289,7 @@ int __init pci_direct_probe(void)
 
 	if (pci_check_type1()) {
 		raw_pci_ops = &pci_direct_conf1;
+		port_cf9_safe = true;
 		return 1;
 	}
 	release_resource(region);
@@ -305,6 +306,7 @@ int __init pci_direct_probe(void)
 
 	if (pci_check_type2()) {
 		raw_pci_ops = &pci_direct_conf2;
+		port_cf9_safe = true;
 		return 2;
 	}
 
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 15b9cf6..1959018 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -96,6 +96,7 @@ extern struct pci_raw_ops *raw_pci_ops;
 extern struct pci_raw_ops *raw_pci_ext_ops;
 
 extern struct pci_raw_ops pci_direct_conf1;
+extern bool port_cf9_safe;
 
 /* arch_initcall level */
 extern int pci_direct_probe(void);
-- 
1.5.6.5


--------------070803000805070905080002--
