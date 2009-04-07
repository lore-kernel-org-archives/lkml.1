Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZDGXNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZDGXNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbZDGXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbZDGXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:29 -0400
Date: Tue, 7 Apr 2009 16:06:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 07/13] fsnotify: generic notification queue and
 waitq
Message-Id: <20090407160626.1ff81b1e.akpm@linux-foundation.org>
In-Reply-To: <20090327200543.32007.98060.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200543.32007.98060.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:43 -0400
Eric Paris <eparis@redhat.com> wrote:

> inotify needs to do asyc notification in which event information is stored
> on a queue until the listener is ready to receive it.  This patch
> implements a generic notification queue for inotify (and later fanotify) to
> store events to be sent at a later time.
> 
>
> ...
>
> +/* return 1 if something is available, return 0 otherwise */
> +int fsnotify_check_notif_queue(struct fsnotify_group *group)
> +{
> +	BUG_ON(!mutex_is_locked(&group->notification_mutex));
> +	return !list_empty(&group->notification_list);
> +}

It's a poorly named function, because the name ("check") doesn't convey
information about the return value.

Better would be

	bool fsnotify_notif_queue_nonempty(...)

or

	bool fsnotify_notif_queue_empty(...)

(and invert test in callers)

	
and the abbreviation of "notify" to "notif" just makes it harder to
remember its name.

best is

	bool fsnotify_notify_queue_is_empty(...)

>  void fsnotify_get_event(struct fsnotify_event *event)
>  {
> @@ -45,26 +60,180 @@ void fsnotify_put_event(struct fsnotify_event *event)
>  		return;
>  
>  	if (atomic_dec_and_test(&event->refcnt)) {
> -		if (event->data_type == FSNOTIFY_EVENT_PATH) {
> +		if (event->data_type == FSNOTIFY_EVENT_PATH)
>  			path_put(&event->path);
> -			event->path.dentry = NULL;
> -			event->path.mnt = NULL;
> -		}
> +		kmem_cache_free(event_kmem_cache, event);
> +	}
> +}
>  
> -		event->mask = 0;
> +struct fsnotify_event_holder *alloc_event_holder(void)
> +{
> +	return kmem_cache_alloc(event_holder_kmem_cache, GFP_KERNEL);
> +}

That's a pretty generic-sounding name for a global symbol.

> -		kmem_cache_free(event_kmem_cache, event);
> +void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
> +{
> +	kmem_cache_free(event_holder_kmem_cache, holder);
> +}

That one's better.

> +/*
> + * check if 2 events contain the same information.
> + */
> +static inline int event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
> +{
> +	if ((old->mask == new->mask) &&
> +	    (old->to_tell == new->to_tell) &&
> +	    (old->data_type == new->data_type)) {
> +		switch (old->data_type) {
> +		case (FSNOTIFY_EVENT_INODE):
> +			if (old->inode == new->inode)
> +				return 1;
> +			break;
> +		case (FSNOTIFY_EVENT_PATH):
> +			if ((old->path.mnt == new->path.mnt) &&
> +			    (old->path.dentry == new->path.dentry))
> +				return 1;
> +		case (FSNOTIFY_EVENT_NONE):
> +			return 1;
> +		};
>  	}
> +	return 0;
>  }

The compiler would have inlined this.

> -struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type)
> +/*
> + * Add an event to the group notification queue.  The group can later pull this
> + * event off the queue to deal with.
> + */
> +int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event)

s/notif/notify/

> +{
> +	struct fsnotify_event_holder *holder = NULL;
> +	struct list_head *list = &group->notification_list;
> +	struct fsnotify_event_holder *last_holder;
> +	struct fsnotify_event *last_event;
> +
> +	/*
> +	 * Check if we expect to be able to use the in event holder.  If not alloc
> +	 * a new holder.
> +	 * For the overflow event it's possible that something will use the in
> +	 * event holder before we get the lock so we may need to jump back and
> +	 * alloc a new holder.
> +	 */

The term "in event" is unclear to this reader.

> +	if (!list_empty(&event->holder.event_list)) {
> +alloc_holder:
> +		holder = alloc_event_holder();
> +		if (!holder)
> +			return -ENOMEM;
> +	}
> +
> +	mutex_lock(&group->notification_mutex);
> +
> +	if (group->q_len >= group->max_events)
> +		event = &q_overflow_event;
> +
> +	spin_lock(&event->lock);
> +
> +	if (list_empty(&event->holder.event_list)) {
> +		if (unlikely(holder))
> +			fsnotify_destroy_event_holder(holder);
> +		holder = &event->holder;
> +	} else if (unlikely(!holder)) {
> +		/* between the time we checked above and got the lock the in
> +		 * event holder was used, go back and get a new one */
> +		spin_unlock(&event->lock);
> +		mutex_unlock(&group->notification_mutex);
> +		goto alloc_holder;
> +	}
> +
> +	if (!list_empty(list)) {
> +		last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
> +		last_event = last_holder->event;
> +		if (event_compare(last_event, event)) {
> +			spin_unlock(&event->lock);
> +			mutex_unlock(&group->notification_mutex);
> +			if (holder != &event->holder)
> +				fsnotify_destroy_event_holder(holder);
> +			return 0;
> +		}
> +	}
> +
> +	group->q_len++;
> +	holder->event = event;
> +
> +	fsnotify_get_event(event);
> +	list_add_tail(&holder->event_list, list);
> +	spin_unlock(&event->lock);
> +	mutex_unlock(&group->notification_mutex);
> +
> +	wake_up(&group->notification_waitq);
> +	return 0;
> +}
> +
>
> ...
>

