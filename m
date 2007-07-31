Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXGaIB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXGaIB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXGaIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:01:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXGaIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:01:20 -0400
Date: Tue, 31 Jul 2007 10:01:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070731080114.GA12367@elte.hu>
References: <20070731054142.GB11306@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731054142.GB11306@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> This patch uses memory policies to attempt to improve this. It 
> requires that we ask the scheduler to suggest the child's new CPU 
> earlier in the fork, but that is not a fundamental difference.

no fundamental objections, but i think we could simply move sched_fork() 
to the following place:

> @@ -989,10 +990,13 @@ static struct task_struct *copy_process(
>  	if (retval)
>  		goto fork_out;
>  
> +	cpu = sched_fork_suggest_cpu(clone_flags);
> +	mpol_arg = mpol_prefer_cpu_start(cpu);
> +
>  	retval = -ENOMEM;
>  	p = dup_task_struct(current);
>  	if (!p)
> -		goto fork_out;
> +		goto fork_mpol;
>  
>  	rt_mutex_init_task(p);


_after_ the dup_task_struct(). Then change sched_fork() to return a CPU 
number - hence we dont have a separate sched_fork_suggest_cpu() 
initialization function, only one, obvious sched_fork() function. 
Agreed?

	Ingo
