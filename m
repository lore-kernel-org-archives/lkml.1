Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbZFQTWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbZFQTWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZFQTWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:22:48 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54996 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773AbZFQTWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:22:47 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH][REVISED] x86: efi/e820 table merge fix
Cc: mingo@elte.hu, hpa@zytor.com, ying.huang@intel.com, yinghai@kernel.org
Message-Id: <E1MH0jo-0001Kp-O3@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 17 Jun 2009 14:24:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

This patch causes all the RAM reservations of EFI_RESERVED_TYPE
to be recorded in the e820 table as type E820_RESERVED.

(A bit of clarification was added in the comment, per Peter and Huang.)

Without this patch EFI_RESERVED_TYPE memory reservations that are also
of attribute type EFI_MEMORY_WB are marked usable in the e820 table.
That would cause a collision between kernel use and some reserver's use
of this memory.

(An example use of this functionality is the UV system, which
 will access extremely large areas of (write-back) memory with a memory
 engine that allows a user to address beyond the processor's range.
 Such areas are reserved in the EFI table by the BIOS.
 Some loaders have a restricted number of entries possible in the e820 table,
 hence the need to record the reservations in the unrestricted EFI table.)

The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
on the kernel command line.

Diffed against 2.6.30-rc8

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -240,10 +240,39 @@ static void __init do_add_efi_memmap(voi
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
 
-		if (md->attribute & EFI_MEMORY_WB)
-			e820_type = E820_RAM;
-		else
+		switch (md->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			/*
+			 * make sure that memory that is not write-back does
+			 * not enter the usable memory pool
+			 */
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			break;
+		case EFI_ACPI_RECLAIM_MEMORY:
+			e820_type = E820_ACPI;
+			break;
+		case EFI_ACPI_MEMORY_NVS:
+			e820_type = E820_NVS;
+			break;
+		case EFI_UNUSABLE_MEMORY:
+			e820_type = E820_UNUSABLE;
+			break;
+		default:
+			/*
+			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
+			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
+			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
+			 */
 			e820_type = E820_RESERVED;
+			break;
+		}
 		e820_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
