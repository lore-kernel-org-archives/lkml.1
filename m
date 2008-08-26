Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbYHZTMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbYHZTMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbYHZTLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:11:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43123 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758960AbYHZTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:11:48 -0400
Message-ID: <48B45572.1090904@sgi.com>
Date: Tue, 26 Aug 2008 12:11:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -	bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net> <20080826075355.GA7596@elte.hu>
In-Reply-To: <20080826075355.GA7596@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Tue, 26 Aug 2008 09:22:20 +0200
>>
>>> And i guess the next generation of 4K CPUs support should just get away 
>>> from cpumask_t-on-kernel-stack model altogether, as the current model is 
>>> not maintainable. We tried the on-kernel-stack variant, and it really 
>>> does not work reliably. We can fix this in v2.6.28.
>> I recenetly did some work on sparc64 to use cpumask pointers as much 
>> as possible.
>>
>> The only case that didn't work was due to a limitation in arch 
>> interfaces for the new generic smp_call_function() code. It passes a 
>> cpumask_t instead of a pointer to one via 
>> arch_send_call_function_ipi().
>>
>> But other than that, the whole sparc64 SMP stuff uses cpumask_t 
>> pointers only.
> 
> nice!
> 
>> What it comes down to is that you have to do the "self cpu" and other 
>> tests in the cross-call dispatch routines themselves, instead of at 
>> the top-level working on cpumask_t objects.
>>
>> Otherwise you have to modify cpumask_t objects and thus pluck them 
>> onto the stack where they take up silly amounts of space.
> 
> What we did was this: we added MAXSMP which just revs up all the SMP 
> tunables to the maximum, so that we can see any problems early in 
> testing.
> 
> And we triggered problems, and we fixed a couple of regressions all 
> around stack footprint. But we didnt catch all of them - some were gcc 
> version dependent and configuration dependent. So i think it's safe to 
> say that the whole concept of allowing such a large cpumask_t to be on 
> the stack is fragile.

Iirc, it was the problem of basing percpu variables at zero that hit
problems with various gcc toolset versions.  I don't remember any
version problems with cpumask's on the stack, they all failed the
same way... :-)
> 
> Hence, i think the best way forward is to change the whole cpumask_t 
> concept and disallow explicit masks altogether. It's so easy to smack a 
> cpumask_t variable on the stack and nothing really warns about it, and 
> any function can become part of a nested call sequence.

This is a great idea!
> 
> So i think the dynamics of it has to be changed: we need a get/put API 
> and we need to make on-stack cpumask illegal on the build level (in 
> generic code at least). This has been Rusty's main argument early on i 
> think, and i now concur.
> 
> 	Ingo

Removing cpumask_t's from the stack is fairly straight forward.  The
problem of changing all functions to expect a cpumask pointer via a
global change is much more problematic.  And of course all those
functions that return a cpumask value would need to be addressed.

Thanks,
Mike
