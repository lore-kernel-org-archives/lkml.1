Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbXITMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbXITMi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXITMiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:38:05 -0400
Received: from pat.uio.no ([129.240.10.15]:57103 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbXITMiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:38:01 -0400
Subject: Re: + git-nfs-vs-nfs-convert-to-new-aops.patch added to -mm tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, nickpiggin@yahoo.com.au
In-Reply-To: <20070920132047.7c2ee42a@twins>
References: <200708202301.l7KN1GAH028291@imap1.linux-foundation.org>
	 <20070920132047.7c2ee42a@twins>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 08:37:56 -0400
Message-Id: <1190291876.6763.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.028)
X-UiO-Scanned: C7DD4F4E094C759ADD5E3D77B58D6C94BB6DF38B
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1287 total 4007095 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 13:20 +0200, Peter Zijlstra wrote:

> > Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> > Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  fs/nfs/file.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff -puN fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops fs/nfs/file.c
> > --- a/fs/nfs/file.c~git-nfs-vs-nfs-convert-to-new-aops
> > +++ a/fs/nfs/file.c
> > @@ -392,6 +392,7 @@ static int nfs_vm_page_mkwrite(struct vm
> >  	struct file *filp = vma->vm_file;
> >  	unsigned pagelen;
> >  	int ret = -EINVAL;
> > +	void *fsdata;
> >  
> >  	lock_page(page);
> >  	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
> > @@ -399,9 +400,13 @@ static int nfs_vm_page_mkwrite(struct vm
> >  	pagelen = nfs_page_length(page);
> >  	if (pagelen == 0)
> >  		goto out_unlock;
> > -	ret = nfs_prepare_write(filp, page, 0, pagelen);
> > +	ret = nfs_write_begin(filp, page->mapping,
> > +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> > +				pagelen, 0, &page, &fsdata);
> >  	if (!ret)
> > -		ret = nfs_commit_write(filp, page, 0, pagelen);
> > +		ret = nfs_write_end(filp, page->mapping,
> > +				(loff_t)page->index << PAGE_CACHE_SHIFT,
> > +				pagelen, pagelen, page, fsdata);
> >  out_unlock:
> >  	unlock_page(page);
> >  	return ret;
> > _
> 
> But even with this patch I deadlock on page lock, just not here
> anymore :-/
> 
> /me continues the mmap write on nfs adventure...
> 
> ---
>  fs/nfs/file.c |   36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/fs/nfs/file.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/file.c
> +++ linux-2.6/fs/nfs/file.c
> @@ -393,22 +393,34 @@ static int nfs_vm_page_mkwrite(struct vm
>  	unsigned pagelen;
>  	int ret = -EINVAL;
>  	void *fsdata;
> +	struct address_space *mapping;
> +	loff_t offset;
>  
>  	lock_page(page);
> -	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
> -		goto out_unlock;
> +	mapping = page->mapping;
> +	if (mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping) {
> +		unlock_page(page);
> +		return -EINVAL;
> +	}
>  	pagelen = nfs_page_length(page);
> -	if (pagelen == 0)
> -		goto out_unlock;
> -	ret = nfs_write_begin(filp, page->mapping,
> -				(loff_t)page->index << PAGE_CACHE_SHIFT,
> -				pagelen, 0, &page, &fsdata);
> -	if (!ret)
> -		ret = nfs_write_end(filp, page->mapping,
> -				(loff_t)page->index << PAGE_CACHE_SHIFT,
> -				pagelen, pagelen, page, fsdata);
> -out_unlock:
> +	offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
>  	unlock_page(page);
> +
> +	/*
> +	 * we can use mapping after releasing the page lock, because:
> +	 * we hold mmap_sem on the fault path, which should pin the vma
> +	 * which should pin the file, which pins the dentry which should
> +	 * hold a reference on inode.
> +	 */
> +
> +	if (pagelen) {
> +		struct page *page2 = NULL;
> +		ret = nfs_write_begin(filp, mapping, offset, pagelen,
> +			       	0, &page2, &fsdata);
> +		if (!ret)
> +			ret = nfs_write_end(filp, mapping, offset, pagelen,
> +				       	pagelen, page2, fsdata);
> +	}
>  	return ret;
>  }

BTW: Ideally, we want to replace this with a "generic_vm_page_mkwrite()"
in mm/filemap.c(?). There is nothing here which is NFS-specific (except
for the fact that we hard-code the callbacks).

Cheers
  Trond

