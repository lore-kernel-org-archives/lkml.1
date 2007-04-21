Return-Path: <linux-kernel-owner+w=401wt.eu-S1030805AbXDUMlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbXDUMlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030864AbXDUMlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:41:47 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:45684 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030805AbXDUMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:41:46 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sat, 21 Apr 2007 22:40:18 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
In-Reply-To: <20070421121235.GA2044@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212240.19139.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 22:12, Willy Tarreau wrote:
> Hi Ingo, Hi Con,
>
> I promised to perform some tests on your code. I'm short in time right now,
> but I observed behaviours that should be commented on.
>
> 1) machine : dual athlon 1533 MHz, 1G RAM, kernel 2.6.21-rc7 + either
> scheduler Test:  ./ocbench -R 250000 -S 750000 -x 8 -y 8
>    ocbench: http://linux.1wt.eu/sched/
>
> 2) SD-0.44
>
>    Feels good, but becomes jerky at moderately high loads. I've started
>    64 ocbench with a 250 ms busy loop and 750 ms sleep time. The system
>    always responds correctly but under X, mouse jumps quite a bit and
>    typing in xterm or even text console feels slightly jerky. The CPU is
>    not completely used, and the load varies a lot (see below). However,
>    the load is shared equally between all 64 ocbench, and they do not
>    deviate even after 4000 iterations. X uses less than 1% CPU during
>    those tests.
>
>    Here's the vmstat output :
[snip]

> 3) CFS-v4
>
>   Feels even better, mouse movements are very smooth even under high load.
>   I noticed that X gets reniced to -19 with this scheduler. I've not looked
>   at the code yet but this looked suspicious to me. I've reniced it to 0
> and it did not change any behaviour. Still very good. The 64 ocbench share
> equal CPU time and show exact same progress after 2000 iterations. The CPU
> load is more smoothly spread according to vmstat, and there's no idle (see
> below). BUT I now think it was wrong to let new processes start with no
> timeslice at all, because it can take tens of seconds to start a new
> process when only 64 ocbench are there. Simply starting "killall ocbench"
> takes about 10 seconds. On a smaller machine (VIA C3-533), it took me more
> than one minute to do "su -", even from console, so that's not X. BTW, X
> uses less than 1% CPU during those tests.
>
> willy@pcw:~$ vmstat 1
[snip]

> 4) first impressions
>
> I think that CFS is based on a more promising concept but is less mature
> and is dangerous right now with certain workloads. SD shows some strange
> behaviours like not using all CPU available and a little jerkyness, but is
> more robust and may be the less risky solution for a first step towards
> a better scheduler in mainline, but it may also probably be the last O(1)
> scheduler, which may be replaced sometime later when CFS (or any other one)
> shows at the same time the smoothness of CFS and the robustness of SD.

I assumed from your description that you were running X nice 0 during all this 
testing and left the tunables from both SD and CFS at their defaults; this 
tends to have the effective equivalent of "timeslice" in CFS smaller than SD.

> I'm sorry not to spend more time on them right now, I hope that other
> people will do.

Thanks for that interesting testing you've done. The fluctuating cpu load and 
the apparently high idle time means there is almost certainly a bug still in 
the cpu accounting I do in update_cpu_clock. It looks suspicious to me 
already on just my first glance. Fortunately the throughput does not appear 
to be adversely affected on other benchmarks so I suspect it's lying about 
the idle time and it's not really there. Which means it's likely also 
accounting the cpu time wrongly. Which also means there's something I can fix 
and improve SD further. Great stuff, thanks! 

-- 
-ck
