Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZIJSqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZIJSqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZIJSqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:46:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZIJSqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:46:05 -0400
Date: Thu, 10 Sep 2009 20:46:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910184601.GA15967@elte.hu>
References: <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu> <4AA93D34.8040500@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA93D34.8040500@arcor.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikos Chantziaras <realnc@arcor.de> wrote:

> On 09/10/2009 09:08 AM, Ingo Molnar wrote:
>>
>> * Nikos Chantziaras<realnc@arcor.de>  wrote:
>>>
>>> With your version of latt.c, I get these results with 2.6-tip vs
>>> 2.6.31-rc9-bfs:
>>>
>>>
>>> (mainline)
>>> Averages:
>>> ------------------------------
>>>          Max            50 usec
>>>          Avg            12 usec
>>>          Stdev           3 usec
>>>
>>>
>>> (BFS)
>>> Averages:
>>> ------------------------------
>>>          Max           474 usec
>>>          Avg            11 usec
>>>          Stdev          16 usec
>>>
>>> However, the interactivity problems still remain.  Does that mean
>>> it's not a latency issue?
>>
>> It means that Jens's test-app, which demonstrated and helped us fix
>> the issue for him does not help us fix it for you just yet.
>>
>> The "fluidity problem" you described might not be a classic latency
>> issue per se (which latt.c measures), but a timeslicing / CPU time
>> distribution problem.
>>
>> A slight shift in CPU time allocation can change the flow of tasks
>> to result in a 'choppier' system.
>>
>> Have you tried, in addition of the granularity tweaks you've done,
>> to renice mplayer either up or down? (or compiz and Xorg for that
>> matter)
>
> Yes.  It seems to do what one would expect, but only if two separate  
> programs are competing for CPU time continuously.  For example, when  
> running two glxgears instances, one with nice 0 the other with 19, the  
> first will report ~5000 FPS, the other ~1000.  Renicing the second one  
> from 19 to 0, will result in both reporting ~3000.  So nice values  
> obviously work in distributing CPU time.  But the problem isn't the  
> available CPU time it seems since even if running glxgears nice -20, it  
> will still freeze during various other interactive taks (moving windows  
> etc.)
>
>
>> [...]
>>    # echo NO_NEW_FAIR_SLEEPERS>  /debug/sched_features
>>
>> Btw., NO_NEW_FAIR_SLEEPERS is something that will turn the scheduler
>> into a more classic fair scheduler (like BFS is too).
>
> Setting NO_NEW_FAIR_SLEEPERS (with everything else at default 
> values) pretty much solves all issues I raised in all my other 
> posts!  With this setting, I can do "nice -n 19 make -j20" and 
> still have a very smooth desktop and watch a movie at the same 
> time.  Various other annoyances (like the 
> "logout/shutdown/restart" dialog of KDE not appearing at all until 
> the background fade-out effect has finished) are also gone.  So 
> this seems to be the single most important setting that vastly 
> improves desktop behavior, at least here.
>
> In fact, I liked this setting so much that I went to 
> kernel/sched_features.h of kernel 2.6.30.5 (the kernel I use 
> normally right now) and set SCHED_FEAT(NEW_FAIR_SLEEPERS, 0) 
> (default is 1) with absolutely no other tweaks (like 
> sched_latency_ns, sched_wakeup_granularity_ns, etc.).  It pretty 
> much behaves like BFS now from an interactivity point of view.  
> But I've used it only for about an hour or so, so I don't know if 
> any ill effects will appear later on.

ok, this is quite an important observation!

Either NEW_FAIR_SLEEPERS is broken, or if it works it's not what we 
want to do. Other measures in the scheduler protect us from fatal 
badness here, but all the finer wakeup behavior is out the window 
really.

Will check this. We'll probably start with a quick commit disabling 
it first - then re-enabling it if it's fixed (will Cc: you so that 
you can re-test with fixed-NEW_FAIR_SLEEPERS, if it's re-enabled).

Thanks a lot for the persistent testing!

	Ingo
