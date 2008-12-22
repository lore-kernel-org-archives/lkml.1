Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYLVCkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYLVCkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 21:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYLVCkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 21:40:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYLVCkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 21:40:25 -0500
Subject: Re: [RFC PATCH -v4 12/14] fsnotify: add correlations between events
From: Eric Paris <eparis@redhat.com>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, hch@infradead.org, zbr@ioremap.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <c6d9bea0812181428s2ae78e30y1e700b2eca07ca96@mail.gmail.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215217.27112.75137.stgit@paris.rdu.redhat.com>
	 <c6d9bea0812181428s2ae78e30y1e700b2eca07ca96@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 21 Dec 2008 21:40:01 -0500
Message-Id: <1229913601.29604.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 17:28 -0500, C. Scott Ananian wrote:
> On Fri, Dec 12, 2008 at 4:52 PM, Eric Paris <eparis@redhat.com> wrote:
> > inotify sends userspace a correlation between events when they are related
> > (aka when dentries are moved).  This adds that same support for all
> > fsnotify events.
> > diff --git a/fs/notify/notification.c b/fs/notify/notification.c
> > index 8ed9d32..7243b20 100644
> > --- a/fs/notify/notification.c
> > +++ b/fs/notify/notification.c
> > @@ -34,6 +35,13 @@
> >
> >  static struct kmem_cache *event_kmem_cache;
> >  static struct kmem_cache *event_holder_kmem_cache;
> > +static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
> > +
> > +u32 fsnotify_get_cookie(void)
> > +{
> > +        return atomic_inc_return(&fsnotify_sync_cookie);
> > +}
> > +EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
> >
> >  int fsnotify_check_notif_queue(struct fsnotify_group *group)
> >  {
> 
> atomic_inc_return seems rather expensive to put on a hot path in
> almost every fs operation.  On a multiprocessor system, the cache line
> for fsnotify_sync_cookie would be ping-ponging constantly between
> processors.  The canonical solution is to form the cookie by
> concatenating the processor number with a per-processor cookie, so
> that generating a new cookie would not require synchronization between
> processors.  Surely this code already exists to be used somewhere in
> Linux.

A) this isn't a hot path, it's only when a file is renamed.

B) It's still a great idea (even if not here at least where I plan to
use an atomic_inc_return in my later fanotify patches).  Does anyone
know of an example of something like this in kernel?

Here I'm slightly concerned wasting enough bits of the 32 (we can't grow
it, because inotify has a fixed abi) for processors, but I'd be
surprised to find we'd ever have enough renames on a single processor
(my 2 second math would be we'd need about 13-14 bits for processors
which still leaves 262k renames per processor before anything wrapped)
to be a problem.

anyone who uses inotify think there would be a problem with cookie reuse
coming this soon?

Since I'm using a 64bit cookie and the lifetime of use in my later code
is measured in seconds I think this would be a great improvement.
Thanks

-Eric

