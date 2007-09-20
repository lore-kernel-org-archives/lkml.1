Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXITLVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXITLVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXITLUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:20:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXITLUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:20:53 -0400
Date: Thu, 20 Sep 2007 13:20:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       nickpiggin@yahoo.com.au, trond.myklebust@fys.uio.no
Subject: Re: + git-nfs-vs-nfs-convert-to-new-aops.patch added to -mm tree
Message-ID: <20070920132047.7c2ee42a@twins>
In-Reply-To: <200708202301.l7KN1GAH028291@imap1.linux-foundation.org>
References: <200708202301.l7KN1GAH028291@imap1.linux-foundation.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 15:56:10 -0700 akpm@linux-foundation.org wrote:


> ------------------------------------------------------
> Subject: git-nfs vs nfs-convert-to-new-aops
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> nfi if this is correct.  How am I supposed to know how to work out what to put
> in `copied' in write_end?

I can has broken NFS :-)

nfs_write_begin wants to lock the page itself, but we pass it a locked
page.

> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/nfs/file.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff -puN fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops fs/nfs/file.c
> --- a/fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops
> +++ a/fs/nfs/file.c
> @@ -392,6 +392,7 @@ static int nfs_vm_page_mkwrite(struct vm
>  	struct file *filp = vma->vm_file;
>  	unsigned pagelen;
>  	int ret = -EINVAL;
> +	void *fsdata;
>  
>  	lock_page(page);
>  	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
> @@ -399,9 +400,13 @@ static int nfs_vm_page_mkwrite(struct vm
>  	pagelen = nfs_page_length(page);
>  	if (pagelen == 0)
>  		goto out_unlock;
> -	ret = nfs_prepare_write(filp, page, 0, pagelen);
> +	ret = nfs_write_begin(filp, page->mapping,
> +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> +				pagelen, 0, &page, &fsdata);
>  	if (!ret)
> -		ret = nfs_commit_write(filp, page, 0, pagelen);
> +		ret = nfs_write_end(filp, page->mapping,
> +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> +				pagelen, pagelen, page, fsdata);
>  out_unlock:
>  	unlock_page(page);
>  	return ret;
> _

But even with this patch I deadlock on page lock, just not here
anymore :-/

/me continues the mmap write on nfs adventure...

---
 fs/nfs/file.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/nfs/file.c
===================================================================
--- linux-2.6.orig/fs/nfs/file.c
+++ linux-2.6/fs/nfs/file.c
@@ -393,22 +393,34 @@ static int nfs_vm_page_mkwrite(struct vm
 	unsigned pagelen;
 	int ret = -EINVAL;
 	void *fsdata;
+	struct address_space *mapping;
+	loff_t offset;
 
 	lock_page(page);
-	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
-		goto out_unlock;
+	mapping = page->mapping;
+	if (mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping) {
+		unlock_page(page);
+		return -EINVAL;
+	}
 	pagelen = nfs_page_length(page);
-	if (pagelen == 0)
-		goto out_unlock;
-	ret = nfs_write_begin(filp, page->mapping,
-				(loff_t)page->index << PAGE_CACHE_SHIFT,
-				pagelen, 0, &page, &fsdata);
-	if (!ret)
-		ret = nfs_write_end(filp, page->mapping,
-				(loff_t)page->index << PAGE_CACHE_SHIFT,
-				pagelen, pagelen, page, fsdata);
-out_unlock:
+	offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	unlock_page(page);
+
+	/*
+	 * we can use mapping after releasing the page lock, because:
+	 * we hold mmap_sem on the fault path, which should pin the vma
+	 * which should pin the file, which pins the dentry which should
+	 * hold a reference on inode.
+	 */
+
+	if (pagelen) {
+		struct page *page2 = NULL;
+		ret = nfs_write_begin(filp, mapping, offset, pagelen,
+			       	0, &page2, &fsdata);
+		if (!ret)
+			ret = nfs_write_end(filp, mapping, offset, pagelen,
+				       	pagelen, page2, fsdata);
+	}
 	return ret;
 }
 
