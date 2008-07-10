Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYGJIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYGJIUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYGJIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:20:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYGJIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:20:03 -0400
Date: Thu, 10 Jul 2008 01:14:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Sustrik <sustrik@fastmq.com>
Cc: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org
Subject: Re: Higher than expected disk write(2) latency
Message-Id: <20080710011417.95532d51.akpm@linux-foundation.org>
In-Reply-To: <4875C45C.2010901@fastmq.com>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	<20080709222701.8eab4924.akpm@linux-foundation.org>
	<4875C45C.2010901@fastmq.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 10:12:12 +0200 Martin Sustrik <sustrik@fastmq.com> wrote:

> Hi Andrew,
> 
> >> we're getting some rather high figures for write(2) latency when testing
> >> synchronous writing to disk.  The test I'm running writes 2000 blocks of
> >> contiguous data to a raw device, using O_DIRECT and various block sizes
> >> down to a minimum of 512 bytes.  
> >>
> >> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
> >> using ata_piix.  Write caching has been explicitly disabled on the
> >> drive, and there is no other activity that should affect the test
> >> results (all system filesystems are on a separate drive).  The system is
> >> running Debian etch, with a 2.6.24 kernel.
> >>
> >> Observed results:
> >>
> >> size=1024, N=2000, took=4.450788 s, thput=3 mb/s seekc=1
> >> write: avg=8.388851 max=24.998846 min=8.335624 ms
> >> 8 ms: 1992 cases
> >> 9 ms: 2 cases
> >> 10 ms: 1 cases
> >> 14 ms: 1 cases
> >> 16 ms: 3 cases
> >> 24 ms: 1 cases
> > 
> > stoopid question 1: are you writing to a regular file, or to /dev/sda?  If
> > the former then metadata fetches will introduce glitches.
> 
> Not a file, just a raw device.
> 
> > stoopid question 2: does the same effect happen with reads?
> 
> Dunno. The read is not critical for us. However, I would expect the same 
> behaviour (see below).
> 
> We've got a satisfying explansation of the behaviour from Roger Heflin:
> 
> "You write sector n and n+1, it takes some amount of time for that first 
> set of sectors to come under the head, when it does you write it and 
> immediately return.   Immediately after that you attempt write sector 
> n+2 and n+3 which just a bit ago passed under the head, so you have to 
> wait an *ENTIRE* revolution for those sectors to again come under the 
> head to be written, another ~8.3ms, and you continue to repeat this with 
> each block being written.   If the sector was randomly placed in the 
> rotation (ie 50% chance of the disk being off by 1/2 a rotation or 
> less-you would have a 4.15 ms average seek time for your test)-but the 
> case of sequential sync writes this leaves the sector about as far as 
> possible from the head (it just passed under the head)."
> 
> Now, the obvious solution was to use AIO to be able to enqueue write 
> requests even before the head reaches the end of the sector - thus there 
> would be no need for superfluous disk revolvings.
> 
> We've actually measured this scenario with kernel AIO (libaio1) and this 
> is what we'vew got (see attached graph).
> 
> The x axis represents individual write operations, y axis represents 
> time. Crosses are operations enqueue times (when write requests were 
> issues), circles are times of notifications (when the app was notified 
> that the write request was processed).
> 
> What we see is that AIO performs rather bad while we are still 
> enqueueing more writes (it misses right position on the disk and has to 
> do superfluous disk revolvings), however, once we stop enqueueing new 
> write request, those already in the queue are processed swiftly.
> 
> My guess (I am not a kernel hacker) would be that sync operations on the 
> AIO queue are slowing down the retrieval from the queue and thus we miss 
> the right place on the disk almost all the time. Once app stops 
> enqueueing new write requests there's no contention on the queue and we 
> are able to catch up with the speed of disk rotation.
> 
> If this is the case, the solution would be straightforward: When 
> dequeueing from AIO queue, dequeue *all* the requests in the queue and 
> place them into another non-synchronised queue. Getting an element from 
> a non-sync queue is matter of few nanoseconds, thus we should be able to 
> process it before head missis the right point on the disk. Once the 
> non-sync queue is empty, we get *all* the requests from the AIO queue 
> again. Etc.
> 
> Anyone any opinion on this matter?

Not immediately, but the fine folks on the linux-aio list might be able to
help out.  If you have some simple testcase code which you can share then
that would help things along.  
