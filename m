Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbXI1ICw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbXI1ICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXI1IBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbXI1IBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:38 -0400
Message-Id: <20070928080042.778183000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/12] lockdep: enable lock_page lockdep annotation
Content-Disposition: inline; filename=lockdep-lock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With everything ready, connect the dots.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    7 +++++++
 include/linux/pagemap.h |   10 ++++++++++
 mm/filemap.c            |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -253,6 +253,13 @@ extern void lockdep_init_map(struct lock
 			     struct lock_class_key *key, int subclass);
 
 /*
+ * To initialize a lockdep_map statically use this macro.
+ * Note that _name must not be NULL.
+ */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+/*
  * Reinitialize a lock key - for cases where there is special locking or
  * special initialization of locks so that the validator gets the scope
  * of dependencies wrong: they are either too broad (they need a class-split)
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -157,12 +157,22 @@ extern void FASTCALL(__lock_page(struct 
 extern void FASTCALL(__lock_page_nosync(struct page *page, unsigned long ip));
 extern void FASTCALL(unlock_page_nocheck(struct page *page));
 
+extern struct lockdep_map *page_lock_map(struct page *page);
+
 static inline void __lock_page_check(struct page *page, int try, unsigned long ip)
 {
+	/*
+	 * use recursive read locks to annotate the page lock.
+	 * this allows us to have a single lock instance per filesystem.
+	 * obviously this reduces the usefulness of the lock checker
+	 * but it also keeps struct page from bloating.
+	 */
+	lock_acquire(page_lock_map(page), 0, try, 2, 2, ip);
 }
 
 static inline void __unlock_page_check(struct page *page, unsigned long ip)
 {
+	lock_release(page_lock_map(page), 1, ip);
 }
 
 /*
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -556,6 +556,41 @@ void end_page_writeback(struct page *pag
 }
 EXPORT_SYMBOL(end_page_writeback);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key lock_page_key;
+static struct lockdep_map lock_page_map =
+	STATIC_LOCKDEP_MAP_INIT("lock_page", &lock_page_key);
+
+struct lockdep_map *page_lock_map(struct page *page)
+{
+	struct address_space *mapping;
+	struct inode *inode;
+	struct super_block *sb;
+	struct file_system_type *type;
+	struct lockdep_map *map = &lock_page_map;
+
+	mapping = page_mapping(page);
+	if (!mapping)
+		goto out;
+
+	inode = mapping->host;
+	if (!inode)
+		goto out;
+
+	sb = inode->i_sb;
+	if (!sb)
+		goto out;
+
+	type = sb->s_type;
+	if (type)
+		map = &type->s_mapping_map;
+
+out:
+	return map;
+}
+EXPORT_SYMBOL(page_lock_map);
+#endif
+
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock

--

