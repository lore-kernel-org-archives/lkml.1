Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZHSWGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZHSWGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZHSWGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:06:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34412 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZHSWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:06:39 -0400
Date: Thu, 20 Aug 2009 00:06:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
Message-ID: <20090819220640.GW12579@kernel.dk>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com> <1250708742.5589.23.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250708742.5589.23.camel@cail>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19 2009, Alan D. Brunelle wrote:
> Hi Jens - 
> 
> I'm not using loop, but it appears that there may be a regression in
> regular asynchronous direct I/O sequential write performance when these
> patches are applied. Using my "small" machine (16-way x86_64, 256GB, two
> dual-port 4GB FC HBAs connected through switches to 4 HP MSA1000s - one
> MSA per port), I'm seeing a small but noticeable drop in performance for
> sequential writes on the order of 2 to 6%. Random asynchronous direct
> I/O and sequential reads appear to unaffected.
> 
> http://free.linux.hp.com/~adb/2009-08-19/nc.png
> 
> has a set of graphs showing the data obtained when utilizing LUNs
> exported by the MSAs (increasing the number of MSAs being used along the
> X-axis). The critical sequential write graph has numbers like (numbers
> expressed in GB/second):
> 
> Kernel                    1MSA  2MSAs 3MSAs 4MSAs
> ------------------------  ----- ----- ----- -----
> 2.6.31-rc6              :  0.17  0.33  0.50  0.65 
> 2.6.31-rc6 + loop-direct:  0.15  0.31  0.46  0.61
> 
> Using all 4 devices we're seeing a drop of slightly over 6%. 
> 
> I also typically do runs utilizing just the caches on the MSAs (getting
> rid of physical disk interactions (seeks &c).). Even here we see a small
> drop off in sequential write performance (on the order of about 2.5%
> when using all 4 MSAs)- but noticeable gains for both random reads and
> (especially) random writes. That graph can be seen at:
> 
> http://free.linux.hp.com/~adb/2009-08-19/ca.png
> 
> BTW: The grace/xmgrace files that generated these can be found at - 
> 
> http://free.linux.hp.com/~adb/2009-08-19/nc.agr
> http://free.linux.hp.com/~adb/2009-08-19/ca.agr
> 
> - as the specifics can be seen better whilst running xmgrace on those
> files.

Thanks a lot for the test run, Alan. I wonder why writes are down while
reads are up. One possibility could be a WRITE vs WRITE_ODIRECT
difference, though I think they should be the same. The patches I posted
have not been benchmarked at all, it's still very much a work in
progress. I just wanted to show the general direction that I thought
would be interesting. So I have done absolutely zero performance
testing, it's only been tested for whether it still worked or not (to
some degree :-)...

I'll poke a bit at it here, too. I want to finish the unplug/wait
problem first. Is your test case using read/write or readv/writev?

-- 
Jens Axboe

