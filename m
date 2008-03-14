Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYCNMX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYCNMX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYCNMXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:23:46 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32780 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYCNMXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:23:46 -0400
Message-ID: <47DA6E4C.2000803@hp.com>
Date: Fri, 14 Mar 2008 08:23:40 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       npiggin@suse.de, dgc@sgi.com
Subject: Re: IO CPU affinity test results
References: <47DA6C1E.8010000@hp.com>
In-Reply-To: <47DA6C1E.8010000@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> Good morning Jens -
>
> I had two machines running the latest patches hang last night:
>
> o  2-way AMD64 - I inadvertently left the patched kernel running, and I was moving a ton of data (100+GB) back up over the net to this node. It hard hung (believe it or not) about 99% of the way through. Hard hang, wouldn't respond to anything.
>
> o  4-way IA64 - I was performing a simple test: [mkfs / mount / untar linux sources / make allnoconfig / make -j 5 / umount] repeatedly switching rq_affinity to 0/1 between each run. After 22 passes it had a hard hang with rq_affinity set to 1.
>
> Of course, there is no way of knowing if either hang had anything to do with the patches, but it seems a bit ominous as RQ=1 was set in both cases.
>
> This same test worked fine for 30 passes on a 2-way AMD64 box, with the following results:
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
> All results are in seconds (as measured by Python's time.time()), except for the psys - which was the average of mpstat's %sys column over the life of the whole run. The mkfs part consisted of [mkfs -t ext2 ; sync ; sync], untar [mount; untar linux sources; umount; sync; sync], make [mount; make allnoconfig; make -j 3; umount; sync; sync], and comb is the combined times of the mkfs, untar and make parts.
>
> So, in a nutshell, we saw slightly better overall performance, but not conclusively, and we saw slightly elevated %system time to accomplish the task.
>
> On the 4-way, results were much worse: the final data shown before the system hung showed the rq=1 passes taking significantly longer, albeit at lower %system. I'm going to try the runs again, but I have a feeling that the latest "clean" patch based upon Nick's single call mechanism is a step backwards.
>
> Alan

I was able to go back and capture the results after 17 passes on the 4-way IA64 box (before it hung), and with rq=1 it shows a huge increase in time needed to do the combined tests - almost 18% longer, however with a reduction of about 24% less system time.

Part  RQ   MIN     AVG     MAX      Dev
----- --  ------  ------  ------  ------
 mkfs  0  18.543  19.055  19.514   0.285
 mkfs  1  18.730  19.217  19.812   0.316

untar  0  17.119  21.396  43.868   8.025
untar  1  16.987  28.155  44.637  10.175

 make  0  23.105  23.866  24.487   0.359
 make  1  24.015  28.384  37.829   3.598

 comb  0  59.610  64.317  86.733   7.896
 comb  1  63.181  75.755  94.079  10.489

 psys  0  10.35%  14.16%  16.28%   1.375
 psys  1   6.89%  10.73%  14.30%   2.368

I'll try to snag some profile data to see what's up.

Alan
PS. Besides the AMD64/IA64 architectural difference, the underlying storage was different as well: U320 on the AMD64 and FC on the IA64, I don't know if that has anything to do with the different results seen on the two hosts.
