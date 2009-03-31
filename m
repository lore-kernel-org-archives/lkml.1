Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbZCaXlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbZCaXlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765298AbZCaXgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:36:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764742AbZCaXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:36:10 -0400
Date: Tue, 31 Mar 2009 16:33:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks
Message-Id: <20090331163335.46529299.akpm@linux-foundation.org>
In-Reply-To: <1238431208-3894-1-git-send-email-jlayton@redhat.com>
References: <1238431208-3894-1-git-send-email-jlayton@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 12:40:08 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> The dirtied_when value on an inode is supposed to represent the first
> time that an inode has one of its pages dirtied. This value is in units
> of jiffies. It's used in several places in the writeback code to
> determine when to write out an inode.
> 
> The problem is that these checks assume that dirtied_when is updated
> periodically. If an inode is continuously being used for I/O it can be
> persistently marked as dirty and will continue to age. Once the time
> difference between dirtied_when and the jiffies value it is being
> compared to is greater than or equal to half the maximum of the jiffies
> type, the logic of the time_*() macros inverts and the opposite of what
> is needed is returned. On 32-bit architectures that's just under 25 days
> (assuming HZ == 1000).
> 
> As the least-recently dirtied inode, it'll end up being the first one
> that pdflush will try to write out. sync_sb_inodes does this check:
> 
> 	/* Was this inode dirtied after sync_sb_inodes was called? */
>  	if (time_after(inode->dirtied_when, start))
>  		break;
> 
> ...but now dirtied_when appears to be in the future. sync_sb_inodes
> bails out without attempting to write any dirty inodes. When this
> occurs, pdflush will stop writing out inodes for this superblock.
> Nothing can unwedge it until jiffies moves out of the problematic
> window.
> 
> This patch fixes this problem by changing the checks against
> dirtied_when to also check whether it appears to be in the future. If it
> does, then we consider the value to be far in the past.
> 
> This should shrink the problematic window of time to such a small period
> as not to matter.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> Acked-by: Ian Kent <raven@themaw.net>
> ---
>  fs/fs-writeback.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e3fe991..dba69a5 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -196,8 +196,9 @@ static void redirty_tail(struct inode *inode)
>  		struct inode *tail_inode;
>  
>  		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
> -		if (!time_after_eq(inode->dirtied_when,
> -				tail_inode->dirtied_when))
> +		if (time_before(inode->dirtied_when,
> +				tail_inode->dirtied_when) ||
> +		    time_after(inode->dirtied_when, jiffies))
>  			inode->dirtied_when = jiffies;
>  	}
>  	list_move(&inode->i_list, &sb->s_dirty);
> @@ -231,7 +232,8 @@ static void move_expired_inodes(struct list_head *delaying_queue,
>  		struct inode *inode = list_entry(delaying_queue->prev,
>  						struct inode, i_list);
>  		if (older_than_this &&
> -			time_after(inode->dirtied_when, *older_than_this))
> +			time_after(inode->dirtied_when, *older_than_this) &&
> +			time_before_eq(inode->dirtied_when, jiffies))
>  			break;
>  		list_move(&inode->i_list, dispatch_queue);
>  	}
> @@ -493,7 +495,8 @@ void generic_sync_sb_inodes(struct super_block *sb,
>  		}
>  
>  		/* Was this inode dirtied after sync_sb_inodes was called? */
> -		if (time_after(inode->dirtied_when, start))
> +		if (time_after(inode->dirtied_when, start) &&
> +		    time_before_eq(inode->dirtied_when, jiffies))
>  			break;
>  

It'd be nice to add/update the comments to explain what's going on. 
Otherwise it's a wee bit obscure, no?

