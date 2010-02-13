Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0BMTMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:12:18 -0500
Received: from xenotime.net ([72.52.64.118]:49077 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757586Ab0BMTMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:12:17 -0500
Message-ID: <4B76F98F.6080802@xenotime.net>
Date: Sat, 13 Feb 2010 11:12:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Joris Dolderer <vorstadtkind@googlemail.com>
CC: linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: Re: [PATCH 1/3] fsnotify: tree-watching support
References: <20100213100521.cb9c8310.vorstadtkind@googlemail.com>
In-Reply-To: <20100213100521.cb9c8310.vorstadtkind@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/10 01:05, Joris Dolderer wrote:
> Add tree-watching support to fsnotify.
> Hope mail works now...

Yes, much better, thanks.

The following review just concerns documentation...

> Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
> ---
>  fs/debugfs/inode.c               |    8 -
>  fs/namei.c                       |    8 -
>  fs/notify/fsnotify.c             |  188 +++++++++++++++++++++++------
>  fs/notify/fsnotify.h             |    1 
>  fs/notify/inode_mark.c           |   46 ++++++-
>  include/linux/dcache.h           |    3 
>  include/linux/fsnotify.h         |   55 +++++---
>  include/linux/fsnotify_backend.h |   51 +++++--
>  8 files changed, 279 insertions(+), 81 deletions(-)


> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 037e878..17cd902 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c

[snip]

> +/* Notify this dentry's ancestors about a child's events. */
> +void __fsnotify_ancestors(struct dentry *dentry, __u32 mask)
> +{
> +	if (dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED) {
> +		struct dentry *parent;
> +		struct inode *p_inode;
> +		bool should_update_children = false;
> +		bool send = false;
> +
> +		spin_lock(&dentry->d_lock);
> +
> +		parent = dentry->d_parent;
> +		p_inode = parent->d_inode;
>  
> -	if (fsnotify_inode_watches_children(p_inode)) {
> -		if (p_inode->i_fsnotify_mask & mask) {
> +		if (fsnotify_inode_watches_children(p_inode)) {
> +			if (p_inode->i_fsnotify_mask & mask) {
> +				dget(parent);
> +				send = true;
> +			}
> +		} else {
> +			/*
> +			 * The parent doesn't care about events on it's children but

			                                           its
(yes, it's just moved, but please correct it)
("it's" means "it is", not possessive)

> +			 * at least one child thought it did.  We need to run all the
> +			 * children and update their d_flags to let them know p_inode
> +			 * doesn't care about them any more.
> +			 */
>  			dget(parent);
> -			send = true;
> +			should_update_children = true;
>  		}

[snip]

> +}
> +EXPORT_SYMBOL_GPL(__fsnotify_ancestors);
> +
> +/*
> + * notify tree-watching ancestors
> + * @dentry: The dentry the walkup should start with
> + * @file_name: The string that should be appended to this dentries' path
> + * @file_len: The length of this string
> + */

Please use kernel-doc notation for this and other exported symbols.
See Documentation/kernel-doc-nano-HOWTO.txt for details, or ask me if you
have questions about it.

E.g.:

/**
 * fsnotify_far_ancestors - notify tree-watching ancestors
 * @dentry: The dentry the walkup should start with
 * @file_name: The string that should be appended to this dentries' path
 * @file_len: The length of this string
 * @mask:  <description>
 */


> +void fsnotify_far_ancestors(struct dentry *dentry, const unsigned char *file_name, int file_len, __u32 mask)
> +{
...

>  }
> -EXPORT_SYMBOL_GPL(__fsnotify_parent);
> +EXPORT_SYMBOL_GPL(fsnotify_far_ancestors);
>  
>  /*
>   * This is the main call to fsnotify.  The VFS calls into hook specific functions

> diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
> index 3165d85..67ad9cb 100644
> --- a/fs/notify/inode_mark.c
> +++ b/fs/notify/inode_mark.c
> @@ -195,14 +216,16 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
>  
>  	/*
>  	 * __fsnotify_update_child_dentry_flags(inode);
> +	 * or __fsnotify_update_descents;
>  	 *
>  	 * I really want to call that, but we can't, we have no idea if the inode
>  	 * still exists the second we drop the entry->lock.
>  	 *
>  	 * The next time an event arrive to this inode from one of it's children

	                          arrives                          its

> -	 * __fsnotify_parent will see that the inode doesn't care about it's
> -	 * children and will update all of these flags then.  So really this
> -	 * is just a lazy update (and could be a perf win...)
> +	 * __fsnotify_ancestors resp. fsnotify_far_ancestors will see that the

What is "resp." ?

> +	 * inode doesn't care about it's children and will update all of these

	                            its

> +	 * flags then.  So really this is just a lazy update (and could be a
> +	 * perf win...)
>  	 */

> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index 4d6f47b..1bea473 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h

[snip]

> -static inline int fsnotify_inode_watches_children(struct inode *inode)
> +static inline bool fsnotify_inode_watches_something(struct inode *inode, u32 what)
>  {
> -	/* FS_EVENT_ON_CHILD is set if the inode may care */
> -	if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
> +	/* what is set if the inode may care */
> +	if (!(inode->i_fsnotify_mask & what))
>  		return 0;

		return false;

>  	/* this inode might care about child events, does it care about the
>  	 * specific set of events that can happen on a child? */
>  	return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
>  }


-- 
~Randy
