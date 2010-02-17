Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab0BQEaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 23:30:22 -0500
Received: from thunk.org ([69.25.196.29]:38477 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934026Ab0BQEaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 23:30:21 -0500
Date: Tue, 16 Feb 2010 23:30:09 -0500
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100217043009.GZ5337@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
	stable@kernel.org, gregkh@suse.de
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <20100215141750.GC3434@quack.suse.cz>
 <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
 <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 07:35:35PM -0800, Linus Torvalds wrote:
> >   writeback_single_inode()
> >     ...writes 1024 pages.
> >     if we haven't written everything in the inode (more than 1024 dirty
> >     pages) we end up doing either requeue_io() or redirty_tail(). In the
> >     first case the inode is put to b_more_io list, in the second case to
> >     the tail of b_dirty list. In either case it will not receive further
> >     writeout until we go through all other members of current b_io list.
> > 
> >   So I claim we currently *do* switch to another inode after 4 MB. That
> > is a fact.
> 
> Ok, I think that's the bug. I do agree that it may well be intentional, 
> but considering the performance impact, I suspect it's been "intentional 
> without any performance numbers".

This is well known amongst file system developers.  We've even raised
it from time to time, but apparently most people are too scared to
touch the writeback code.  I proposed upping the limit some six months
ago, but I got serious pushback.  As a result, I followed XFS's lead,
and so now, both XFS and ext4 will write more pages than what is
requested by the writeback logic, to work around this bug.....

What we really want to do is to time how fast the device is.  If the
device is some Piece of Sh*t USB stick, then maybe you only want to
write 4MB at a time to avoid latency problems.  Heck, maybe you only
want to write 32k at a time, if it's really slow....  But if it's some
super-fast RAID array, maybe you want to write a lot more than 4MB at
a time.

We've had this logic for a long time, and given the increase in disk
density, and spindle speeds, the 4MB limit, which might have made
sense 10 years ago, probably doesn't make sense now.

> If it's bad for synchronous syncs, then it's bad for background syncing 
> too, and I'd rather get rid of the MAX_WRITEBACK_PAGES thing entirely - 
> since the whole latency argument goes away if we don't always honor it 
> ("Oh, we have good latency - _except_ if you do 'sync()' to synchronously 
> write something out" - that's just insane).

I tried arguing for this six months ago, and got the argument that it
might cause latency problems on slow USB sticks.  So I added a forced
override for ext4, which now writes 128MB at a time --- with a sysfs
tuning knob that allow the old behaviour to be restored if users
really complained.  No one did actually complain....

						- Ted
