Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbXGJGDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbXGJGDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXGJGDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:03:13 -0400
Received: from il.qumranet.com ([82.166.9.18]:37832 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXGJGDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:03:12 -0400
Message-ID: <4693211D.4040406@qumranet.com>
Date: Tue, 10 Jul 2007 09:03:09 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com>	 <11838956893094-git-send-email-avi@qumranet.com>	 <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>	 <20070709071640.GB10864@one.firstfloor.org>	 <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com> <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>
In-Reply-To: <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 10 Jul 2007 09:03:09 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>
>
> On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
>> [...]
>> on_each_cpu() was imho always a mistake. It would have been better
>> to just fix smp_call_function() directly
>
> I'm not sure what you mean by "fix" here, but if you're proposing
> that we change smp_call_function() semantics to _include_ the
> current CPU (and just run the given function locally also along
> with the others -- and hence get rid of on_each_cpu) then I'm sorry
> but I'll have to *violently* disagree with that. Please remember that
> the current CPU _must_ be treated specially in a whole *lot* of
> usage scenarios ...

I imagine that by "fix" Andi means also updating all callers.  Otherwise
he would just have said "break".

>
> On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
>> > I think it would be better to fix smp_call_function_single to just
>> > handle this case transparently. There aren't that many callers yet
>> > because it is
>> > fairly new.
>
> Take the same example here -- let's say we want to send a
> "for (;;) ;" kind of function to a specified CPU. Now let's say
> by the time we've called smp_call_function_single() on that
> target CPU, we're preempted out and then get rescheduled
> on the target CPU itself. There, we begin executing the
> smp_call_function_single() (as modified by Avi here with your
> proposed changed semantics) and notice that we've landed
> on the target CPU itself, execute the suicidal function
> _locally_ *in current thread* itself, and ... well, I hope you
> get the picture.

So you disable preemption before calling smp_call_function_single().

>
> So my opinion is to go with the get_cpu() / put_cpu() wrapper
> Avi is proposing here and keep smp_call_function{_single}
> semantics unchanged. [ Also please remember that for
> *correctness*, preemption needs to be disabled by the
> _caller_ of smp_call_function{_single} functions, doing so
> inside them is insufficient. ]

That's not correct.  kvm has two places where you can call the new
smp_call_function_single() (or on_cpu()) without disabling preemption. 
There are also a couple of existing places that don't need to disable
preemption with the new semantics (see mtrr_save_state(), do_cpuid(),  
_rdmsr_on_cpu(), all in arch/i386 for examples).  In fact I think more
places can take advantage of the new semantics than not.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

