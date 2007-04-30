Return-Path: <linux-kernel-owner+w=401wt.eu-S1161654AbXD3HBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161654AbXD3HBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161659AbXD3HBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:01:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:3601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161653AbXD3HBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:01:06 -0400
Date: Mon, 30 Apr 2007 08:56:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS  is under heavy write load (massive starvation)
Message-ID: <20070430065646.GC21015@kernel.dk>
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz> <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28 2007, Linus Torvalds wrote:
> > The main problem is that if the user extracts tar archive, tar eventually
> > blocks on writeback I/O --- O.K. But if bash attempts to write one page to
> > .bash_history file at the same time, it blocks too --- bad, the user is
> > annoyed.
> 
> Right, but it's actually very unlikely. Think about it: the person who 
> extracts the tar-archive is perhaps dirtying a thousand pages, while the 
> .bash_history writeback is doing a single one. Which process do you think 
> is going to hit the "oops, we went over the limit" case 99.9% of the time?
> 
> The _really_ annoying problem is when you just have absolutely tons of 
> memory dirty, and you start doing the writeback: if you saturate the IO 
> queues totally, it simply doesn't matter _who_ starts the writeback, 
> because anybody who needs to do any IO at all (not necessarily writing) is 
> going to be blocked.
> 
> This is why having gigabytes of dirty data (or even "just" hundreds of 
> megs) can be so annoying.
> 
> Even with a good software IO scheduler, when you have disks that do tagged 
> queueing, if you fill up the disk queue with a few dozen (depends on the 
> disk what the queue limit is) huge write requests, it doesn't really 
> matter if the _software_ queuing then gives a big advantage to reads 
> coming in. They'll _still_ be waiting for a long time, especially since 
> you don't know what the disk firmware is going to do.
> 
> It's possible that we could do things like refusing to use all tag entries 
> on the disk for writing. That would probably help latency a _lot_. Right 
> now, if we do writeback, and fill up all the slots on the disk, we cannot 
> even feed the disk the read request immediately - we'll have to wait for 
> some of the writes to finish before we can even queue the read to the 
> disk.
> 
> (Of course, if disks don't support tagged queueing, you'll never have this 
> problem at all, but most disks do these days, and I strongly suspect it 
> really can aggravate latency numbers a lot).
> 
> Jens? Comments? Or do you do that already?

Yes, CFQ tries to handle that quite aggressively already. With the
emergene of NCQ on SATA, it has become a much bigger problem since it's
seen so easily on the desktop. The SCSI people usually don't care about
latency that much, so not many complaints there.

The recently posted patch series for CFQ that I will submit soon for
2.6.22 has more fixes/tweaks for this.


-- 
Jens Axboe

