Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYHYRGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYHYRGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYHYRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:06:47 -0400
Received: from ms01.sssup.it ([193.205.80.99]:41643 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753129AbYHYRGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:06:46 -0400
Date: Mon, 25 Aug 2008 19:06:41 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Matthew <jackdachef@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080825170641.GA4720@gandalf.sssup.it>
References: <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk> <20080515122156.GA11600@gandalf.sssup.it> <6278d2220808241324j117725efq8e87025313fb025f@mail.gmail.com> <20080825202936.GA3608@gandalf.sssup.it> <6278d2220808250839j1dc25c02uda7bf8b6b150acb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220808250839j1dc25c02uda7bf8b6b150acb7@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Daniel J Blueman <daniel.blueman@gmail.com>
> Date: Mon, Aug 25, 2008 04:39:01PM +0100
>
> On Mon, Aug 25, 2008 at 9:29 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
> > Hi,
> >
> >> From: Daniel J Blueman <daniel.blueman@gmail.com>
> >> Date: Sun, Aug 24, 2008 09:24:37PM +0100
> >>
> >> Hi Fabio, Jens,
> >>
> > ...
> >> This was the last test I didn't get around to. Alas, is did help, but
> >> didn't give the merging required for full performance:
> >>
> >> # echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
> >> bs=128k count=2000
> >> 262144000 bytes (262 MB) copied, 2.47787 s, 106 MB/s
> >>
> >> # echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
> >> Timing buffered disk reads:  308 MB in  3.01 seconds = 102.46 MB/sec
> >>
> >> It is an improvement over the baseline performance of 2.6.27-rc4:
> >>
> >> # echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
> >> bs=128k count=2000
> >> 262144000 bytes (262 MB) copied, 2.56514 s, 102 MB/s
> >>
> >> # echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
> >> Timing buffered disk reads:  294 MB in  3.02 seconds =  97.33 MB/sec
> >>
> >> Note that platter speed is around 125MB/s (which I get near at smaller
> >> read sizes).
> >>
> >> I feel 128KB read requests are perhaps important, as this is a
> >> commonly-used RAID stripe size, and may explain the read-performance
> >> drop sometimes we see in hardware vs software RAID benchmarks.
> >>
> >> How can we generate some ideas or movement on fixing/improving this behaviour?
> >>
> >
> > Thank you for testing.  The blktrace output for this run should be
> > interesting, esp. to compare it with a blktrace obtained from anticipatory
> > with the same workload - IIRC anticipatory didn't suffer from the problem,
> > and anticipatory has a slightly different dispatching mechanism that
> > this patch tried to bring into cfq.
> >
> > Even if a proper fix may not belong to the elevator itself, I think
> > that this couple (this last test + anticipatory) of traces should help
> > in better understanding what is still going wrong.
> >
> > Thank you in advance.
> 
> See http://quora.org/blktrace-n.tar.bz2
> 
> Where n is:
>  0 - 2.6.27-rc4 unpatched
>  1 - 2.6.27-rc4 with your CFQ patch, CFQ scheduler
>  2 - 2.6.27-rc4 with your CFQ patch, anticipatory scheduler
>  3 - 2.6.27-rc4 with your CFQ patch, deadline scheduler
> 
> I have found it's not always possible to reproduce this issue, eg now,
> with stock CFQ, I'm seeing consistent 117-123MB/s with hdparm and dd
> (as above), whereas I was seeing a consistent 95-103MB/s, so the
> blktraces may not show the slower-performance pattern - even with
> precisely the same (controlled) environment.
> 

If I read them correctly, all the traces show dispatches with
requests still growing; the elevator cannot know if a request
will grow or not once it has been queued, and the heuristics
we tried so far to postpone dispatches gave no results.

I don't see any elevator-only solution to the problem...
