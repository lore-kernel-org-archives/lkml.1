Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZLBEh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZLBEh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZLBEhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764922"
Message-Id: <20091202043046.791112765@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/24] HWPOISON: show corrupted file info
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-describe-page-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If file data is corrupted, the user may want to know which file
is corrupted.

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- linux-mm.orig/mm/memory-failure.c	2009-12-01 09:56:21.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-12-01 09:56:23.000000000 +0800
@@ -56,6 +56,47 @@ u64 hwpoison_filter_flags_mask;
 u64 hwpoison_filter_flags_value;
 u32 hwpoison_filter_memcg;
 
+static void describe_page_file(struct page *page)
+{
+	char *name = "?";
+	struct inode *inode;
+	struct dentry *dentry;
+
+	if (PageAnon(page))
+		return;
+
+	if (!page->mapping)
+		return;
+
+	inode = igrab(page->mapping->host);
+	if (!inode)
+		return;
+
+	dentry = d_find_alias(inode);
+
+	if (dentry) {
+		spin_lock(&dentry->d_lock);
+		name = dentry->d_name.name;
+	}
+
+	printk(KERN_ERR
+	       "MCE %#lx: dev %d:%d inode %lu(%s) pgoff %lu%s\n",
+	       page_to_pfn(page),
+	       MAJOR(inode->i_sb->s_dev),
+	       MINOR(inode->i_sb->s_dev),
+	       inode->i_ino,
+	       name,
+	       page->index,
+	       PageDirty(page) ? " corrupted" : "");
+
+	if (dentry) {
+		spin_unlock(&dentry->d_lock);
+		dput(dentry);
+	}
+
+	iput(inode);
+}
+
 static int hwpoison_filter_dev(struct page *p)
 {
 	struct address_space *mapping;
@@ -525,6 +566,8 @@ static int me_pagecache_clean(struct hwp
 		} else {
 			ret = RECOVERED;
 		}
+		if (PageDirty(p) && !PageSwapBacked(p))
+			describe_page_file(p);
 	} else {
 		/*
 		 * If the file system doesn't support it just invalidate


