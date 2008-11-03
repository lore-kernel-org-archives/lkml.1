Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYKCRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYKCRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYKCRKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:10:25 -0500
Received: from home.keithp.com ([63.227.221.253]:34177 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbYKCRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:10:24 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] Add io-mapping functions to dynamically map large device apertures
Date: Mon,  3 Nov 2008 09:09:58 -0800
Message-Id: <1225732199-21560-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225732199-21560-1-git-send-email-keithp@keithp.com>
References: <1225732199-21560-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graphics devices have large PCI apertures which would consume a significant
fraction of a 32-bit address space if mapped during driver initialization.
Using ioremap at runtime is impractical as it is too slow. This new set of
interfaces uses atomic mappings on 32-bit processors and a large static
mapping on 64-bit processors to provide reasonable 32-bit performance and
optimal 64-bit performance.

The current implementation sits atop the existing CONFIG_HIGHMEM kmap_atomic
mechanism for 32-bit processors when present. When absent, it just uses
ioremap, which remains horribly inefficient. Fixing non-HIGHMEM 32-bit
kernels to provide per-CPU mappings ala HIGHMEM would resolve that
performance issue.

This includes some editorial suggestions from Randy Dunlap for
Documentation/io-mapping.txt

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 Documentation/io-mapping.txt |   82 +++++++++++++++++++++++++++
 include/linux/io-mapping.h   |  125 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/io-mapping.txt
 create mode 100644 include/linux/io-mapping.h

diff --git a/Documentation/io-mapping.txt b/Documentation/io-mapping.txt
new file mode 100644
index 0000000..473e43b
--- /dev/null
+++ b/Documentation/io-mapping.txt
@@ -0,0 +1,82 @@
+The io_mapping functions in linux/io-mapping.h provide an abstraction for
+efficiently mapping small regions of an I/O device to the CPU. The initial
+usage is to support the large graphics aperture on 32-bit processors where
+ioremap_wc cannot be used to statically map the entire aperture to the CPU
+as it would consume too much of the kernel address space.
+
+A mapping object is created during driver initialization using
+
+	struct io_mapping *io_mapping_create_wc(unsigned long base,
+						unsigned long size)
+
+		'base' is the bus address of the region to be made
+		mappable, while 'size' indicates how large a mapping region to
+		enable. Both are in bytes.
+
+		This _wc variant provides a mapping which may only be used
+		with the io_mapping_map_atomic_wc or io_mapping_map_wc.
+
+With this mapping object, individual pages can be mapped either atomically
+or not, depending on the necessary scheduling environment. Of course, atomic
+maps are more efficient:
+
+	void *io_mapping_map_atomic_wc(struct io_mapping *mapping,
+				       unsigned long offset)
+
+		'offset' is the offset within the defined mapping region.
+		Accessing addresses beyond the region specified in the
+		creation function yields undefined results. Using an offset
+		which is not page aligned yields an undefined result. The
+		return value points to a single page in CPU address space.
+
+		This _wc variant returns a write-combining map to the
+		page and may only be used with mappings created by
+		io_mapping_create_wc
+
+		Note that the task may not sleep while holding this page
+		mapped.
+
+	void io_mapping_unmap_atomic(void *vaddr)
+
+		'vaddr' must be the the value returned by the last
+		io_mapping_map_atomic_wc call. This unmaps the specified
+		page and allows the task to sleep once again.
+
+If you need to sleep while holding the lock, you can use the non-atomic
+variant, although they may be significantly slower.
+
+	void *io_mapping_map_wc(struct io_mapping *mapping,
+				unsigned long offset)
+
+		This works like io_mapping_map_atomic_wc except it allows
+		the task to sleep while holding the page mapped.
+
+	void io_mapping_unmap(void *vaddr)
+
+		This works like io_mapping_unmap_atomic, except it is used
+		for pages mapped with io_mapping_map_wc.
+
+At driver close time, the io_mapping object must be freed:
+
+	void io_mapping_free(struct io_mapping *mapping)
+
+Current Implementation:
+
+The initial implementation of these functions uses existing mapping
+mechanisms and so provides only an abstraction layer and no new
+functionality.
+
+On 64-bit processors, io_mapping_create_wc calls ioremap_wc for the whole
+range, creating a permanent kernel-visible mapping to the resource. The
+map_atomic and map functions add the requested offset to the base of the
+virtual address returned by ioremap_wc.
+
+On 32-bit processors with HIGHMEM defined, io_mapping_map_atomic_wc uses
+kmap_atomic_pfn to map the specified page in an atomic fashion;
+kmap_atomic_pfn isn't really supposed to be used with device pages, but it
+provides an efficient mapping for this usage.
+
+On 32-bit processors without HIGHMEM defined, io_mapping_map_atomic_wc and
+io_mapping_map_wc both use ioremap_wc, a terribly inefficient function which
+performs an IPI to inform all processors about the new mapping. This results
+in a significant performance penalty.
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
new file mode 100644
index 0000000..82df317
--- /dev/null
+++ b/include/linux/io-mapping.h
@@ -0,0 +1,125 @@
+/*
+ * Copyright © 2008 Keith Packard <keithp@keithp.com>
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#ifndef _LINUX_IO_MAPPING_H
+#define _LINUX_IO_MAPPING_H
+
+#include <linux/types.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/iomap.h>
+
+/*
+ * The io_mapping mechanism provides an abstraction for mapping
+ * individual pages from an io device to the CPU in an efficient fashion.
+ *
+ * See Documentation/io_mapping.txt
+ */
+
+/* this struct isn't actually defined anywhere */
+struct io_mapping;
+
+#ifdef CONFIG_HAVE_ATOMIC_IOMAP
+
+/*
+ * For small address space machines, mapping large objects
+ * into the kernel virtual space isn't practical. Where
+ * available, use fixmap support to dynamically map pages
+ * of the object at run time.
+ */
+
+static inline struct io_mapping *
+io_mapping_create_wc(unsigned long base, unsigned long size)
+{
+	return (struct io_mapping *) base;
+}
+
+static inline void
+io_mapping_free(struct io_mapping *mapping)
+{
+}
+
+/* Atomic map/unmap */
+static inline void *
+io_mapping_map_atomic_wc(struct io_mapping *mapping, unsigned long offset)
+{
+	offset += (unsigned long) mapping;
+	return iomap_atomic_prot_pfn(offset >> PAGE_SHIFT, KM_USER0,
+				     __pgprot(__PAGE_KERNEL_WC));
+}
+
+static inline void
+io_mapping_unmap_atomic(void *vaddr)
+{
+	iounmap_atomic(vaddr, KM_USER0);
+}
+
+static inline void *
+io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
+{
+	offset += (unsigned long) mapping;
+	return ioremap_wc(offset, PAGE_SIZE);
+}
+
+static inline void
+io_mapping_unmap(void *vaddr)
+{
+	iounmap(vaddr);
+}
+
+#else
+
+/* Create the io_mapping object*/
+static inline struct io_mapping *
+io_mapping_create_wc(unsigned long base, unsigned long size)
+{
+	return (struct io_mapping *) ioremap_wc(base, size);
+}
+
+static inline void
+io_mapping_free(struct io_mapping *mapping)
+{
+	iounmap(mapping);
+}
+
+/* Atomic map/unmap */
+static inline void *
+io_mapping_map_atomic_wc(struct io_mapping *mapping, unsigned long offset)
+{
+	return ((char *) mapping) + offset;
+}
+
+static inline void
+io_mapping_unmap_atomic(void *vaddr)
+{
+}
+
+/* Non-atomic map/unmap */
+static inline void *
+io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
+{
+	return ((char *) mapping) + offset;
+}
+
+static inline void
+io_mapping_unmap(void *vaddr)
+{
+}
+
+#endif /* HAVE_ATOMIC_IOMAP */
+
+#endif /* _LINUX_IO_MAPPING_H */
-- 
1.5.6.5

