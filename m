Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXEIUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXEIUkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXEIUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:40:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353AbXEIUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:40:35 -0400
Date: Wed, 9 May 2007 13:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, adilger@clusterfs.com,
       clameter@sgi.com
Subject: Re: [PATCH 1/4] ext2: remove inode constructor
Message-Id: <20070509133948.814128f4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 12:57:46 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As alloc_inode() touches the same cache line as init_once(), we gain
> nothing from using slab constructors.
> 
> Cc: Stephen C. Tweedie <sct@redhat.com>
> Cc: Andreas Dilger <adilger@clusterfs.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/ext2/super.c |   32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
> 
> Index: 26-mm/fs/ext2/super.c
> ===================================================================
> --- 26-mm.orig/fs/ext2/super.c	2007-05-05 12:26:15.000000000 +0300
> +++ 26-mm/fs/ext2/super.c	2007-05-05 12:30:50.000000000 +0300
> @@ -140,16 +140,24 @@ static struct kmem_cache * ext2_inode_ca
>  static struct inode *ext2_alloc_inode(struct super_block *sb)
>  {
>  	struct ext2_inode_info *ei;
> -	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep,
> -						GFP_KERNEL|__GFP_RECLAIMABLE);
> +	struct inode *inode;
> +
> +	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL|__GFP_RECLAIMABLE);
>  	if (!ei)
>  		return NULL;
> +	rwlock_init(&ei->i_meta_lock);
> +#ifdef CONFIG_EXT2_FS_XATTR
> +	init_rwsem(&ei->xattr_sem);
> +#endif
> +	mutex_init(&ei->truncate_mutex);

ext2 has no truncate_mutex.


These patches are rather tangled up with the unmerged __GFP_RECLAIMABLE
stuff.  I'll duck them for now.

