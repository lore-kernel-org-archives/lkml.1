Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXGJFx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXGJFx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXGJFxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:53:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:55064 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXGJFxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:53:17 -0400
Message-ID: <46931ECB.2060601@qumranet.com>
Date: Tue, 10 Jul 2007 08:53:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>	 <20070708134850.GB22911@elte.hu>	 <1183937563.6005.365.camel@localhost.localdomain>	 <4691D82F.3030401@qumranet.com> <1184029745.6005.402.camel@localhost.localdomain>
In-Reply-To: <1184029745.6005.402.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 10 Jul 2007 08:53:15 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 2007-07-09 at 09:39 +0300, Avi Kivity wrote:
>   
>> Rusty Russell wrote:
>>     
>>> I think a "struct preempt_ops *" and a "void *preempt_ops_data" inside
>>> every task struct is a better idea.  Call the config option
>>> PREEMPT_SCHED_HOOKS and now there's nothing kvm-specific about it...
>>>   
>>>       
>> I considered that, but your proposal does not allow a single task to
>> have multiple preemption hooks installed (hookers?!).  Since in general
>> there's no reason to suppose that users would be mutually exclusive, we
>> need to have a struct hlist of these things.  All in all this seemed to
>> indicate that the second user should have the honor of figuring out that
>> stuff.
>>     
>
> No; this is a "I'm doing something magic and need to know before someone
> else takes the CPU".  Almost by definition, you cannot have two of them
> at the same time.  Let someone else try that if and when...
>   

Why can't you have two of them?  Say I'm writing a module to utilize
branch recording to be able to debug a process in reverse (of course
that doesn't really need sched hooks; let's pretend it does).  Why can't
I debug a process that uses kvm?

More importantly, now the two subsystems have to know about each other
so they don't step on each other's toes.

> But having different hooks for different tasks makes a great deal of
> sense.  This hook makes a great deal of sense.
>   

If we make the hooks non-kvm-specific, I'd just add an hlist there.

> But KVM-specific code in the scheduler is just wrong, and I think we all
> know that.
>   

Even if I eradicate all mention of kvm from the patch, it's still kvm
specific.  kvm at least is sensitive to the exact point where we switch
in (it wants interrupts enabled) and it expects certain parameters to
the callbacks.  If $new_abuser needs other conditions or parameters,
which is quite likely IMO as it will most likely have to do with
hardware, then we will need to update the hooks anyway.

Removing 'kvm' from the patch is easy; but I don't like to pretend to
generality where there ain't.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

