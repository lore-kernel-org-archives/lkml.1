Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXHQMz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXHQMz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXHQMzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:55:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:44896 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbXHQMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:55:16 -0400
Message-ID: <46C59AB1.6070505@qumranet.com>
Date: Fri, 17 Aug 2007 15:55:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers"	mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net>
In-Reply-To: <46C56774.2030009@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 17 Aug 2007 15:55:13 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>>     
>>> - remove PATCH 3, and add in task_struct a "ktime vtime" where we accumulate
>>> guest time (by calling something like guest_enter() and guest_exit() from the
>>> virtualization engine), and when in account_system_time() we have cputime >
>>> vtime we substrate vtime from cputime and add vtime to user time and guest time.
>>> But doing like this we freeze in kernel/sched.c the link between system time,
>>> user time and guest time (i.e. system time = system time - vtime, user time =
>>> user time + vtime and guest time = guest time + vtime).
>>>       
>> Actually, I think we can set a per-cpu "in_guest" flag for the scheduler
>> code, which then knows to add the tick to the guest time.  That seems
>> the simplest possible solution.
>>
>> lguest or kvm would set the flag before running the guest (which is done
>> with preempt disabled or using preemption hooks), and reset it
>> afterwards.
>>
>> Thoughts?
>>     
>
> It was my first attempt (except I didn't have a per-cpu flag, but a per-task
> flag), it's not visible but I love simplicity... ;-)
>
> A KVM VCPU is stopped by preemption, so when we enter in scheduler we have
> exited from VCPU and thus this flags is off (so we account 0 to the guest). What
> I did then is "set the flag on when we enter in the VCPU, and
> "account_system_time()" sets the flag off when it adds this timeslice to cpustat
> (and compute correctly guest, user, system time). But I didn't like this idea
> because all code executed after we entered in the VCPU is accounted to the guest
> until we have an account_system_time() and I suppose we can have real system
> time in this part. And I guess a VCPU can be less than 1 ms (unit of cputime) in
> a timeslice.
>
> So ? What's best ?
>   

The normal user/system accounting has the same issue, no?  Whereever we
happen to land (kernel or user) gets the whole tick.

So I think it is okay to have the same limitation for guest time.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

