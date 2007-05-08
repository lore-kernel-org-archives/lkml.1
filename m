Return-Path: <linux-kernel-owner+w=401wt.eu-S1032395AbXEHVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032395AbXEHVfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032387AbXEHVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:35:18 -0400
Received: from lazybastard.de ([212.112.238.170]:45453 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032261AbXEHVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:35:16 -0400
Date: Tue, 8 May 2007 23:30:58 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508213058.GD23056@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain> <20070508163226.GA22443@lazybastard.org> <1178647242.3042.404.camel@localhost.localdomain> <20070508202515.GA23056@lazybastard.org> <1178657906.3042.434.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178657906.3042.434.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 22:58:26 +0200, Thomas Gleixner wrote:
> On Tue, 2007-05-08 at 22:25 +0200, Jörn Engel wrote:
> > > 
> > > Kernel doc comments as:
> > > 
> > > /**
> > >  * struct hrtimer - the basic hrtimer structure
> > >  * @node:       red black tree node for time ordered insertion
> > >  * @expires:    the absolute expiry time in the hrtimers internal
> > >  *              representation. The time is related to the clock on
> > >  *              which the timer is based.
> > > 
> > > give you a nice overview with enough space for good explanations and can
> > > be converted to kernel doc as well.
> > 
> > That makes sense, at least for anything that can be described as an
> > interfaces.  As for the kernel-only header - not sure yet.
>
> Well. It makes code consistent and easier to create documentation even
> for interfaces which are only used inside of one subsystem. We want code
> which can be maintained and worked on by others than the wizzard who
> wrote it in the first place.

My biggest concern right now is struct logfs_super.  That beast has
grown so large that kerneldoc style documentation means you cannot have
the definition (along with type) and the comment on the same screen
anymore.  That sucks.

Whether it sucks more than the current state is open for discussion.

One option I see is to have several kerneldoc style comments.  struct
logfs_super is roughly grouped by the files that "own" a particular
field.  That grouping is best-effort and often somewhat wrong as many
fields are used in more than one file.  But it would allow having one
comment per group.

Downside is that this help human readers of the code but will confuse
existing tools.  Yet another solution that sucks.

Is there a really good way to do it?

> > > > Will that make the code look better or just slavishly follow indentation
> > > > guidelines?  Adding spaces where you suggested weakens the grouping of
> > > > the three for(;;) parameters, imo.
> > > > 
> > > 	(__i = 0; __i < LOGFS_JOURNAL_SEGS; __i++)
> > > 
> > > 	is way simpler to parse than
> > > 
> > > 	(__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
> > 
> > If that statement was meant to be generic, it failed for me.  Now, I
> > happen to be used to one thing and you are used to another, so a large
> > part of that may only be habit.  Still, I have have thought about what
> > I'm doing and believe to have a slightly more objective reason (better
> > grouping).
> 
> The grouping is done by "; ". I really had problems to spot the actual
> operators as it looks like one large string in the first place.
> 
> So which one is more objective ? :)

If I were a parser, I would give you a point.  But my caveman eyes have
a really hard time finding those darn ";".  Spaces and lack of spaces is
simple.  Big, black, blocking the sun - must be a bear, I better run
now.  Did it have a pimple on its nose?  How should I know?

Do you feel mortally offended if I leave it and that and not change my
code?

> > If that were true, why are function and line included in BUG() then?
> 
> ENOPARSE

#define BUG() do { \
	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
	panic("BUG!"); \
} while (0)

I'm fairly confident that having LOGFS_BUG a #define is the most
efficient way to do things.  It may waste a stack slot for any compiler
unable to optimize that away, fair.  But at least it has all the
functionality.

> > And after looking up BUG(), why is the loglevel missing from every
> > printk in it? 
> 
> To avoid filtering
> 
> >  Looks like a "naked" printk is far from uncommon.
> 
> All printks need to have a loglevel for two reasons:
> 
> 1) it allows them to be filtered
> 2) you see which category it is when you read the code
> 
> > Plus,
> > in my testing, something magically added a default (<4>) loglevel to
> > every printk.
> 
> default log level

Not I'm really confused.  So there is a default log level.  And the
BUG-printk obviously gets the default log-level.  But then, how does
that avoid filtering?

Anyway, any surviving printk in my code will fare better with KERN_INFO
or KERN_DEBUG.

> > > No, open code device_read and add the error path at the place where
> > > device_read is used and put a bug in the error path for now.
> > 
> > But that is pointless.  In particular the "for now" part is pointless.
> > "For now" is exactly what I have already.  And the less I waste my time
> > with cosmetics the sooner I can spend time to fix it "for good".
> 
> No it is absolutely _NOT_ pointless, it is obfuscation for no reason
> other than laziness.
> 
> Now your code reads:
> 
> 	device_read(...);
> 
> There is no hint that this might fail.
> 
> 	if (mtd->read(.....) {
> 		/* FIXME: I have no clue how to handle this error */
> 		BUG();
> 	}
> 
> Is entirely clear for all readers.

Ok, you have a point.

> I know that you have no clue, but
> others don't :)

And I have no clue what you meant here. :)

> > > > > > +#if 0
> > > > > 
> > > > > Can you please remove this ?
> > > > 
> > > > Nope.  That code will get used in the future.
> > > 
> > > So why don't you add it when it you start to use it ?
> > 
> > Why do you want to see this code gone?  Unlike many of the #if 0 Adrian
> > added, this code has a maintainer that cares about it.  Surely there
> > must be better candidates for removal.
> 
> Fair enough. Just add some comment, why it is there and how it is going
> to be used soon.

Deal.

> > That implies I would also do this without actually wanting to.  Or maybe
> > not me but some other kernel hackers.  Is that realistic?  Have such
> > bugs occurred?
> 
> Well, neither way does prevent bogus casts.

Exactly.  If there was a good way to remove the cast, I would happily
comply.

> I prefer the explicit one.

:)

> > Then let us discuss the more important issue of potentially exporting
> > alloc_inode() first, please.
> 
> Please take this up with the folks in charge of alloc_inode.

Will do.

> Well, you want to have exposure and people who test it. So making it as
> easy as possible for all of them is not a bad goal.

You have a point.

Jörn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
