Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZDGXpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZDGXpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZDGXpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:45:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60446 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZDGXpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:45:31 -0400
Date: Tue, 7 Apr 2009 16:45:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/13] fsnotify: unified filesystem notification backend
Message-ID: <20090407234528.GA21258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com> <20090319180502.17449.54673.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319180502.17449.54673.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:05:03PM -0400, Eric Paris wrote:
> fsnotify is a backend for filesystem notification.  fsnotify does
> not provide any userspace interface but does provide the basis
> needed for other notification schemes such as dnotify.  fsnotify
> can be extended to be the backend for inotify or the upcoming
> fanotify.  fsnotify provides a mechanism for "groups" to register for
> some set of filesystem events and to then deliver those events to
> those groups for processing.
> 
> fsnotify has a number of benefits, the first being actually shrinking the size
> of an inode.  Before fsnotify to support both dnotify and inotify an inode had
> 
>         unsigned long           i_dnotify_mask; /* Directory notify events */
>         struct dnotify_struct   *i_dnotify; /* for directory notifications */
>         struct list_head        inotify_watches; /* watches on this inode */
>         struct mutex            inotify_mutex;  /* protects the watches list
> 
> But with fsnotify this same functionallity (and more) is done with just
> 
>         __u32                   i_fsnotify_mask; /* all events for this inode */
>         struct hlist_head       i_fsnotify_mark_entries; /* marks on this inode */
> 
> That's right, inotify, dnotify, and fanotify all in 64 bits.  We used that
> much space just in inotify_watches alone, before this patch set.
> 
> fsnotify object lifetime and locking is MUCH better than what we have today.
> inotify locking is incredibly complex.  See 8f7b0ba1c8539 as an example of
> what's been busted since inception.  inotify needs to know internal semantics
> of superblock destruction and unmounting to function.  The inode pinning and
> vfs contortions are horrible.
> 
> no fsnotify implementers do allocation under locks.  This means things like
> f04b30de3 which (due to an overabundance of caution) changes GFP_KERNEL to
> GFP_NOFS can be reverted.  There are no longer any allocation rules when using
> or implementing your own fsnotify listener.
> 
> fsnotify paves the way for fanotify.  people may not care for the original
> companies that pushed for TALPA, but fanotify was designed with flexibility in
> mind.  A first group that wants fanotify like interfaces is the readahead
> group.  So they can be profiling at boot time in order to dynamicly tune
> readahead to help with boot speed.  I've got other ideas how to use fanotify
> to speed up boot when dealing with encrypted mounts, but I'm not ready to say
> it yet since I don't know if my idea will work.
> 
> This patch series just builds fsnotify to the point that it can implement
> dnotify and inotify_user.  Patches exist and will be sent soon after
> acceptance to finish the in kernel inotify conversion (audit) and implement
> fanotify.

Looks good from an SRCU viewpoint.  The only comment I have (other than
running commentary interspersed) is why no

	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));

in fsnotify_add_group().

You have a global lock fsnotify_grp_mutex covering all of the updates
I can see, use fsnotify_grp_srcu consistently, and have all traversals
covered either by srcu_read_lock() or fsnotify_grp_mutex.

							Thanx, Paul

> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  fs/notify/Kconfig                |   13 +++
>  fs/notify/Makefile               |    2 
>  fs/notify/fsnotify.c             |   79 ++++++++++++++++++
>  fs/notify/fsnotify.h             |   17 ++++
>  fs/notify/group.c                |  168 ++++++++++++++++++++++++++++++++++++++
>  fs/notify/notification.c         |  116 ++++++++++++++++++++++++++
>  include/linux/fsnotify.h         |  129 +++++++++++++++++++++--------
>  include/linux/fsnotify_backend.h |  135 +++++++++++++++++++++++++++++++
>  8 files changed, 622 insertions(+), 37 deletions(-)
>  create mode 100644 fs/notify/fsnotify.c
>  create mode 100644 fs/notify/fsnotify.h
>  create mode 100644 fs/notify/group.c
>  create mode 100644 fs/notify/notification.c
>  create mode 100644 include/linux/fsnotify_backend.h
> 
> diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
> index 50914d7..31dac7e 100644
> --- a/fs/notify/Kconfig
> +++ b/fs/notify/Kconfig
> @@ -1,2 +1,15 @@
> +config FSNOTIFY
> +	bool "Filesystem notification backend"
> +	default y
> +	---help---
> +	   fsnotify is a backend for filesystem notification.  fsnotify does
> +	   not provide any userspace interface but does provide the basis
> +	   needed for other notification schemes such as dnotify, inotify,
> +	   and fanotify.
> +
> +	   Say Y here to enable fsnotify suport.
> +
> +	   If unsure, say Y.
> +
>  source "fs/notify/dnotify/Kconfig"
>  source "fs/notify/inotify/Kconfig"
> diff --git a/fs/notify/Makefile b/fs/notify/Makefile
> index 5a95b60..db5467b 100644
> --- a/fs/notify/Makefile
> +++ b/fs/notify/Makefile
> @@ -1,2 +1,4 @@
> +obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
> +
>  obj-y			+= dnotify/
>  obj-y			+= inotify/
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> new file mode 100644
> index 0000000..56bee0f
> --- /dev/null
> +++ b/fs/notify/fsnotify.c
> @@ -0,0 +1,79 @@
> +/*
> + *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2, or (at your option)
> + *  any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/dcache.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/srcu.h>
> +
> +#include <linux/fsnotify_backend.h>
> +#include "fsnotify.h"
> +
> +/*
> + * This is the main call to fsnotify.  The VFS calls into hook specific functions
> + * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
> + * out to all of the registered fsnotify_group.  Those groups can then use the
> + * notification event in whatever means they feel necessary.
> + */
> +void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
> +{
> +	struct fsnotify_group *group;
> +	struct fsnotify_event *event = NULL;
> +	int idx;
> +
> +	if (list_empty(&fsnotify_groups))
> +		return;
> +
> +	if (!(mask & fsnotify_mask))
> +		return;
> +
> +	/*
> +	 * SRCU!!  the groups list is very very much read only and the path is
> +	 * very hot.  The VAST majority of events are not going to need to do
> +	 * anything other than walk the list so it's crazy to pre-allocate.
> +	 */
> +	idx = srcu_read_lock(&fsnotify_grp_srcu);

All the srcu operations use the same srcu_struct, as required.

> +	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {

Under srcu_read_lock(), as required.

> +		if (mask & group->mask) {
> +			if (!event) {
> +				event = fsnotify_create_event(to_tell, mask, data, data_is);
> +				/* shit, we OOM'd and now we can't tell, maybe
> +				 * someday someone else will want to do something
> +				 * here */
> +				if (!event)
> +					break;
> +			}
> +			group->ops->handle_event(group, event);
> +		}
> +	}
> +	srcu_read_unlock(&fsnotify_grp_srcu, idx);
> +	/*
> +	 * fsnotify_create_event() took a reference so the event can't be cleaned
> +	 * up while we are still trying to add it to lists, drop that one.
> +	 */
> +	if (event)
> +		fsnotify_put_event(event);
> +}
> +EXPORT_SYMBOL_GPL(fsnotify);
> +
> +static __init int fsnotify_init(void)
> +{
> +	return init_srcu_struct(&fsnotify_grp_srcu);
> +}
> +subsys_initcall(fsnotify_init);
> diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
> new file mode 100644
> index 0000000..bf41e60
> --- /dev/null
> +++ b/fs/notify/fsnotify.h
> @@ -0,0 +1,17 @@
> +#ifndef _LINUX_FSNOTIFY_PRIVATE_H
> +#define _LINUX_FSNOTIFY_PRIVATE_H
> +
> +#include <linux/dcache.h>
> +#include <linux/list.h>
> +#include <linux/fs.h>
> +#include <linux/path.h>
> +#include <linux/spinlock.h>
> +
> +#include <linux/fsnotify.h>
> +
> +#include <asm/atomic.h>
> +
> +extern struct srcu_struct fsnotify_grp_srcu;
> +extern struct list_head fsnotify_groups;
> +extern __u32 fsnotify_mask;
> +#endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
> diff --git a/fs/notify/group.c b/fs/notify/group.c
> new file mode 100644
> index 0000000..88d040b
> --- /dev/null
> +++ b/fs/notify/group.c
> @@ -0,0 +1,168 @@
> +/*
> + *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2, or (at your option)
> + *  any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/srcu.h>
> +#include <linux/rculist.h>
> +#include <linux/wait.h>
> +
> +#include <linux/fsnotify_backend.h>
> +#include "fsnotify.h"
> +
> +#include <asm/atomic.h>
> +
> +DEFINE_MUTEX(fsnotify_grp_mutex);
> +struct srcu_struct fsnotify_grp_srcu;
> +LIST_HEAD(fsnotify_groups);
> +__u32 fsnotify_mask;
> +
> +void fsnotify_recalc_global_mask(void)
> +{
> +	struct fsnotify_group *group;
> +	__u32 mask = 0;
> +	int idx;
> +
> +	idx = srcu_read_lock(&fsnotify_grp_srcu);
> +	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {

Under srcu_read_lock(), as required.

> +		mask |= group->mask;
> +	}
> +	srcu_read_unlock(&fsnotify_grp_srcu, idx);
> +	fsnotify_mask = mask;
> +}
> +
> +static void fsnotify_add_group(struct fsnotify_group *group)
> +{
> +	list_add_rcu(&group->group_list, &fsnotify_groups);

OK, protected by fsnotify_grp_mutex.

Can't resist asking why no "BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));",
though.  ;-)

> +	group->evicted = 0;
> +}
> +
> +static void fsnotify_get_group(struct fsnotify_group *group)
> +{
> +	atomic_inc(&group->refcnt);
> +}
> +
> +static void fsnotify_destroy_group(struct fsnotify_group *group)
> +{
> +	if (group->ops->free_group_priv)
> +		group->ops->free_group_priv(group);
> +
> +	kfree(group);
> +}
> +
> +static void __fsnotify_evict_group(struct fsnotify_group *group)
> +{
> +	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
> +
> +	if (!group->evicted)
> +		list_del_rcu(&group->group_list);

OK, protected by fsnotify_grp_mutex or the BUG_ON trips.  ;-)

> +	group->evicted = 1;
> +}
> +
> +void fsnotify_evict_group(struct fsnotify_group *group)
> +{
> +	mutex_lock(&fsnotify_grp_mutex);
> +	__fsnotify_evict_group(group);
> +	mutex_unlock(&fsnotify_grp_mutex);
> +}
> +
> +void fsnotify_put_group(struct fsnotify_group *group)
> +{
> +	if (!atomic_dec_and_mutex_lock(&group->refcnt, &fsnotify_grp_mutex))
> +		return;
> +
> +	/* OK, now we know that there's no other users *and* we hold mutex,
> +	 * so no new references will appear */
> +	__fsnotify_evict_group(group);
> +
> +	/* now it's off the list, so the only thing we might care about is
> +	 * srcu acces.... */
> +	mutex_unlock(&fsnotify_grp_mutex);
> +	synchronize_srcu(&fsnotify_grp_srcu);
> +
> +	/* and now it is really dead. _Nothing_ could be seeing it */
> +	fsnotify_recalc_global_mask();
> +	fsnotify_destroy_group(group);
> +}
> +
> +static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u32 mask,
> +						  const struct fsnotify_ops *ops)
> +{
> +	struct fsnotify_group *group_iter;
> +	struct fsnotify_group *group = NULL;
> +
> +	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
> +
> +	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {

Given that you hold fsnotify_grp_mutex, you in theory don't need the
_rcu form, but not a problem.  Just wanted you to know that I was paying
attention.  ;-)

> +		if (group_iter->group_num == group_num) {
> +			if ((group_iter->mask == mask) &&
> +			    (group_iter->ops == ops)) {
> +				fsnotify_get_group(group_iter);
> +				group = group_iter;
> +			} else
> +				group = ERR_PTR(-EEXIST);
> +		}
> +	}
> +	return group;
> +}
> +
> +/*
> + * Either finds an existing group which matches the group_num, mask, and ops or
> + * creates a new group and adds it to the global group list.  In either case we
> + * take a reference for the group returned.
> + *
> + * low use function, could be faster to check if the group is there before we do
> + * the allocation and the initialization, but this is only called when notification
> + * systems make changes, so why make it more complex?
> + */
> +struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask,
> +					     const struct fsnotify_ops *ops)
> +{
> +	struct fsnotify_group *group, *tgroup;
> +
> +	group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
> +	if (!group)
> +		return ERR_PTR(-ENOMEM);
> +
> +	atomic_set(&group->refcnt, 1);
> +
> +	group->group_num = group_num;
> +	group->mask = mask;
> +
> +	group->ops = ops;
> +
> +	mutex_lock(&fsnotify_grp_mutex);
> +	tgroup = fsnotify_find_group(group_num, mask, ops);
> +	if (tgroup) {
> +		/* group already exists */
> +		mutex_unlock(&fsnotify_grp_mutex);
> +		/* destroy the new one we made */
> +		fsnotify_put_group(group);
> +		return tgroup;
> +	}
> +
> +	/* group not found, add a new one */
> +	fsnotify_add_group(group);
> +	mutex_unlock(&fsnotify_grp_mutex);
> +
> +	if (mask)
> +		fsnotify_recalc_global_mask();
> +
> +	return group;
> +}
> diff --git a/fs/notify/notification.c b/fs/notify/notification.c
> new file mode 100644
> index 0000000..eb23a69
> --- /dev/null
> +++ b/fs/notify/notification.c
> @@ -0,0 +1,116 @@
> +/*
> + *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2, or (at your option)
> + *  any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/mount.h>
> +#include <linux/mutex.h>
> +#include <linux/namei.h>
> +#include <linux/path.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/atomic.h>
> +
> +#include <linux/fsnotify_backend.h>
> +#include "fsnotify.h"
> +
> +static struct kmem_cache *event_kmem_cache;
> +
> +void fsnotify_get_event(struct fsnotify_event *event)
> +{
> +	atomic_inc(&event->refcnt);
> +}
> +
> +void fsnotify_put_event(struct fsnotify_event *event)
> +{
> +	if (!event)
> +		return;
> +
> +	if (atomic_dec_and_test(&event->refcnt)) {
> +		if (event->data_type == FSNOTIFY_EVENT_PATH) {
> +			path_put(&event->path);
> +			event->path.dentry = NULL;
> +			event->path.mnt = NULL;
> +		}
> +
> +		event->mask = 0;
> +
> +		kmem_cache_free(event_kmem_cache, event);
> +	}
> +}
> +
> +struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type)
> +{
> +	struct fsnotify_event *event;
> +
> +	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
> +	if (!event)
> +		return NULL;
> +
> +	atomic_set(&event->refcnt, 1);
> +
> +	spin_lock_init(&event->lock);
> +
> +	event->path.dentry = NULL;
> +	event->path.mnt = NULL;
> +	event->inode = NULL;
> +
> +	event->to_tell = to_tell;
> +
> +	switch (data_type) {
> +	case FSNOTIFY_EVENT_FILE: {
> +		struct file *file = data;
> +		struct path *path = &file->f_path;
> +		event->path.dentry = path->dentry;
> +		event->path.mnt = path->mnt;
> +		path_get(&event->path);
> +		event->data_type = FSNOTIFY_EVENT_PATH;
> +		break;
> +	}
> +	case FSNOTIFY_EVENT_PATH: {
> +		struct path *path = data;
> +		event->path.dentry = path->dentry;
> +		event->path.mnt = path->mnt;
> +		path_get(&event->path);
> +		event->data_type = FSNOTIFY_EVENT_PATH;
> +		break;
> +	}
> +	case FSNOTIFY_EVENT_INODE:
> +		event->inode = data;
> +		event->data_type = FSNOTIFY_EVENT_INODE;
> +		break;
> +	default:
> +		BUG();
> +	};
> +
> +	event->mask = mask;
> +
> +	return event;
> +}
> +
> +__init int fsnotify_notification_init(void)
> +{
> +	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);
> +
> +	return 0;
> +}
> +subsys_initcall(fsnotify_notification_init);
> +
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index 00fbd5b..3d68058 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -13,6 +13,7 @@
> 
>  #include <linux/dnotify.h>
>  #include <linux/inotify.h>
> +#include <linux/fsnotify_backend.h>
>  #include <linux/audit.h>
> 
>  /*
> @@ -35,6 +36,17 @@ static inline void fsnotify_d_move(struct dentry *entry)
>  }
> 
>  /*
> + * fsnotify_inoderemove - an inode is going away
> + */
> +static inline void fsnotify_inoderemove(struct inode *inode)
> +{
> +	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
> +	inotify_inode_is_dead(inode);
> +
> +	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
> +}
> +
> +/*
>   * fsnotify_move - file old_name at old_dir was moved to new_name at new_dir
>   */
>  static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
> @@ -43,28 +55,42 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
>  {
>  	struct inode *source = moved->d_inode;
>  	u32 cookie = inotify_get_cookie();
> +	__u32 old_dir_mask = 0;
> +	__u32 new_dir_mask = 0;
> 
> -	if (old_dir == new_dir)
> +	if (old_dir == new_dir) {
>  		inode_dir_notify(old_dir, DN_RENAME);
> -	else {
> +		old_dir_mask = FS_DN_RENAME;
> +	} else {
>  		inode_dir_notify(old_dir, DN_DELETE);
> +		old_dir_mask = FS_DELETE;
>  		inode_dir_notify(new_dir, DN_CREATE);
> +		new_dir_mask = FS_CREATE;
>  	}
> 
> -	if (isdir)
> +	if (isdir) {
>  		isdir = IN_ISDIR;
> +		old_dir_mask |= FS_IN_ISDIR;
> +		new_dir_mask |= FS_IN_ISDIR;
> +	}
> +
> +	old_dir_mask |= FS_MOVED_FROM;
> +	new_dir_mask |= FS_MOVED_TO;
> +
>  	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
>  				  source);
>  	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
>  				  source);
> 
> -	if (target) {
> -		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
> -		inotify_inode_is_dead(target);
> -	}
> +	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
> +	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
> +
> +	if (target)
> +		fsnotify_inoderemove(target);
> 
>  	if (source) {
>  		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
> +		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
>  	}
>  	audit_inode_child(new_name, moved, new_dir);
>  }
> @@ -75,26 +101,19 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
>  static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
>  {
>  	if (isdir)
> -		isdir = IN_ISDIR;
> +		isdir = FS_IN_ISDIR;
>  	dnotify_parent(dentry, DN_DELETE);
>  	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
>  }
> 
>  /*
> - * fsnotify_inoderemove - an inode is going away
> - */
> -static inline void fsnotify_inoderemove(struct inode *inode)
> -{
> -	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
> -	inotify_inode_is_dead(inode);
> -}
> -
> -/*
>   * fsnotify_link_count - inode's link count changed
>   */
>  static inline void fsnotify_link_count(struct inode *inode)
>  {
>  	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
> +
> +	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -106,6 +125,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
>  	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
>  				  dentry->d_inode);
>  	audit_inode_child(dentry->d_name.name, dentry, inode);
> +
> +	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -120,6 +141,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
>  				  inode);
>  	fsnotify_link_count(inode);
>  	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
> +
> +	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -131,6 +154,8 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
>  	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
>  				  dentry->d_name.name, dentry->d_inode);
>  	audit_inode_child(dentry->d_name.name, dentry, inode);
> +
> +	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -139,14 +164,16 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
>  static inline void fsnotify_access(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	u32 mask = IN_ACCESS;
> +	__u32 mask = FS_ACCESS;
> 
>  	if (S_ISDIR(inode->i_mode))
> -		mask |= IN_ISDIR;
> +		mask |= FS_IN_ISDIR;
> 
>  	dnotify_parent(dentry, DN_ACCESS);
>  	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
>  	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +
> +	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -155,14 +182,16 @@ static inline void fsnotify_access(struct dentry *dentry)
>  static inline void fsnotify_modify(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	u32 mask = IN_MODIFY;
> +	__u32 mask = FS_MODIFY;
> 
>  	if (S_ISDIR(inode->i_mode))
> -		mask |= IN_ISDIR;
> +		mask |= FS_IN_ISDIR;
> 
>  	dnotify_parent(dentry, DN_MODIFY);
>  	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
>  	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +
> +	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -171,13 +200,15 @@ static inline void fsnotify_modify(struct dentry *dentry)
>  static inline void fsnotify_open(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	u32 mask = IN_OPEN;
> +	__u32 mask = FS_OPEN;
> 
>  	if (S_ISDIR(inode->i_mode))
> -		mask |= IN_ISDIR;
> +		mask |= FS_IN_ISDIR;
> 
>  	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
>  	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +
> +	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -189,13 +220,15 @@ static inline void fsnotify_close(struct file *file)
>  	struct inode *inode = dentry->d_inode;
>  	const char *name = dentry->d_name.name;
>  	fmode_t mode = file->f_mode;
> -	u32 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
> +	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
> 
>  	if (S_ISDIR(inode->i_mode))
> -		mask |= IN_ISDIR;
> +		mask |= FS_IN_ISDIR;
> 
>  	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
>  	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +
> +	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
>  }
> 
>  /*
> @@ -204,13 +237,15 @@ static inline void fsnotify_close(struct file *file)
>  static inline void fsnotify_xattr(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	u32 mask = IN_ATTRIB;
> +	__u32 mask = FS_ATTRIB;
> 
>  	if (S_ISDIR(inode->i_mode))
> -		mask |= IN_ISDIR;
> +		mask |= FS_IN_ISDIR;
> 
>  	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
>  	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
> +
> +	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
>  }
> 
>  /*
> @@ -224,31 +259,31 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
>  	u32 in_mask = 0;
> 
>  	if (ia_valid & ATTR_UID) {
> -		in_mask |= IN_ATTRIB;
> +		in_mask |= FS_ATTRIB;
>  		dn_mask |= DN_ATTRIB;
>  	}
>  	if (ia_valid & ATTR_GID) {
> -		in_mask |= IN_ATTRIB;
> +		in_mask |= FS_ATTRIB;
>  		dn_mask |= DN_ATTRIB;
>  	}
>  	if (ia_valid & ATTR_SIZE) {
> -		in_mask |= IN_MODIFY;
> +		in_mask |= FS_MODIFY;
>  		dn_mask |= DN_MODIFY;
>  	}
>  	/* both times implies a utime(s) call */
>  	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
>  	{
> -		in_mask |= IN_ATTRIB;
> +		in_mask |= FS_ATTRIB;
>  		dn_mask |= DN_ATTRIB;
>  	} else if (ia_valid & ATTR_ATIME) {
> -		in_mask |= IN_ACCESS;
> +		in_mask |= FS_ACCESS;
>  		dn_mask |= DN_ACCESS;
>  	} else if (ia_valid & ATTR_MTIME) {
> -		in_mask |= IN_MODIFY;
> +		in_mask |= FS_MODIFY;
>  		dn_mask |= DN_MODIFY;
>  	}
>  	if (ia_valid & ATTR_MODE) {
> -		in_mask |= IN_ATTRIB;
> +		in_mask |= FS_ATTRIB;
>  		dn_mask |= DN_ATTRIB;
>  	}
> 
> @@ -256,20 +291,40 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
>  		dnotify_parent(dentry, dn_mask);
>  	if (in_mask) {
>  		if (S_ISDIR(inode->i_mode))
> -			in_mask |= IN_ISDIR;
> +			in_mask |= FS_IN_ISDIR;
>  		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
>  		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
>  						  dentry->d_name.name);
> +		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
>  	}
>  }
> 
> -#ifdef CONFIG_INOTIFY	/* inotify helpers */
> +#if defined(CONFIG_INOTIFY) || defined(CONFIG_FSNOTIFY)	/* notify helpers */
> 
>  /*
>   * fsnotify_oldname_init - save off the old filename before we change it
>   */
>  static inline const char *fsnotify_oldname_init(const char *name)
>  {
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
> +
>  	return kstrdup(name, GFP_KERNEL);
>  }
> 
> @@ -281,7 +336,7 @@ static inline void fsnotify_oldname_free(const char *old_name)
>  	kfree(old_name);
>  }
> 
> -#else	/* CONFIG_INOTIFY */
> +#else	/* CONFIG_INOTIFY || CONFIG_FSNOTIFY */
> 
>  static inline const char *fsnotify_oldname_init(const char *name)
>  {
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> new file mode 100644
> index 0000000..0523333
> --- /dev/null
> +++ b/include/linux/fsnotify_backend.h
> @@ -0,0 +1,135 @@
> +/*
> + * Filesystem access notification for Linux
> + *
> + *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
> + */
> +
> +#ifndef _LINUX_FSNOTIFY_BACKEND_H
> +#define _LINUX_FSNOTIFY_BACKEND_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/fs.h> /* struct inode */
> +#include <linux/list.h>
> +#include <linux/path.h> /* struct path */
> +#include <linux/spinlock.h>
> +#include <linux/wait.h>
> +
> +#include <asm/atomic.h>
> +
> +/*
> + * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
> + * convert between them.  dnotify only needs conversion at watch creation
> + * so no perf loss there.  fanotify isn't defined yet, so it can use the
> + * wholes if it needs more events.
> + */
> +#define FS_ACCESS		0x00000001ul	/* File was accessed */
> +#define FS_MODIFY		0x00000002ul	/* File was modified */
> +#define FS_ATTRIB		0x00000004ul	/* Metadata changed */
> +#define FS_CLOSE_WRITE		0x00000008ul	/* Writtable file was closed */
> +#define FS_CLOSE_NOWRITE	0x00000010ul	/* Unwrittable file closed */
> +#define FS_OPEN			0x00000020ul	/* File was opened */
> +#define FS_MOVED_FROM		0x00000040ul	/* File was moved from X */
> +#define FS_MOVED_TO		0x00000080ul	/* File was moved to Y */
> +#define FS_CREATE		0x00000100ul	/* Subfile was created */
> +#define FS_DELETE		0x00000200ul	/* Subfile was deleted */
> +#define FS_DELETE_SELF		0x00000400ul	/* Self was deleted */
> +#define FS_MOVE_SELF		0x00000800ul	/* Self was moved */
> +
> +#define FS_UNMOUNT		0x00002000ul	/* inode on umount fs */
> +#define FS_Q_OVERFLOW		0x00004000ul	/* Event queued overflowed */
> +#define FS_IN_IGNORED		0x00008000ul	/* last inotify event here */
> +
> +#define FS_IN_ISDIR		0x40000000ul	/* event occurred against dir */
> +#define FS_IN_ONESHOT		0x80000000ul	/* only send event once */
> +
> +#define FS_DN_RENAME		0x10000000ul	/* file renamed */
> +#define FS_DN_MULTISHOT		0x20000000ul	/* dnotify multishot */
> +
> +#define FS_EVENT_ON_CHILD	0x08000000ul
> +
> +struct fsnotify_group;
> +struct fsnotify_event;
> +
> +/*
> + * Each group much define these ops.
> + *
> + * handle_event - main call for a group to handle an fs event
> + * free_group_priv - called when a group refcnt hits 0 to clean up the private union
> + */
> +struct fsnotify_ops {
> +	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
> +	void (*free_group_priv)(struct fsnotify_group *group);
> +};
> +
> +/*
> + * A group is a "thing" that wants to receive notification about filesystem
> + * events.  The mask holds the subset of event types this group cares about.
> + * refcnt on a group is up to the implementor and at any moment if it goes 0
> + * everything will be cleaned up.
> + */
> +struct fsnotify_group {
> +	struct list_head group_list;	/* list of all groups on the system */
> +	__u32 mask;			/* mask of events this group cares about */
> +	atomic_t refcnt;		/* num of processes with a special file open */
> +	unsigned int group_num;		/* the 'name' of the event */
> +
> +	const struct fsnotify_ops *ops;	/* how this group handles things */
> +
> +	unsigned int evicted:1;		/* has this group been evicted? */
> +
> +	/* groups can define private fields here */
> +	union {
> +	};
> +};
> +
> +/*
> + * all of the information about the original object we want to now send to
> + * a group.  If you want to carry more info from the accessing task to the
> + * listener this structure is where you need to be adding fields.
> + */
> +struct fsnotify_event {
> +	spinlock_t lock;	/* protection for the associated event_holder and private_list */
> +	struct inode *to_tell;
> +	/*
> +	 * depending on the event type we should have either a path or inode
> +	 * we should never have more than one....
> +	 */
> +	union {
> +		struct path path;
> +		struct inode *inode;
> +	};
> +/* when calling fsnotify tell it if the data is a path or inode */
> +#define FSNOTIFY_EVENT_PATH	1
> +#define FSNOTIFY_EVENT_INODE	2
> +#define FSNOTIFY_EVENT_FILE	3
> +	int data_type;		/* which of the above union we have */
> +	atomic_t refcnt;	/* how many groups still are using/need to send this event */
> +	__u32 mask;		/* the type of access */
> +};
> +
> +#ifdef CONFIG_FSNOTIFY
> +
> +/* called from the vfs to signal fs events */
> +extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
> +
> +/* called from fsnotify interfaces, such as fanotify or dnotify */
> +extern void fsnotify_recalc_global_mask(void);
> +extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask, const struct fsnotify_ops *ops);
> +extern void fsnotify_put_group(struct fsnotify_group *group);
> +
> +extern void fsnotify_get_event(struct fsnotify_event *event);
> +extern void fsnotify_put_event(struct fsnotify_event *event);
> +extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
> +
> +/* put here because inotify does some weird stuff when destroying watches */
> +extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_is);
> +#else
> +
> +static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
> +{}
> +#endif	/* CONFIG_FSNOTIFY */
> +
> +#endif	/* __KERNEL __ */
> +
> +#endif	/* _LINUX_FSNOTIFY_BACKEND_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
