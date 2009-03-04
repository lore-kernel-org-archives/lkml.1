Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZCDLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZCDLH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZCDLHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:07:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZCDLHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:07:09 -0500
Date: Wed, 4 Mar 2009 11:06:35 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236160001.29024.29.camel@penberg-laptop>
References: <1236160001.29024.29.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: move devmem_is_allowed() to common mm/init.c
Message-ID: <tip-540aca06b737cc38965b52eeceefba3d24376461@git.kernel.org>
Git-Commit-ID: 540aca06b737cc38965b52eeceefba3d24376461
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 11:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  540aca06b737cc38965b52eeceefba3d24376461
Gitweb:     http://git.kernel.org/tip/540aca06b737cc38965b52eeceefba3d24376461
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Wed, 4 Mar 2009 11:46:40 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 11:40:04 +0100

x86: move devmem_is_allowed() to common mm/init.c

Impact: cleanup

The function is identical on 32-bit and 64-bit configurations so move
it to the common mm/init.c file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236160001.29024.29.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c    |   24 ++++++++++++++++++++++++
 arch/x86/mm/init_32.c |   21 ---------------------
 arch/x86/mm/init_64.c |   22 ----------------------
 3 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ce6a722..f89df52 100644
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
index 0b087dc..917c4e6 100644
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
index 724e537..074435e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -876,28 +876,6 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
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
 
