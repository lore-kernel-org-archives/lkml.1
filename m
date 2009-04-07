Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZDGXQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZDGXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZDGXMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756791AbZDGXMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:48 -0400
Date: Tue, 7 Apr 2009 16:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 04/13] fsnotify: add in inode fsnotify markings
Message-Id: <20090407160615.0815aadd.akpm@linux-foundation.org>
In-Reply-To: <20090327200526.32007.29489.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200526.32007.29489.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:26 -0400
Eric Paris <eparis@redhat.com> wrote:

> This patch creates in inode fsnotify markings.  dnotify will make use of in
> inode markings to mark which inodes it wishes to send events for.

The text appears to be using the term "in inode" as a term-of-art.  But
it's a new one to me.

>  fanotify
> will use this to mark which inodes it does not wish to send events for.
> 

<but i dont know what fanotify is>

> ---
> 
>  Documentation/filesystems/fsnotify.txt |  180 +++++++++++++++++++++++++
>  fs/inode.c                             |    9 +
>  fs/notify/Makefile                     |    2 
>  fs/notify/fsnotify.c                   |   10 +
>  fs/notify/fsnotify.h                   |    3 
>  fs/notify/group.c                      |   33 ++++-
>  fs/notify/inode_mark.c                 |  229 ++++++++++++++++++++++++++++++++
>  include/linux/fs.h                     |    5 +
>  include/linux/fsnotify.h               |    9 +
>  include/linux/fsnotify_backend.h       |   58 ++++++++
>  10 files changed, 535 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/fsnotify.txt
>  create mode 100644 fs/notify/inode_mark.c
> 
> diff --git a/Documentation/filesystems/fsnotify.txt b/Documentation/filesystems/fsnotify.txt
> new file mode 100644
> index 0000000..e1c90f5
> --- /dev/null
> +++ b/Documentation/filesystems/fsnotify.txt
> @@ -0,0 +1,180 @@
> +fsnotify inode mark locking/lifetime/and refcnting
> +
> +struct fsnotify_mark_entry {
> +        __u32 mask;                     /* mask this mark entry is for */
> +        /* we hold ref for each i_list and g_list.  also one ref for each 'thing'
> +         * in kernel that found and may be using this mark. */
> +        atomic_t refcnt;                /* active things looking at this mark */
> +        struct inode *inode;            /* inode this entry is associated with */
> +        struct fsnotify_group *group;   /* group this mark entry is for */
> +        struct hlist_node i_list;       /* list of mark_entries by inode->i_fsnotify_mark_entries */
> +        struct list_head g_list;        /* list of mark_entries by group->i_fsnotify_mark_entries */
> +        spinlock_t lock;                /* protect group, inode, and killme */
> +        struct list_head free_i_list;   /* tmp list used when freeing this mark */
> +        struct list_head free_g_list;   /* tmp list used when freeing this mark */
> +        void (*free_mark)(struct fsnotify_mark_entry *entry); /* called on final put+free */
> +};
> +
> +REFCNT:
> +The mark->refcnt tells how many "things" in the kernel currectly are

"currently"

>
> ...
>
> +The inode mark can be cleared for a number of different reasons including:
> +- The inode is unlinked for the last time.  (fsnotify_inoderemove)
> +- The inode is being evicted from cache. (fsnotify_inode_delete)
> +- The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)

So it did want to be called fsnotify_inode_remove.

> +- Something explicitly requests that it be removed.  (fsnotify_destroy_mark_by_entry)
> +- The fsnotify_group associated with the mark is going away and all such marks
> +  need to be cleaned up. (fsnotify_clear_marks_by_group)
> +
> +Worst case we are given an inode and need to clean up all the marks on that
> +inode.  We take i_lock and walk the i_fsnotify_mark_entries safely.  For each
> +mark on the list we take a reference (so the mark can't disappear under us).
> +We remove that mark form the inode's list of marks and we add this mark to a
> +private list anchored on the stack using i_free_list;  At this point we no
> +longer fear anything finding the mark using the inode's list of marks.

damn, I wish this was all written in the C files instead.

>
> ...
>
> +void fsnotify_recalc_group_mask(struct fsnotify_group *group)
> +{
> +	__u32 mask = 0;
> +	__u32 old_mask = group->mask;
> +	struct fsnotify_mark_entry *entry;
> +
> +	spin_lock(&group->mark_lock);
> +	list_for_each_entry(entry, &group->mark_entries, g_list) {
> +		mask |= entry->mask;
> +	}

unneeded {}  (numerous places)

> +	spin_unlock(&group->mark_lock);
> +
> +	group->mask = mask;
> +
> +	if (old_mask != mask)
> +		fsnotify_recalc_global_mask();
> +}
> +
>  static void fsnotify_add_group(struct fsnotify_group *group)
>  {
>  	int priority = group->priority;
> @@ -71,13 +89,22 @@ static void fsnotify_get_group(struct fsnotify_group *group)
>  	atomic_inc(&group->refcnt);
>  }
>  
> -static void fsnotify_destroy_group(struct fsnotify_group *group)
> +void fsnotify_final_destroy_group(struct fsnotify_group *group)
>  {
>  	if (group->ops->free_group_priv)
>  		group->ops->free_group_priv(group);
>  
>  	kfree(group);
>  }

missing newline

> +static void fsnotify_destroy_group(struct fsnotify_group *group)
> +{
> +	/* clear all inode mark entries for this group */
> +	fsnotify_clear_marks_by_group(group);
> +
> +	/* past the point of no return, matches the initial value of 1 */
> +	if (atomic_dec_and_test(&group->num_marks))
> +		fsnotify_final_destroy_group(group);
> +}
>  
>
> ...
>
> +void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
> +{
> +	struct fsnotify_group *group;
> +	struct inode *inode;
> +
> +	spin_lock(&entry->lock);
> +
> +	group = entry->group;
> +	inode = entry->inode;
> +
> +	BUG_ON(group && !inode);
> +	BUG_ON(!group && inode);
> +
> +	/* if !group something else already marked this to die */
> +	if (!group) {
> +		spin_unlock(&entry->lock);
> +		return;
> +	}
> +
> +	/* this just tests that the caller held a reference */
> +	if (unlikely(atomic_read(&entry->refcnt) < 3))
> +		BUG();

BUG_ON()

> +	spin_lock(&group->mark_lock);
> +	spin_lock(&inode->i_lock);
> +
> +	hlist_del_init(&entry->i_list);
> +	entry->inode = NULL;
> +	fsnotify_put_mark(entry); /* for i_list */
> +
> +	list_del_init(&entry->g_list);
> +	entry->group = NULL;
> +	fsnotify_put_mark(entry); /* for g_list */
> +
> +	fsnotify_recalc_inode_mask_locked(inode);
> +
> +	spin_unlock(&inode->i_lock);
> +	spin_unlock(&group->mark_lock);
> +	spin_unlock(&entry->lock);
> +
> +	group->ops->freeing_mark(entry, group);
> +
> +	if (atomic_dec_and_test(&group->num_marks))
> +		fsnotify_final_destroy_group(group);
> +}
> +
>
> ...
>
> +void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(struct fsnotify_mark_entry *entry))

you must have a wide monitor.

> +
> +{
> +	spin_lock_init(&entry->lock);
> +	atomic_set(&entry->refcnt, 1);
> +	INIT_HLIST_NODE(&entry->i_list);
> +	entry->group = NULL;
> +	entry->mask = 0;
> +	entry->inode = NULL;
> +	entry->free_mark = free_mark;
> +}
> +
>
> ...
>

