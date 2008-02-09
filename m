Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYBIBwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYBIBwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYBIBvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:51:52 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57359 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYBIBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:51:51 -0500
Date: Fri, 08 Feb 2008 19:49:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
 threads
In-reply-to: <fa.6N2dhyJ1cmBqiuFKgCaYfwduM+0@ifi.uio.no>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Message-id: <47AD06BD.7040702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6N2dhyJ1cmBqiuFKgCaYfwduM+0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Hi,
> 
> I ended up with a customer benchmark in my lap this week that doesn't
> do well on recent kernels. :(
> 
> After cutting it down to a simple testcase/microbenchmark, it seems like
> recent kernels don't do as well with short-lived threads competing
> with the thread it's cloned off of. The CFS scheduler changes come to
> mind, but I suppose it could be caused by something else as well.
> 
> The pared-down testcase is included below. Reported runtime for the
> testcase has increased almost 3x between 2.6.22 and 2.6.24:
> 
> 2.6.22: 3332 ms
> 2.6.23: 4397 ms
> 2.6.24: 8953 ms
> 2.6.24-git19: 8986 ms
> 
> While running, it'll fork off a bunch of threads, each doing just a little
> work, then busy-waiting on the original thread to finish as well. Yes,
> it's incredibly stupidly coded but that's not my point here.
> 
> During run, (runtime 10s on my 1.5GHz Core2 Duo laptop), vmstat 2  shows:
> 
>  0  0      0 115196 364748 2248396    0    0     0     0  163   89  0  0 100  0
>  2  0      0 115172 364748 2248396    0    0     0     0  270  178 24  0 76  0
>  2  0      0 115172 364748 2248396    0    0     0     0  402  283 52  0 48  0
>  2  0      0 115180 364748 2248396    0    0     0     0  402  281 50  0 50  0
>  2  0      0 115180 364764 2248396    0    0     0    22  403  295 51  0 48  1
>  2  0      0 115056 364764 2248396    0    0     0     0  399  280 52  0 48  0
>  0  0      0 115196 364764 2248396    0    0     0     0  241  141 17  0 83  0
>  0  0      0 115196 364768 2248396    0    0     0     2  155   67  0  0 100  0
>  0  0      0 115196 364768 2248396    0    0     0     0  148   62  0  0 100  0
> 
> I.e. runqueue is 2, but only one cpu is busy. However, this still seems
> true on the kernel that runs the testcase in more reasonable time.
> 
> Also, 'time' reports real and user time roughly the same on all kernels,
> so it's not that the older kernels are better at spreading out the load
> between the two cores (either that or it doesn't account for stuff right).
> 
> I've included the config files, runtime output and vmstat output at
> http://lixom.net/~olof/threadtest/. I see similar behaviour on PPC as
> well as x86, so it's not architecture-specific.
> 
> Testcase below. Yes, I know, there's a bunch of stuff that could be done
> differently and better, but it still doesn't motivate why there's a 3x
> slowdown between kernel versions...

I would say that something coded this bizarrely is really an application 
bug and not something that one could call a kernel regression. Any 
change in how the parent and child threads get scheduled will have a 
huge impact on this test. I bet if you replace that busy wait with a 
pthread_cond_wait or something similar, this problem goes away.

Hopefully it doesn't have to be pointed out that spawning off threads to 
do so little work before terminating is inefficient, a thread pool or 
even just a single thread would likely do a much better job..
