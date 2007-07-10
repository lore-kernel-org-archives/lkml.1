Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbXGJHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbXGJHTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXGJHTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:19:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:40749 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXGJHTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:19:10 -0400
Message-ID: <469332F3.1000808@qumranet.com>
Date: Tue, 10 Jul 2007 10:19:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>	 <20070708134850.GB22911@elte.hu>	 <1183937563.6005.365.camel@localhost.localdomain>	 <4691D82F.3030401@qumranet.com>	 <1184029745.6005.402.camel@localhost.localdomain>	 <46931ECB.2060601@qumranet.com> <1184050055.6005.523.camel@localhost.localdomain>
In-Reply-To: <1184050055.6005.523.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-07-10 at 08:53 +0300, Avi Kivity wrote:
>   
>> Rusty Russell wrote:
>>     
>>> No; this is a "I'm doing something magic and need to know before someone
>>> else takes the CPU".  Almost by definition, you cannot have two of them
>>> at the same time.  Let someone else try that if and when...
>>>       
>> Why can't you have two of them?  Say I'm writing a module to utilize
>> branch recording to be able to debug a process in reverse (of course
>> that doesn't really need sched hooks; let's pretend it does).  Why can't
>> I debug a process that uses kvm?
>>
>> More importantly, now the two subsystems have to know about each other
>> so they don't step on each other's toes.
>>     
>
> Exactly, if we have two at the same time, they need to know about each
> other.  Providing infrastructure which lets them avoid thinking about it
> is the wrong direction.
>   

With a kvm-specific hook, they can't stop on each other (there can only 
be one).
With a list, they don't stomp on each other.
With a struct preempt_ops but no list, as you propose, they can and will 
stomp on each other.

>   
>>> But KVM-specific code in the scheduler is just wrong, and I think we all
>>> know that.
>>>       
>> Even if I eradicate all mention of kvm from the patch, it's still kvm
>> specific.  kvm at least is sensitive to the exact point where we switch
>> in (it wants interrupts enabled) and it expects certain parameters to
>> the callbacks.  If $new_abuser needs other conditions or parameters,
>> which is quite likely IMO as it will most likely have to do with
>> hardware, then we will need to update the hooks anyway.
>>     
>
> If it's not general, then this whole approach is wrong: put it in
> arch/*/kernel/process.c:__switch_to and finish_arch_switch.  

I imagine other kvm ports will also need this.  It's not arch specific, 
just kvm specific (but that's not really fair: other archs might want 
the switch in another place, or they might not need it after all).

I guess I can put it in arch specific code, but that means both i386 and 
x86_64.

Once we have another user we can try to generalize it.

> The
> congruent case which comes to mind is lazy FPU handling.
>   

That one has preempt_ops in hardware: cr0.ts and #NM.

> Which brings us to the question: why do you want interrupts enabled?
>   

The sched in hook (vcpu_load) sometimes needs to issue an IPI in order 
to flush the VT registers from another cpu into memory.

-- 
error compiling committee.c: too many arguments to function

