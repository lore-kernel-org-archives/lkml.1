Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZFPVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZFPVmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbZFPVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:42:29 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757283AbZFPVm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:42:28 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: efi/e820 table merge fix
Cc: mingo@elte.hu, hpa@zytor.com, ying.huang@intel.com, yinghai@kernel.org
Message-Id: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 16 Jun 2009 16:43:40 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

This patch causes all the EFI_RESERVED_TYPE memory reservations to be recorded
in the e820 table as type E820_RESERVED.

(This patch replaces one called 'x86: vendor reserved memory type'.
 This version has been discussed a bit with Peter and Yinghai but not given
 a final opinion.)

Without this patch EFI_RESERVED_TYPE memory reservations may be
marked usable in the e820 table. There may be a collision between
kernel use and some reserver's use of this memory.

(An example use of this functionality is the UV system, which
 will access extremely large areas of memory with a memory engine
 that allows a user to address beyond the processor's range.  Such
 areas are reserved in the EFI table by the BIOS.
 Some loaders have a restricted number of entries possible in the e820 table,
 hence the need to record the reservations in the unrestricted EFI table.)

The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
on the kernel command line.

Diffed against 2.6.30-rc8

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -240,10 +240,35 @@ static void __init do_add_efi_memmap(voi
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
