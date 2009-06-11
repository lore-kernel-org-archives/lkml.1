Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZFKO0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZFKO0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZFKO0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:26:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42580 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbZFKO0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:26:30 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: vendor reserved memory type
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1MElFX-0007fY-TR@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 11 Jun 2009 09:27:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Create a new e820 memory type (E820_VENDOR_RESERVED) for areas
of memory reserved by the BIOS in the EFI table.

(An example use of this functionality is the UV system, which
 will access extremely large areas of memory with a memory engine
 that allows a user to address beyond the processor's range.  Such
 areas are reserved in the EFI table by the BIOS.)

Without this patch the EFI_RESERVED_TYPE memory reservations will be
marked usable in the e820 table. There will be a collision between
kernel use and reserver's use of this memory.

This patch causes the EFI_RESERVED_TYPE memory reservations to be recorded
in the e820 table as new type E820_VENDOR_RESERVED.
This patch makes sanitize_e820_map() preserve E820_VENDOR_RESERVED types
as separate entries.

[The elilo loader may combine regions of like type as it builds the e820
 table in boot_params (regular RAM and vendor reserved areas are combined).
 But this patch makes do_add_efi_memmap() separate the RESERVED regions
 into separate e820 entries.
 Some loaders have a restricted number of entries possible in the e820 table,
 hence the need to record the reservations in the unrestricted EFI table.]
The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
on the kernel command line.

Diffed against 2.6.30-rc8

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |    7 ++++++-
 arch/x86/kernel/efi.c       |    4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/e820.c
===================================================================
--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -141,6 +141,9 @@ static void __init e820_print_type(u32 t
 	case E820_RESERVED:
 		printk(KERN_CONT "(reserved)");
 		break;
+	case E820_VENDOR_RESERVED:
+		printk(KERN_CONT "(vendor reserved)");
+		break;
 	case E820_ACPI:
 		printk(KERN_CONT "(ACPI data)");
 		break;
@@ -355,8 +358,10 @@ int __init sanitize_e820_map(struct e820
 		/*
 		 * continue building up new bios map based on this
 		 * information
+		 * (do not consolidate the E820_VENDOR_RESERVED ranges)
 		 */
-		if (current_type != last_type)	{
+		if ((current_type != last_type) ||
+		    (current_type == E820_VENDOR_RESERVED)) {
 			if (last_type != 0)	 {
 				new_bios[new_bios_entry].size =
 					change_point[chgidx]->addr - last_addr;
Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -240,7 +240,9 @@ static void __init do_add_efi_memmap(voi
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
 
-		if (md->attribute & EFI_MEMORY_WB)
+		if (md->type == EFI_RESERVED_TYPE)
+			e820_type = E820_VENDOR_RESERVED;
+		else if (md->attribute & EFI_MEMORY_WB)
 			e820_type = E820_RAM;
 		else
 			e820_type = E820_RESERVED;
Index: linux/arch/x86/include/asm/e820.h
===================================================================
--- linux.orig/arch/x86/include/asm/e820.h
+++ linux/arch/x86/include/asm/e820.h
@@ -44,6 +44,7 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 #define E820_UNUSABLE	5
+#define E820_VENDOR_RESERVED 6
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
