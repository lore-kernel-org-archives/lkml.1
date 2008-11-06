Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYKFVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYKFVVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYKFVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:21:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43816 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754098AbYKFVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:21:22 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: access to efi reserved memory type
Cc: mingo@elte.hu
Message-Id: <E1KyCJW-0002lH-08@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 06 Nov 2008 15:22:50 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Give drivers addresses of memory type EFI_RESERVED_TYPE.
This supports drivers that use vendor-specific memory, available
only to special devices.

The walk() function scans the EFI memory map and does a callback to a
specified function for each memory area of a specified type.
efi_memmap_walk_reserved() provides a scan for type EFI_RESERVED_TYPE.

(an earlier version of this patch had proposed a new EFI type, but
 EFI_RESERVED_TYPE should be sufficient, given that the firmware follows
 the standard and does not use such memory for its own purposes)

A UV driver will be posted to the community in the future that will use
these routines.

Diffed against 2.6.27-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -572,3 +572,39 @@ u64 efi_mem_attributes(unsigned long phy
 	}
 	return 0;
 }
+
+static void
+walk(efi_freemem_callback_t callback, void *arg, int type)
+{
+	efi_memory_desc_t *md;
+	void *p;
+	int size;
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
+		if ((*callback)(md->phys_addr,
+		     md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
+		     arg) < 0)
+			return;
+	}
+}
+
+/*
+ * Walk the EFI memory map and call "callback" once for each EFI memory
+ * descriptor of type EFI_RESERVED_TYPE.
+ */
+void
+efi_memmap_walk_reserved(efi_freemem_callback_t callback, void *arg)
+{
+	walk(callback, arg, EFI_RESERVED_TYPE);
+}
+
+EXPORT_SYMBOL(efi_memmap_walk_reserved);
