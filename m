Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZIFNRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZIFNRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 09:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbZIFNRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 09:17:49 -0400
Received: from ms01.sssup.it ([193.205.80.99]:32806 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757732AbZIFNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 09:17:49 -0400
Date: Sun, 6 Sep 2009 15:21:04 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Anirban Sinha <ani@anirban.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, Anirban Sinha <ASinha@zeugmasystems.com>,
       Dario Faggioli <raistlin@linux.it>
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Message-ID: <20090906132104.GK14492@gandalf.sssup.it>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local> <20090905204037.GE4953@gandalf.sssup.it> <DDFD17CC94A9BD49A82147DDF7D545C54DC481@exchange.ZeugmaSystems.local> <D0B95E79-EDEC-487A-B8AB-0D90E4E81A9E@anirban.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0B95E79-EDEC-487A-B8AB-0D90E4E81A9E@anirban.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Anirban Sinha <ani@anirban.org>
> Date: Sat, Sep 05, 2009 05:47:39PM -0700
>
> > You say you pin the threads to a single core: how many cores does  
> your
> > system have?
> 
> The results I sent you were on a dual core blade.
> 
> 
> > If this is the case, this behavior is the expected one, the scheduler
> > tries to reduce the number of migrations, concentrating the bandwidth
> > of rt tasks on a single core.  With your workload it doesn't work  
> well
> > because runtime migration has freed the other core(s) from rt  
> bandwidth,
> > so these cores are available to SCHED_OTHER ones, but your  
> SCHED_OTHER
> > thread is pinned and cannot make use of them.
> 
> But, I ran the same routine on a quadcore blade and the results this  
> time were:
> 
> rt_runtime/rt_period  % of iterations of reg thrd against rt thrd
> 
> 0.20                  46%
> 0.25                  18%
> 0.26                  7%
> 0.3                   0%
> 0.4                   0%
> (rest of the cases)   0%
> 
> So if the scheduler is concentrating all rt bandwidth to one core, it  
> should be effectively 0.2 * 4 = 0.8 for this core. Hence,  we should  
> see the percentage closer to 20% but it seems that it's more than  
> double. At ~0.25, the regular thread should make no progress, but it  
> seems it does make a little progress.

So this can be a bug.  While it is possible that the kernel does
not succeed in migrating all the runtime (e.g., due to a (system) rt
task consuming some bandwidth on a remote cpu), 46% instead of 20%
is too much.

Running your program I'm unable to reproduce the same issue on a recent
kernel here; for 25ms over 100ms across several runs I get less than 2%.
This number increases, reaching your values, only when using short
periods (where the meaning for short depends on your HZ value), which
is something to be expected, due to the fact that rt throttling uses
the tick to charge runtimes to tasks.

Looking at the git history, there have been several bugfixes to the rt
bandwidth code from 2.6.26, one of them seems to be strictly related to
runtime accounting with your setup:

    commit f6121f4f8708195e88cbdf8dd8d171b226b3f858
    Author: Dario Faggioli <raistlin@linux.it>
    Date:   Fri Oct 3 17:40:46 2008 +0200
    
        sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq
