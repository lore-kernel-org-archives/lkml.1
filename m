Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbZIJRx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbZIJRx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZIJRx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:53:56 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:52905 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZIJRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:53:55 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net A814E2571FF
Message-ID: <4AA93D34.8040500@arcor.de>
Date: Thu, 10 Sep 2009 20:53:56 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu>
In-Reply-To: <20090910060824.GF1335@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 09:08 AM, Ingo Molnar wrote:
>
> * Nikos Chantziaras<realnc@arcor.de>  wrote:
>>
>> With your version of latt.c, I get these results with 2.6-tip vs
>> 2.6.31-rc9-bfs:
>>
>>
>> (mainline)
>> Averages:
>> ------------------------------
>>          Max            50 usec
>>          Avg            12 usec
>>          Stdev           3 usec
>>
>>
>> (BFS)
>> Averages:
>> ------------------------------
>>          Max           474 usec
>>          Avg            11 usec
>>          Stdev          16 usec
>>
>> However, the interactivity problems still remain.  Does that mean
>> it's not a latency issue?
>
> It means that Jens's test-app, which demonstrated and helped us fix
> the issue for him does not help us fix it for you just yet.
>
> The "fluidity problem" you described might not be a classic latency
> issue per se (which latt.c measures), but a timeslicing / CPU time
> distribution problem.
>
> A slight shift in CPU time allocation can change the flow of tasks
> to result in a 'choppier' system.
>
> Have you tried, in addition of the granularity tweaks you've done,
> to renice mplayer either up or down? (or compiz and Xorg for that
> matter)

Yes.  It seems to do what one would expect, but only if two separate 
programs are competing for CPU time continuously.  For example, when 
running two glxgears instances, one with nice 0 the other with 19, the 
first will report ~5000 FPS, the other ~1000.  Renicing the second one 
from 19 to 0, will result in both reporting ~3000.  So nice values 
obviously work in distributing CPU time.  But the problem isn't the 
available CPU time it seems since even if running glxgears nice -20, it 
will still freeze during various other interactive taks (moving windows 
etc.)


> [...]
>    # echo NO_NEW_FAIR_SLEEPERS>  /debug/sched_features
>
> Btw., NO_NEW_FAIR_SLEEPERS is something that will turn the scheduler
> into a more classic fair scheduler (like BFS is too).

Setting NO_NEW_FAIR_SLEEPERS (with everything else at default values) 
pretty much solves all issues I raised in all my other posts!  With this 
setting, I can do "nice -n 19 make -j20" and still have a very smooth 
desktop and watch a movie at the same time.  Various other annoyances 
(like the "logout/shutdown/restart" dialog of KDE not appearing at all 
until the background fade-out effect has finished) are also gone.  So 
this seems to be the single most important setting that vastly improves 
desktop behavior, at least here.

In fact, I liked this setting so much that I went to 
kernel/sched_features.h of kernel 2.6.30.5 (the kernel I use normally 
right now) and set SCHED_FEAT(NEW_FAIR_SLEEPERS, 0) (default is 1) with 
absolutely no other tweaks (like sched_latency_ns, 
sched_wakeup_granularity_ns, etc.).  It pretty much behaves like BFS now 
from an interactivity point of view.  But I've used it only for about an 
hour or so, so I don't know if any ill effects will appear later on.


> NO_START_DEBIT might be another thing that improves (or worsens :-/)
> make -j type of kernel build workloads.

No effect with this one, at least not one I could observe.

I didn't have the opportunity yet to test and tweak all the other 
various settings you listed, but I will try to do so as soon as possible.
