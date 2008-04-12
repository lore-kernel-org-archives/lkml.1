Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYDLUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYDLUNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYDLUM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:12:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53153 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYDLUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:12:56 -0400
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Alan Mayer <ajm@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
In-Reply-To: <Pine.SGI.3.96.1080326134915.7873204Z-100000@fergus.americas.sgi.com>
References: <Pine.SGI.3.96.1080326134915.7873204Z-100000@fergus.americas.sgi.com>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 13:12:42 -0700
Message-Id: <1208031162.31434.15.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 13:55 -0500, Alan Mayer wrote:
> On Wed, 26 Mar 2008, Linus Torvalds wrote:
> 
> > 
> > 
> > On Wed, 26 Mar 2008, Pavel Machek wrote:
> > > 
> > > This is very ugly. Why not include it unconditionally -- with guard in
> > > apicdef.h?
> > 
> > I do agree that it's ugly, but I think the ugliness is more serious than 
> > that.
> > 
> > What I think we should do is to make NR_IRQS no longer be a compile-time 
> > constant, but instead just do something like
> > 
> > 	unsigned int NR_IRQS __read_mostly;
> > 
> > and then just set it early in the boot sequence depending on the real CPU 
> > numbers etc.
> > 
> > I realize that this will require some changes to a few arrays that are 
> > statically allocated and depend on NR_IRQ's (notably "irq_desc"), but 
> > don't you guys think that this would be a cleaner thing?
> > 
> > [ I suspect that irq_desc[] itself could quite reasonably be a rather much 
> >   smaller __read_mostly hash-table of dynamically allocated entries - the 
> >   thing would be only modified at boot, so it should cache beautifully 
> >   even across hundreds of CPU's ]
> > 
> > Whatever. I'm not opposed to this whole static thing, but I do wonder if 
> > it's worth doing that way. There *may* be performance reasons for doing it 
> > the way we're doing it, but quite frankly, I think the #define is mostly 
> > purely historical, from when it was just a fixed number (originally 16!) 
> > and it made sense to think of it as a small static array.
> > 
> > 			Linus
> > 
> 
> Well, I was looking at it from that point of view.  But, when I found myself
> looking at code, particularly in drivers, that indexed into the irq_desc array
> and started modifying the descriptor in place and then calling setup_irq(),
> I realized that what was needed was a redesign of the whole mess from first
> principals.  I still think that's what needs to be done, but by some one with
> more experience and credibility than me.  Maybe in a year I'd be willing
> to attempt it, but not today.

Well I will agree with Linus and go one farther and say that NR_IRQS
needs to die.  I started on that once and x86 is just about ready to
accomodate it.

There is a size issue on small machines.  And there is very bad NUMA
affinity on large machines.  So the current structure really is not
optimal for anyone.  All of this gets especially bad for distro kernels
that try and support everything.

Also MAX_IOAPICS is very much the wrong factor to be using on large
machines to size the irq array.  New machines are moving towards MSI and
cards can have an unreasonable number of MSI irqs.  In practice the top
end I have seen is 20-30 per card but it is still a lot.    So I think
you may get a nasty surprise when you plug in a bunch of high
performance cards with multiple queues into a big box.  The 32*NR_CPUS
as a rule of thumb comes from IBM boxes that are a little better
balanced when it comes to compute vs. I/O capablility.  

For actual irq reception we have our per cpu array of vectors that point
to the irq_desc so even if the global list of irqs was a linked list we
should not have performance problems.

I need to do some sorting out of sysfs first but I will certainly see if
I can look at this again.  And I will very much be willing to work with
someone else who wants to work on this and has more time then I do at
the moment.

The basic idea is moving the generic irq apis to a point where we can
refer to irqs in the generic code with a struct irq * instead of by
number.  We really only the need the number for talking about irqs to
user space.

Eric


