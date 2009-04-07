Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbZDGXOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbZDGXOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZDGXMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401AbZDGXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:43 -0400
Date: Tue, 7 Apr 2009 16:06:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 02/13] fsnotify: unified filesystem notification
 backend
Message-Id: <20090407160606.33e58c35.akpm@linux-foundation.org>
In-Reply-To: <20090327200515.32007.53032.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200515.32007.53032.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:15 -0400
Eric Paris <eparis@redhat.com> wrote:

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
> 
>
> ...
>
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

I hinted to paulmck that he might like to review this ;)

> +	 * very hot.  The VAST majority of events are not going to need to do
> +	 * anything other than walk the list so it's crazy to pre-allocate.
> +	 */
> +	idx = srcu_read_lock(&fsnotify_grp_srcu);
> +	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
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
>
> ...
>
> --- /dev/null
> +++ b/fs/notify/fsnotify.h
> @@ -0,0 +1,17 @@
> +#ifndef _LINUX_FSNOTIFY_PRIVATE_H
> +#define _LINUX_FSNOTIFY_PRIVATE_H

The #define doesn't match the filename?

> +#include <linux/dcache.h>
> +#include <linux/list.h>
> +#include <linux/fs.h>
> +#include <linux/path.h>
> +#include <linux/spinlock.h>
> +
>
> ...
>
> +
> +DEFINE_MUTEX(fsnotify_grp_mutex);

This has global scope, but isn't declared in fsnotify.h

> +struct srcu_struct fsnotify_grp_srcu;
> +LIST_HEAD(fsnotify_groups);
> +__u32 fsnotify_mask;

It's nice to provide comments explaining the role of key globals such
as these.  fsnotify_mask is particularly unobvious.

> +void fsnotify_recalc_global_mask(void)
> +{
> +	struct fsnotify_group *group;
> +	__u32 mask = 0;
> +	int idx;
> +
> +	idx = srcu_read_lock(&fsnotify_grp_srcu);
> +	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
> +		mask |= group->mask;
> +	}

unneeded braces.

> +	srcu_read_unlock(&fsnotify_grp_srcu, idx);
> +	fsnotify_mask = mask;
> +}

What does this function do?

It's hard to review code when things such as this are left unexplained.

> +static void fsnotify_add_group(struct fsnotify_group *group)
> +{
> +	list_add_rcu(&group->group_list, &fsnotify_groups);
> +	group->evicted = 0;
> +}

Locking?  Seems to requrie that callers hold fsnotify_grp_mutex?

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
> +	group->evicted = 1;
> +}

Why is this called "evict"?  In Linux, the term "eviction" implies some
sort of involuntary asynchronous reclaimation.  But afaict (and lacking
explanatory documentation) this function seems to be a plain old
freeing function.  So why is it not called fsnotify_free_group()?

This is all a bit unaproachable.

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

The usual commenting style is

	/*
	 * OK, now we know that there's no other users *and* we hold mutex,
	 * so no new references will appear
	 */

> +	__fsnotify_evict_group(group);
> +
> +	/* now it's off the list, so the only thing we might care about is
> +	 * srcu acces.... */

"access"

> +	mutex_unlock(&fsnotify_grp_mutex);
> +	synchronize_srcu(&fsnotify_grp_srcu);
> +
> +	/* and now it is really dead. _Nothing_ could be seeing it */
> +	fsnotify_recalc_global_mask();
> +	fsnotify_destroy_group(group);
> +}
> +
>
> ...
>
> +/*
> + * Either finds an existing group which matches the group_num, mask, and ops or
> + * creates a new group and adds it to the global group list.  In either case we
> + * take a reference for the group returned.
> + *
> + * low use function, could be faster to check if the group is there before we do
> + * the allocation and the initialization, but this is only called when notification
> + * systems make changes, so why make it more complex?

Yup.  But that would seem to be a pretty simple change to make?

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

This is the only fsnotify_add_group() callsite and it's just two lines. 
Open-code it here?

> +	mutex_unlock(&fsnotify_grp_mutex);
> +
> +	if (mask)
> +		fsnotify_recalc_global_mask();

I'd understand this if I knew what fsnotify_mask does :(

> +	return group;
> +}
>
> ...
>
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

Why are these fields zeroed here?  If it's for debugging then slab
poisoning should suffice?

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

unneeded semicolon

> +	event->mask = mask;
> +
> +	return event;
> +}
> +
> +__init int fsnotify_notification_init(void)
> +{
> +	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);

Can use the cheesy KMEM_CACHE() macro?

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

inode_remove?

> +{
> +	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
> +	inotify_inode_is_dead(inode);
> +
> +	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
> +}
> +
>
> ...
>
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

All the "ul"s seem redundant?

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

"free_group_private"

> +};
> +
> +/*
> + * A group is a "thing" that wants to receive notification about filesystem
> + * events.  The mask holds the subset of event types this group cares about.

It's unclear what the "event types" are.  FS_* from above?

Perhaps things would be clearer if they were named FS_EVENT_*, or FSE_*?

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

If someone adds another bitfield here then they will share the same
word and will hence need locking.  It'd be less risky to just make this
a plain old `unsigned'.  Or `bool'.

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

Does the existence of a `struct fsnotify_event' cause a reference to be
taken on fsnotify_event.to_tell?

If so, that's useful information to add here.

Either way, a few words about the design of the lifetime management
would be helpful.

>
> ...
>

