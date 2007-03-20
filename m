Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXCTNxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXCTNxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCTNxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:53:31 -0400
Received: from THUNK.ORG ([69.25.196.29]:58625 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932806AbXCTNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:53:30 -0400
Date: Tue, 20 Mar 2007 09:52:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070320135231.GA6043@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Matt Mackall <mpm@selenic.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174393549.17249.101.camel@sauron>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 02:25:49PM +0200, Artem Bityutskiy wrote:
> You failed to clearly define what is block until now, then you blame me
> that I do not understand you. So I see block = eraseblock, lets assume
> for further conversation.
> 
> OK. Suppose we have done what you say, although I _do not_ think it is
> makes a lot of sense. So, now we have a block device, with 128KiB block
> size. We have LVM, dm-wl or whatever stuff. Fine.
> 
> Do you realize that 128KiB is _huge_ block size, and performance will
> suck, and suck a lot if you utilize say, ext2 or whatever block device
> FS.

As a suggestion, let's stop right here and see if we can get both
sides talking in a more constructive fashion.  Maybe it's just me, but
I see both sides talking past each other in a rather dramatic fashion.

Linux seems to allow multiple implementations of things at the edge
(such as filesystems), but not at the core (devicemapper when in,
device mapper didn't; it's unlikely that we would have two competing
block device layers or two VFS layers, etc.).  The question then is
whether UBI and dm are close enough or not that should be one
subsystem or not.

There a number of red herrings that have been introduced in this
discussion; of *course* the existing block device layer can handle
FLASH devices; Matt is proposing that they be extended.  And of
*course* you woulnd't propose to use ext2 on top of an 128k blocksize,
anymore than you would force a flash filesystem to use a 4k or 512
byte blocksize; there are plenty of configurations that won't make
sense, and by itself this isn't an indictment of the core idea that
the block device layer and dm should be augmented to encompass flash
functionality.

As far as who gets to do the work, unfortunately sometimes the people
submitting the new code have to make the changes suggested by the
reviewer.  That's one of the prices that gets paid for mainline
inclusion.  It's different when someone asks for a completely new
feature, especially for code that is already in mainline; then, "feel
free to send a patch" is perfectly accepted.  But if it's a matter of
refactoring the code to fit in some other framework, that's often up
to the submitter to do, not the reviewer. 

Of course, it remains to be seen whether or not this is a good idea to
do in the first place; but some of the arguments being used to shoot
down Matt's suggestion aren't really good ones to begin with.

> To make it faster I have to have a way to do finer grained I/O:
> read/write to different positions of 128KiB block. Do you realize how
> much you will abuse all the generic block device infrastructure if you
> try to add this? Note, all levels up to LVM will need to have this. A
> believe it is braindead ((c) tglx) to add this feature.

OK, and this could be it.  But I suspect one of the things which may
be missing that make it easier for you to explain why what UBI is
doing is so different from the dm and block device stack is to include
the contents of:

	http://www.linux-mtd.infradead.org/faq/ubi.html
	http://www.linux-mtd.infradead.org/doc/ubi.html

and some system level documentation in a Documentation/ubi.txt file as
part of the patch set.  I don't think people completely understand the
high-level architecture of what UBI is trying to achieve.  What are
the interfaces at the top and the bottom of the stack?  For example,
the fact that UBI exports Logical Erase blocks that are not a
power-of-two (possibly 128k minus 128 bytes) means that it certainly
might not be a good match for the dm stack.  But why is that the case?
I can imagine good reasons for it, but a high-level description of the
design decisions would be very useful.

It would also help people understand why there are so many "units" in
UBI, since hopefully the high-level documentation would explain why
they fit together, and perhaps why some of the units weren't folded
together.  What value do they add as separate components?

There are hints of the overall system architecture in some of the
indivdual comments for data structures, but even reading all of those,
there isn't quite enough for people to figure out what it is; and that
may be causing some of these comments of people saying there's too
much code to evaluate, or why didn't you do it *this* way?   

Regards,

						- Ted
