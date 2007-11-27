Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXK0XVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXK0XVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXK0XVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:21:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755553AbXK0XVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:21:43 -0500
Date: Tue, 27 Nov 2007 15:21:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: andi@firstfloor.org, travis@sgi.com, ak@suse.de, clameter@sgi.com,
       pageexec@freemail.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
Message-Id: <20071127152122.1d5fbce3.akpm@linux-foundation.org>
In-Reply-To: <20071127151241.038c146d.akpm@linux-foundation.org>
References: <20071127215052.090968000@sgi.com>
	<20071127215054.660250000@sgi.com>
	<20071127221628.GG24223@one.firstfloor.org>
	<20071127151241.038c146d.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 15:12:41 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 27 Nov 2007 23:16:28 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Tue, Nov 27, 2007 at 01:50:53PM -0800, travis@sgi.com wrote:
> > > Change loops controlled by 'for (i = 0; i < NR_CPUS; i++)' to use
> > > 'for_each_possible_cpu(i)' when there's a _remote possibility_ of
> > > dereferencing a non-allocated per_cpu variable involved.
> > > 
> > > All files except mm/vmstat.c are x86 arch.
> > > 
> > > Based on 2.6.24-rc3-mm1 .
> > > 
> > > Thanks to pageexec@freemail.hu for pointing this out.
> > 
> > Looks good to me. 2.6.24 candidate.
> 
> hm.  Has anyone any evidence that we're actually touching
> not-possible-cpu's memory here?
> 
> Also, the sum_vm_events() change looks buggy - it assumes that
> cpu_possible_map has no gaps in it.  But that change is unneeded because
> sum_vm_events() is only ever passed cpu_online_map and I'm hoping that we
> don't usually online not-possible CPUs.
> 
> --- a/mm/vmstat.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix
> +++ a/mm/vmstat.c
> @@ -27,12 +27,12 @@ static void sum_vm_events(unsigned long 
>  	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
>  
>  	cpu = first_cpu(*cpumask);
> -	while (cpu < NR_CPUS && cpu_possible(cpu)) {
> +	while (cpu < NR_CPUS) {
>  		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
>  
>  		cpu = next_cpu(cpu, *cpumask);
>  
> -		if (cpu < NR_CPUS && cpu_possible(cpu))
> +		if (cpu < NR_CPUS)
>  			prefetch(&per_cpu(vm_event_states, cpu));

The prefetch however might still need some work - we can indeed do
prefetch() against a not-possible CPU's memory here.  And I do recall that
4-5 years ago we did have a CPU (one of mine, iirc) which would oops when
prefetching from a bad address.  I forget what the conclusion was on that
matter.

If we do want to fix the prefetch-from-outer-space then we should be using
cpu_isset(cpu, *cpumask) here rather than cpu_possible().

