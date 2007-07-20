Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXGTKMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXGTKMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXGTKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:11:32 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59144 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752233AbXGTKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:11:30 -0400
Message-ID: <384926280.09332@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070720101124.470940735@mail.ustc.edu.cn>
References: <20070720100740.106917381@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jul 2007 18:07:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] introduce radix_tree_scan_hole()
Content-Disposition: inline; filename=radixtree-introduce-scan-hole-data-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
for the first hole. It will be used in interleaved readahead.

The implementation is dumb and obviously correct.
It can help debug the possible smart one in future.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 include/linux/radix-tree.h |    2 ++
 lib/radix-tree.c           |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- linux-2.6.22-rc6-mm1.orig/include/linux/radix-tree.h
+++ linux-2.6.22-rc6-mm1/include/linux/radix-tree.h
@@ -155,6 +155,8 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
--- linux-2.6.22-rc6-mm1.orig/lib/radix-tree.c
+++ linux-2.6.22-rc6-mm1/lib/radix-tree.c
@@ -601,6 +601,40 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+static unsigned long
+radix_tree_scan_hole_dumb(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		if (++index == 0)
+			break;
+	}
+
+	return index;
+}
+
+/**
+ *	radix_tree_scan_hole    -    scan for hole
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@max_scan:      advice on max items to scan (it may scan a little more)
+ *
+ *      Scan forward from @index for a hole/empty item, stop when
+ *      - hit hole
+ *      - wrap-around to index 0
+ *      - @max_scan or more items scanned
+ */
+unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	return radix_tree_scan_hole_dumb(root, index, max_scan);
+}
+EXPORT_SYMBOL(radix_tree_scan_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)

--
