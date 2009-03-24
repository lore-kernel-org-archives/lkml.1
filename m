Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZCXTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZCXTsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZCXTsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:48:04 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53790 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753566AbZCXTsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:48:03 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: access to efi reserved memory type
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1LmCbn-0000LR-Ih@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 24 Mar 2009 14:48:23 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

This patch allows a driver to find the addresses of a specified memory type.

This supports drivers that use vendor-specific memory, available
only to special devices. An upcoming example being a UV driver that
will allow users to map in and access extremely large areas of memory
that are beyond the processor's address range.

The efi_mapped_type() function provides starting/ending addresses of
any EFI memory range of a specified type.
To be used like this to find all such ranges:
     start = 0;
     end = HIGH_VALUE;
     while ((ret_start = efi_mapped_type(start, end, EFI_RESERVED_TYPE,
             &ret_end)) != HIGH_VALUE) {
         [ process ret_start and ret_end ]
         start = ret_end;
     }

The UV driver mentioned above will be posted to the community in the future.

An earlier version of this patch raised some objections because
1) it used a callback method, and 2) it interfaced to just the EFI table
and not the e820 table.
The callback method has been replaced with an iterative one.
But use of the e820 table here is a bit problematic.  That is because the
e820 table is limited in size (128 entries). The BIOS can make a virtually
unlimited number of EFI_RESERVED_TYPE entries. Then those entries can
be merged into the e820 table with a "add_efi_memmap" boot line option.
But there seems to be no way around requiring that option for a given
architecture, as the acpi tables are not available to test for machine
type until after efi_init().
Hence our desire to give the driver access to the EFI table.

Tested on 2.6.29-rc7 (and previous versions) running on a
UV hardware simulator.

Diffed against 2.6.29-rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/efi.h   |    2 +-
 2 files changed, 37 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -572,3 +572,39 @@ u64 efi_mem_attributes(unsigned long phy
 	}
 	return 0;
 }
+
+/*
+ * This function returns the start (and end) of any range lying within the
+ * range <start,end> of a given type.
+ * Returns 0xffffffffffffffff if there is no such range of that type.
+ */
+u64
+efi_mapped_type(u64 start, u64 end, unsigned type, u64 *returned_end)
+{
+	int size;
+	u64 range_end;
+	efi_memory_desc_t *md;
+	void *p;
+
+	if (returned_end == NULL)
+		return 0xffffffffffffffffUL;
+
+	/*
+	 * memmap.map is zeroed in efi_enter_virtual_mode()
+	 * but we can use the physical address (phys_map)
+	 */
+	size = memmap.nr_map*memmap.desc_size;
+	for (p = memmap.phys_map; p < memmap.phys_map+size;
+						p += memmap.desc_size) {
+		md = (efi_memory_desc_t *)__va(p);
+		if (md->type != type)
+			continue;
+		range_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if (md->phys_addr >= end || range_end <= start)
+			continue;
+		*returned_end = range_end;
+		return md->phys_addr;
+	}
+	return 0xffffffffffffffffUL;
+}
+EXPORT_SYMBOL_GPL(efi_mapped_type);
Index: linux/include/linux/efi.h
===================================================================
--- linux.orig/include/linux/efi.h
+++ linux/include/linux/efi.h
@@ -291,7 +291,7 @@ efi_guid_unparse(efi_guid_t *guid, char 
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
-extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
+extern u64 efi_mapped_type(u64 start, u64 end, unsigned type, u64 *returned_end);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 extern u64 efi_get_iobase (void);
