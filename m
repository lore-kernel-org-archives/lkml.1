Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXGJIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXGJIYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXGJIYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:24:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:40805 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXGJIYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:24:12 -0400
Message-ID: <46934232.2070509@qumranet.com>
Date: Tue, 10 Jul 2007 11:24:18 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>	 <20070708134850.GB22911@elte.hu>	 <1183937563.6005.365.camel@localhost.localdomain>	 <4691D82F.3030401@qumranet.com>	 <1184029745.6005.402.camel@localhost.localdomain>	 <46931ECB.2060601@qumranet.com>	 <1184050055.6005.523.camel@localhost.localdomain>	 <469332F3.1000808@qumranet.com> <1184054478.6005.555.camel@localhost.localdomain>
In-Reply-To: <1184054478.6005.555.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-07-10 at 10:19 +0300, Avi Kivity wrote:
>   
>> Rusty Russell wrote:
>>     
>>> Exactly, if we have two at the same time, they need to know about each
>>> other.  Providing infrastructure which lets them avoid thinking about it
>>> is the wrong direction.
>>>   
>>>       
>> With a kvm-specific hook, they can't stop on each other (there can only 
>> be one).
>> With a list, they don't stomp on each other.
>> With a struct preempt_ops but no list, as you propose, they can and will 
>> stomp on each other.
>>     
>
> I'm not talking about the actual overwriting of someone else's hook.
> I'm talking about semantic conflicts involving the actual CPU state.
>
> If I'm lazily restoring some CPU state because I know I don't use it,
> and you're lazily restoring some CPU state because you don't use it, we
> need to make sure that state doesn't intersect: ie. we need to be aware
> of each other.  Only providing a single hook per task forces the second
> user to think about it (maybe that lazy state saving needs to be
> extracted into common code).
>   

Well, if there's another user of VT instructions, then we certainly need 
to have something central to coordinate it.  No API can prevent this, at 
some point we'll forced to use common sense.

>> I guess I can put it in arch specific code, but that means both i386 and 
>> x86_64.
>>
>> Once we have another user we can try to generalize it.
>>     
>
> The problem is that the arch hooks are in the wrong place: 
>
>   

Yes.

>>> Which brings us to the question: why do you want interrupts enabled?
>>>       
>> The sched in hook (vcpu_load) sometimes needs to issue an IPI in order 
>> to flush the VT registers from another cpu into memory.
>>     
>
> OK, I'll have to go away and read the code for this.
>
> BTW, I have no problem with #ifdef KVM-style code in arch-specifics.
> It's kernel/sched.c which is jarring...
>   

We don't want you jarred, do we? I'll prepare a non-kvm-specific patch 
for review later on.  But I can't bring myself to do a single generic 
hook (it's impossible to use correctly); it will be an hlist-based thing.

-- 
error compiling committee.c: too many arguments to function

