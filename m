Return-Path: <linux-kernel-owner+w=401wt.eu-S1762960AbXGUTBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960AbXGUTBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXGUTBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:01:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53303 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbXGUTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:01:45 -0400
Message-Id: <20070721210052.263005000@chello.nl>
References: <20070721210005.000228000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 23:00:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] readahead: fadvise drop behind controls
Content-Disposition: inline; filename=readahead-fadvise.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

currently drop behind is controlled by a heuristic:

  ra->size == ra->ra_pages

provide some fadvise() control:

POSIX_FADV_NORMAL     - heuristic
POSIX_FADV_RANDOM     - always disable drop behind
POSIX_FADV_SEQUENTIAL - always enable drop behind

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/fs.h |    7 +++++++
 mm/fadvise.c       |    5 +++++
 mm/readahead.c     |    4 +++-
 3 files changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -705,8 +705,15 @@ struct file_ra_state {
 	unsigned int ra_pages;		/* Maximum readahead window */
 	int mmap_miss;			/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
+	unsigned int flags;		/* readahead flags */
 };
 
+#define F_RA_DROP_BEHIND_NEVER		1
+#define F_RA_DROP_BEHIND_ALWAYS		2
+
+#define F_RA_DROP_BEHIND_MASK \
+	(F_RA_DROP_BEHIND_NEVER|F_RA_DROP_BEHIND_ALWAYS)
+
 /*
  * Check if @index falls in the readahead windows.
  */
Index: linux-2.6/mm/fadvise.c
===================================================================
--- linux-2.6.orig/mm/fadvise.c
+++ linux-2.6/mm/fadvise.c
@@ -65,12 +65,17 @@ asmlinkage long sys_fadvise64_64(int fd,
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		file->f_ra.flags &= ~F_RA_DROP_BEHIND_MASK;
 		break;
 	case POSIX_FADV_RANDOM:
 		file->f_ra.ra_pages = 0;
+		file->f_ra.flags &= ~F_RA_DROP_BEHIND_MASK;
+		file->f_ra.flags |= F_RA_DROP_BEHIND_NEVER;
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		file->f_ra.flags &= ~F_RA_DROP_BEHIND_MASK;
+		file->f_ra.flags |= F_RA_DROP_BEHIND_ALWAYS;
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c
+++ linux-2.6/mm/readahead.c
@@ -485,7 +485,9 @@ page_cache_async_readahead(struct addres
 	 * hint that there is sequential IO, which implies that the pages that
 	 * have been used thus far can be reclaimed
 	 */
-	if (ra->size == ra->ra_pages) do {
+	if (!(ra->flags & F_RA_DROP_BEHIND_NEVER) &&
+	    ((ra->flags & F_RA_DROP_BEHIND_ALWAYS) ||
+	     ra->size == ra->ra_pages)) do {
 		nr_pages = find_get_pages(mapping,
 				demote_idx, ARRAY_SIZE(pages), pages);
 

--

