Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXDZCU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXDZCU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbXDZCU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:20:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbXDZCU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:20:26 -0400
Date: Wed, 25 Apr 2007 19:20:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-Id: <20070425192020.aa14b08f.akpm@linux-foundation.org>
In-Reply-To: <20070425191359.GA13241@infradead.org>
References: <20070425154934.GP6798@traven>
	<20070425191359.GA13241@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 20:13:59 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Apr 25, 2007 at 05:49:34PM +0200, Matthias Kaehlcke wrote:
> > drivers/char/tty_io.c uses a semaphore as mutex. use the mutex API
> > instead of the (binary) semaphore
> 
> This looks like it should be a spinlock:
> 
> > -		down(&allocated_ptys_lock);
> > +		mutex_lock(&allocated_ptys_lock);
> >  		idr_remove(&allocated_ptys, idx);
> > -		up(&allocated_ptys_lock);
> > +		mutex_unlock(&allocated_ptys_lock);
> 
> idr_remove is a quick operation that doesn't sleep.
> 
> > @@ -2639,24 +2639,24 @@ static int ptmx_open(struct inode * inode, struct file * filp)
> >  	nonseekable_open(inode, filp);
> >  
> >  	/* find a device that is not in use. */
> > -	down(&allocated_ptys_lock);
> > +	mutex_lock(&allocated_ptys_lock);
> >  	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
> > -		up(&allocated_ptys_lock);
> 
> The idr_pre_get should be moved out of the lock, that's the whole
> point for it's existance..
> 

I think having it inside the lock makes sense:

	mutex_lock()
	idr_pre_get()
	idr_get_new()
	mutex_unlock()

here, if idr_pre_get() succeeded, we know that idr_get_new() will succeed.

otoh:

try_again:
	idr_pre_get()
	mutex_lock()
	if (idr_get_new() == failed) {
		mutex_unlock()
		goto try_again;
	}
	mutex_unlock()

is not nice.


the IDR api is awful.  A little project is to rip out all its internal
locking and to implement caller-provided locking.

Unfortunately the fact that the library allocates memory means that we
might need to do awkward things like radix_tree_preload() to make it
reliable for callers who use spinlocking.

