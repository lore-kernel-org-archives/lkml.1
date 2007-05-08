Return-Path: <linux-kernel-owner+w=401wt.eu-S1031747AbXEHUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031747AbXEHUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031686AbXEHUzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:55:40 -0400
Received: from www.osadl.org ([213.239.205.134]:34350 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031644AbXEHUzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:55:38 -0400
Subject: Re: [PATCH 1/2] LogFS proper
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
In-Reply-To: <20070508202515.GA23056@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org>
	 <20070507220036.GB15054@lazybastard.org>
	 <1178608950.3042.273.camel@localhost.localdomain>
	 <20070508163226.GA22443@lazybastard.org>
	 <1178647242.3042.404.camel@localhost.localdomain>
	 <20070508202515.GA23056@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 22:58:26 +0200
Message-Id: <1178657906.3042.434.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 22:25 +0200, Jörn Engel wrote:
> > > > Please comment the structure with kernel doc comments and avoid the tail
> > > > comments.
> > > 
> > > I'd like to hear your rationale.
> > 
> > Kernel doc comments as:
> > 
> > /**
> >  * struct hrtimer - the basic hrtimer structure
> >  * @node:       red black tree node for time ordered insertion
> >  * @expires:    the absolute expiry time in the hrtimers internal
> >  *              representation. The time is related to the clock on
> >  *              which the timer is based.
> > 
> > give you a nice overview with enough space for good explanations and can
> > be converted to kernel doc as well.
> 
> That makes sense, at least for anything that can be described as an
> interfaces.  As for the kernel-only header - not sure yet.

Well. It makes code consistent and easier to create documentation even
for interfaces which are only used inside of one subsystem. We want code
which can be maintained and worked on by others than the wizzard who
wrote it in the first place.

> > > Will that make the code look better or just slavishly follow indentation
> > > guidelines?  Adding spaces where you suggested weakens the grouping of
> > > the three for(;;) parameters, imo.
> > > 
> > 	(__i = 0; __i < LOGFS_JOURNAL_SEGS; __i++)
> > 
> > 	is way simpler to parse than
> > 
> > 	(__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
> 
> If that statement was meant to be generic, it failed for me.  Now, I
> happen to be used to one thing and you are used to another, so a large
> part of that may only be habit.  Still, I have have thought about what
> I'm doing and believe to have a slightly more objective reason (better
> grouping).

The grouping is done by "; ". I really had problems to spot the actual
operators as it looks like one large string in the first place.

So which one is more objective ? :)

> If that were true, why are function and line included in BUG() then?

ENOPARSE

> And after looking up BUG(), why is the loglevel missing from every
> printk in it? 

To avoid filtering

>  Looks like a "naked" printk is far from uncommon.

All printks need to have a loglevel for two reasons:

1) it allows them to be filtered
2) you see which category it is when you read the code

> Plus,
> in my testing, something magically added a default (<4>) loglevel to
> every printk.

default log level

> This leaves me a bit puzzled and wondering whether I should change each
> and every printk in my code.  After killing the bogus ones, of course.

Yes, please

> > > Maybe the libfs version could get moved to a header somewhere.
> > 
> > Yes please
> 
> Does anyone have a header suggestion?  fs.h is the obvious one, although
> it looks like the last thing it needs is even more content.

Shrug

> > 
> > No, open code device_read and add the error path at the place where
> > device_read is used and put a bug in the error path for now.
> 
> But that is pointless.  In particular the "for now" part is pointless.
> "For now" is exactly what I have already.  And the less I waste my time
> with cosmetics the sooner I can spend time to fix it "for good".

No it is absolutely _NOT_ pointless, it is obfuscation for no reason
other than laziness.

Now your code reads:

	device_read(...);

There is no hint that this might fail.

	if (mtd->read(.....) {
		/* FIXME: I have no clue how to handle this error */
		BUG();
	}

Is entirely clear for all readers. I know that you have no clue, but
others don't :)

> I think it is unfortunate that the second comment is just 6 characters
> longer and yet has to fill four lines instead of one.  Oh well,
> consistency wins.

Thanks

> > 	if (dest) {
> > 		 /* symlink */
> > 		ret = logfs_inode_write(inode, dest, destlen, 0);
> > 	} else {
> > 		/* creat/mkdir/mknod */
> > 		ret = __logfs_write_inode(inode);
> > 	}
> 
> That _does_ look better.  Consider me convinced.

:)

> > > > > +#if 0
> > > > 
> > > > Can you please remove this ?
> > > 
> > > Nope.  That code will get used in the future.
> > 
> > So why don't you add it when it you start to use it ?
> 
> Why do you want to see this code gone?  Unlike many of the #if 0 Adrian
> added, this code has a maintainer that cares about it.  Surely there
> must be better candidates for removal.

Fair enough. Just add some comment, why it is there and how it is going
to be used soon.


> That implies I would also do this without actually wanting to.  Or maybe
> not me but some other kernel hackers.  Is that realistic?  Have such
> bugs occurred?

Well, neither way does prevent bogus casts. I prefer the explicit one.

> > > > > +	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
> > > > > +	 * to be nonstatic, alas. */
> > > > > +	{
> > > > > +		static const struct address_space_operations empty_aops;
> > > > > +		struct address_space * const mapping = &inode->i_data;
> > > > 
> > > > Please remove the brackets and move the variables to the top of the
> > > > fucntion
> > > 
> > > Erm?  Did you read the comment?  I have copied the code from
> > > alloc_inode() without changes.  That is bad enough as it is.  If I were
> > > to change the code format, chances of detecting changes in one function
> > > not followed in the other would increase even more.
> > 
> > I read the comment, but it did not make any sense versus the brackets.
> > 
> > > I'm sure this particular gem can use some discussion, as long as it's
> > > not limited to formatting issues.
> > 
> > well, both.
> 
> Then let us discuss the more important issue of potentially exporting
> alloc_inode() first, please.

Please take this up with the folks in charge of alloc_inode.

> > > Send me a testcase. :)
> > 
> > Use nand error injection :)
> 
> I'll inject errors in ramtd then.  If nothing else, at least I'm
> familiar with that beast.

Sounds like a plan.

> > > As above, I prefer explicitly stating "this has never happened, I have
> > > no clue what should be done" over some half-assed "I hope this works,
> > > even though noone ever tested it".
> > > 
> > > Both are lame, one just happens to be slightly less wicked and a lot
> > > more honest.
> > 
> > Well, at least it would be good to return the problem back to the place,
> > where it actually would do damage and BUG there, so it is more obvious
> > where you need to work on error handling. Bugs in the middle of nowhere
> > are not really helpful
> 
> Helpful to whom?  If you volunteered to do this testing, I will gladly
> change the code to your liking.  If, as expected, I will do this work
> then I actually like it as it is "for now". :)

Well, you want to have exposure and people who test it. So making it as
easy as possible for all of them is not a bad goal.

> At least you ask this year, while I still have a faint memory of what I
> did. :)

:)

	tglx


