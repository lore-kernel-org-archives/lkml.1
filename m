Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYJ2Uhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYJ2Uhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYJ2Uhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:37:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754535AbYJ2Uhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:37:31 -0400
Date: Wed, 29 Oct 2008 16:37:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: rjw@sisk.pl, <linux-kernel@vger.kernel.org>, <ncunningham@crca.org.au>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
In-Reply-To: <E1KvDcp-0008B7-SR@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Miklos Szeredi wrote:

> On Wed, 29 Oct 2008, Alan Stern wrote:
> > On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> > 
> > > Actually I was thinking of an rw-semaphore, not a mutex.  But yeah
> > > that still has scalability problems.  But it could be done with custom
> > > locking primitives, optimized for this case:
> > > 
> > >    suspend_disable();
> > >    /* driver stuff */
> > >    suspend_enable();
> > 
> > Yes, it could be done.  And the overhead could be minimized by using
> > per-CPU variables.  It would still be an awful lot of work, and easy to
> > get wrong.
> 
> OK, getting back to this, as it seems to be the only way that we agree
> is doable.
> 
> How about this,
> 
>  a) identify syscalls that may make drivers do I/O:
> 
>  - read
>  - write
>  - ioctl
>  ???
> 
>  b) add the suspend_disable/enable() primitives to these syscalls
> 
>  c) push primitives inside the implementation

I discussed this last summer with Rafael.  It's a lot harder than it 
looks, for all sorts of reasons.  For example, what about user tasks 
that have access to memory-mapped I/O regions?

> c) is slightly tricky, but could be done for example by setting a flag
> on open: FMODE_NO_SUSPEND_DISABLE (better name required), saying that
> implementation is responsible for getting the suspend disable magic
> right.
> 
> For starters this flag could be set for all non-device opens (maybe all
> non-char-dev opens?), solving the fuse vs. freezer issues without any
> complicated trickery.

I don't know.  There are other interfaces too, like sysfs attributes, 
that would have to be handled specially.  On the whole, the freezer 
seems much, much simpler.

Regarding fuse, something like Nigel's scheme for preventing new 
requests and then waiting for old requests to complete might work out.  
Especially if you combine it with a strategy for making the freezer 
back and retry after a delay when something goes wrong.

Alan Stern

