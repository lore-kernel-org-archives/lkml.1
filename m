Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZDGXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZDGXOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZDGXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbZDGXMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:46 -0400
Date: Tue, 7 Apr 2009 16:06:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 13/13] inotify: reimplement inotify using fsnotify
Message-Id: <20090407160639.18bdfda1.akpm@linux-foundation.org>
In-Reply-To: <20090327200616.32007.95370.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200616.32007.95370.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:06:17 -0400
Eric Paris <eparis@redhat.com> wrote:

> Reimplement inotify_user using fsnotify.  This should be feature for feature
> exactly the same as the original inotify_user.  This does not make any changes
> to the in kernel inotify feature used by audit.  Those patches (and the eventual
> removal of in kernel inotify) will come after the new inotify_user proves to be
> working correctly.
> 
>
> ...
>
> +static inline __u32 inotify_arg_to_mask(u32 arg)
> +{
> +	__u32 mask;
> +
> +	/* FS_* damn sure better equal IN_* */
> +	BUILD_BUG_ON(IN_ACCESS != FS_ACCESS);
> +	BUILD_BUG_ON(IN_MODIFY != FS_MODIFY);
> +	BUILD_BUG_ON(IN_ATTRIB != FS_ATTRIB);
> +	BUILD_BUG_ON(IN_CLOSE_WRITE != FS_CLOSE_WRITE);
> +	BUILD_BUG_ON(IN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
> +	BUILD_BUG_ON(IN_OPEN != FS_OPEN);
> +	BUILD_BUG_ON(IN_MOVED_FROM != FS_MOVED_FROM);
> +	BUILD_BUG_ON(IN_MOVED_TO != FS_MOVED_TO);
> +	BUILD_BUG_ON(IN_CREATE != FS_CREATE);
> +	BUILD_BUG_ON(IN_DELETE != FS_DELETE);
> +	BUILD_BUG_ON(IN_DELETE_SELF != FS_DELETE_SELF);
> +	BUILD_BUG_ON(IN_MOVE_SELF != FS_MOVE_SELF);
> +	BUILD_BUG_ON(IN_Q_OVERFLOW != FS_Q_OVERFLOW);
> +
> +	BUILD_BUG_ON(IN_UNMOUNT != FS_UNMOUNT);
> +	BUILD_BUG_ON(IN_ISDIR != FS_IN_ISDIR);
> +	BUILD_BUG_ON(IN_IGNORED != FS_IN_IGNORED);
> +	BUILD_BUG_ON(IN_ONESHOT != FS_IN_ONESHOT);

These checks can be placed anywhere.  Putting them in a header file
means that they are performed nultiple times per build and slows the
build a bit.

> +	/* everything should accept their own ignored and cares about children */
> +	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
> +
> +	/* mask off the flags used to open the fd */
> +	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
> +
> +	return mask;
> +}
> +
> +static inline u32 inotify_mask_to_arg(__u32 mask)
> +{
> +	u32 arg;
> +
> +	arg = (mask & (IN_ALL_EVENTS | IN_ISDIR | IN_UNMOUNT | IN_IGNORED | IN_Q_OVERFLOW));
> +
> +	return arg;
> +}

	return mask & (IN_ALL_EVENTS|IN_ISDIR|IN_UNMOUNT|IN_IGNORED|
			IN_Q_OVERFLOW);

would suffice.

>
> ...
>
> --- /dev/null
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -0,0 +1,156 @@
> +/*
> + * fs/inotify_user.c - inotify support for userspace
> + *
> + * Authors:
> + *	John McCutchan	<ttb@tentacle.dhs.org>
> + *	Robert Love	<rml@novell.com>
> + *
> + * Copyright (C) 2005 John McCutchan
> + * Copyright 2006 Hewlett-Packard Development Company, L.P.
> + *
> + * Copyright (C) 2009 Eric Paris <Red Hat Inc>
> + * inotify was largely rewriten to make use of the fsnotify infrastructure
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/limits.h>
> +#include <linux/module.h>
> +#include <linux/mount.h>
> +#include <linux/namei.h>
> +#include <linux/poll.h>
> +#include <linux/idr.h>
> +#include <linux/init.h>
> +#include <linux/inotify.h>
> +#include <linux/list.h>
> +#include <linux/syscalls.h>
> +#include <linux/string.h>
> +#include <linux/magic.h>
> +#include <linux/writeback.h>
> +
> +#include "inotify.h"
> +
> +#include <asm/ioctls.h>

Is this include needed?
>
> ...
>
> +void __inotify_free_event_priv(struct inotify_event_private_data *event_priv)
> +{
> +	list_del_init(&event_priv->fsnotify_event_priv_data.event_list);
> +	kmem_cache_free(event_priv_cachep, event_priv);
> +}

Locking for this?  Seems to be event->lock, but inotify_handle_event()
calls this without locks.

>
> ...
>
> --- /dev/null
> +++ b/fs/notify/inotify/inotify_kernel.c
> @@ -0,0 +1,276 @@
> +/*
> + * fs/inotify_user.c - inotify support for userspace
> + *
> + * Authors:
> + *	John McCutchan	<ttb@tentacle.dhs.org>
> + *	Robert Love	<rml@novell.com>
> + *
> + * Copyright (C) 2005 John McCutchan
> + * Copyright 2006 Hewlett-Packard Development Company, L.P.
> + *
> + * Copyright (C) 2009 Eric Paris <Red Hat Inc>
> + * inotify was largely rewriten to make use of the fsnotify infrastructure
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/limits.h>
> +#include <linux/module.h>
> +#include <linux/mount.h>
> +#include <linux/namei.h>
> +#include <linux/poll.h>
> +#include <linux/idr.h>
> +#include <linux/init.h>
> +#include <linux/inotify.h>
> +#include <linux/list.h>
> +#include <linux/syscalls.h>
> +#include <linux/string.h>
> +#include <linux/magic.h>
> +#include <linux/writeback.h>
> +
> +#include "inotify.h"
> +
> +#include <asm/ioctls.h>

Needed?

> +static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
> +struct kmem_cache *event_priv_cachep __read_mostly;
> +static struct fsnotify_event *inotify_ignored_event;
> +
> +atomic_t inotify_grp_num;

In some places you initialise static atomic_t's with ATOMIC_INIT(0). 
In others, not.

We seem to have given up on always initialising these things, so
omitting the initialiser is OK.

> +/*
> + * find_inode - resolve a user-given path to a specific inode
> + */
> +int find_inode(const char __user *dirname, struct path *path, unsigned flags)

A poorly-chosen global identifier.

> +{
> +	int error;
> +
> +	error = user_path_at(AT_FDCWD, dirname, flags, path);
> +	if (error)
> +		return error;
> +	/* you can only watch an inode if you have read permissions on it */
> +	error = inode_permission(path->dentry->d_inode, MAY_READ);
> +	if (error)
> +		path_put(path);
> +	return error;
> +}
> +
>
> ...
>
> +/* ding dong the mark is dead */
> +static void inotify_free_mark(struct fsnotify_mark_entry *entry)
> +{
> +	struct inotify_inode_mark_entry *ientry = (struct inotify_inode_mark_entry *)entry;

container_of(), please.

> +
> +	kmem_cache_free(inotify_inode_mark_cachep, ientry);
> +}
> +
>
> ...
>
> +static int __init inotify_kernel_setup(void)
> +{
> +	inotify_inode_mark_cachep = kmem_cache_create("inotify_mark_entry",
> +					sizeof(struct inotify_inode_mark_entry),
> +					0, SLAB_PANIC, NULL);
> +	event_priv_cachep = kmem_cache_create("inotify_event_priv_cache",
> +					sizeof(struct inotify_event_private_data),
> +					0, SLAB_PANIC, NULL);

KMEM_CACHE()?

> +	inotify_ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL, FSNOTIFY_EVENT_INODE, NULL, 0);
> +	if (!inotify_ignored_event)
> +		panic("unable to allocate the inotify ignored event\n");
> +	return 0;
> +}
>
> ...
>

