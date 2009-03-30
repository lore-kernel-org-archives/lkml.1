Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZC3Vc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZC3Vc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZC3Vcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:32:48 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42499 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752982AbZC3Vcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:32:47 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: access to efi reserved memory type
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1LoP6G-0001i2-N4@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 30 Mar 2009 16:32:56 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

Replaces version 1 of this patch:
http://marc.info/?l=linux-kernel&m=123792413205578&w=2

Create a new e820 memory type (E820_VENDOR_RESERVED) for areas
of memory reserved by the BIOS.
(An example use of this functionality is the coming UV system, which
 will access extremely large areas of memory with a memory engine
 that allows a user to address beyond the processor's range.)

The EFI type EFI_RESERVED_TYPE memory reservations are passed to the
e820 table as type E820_VENDOR_RESERVED ranges.

[The elilo loader may combine regions of like type as it builds the e820
 table in boot_params (regular RAM and vendor reserved areas are combined).
 But do_add_efi_memmap() separates the RESERVED regions into separate
 e820 entries.]

The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
on the kernel command line.

This patch also provides an exported function to allow a driver to find e820
entries of a specified type.

[
 Version 1 accessed these regions from the EFI table.  A major problem with
 that patch is that if "add_efi_memmap" is not specified on the boot command
 line, the EFI table is not merged into the e820, so the kernel also uses
 these regions for regular memory.  Then subsequent use of the regions by
 the driver corrupts system or user memory, which causes a head-scratcher
 of a panic or of user exceptions.
 With this version no reserved regions are visible to the calling driver
 if that boot option is not specified.
]

Diffed against 2.6.29-rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/e820.h |    2 ++
 arch/x86/kernel/e820.c      |   34 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/efi.c       |    4 +++-
 3 files changed, 38 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/e820.c
===================================================================
--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -74,6 +74,33 @@ e820_any_mapped(u64 start, u64 end, unsi
 EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
+ * This function returns the start (and end) of any range lying within the
+ * range <start,end> of a given type.
+ * Returns 0xffffffffffffffff if there is no such range of that type.
+ */
+u64
+e820_mapped_type(u64 start, u64 end, unsigned type, u64 *returned_end)
+{
+	int i;
+
+	if (returned_end == NULL)
+		return 0xffffffffffffffffUL;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (type && ei->type != type)
+			continue;
+		if (ei->addr >= end || ei->addr + ei->size <= start)
+			continue;
+		*returned_end = ei->addr + ei->size;
+		return ei->addr;;
+	}
+	return 0xffffffffffffffffUL;
+}
+EXPORT_SYMBOL_GPL(e820_mapped_type);
+
+/*
  * This function checks if the entire range <start,end> is mapped with type.
  *
  * Note: this function only works correct if the e820 table is sorted and
@@ -142,6 +169,9 @@ void __init e820_print_map(char *who)
 		case E820_RESERVED:
 			printk(KERN_CONT "(reserved)\n");
 			break;
+		case E820_VENDOR_RESERVED:
+			printk(KERN_CONT "(vendor reserved)\n");
+			break;
 		case E820_ACPI:
 			printk(KERN_CONT "(ACPI data)\n");
 			break;
@@ -343,8 +373,10 @@ int __init sanitize_e820_map(struct e820
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
@@ -68,6 +69,7 @@ extern struct e820map e820_saved;
 
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
+extern u64 e820_mapped_type(u64 start, u64 end, unsigned type, u64 *ret_end);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
