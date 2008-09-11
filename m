Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYIKONe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYIKONe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYIKONY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:13:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbYIKONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:13:23 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: efi vendor_reserved memory type
Cc: mingo@elte.hu
Message-Id: <E1KdmvN-0004KL-9J@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 11 Sep 2008 09:13:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Add an EFI_VENDOR_RESERVED memory type.
This supports memory available only to special devices. Such memory will
not be used as general RAM by the OS.

And add a method for a device driver to locate that memory. The walk()
function scans the EFI memory map and does a callback to a specified
function for each memory area of a specified type.
efi_memmap_walk_vr() is made available for a module to scan for
type EFI_VENDOR_RESERVED.

A UV driver will be posted later that will use these routines.

Diffed against 2.6.27-rc1-mm1-dirty

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/efi.h   |    3 ++-
 2 files changed, 38 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -568,3 +568,39 @@ u64 efi_mem_attributes(unsigned long phy
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
+ * descriptor of type VENDOR_RESERVED.
+ */
+void
+efi_memmap_walk_vr(efi_freemem_callback_t callback, void *arg)
+{
+	walk(callback, arg, EFI_VENDOR_RESERVED);
+}
+
+EXPORT_SYMBOL_GPL(efi_memmap_walk_vr);
Index: linux/include/linux/efi.h
===================================================================
--- linux.orig/include/linux/efi.h
+++ linux/include/linux/efi.h
@@ -77,7 +77,8 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO		11
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
-#define EFI_MAX_MEMORY_TYPE		14
+#define EFI_VENDOR_RESERVED		14
+#define EFI_MAX_MEMORY_TYPE		15
 
 /* Attribute values: */
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
