Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbZDGXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbZDGXNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZDGXMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbZDGXMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:40 -0400
Date: Tue, 7 Apr 2009 16:06:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 05/13] fsnotify: parent event notification
Message-Id: <20090407160619.dd8748a9.akpm@linux-foundation.org>
In-Reply-To: <20090327200531.32007.62129.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200531.32007.62129.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:32 -0400
Eric Paris <eparis@redhat.com> wrote:

> inotify and dnotify both use a similar parent notification mechanism.  We
> add a generic parent notification mechanism to fsnotify for both of these
> to use.  This new machanism also adds the dentry flag optimization which
> exists for inotify to dnotify.
> 
>
> ...
>
>  /*
> + * Given an inode, first check if we care what happens to out children.  Inotify

"our"

> + * and dnotify both tell their parents about events.  If we care about any event
> + * on a child we run all of our children and set a dentry flag saying that the
> + * parent cares.  Thus when an event happens on a child it can quickly tell if
> + * if there is a need to find a parent and send the event to the parent.
> + */
> +static inline void fsnotify_update_dentry_child_flags(struct inode *inode)
> +{
> +	struct dentry *alias;
> +	int watched;
> +
> +	if (!S_ISDIR(inode->i_mode))
> +		return;
> +
> +	/* determine if the children should tell inode about their events */
> +	watched = fsnotify_inode_watches_children(inode);
> +
> +	spin_lock(&dcache_lock);
> +	/* run all of the dentries associated with this inode.  Since this is a
> +	 * directory, there damn well better only be one item on this list */
> +	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
> +		struct dentry *child;
> +
> +		/* run all of the children of the original inode and fix their
> +		 * d_flags to indicate parental interest (their parent is the
> +		 * original inode) */
> +		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
> +			if (!child->d_inode)
> +				continue;
> +
> +			spin_lock(&child->d_lock);
> +			if (watched)
> +				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
> +			else
> +				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
> +			spin_unlock(&child->d_lock);
> +		}
> +	}
> +	spin_unlock(&dcache_lock);
> +}

Huge function, three callsites, way too large to inline!

afacit all these DCACHE_FSNOTIFY_PARENT_WATCHED bits are left set
without suitable locks being held.  What prevents different threads of
control from setting and clearing them under each others' feet?

The comment should be updated to answer this, please.

>
> ...
>
> +static inline void fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
>  {
> -	inotify_d_instantiate(entry, inode);
> +	__fsnotify_d_instantiate(dentry, inode);
> +
> +	/* call the legacy inotify shit */
> +	inotify_d_instantiate(dentry, inode);
> +}
> +
> +/* Notify this dentry's parent about a child's events. */
> +static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
> +{
> +	struct dentry *parent;
> +	struct inode *p_inode;
> +	char send = 0;
> +
> +	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
> +		return;
> +
> +	/* we are notifying a parent so come up with the new mask which
> +	 * specifies these are events which came from a child. */
> +	mask |= FS_EVENT_ON_CHILD;
> +
> +	spin_lock(&dentry->d_lock);
> +	parent = dentry->d_parent;
> +	p_inode = parent->d_inode;
> +
> +	if (p_inode->i_fsnotify_mask & mask) {
> +		dget(parent);
> +		send = 1;
> +	}
> +
> +	spin_unlock(&dentry->d_lock);
> +
> +	if (send) {
> +		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
> +		dput(parent);
> +	}
>  }

I hereby revoke your inlining license.

>
> ...
>
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -45,8 +45,17 @@
>  #define FS_DN_RENAME		0x10000000ul	/* file renamed */
>  #define FS_DN_MULTISHOT		0x20000000ul	/* dnotify multishot */
>  
> +/* this inode cares about things that happen to it's children.  Always set for

"its"

> + * dnotify and inotify.  never set for fanotify */

You might want to go through the comments and start sentences with
capital latters :(

>  #define FS_EVENT_ON_CHILD	0x08000000ul
>  
> +/* this is a list of all events that may get sent to a parernt based on fs event
> + * happening to inodes inside that directory */
>
> ...
>

