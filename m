Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbYDBSg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbYDBSg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYDBSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:38 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38397 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754151AbYDBSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:35 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 14:35:31 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 24] xen: make grant table arch portable
X-Mercurial-Node: 66b5bbca0b7013c4d78e25830a115d63657c0c24
Message-Id: <66b5bbca0b7013c4d78e.1207158840@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

split out x86 specific part from grant-table.c and
allow ia64/xen specific initialization.
ia64/xen grant table is based on pseudo physical address
(guest physical address) unlike x86/xen. On ia64 init_mm
doesn't map identity straight mapped area.
ia64/xen specific grant table initialization is necessary.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/Makefile      |    2
 arch/x86/xen/grant-table.c |   91 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/grant-table.c  |   35 +---------------
 include/xen/grant_table.h  |    7 ++-
 4 files changed, 101 insertions(+), 34 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			time.o manage.o xen-asm.o
+			time.o manage.o xen-asm.o grant-table.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/grant-table.c
@@ -0,0 +1,91 @@
+/******************************************************************************
+ * grant_table.c
+ * x86 specific part
+ *
+ * Granting foreign access to our memory reservation.
+ *
+ * Copyright (c) 2005-2006, Christopher Clark
+ * Copyright (c) 2004-2005, K A Fraser
+ * Copyright (c) 2008 Isaku Yamahata <yamahata at valinux co jp>
+ *                    VA Linux Systems Japan. Split out x86 specific part.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+
+#include <xen/interface/xen.h>
+#include <xen/page.h>
+#include <xen/grant_table.h>
+
+#include <asm/pgtable.h>
+
+static int map_pte_fn(pte_t *pte, struct page *pmd_page,
+		      unsigned long addr, void *data)
+{
+	unsigned long **frames = (unsigned long **)data;
+
+	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+	(*frames)++;
+	return 0;
+}
+
+static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
+			unsigned long addr, void *data)
+{
+
+	set_pte_at(&init_mm, addr, pte, __pte(0));
+	return 0;
+}
+
+int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   struct grant_entry **__shared)
+{
+	int rc;
+	struct grant_entry *shared = *__shared;
+
+	if (shared == NULL) {
+		struct vm_struct *area =
+			xen_alloc_vm_area(PAGE_SIZE * max_nr_gframes);
+		BUG_ON(area == NULL);
+		shared = area->addr;
+		*__shared = shared;
+	}
+
+	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
+				 PAGE_SIZE * nr_gframes,
+				 map_pte_fn, &frames);
+	return rc;
+}
+
+void arch_gnttab_unmap_shared(struct grant_entry *shared,
+			      unsigned long nr_gframes)
+{
+	apply_to_page_range(&init_mm, (unsigned long)shared,
+			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
+}
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -435,24 +435,6 @@
 	return xen_max;
 }
 
-static int map_pte_fn(pte_t *pte, struct page *pmd_page,
-		      unsigned long addr, void *data)
-{
-	unsigned long **frames = (unsigned long **)data;
-
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
-	return 0;
-}
-
-static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
-			unsigned long addr, void *data)
-{
-
-	set_pte_at(&init_mm, addr, pte, __pte(0));
-	return 0;
-}
-
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
@@ -476,17 +458,9 @@
 
 	BUG_ON(rc || setup.status);
 
-	if (shared == NULL) {
-		struct vm_struct *area;
-		area = xen_alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
-		BUG_ON(area == NULL);
-		shared = area->addr;
-	}
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn, &frames);
+	rc = arch_gnttab_map_shared(frames, nr_gframes, max_nr_grant_frames(),
+				    &shared);
 	BUG_ON(rc);
-	frames -= nr_gframes; /* adjust after map_pte_fn() */
 
 	kfree(frames);
 
@@ -502,10 +476,7 @@
 
 static int gnttab_suspend(void)
 {
-	apply_to_page_range(&init_mm, (unsigned long)shared,
-			    PAGE_SIZE * nr_grant_frames,
-			    unmap_pte_fn, NULL);
-
+	arch_gnttab_unmap_shared(shared, nr_grant_frames);
 	return 0;
 }
 
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -103,6 +103,12 @@
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
 
+int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   struct grant_entry **__shared);
+void arch_gnttab_unmap_shared(struct grant_entry *shared,
+			      unsigned long nr_gframes);
+
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 #endif /* __ASM_GNTTAB_H__ */


