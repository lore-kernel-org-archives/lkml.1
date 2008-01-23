Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYAWNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYAWNa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYAWNas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:30:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:56930 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751357AbYAWNar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:30:47 -0500
Date: Wed, 23 Jan 2008 14:30:45 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Message-ID: <20080123133045.GC10144@duck.suse.cz>
References: <20080122171025.GB4485@duck.suse.cz> <200801231200.03016.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801231200.03016.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-01-08 12:00:02, Nick Piggin wrote:
> On Wednesday 23 January 2008 04:10, Jan Kara wrote:
> >   Hi,
> >
> >   as I got no answer for a week, I'm resending this fix for races in
> > private_list handling. Andrew, do you like them more than the previous
> > version?
> 
> FWIW, I reviewed this, and it looks OK although I think some comments
> would be in order.
  Thanks.

> What would be really nice is to avoid the use of b_assoc_buffers
> completely in this function like I've attempted (untested). I don't
> know if you'd actually call that an improvement...?
  I thought about this solution as well. But main issue I had with this
solution is that currently, you nicely submit all the metadata buffers at
once, so that block layer can sort them and write them in nice order. With
the array you submit buffers by 16 (or any other fixed amount) and in
mostly random order... So IMHO fsync would become measurably slower.

> Couple of things I noticed while looking at this code.
> 
> - What is osync_buffers_list supposed to do? I couldn't actually
>   work it out. Why do we care about waiting for these buffers on
>   here that were added while waiting for writeout of other buffers
>   to finish? Can we just remove it completely? I must be missing
>   something.
  The problem here is that mark_buffer_dirty_inode() can move the buffer
from 'tmp' list back to private_list while we are waiting for another
buffer...

> - What are the get_bh(bh) things supposed to do? Protect the lifetime
>   of a given bh while "lock" is dropped? That's nice, ignoring the
>   fact that we brelse(bh) *before* taking the lock again... but isn't
>   every single other buffer that we _have't_ elevated its reference
>   exposed to exactly the same lifetime problem? IOW, either it is not
>   required at all, or it is required for _all_ buffers? (my patch
>   should fix this).
  I think this get_bh() should stop try_to_free_buffers() from removing the
buffer. brelse() before taking the private_lock is fine, because the loop
actually checks for while (!list_empty(tmp)) so we really don't care what
happens with the buffer after we are done with it. So I think that logic is
actually fine.

> Hmm, now I remember why I rewrote this file :P
  Well, I wrote a patch which cleaned up this logic and got rid of that tmp
list because the handling is really messy but Andrew didn't like it and
wanted just small changes if possible...

> Index: linux-2.6/fs/buffer.c
> ===================================================================
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -792,47 +792,53 @@ EXPORT_SYMBOL(__set_page_dirty_buffers);
>   */
>  static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
>  {
> +	struct buffer_head *batch[16];
> +	int i, idx, done;
>  	struct buffer_head *bh;
> -	struct list_head tmp;
>  	int err = 0, err2;
>  
> -	INIT_LIST_HEAD(&tmp);
> -
> +again:
>  	spin_lock(lock);
> +	idx = 0;
>  	while (!list_empty(list)) {
>  		bh = BH_ENTRY(list->next);
>  		__remove_assoc_queue(bh);
>  		if (buffer_dirty(bh) || buffer_locked(bh)) {
> -			list_add(&bh->b_assoc_buffers, &tmp);
> -			if (buffer_dirty(bh)) {
> -				get_bh(bh);
> -				spin_unlock(lock);
> -				/*
> -				 * Ensure any pending I/O completes so that
> -				 * ll_rw_block() actually writes the current
> -				 * contents - it is a noop if I/O is still in
> -				 * flight on potentially older contents.
> -				 */
> -				ll_rw_block(SWRITE, 1, &bh);
> -				brelse(bh);
> -				spin_lock(lock);
> -			}
> +			batch[idx++] = bh;
> +			get_bh(bh);
>  		}
> +
> +		if (idx == 16)
> +			break;
>  	}
> +	done = list_empty(list);
> +	spin_unlock(lock);
>  
> -	while (!list_empty(&tmp)) {
> -		bh = BH_ENTRY(tmp.prev);
> -		list_del_init(&bh->b_assoc_buffers);
> -		get_bh(bh);
> -		spin_unlock(lock);
> +	for (i = 0; i < idx; i++) {
> +		bh = batch[i];
> +		if (buffer_dirty(bh)) {
> +			/*
> +			 * Ensure any pending I/O completes so
> +			 * that ll_rw_block() actually writes
> +			 * the current contents - it is a noop
> +			 * if I/O is still in flight on
> +			 * potentially older contents.
> +			 */
> +			ll_rw_block(SWRITE, 1, &bh);
> +		}
> +	}
> +	for (i = 0; i < idx; i++) {
> +		bh = batch[i];
>  		wait_on_buffer(bh);
>  		if (!buffer_uptodate(bh))
>  			err = -EIO;
>  		brelse(bh);
> -		spin_lock(lock);
>  	}
> +
> +	idx = 0;
> +	if (!done)
> +		goto again;
>  	
> -	spin_unlock(lock);
>  	err2 = osync_buffers_list(lock, list);
>  	if (err)
>  		return err;

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
