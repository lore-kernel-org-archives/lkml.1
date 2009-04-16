Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZDPB1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZDPB1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZDPB1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:27:12 -0400
Received: from ozlabs.org ([203.10.76.45]:36382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZDPB1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:27:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Thu, 16 Apr 2009 10:57:05 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161057.07108.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 12:58:45 am Linus Torvalds wrote:
> 
> On Wed, 15 Apr 2009, Rusty Russell wrote:
> > 
> >    The API is screwy.  It excludes the current CPU from the mask,
> > unconditionally.  It's a tlb flush helper masquerading as a general function.
> > 
> > (smp_call_function has the same issue).
> > 
> > Something like this?
> > 
> > Subject: smp_call_function_many: add explicit exclude_self flag
> 
> No. This just makes the API even screwier. It fixes the 
> "smp_processor_id()" thing, but it is 
> 
>  (a) horribly buggy

Sure.  Did it even compile?

>      Those 
> 
> 	if (exclude_self && cpu == this_cpu)
> 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> 
>      things are wrong - we need to do that "jump over our own CPU" thing 
>      regardless of whether 'exclude_self' is set or not, since we're going 
>      to special-case our own CPU anyway.

I don't think so (smp_call_function_single will DTRT if 
cpu == smp_processor_id).  But I didn't test to be sure.

>  (c) Wrong, even if it wasn't (horribly buggy)^2
> 
>      Adding "flags" to an interface doesn't make it better. Quite the 
>      reverse. It makes it worse.

Uglier.  Worse?  It would have prevented Andrew's mistake.

>      It also makes it even MORE different from 
>      all the other smp_call_function's, which just do the 'self' cpu 
>      without any stupid conditionals and flags.

You've said this twice, but unfortunately that doesn't make it true.

smp_call_function() is the original from which this derives, and it has
always skipped the current cpu.  Hence on_each_cpu().

I'd love to see a fix which isn't ugly and doesn't put a cpumask on the
stack.

> > Impact: clarify and extend confusing API
> 
> And what the hell is up with these bogus "Impact:" things? Who started 
> doing that, and why?

Ingo wants them.  Example:

	lguest: don't expect linear addresses in gdt pvops

	Impact: fix guest crash 'lguest: bad read address 0x4800000 len 256'

What's more important in the subject line?  That it fixes a crash, or what it
does?

Thanks,
Rusty.
