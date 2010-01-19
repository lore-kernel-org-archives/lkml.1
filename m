Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811Ab0ASJLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0ASJLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629Ab0ASJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:11:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab0ASJLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:11:46 -0500
Message-ID: <4B5576D8.90804@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 17:09:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: fix race in	perf_swevent_get_recursion_context()
References: <4B54654A.4090601@cn.fujitsu.com> <20100118164128.GI10364@nowhere> <4B5508AF.1080302@cn.fujitsu.com> <20100119085811.GA5145@nowhere>
In-Reply-To: <20100119085811.GA5145@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:

> 
> I still don't understand the problem.
> 
> It's not like a fight between different cpus, it's a local per cpu
> fight.
> 
> NMIs can't nest other NMIs but hardirq can nest another hardirqs,
> we don't care much about these though.
> So let's imagine the following sequence, a fight between nested
> hardirqs:
> 
> cpuctx->recursion[irq] initially = 0
> 
> Interrupt (level 0):
> 
>        if (cpuctx->recursion[rctx]) {
>                put_cpu_var(perf_cpu_context);
>                return -1;
>        }
> 
> Interrupt (level 1):
> 
> 
> 	cpuctx->recursion[rctx]++; // = 1
> 
> 	...
> 	do something
> 	...
> 	cpuctx->recursion[rctx]--; // = 0
> 
> End Interrupt (level 1)
> 
> 	cpuctx->recursion[rctx]++; // = 1
> 
>         ...
>         do something
>         ...
>         cpuctx->recursion[rctx]--; // = 0
> 
> End interrupt (level 0)
> 
> Another sequence could be Interrupt level 0 has
> already incremented recursion and we are interrupted by
> irq level 1 which then won't be able to get the recursion
> context. But that's not a big deal I think.
> 

Thanks Frederic, i forget this feature of nesting of hard-irq :-(

Sorry for disturb you all

- Xiao
