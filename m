Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXEPWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXEPWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbXEPWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:37 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50148 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758455AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355696.13712@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224818.683288460@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:56 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 4/9] readahead: data structure and routines
Content-Disposition: inline; filename=readahead-data-structure-and-routines.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extend struct file_ra_state to support the on-demand readahead logic.
Also define some helpers for it.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

 include/linux/fs.h |   64 +++++++++++++++++++++++++++++++++++++++++++
 mm/readahead.c     |   19 ++++++++++++
 2 files changed, 83 insertions(+)

--- linux-2.6.22-rc1-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc1-mm1/include/linux/fs.h
@@ -702,6 +702,10 @@ struct fown_struct {
 
 /*
  * Track a single file's readahead state
+ *
+ *  ================#============|==================#==================|
+ *                  ^            ^                  ^                  ^
+ *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
  */
 struct file_ra_state {
 	unsigned long start;		/* Current window */
@@ -711,6 +715,12 @@ struct file_ra_state {
 	unsigned long prev_index;	/* Cache last read() position */
 	unsigned long ahead_start;	/* Ahead window */
 	unsigned long ahead_size;
+
+	pgoff_t la_index;               /* enqueue time */
+	pgoff_t ra_index;               /* begin offset */
+	pgoff_t lookahead_index;        /* time to do next readahead */
+	pgoff_t readahead_index;        /* end offset */
+
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
@@ -719,6 +729,60 @@ struct file_ra_state {
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
 
+/*
+ * Measuring read-ahead sizes.
+ *
+ *                  |----------- readahead size ------------>|
+ *  ===#============|==================#=====================|
+ *     |------- invoke interval ------>|-- lookahead size -->|
+ */
+static inline unsigned long ra_readahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->ra_index;
+}
+
+static inline unsigned long ra_lookahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->lookahead_index;
+}
+
+static inline unsigned long ra_invoke_interval(struct file_ra_state *ra)
+{
+	return ra->lookahead_index - ra->la_index;
+}
+
+/*
+ * Check if @index falls in the readahead windows.
+ */
+static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
+{
+	return (index >= ra->la_index &&
+		index <  ra->readahead_index);
+}
+
+/*
+ * Where is the old read-ahead and look-ahead?
+ */
+static inline void ra_set_index(struct file_ra_state *ra,
+				pgoff_t la_index, pgoff_t ra_index)
+{
+	ra->la_index = la_index;
+	ra->ra_index = ra_index;
+}
+
+/*
+ * Where is the new read-ahead and look-ahead?
+ */
+static inline void ra_set_size(struct file_ra_state *ra,
+				unsigned long ra_size, unsigned long la_size)
+{
+	ra->readahead_index = ra->ra_index + ra_size;
+	ra->lookahead_index = ra->ra_index + ra_size - la_size;
+}
+
+unsigned long ra_submit(struct file_ra_state *ra,
+		       struct address_space *mapping, struct file *filp);
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
--- linux-2.6.22-rc1-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc1-mm1/mm/readahead.c
@@ -592,3 +592,22 @@ unsigned long max_sane_readahead(unsigne
 	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
+
+/*
+ * Submit IO for the read-ahead request in file_ra_state.
+ */
+unsigned long ra_submit(struct file_ra_state *ra,
+		       struct address_space *mapping, struct file *filp)
+{
+	unsigned long ra_size;
+	unsigned long la_size;
+	int actual;
+
+	ra_size = ra_readahead_size(ra);
+	la_size = ra_lookahead_size(ra);
+	actual = __do_page_cache_readahead(mapping, filp,
+					ra->ra_index, ra_size, la_size);
+
+	return actual;
+}
+EXPORT_SYMBOL_GPL(ra_submit);

--
