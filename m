Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbXCHRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbXCHRab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXCHRaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:30:30 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56661 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbXCHRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:30:28 -0500
Date: Thu, 8 Mar 2007 09:30:06 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 5/6] integrity: mtime patch for mmap files
Message-ID: <20070308173006.GO6602@sequoia.sous-sol.org>
References: <1173369853.5981.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173369853.5981.5.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> This is a minimal subset of Peter Staubach's July patch, updated to
> apply to the latest kernel. The subset was chosen to demonstrate that
> mmaped files are hashed and hmac properly by EVM after being modified
> when a file's mtime is updated correctly.

Would make sense to Cc Peter on fsdevel on this.

> Index: linux-2.6.21-rc3-mm2/fs/inode.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/inode.c
> +++ linux-2.6.21-rc3-mm2/fs/inode.c
> @@ -1209,8 +1209,8 @@ void touch_atime(struct vfsmount *mnt, s
>  EXPORT_SYMBOL(touch_atime);
>  
>  /**
> - *	file_update_time	-	update mtime and ctime time
> - *	@file: file accessed
> + *	inode_update_time	-	update mtime and ctime time
> + *	@inode: file accessed
>   *
>   *	Update the mtime and ctime members of an inode and mark the inode
>   *	for writeback.  Note that this function is meant exclusively for
> @@ -1220,9 +1220,8 @@ EXPORT_SYMBOL(touch_atime);
>   *	timestamps are handled by the server.
>   */
>  
> -void file_update_time(struct file *file)
> +void inode_update_time(struct inode *inode)
>  {
> -	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct timespec now;
>  	int sync_it = 0;
>  
> @@ -1246,7 +1245,7 @@ void file_update_time(struct file *file)
>  		mark_inode_dirty_sync(inode);
>  }
>  
> -EXPORT_SYMBOL(file_update_time);
> +EXPORT_SYMBOL(inode_update_time);
>  
>  int inode_needs_sync(struct inode *inode)
>  {
> Index: linux-2.6.21-rc3-mm2/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/fs-writeback.c
> +++ linux-2.6.21-rc3-mm2/fs/fs-writeback.c
> @@ -167,6 +167,9 @@ __sync_single_inode(struct inode *inode,
>  
>  	spin_unlock(&inode_lock);
>  
> +	if (test_and_clear_bit(AS_MCTIME, &mapping->flags))
> +		inode_update_time(inode);
> +
>  	ret = do_writepages(mapping, wbc);
>  
>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
> Index: linux-2.6.21-rc3-mm2/fs/buffer.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/fs/buffer.c
> +++ linux-2.6.21-rc3-mm2/fs/buffer.c
> @@ -734,8 +734,11 @@ int __set_page_dirty_buffers(struct page
>  	}
>  	spin_unlock(&mapping->private_lock);
>  
> -	if (TestSetPageDirty(page))
> +	if (TestSetPageDirty(page)) {
> +		if (page_mapped(page))
> +			set_bit(AS_MCTIME, &mapping->flags);
>  		return 0;
> +	}
>  
>  	write_lock_irq(&mapping->tree_lock);
>  	if (page->mapping) {	/* Race with truncate? */
> @@ -749,6 +752,8 @@ int __set_page_dirty_buffers(struct page
>  	}
>  	write_unlock_irq(&mapping->tree_lock);
>  	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +	if (page_mapped(page))
> +		set_bit(AS_MCTIME, &mapping->flags);
>  	return 1;
>  }
>  EXPORT_SYMBOL(__set_page_dirty_buffers);
> Index: linux-2.6.21-rc3-mm2/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/include/linux/fs.h
> +++ linux-2.6.21-rc3-mm2/include/linux/fs.h
> @@ -1944,7 +1944,12 @@ extern int buffer_migrate_page(struct ad
>  extern int inode_change_ok(struct inode *, struct iattr *);
>  extern int __must_check inode_setattr(struct inode *, struct iattr *);
>  
> -extern void file_update_time(struct file *file);
> +extern void inode_update_time(struct inode *);
> +
> +static inline void file_update_time(struct file *file)
> +{
> +	inode_update_time(file->f_dentry->d_inode);

s/f_dentry/f_path.dentry/

> +}
>  
>  static inline ino_t parent_ino(struct dentry *dentry)
>  {
> Index: linux-2.6.21-rc3-mm2/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/include/linux/pagemap.h
> +++ linux-2.6.21-rc3-mm2/include/linux/pagemap.h
> @@ -17,8 +17,9 @@
>   * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
>   * allocation mode flags.
>   */
> -#define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
> +#define AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
>  #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
> +#define AS_MCTIME	(__GFP_BITS_SHIFT + 2)	/* need m/ctime change */
>  
>  static inline void mapping_set_error(struct address_space *mapping, int error)
>  {
> Index: linux-2.6.21-rc3-mm2/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/mm/page-writeback.c
> +++ linux-2.6.21-rc3-mm2/mm/page-writeback.c
> @@ -815,8 +815,10 @@ int __set_page_dirty_no_writeback(struct
>   */
>  int __set_page_dirty_nobuffers(struct page *page)
>  {
> +	struct address_space *mapping = page_mapping(page);
> +	int ret = 0;
> +
>  	if (!TestSetPageDirty(page)) {
> -		struct address_space *mapping = page_mapping(page);
>  		struct address_space *mapping2;
>  
>  		if (!mapping)
> @@ -840,9 +842,11 @@ int __set_page_dirty_nobuffers(struct pa
>  			/* !PageAnon && !swapper_space */
>  			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  		}
> -		return 1;
> +		ret = 1;
>  	}
> -	return 0;
> +	if (page_mapped(page))
> +		set_bit(AS_MCTIME, &mapping->flags);

Don't you want 'if (mapping)' here?  And why update mctime when the
page isn't dirty?
