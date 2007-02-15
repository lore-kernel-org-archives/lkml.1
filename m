Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXBOBcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXBOBcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXBOBcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:32:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:33442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXBOBcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:32:31 -0500
Date: Thu, 15 Feb 2007 02:32:29 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] fs: fix libfs data leak
Message-ID: <20070215013229.GH29797@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


simple_prepare_write leaks uninitialised kernel data. This happens because the
it leaves an uninitialised "hole" over the part of the page that the write is
expected to go to. This is fine, but it then marks the page uptodate, which
means a concurrent read can come in and copy the uninitialised memory into
userspace before it written to.

Fix it by simply marking it uptodate in simple_commit_write instead, after
the hole has been filled in.  This could theoretically break an fs that uses
simple_prepare_write and not simple_commit_write, and that relies on the
incorrect simple_prepare_write behaviour. Luckily, none of those exists in the
tree.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -335,17 +335,18 @@ int simple_prepare_write(struct file *fi
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 		}
-		SetPageUptodate(page);
 	}
 	return 0;
 }
 
 int simple_commit_write(struct file *file, struct page *page,
-			unsigned offset, unsigned to)
+			unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
 	/*
 	 * No need to use i_size_read() here, the i_size
 	 * cannot change under us because we hold the i_mutex.
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt
+++ linux-2.6/Documentation/filesystems/vfs.txt
@@ -617,6 +617,11 @@ struct address_space_operations {
 	In this case the prepare_write will be retried one the lock is
   	regained.
 
+	Note: the page _must not_ be marked uptodate in this function
+	(or anywhere else) unless it actually is uptodate right now. As
+	soon as a page is marked uptodate, it is possible for a concurrent
+	read(2) to copy it to userspace.
+
   commit_write: If prepare_write succeeds, new data will be copied
         into the page and then commit_write will be called.  It will
         typically update the size of the file (if appropriate) and
