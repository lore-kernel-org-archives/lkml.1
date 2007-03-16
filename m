Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXCPIwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXCPIwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbXCPIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:44 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34583 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753089AbXCPIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:22 -0400
Message-ID: <374035058.94331@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085051.601015000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:48:57 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] readahead: state based method: check node id
Content-Disposition: inline; filename=readahead-state-based-method-check-node-id.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The file_ra_state.age is node specific,
comparing ages between two nodes is a bug.

So add code to
- take down the node id in file_ra_state.flags;
- ensure that we are comparing the ages from the same node.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |    2 +-
 mm/readahead.c     |   30 +++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/include/linux/fs.h
+++ linux-2.6.21-rc3-mm2/include/linux/fs.h
@@ -738,7 +738,7 @@ struct file_ra_state {
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 
-	unsigned long flags;	/* RA_FLAG_xxx | ra_class_old | ra_class_new */
+	unsigned long flags;	/* RA_FLAG_xxx | node_id | class_old | class_new */
 	unsigned long prev_page;	/* Cache last read() position */
 	unsigned long ra_pages;		/* Maximum readahead window */
 };
--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -52,11 +52,13 @@ EXPORT_SYMBOL_GPL(readahead_ratio);
 int readahead_hit_rate = 1;
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
+#define RA_CLASS_SHIFT 4
+#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
+#define RA_NODE_SHIFT  (2 * RA_CLASS_SHIFT)
+#define RA_NODE_MASK   ((MAX_NUMNODES-1) << RA_NODE_SHIFT)
 /*
  * Detailed classification of read-ahead behaviors.
  */
-#define RA_CLASS_SHIFT 4
-#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
@@ -802,6 +804,11 @@ static inline enum ra_class ra_class_old
 	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
 }
 
+static inline int ra_node_id(struct file_ra_state *ra)
+{
+	return (ra->flags >> RA_NODE_SHIFT) & RA_NODE_MASK;
+}
+
 static unsigned long ra_readahead_size(struct file_ra_state *ra)
 {
 	return ra->readahead_index - ra->ra_index;
@@ -864,6 +871,18 @@ static void ra_set_size(struct file_ra_s
 }
 
 /*
+ * Save the current node id and age.
+ */
+static void ra_save_node_age(struct file_ra_state *ra)
+{
+	int nid = numa_node_id();
+
+	ra->flags &= ~RA_NODE_MASK;
+	ra->flags |= nid << RA_NODE_SHIFT;
+	ra->age = nr_scanned_pages_node(nid);
+}
+
+/*
  * Submit IO for the read-ahead request in file_ra_state.
  */
 static unsigned long ra_submit(struct file_ra_state *ra,
@@ -901,7 +920,7 @@ static unsigned long ra_submit(struct fi
 	}
 
 	/* Take down the current read-ahead aging value. */
-	ra->age = nr_scanned_pages_node(numa_node_id());
+	ra_save_node_age(ra);
 
 	ra_size = ra_readahead_size(ra);
 	la_size = ra_lookahead_size(ra);
@@ -1025,9 +1044,10 @@ static unsigned long compute_thrashing_t
 	unsigned long stream_shift;
 	unsigned long ra_size;
 	uint64_t ll;
+	int nid = ra_node_id(ra);
 
-	global_size = nr_free_inactive_pages_node(numa_node_id());
-	global_shift = nr_scanned_pages_node(numa_node_id()) - ra->age;
+	global_size = nr_free_inactive_pages_node(nid);
+	global_shift = nr_scanned_pages_node(nid) - ra->age;
 	global_shift |= 1UL;
 	stream_shift = ra_invoke_interval(ra);
 

--
