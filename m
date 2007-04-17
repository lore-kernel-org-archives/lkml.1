Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDQFqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDQFqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXDQFqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:46:50 -0400
Received: from ns.suse.de ([195.135.220.2]:37481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXDQFqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:46:49 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: CPU ordering with respect to krefs
Date: Tue, 17 Apr 2007 07:44:48 +0200
User-Agent: KMail/1.9.1
Cc: Eric Dumazet <dada1@cosmosbay.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <200704021447.59476.oneukum@suse.de> <20070402163354.ef741262.dada1@cosmosbay.com> <20070412062717.GA13047@kroah.com>
In-Reply-To: <20070412062717.GA13047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170744.49157.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. April 2007 08:27 schrieb Greg KH:
> On Mon, Apr 02, 2007 at 04:33:54PM +0200, Eric Dumazet wrote:
> > On Mon, 2 Apr 2007 14:47:59 +0200
> > Oliver Neukum <oneukum@suse.de> wrote:
> > 
> > > Hi,
> > > 
> > > some atomic operations are only atomic, not ordered. Thus a CPU is allowed
> > > to reorder memory references to an object to before the reference is
> > > obtained. This fixes it.
> > > 
> > > 	Regards
> > > 		Oliver
> > > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> > > ------
> > > 
> > > --- a/lib/kref.c	2007-04-02 14:40:40.000000000 +0200
> > > +++ b/lib/kref.c	2007-04-02 14:40:50.000000000 +0200
> > > @@ -21,6 +21,7 @@
> > >  void kref_init(struct kref *kref)
> > >  {
> > >  	atomic_set(&kref->refcount,1);
> > > +	smp_mb();
> > >  }
> > 
> > I dont understand why smp_mb() is needed here, and not in
> > spinlock_init() for example.
> 
> I think, after reading the Documentation/memory-barriers.txt and
> Documentation/atomic_ops.txt documentation, that spin_lock_init() also
> needs this kind of memory barrier.

spin_lock_init() is not an atomic operation.
In principle, the issue exists. However, the whole issue is a bit of a grey
area. You might take the viewpoint that upping the refcount needs to be
under lock, which needs to take care of ordering issues in case of krefs.
A new spinlock has the same issue. You need to be careful making them
accessible to other CPUs.

If you take code like:

static int producer()
{
	...
	data = kmalloc(...);
	spin_lock_init(&data->lock);
	data->value = some_value;
	data->next = global_pointer;

	global_pointer = data;
	...
}
	
You have an ordering bug anyway, which you can't fix in spin_lock_init().

	Regards
		Oliver
