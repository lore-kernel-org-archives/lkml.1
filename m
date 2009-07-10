Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZGJRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZGJRAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZGJQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:7787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbZGJQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777322"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 04/10] x86, PAT: Add PAT reserve free to io_mapping* APIs
Date: Fri, 10 Jul 2009 09:57:35 -0700
Message-Id: <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

io_mapping_* interfaces were added, mainly for graphics drivers.
Make this interface go through the PAT reserve/free, instead of
hardcoding WC mapping. This makes sure that there are no
aliases due to unconditional WC setting.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/iomap.h |    9 ++++++---
 arch/x86/mm/iomap_32.c       |   27 +++++++++++++++++++++++++--
 include/linux/io-mapping.h   |   17 ++++++++++++-----
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index 0e9fe1d..f35eb45 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -26,13 +26,16 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
-int
-is_io_mapping_possible(resource_size_t base, unsigned long size);
-
 void *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
 void
 iounmap_atomic(void *kvaddr, enum km_type type);
 
+int
+iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot);
+
+void
+iomap_free(resource_size_t base, unsigned long size);
+
 #endif /* _ASM_X86_IOMAP_H */
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index fe6f84c..84e236c 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 
-int is_io_mapping_possible(resource_size_t base, unsigned long size)
+static int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
 #if !defined(CONFIG_X86_PAE) && defined(CONFIG_PHYS_ADDR_T_64BIT)
 	/* There is no way to map greater than 1 << 32 address without PAE */
@@ -30,7 +30,30 @@ int is_io_mapping_possible(resource_size_t base, unsigned long size)
 #endif
 	return 1;
 }
-EXPORT_SYMBOL_GPL(is_io_mapping_possible);
+
+int iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot)
+{
+	unsigned long flag = _PAGE_CACHE_WC;
+	int ret;
+
+	if (!is_io_mapping_possible(base, size))
+		return -EINVAL;
+
+	ret = io_reserve_memtype(base, base + size, &flag);
+	if (ret)
+		return ret;
+
+	*prot = __pgprot(__PAGE_KERNEL | flag);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_create_wc);
+
+void
+iomap_free(resource_size_t base, unsigned long size)
+{
+	io_free_memtype(base, base + size);
+}
+EXPORT_SYMBOL_GPL(iomap_free);
 
 void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 {
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 0adb0f9..97eb928 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -49,23 +49,30 @@ static inline struct io_mapping *
 io_mapping_create_wc(resource_size_t base, unsigned long size)
 {
 	struct io_mapping *iomap;
-
-	if (!is_io_mapping_possible(base, size))
-		return NULL;
+	pgprot_t prot;
 
 	iomap = kmalloc(sizeof(*iomap), GFP_KERNEL);
 	if (!iomap)
-		return NULL;
+		goto out_err;
+
+	if (iomap_create_wc(base, size, &prot))
+		goto out_free;
 
 	iomap->base = base;
 	iomap->size = size;
-	iomap->prot = pgprot_writecombine(__pgprot(__PAGE_KERNEL));
+	iomap->prot = prot;
 	return iomap;
+
+out_free:
+	kfree(iomap);
+out_err:
+	return NULL;
 }
 
 static inline void
 io_mapping_free(struct io_mapping *mapping)
 {
+	iomap_free(mapping->base, mapping->size);
 	kfree(mapping);
 }
 
-- 
1.6.0.6

