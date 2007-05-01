Return-Path: <linux-kernel-owner+w=401wt.eu-S1161698AbXEAK2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161698AbXEAK2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161691AbXEAK2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:28:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161698AbXEAK2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:28:07 -0400
Subject: [GFS2] Patch to fix mmap of stuffed files [31/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:23:33 +0100
Message-Id: <1178015013.5462.192.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From bf126aee6d54fe1e509846abf3b27aba84c6d7ce Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 20 Apr 2007 09:18:30 +0100
Subject: [PATCH] [GFS2] Patch to fix mmap of stuffed files

If a stuffed file is mmaped and a page fault is generated at some offset
above the initial page, we need to create a zero page to hang the buffer
heads off before we can unstuff the file. This is a fix for bz #236087

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 90c2879..30c1562 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -197,7 +197,19 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 	void *kaddr;
 	int error;
 
-	BUG_ON(page->index);
+	/*
+	 * Due to the order of unstuffing files and ->nopage(), we can be
+	 * asked for a zero page in the case of a stuffed file being extended,
+	 * so we need to supply one here. It doesn't happen often.
+	 */
+	if (unlikely(page->index)) {
+		kaddr = kmap_atomic(page, KM_USER0);
+		memset(kaddr, 0, PAGE_CACHE_SIZE);
+		kunmap_atomic(kaddr, KM_USER0);
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+		return 0;
+	}
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
@@ -208,9 +220,8 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 	       ip->i_di.di_size);
 	memset(kaddr + ip->i_di.di_size, 0, PAGE_CACHE_SIZE - ip->i_di.di_size);
 	kunmap_atomic(kaddr, KM_USER0);
-
+	flush_dcache_page(page);
 	brelse(dibh);
-
 	SetPageUptodate(page);
 
 	return 0;
-- 
1.5.1.2



