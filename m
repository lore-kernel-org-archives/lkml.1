Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZIILwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZIILwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZIILwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:52:04 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:49037 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbZIILwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:52:02 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 7858B39A991
Message-ID: <4AA796E2.405@arcor.de>
Date: Wed, 09 Sep 2009 14:52:02 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu>	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>	 <20090907204458.GJ18599@kernel.dk>  <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins>
In-Reply-To: <1252423398.7746.97.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 06:23 PM, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
>> And here's a newer version.
>
> I tinkered a bit with your proglet and finally found the problem.
>
> You used a single pipe per child, this means the loop in run_child()
> would consume what it just wrote out until it got force preempted by the
> parent which would also get woken.
>
> This results in the child spinning a while (its full quota) and only
> reporting the last timestamp to the parent.
>
> Since consumer (parent) is a single thread the program basically
> measures the worst delay in a thundering herd wakeup of N children.
>
> The below version yields:
>
> idle
>
> [root@opteron sched]# ./latt -c8 sleep 30
> Entries: 664 (clients=8)
>
> Averages:
> ------------------------------
>          Max           128 usec
>          Avg            26 usec
>          Stdev          16 usec
>
>
> make -j4
>
> [root@opteron sched]# ./latt -c8 sleep 30
> Entries: 648 (clients=8)
>
> Averages:
> ------------------------------
>          Max         20861 usec
>          Avg          3763 usec
>          Stdev        4637 usec
>
>
> Mike's patch, make -j4
>
> [root@opteron sched]# ./latt -c8 sleep 30
> Entries: 648 (clients=8)
>
> Averages:
> ------------------------------
>          Max         17854 usec
>          Avg          6298 usec
>          Stdev        4735 usec

I've run two tests with this tool.  One with mainline (2.6.31-rc9) and 
one patched with 2.6.31-rc9-sched-bfs-210.patch.

Before running this test, I disabled the cron daemon in order not to 
have something pop-up in the background out of a sudden.

The test consisted of starting a "make -j2" in the kernel tree inside a 
3GB tmpfs mountpoint and then running 'latt "mplayer -vo gl2 -framedrop 
videofile.mkv"'  (mplayer in this case is a single-threaded 
application.)  Caches were warmed-up first; the results below are from 
the second run of each test.

The kernel .config file used by the running kernels and also for "make 
-j2" is:

   http://foss.math.aegean.gr/~realnc/kernel/config-2.6.31-rc9-latt-test

The video file used for mplayer is:

   http://foss.math.aegean.gr/~realnc/vids/3DMark2000.mkv (100MB)
   (The reason this was used is that it's a 60FPS video,
   therefore very smooth and makes all skips stand out
   clearly.)


Results for mainline:

   Averages:
   ------------------------------
           Max         29930 usec
           Avg         11043 usec
           Stdev        5752 usec


Results for BFS:

   Averages:
   ------------------------------
           Max         14017 usec
           Avg            49 usec
           Stdev         697 usec


One thing that's worth noting is that with mainline, mplayer would 
occasionally spit this out:

    YOUR SYSTEM IS TOO SLOW TO PLAY THIS

which doesn't happen with BFS.
