Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbXGUEqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbXGUEqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbXGUEny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:43:54 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49836 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751696AbXGUEnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:43:49 -0400
Message-ID: <384993020.08966@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721044347.250839328@mail.ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 12:43:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
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
