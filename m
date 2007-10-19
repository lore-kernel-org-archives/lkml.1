Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbXJSNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbXJSNLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXJSNLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:11:13 -0400
Received: from verein.lst.de ([213.95.11.210]:35218 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbXJSNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:11:12 -0400
Date: Fri, 19 Oct 2007 15:11:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] clean up vmtruncate
Message-ID: <20071019131105.GA10406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmtruncate is a twisted maze of gotos, this patch cleans it up to
have a proper if else for the two major cases of extending and
truncating truncate and thus makes it a lot more readable while
keeping exactly the same functinality.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-09-14 13:51:55.000000000 +0200
+++ linux-2.6/mm/memory.c	2007-09-14 13:55:41.000000000 +0200
@@ -2003,50 +2003,49 @@ EXPORT_SYMBOL(unmap_mapping_range);
  */
 int vmtruncate(struct inode * inode, loff_t offset)
 {
-	struct address_space *mapping = inode->i_mapping;
-	unsigned long limit;
+	if (inode->i_size < offset) {
+		unsigned long limit;
 
-	if (inode->i_size < offset)
-		goto do_expand;
-	/*
-	 * truncation of in-use swapfiles is disallowed - it would cause
-	 * subsequent swapout to scribble on the now-freed blocks.
-	 */
-	if (IS_SWAPFILE(inode))
-		goto out_busy;
-	i_size_write(inode, offset);
+		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		if (limit != RLIM_INFINITY && offset > limit)
+			goto out_sig;
+		if (offset > inode->i_sb->s_maxbytes)
+			goto out_big;
+		i_size_write(inode, offset);
+	} else {
+		struct address_space *mapping = inode->i_mapping;
 
-	/*
-	 * unmap_mapping_range is called twice, first simply for efficiency
-	 * so that truncate_inode_pages does fewer single-page unmaps. However
-	 * after this first call, and before truncate_inode_pages finishes,
-	 * it is possible for private pages to be COWed, which remain after
-	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
-	 * call must be made for correctness.
-	 */
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, offset);
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	goto out_truncate;
-
-do_expand:
-	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && offset > limit)
-		goto out_sig;
-	if (offset > inode->i_sb->s_maxbytes)
-		goto out_big;
-	i_size_write(inode, offset);
+		/*
+		 * truncation of in-use swapfiles is disallowed - it would
+		 * cause subsequent swapout to scribble on the now-freed
+		 * blocks.
+		 */
+		if (IS_SWAPFILE(inode))
+			return -ETXTBSY;
+		i_size_write(inode, offset);
+
+		/*
+		 * unmap_mapping_range is called twice, first simply for
+		 * efficiency so that truncate_inode_pages does fewer
+		 * single-page unmaps.  However after this first call, and
+		 * before truncate_inode_pages finishes, it is possible for
+		 * private pages to be COWed, which remain after
+		 * truncate_inode_pages finishes, hence the second
+		 * unmap_mapping_range call must be made for correctness.
+		 */
+		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(mapping, offset);
+		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+	}
 
-out_truncate:
 	if (inode->i_op && inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 	return 0;
+
 out_sig:
 	send_sig(SIGXFSZ, current, 0);
 out_big:
 	return -EFBIG;
-out_busy:
-	return -ETXTBSY;
 }
 EXPORT_SYMBOL(vmtruncate);
 
