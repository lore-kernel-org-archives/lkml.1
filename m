Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZCFRqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZCFRqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZCFRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:46:42 -0500
Received: from relay3.sgi.com ([192.48.171.31]:35014 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753104AbZCFRql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:46:41 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: access to efi reserved memory type
Cc: mingo@elte.hu
Message-Id: <E1Lfe8A-00056c-SH@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 06 Mar 2009 11:46:42 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

 (this patch dates back to 2008-11-06
    http://marc.info/?l=linux-kernel&m=122600658522471&w=2
  but has never been applied.)

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

Tested on 2.6.29-rc7 (and many previous versions) running on a
UV hardware simulator.

Diffed against 2.6.29-rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -579,3 +579,39 @@ u64 efi_mem_attributes(unsigned long phy
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
