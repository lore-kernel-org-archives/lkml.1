Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXHAReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXHAReW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXHAReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:34:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36439 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbXHAReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:34:12 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1185983752.2636.116.camel@imap.mvista.com>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185969554.9513.106.camel@ghaskins-t60p.haskins.net>
	 <1185981025.2636.102.camel@imap.mvista.com>
	 <1185981585.9513.119.camel@ghaskins-t60p.haskins.net>
	 <1185983752.2636.116.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 13:32:31 -0400
Message-Id: <1185989551.9513.163.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 08:55 -0700, Daniel Walker wrote:
> On Wed, 2007-08-01 at 11:19 -0400, Gregory Haskins wrote:
> > On Wed, 2007-08-01 at 08:10 -0700, Daniel Walker wrote:
> > 
> > > 
> > > rt_mutex_setprio() is just a function. It was also designed specifically
> > > for PI , so it seems fairly sane to use it in other PI type
> > > situations ..
> > > 
> > 
> > Yes.  It is designed for PI and I wasn't suggesting you shouldn't use
> > the logic itself.  What I was suggesting is that dealing with an API
> > that has "rt_mutex" in it for something that has nothing to do with
> > rt_mutexes is, well...
> 
> It's fine for now .. One step at a time..

I can live with that.

> 
> > All I was suggesting is that we break out the PI subsystem from rt_mutex
> > code so its an independent PI API and have the rt_mutex subsystem become
> > a user.   That's a far cleaner way to do it, IMHO.
> 
> The workqueues don't really need full blown transitive PI. So without
> that your back to the rt_mutex_setprio function .. Which could be
> renamed ..

Right ;)  That's all I am really saying, but its not a big deal.

> 
> Here was my attempt years ago , 
> 
> http://lkml.org/lkml/2005/5/31/288

Cool!  I haven't looked at the patches in depth yet, but perhaps that
concept should be revisited.

> Looking back on it, I'm not sure what users I was planning to implement
> along with it .. I'm sure I was thinking "There must be other blocking
> primitives that could use this.." , but now I don't think there are ..
> Everything pretty much runs through the rt mutex.. 

Well, not necessarily.  I think your first instinct was right.  Really
any form of waiting can potentially be subject to inversion, IMHO.
Waiting for a mutex is an obvious form, and also easy to solve since you
have clear delineation between the waiters (and their priorities) and
the resource holder.  

However, inversion can happen any time you are waiting on a resource
regardless of the blocking mechanism...for instance, waiting on a
wait_queue.  Consider the situation of three RT tasks A, B, C.  A is the
highest, C the lowest.  Assume C is a threaded IRQ handler for, say,
diskio, and C will signal a wait_queue when IO completes.  In this
scenario, A can get inverted behind B if it does diskio.  (In fact, I
think someone was reporting a similar problem on the list last week, and
the response was that we don't support that yet...I would like to change
that :).

The problem with something like a wait_queue, as previously mentioned,
is you don't have a clear way to delineate who should get PI boosted.  I
am wondering if we can put our heads together and come up with a
comprehensive solution to this problem (even if it only works in certain
situations..e.g. threads that explicitly register with a waitqueue,
etc).

The solution here might be as simple as the previously mentioned
registration API, it might be something that can be done automatically
in the infrastructure, or it might be something along the lines of
converting more things over to use rt_mutex?  I don't know what the
answer will be yet.  All have their challenges.  But I do think its a
problem worth solving.

I think the workqueue stuff we are doing is really the first step in
this direction...but really some parts of that work are just special
casing one form of the "wait_queue" scenario.  I would like to
generalize this going forward.

> workqueues are just
> "dancing" , or changing priorities up/down which is really only the
> lowest level of what the rt-mutex does.

I totally agree that what the workqueues are currently doing in our
patches are just a subset of PI.  But I absolutely think there are
potential users of at least some of PI like facilities other than just
mutexes.

I appreciate your review, discussion, and contribution on this matter,
Daniel.  Thank you!  I will take a look at your PI patches to see if I
think it aligns with my current thoughts.

-Greg

