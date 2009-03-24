Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZCXR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZCXR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbZCXRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:55:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37348 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981AbZCXRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:55:09 -0400
Date: Tue, 24 Mar 2009 18:55:06 +0100
From: Jan Kara <jack@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324175506.GB15524@atrey.karlin.mff.cuni.cz>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > They don't solve the problem where there is a *huge* amount of writes
> > going on, though --- if something is dirtying pages at a rate far
> 
> At very high rates other things seem to go pear shaped. I've not traced
> it back far enough to be sure but what I suspect occurs from the I/O at
> disk level is that two people are writing stuff out at once - presumably
> the vm paging pressure and the file system - as I see two streams of I/O
> that are each reasonably ordered but are interleaved.
  There are different problems leading to this:
1) JBD commit code writes ordered data on each transaction commit. This
is done in dirtied-time order which is not necessarily optimal in case
of random access IO. IO scheduler helps here though because we submit a
lot of IO at once. ext4 has at least the randomness part of this problem
"fixed" because it submits ordered data via writepages(). Doing this
change requires non-trivial changes to the journaling layer so I wasn't
brave enough to do it with ext3 and JBD as well (although porting the
patch is trivial).

2) When we do dirty throttling, there are going to be several threads
writing out on the filesystem (if you have more pdflush threads which
translates to having more than one CPU). Jens' per-BDI writeback
threads could help here (but I haven't yet got to reading his patches in
detail to be sure).

  These two problems together result in non-optimal IO pattern. At least
that's where I got to when I was looking into why Berkeley DB is so
slow. I was trying to somehow serialize more pdflush threads on the
filesystem but a stupid solution does not really help much - either I
was starving some throttled thread by other threads doing writeback or
I didn't quite keep the disk busy. So something like Jens' approach
is probably the way to go in the end.

> > don't get *that* bad, even with ext3.  At least, I haven't found a
> > workload that doesn't involve either dd if=/dev/zero or a massive
> > amount of data coming in over the network that will cause fsync()
> > delays in the > 1-2 second category.  Ext3 has been around for a long
> 
> I see it with a desktop when it pages hard and also when doing heavy
> desktop I/O (in my case the repeatable every time case is saving large
> images in the gimp - A4 at 600-1200dpi).
> 
> The other one (#8636) seems to be a bug in the I/O schedulers as it goes
> away if you use a different I/O sched.
> 
> > solve.  Simply mounting an ext3 filesystem using ext4, without making
> > any change to the filesystem format, should solve the problem.
> 
> I will try this experiment but not with production data just yet 8)
> 
> > some other users' data files.  This was the reason for Stephen Tweedie
> > implementing the data=ordered mode, and making it the default.
> 
> Yes and in the server environment or for typical enterprise customers
> this is a *big issue*, especially the risk of it being undetected that
> they just inadvertently did something like put your medical data into the
> end of something public during a crash.
> 
> > Try ext4, I think you'll like it.  :-)
> 
> I need to, so that I can double check none of the open jbd locking bugs
> are there and close more bugzilla entries (#8147)
  This one is still there. I'll have a look at it tomorrow and hopefully
will be able to answer...

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
