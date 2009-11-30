Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZK3Pkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZK3Pkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZK3Pk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:40:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:50435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZK3Pk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:40:28 -0500
Date: Mon, 30 Nov 2009 16:40:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130154031.GE21639@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 07:22:13AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Nov 2009, Nick Piggin wrote:
> > 
> > We do have quite a large number of rwlocks really.
> 
> Dynamically they tend to be unimportant, except for the tasklist_lock. 
> Many of them are in drivers and/or finegrained, or get called only by 
> fairly unusual things (registering filesystems etc).
> 
> > If they are so important as to be rwlocks,
> 
> Stop making total red-herring arguments.

I just mean, if their usage patterns justify their being an rwlock
(as opposed to a plain spinlock). That would mean they can have
significant parallelism in read-side critical sections. And that means
they could have livelock/DoS problems.


> It's not about "so important as to be rwlocks". Quite the reverse. I'm 
> saying that most rwlocks are totally _unimportant_. Being a rwlock does 
> _not_ make anything more important or less important in itself, so your 
> argument is bogus. You have to base importantness on other issues than 
> whether they are rwlocks or not.

I agree there are probably many of them which should just be spinlocks
by nature of their usage patterns. But I would have thought that at
least *some* small percentage of them other than tasklist_lock
would be valid rwlocks.

Anyway, pointless to care about that point I guess... either they exist
or they don't, either way we can't just make all rwlocks fair of course.
So they would have to be tackled one at a time.

 
> As far as I can tell there is _one_ single important rwlock, and that's 
> tasklist_lock. Everything else could probably trivially and individually 
> be turned into a spinlock if fairness matters for them. But tasklist_lock 
> fundamentally depends on the semantics of rwlocks.
> 
> And that one rwlock requires unfair behavior, and is not going to be happy 
> with some more complicated thing (because it is also called from some 
> pretty critical pathways).
> 
> So my argument is purely:
> 
>  - there is absolutely NOBODY who cares about "fair" rwlocks, because no 
>    other user will ever hit its lock enough for it to matter. And if they
>    really do, most of them tend to be fairly simple and localized and 
>    might be turned into spinlocks.
> 
>  - the _one_ major exception to this - somebody who does hit the lock 
>    enough for fairness to matter - is not likely amenable to any kind of 
>    trivial fairness.
> 
> Now, I'd love to come up with some solution to tasklist_lock, but I just 
> don't see it. At least nothing easy that doesn't have tons of downsides 
> (like turning it into a spinlock, using the irq-safe versions, and having 
> irq's potentially disabled for much longer than I think is good).

Well the simple thing I tried earlier was a per-cpu array of nesting
counter there. It's not _too_ expensive, but it does add another cacheline
access and branch there. It seems to work in solving the livelock though.

