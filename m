Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZDEOUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZDEOUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZDEOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:20:41 -0400
Received: from tichy.grunau.be ([85.131.189.73]:48322 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZDEOUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:20:40 -0400
Date: Sun, 5 Apr 2009 16:20:13 +0200
From: Janne Grunau <j@jannau.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Rees <drees76@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090405142013.GB10556@aniel>
References: <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org> <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com> <49D69C1D.50209@garzik.org> <20090404162954.GA5170@aniel> <49D7E71B.2080301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D7E71B.2080301@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 07:02:51PM -0400, Jeff Garzik wrote:
> Janne Grunau wrote:
> > 
> > Jeff, could you please try following patch for 0.21 or update to the
> > latest trunk revision. I don't have a way to reproduce the high
> > latencies with fdatasync on ext3, data=ordered. Doing a parallel
> > "dd if=/dev/zero of=file" on the same partition introduces even with
> > sync_file_range latencies over 1 second.
> 
> Is dd + sync_file_range really a realistic comparison?  dd is streaming 
> as fast as the disk can output data, whereas MythTV is streaming as fast 
> as video is being recorded.  If you are maxing out your disk throughput, 
> there will be obvious impact no matter what.

sure, I tried simulating a case where the fsync/fdatasync from mythtv
impose high latencies on other processes due to syncing other big writes
too.

> I would think a more accurate comparison would be recording multiple 
> video streams in parallel, comparing fsync/fdatasync/sync_file_range?

I tested 3 simultaneous recordings and haven't noticed a difference. I'm
even sure if I should. With multiple recording at the same time mythtv
would also call fdatasync multiple times per second.

I guess I could compare how long fdatasync and sync_file_range with
SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE |
SYNC_FILE_RANGE_WAIT_AFTER are blocking. Not that mythtv would care
since they are called in it's own thread.

> IOW, what is an average MythTV setup -- what processes are actively 
> reading/writing storage?

writing:
mythbackend - recordings and preview images (2-20mbps)

reading:
mythfrontend - viewing (2-20mbps)
mythcommflag - faster than viewing, maybe up to 50mbps (depending on cpu)

writing+reading:
mythtranscode - combined rate less than 50mbps, usually more reads than
                writes (depending on cpu)
mythtranscode (lossless) - around maximal disk throughput

> Where are you noticing latencies, and does 
> sync_file_range decrease those areas of high latency?

I don't notice latencies in mythtv, at least no for which file systems
or the block layer can be blamed for. But my setup is build to avoid
these. Mythtv records to it's own disks formatted with xfs. Mythtv
generally tries to spread simultaneous recodings over different file
systems. The tests were on a different system though.

Janne
