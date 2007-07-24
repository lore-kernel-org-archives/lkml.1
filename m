Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXGXCMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXGXCMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbXGXCMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:12:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40654 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759595AbXGXCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:12:13 -0400
Message-ID: <385243123.22147@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070724020042.319225909@mail.ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jul 2007 10:00:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 04/10] radixtree: introduce radix_tree_scan_hole()
Content-Disposition: inline; filename=radixtree-introduce-scan-hole-data-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
for the first hole. It will be used in interleaved readahead.

The implementation is dumb and obviously correct.
It can help debug(and document) the possible smart one in future.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- linux-2.6.22-rc6-mm1.orig/include/linux/radix-tree.h
+++ linux-2.6.22-rc6-mm1/include/linux/radix-tree.h
@@ -155,6 +155,8 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
--- linux-2.6.22-rc6-mm1.orig/lib/radix-tree.c
+++ linux-2.6.22-rc6-mm1/lib/radix-tree.c
@@ -601,6 +601,42 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+/**
+ *	radix_tree_next_hole    -    find the next hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search the set [index, min(index+max_scan-1, MAX_INDEX)] for the lowest
+ *	indexed hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'return - index >= max_scan'
+ *	will be true).
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of the
+ *	tree at a single point in time. For example, if a hole is created at index
+ *	5, then subsequently a hole is created at index 10, radix_tree_next_hole
+ *	covering both indexes may return 10 if called under rcu_read_lock.
+ */
+unsigned long radix_tree_next_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index++;
+		if (index == 0)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_next_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)

--
