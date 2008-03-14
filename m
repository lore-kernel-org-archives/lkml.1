Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYCNMgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYCNMgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCNMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:36:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18209 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYCNMgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:36:10 -0400
Date: Fri, 14 Mar 2008 13:36:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: IO CPU affinity test results
Message-ID: <20080314123606.GL17940@kernel.dk>
References: <47DA6C1E.8010000@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA6C1E.8010000@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14 2008, Alan D. Brunelle wrote:
> Good morning Jens - 
> 
> I had two machines running the latest patches hang last night: 
> 
> o  2-way AMD64 - I inadvertently left the patched kernel running, and
> I was moving a ton of data (100+GB) back up over the net to this node.
> It hard hung (believe it or not) about 99% of the way through. Hard
> hang, wouldn't respond to anything.
> 
> o  4-way IA64 - I was performing a simple test: [mkfs / mount / untar
> linux sources / make allnoconfig / make -j 5 / umount] repeatedly
> switching rq_affinity to 0/1 between each run. After 22 passes it had
> a hard hang with rq_affinity set to 1.
> 
> Of course, there is no way of knowing if either hang had anything to
> do with the patches, but it seems a bit ominous as RQ=1 was set in
> both cases.
> 
> This same test worked fine for 30 passes on a 2-way AMD64 box, with
> the following results:
> 
> Part  RQ   MIN     AVG     MAX      Dev
> ----- --  ------  ------  ------  ------
>  mkfs  0  41.656  41.862  42.086   0.141
>  mkfs  1  41.618  41.909  42.270   0.192
> 
> untar  0  18.055  19.611  20.906   0.720
> untar  1  18.523  19.905  21.988   0.738
> 
>  make  0  50.480  50.991  51.752   0.340
>  make  1  49.819  50.442  51.000   0.292
> 
>  comb  0 110.433 112.464 114.176   0.932
>  comb  1 110.694 112.256 114.683   0.948
> 
>  psys  0  10.28%  10.91%  11.29%   0.243
>  psys  1  10.21%  11.05%  11.80%   0.350
> 
> 
> All results are in seconds (as measured by Python's time.time()),
> except for the psys - which was the average of mpstat's %sys column
> over the life of the whole run. The mkfs part consisted of [mkfs -t
> ext2 ; sync ; sync], untar [mount; untar linux sources; umount; sync;
> sync], make [mount; make allnoconfig; make -j 3; umount; sync; sync],
> and comb is the combined times of the mkfs, untar and make parts. 
> 
> So, in a nutshell, we saw slightly better overall performance, but not
> conclusively, and we saw slightly elevated %system time to accomplish
> the task. 

I think that is encouraging, for such a small setup. The make results
are particularly nice. The hangs are a bother, I have no good ideas on
why the occur. The fact that it happens on both archs indicates that
this is perhaps a generic problem, which is good. The code to support
this is relatively simple, so it should be possible to go over it with a
fine toothed comb and see if anything shows up.

You didn't get any watchdog triggers on the serial console, or anything
like that?

> On the 4-way, results were much worse: the final data shown before the
> system hung showed the rq=1 passes taking significantly longer, albeit
> at lower %system. I'm going to try the runs again, but I have a
> feeling that the latest "clean" patch based upon Nick's single call
> mechanism is a step backwards.

As to the hangs, yes it's definitely a step back. Cleanliness of code is
better though and it's something we can support, so I'm inclined to try
and make it work. The overhead of the cleaner approach should not be a
problem, it'll be a bit more costly than the ipi hack but not a lot.
Since the tuning and tweaks, we got rid of the allocations in the path,
so it should be about as fast as the original.

So once the base is stable, we can go and profile and squeeze some more
performance out of it :-)

-- 
Jens Axboe

