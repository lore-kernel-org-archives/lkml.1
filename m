Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZJBL47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZJBL47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZJBL46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:56:58 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:37831 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbZJBL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:56:57 -0400
Date: Fri, 02 Oct 2009 20:57:01 +0900 (JST)
Message-Id: <20091002.205701.71114259.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 3/9] blkio-cgroup-v13: The new page_cgroup framework
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20091002.205635.226776464.ryov@valinux.co.jp>
References: <20091002.205607.193712402.ryov@valinux.co.jp>
	<20091002.205635.226776464.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the page_cgroup framework be able to be used even if
the compile option of the cgroup memory controller is off.
So blkio-cgroup can use this framework without the memory controller.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 include/linux/memcontrol.h  |    6 ++++++
 include/linux/mmzone.h      |    4 ++--
 include/linux/page_cgroup.h |    5 +++--
 init/Kconfig                |    4 ++++
 mm/Makefile                 |    3 ++-
 mm/memcontrol.c             |    6 ++++++
 mm/page_cgroup.c            |    3 +--
 7 files changed, 24 insertions(+), 7 deletions(-)

Index: linux-2.6.32-rc1/include/linux/memcontrol.h
===================================================================
--- linux-2.6.32-rc1.orig/include/linux/memcontrol.h
+++ linux-2.6.32-rc1/include/linux/memcontrol.h
@@ -37,6 +37,8 @@ struct mm_struct;
  * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
  */
 
+extern void __init_mem_page_cgroup(struct page_cgroup *pc);
+
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
@@ -124,6 +126,10 @@ unsigned long mem_cgroup_soft_limit_recl
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
+static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+}
+
 static inline int mem_cgroup_newpage_charge(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
 {
Index: linux-2.6.32-rc1/include/linux/mmzone.h
===================================================================
--- linux-2.6.32-rc1.orig/include/linux/mmzone.h
+++ linux-2.6.32-rc1/include/linux/mmzone.h
@@ -616,7 +616,7 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
@@ -966,7 +966,7 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
Index: linux-2.6.32-rc1/include/linux/page_cgroup.h
===================================================================
--- linux-2.6.32-rc1.orig/include/linux/page_cgroup.h
+++ linux-2.6.32-rc1/include/linux/page_cgroup.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 #include <linux/bit_spinlock.h>
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -14,6 +14,7 @@ struct page_cgroup {
 	unsigned long flags;
 	struct mem_cgroup *mem_cgroup;
 	struct page *page;
+	unsigned long blkio_cgroup_id;
 	struct list_head lru;		/* per cgroup LRU list */
 };
 
@@ -96,7 +97,7 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_CGROUP_PAGE */
 struct page_cgroup;
 
 static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
Index: linux-2.6.32-rc1/init/Kconfig
===================================================================
--- linux-2.6.32-rc1.orig/init/Kconfig
+++ linux-2.6.32-rc1/init/Kconfig
@@ -599,6 +599,10 @@ config CGROUP_MEM_RES_CTLR_SWAP
 
 endif # CGROUPS
 
+config CGROUP_PAGE
+	def_bool y
+	depends on CGROUP_MEM_RES_CTLR
+
 config MM_OWNER
 	bool
 
Index: linux-2.6.32-rc1/mm/Makefile
===================================================================
--- linux-2.6.32-rc1.orig/mm/Makefile
+++ linux-2.6.32-rc1/mm/Makefile
@@ -40,7 +40,8 @@ else
 obj-$(CONFIG_SMP) += allocpercpu.o
 endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_PAGE) += page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
Index: linux-2.6.32-rc1/mm/memcontrol.c
===================================================================
--- linux-2.6.32-rc1.orig/mm/memcontrol.c
+++ linux-2.6.32-rc1/mm/memcontrol.c
@@ -125,6 +125,12 @@ static s64 mem_cgroup_local_usage(struct
 	return ret;
 }
 
+void __meminit __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+	pc->mem_cgroup = NULL;
+	INIT_LIST_HEAD(&pc->lru);
+}
+
 /*
  * per-zone information in memory controller.
  */
Index: linux-2.6.32-rc1/mm/page_cgroup.c
===================================================================
--- linux-2.6.32-rc1.orig/mm/page_cgroup.c
+++ linux-2.6.32-rc1/mm/page_cgroup.c
@@ -14,9 +14,8 @@ static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
 {
 	pc->flags = 0;
-	pc->mem_cgroup = NULL;
 	pc->page = pfn_to_page(pfn);
-	INIT_LIST_HEAD(&pc->lru);
+	__init_mem_page_cgroup(pc);
 }
 static unsigned long total_usage;
 
