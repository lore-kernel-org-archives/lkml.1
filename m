Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZADDfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZADDfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZADDfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:35:21 -0500
Received: from ozlabs.org ([203.10.76.45]:39379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZADDfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:35:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] cpus4096 tree, part 3
Date: Sun, 4 Jan 2009 14:05:14 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
References: <200901011149.18401.rusty@rustcorp.com.au> <20090103203621.GA2491@elte.hu> <alpine.LFD.2.00.0901031244090.3179@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901031244090.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041405.15096.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 07:26:03 Linus Torvalds wrote:
> 
> On Sat, 3 Jan 2009, Ingo Molnar wrote:
> > 
> > > Has anybody looked at what the stack size is with MAXSMP set with an 
> > > allyesconfig? And what areas are still problematic, if any? Are we going 
> > > to have some code-paths that still essentially have 1kB+ of stack space 
> > > just because they haven't been converted and still have the cpu mask on 
> > > stack?
> > 
> > ok, indeed testing of that is in order now.
> 
> Well, since I can compile a allyesconfig pretty quickly, I did the static 
> part. It looks better than it used to, and I think most of the huge stacks 
> are totally unrealted to cpu masks. But not all.
> 
> But it looks like we have a few:
> 
>  - flush_tlb_current_task:
> 	cpumask_t cpu_mask;
>  - flush_tlb_mm:
> 	cpumask_t cpu_mask;
...
>  - acpi_cpufreq_target:
> 	cpumask_t online_policy_cpus

Mike?  These are x86-specific...

>  - local_cpus_show:
> 	cpumask_t mask;
>  - local_cpulist_show:
> 	cpumask_t mask;

Yes, this removal is still in my queue.  I'll double-check that all the
archs have the new "cpumask_of_pcibus". (cpumask:replace-and-remove-pcibus_to_cpumask.patch "cpumask: remove the now-obsoleted pcibus_to_cpumask()").

> and then we have a number of things that have "struct cpufreq_policy" on 
> the stack, and those things have two cpumask_t's in each.

Yep, we have the conversion for that too.  Mike, it's cpumask:convert-drivers_acpi.patch "cpumask: convert struct cpufreq_policy to cpumask_var_t."

> The rest of the high-stack-usage cases - from a _very_ quick look - seem 
> to be unrelated to CPU masks, but in the "more than 1kB of stack" group 
> about a third (wild handwaving eyeballing) of them do seem to be related 
> to cpumask.

Mike was tracking this; I think he has a script to set NR_CPUS small then
large and dump the changes.

Cheers,
Rusty.
