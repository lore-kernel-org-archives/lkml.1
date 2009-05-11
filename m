Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZEKUn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZEKUn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZEKUnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:43:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZEKUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:43:46 -0400
Message-ID: <4A088DF4.7080305@garzik.org>
Date: Mon, 11 May 2009 16:43:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org> <20090508190944.GB12130@elte.hu> <200905101819.41765.rusty@rustcorp.com.au> <20090511105816.GG4648@elte.hu>
In-Reply-To: <20090511105816.GG4648@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Sat, 9 May 2009 04:39:44 am Ingo Molnar wrote:
>>> * Jeff Garzik <jeff@garzik.org> wrote:
>>>> The semantics for variable-length arrays __in the middle of structs__
>>>> are quite muddy, and a case in sched.c presents an interesting case,
>>>> as the preceding code comment indicates:
>>>>
>>>> 	/*
>>>> 	 * The cpus mask in sched_group and sched_domain hangs off
>>>> 	 the end.  * FIXME: use cpumask_var_t or dynamic percpu alloc
>>>> 	 to avoid * wasting space for nr_cpu_ids < CONFIG_NR_CPUS.  */
>>>> 	struct static_sched_group {
>>>> 		struct sched_group sg; DECLARE_BITMAP(cpus,
>>>> 		CONFIG_NR_CPUS);
>>>> 	};
>> Yeah, it's kinda nasty.  Generally, sched_group is dynamically 
>> allocated, so we just allocate sizeof(struct sched_group) + size 
>> of nr_cpu_ids bits.
>>
>> These ones are static, and it was easier to put this hack in than 
>> make them dynamic.  There's nothing wrong with it, until we really 
>> want NR_CPUS == bignum, or we want to get rid of NR_CPUS 
>> altogether for CONFIG_CPUMASKS_OFFSTACK (which would be very 
>> clean, but not clearly worthwhile).
>>
>> But more importantly, my comment is obviously unclear, since your 
>> patch shows you didn't understand the purpose of the field: The 
>> cpus bitmap *is* the sg-cpumask[] array.
> 
> I dont think Jeff misunderstood this code (hey, he found it! :), his 
> patch is a demonstration of why this code is a problem: a seemingly 
> innocious invariant modification (his patch) kills the kernel dead.

Yeah, it was intended to spark debate...  definitely not to be applied 
(hence "NOT-signed-off-by", among other hints).


>>>> Maybe a C expert can say whether cpumask[0] is better than cpumask[],
>>>> or have other comments?
>> [0] is a gcc extension, but it should be equivalent.
>>
>>> That cpumask[] should probably be cpumask[0], to document the
>>> aliasing to ->span and ->cpus properly.
>> If the comment wasn't sufficient documentation, I don't think that 
>> would help :(
> 
> It's a visual helper: it matches up with how we do these 'zero size 
> array means dynamic structure continuation' tricks generally.
> 
> I first mis-parsed the code for a second when seeing cpumask[]. 
> cpumask[0] stands out like a sore thumb. And we dont read comments 
> anyway ;-)
> 
> Jeff, i suspect you found this because you are working on something 
> rather interesting? :) If yes, would it help your project if we did 
> the cpumask[0] cleanup and pushed it upstream immediately?

I think cpumask[0] would be more clear and consistent with the rest of 
the kernel.

But unfortunately for the twin projects of (a) static analysis and 
checking with 'sparse', and (b) compiling under another compiler, 
VLA-in-middle-of-struct is a killer in either case.

	Jeff




