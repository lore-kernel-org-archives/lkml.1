Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYJ2VHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYJ2VHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYJ2VHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:07:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45435 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbYJ2VHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:07:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Wed, 29 Oct 2008 22:11:48 +0100
User-Agent: KMail/1.9.9
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810292211.49021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Alan Stern wrote:
> On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> 
> > On Wed, 29 Oct 2008, Alan Stern wrote:
> > > On Wed, 29 Oct 2008, Miklos Szeredi wrote:
> > > 
> > > > Actually I was thinking of an rw-semaphore, not a mutex.  But yeah
> > > > that still has scalability problems.  But it could be done with custom
> > > > locking primitives, optimized for this case:
> > > > 
> > > >    suspend_disable();
> > > >    /* driver stuff */
> > > >    suspend_enable();
> > > 
> > > Yes, it could be done.  And the overhead could be minimized by using
> > > per-CPU variables.  It would still be an awful lot of work, and easy to
> > > get wrong.
> > 
> > OK, getting back to this, as it seems to be the only way that we agree
> > is doable.
> > 
> > How about this,
> > 
> >  a) identify syscalls that may make drivers do I/O:
> > 
> >  - read
> >  - write
> >  - ioctl
> >  ???
> > 
> >  b) add the suspend_disable/enable() primitives to these syscalls
> > 
> >  c) push primitives inside the implementation
> 
> I discussed this last summer with Rafael.  It's a lot harder than it 
> looks, for all sorts of reasons.  For example, what about user tasks 
> that have access to memory-mapped I/O regions?
> 
> > c) is slightly tricky, but could be done for example by setting a flag
> > on open: FMODE_NO_SUSPEND_DISABLE (better name required), saying that
> > implementation is responsible for getting the suspend disable magic
> > right.
> > 
> > For starters this flag could be set for all non-device opens (maybe all
> > non-char-dev opens?), solving the fuse vs. freezer issues without any
> > complicated trickery.
> 
> I don't know.  There are other interfaces too, like sysfs attributes, 
> that would have to be handled specially.  On the whole, the freezer 
> seems much, much simpler.
> 
> Regarding fuse, something like Nigel's scheme for preventing new 
> requests and then waiting for old requests to complete might work out.  
> Especially if you combine it with a strategy for making the freezer 
> back and retry after a delay when something goes wrong.

Yeah.

The current design of the freezer is rather simplistic and I'm not really sure
it's the best one possible.  Perhaps we can redesign the freezer to work
differently and handle the cases like fuse.

I didn't have the time to think about that yet, though.

Thanks,
Rafael
