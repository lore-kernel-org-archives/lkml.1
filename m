Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbXD0PTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbXD0PTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXD0PTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:19:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983AbXD0PTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:19:10 -0400
Date: Fri, 27 Apr 2007 08:18:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <1177660767.6567.41.camel@Homer.simpson.net>
Message-ID: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Mike Galbraith wrote:
> 
> As subject states, my GUI is going away for extended periods of time
> when my very full and likely highly fragmented (how to find out)
> filesystem is under heavy write load.  While write is under way, if
> amarok (mp3 player) is running, no song change will occur until write is
> finished, and the GUI can go _entirely_ comatose for very long periods.
> Usually, it will come back to life after write is finished, but
> occasionally, a complete GUI restart is necessary.

One thing to try out (and dammit, I should make it the default now in 
2.6.21) is to just make the dirty limits much lower. We've been talking 
about this for ages, I think this might be the right time to do it.

Especially with lots of memory, allowing 40% of that memory to be dirty is 
just insane (even if we limit it to "just" 40% of the normal memory zone. 
That can be gigabytes. And no amount of IO scheduling will make it 
pleasant to try to handle the situation where that much memory is dirty.

So I do believe that we could probably do something about the IO 
scheduling _too_:

 - break up large write requests (yeah, it will make for worse IO 
   throughput, but if make it configurable, and especially with 
   controllers that don't have insane overheads per command, the 
   difference between 128kB requests and 16MB requests is probably not 
   really even noticeable - SCSI things with large per-command overheads 
   are just stupid)

   Generating huge requests will automatically mean that they are 
   "unbreakable" from an IO scheduler perspective, so it's bad for latency 
   for other reqeusts once they've started.

 - maybe be more aggressive about prioritizing reads over writes.

but in the meantime, what happens if you apply this patch?

Actually, you don't need to apply the patch - just do

	echo 5 > /proc/sys/vm/dirty_background_ratio
	echo 10 > /proc/sys/vm/dirty_ratio

and say if it seems to improve things. I think those are much saner 
defaults especially for a desktop system (and probably for most servers 
too, for that matter).

Even 10% of memory dirty can be a whole lot of RAM, but it should 
hopefully be _better_ than the insane default we have now.

Historical note: allowing about half of memory to contain dirty pages made 
more sense back in the days when people had 16-64MB of memory, and a 
single untar of even fairly small projects would otherwise hit the disk. 
But memory sizes have grown *much* more quickly than disk speeds (and 
latency requirements have gone down, not up), so a default that may 
actually have been perfectly fine at some point seems crazy these days..

		Linus

---
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f469e3c..a794945 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -67,12 +67,12 @@ static inline long sync_writeback_pages(void)
 /*
  * Start background writeback (via pdflush) at this percentage
  */
-int dirty_background_ratio = 10;
+int dirty_background_ratio = 5;
 
 /*
  * The generator of dirty data starts writeback at this percentage
  */
-int vm_dirty_ratio = 40;
+int vm_dirty_ratio = 10;
 
 /*
  * The interval between `kupdate'-style writebacks, in jiffies
