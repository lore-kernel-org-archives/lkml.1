Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYKPEhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYKPEhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYKPEg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:36:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYKPEg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:36:58 -0500
Message-ID: <491FA28B.2070003@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:33:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some subsystem needs vmalloc() when required memory is large.
but current kernel has not APIs for this requirement.
this patch introduces simple_malloc() and simple_free().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ffee2f7..e9c11f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -13,6 +13,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/vmalloc.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -278,6 +279,36 @@ static inline int is_vmalloc_addr(const void *x)
 #endif
 }
 
+static inline void *__simple_malloc(unsigned long size, int pages_hint)
+{
+	if (size <= PAGE_SIZE * pages_hint)
+		return kmalloc(size, GFP_KERNEL);
+	else
+		return vmalloc(size);
+}
+
+/**
+ * simple_malloc - allocate memory by kmalloc() or vmalloc()
+ *
+ * if @size <= PAGE_SIZE, memory is allocated by kmalloc(),
+ * otherwise by vmalloc()
+ */
+static inline void *simple_malloc(unsigned long size)
+{
+	return __simple_malloc(size, 1);
+}
+
+/**
+ * simple_free - free the memory by kfree(), or vfree() if it is vmalloc addr
+ */
+static inline void simple_free(void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))


