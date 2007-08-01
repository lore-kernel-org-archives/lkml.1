Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbXHAAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbXHAAVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbXHAAVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:21:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:52845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbXHAAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:21:15 -0400
Date: Wed, 1 Aug 2007 02:21:14 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070801002114.GB31006@wotan.suse.de>
References: <20070731054142.GB11306@wotan.suse.de> <20070731080114.GA12367@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731080114.GA12367@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 10:01:14AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > This patch uses memory policies to attempt to improve this. It 
> > requires that we ask the scheduler to suggest the child's new CPU 
> > earlier in the fork, but that is not a fundamental difference.
> 
> no fundamental objections, but i think we could simply move sched_fork() 
> to the following place:
> 
> > @@ -989,10 +990,13 @@ static struct task_struct *copy_process(
> >  	if (retval)
> >  		goto fork_out;
> >  
> > +	cpu = sched_fork_suggest_cpu(clone_flags);
> > +	mpol_arg = mpol_prefer_cpu_start(cpu);
> > +
> >  	retval = -ENOMEM;
> >  	p = dup_task_struct(current);
> >  	if (!p)
> > -		goto fork_out;
> > +		goto fork_mpol;
> >  
> >  	rt_mutex_init_task(p);
> 
> 
> _after_ the dup_task_struct(). Then change sched_fork() to return a CPU 
> number - hence we dont have a separate sched_fork_suggest_cpu() 
> initialization function, only one, obvious sched_fork() function. 
> Agreed?

That puts task struct, kernel stack, thread info on the wrong node.

