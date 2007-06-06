Return-Path: <linux-kernel-owner+w=401wt.eu-S935185AbXFFTQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185AbXFFTQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbXFFTQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:16:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:41190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764425AbXFFTQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="94140690"
Message-Id: <20070606190042.510643000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 11:57:00 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Content-Disposition: inline; filename=resource_pool.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 include/linux/respool.h |   43 +++++++++
 lib/Makefile            |    1 
 lib/respool.c           |  222 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 266 insertions(+)

Index: linux-2.6.22-rc3/include/linux/respool.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/include/linux/respool.h	2007-06-06 11:33:24.000000000 -0700
@@ -0,0 +1,43 @@
+/*
+ * respool.c - library routines for handling generic pre-allocated pool of objects
+ *
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ *
+ */
+
+#ifndef _RESPOOL_H_
+#define _RESPOOL_H_
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+typedef void *(*rpool_alloc_t)(unsigned int, gfp_t);
+typedef void (*rpool_free_t)(void *, unsigned int);
+
+struct resource_pool {
+	struct work_struct work;
+	spinlock_t	pool_lock;	/* pool lock to walk the pool_head */
+	struct list_head pool_head;	/* pool objects list head	*/
+	unsigned int	min_count;	/* min count to maintain	*/
+	unsigned int	grow_count;	/* grow by count when time to grow */
+	unsigned int	curr_count;	/* count of current free objects */
+	unsigned int	alloc_size;	/* objects size			*/
+	rpool_alloc_t 	alloc_mem;	/* pool mem alloc function pointer */
+	rpool_free_t 	free_mem;	/* pool mem free function pointer */
+};
+
+void *get_resource_pool_obj(struct resource_pool *ppool);
+void put_resource_pool_obj(void * vaddr, struct resource_pool *ppool);
+void destroy_resource_pool(struct resource_pool *ppool);
+int init_resource_pool(struct resource_pool *res,
+	unsigned int min_count, unsigned int alloc_size,
+	unsigned int grow_count, rpool_alloc_t alloc_fn,
+	rpool_free_t free_fn);
+
+#endif
Index: linux-2.6.22-rc3/lib/Makefile
===================================================================
--- linux-2.6.22-rc3.orig/lib/Makefile	2007-06-06 11:33:21.000000000 -0700
+++ linux-2.6.22-rc3/lib/Makefile	2007-06-06 11:33:24.000000000 -0700
@@ -58,6 +58,7 @@
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
+obj-$(CONFIG_DMAR) += respool.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
Index: linux-2.6.22-rc3/lib/respool.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/lib/respool.c	2007-06-06 11:34:46.000000000 -0700
@@ -0,0 +1,222 @@
+/*
+ * respool.c - library routines for handling generic pre-allocated pool of objects
+ *
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ */
+
+#include <linux/respool.h>
+
+/**
+ * get_resource_pool_obj - gets an object from the pool
+ * @ppool - resource pool in question
+ * This function gets an object from the pool and
+ * if the pool count drops below min_count, this
+ * function schedules work to grow the pool. If
+ * no elements are fount in the pool then this function
+ * tries to get memory from kernel.
+ */
+void * get_resource_pool_obj(struct resource_pool *ppool)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+	bool queue_work = 0;
+
+	spin_lock_irqsave(&ppool->pool_lock, flags);
+	if (!list_empty(&ppool->pool_head)) {
+		plist = ppool->pool_head.next;
+		list_del(plist);
+		ppool->curr_count--;
+	} else {
+		/*Making sure that curr_count is 0 when list is empty */
+		plist = NULL;
+		BUG_ON(ppool->curr_count != 0);
+	}
+
+	/* Check if pool needs to grow */
+	if (ppool->curr_count <= ppool->min_count)
+		queue_work = 1;
+	spin_unlock_irqrestore(&ppool->pool_lock, flags);
+
+	if (queue_work)
+		schedule_work(&ppool->work); /* queue work to grow the pool */
+
+
+	if (plist) {
+		memset(plist, 0, ppool->alloc_size); /* Zero out memory */
+		return plist;
+	}
+
+	/* Out of luck, try to get memory from kernel */
+	plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
+			GFP_ATOMIC);
+
+	return plist;
+}
+
+/**
+ * put_resource_pool_obj - puts an object back to the pool
+ * @vaddr - object's address
+ * @ppool - resource pool in question.
+ * This function puts an object back to the pool.
+ */
+void put_resource_pool_obj(void * vaddr, struct resource_pool *ppool)
+{
+	unsigned long	flags;
+	struct list_head *plist = (struct list_head *)vaddr;
+	bool queue_work = 0;
+
+	BUG_ON(!vaddr);
+	BUG_ON(!ppool);
+
+	spin_lock_irqsave(&ppool->pool_lock, flags);
+	list_add(plist, &ppool->pool_head);
+	ppool->curr_count++;
+	if (ppool->curr_count > (ppool->min_count +
+		ppool->grow_count * 2))
+		queue_work = 1;
+	spin_unlock_irqrestore(&ppool->pool_lock, flags);
+
+	if (queue_work)
+		schedule_work(&ppool->work); /* queue work to shrink the pool */
+}
+
+void
+__grow_resource_pool(struct resource_pool *ppool,
+	unsigned int grow_count)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+
+	while(grow_count) {
+		plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
+			GFP_KERNEL);
+
+		if (!plist)
+			break;
+
+		/* Add the element to the list */
+		spin_lock_irqsave(&ppool->pool_lock, flags);
+		list_add(plist, &ppool->pool_head);
+		ppool->curr_count++;
+		spin_unlock_irqrestore(&ppool->pool_lock, flags);
+		grow_count--;
+	}
+}
+
+void
+__shrink_resource_pool(struct resource_pool *ppool,
+	unsigned int shrink_count)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+
+	while (shrink_count) {
+		/* remove an object from the pool */
+		spin_lock_irqsave(&ppool->pool_lock, flags);
+		if (list_empty(&ppool->pool_head)) {
+			spin_unlock_irqrestore(&ppool->pool_lock, flags);
+			break;
+		}
+		plist = ppool->pool_head.next;
+		list_del(plist);
+		ppool->curr_count--;
+		spin_unlock_irqrestore(&ppool->pool_lock, flags);
+		ppool->free_mem(plist, ppool->alloc_size);
+		shrink_count--;
+	}
+}
+
+
+/**
+ * resize_resource_pool - resize the given resource pool
+ * @work - work struct
+ * This functions gets the resource pool pointer from the
+ * work struct and grows the resource pool by grow_count.
+ */
+static void
+resize_resource_pool(struct work_struct * work)
+{
+	struct resource_pool *ppool;
+	unsigned int min_count, grow_count = 0;
+	unsigned int shrink_count = 0;
+	unsigned long	flags;
+
+	ppool = container_of(work, struct resource_pool, work);
+
+	/* compute the minimum count to grow */
+	spin_lock_irqsave(&ppool->pool_lock, flags);
+	min_count = ppool->min_count + ppool->grow_count;
+	if (ppool->curr_count < min_count)
+		grow_count = min_count - ppool->curr_count;
+	else if (ppool->curr_count > min_count + ppool->grow_count)
+		shrink_count = ppool->curr_count - min_count;
+	spin_unlock_irqrestore(&ppool->pool_lock, flags);
+
+	if (grow_count)
+		__grow_resource_pool(ppool, grow_count);
+	else if (shrink_count)
+		__shrink_resource_pool(ppool, shrink_count);
+}
+
+/**
+ * destroy_resource_pool - destroys the given resource pool
+ * @ppool - resource pool in question.
+ * This function walks throuhg its list and frees up the
+ * preallocated objects.
+ */
+void
+destroy_resource_pool(struct resource_pool *ppool)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+
+	spin_lock_irqsave(&ppool->pool_lock, flags);
+	while (!list_empty(&ppool->pool_head)) {
+		plist = &ppool->pool_head;
+		list_del(plist);
+
+		ppool->free_mem(plist, ppool->alloc_size);
+
+	}
+	ppool->curr_count = 0;
+	spin_unlock_irqrestore(&ppool->pool_lock, flags);
+}
+
+/**
+ * init_resource_pool - initializes the resource pool
+ * @res: resource pool in question.
+ * @min_count: count of objectes to pre-allocate
+ * @alloc_size: size of each objects
+ * @grow_count: count of objects to grow when required
+ * @alloc_fn: function which allocates memory
+ * @free_fn: function which frees memory
+ *
+ * This function initializes the given resource pool and
+ * populates the min_count of objects to begin with.
+ */
+int
+init_resource_pool(struct resource_pool *res,
+	unsigned int min_count, unsigned int alloc_size,
+	unsigned int grow_count, rpool_alloc_t alloc_fn,
+	rpool_free_t free_fn)
+{
+	res->min_count = min_count;
+	res->alloc_size = alloc_size;
+	res->grow_count = grow_count;
+	res->curr_count = 0;
+	res->alloc_mem = alloc_fn;
+	res->free_mem = free_fn;
+	spin_lock_init(&res->pool_lock);
+	INIT_LIST_HEAD(&res->pool_head);
+	INIT_WORK(&res->work, resize_resource_pool);
+
+	/* grow the pool */
+	resize_resource_pool(&res->work);
+
+	return (res->curr_count == 0);
+}
+

-- 
