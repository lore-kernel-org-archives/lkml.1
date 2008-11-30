Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYK3AQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYK3AQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 19:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYK3AQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 19:16:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23011 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbYK3AQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 19:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KS3yH7io8ncjCXkS1bK0HkHG0cTxs0aOEPcO+tKKl/xUUo/RD675dUhgHPZ3jp00nx
         hRc4KlmONOhLMOjvOQUpikRrwIbvarGHVkDlzOghwdgzLJBQ814L0wZwX2zkhT+52AgU
         tFj+yXTPA8Gsx7PPiVE3utv8tyCmA4m0cZUPo=
Subject: [RESEND take 2][PATCH 1/2] Implement /proc/mempool file to display
	mempools.
From: Remi Colinet <remi.colinet@gmail.com>
Reply-To: remi.colinet@gmail.com
To: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1228003445.13070.1.camel@localhost.localdomain>
References: <1228003445.13070.1.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Personal
Date: Sun, 30 Nov 2008 01:10:55 +0100
Message-Id: <1228003855.13070.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement /proc/mempool file to display mempools.

Signed-off-by: Remi Colinet <remi.colinet@gmail.com>
---
 fs/proc/Makefile        |    1
 fs/proc/mempool.c       |   99 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mempool.h |   40 +++++++++++++++----
 mm/mempool.c            |   43 +++++++++++++++++++-
 4 files changed, 171 insertions(+), 12 deletions(-)

diff -uNrp linux/fs/proc/Makefile linux-mempool/fs/proc/Makefile
--- linux/fs/proc/Makefile	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/fs/proc/Makefile	2008-11-29 22:52:40.000000000 +0100
@@ -15,6 +15,7 @@ proc-y	+= devices.o
 proc-y	+= interrupts.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
+proc-y	+= mempool.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
diff -uNrp linux/fs/proc/mempool.c linux-mempool/fs/proc/mempool.c
--- linux/fs/proc/mempool.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-mempool/fs/proc/mempool.c	2008-11-30 00:37:11.000000000 +0100
@@ -0,0 +1,99 @@
+/*
+ * mempool.c: Mempool tracking with proc filesystem.
+ *
+ * Written by Remi Colinet (remi.colinet@gmail.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ **/
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mmzone.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/mempool.h>
+#include <asm/atomic.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+struct proc_dir_entry *mempool_entry;
+
+static char *mempool_type_name[MEMPOOL_NR_TYPES] = {
+	"slab",
+	"kmalloc",
+	"kzalloc",
+	"page",
+	"private"
+};
+
+static void *mempool_start(struct seq_file *m, loff_t *pos)
+{
+	read_lock(&mempool_lock);
+	if (*pos != 0)
+		return NULL;
+
+	if (list_empty(&mempool_list))
+		return NULL;
+
+	seq_printf(m, "name            type     size  min curr\n");
+	return list_entry(mempool_list.next, mempool_t, list);
+}
+
+static void *mempool_next(struct seq_file *m, void *arg, loff_t *pos)
+{
+	mempool_t *mempool = (mempool_t *)arg;
+
+	(*pos)++;
+	if (mempool->list.next == &mempool_list)
+		return NULL;
+
+	return list_entry(mempool->list.next, mempool_t, list);
+}
+
+static void mempool_stop(struct seq_file *m, void *arg)
+{
+	read_unlock(&mempool_lock);
+}
+
+static int mempool_show(struct seq_file *m, void *arg)
+{
+	mempool_t *mempool = (mempool_t *)arg;
+
+	BUG_ON(mempool == NULL);
+
+	seq_printf(m, "%-15s %-8s %5d %4d %d\n", mempool->name,
+		mempool_type_name[mempool->type], mempool->size,
+		mempool->min_nr, mempool->curr_nr);
+	return 0;
+}
+
+static struct seq_operations mempool_seq_ops = {
+	.start  = mempool_start,
+	.next   = mempool_next,
+	.stop   = mempool_stop,
+	.show   = mempool_show,
+};
+
+static int mempool_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &mempool_seq_ops);
+}
+
+static const struct file_operations proc_mempool_file_operations = {
+	.open           = mempool_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static int __init proc_mempool_init(void)
+{
+	proc_create("mempool", 0, NULL, &proc_mempool_file_operations);
+	return 0;
+}
+module_init(proc_mempool_init);
diff -uNrp linux/include/linux/mempool.h linux-mempool/include/linux/mempool.h
--- linux/include/linux/mempool.h	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/include/linux/mempool.h	2008-11-29 23:23:40.000000000 +0100
@@ -18,15 +18,33 @@ typedef struct mempool_s {
 	void **elements;
 
 	void *pool_data;
+	struct list_head list;
+	char *name;
+	unsigned int size;
+	unsigned short type;
 	mempool_alloc_t *alloc;
 	mempool_free_t *free;
 	wait_queue_head_t wait;
 } mempool_t;
 
+extern struct list_head mempool_list;
+extern rwlock_t mempool_lock;
+
+enum MEMPOOL_TYPE {
+	MEMPOOL_SLAB,
+	MEMPOOL_KMALLOC,
+	MEMPOOL_KZALLOC,
+	MEMPOOL_PAGE,
+	MEMPOOL_PRIVATE,        /* For private or default usage */
+	MEMPOOL_NR_TYPES
+};
+
 extern mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data);
+	mempool_free_t *free_fn, void *pool_data, const char *name,
+	unsigned short type);
 extern mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int nid);
+	mempool_free_t *free_fn, void *pool_data, int nid, const char *name,
+	unsigned short type);
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask);
 extern void mempool_destroy(mempool_t *pool);
@@ -42,8 +60,9 @@ void mempool_free_slab(void *element, vo
 static inline mempool_t *
 mempool_create_slab_pool(int min_nr, struct kmem_cache *kc)
 {
+	const char *name = kmem_cache_name(kc);
 	return mempool_create(min_nr, mempool_alloc_slab, mempool_free_slab,
-			      (void *) kc);
+			      (void *) kc, name, MEMPOOL_SLAB);
 }
 
 /*
@@ -53,15 +72,17 @@ mempool_create_slab_pool(int min_nr, str
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data);
 void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data);
 void mempool_kfree(void *element, void *pool_data);
-static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size)
+static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size,
+	const char *name)
 {
 	return mempool_create(min_nr, mempool_kmalloc, mempool_kfree,
-			      (void *) size);
+			      (void *) size, name, MEMPOOL_KMALLOC);
 }
-static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size)
+static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size,
+	const char *name)
 {
 	return mempool_create(min_nr, mempool_kzalloc, mempool_kfree,
-			      (void *) size);
+			      (void *) size, name, MEMPOOL_KMALLOC);
 }
 
 /*
@@ -70,10 +91,11 @@ static inline mempool_t *mempool_create_
  */
 void *mempool_alloc_pages(gfp_t gfp_mask, void *pool_data);
 void mempool_free_pages(void *element, void *pool_data);
-static inline mempool_t *mempool_create_page_pool(int min_nr, int order)
+static inline mempool_t *mempool_create_page_pool(int min_nr, int order,
+	const char *name)
 {
 	return mempool_create(min_nr, mempool_alloc_pages, mempool_free_pages,
-			      (void *)(long)order);
+			      (void *)(long)order, name, MEMPOOL_PAGE);
 }
 
 #endif /* _LINUX_MEMPOOL_H */
diff -uNrp linux/mm/mempool.c linux-mempool/mm/mempool.c
--- linux/mm/mempool.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/mm/mempool.c	2008-11-29 22:40:53.000000000 +0100
@@ -15,6 +15,9 @@
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
 
+LIST_HEAD(mempool_list);
+DEFINE_RWLOCK(mempool_lock);
+
 static void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
@@ -44,6 +47,8 @@ static void free_pool(mempool_t *pool)
  * @alloc_fn:  user-defined element-allocation function.
  * @free_fn:   user-defined element-freeing function.
  * @pool_data: optional private data available to the user-defined functions.
+ * @name: name of the mempool
+ * @type: type of the mempool (PAGE, SLAB, KMALLOC, KZALLOC, PRIVATE)
  *
  * this function creates and allocates a guaranteed size, preallocated
  * memory pool. The pool can be used from the mempool_alloc() and mempool_free()
@@ -52,14 +57,17 @@ static void free_pool(mempool_t *pool)
  * from IRQ contexts.
  */
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
-				mempool_free_t *free_fn, void *pool_data)
+	mempool_free_t *free_fn, void *pool_data, const char *name,
+	unsigned short type)
 {
-	return  mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,-1);
+	return  mempool_create_node(min_nr, alloc_fn, free_fn, pool_data, -1,
+		name, type);
 }
 EXPORT_SYMBOL(mempool_create);
 
 mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int node_id)
+	mempool_free_t *free_fn, void *pool_data, int node_id, const char *name,
+	unsigned short type)
 {
 	mempool_t *pool;
 	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL | __GFP_ZERO, node_id);
@@ -91,6 +99,35 @@ mempool_t *mempool_create_node(int min_n
 		}
 		add_element(pool, element);
 	}
+
+	/*
+	 * Setup name of the mempool
+	 */
+	pool->name = kmalloc(strlen(name), GFP_KERNEL);
+	if (pool->name == NULL) {
+		/* should release other memory allocations */
+		return ERR_PTR(-ENOMEM);
+	}
+
+	strcpy(pool->name, name);
+	pool->type = type;
+	if (type == MEMPOOL_KZALLOC || type == MEMPOOL_KMALLOC)
+		pool->size = (int)(long) pool_data;
+	if (type == MEMPOOL_PAGE)
+		pool->size = (int)(PAGE_SIZE << (int)(long) pool_data);
+	if (type == MEMPOOL_SLAB) {
+		struct kmem_cache *kc = pool_data;
+		pool->size = kmem_cache_size(kc);
+	}
+	if (type == MEMPOOL_PRIVATE)
+		pool->size = 0;
+
+	/*
+	 * Add the mempool to the global list
+	 */
+	write_lock(&mempool_lock);
+	list_add_tail(&pool->list, &mempool_list);
+	write_unlock(&mempool_lock);
 	return pool;
 }
 EXPORT_SYMBOL(mempool_create_node);


