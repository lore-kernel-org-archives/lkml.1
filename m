Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbXHVJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbXHVJLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbXHVIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:53 -0400
Received: from 1wt.eu ([62.212.114.60]:2174 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164AbXHVIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:48 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084022.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:15 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 31/58] readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
Content-Disposition: inline; filename=0031-readahead-MIN_RA_PAGES-MAX_RA_PAGES-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Define two convenient macros for read-ahead:
	- MAX_RA_PAGES: rounded down counterpart of VM_MAX_READAHEAD
	- MIN_RA_PAGES: rounded _up_ counterpart of VM_MIN_READAHEAD

Note that the rounded up MIN_RA_PAGES will work flawlessly with _large_
page sizes like 64k.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/readahead.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 0f539e8..f26cdea 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -21,8 +21,16 @@ void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
+/*
+ * Convienent macros for min/max read-ahead pages.
+ * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
+ * The latter is necessary for systems with large page size(i.e. 64k).
+ */
+#define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
+#define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
+
 struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE,
+	.ra_pages	= MAX_RA_PAGES,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,
@@ -51,7 +59,7 @@ static inline unsigned long get_max_readahead(struct file_ra_state *ra)
 
 static inline unsigned long get_min_readahead(struct file_ra_state *ra)
 {
-	return (VM_MIN_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	return MIN_RA_PAGES;
 }
 
 static inline void reset_ahead_window(struct file_ra_state *ra)
-- 
1.5.2.5

-- 
