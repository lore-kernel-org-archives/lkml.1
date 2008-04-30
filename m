Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYD3R2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYD3R2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbYD3R2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:28:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758194AbYD3R2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:28:03 -0400
Date: Wed, 30 Apr 2008 10:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, mhalcrow@us.ibm.com,
       hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_*
 updates
Message-Id: <20080430101704.9cbd6384.akpm@linux-foundation.org>
In-Reply-To: <200804210650.m3L6ogJe019566@agora.fsl.cs.sunysb.edu>
References: <200804210650.m3L6ogJe019566@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 02:50:42 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> 
> 1. remove the 3rd arg to fsstack_copy_attr_all.  There are no users for it:
>    ecryptfs never used the 3rd arg; unionfs stopped using it a long time
>    ago.  Halcrow ok'ed this patch some time ago.
> 
> 2. add necessary locking for 32-bit smp systems in fsstack_copy_inode_size
>    (courtesy Hugh Dickins).
> 
> 3. minor commenting style changes, and addition of copyrights which were
>    missing.
> 
> Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
>
> ...
>
>  void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
>  {
> -	i_size_write(dst, i_size_read((struct inode *)src));
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> +	spin_lock(&dst->i_lock);
> +#endif

The defined(CONFIG_SMP) is wrong.  The spinlock is here to protect
dst->i_blocks, but it can be corrupted via preemption on uniprocessor as
well.  So a plain old

#if BITS_PER_LONG == 32

would fix that.


> +	i_size_write(dst, i_size_read(src));
>  	dst->i_blocks = src->i_blocks;
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> +	spin_unlock(&dst->i_lock);
> +#endif
>  }

However, what about src->i_blocks?  It is protected by src->i_lock.  The
code as you have it here could read transient values.

Furthermore, i_lock is defined as an innermost lock, for protection of
inode internals.  But here we're proposing "taking" inode->i_size_seqcount
inside i_lock.  Not necessarily a problem, but it broke the old rule.

We're also doing a read_seqlock of a _different_ inode inside this inode's
i_lock.  Again, this is not necessarily a problem (but it might be!) but it
adds complexity and needs thought.


Can we avoid having to think?

void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
{
	blkcnt_t i_blocks;
	loff_t i_size;

	i_size = i_size_read(src);
	spin_lock_32bit(&src->i_lock);
	i_blocks = src->i_blocks;
	spin_unlock_32bit(&src->i_lock);

	i_size_write(dst, i_size);
	spin_lock_32bit(&dst->i_lock)
	dst->i_blocks = i_blocks;
	spin_unlock_32bit(&dst->i_lock)
}


