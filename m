Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbZACU4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbZACU4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbZACU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:56:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779AbZACU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:56:23 -0500
Date: Sat, 3 Jan 2009 12:56:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] cpus4096 tree, part 3
In-Reply-To: <20090103203621.GA2491@elte.hu>
Message-ID: <alpine.LFD.2.00.0901031244090.3179@localhost.localdomain>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu>
 <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain> <20090103203621.GA2491@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Ingo Molnar wrote:
> 
> > Has anybody looked at what the stack size is with MAXSMP set with an 
> > allyesconfig? And what areas are still problematic, if any? Are we going 
> > to have some code-paths that still essentially have 1kB+ of stack space 
> > just because they haven't been converted and still have the cpu mask on 
> > stack?
> 
> ok, indeed testing of that is in order now.

Well, since I can compile a allyesconfig pretty quickly, I did the static 
part. It looks better than it used to, and I think most of the huge stacks 
are totally unrealted to cpu masks. But not all.

But it looks like we have a few:

 - flush_tlb_current_task:
	cpumask_t cpu_mask;
 - flush_tlb_mm:
	cpumask_t cpu_mask;
 - local_cpus_show:
	cpumask_t mask;
 - local_cpulist_show:
	cpumask_t mask;
 - acpi_cpufreq_target:
	cpumask_t online_policy_cpus

and then we have a number of things that have "struct cpufreq_policy" on 
the stack, and those things have two cpumask_t's in each.

The rest of the high-stack-usage cases - from a _very_ quick look - seem 
to be unrelated to CPU masks, but in the "more than 1kB of stack" group 
about a third (wild handwaving eyeballing) of them do seem to be related 
to cpumask.

And those things (VM, ACPI and PCI) are easily triggered in real use and 
don't need odd hardware. So I think they need to be fixed before 2.6.29, 
otherwise I'll have to disable MAXSMP and again limit MAX_CPU back to 128 
or something.

			Linus
