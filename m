Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbYLMQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbYLMQfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYLMQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:35:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbYLMQff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:35:35 -0500
Subject: Re: [RFC PATCH -v4 07/14] fsnotify: add in inode fsnotify markings
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081213030701.GD807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215151.27112.71399.stgit@paris.rdu.redhat.com>
	 <20081213030701.GD807@ioremap.net>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 11:35:09 -0500
Message-Id: <1229186110.29167.100.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 06:07 +0300, Evgeniy Polyakov wrote:
> On Fri, Dec 12, 2008 at 04:51:51PM -0500, Eric Paris (eparis@redhat.com) wrote:
> > +void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
> > +{
> > +	if (atomic_dec_and_test(&entry->refcnt)) {
> > +		spin_lock(&entry->lock);
> > +		/* entries can only be found by the kernel by searching the
> > +		 * inode->i_fsnotify_entries or the group->mark_entries lists.
> > +		 * if freeme is set that means this entry is off both lists.
> > +		 * if refcnt is 0 that means we are the last thing still
> > +		 * looking at this entry, so its time to free.
> > +		 */
> > +		if (!atomic_read(&entry->refcnt) && entry->freeme) {
> 
> Why do you check refcnt again? Does it mean its life cycle does not end
> when it hits zero and should be freed only under lock, which in turn
> means it may be accessed under that lock and zero refcnt? Please
> describe this locking in more details.

Al Viro, please pay attention to this patch.  This is the one that
provides lifetimes which I hope solves all of inotify's "fun"

marks have very interesting semantics which took me a long time to
figure out.  Marks can only be found in kernel by walking one of two
lists.  group->mark_entries or inode->i_fsnotify_mark_entries.  These
lists are protected by group->mark_lock or inode->i_lost respectively.
Everything else inside of a mark is protected by entry->lock.  The
locking order is

entry->lock
  group->mark_lock
    inode->i_lock

Entries must not be freed until they are gone from both the group->list
and the inode->list and no other process is referencing this entry.  The
refcnt keeps track of how many processes are looking at this entry.  The
freeme is set when the entry is removed from both lists.  Thus if the
refcnt==0 and freeme=1 that means nothing is looking at this entry and
it is off both lists so we free it.

The difficulty lies in the fact that we might need to free marks for 3
reasons from 3 different directions.

1) inode disappears (inode deleted or evicted form core, backing FS
unmounted)
2) group disappears (close the inotify fd)
3) entry needs to go (inotify unregisters it)

Number 3 is by far the easiest.  We grab entry->lock.  If entry->group
is set grab it's lock.  If entry->inode is set we grab that lock.  We
can then drop this entry from both lists set group and inode to NULL and
set freeme.  Once everything is finished looking at the entry it will
get freed.

Numbers 2 and 3 are much harder lets look at #1 since #2 is similar.
There are 3 reasons I can think of that we would need to kill all
entries given an inode.  the inode is evicted from core (this isn't
actually an issue with dnotify or inotify since dnotify holds a
reference by the sheer fact an associated file for the inode must be
held open, and the existence of a "watch" or "entry" for inotify keep it
from being evicted due to memory pressure.  It could be evicted because
the last dentry pointing to the inode was deleted.  The fs backing that
inode is being unmounted.  In any case, we are given an inode and we are
told "all entries associated with this inode need to be freed."

So to find an entry we need to first grab the inode->i_lock and start to
walk the inode->i_fsnotify_mark_entries list.  Since we hold the i_lock
we are not allowed to grab any other locks nor are we allowed to change
anything other than entry->i_list.  The secret sauce is that we actually
move the entry from the inode list to a private list which we can walk
and modify lockless.  Inside the event we actually have to use a
different list, free_i_list, for this operation so nothing else that
races with us can mess stuff up.  We run the entire inode we are trying
to free all entries for an put the entries on the private list.  We do
NOT modify event->inode.

After this point we can drop inode->i_lock since we are finished with
inode->i_fsnotify_mark_entries and that list is empty.  Now we can walk
the private list we just created lockless.  We can thus try to grab in
order, all three locks (we don't really need i_lock since we are already
off the inode's list) and can safely remove this entry from both lists,
set both entry->inode and entry->group to NULL (we hold the event->lock
so this is safe) and since we are off both lists set freeme.

As soon as we dropped i_lock remember we could have raced.  The cool
thing here is that this is fine.  The "thing" we are racing with is
going to be holding entry->lock.  So we are going to block until that
gets released.  That other task is going to grab entry->inode->i_lock
which is also fine.  As long as we exist the inode still exists and so
the lock is ok.  Since we always use list_del_init(entry->i_list) when
that other task tries to remove this entry from the inode list it won't
really be doing anything, nor hurting anything.  This is the reason that
we needed the free_i_list.  So a racing task can't mess with the lists
that we need.  Only a process shooting an entry by inode will use this
list.  That other task is also going to take care of setting
entry->inode == NULL.

Eventually we are going to get the entry->lock, will do our best to lock
what else we can (we actually shouldn't find entry->inode or
entry->group if we lost the race), and we will remove the entry from
what lists we can (again it's already off both lists).  At the end we
know that this entry is off both lists and can be marked to be freed.

It's actually quite slick, we can try to free an entry from all 3
directions at once but the entry won't actually be freed until it is off
both lists and nothing is left actively referencing it.


> 
> > +			spin_unlock(&entry->lock);
> > +			fsnotify_destroy_mark(entry);
> > +			return;
> > +		}
> > +		spin_unlock(&entry->lock);
> > +	}
> > +}
> > +
> > +void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
> > +{
> > +	struct fsnotify_mark_entry *lentry, *entry;
> > +	struct inode *inode;
> > +	LIST_HEAD(free_list);
> > +
> > +	spin_lock(&group->mark_lock);
> > +	list_for_each_entry_safe(entry, lentry, &group->mark_entries, g_list) {
> > +		list_del_init(&entry->g_list);
> > +		list_add(&entry->free_g_list, &free_list);
> > +	}
> > +	spin_unlock(&group->mark_lock);
> > +
> > +	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
> > +		fsnotify_get_mark(entry);
> > +		spin_lock(&entry->lock);
> > +		inode = entry->inode;
> > +		if (!inode) {
> 
> This inode does not seem to be grabbed previously, or I missed that
> part? What prevents it from being freed?

Here's the cool part.  If the inode was free, we would have removed this
entry from the inode->i_fsnotify_mark_entries list and set entry->inode
to NULL back when that happened.

> 
> > +			entry->group = NULL;
> > +			spin_unlock(&entry->lock);
> > +			fsnotify_put_mark(entry);
> > +			continue;
> > +		}
> > +		spin_lock(&inode->i_lock);
> > +
> > +		list_del_init(&entry->i_list);
> > +		entry->inode = NULL;
> > +		list_del_init(&entry->g_list);
> > +		entry->group = NULL;
> > +		entry->freeme = 1;
> > +
> > +		spin_unlock(&inode->i_lock);
> > +		spin_unlock(&entry->lock);
> > +
> > +		fsnotify_put_mark(entry);
> > +	}
> > +}
> 
> > +void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags)
> > +{
> > +	struct fsnotify_mark_entry *lentry, *entry;
> > +	LIST_HEAD(free_list);
> > +
> > +	spin_lock(&inode->i_lock);
> > +	list_for_each_entry_safe(entry, lentry, &inode->i_fsnotify_mark_entries, i_list) {
> > +		list_del_init(&entry->i_list);
> > +		list_add(&entry->free_i_list, &free_list);
> > +	}
> > +	spin_unlock(&inode->i_lock);
> > +
> > +	/*
> > +	 * at this point destroy_by_* might race.
> > +	 *
> > +	 * we used list_del_init() so it can be list_del_init'd again, no harm.
> > +	 * we were called from an inode function so we know that other user can
> > +	 * try to grab entry->inode->i_lock without a problem.
> > +	 */
> > +	list_for_each_entry_safe(entry, lentry, &free_list, free_i_list) {
> > +		fsnotify_get_mark(entry);
> > +		entry->group->ops->mark_clear_inode(entry, inode, flags);
> > +		fsnotify_put_mark(entry);
> > +	}
> 
> Since entry was not grabbed in the above locked list, what prevents it
> to be freed before fsnotify_get_mark() executed? Could that get moved
> under lock?

absolutely nothing.  This is a bug.  thanks.

> > +}
> > +
> > +/* caller must hold inode->i_lock */
> > +struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode)
> > +{
> > +	struct fsnotify_mark_entry *entry;
> > +
> > +	list_for_each_entry(entry, &inode->i_fsnotify_mark_entries, i_list) {
> > +		if (entry->group == group) {
> > +			fsnotify_get_mark(entry);
> > +			return entry;
> > +		}
> > +	}
> > +	return NULL;
> > +}
> > +/*
> 
> Missed newline before comment's start :)

don't I wish this was my only problem  :)

> 
> > + * This is a low use function called when userspace is changing what is being
> > + * watched.  I don't mind doing the allocation since I'm assuming we will have
> > + * more new events than we have adding to old events...
> > + *
> > + * add (we use |=) the mark to the in core inode mark, if you need to change
> > + * rather than | some new bits you needs to fsnotify_destroy_mark_by_inode()
> > + * then call this with all the right bits in the mask.
> > + */
> > +struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, __u64 mask)
> > +{
> > +	/* we initialize entry to shut up the compiler in case we just to out... */
> > +	struct fsnotify_mark_entry *entry = NULL, *lentry;
> > +
> > +	/* pre allocate an entry so we can hold the lock */
> > +	entry = fsnotify_alloc_mark();
> > +	if (!entry)
> > +		return NULL;
> > +
> > +	/*
> > +	 * LOCKING ORDER!!!!
> > +	 * entry->lock
> > +	 * group->mark_lock
> > +	 * inode->i_lock
> > +	 */
> > +	spin_lock(&group->mark_lock);
> > +	spin_lock(&inode->i_lock);
> > +	lentry = fsnotify_find_mark_entry(group, inode);
> > +	if (lentry) {
> > +		/* we didn't use the new entry, kill it */
> > +		fsnotify_destroy_mark(entry);
> > +		entry = lentry;
> > +		entry->mask |= mask;
> > +		goto out_unlock;
> > +	}
> > +
> > +	spin_lock_init(&entry->lock);
> > +	atomic_set(&entry->refcnt, 1);
> > +	entry->group = group;
> > +	entry->mask = mask;
> > +	entry->inode = inode;
> 
> That's what I talked about previously, what if this inode will be
> released after inode unlocked?

__fsnotify_inode_delete() will clean this up when the inode is being
booted.  since this entry is on the inode->i_fsnotify_mark_entries list.



