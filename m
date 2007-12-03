Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXLCTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXLCTC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXLCTCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:02:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbXLCTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:02:20 -0500
Date: Mon, 3 Dec 2007 11:01:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Denis V. Lunev" <den@openvz.org>
Cc: devel@openvz.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       dev@openvz.org
Subject: Re: [PATCH] AB-BA deadlock in drop_caches sysctl (resend, the one
 sent was for 2.6.18)
Message-Id: <20071203110143.a18ab4d0.akpm@linux-foundation.org>
In-Reply-To: <20071203135247.GA29579@iris.sw.ru>
References: <20071203135247.GA29579@iris.sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 16:52:47 +0300
"Denis V. Lunev" <den@openvz.org> wrote:

> There is a AB-BA deadlock regarding drop_caches sysctl. Here are the code
> paths:
> 
> drop_pagecache
>   spin_lock(&inode_lock);
>   invalidate_mapping_pages
>     try_to_release_page
>       ext3_releasepage
>         journal_try_to_free_buffers
>           __journal_try_to_free_buffer
> 	    spin_lock(&journal->j_list_lock);
> 
> __journal_temp_unlink_buffer (called under journal->j_list_lock by comments)
>   mark_buffer_dirty
>     __set_page_dirty
>       __mark_inode_dirty
>         spin_lock(&inode_lock);
> 
> The patch tries to address the issue - it drops inode_lock before digging into
> invalidate_inode_pages. This seems sane as inode hold should not gone from the
> list and should not change its place.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> --
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..4ac80d8 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -14,15 +14,27 @@ int sysctl_drop_caches;
>  
>  static void drop_pagecache_sb(struct super_block *sb)
>  {
> -	struct inode *inode;
> +	struct inode *inode, *old;
>  
> +	old = NULL;
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
>  			continue;
> -		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> +		__iget(inode);
> +		spin_unlock(&inode_lock);
> +
> +		if (old != NULL)
> +			iput(old);
> +		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> +		old = inode;
> +
> +		spin_lock(&inode_lock);
>  	}
>  	spin_unlock(&inode_lock);
> +
> +	if (old != NULL)
> +		iput(old);
>  }

We need to hold onto inode_lock while walking sb->s_inodes.  Otherwise the
inode which we're currently looking at could get removed from i_sb_list and
bad things will happen (drop_pagecache_sb will go infinite, or will oops, I
guess).

drop_caches is bad this way - it has a couple of ranking errors.  A
suitable fix would be to remove the drop_caches feature, but it seems to be
fairly popular as a developer thing.  The approach thus far has been "yeah,
sorry about that, but drop_caches is only for development and it is
root-only anyway".

We could fix this particular issue by changing JBD to run
mark_inode_dirty() outside list_lock (which would be a good change
independent of the drop_caches issue) but other problems with drop_caches
will remain.

One way to fix jbd (and jbd2) would be:

static void __journal_temp_unlink_buffer(struct journal_head *jh,
					struct buffer_head **bh_to_dirty)
{
	*bh_to_dirty = NULL;
	...
	if (test_clear_buffer_jbddirty(bh))
		*bh_to_dirty = bh;
}

{
	struct buffer_head *bh_to_dirty;	/* probably needs uninitialized_var() */

	...
	__journal_temp_unlink_buffer(jh, &bh_to_dirty);
	...
	jbd_mark_buffer_dirty(bh_to_dirty);
	brelse(bh_to_dirty);
	...
}

static inline void jbd_mark_buffer_dirty(struct buffer_head *bh)
{
	if (bh)
		mark_buffer_dirty(bh);
}


