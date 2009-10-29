Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZJ2PRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZJ2PRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZJ2PRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:17:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbZJ2PRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:17:48 -0400
Date: Thu, 29 Oct 2009 08:17:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: Mike Hommey <mh@glandium.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Message-Id: <20091029081701.83249755.akpm@linux-foundation.org>
In-Reply-To: <20091029124055.GB7436@localhost.localdomain>
References: <1256577868-30484-1-git-send-email-mh@glandium.org>
	<20091028230022.e15b1e9c.akpm@linux-foundation.org>
	<20091029123153.GA7436@localhost.localdomain>
	<20091029124055.GB7436@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 08:40:56 -0400 Josef Bacik <josef@redhat.com> wrote:

> 
> Ok here it is.  I've fixed all the type issues and there were other problems
> with not setting FIEMAP_EXTENT_LAST last properly.  If this is more reasonable
> to you I will update it and send it along properly.  Thanks,

geeze, how did we lose a patch of this magnitude?

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index ac2d47e..ee9fba0 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -228,13 +228,22 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
>  
>  #ifdef CONFIG_BLOCK
>  
> -#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
> -#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
> +static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
> +{
> +	return (offset >> inode->i_blkbits);
> +}
> +
> +static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
> +{
> +	return (blk << inode->i_blkbits);
> +}

ah.  Adding the types really does clarify things.

>  /**
>   * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
>   * @inode - the inode to map
> - * @arg - the pointer to userspace where we copy everything to
> + * @fieinfo - the fiemap info struct that will be passed back to userspace
> + * @start - where to start mapping in the inode
> + * @len - how much space to map
>   * @get_block - the fs's get_block function
>   *
>   * This does FIEMAP for block based inodes.  Basically it will just loop
> @@ -250,43 +259,63 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
>   */
>  
>  int __generic_block_fiemap(struct inode *inode,
> -			   struct fiemap_extent_info *fieinfo, u64 start,
> -			   u64 len, get_block_t *get_block)
> +			   struct fiemap_extent_info *fieinfo, loff_t start,
> +			   loff_t len, get_block_t *get_block)
>  {
> -	struct buffer_head tmp;
> -	unsigned int start_blk;
> -	long long length = 0, map_len = 0;
> +	struct buffer_head map_bh;
> +	sector_t start_blk;

And the bugfix is there.

Has anyone actually tested this code on large files?  Greater than 4G
sectors and greater than 4G pages?


