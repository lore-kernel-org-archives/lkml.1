Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbXLMX7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbXLMX7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764914AbXLMX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:57:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:62004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763982AbXLMX5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="241552125"
Message-Id: <20071213235713.521185000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:54 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 11/12] PAT 64b: devmem do not read pages not mapped in identity map
Content-Disposition: inline; filename=dev_mem_skip_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable valid_phys_addr_range for x86_64 and check whether the identity
mapping exists before reading /dev/mem. For reserved regions there is no
identity mappings any more and then cannot be read from /dev/mem.

Side effect is that dd of entire memory will not work any more, once there are
reserved holes in memory space.

TBD: Read reserved regions as 0xffff or something, and continue reading
across holes, till we reach the high_memory (end of memory).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6.24-rc/arch/x86/kernel/e820_64.c
@@ -220,6 +220,11 @@ int is_memory_all_valid(unsigned long st
 }
 EXPORT_SYMBOL_GPL(is_memory_all_valid);
 
+int valid_phys_addr_range(unsigned long addr, size_t count)
+{
+	return is_memory_all_valid(addr, addr + count);
+}
+
 /* 
  * Find a free area in a specific range. 
  */ 
Index: linux-2.6.24-rc/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/io_64.h
+++ linux-2.6.24-rc/include/asm-x86/io_64.h
@@ -265,6 +265,15 @@ extern int iommu_bio_merge;
  */
 #define xlate_dev_kmem_ptr(p)	p
 
+#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
+extern int valid_phys_addr_range (unsigned long addr, size_t count);
+
+static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
+{
+	return 1;
+}
+
+
 #endif /* __KERNEL__ */
 
 #endif

-- 
