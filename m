Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZDFQ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZDFQ6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZDFQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:57:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45364 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZDFQ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:57:55 -0400
Date: Mon, 6 Apr 2009 18:57:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406165753.GG5178@kernel.dk>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <20090406130414.GX5178@kernel.dk> <alpine.LFD.2.00.0904060835530.3863@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904060835530.3863@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Jens Axboe wrote:
> > 
> > Ran the fsync-tester [1]. Drive is a 3-4 years old SATA drive, fs is
> > ext3/writeback. IO scheduler is CFQ.
> > 
> > fsync time: 0.2785s
> > fsync time: 0.2640s
> > 
> > And with Linus torture dd running in the background:
> > 
> > fsync time: 0.0109s
> > fsync time: 0.5236s
> > fsync time: 1.2108s
> 
> Ok, it's definitely better for me too. CFQ used to be the problem case 
> (with the previous patches), now I've been trying with CFQ for a while, 
> and it seems ok.
> 
> Not wonderful, by any means, but I haven't seen a 5+ second delay yet. 
> I've come close (I have a few 2+s hickups in my trace), but it's 
> clearly more responsive, even if I'd wish it to be better still.

OK that's good. I'll run some testing with this as well and perhaps we
can even do better still.

> One thing that I find intriguing is how the fsync time seems so 
> _consistent_ across a wild variety of drives. It's interesting how you see 
> delays that are roughly the same order of magnitude, even though you are 
> using an old SATA drive, and I'm using the Intel SSD. And when you turn 
> off TCQ, your numbers go down even more.
> 
> That just makes me suspect that there is something else than pure IO going 
> on. There shouldn't be any idling by the IO scheduler in my setup 
> ("rotational" is zero for me), and quite frankly, I should not see 
> latencies in the seconds even _with_ TCQ, since it should be limited to 
> just 32 tags. Of course, maybe some of those requests just grow humongous. 
> 
> So maybe one reason the "sync()" workload is so horrible is that we get 
> insanely big single requests. I see
> 
> 	[root@nehalem queue]# cat max_sectors_kb 
> 	512
> 
> so we should be limited to half a meg per request, but I guess 32 of those 
> will take some time even on the Intel SSD. In fact, I guess the SSD is not 
> really any faster than your 2-3 year old SATA disk when it comes to pure 
> linear throughput

It's probably close, for your MLC version. This drive does around
60Mb/sec sequential writes, which is in the ball park with the ~70 yours
should be doing.

> Hmm. Doing a "echo 64 > max_sectors_kb" does seem to make my experience 
> nicer. At no really noticeable downside in throughput that I can see: the 
> "dd+sync" still tends to fluctuate 30-40s. But maybe I'm fooling myself. 
> But my 'strace' seems to agree: I'm having a hard time triggering anything 
> even close to a second latency now.
> 
> I wonder if we could limit the tag usage by request _size_, ie not let big 
> requests fill up all the tags (by all means allow writes to fill them up 
> if they are small - it's with many small requests that you get the biggest 
> advantage, after all, and with many _big_ requests that the downside is 
> the biggest too).

I think we are doing OK with the tag async vs sync allocation, there
should be plenty of room for sync IO still. The problem is likely
earlier, before we even assign a tag. The IO schedulers will move IO to
the dispatch list and the driver will grab it from there, assign a tag,
start, etc. Perhaps we end up moving too much to the dispatch list. That
would increase latencies, even if a sync queue preempts the current
async queue and dispatches a request (which goes to the dispatch list,
ordered, and thus may have to wait for others to be serviced first).

Just speculating, I'll test and probe and see what comes up.

-- 
Jens Axboe

