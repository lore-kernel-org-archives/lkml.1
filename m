Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYLMPBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYLMPBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYLMPBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:01:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYLMPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:01:40 -0500
Subject: Re: [RFC PATCH -v4 05/14] fsnotify: unified filesystem
 notification backend
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081213025417.GC807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215140.27112.67859.stgit@paris.rdu.redhat.com>
	 <20081213025417.GC807@ioremap.net>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 10:01:15 -0500
Message-Id: <1229180475.29167.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 05:54 +0300, Evgeniy Polyakov wrote:
> > +struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
> > +{
> > +	struct fsnotify_event *event;
> > +
> > +	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
> > +	if (!event)
> > +		return NULL;
> > +
> > +	atomic_set(&event->refcnt, 1);
> > +
> > +	spin_lock_init(&event->lock);
> > +
> > +	event->path.dentry = NULL;
> > +	event->path.mnt = NULL;
> > +	event->inode = NULL;
> > +
> > +	INIT_LIST_HEAD(&event->private_data_list);
> > +
> > +	event->to_tell = to_tell;
> 
> What prevents this inode to be released?

Absolutely nothing and I need to document that.  Two things,
event->to_tell and event->data if event->data_is == INODE are ONLY valid
during the call to group-?event_to_notif().  As soon as all groups
return from that call those are not valid fields.  I could set them NULL
when they aren't allowed to be used any more, but it's a wasted
operation on a VERY hot path (fsnotify())

As a side note event->data if event->data_is == FILE is perfectly
allowed to be used until the event is freed.  That's totally pointless
for this patch set and I might drop it on the next submission, but it is
needed for my fanotify notify patches that I keep in mind as I'm doing
this.

I'll remember to better document this 'quirk' in case anyone tries to
write a new notifier.

-Eric

