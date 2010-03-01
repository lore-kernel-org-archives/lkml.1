Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab0CATrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:47:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0CATrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:47:06 -0500
Subject: Re: [PATCH 1/3] fsnotify: tree-watching support
From: Eric Paris <eparis@redhat.com>
To: Joris Dolderer <vorstadtkind@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100219144653.dc2b1a03.vorstadtkind@googlemail.com>
References: <20100219144653.dc2b1a03.vorstadtkind@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 14:47:02 -0500
Message-ID: <1267472822.10582.104.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 14:46 +0100, Joris Dolderer wrote:
> Add tree-watching support to fsnotify.
> See http://patchwork.kernel.org/patch/79171/ and http://patchwork.kernel.org/patch/79172/ for other patches.
> Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
> ---
>  fs/debugfs/inode.c               |    8 +
>  fs/namei.c                       |   12 +-
>  fs/notify/fsnotify.c             |  189 +++++++++++++++++++++++++++++++--------
>  fs/notify/fsnotify.h             |    1 
>  fs/notify/inode_mark.c           |   46 ++++++++-
>  include/linux/dcache.h           |    3 
>  include/linux/fsnotify.h         |   55 +++++++----
>  include/linux/fsnotify_backend.h |   51 +++++++---
>  8 files changed, 282 insertions(+), 83 deletions(-)
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 037e878..17cd902 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c
> @@ -76,55 +76,165 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
>  	spin_unlock(&dcache_lock);
>  }
>  
> -/* Notify this dentry's parent about a child's events. */
> -void __fsnotify_parent(struct dentry *dentry, __u32 mask)
> +/*
> + * Does the work when updating descents of a dentry
> + */
> +static void fsnotify_update_descents(struct dentry *dentry, bool watched)
>  {
> -	struct dentry *parent;
> -	struct inode *p_inode;
> -	bool send = false;
> -	bool should_update_children = false;
> +	struct dentry *child;
> +
> +	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
> +		if (!child->d_inode)
> +			continue;
> +
> +		spin_lock(&child->d_lock);
> +
> +		if (watched)
> +			child->d_flags |= DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
> +		else
> +			child->d_flags &= ~DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
> +
> +		if (!fsnotify_inode_watches_descents(child->d_inode)) {
> +			fsnotify_update_descents(child, watched);
> +		}
> +
> +		spin_unlock(&child->d_lock);
> +	}
> +}

I haven't tested the code at all, just started to even peek at it and
only made it this far.....

Did you run this with lockdep enabled?  Turn it on, understand and fix
anything it complains about.

Any kind of recursion, especially that which is not tail recursion is
highly frowned upon.

What happens when you do

mkdir /tmp/subdir
ln -s ../ /tmp/subdir/upone

and then put a recursive watch on /tmp?

I'm betting deadlock for 1 of 2 reasons, either you

A) try to take the dentry->d_lock on subdir twice (deadlock)
B) run indefinitely around the /tmp -> /tmp/subdir -> /tmp/subdir/upone
-> /tmp/subidr -> /tmp/subdir/upone -> ... loop.

Maybe I'm missing something, but both of these make this a
non-starter....

Maybe symlinks don't break like that, but I'm betting I could do A with
bind mounts if not B.....

-Eric

