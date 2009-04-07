Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZDGXQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZDGXQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZDGXMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZDGXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:51 -0400
Date: Tue, 7 Apr 2009 16:06:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 12/13] fsnotify: handle filesystem unmounts with
 fsnotify marks
Message-Id: <20090407160635.236772e5.akpm@linux-foundation.org>
In-Reply-To: <20090327200611.32007.38991.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200611.32007.38991.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:06:11 -0400
Eric Paris <eparis@redhat.com> wrote:

> When an fs is unmounted with an fsnotify mark entry attached to one of its
> inodes we need to destroy that mark entry and we also (like inotify) send
> an unmount event.
> 
>
> ...
>
> +/**
> + * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
> + * @list: list of inodes being unmounted (sb->s_inodes)
> + *
> + * Called with inode_lock held, protecting the unmounting super block's list
> + * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
> + * We temporarily drop inode_lock, however, and CAN block.
> + */
> +void fsnotify_unmount_inodes(struct list_head *list)
> +{
> +	struct inode *inode, *next_i, *need_iput = NULL;
> +
> +	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
> +		struct inode *need_iput_tmp;
> +
> +		/*
> +		 * If i_count is zero, the inode cannot have any watches and
> +		 * doing an __iget/iput with MS_ACTIVE clear would actually
> +		 * evict all inodes with zero i_count from icache which is
> +		 * unnecessarily violent and may in fact be illegal to do.
> +		 */
> +		if (!atomic_read(&inode->i_count))
> +			continue;
> +
> +		/*
> +		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
> +		 * I_WILL_FREE which is fine because by that point the inode
> +		 * cannot have any associated watches.
> +		 */
> +		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
> +			continue;
> +
> +		need_iput_tmp = need_iput;
> +		need_iput = NULL;
> +
> +		/* In case fsnotify_inode_delete() drops a reference. */
> +		if (inode != need_iput_tmp)
> +			__iget(inode);
> +		else
> +			need_iput_tmp = NULL;
> +
> +		/* In case the dropping of a reference would nuke next_i. */
> +		if ((&next_i->i_sb_list != list) &&
> +		    atomic_read(&next_i->i_count) &&
> +		    !(next_i->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))) {
> +			__iget(next_i);
> +			need_iput = next_i;
> +		}
> +
> +		/*
> +		 * We can safely drop inode_lock here because we hold
> +		 * references on both inode and next_i.  Also no new inodes
> +		 * will be added since the umount has begun.  Finally,
> +		 * iprune_mutex keeps shrink_icache_memory() away.
> +		 */
> +		spin_unlock(&inode_lock);
> +
> +		if (need_iput_tmp)
> +			iput(need_iput_tmp);

iput(NULL) is legal.

> +		/* for each watch, send FS_UNMOUNT and then remove it */
> +		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +
> +		fsnotify_inode_delete(inode);
> +
> +		iput(inode);
> +
> +		spin_lock(&inode_lock);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(fsnotify_unmount_inodes);

Why is it exported?
