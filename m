Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXD1QGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXD1QGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXD1QGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:06:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbXD1QGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:06:10 -0400
Date: Sat, 28 Apr 2007 09:05:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Mikulas Patocka wrote:
> > 
> > Especially with lots of memory, allowing 40% of that memory to be dirty is
> > just insane (even if we limit it to "just" 40% of the normal memory zone.
> > That can be gigabytes. And no amount of IO scheduling will make it
> > pleasant to try to handle the situation where that much memory is dirty.
> 
> What about using different dirtypage limits for different processes?

Not good. We inadvertedly actually had a very strange case of that, in the 
sense that we had different dirtypage limits depending on the type of the 
allocation: if somebody used GFP_HIGHUSER, he'd be looking at the 
percentage as a percentage of _all_ memory, but if somebody used 
GFP_KERNEL he'd look at it as a percentage of just the normal low memory. 
So effectively they had different limits (the percentage may have been the 
same, but the _meaning_ of the percentage changed ;)

And it's really problematic, because it means that the process that has a 
high tolerance for dirty memory will happily dirty a lot of RAM, and then 
when the process that has a _low_ tolerance comes along, it might write 
just a single byte, and go "oh, damn, I'm way over my dirty limits, I will 
now have to start doing writeouts like mad".

Your form is much better:

> --- i.e. every process has dirtypage activity counter, that is increased when
> it dirties a page and decreased over time.

..but is really hard to do, and in particular, it's really hard to make 
any kinds of guarantees that when you have a hundred processes, they won't 
go over the total dirty limit together!

And one of the reasons for the dirty limit is that the VM really wants to 
know that it always has enough clean memory that it can throw away that 
even if it needs to do allocations while under IO, it's not totally 
screwed.  An example of this is using dirty mmap with a networked 
filesystem: with 2.6.20 and later, this should actually _work_ fairly 
reliably, exactly because we now also count the dirty mapped pages in the 
dirty limits, so we never get into the situation that we used to be able 
to get into, where some process had mapped all of RAM, and dirtied it 
without the kernel even realizing, and then when the kernel needed more 
memory (in order to write some of it back), it was totally screwed.

So we do need the "global limit", as just a VM safety issue. We could do 
some per-process counters in addition to that, but generally, the global 
limit actually ends up doing the right thing: heavy writers are more 
likely to _hit_ the limit, so statistically the people who write most are 
also the people who end up havign to clean up - so it's all fair.

> The main problem is that if the user extracts tar archive, tar eventually
> blocks on writeback I/O --- O.K. But if bash attempts to write one page to
> .bash_history file at the same time, it blocks too --- bad, the user is
> annoyed.

Right, but it's actually very unlikely. Think about it: the person who 
extracts the tar-archive is perhaps dirtying a thousand pages, while the 
.bash_history writeback is doing a single one. Which process do you think 
is going to hit the "oops, we went over the limit" case 99.9% of the time?

The _really_ annoying problem is when you just have absolutely tons of 
memory dirty, and you start doing the writeback: if you saturate the IO 
queues totally, it simply doesn't matter _who_ starts the writeback, 
because anybody who needs to do any IO at all (not necessarily writing) is 
going to be blocked.

This is why having gigabytes of dirty data (or even "just" hundreds of 
megs) can be so annoying.

Even with a good software IO scheduler, when you have disks that do tagged 
queueing, if you fill up the disk queue with a few dozen (depends on the 
disk what the queue limit is) huge write requests, it doesn't really 
matter if the _software_ queuing then gives a big advantage to reads 
coming in. They'll _still_ be waiting for a long time, especially since 
you don't know what the disk firmware is going to do.

It's possible that we could do things like refusing to use all tag entries 
on the disk for writing. That would probably help latency a _lot_. Right 
now, if we do writeback, and fill up all the slots on the disk, we cannot 
even feed the disk the read request immediately - we'll have to wait for 
some of the writes to finish before we can even queue the read to the 
disk.

(Of course, if disks don't support tagged queueing, you'll never have this 
problem at all, but most disks do these days, and I strongly suspect it 
really can aggravate latency numbers a lot).

Jens? Comments? Or do you do that already?

			Linus
