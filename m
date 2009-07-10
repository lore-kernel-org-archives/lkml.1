Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZGJRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZGJRAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZGJQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:7780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZGJQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777317"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 03/10] x86, PAT: New i/f for driver to request memtype for IO regions
Date: Fri, 10 Jul 2009 09:57:34 -0700
Message-Id: <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new routines to request memtype for IO regions. This will currently
be a backend for io_mapping_* routines. But, it can also be made available
to drivers directly in future, in case it is needed.

reserve interface reserves the memory, makes sure we have a compatible
memory type available and keeps the identity map in sync when needed.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/pat.h |    5 ++++
 arch/x86/mm/pat.c          |   49 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 7af14e5..e2c1668 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -19,4 +19,9 @@ extern int free_memtype(u64 start, u64 end);
 extern int kernel_map_sync_memtype(u64 base, unsigned long size,
 		unsigned long flag);
 
+int io_reserve_memtype(resource_size_t start, resource_size_t end,
+			unsigned long *type);
+
+void io_free_memtype(resource_size_t start, resource_size_t end);
+
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index d5af279..82d097c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -498,6 +498,55 @@ int free_memtype(u64 start, u64 end)
 }
 
 
+/**
+ * io_reserve_memtype - Request a memory type mapping for a region of memory
+ * @start: start (physical address) of the region
+ * @end: end (physical address) of the region
+ * @type: A pointer to memtype, with requested type. On success, requested
+ * or any other compatible type that was available for the region is returned
+ *
+ * On success, returns 0
+ * On failure, returns non-zero
+ */
+int io_reserve_memtype(resource_size_t start, resource_size_t end,
+			unsigned long *type)
+{
+	unsigned long req_type = *type;
+	unsigned long new_type;
+	int ret;
+
+	WARN_ON_ONCE(iomem_map_sanity_check(start, end - start));
+
+	ret = reserve_memtype(start, end, req_type, &new_type);
+	if (ret)
+		goto out_err;
+
+	if (!is_new_memtype_allowed(req_type, new_type))
+		goto out_free;
+
+	if (kernel_map_sync_memtype(start, end - start, new_type) < 0)
+		goto out_free;
+
+	*type = new_type;
+	return 0;
+
+out_free:
+	free_memtype(start, end);
+	ret = -EBUSY;
+out_err:
+	return ret;
+}
+
+/**
+ * io_free_memtype - Release a memory type mapping for a region of memory
+ * @start: start (physical address) of the region
+ * @end: end (physical address) of the region
+ */
+void io_free_memtype(resource_size_t start, resource_size_t end)
+{
+	free_memtype(start, end);
+}
+
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
-- 
1.6.0.6

