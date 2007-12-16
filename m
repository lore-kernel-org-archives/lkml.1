Return-Path: <linux-kernel-owner+w=401wt.eu-S934542AbXLPMGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542AbXLPMGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbXLPMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:33 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60654 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934072AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806668.22519@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120418.498110756@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:35 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] readahead: remove unused do_page_cache_readahead()
Content-Disposition: inline; filename=readahead-remove-do_page_cache_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove do_page_cache_readahead().
Its last user, mmap read-around, has been changed to call ra_submit().

Also, the no-readahead-if-congested logic is not appropriate here. 
Raw 1-page reads can only makes things painfully slower, and
users are pretty sensitive about the slow loading of executables.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/mm.h |    2 --
 mm/readahead.c     |   16 ----------------
 2 files changed, 18 deletions(-)

--- linux-2.6.24-rc4-mm1.orig/include/linux/mm.h
+++ linux-2.6.24-rc4-mm1/include/linux/mm.h
@@ -1084,8 +1084,6 @@ int write_one_page(struct page *page, in
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
--- linux-2.6.24-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc4-mm1/mm/readahead.c
@@ -208,22 +208,6 @@ int force_page_cache_readahead(struct ad
 }
 
 /*
- * This version skips the IO if the queue is read-congested, and will tell the
- * block layer to abandon the readahead if request allocation would block.
- *
- * force_page_cache_readahead() will ignore queue congestion and will block on
- * request queues.
- */
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read)
-{
-	if (bdi_read_congested(mapping->backing_dev_info))
-		return -1;
-
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
-}
-
-/*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */

-- 
