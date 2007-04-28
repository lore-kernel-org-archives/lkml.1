Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbXD1A4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbXD1A4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbXD1A4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:56:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbXD1A4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 03:00:22 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280145.26253.rjw@sisk.pl> <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280300.22604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 01:59, Linus Torvalds wrote:
> 
> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> >
> > Actually, the less things happen while we're creating and saving the image,
> > the less sources of potential problems there are and by freezing the kernel
> > threads (not all of them), we cause less things to happen at that time.
> 
> That makes no sense.
> 
> You have to create the snapshot image with interrupts disabled *anyway*.
> 
> I really don't see how you can say that stopping threads etc can make any 
> difference what-so-ever. If you don't create the snapshot with interrupts 
> disabled (and just with a single CPU running) you have so many other 
> problems that it's not even remotely funny.
> 
> So there's *by*definition* nothing at all that can happen while you 
> snapshot the system. Claiming otherwise is just silly.

For creating the snapshot alone, it doesn't matter.  Except that the restore is
cleaner a bit (we know exactly what all of these threads will be doing when
we restore the image and enable the IRQs after that).

Still, I think that kernel threads can potentailly hold locks accross the
freezing of devices and image creation and that is fishy.  Also I believe,
although I'm not 100% sure, that some of them may cause problems to
appear after we've created the image and while we are saving it.

> > To make you happy, we could stop doing that, but what actual _advantage_
> > that would bring?
> 
> Like getting rid of all the magic "I don't want you to freeze me" crud?

And what exactly is wrong with it?

> Or getting rid of this horribly idiotic "three times widdershins" kind of 
> black magic mentality! It looks like the main reason for the process 
> freezing has nothing to do with technology, but some irrational fear of 
> other things happening at the same time, even though they CANNOT happen if 
> you do things even half-way sanely.
> 
> The "let's stop all kernel threads" is superstition. It's the same kind of 
> superstition that made people write "sync" three times before turning off 
> the power in the olden times. It's the kind of superstition that comes 
> from "we don't do things right, so let's be vewy vewy quiet and _pray_ 
> that it works when we are beign quiet".
>
> That's bad.

Okay.  Accidentally, I'm working on a freezer patch, so I'll probably drop
the freezing of kernel threads from swsusp in it and we'll see what happens.

Let's do the experiment, shall we?

> It's doubly bad, because that idiocy has also infected s2ram. Again, 
> another thing that really makes no sense at all - and we do it not just 
> for snapshotting, but for s2ram too. Can you tell me *why*?

Why we freeze tasks at all or why we freeze kernel threads?

> > > Trying to freeze kernel threads has _caused_ problems. It has _added_ 
> > > these interdependencies. It hasn't removed a single dependency at any 
> > > time, it has just added new problems!
> > 
> > What problems are you talking about?
> 
> Like you wouldn't know. Look at commit b43376927a that you yourself are 
> credited with, just a month ago. 
> 
> Then, do something as simple as
> 
> 	git grep create_freezeable_workthread

s/workthread/workqueue/

> and ponder the end results of that grep. If you don't see something wrong, 
> you're blind.

This was a mistake, quite unrelated to the point you're making.  And actually,
I was trying to fix a problem with two kernel threads that we thought might
submit I/O to disk after the image had been created.  Otherwise I wouldn't
have thought of doing that change.

> > > NONE of these are valid explanations at all. You're listing totally 
> > > theoretical problems, and ignoring all the _real_ problems that trying to 
> > > freeze kernel threads has _caused_.
> > 
> > Example, please?
> 
> Who do you think you are kidding? See above.

Well, if someone does something in a wrong way, that need not mean the
thing he was trying to do was wrong.

Somehow, I knew you would point at this ...

> And if you think that's an isolated example, look again. And start 
> grepping for PF_NOFREEZE, and other examples.

May I say I'm not convinced?

> The fact is, there is not a *single* reason to freeze kernel threads. But 
> some rocket scientist decided to, and then screwed everybody else over.

At least _that_ wasn't me. :-)

Greetings,
Rafael
