Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYCYTyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYCYTyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYCYTyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:54:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYCYTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:54:34 -0400
Date: Tue, 25 Mar 2008 12:53:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: dgc@sgi.com, wfg@mail.ustc.edu.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix lock inversion in drop_pagecache_sb()
Message-Id: <20080325125354.5f2da108.akpm@linux-foundation.org>
In-Reply-To: <20080325181227.GE5125@duck.suse.cz>
References: <20080325181227.GE5125@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 19:12:27 +0100
Jan Kara <jack@suse.cz> wrote:

> Fix longstanding lock inversion in drop_pagecache_sb by dropping inode_lock
> before calling __invalidate_mapping_pages(). We just have to make sure
> inode won't go away from under us by keeping reference to it and putting
> the reference only after we have safely resumed the scan of the inode
> list. A bit tricky but not too bad...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: Fengguang Wu <wfg@mail.ustc.edu.cn>
> CC: David Chinner <dgc@sgi.com>
> 
> ---
>  fs/drop_caches.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..f5aae26 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -14,15 +14,21 @@ int sysctl_drop_caches;
>  
>  static void drop_pagecache_sb(struct super_block *sb)
>  {
> -	struct inode *inode;
> +	struct inode *inode, *toput_inode = NULL;
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
>  			continue;

OT: it might be worth having an `if (mapping->nrpages==0) continue' here.

> +		__iget(inode);
> +		spin_unlock(&inode_lock);
>  		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> +		iput(toput_inode);
> +		toput_inode = inode;
> +		spin_lock(&inode_lock);
>  	}
>  	spin_unlock(&inode_lock);
> +	iput(toput_inode);
>  }
>  
>  void drop_pagecache(void)

hrm.  So we have a random ref on an inode without holding inode_lock.  If
we race with invalidate_list() we end up with an inode stuck on s_inodes
and "Self-destruct in 5 seconds.  Have a nice day...", don't we?
