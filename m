Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZIPN50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZIPN50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZIPN5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:57:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42627 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZIPN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:57:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       David Howells <dhowells@redhat.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] NOMMU: add support for Memory Protection Units (MPU)
Date: Wed, 16 Sep 2009 09:57:10 -0400
Message-Id: <1253109430-4732-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1247581340-20031-1-git-send-email-vapier@gentoo.org>
References: <1247581340-20031-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

Some architectures (like the Blackfin arch) implement some of the
"simpler" features that one would expect out of a MMU such as memory
protection.  In our case, we actually get read/write/exec protection
down to the page boundary so processes can't stomp on each other let
alone the kernel.  There is a performance decrease (which depends greatly
on the workload) however as the hardware/software interaction was not
optimized at design time.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David Howells <dhowells@redhat.com>
---
 kernel/module.c |    5 +++++
 mm/nommu.c      |   21 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 05ce49c..90af6a1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -47,6 +47,7 @@
 #include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
@@ -1535,6 +1536,10 @@ static void free_module(struct module *mod)
 
 	/* Finally, free the core (containing the module structure) */
 	module_free(mod, mod->module_core);
+
+#ifdef CONFIG_MPU
+	update_protections(current->mm);
+#endif
 }
 
 void *__symbol_get(const char *symbol)
diff --git a/mm/nommu.c b/mm/nommu.c
index 66e81e7..b73f4be 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -33,6 +33,7 @@
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
 #include "internal.h"
 
 static inline __attribute__((format(printf, 1, 2)))
@@ -627,6 +628,22 @@ static void put_nommu_region(struct vm_region *region)
 }
 
 /*
+ * update protection on a vma
+ */
+static void protect_vma(struct vm_area_struct *vma, unsigned long flags)
+{
+#ifdef CONFIG_MPU
+	struct mm_struct *mm = vma->vm_mm;
+	long start = vma->vm_start & PAGE_MASK;
+	while (start < vma->vm_end) {
+		protect_page(mm, start, flags);
+		start += PAGE_SIZE;
+	}
+	update_protections(mm);
+#endif
+}
+
+/*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
  * page
@@ -645,6 +662,8 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 	mm->map_count++;
 	vma->vm_mm = mm;
 
+	protect_vma(vma, vma->vm_flags);
+
 	/* add the VMA to the mapping */
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
@@ -707,6 +726,8 @@ static void delete_vma_from_mm(struct vm_area_struct *vma)
 
 	kenter("%p", vma);
 
+	protect_vma(vma, 0);
+
 	mm->map_count--;
 	if (mm->mmap_cache == vma)
 		mm->mmap_cache = NULL;
-- 
1.6.5.rc1

