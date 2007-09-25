Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbXIYMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbXIYMnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXIYMnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:43:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60101 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbXIYMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:43:08 -0400
Date: Tue, 25 Sep 2007 14:42:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, mingo@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [HACK] convert i_alloc_sem for direct_io.c craziness!
Message-ID: <20070925144257.1acedd24@twins>
In-Reply-To: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 17:14:26 -0400 (EDT) Steven Rostedt
<rostedt@goodmis.org> wrote:

> 
> Hopefully I will get some attention from those that are responsible for
> fs/direct_io.c
> 
> Ingo and Thomas,
> 
> This patch converts the i_alloc_sem into a compat_rw_semaphore for the -rt
> patch.  Seems that the code in fs/direct_io.c does some nasty logic with
> the i_alloc_sem.  For DIO_LOCKING, I'm assuming that the i_alloc_sem is
> used as a reference counter for pending requests. When the request is
> made, the down_read is performed. When the request is handled by the block
> softirq, then that softirq does an up on the request. So the owner is not
> the same between down and up. When all requests are handled, the semaphore
> counter should be zero. This keeps away any write access while requests
> are pending.
> 
> Now this may all be well and dandy for vanilla Linux, but it breaks
> miserbly when converted to -rt.
> 
> 1) In RT rw_semaphores must be up'd by the same thread that down's it.
> 
> 2) We can't do PI on the correct processes.
> 
> This patch converts (for now) the i_alloc_sem into a compat_rw_semaphore
> to give back the old features to the sem. This fixes deadlocks that we've
> been having WRT direct_io.  But unfortunately, it now opens up
> unbonded priority inversion with this semaphore.  But really, those that
> can be affected by this, shouldn't be doing disk IO anyway.
> 
> The real fix would be to get rid of the read semaphore trickery in
> direct_io.c.

How about teaching {up,down}_read_non_owner() to barf on rw_semaphore
in -rt?

> Signed-off-by: Steve Rostedt <rostedt@goodmis.org>
> 
> Index: linux-2.6.23-rc4-rt1/include/linux/fs.h
> ===================================================================
> --- linux-2.6.23-rc4-rt1.orig/include/linux/fs.h	2007-09-24 16:58:59.000000000 -0400
> +++ linux-2.6.23-rc4-rt1/include/linux/fs.h	2007-09-24 16:59:11.000000000 -0400
> @@ -577,7 +577,7 @@ struct inode {
>  	umode_t			i_mode;
>  	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
>  	struct mutex		i_mutex;
> -	struct rw_semaphore	i_alloc_sem;
> +	struct compat_rw_semaphore	i_alloc_sem;
>  	const struct inode_operations	*i_op;
>  	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
>  	struct super_block	*i_sb;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
