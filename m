Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbZAQTGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbZAQTGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZAQTGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:06:07 -0500
Received: from brick.kernel.dk ([93.163.65.50]:22435 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbZAQTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:06:04 -0500
Date: Sat, 17 Jan 2009 20:04:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090117190437.GZ30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117162657.GA31965@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17 2009, Mathieu Desnoyers wrote:
> A long standing I/O regression (since 2.6.18, still there today) has hit
> Slashdot recently :
> http://bugzilla.kernel.org/show_bug.cgi?id=12309
> http://it.slashdot.org/article.pl?sid=09/01/15/049201
> 
> I've taken a trace reproducing the wrong behavior on my machine and I
> think it's getting us somewhere.
> 
> LTTng 0.83, kernel 2.6.28
> Machine : Intel Xeon E5405 dual quad-core, 16GB ram
> (just created a new block-trace.c LTTng probe which is not released yet.
> It basically replaces blktrace)
> 
> 
> echo 3 > /proc/sys/vm/drop_caches
> 
> lttctl -C -w /tmp/trace -o channel.mm.bufnum=8 -o channel.block.bufnum=64 trace
> 
> dd if=/dev/zero of=/tmp/newfile bs=1M count=1M
> cp -ax music /tmp   (copying 1.1GB of mp3)
> 
> ls  (takes 15 seconds to get the directory listing !)
> 
> lttctl -D trace
> 
> I looked at the trace (especially at the ls surroundings), and bash is
> waiting for a few seconds for I/O in the exec system call (to exec ls).
> 
> While this happens, we have dd doing lots and lots of bio_queue. There
> is a bio_backmerge after each bio_queue event. This is reasonable,
> because dd is writing to a contiguous file.
> 
> However, I wonder if this is not the actual problem. We have dd which
> has the head request in the elevator request queue. It is progressing
> steadily by plugging/unplugging the device periodically and gets its
> work done. However, because requests are being dequeued at the same
> rate others are being merged, I suspect it stays at the top of the queue
> and does not let the other unrelated requests run.
> 
> There is a test in the blk-merge.c which makes sure that merged requests
> do not get bigger than a certain size. However, if the request is
> steadily dequeued, I think this test is not doing anything.
> 
> 
> This patch implements a basic test to make sure we never merge more
> than 128 requests into the same request if it is the "last_merge"
> request. I have not been able to trigger the problem again with the
> fix applied. It might not be in a perfect state : there may be better
> solutions to the problem, but I think it helps pointing out where the
> culprit lays.

To be painfully honest, I have no idea what you are attempting to solve
with this patch. First of all, Linux has always merged any request
possible. The one-hit cache is just that, a one hit cache frontend for
merging. We'll be hitting the merge hash and doing the same merge if it
fails. Since we even cap the size of the request, the merging is also
bounded.

Furthermore, the request being merged is not considered for IO yet. It
has not been dispatched by the io scheduler. IOW, I'm surprised your
patch makes any difference at all. Especially with your 128 limit, since
4kbx128kb is 512kb which is the default max merge size anyway. These
sort of test cases tend to be very sensitive and exhibit different
behaviour for many runs, so call me a bit skeptical and consider that an
enouragement to do more directed testing. You could use fio for
instance. Have two jobs in your job file. One is a dd type process that
just writes a huge file, the other job starts eg 10 seconds later and
does a 4kb read of a file.

As a quick test, could you try and increase the slice_idle to eg 20ms?
Sometimes I've seen timing being slightly off, which makes us miss the
sync window for the ls (in your case) process. Then you get a mix of
async and sync IO all the time, which very much slows down the sync
process.

-- 
Jens Axboe

