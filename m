Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCDJqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCDJqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZCDJqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:46:45 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40654 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZCDJqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:46:44 -0500
Subject: [PATCH] x86: devmem_is_allowed() to common mm/init.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Mar 2009 11:46:40 +0200
Message-Id: <1236160001.29024.29.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

The function is identical on 32-bit and 64-bit configurations so move it to the
common mm/init.c file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c    |   24 ++++++++++++++++++++++++
 arch/x86/mm/init_32.c |   21 ---------------------
 arch/x86/mm/init_64.c |   22 ----------------------
 3 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 201bf4a..cc7fe66 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1,9 +1,33 @@
+#include <linux/ioport.h>
 #include <linux/swap.h>
+
 #include <asm/cacheflush.h>
 #include <asm/page.h>
+#include <asm/page_types.h>
 #include <asm/sections.h>
 #include <asm/system.h>
 
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ *
+ * On x86, access has to be given to the first megabyte of ram because that area
+ * contains bios code and data regions used by X and dosemu and similar apps.
+ * Access has to be given to non-kernel-ram areas as well, these contain the PCI
+ * mmio resources as well as potential bios/acpi data regions.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	if (pagenr <= 256)
+		return 1;
+	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
+		return 0;
+	if (!page_is_ram(pagenr))
+		return 1;
+	return 0;
+}
+
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr = begin;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 49c65ee..f21336e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -354,27 +354,6 @@ repeat:
 	}
 }
 
-/*
- * devmem_is_allowed() checks to see if /dev/mem access to a certain address
- * is valid. The argument is a physical page number.
- *
- *
- * On x86, access has to be given to the first megabyte of ram because that area
- * contains bios code and data regions used by X and dosemu and similar apps.
- * Access has to be given to non-kernel-ram areas as well, these contain the PCI
- * mmio resources as well as potential bios/acpi data regions.
- */
-int devmem_is_allowed(unsigned long pagenr)
-{
-	if (pagenr <= 256)
-		return 1;
-	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
-		return 0;
-	if (!page_is_ram(pagenr))
-		return 1;
-	return 0;
-}
-
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8df5919..8a85dbd 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -874,28 +874,6 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-/*
- * devmem_is_allowed() checks to see if /dev/mem access to a certain address
- * is valid. The argument is a physical page number.
- *
- *
- * On x86, access has to be given to the first megabyte of ram because that area
- * contains bios code and data regions used by X and dosemu and similar apps.
- * Access has to be given to non-kernel-ram areas as well, these contain the PCI
- * mmio resources as well as potential bios/acpi data regions.
- */
-int devmem_is_allowed(unsigned long pagenr)
-{
-	if (pagenr <= 256)
-		return 1;
-	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
-		return 0;
-	if (!page_is_ram(pagenr))
-		return 1;
-	return 0;
-}
-
-
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
 			 kcore_modules, kcore_vsyscall;
 
-- 
1.5.4.3



