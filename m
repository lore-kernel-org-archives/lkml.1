Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZDOPb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZDOPb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZDOPbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:31:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbZDOPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:31:48 -0400
Date: Wed, 15 Apr 2009 08:28:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <200904152014.11717.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Rusty Russell wrote:
> 
>    The API is screwy.  It excludes the current CPU from the mask,
> unconditionally.  It's a tlb flush helper masquerading as a general function.
> 
> (smp_call_function has the same issue).
> 
> Something like this?
> 
> Subject: smp_call_function_many: add explicit exclude_self flag

No. This just makes the API even screwier. It fixes the 
"smp_processor_id()" thing, but it is 

 (a) horribly buggy

     See the 'return' without any put_cpu()

 (b) horribly buggy

     Those 

	if (exclude_self && cpu == this_cpu)
		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);

     things are wrong - we need to do that "jump over our own CPU" thing 
     regardless of whether 'exclude_self' is set or not, since we're going 
     to special-case our own CPU anyway.

 (c) Wrong, even if it wasn't (horribly buggy)^2

     Adding "flags" to an interface doesn't make it better. Quite the 
     reverse. It makes it worse. It also makes it even MORE different from 
     all the other smp_call_function's, which just do the 'self' cpu 
     without any stupid conditionals and flags.

IOW, it would make things worse even if it worked. Which it doesn't.

> Impact: clarify and extend confusing API

And what the hell is up with these bogus "Impact:" things? Who started 
doing that, and why? If your single-line explanation at the top is not 
good enough, and your multi-line explanation isn't clear enough, then you 
should fix the OTHER parts, not add that _idiotic_ "Impact" statement.

The thing has spread like wildfire, and it's STUPID.

		Linus
