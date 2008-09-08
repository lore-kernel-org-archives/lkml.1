Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYIHPsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYIHPsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYIHPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:47:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48058 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbYIHPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:47:52 -0400
Message-ID: <48C54925.8040409@sgi.com>
Date: Mon, 08 Sep 2008 08:47:49 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for smp_call_function_mask
References: <20080905214019.821172000@polaris-admin.engr.sgi.com> <20080906132944.GC4910@elte.hu> <48C2C810.3070809@sgi.com> <200809082030.41987.nickpiggin@yahoo.com.au>
In-Reply-To: <200809082030.41987.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Sunday 07 September 2008 04:12, Mike Travis wrote:
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>>   * Cleanup cpumask_t usages in smp_call_function_mask function chain
>>>>     to prevent stack overflow problem when NR_CPUS=4096.
>>>>
>>>>   * Reduce the number of passed cpumask_t variables in the following
>>>>     call chain for x86_64:
>>>>
>>>> 	smp_call_function_mask -->
>>>> 	    arch_send_call_function_ipi->
>>>> 		    smp_ops.send_call_func_ipi -->
>>>> 			    genapic->send_IPI_mask
>>>>
>>>>     Since the smp_call_function_mask() is an EXPORTED function, we
>>>>     cannot change it's calling interface for a patch to 2.6.27.
>>>>
>>>>     The smp_ops.send_call_func_ipi interface is internal only and
>>>>     has two arch provided functions:
>>>>
>>>> 	arch/x86/kernel/smp.c:  .send_call_func_ipi = native_send_call_func_ipi
>>>> 	arch/x86/xen/smp.c:     .send_call_func_ipi =
>>>> xen_smp_send_call_function_ipi arch/x86/mach-voyager/voyager_smp.c:   
>>>> (uses native_send_call_func_ipi)
>>>>
>>>>     Therefore modifying the internal interface to use a cpumask_t
>>>> pointer is straight-forward.
>>>>
>>>>     The changes to genapic are much more extensive and are affected by
>>>> the recent additions of the x2apic modes, so they will be done for
>>>> 2.6.28 only.
>>>>
>>>> Based on 2.6.27-rc5-git6.
>>>>
>>>> Applies to linux-2.6.tip/master (with FUZZ).
>>> applied to tip/cpus4096, thanks Mike.
>> Thanks Ingo!  Could you send me the git id for the merge?
>>
>>> I'm still wondering whether we should get rid of non-reference based
>>> cpumask_t altogether ...
>> I've got a whole slew of "get-ready-to-remove-cpumask_t's" coming soon.
>> There are two phases, one completely within the x86 arch and the 2nd hits
>> the generic smp_call_function_mask ABI (won't be doable as a back-ported
>> patch to 2.6.27.)
>>
>>> Did you have a chance to look at the ftrace/stacktrace tracer in latest
>>> tip/master, which will show the maximum stack footprint that can occur?
>> Hmm, no.  I'm using a default config right now as I can boot that pretty
>> easily.  I'll turn on the ftrace thing and check it out.
>>
>>> Also, i've applied the patch below as well to restore MAXSMP in a muted
>>> form - with big warning signs added as well.
>> The main thing is to allow the distros to set it manually for their QA
>> testing of 2.6.27.  I'm sure I'll get back bugs because of just that.
>>
>> (Is there a way to have them know to assign bugzilla's to me if NR_CPUS=4k
>> is the root of the problem?  This is an extremely serious issue for SGI
>> and I'd like to avoid any delays in me finding out about problems.)
> 
> Considering that, unless I'm mistaken, you want to run production systems
> with 4096 CPUs at some point, then I would say you should really consider
> increasing NR_CPUS _further_ than that in QA efforts, so that we might be
> a bit more confident of running production kernels with 4096.
> 
> Is that being tried? Setting it to 8192 or even higher during QA seems
> like a good idea to me.


That's a good idea.  I do occasionally set it to 16k (and 64k) for experimental
reasons (and to really highlight where cpumask_t space hogs reside), but I
hadn't thought to do it in the QA environment.

Thanks,
Mike
