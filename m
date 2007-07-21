Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXGUEph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXGUEph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbXGUEnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:43:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49778 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751162AbXGUEnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:43:49 -0400
Message-ID: <384993019.16801@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721044346.554186594@mail.ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 12:43:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/7] readahead: compacting file_ra_state
Content-Disposition: inline; filename=short-rasize.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'unsigned int' instead of 'unsigned long' for readahead sizes.

This helps reduce memory consumption on 64bit CPU when
a lot of files are opened.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |    8 ++++----
 mm/filemap.c       |    2 +-
 mm/readahead.c     |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc6-mm1/include/linux/fs.h
@@ -771,12 +771,12 @@ struct fown_struct {
  * Track a single file's readahead state
  */
 struct file_ra_state {
-	pgoff_t start;                  /* where readahead started */
-	unsigned long size;             /* # of readahead pages */
-	unsigned long async_size;       /* do asynchronous readahead when
+	pgoff_t start;			/* where readahead started */
+	unsigned int size;		/* # of readahead pages */
+	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
-	unsigned long ra_pages;		/* Maximum readahead window */
+	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -840,7 +840,7 @@ static void shrink_readahead_size_eio(st
 	if (count > 5)
 		return;
 	count++;
-	printk(KERN_WARNING "Reducing readahead size to %luK\n",
+	printk(KERN_WARNING "Reducing readahead size to %dK\n",
 		ra->ra_pages << (PAGE_CACHE_SHIFT - 10));
 }
 
--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
@@ -342,7 +342,7 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max;	/* max readahead pages */
+	int max;	/* max readahead pages */
 	int sequential;
 
 	max = ra->ra_pages;

--
