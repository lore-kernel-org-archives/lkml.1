Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZK3Jm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZK3Jm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZK3Jm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:42:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZK3Jmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:42:55 -0500
Message-ID: <4B13935C.3040407@redhat.com>
Date: Mon, 30 Nov 2009 11:41:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com> <4B138950.9040905@kernel.org>
In-Reply-To: <4B138950.9040905@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 10:58 AM, Tejun Heo wrote:
> Hello,
>
> On 11/28/2009 09:12 PM, Avi Kivity wrote:
>    
>>> Hmm, commit 498657a moved the fire_sched_in_preempt_notifiers() call
>>> into the irqs disabled section recently.
>>>
>>>       sched, kvm: Fix race condition involving sched_in_preempt_notifers
>>>
>>>       In finish_task_switch(), fire_sched_in_preempt_notifiers() is
>>>       called after finish_lock_switch().
>>>
>>>       However, depending on architecture, preemption can be enabled after
>>>       finish_lock_switch() which breaks the semantics of preempt
>>>       notifiers.
>>>
>>>       So move it before finish_arch_switch(). This also makes the in-
>>>       notifiers symmetric to out- notifiers in terms of locking - now
>>>       both are called under rq lock.
>>>
>>> It's not a surprise that this breaks the existing code which does the
>>> smp function call.
>>>        
>> Yes, kvm expects preempt notifiers to be run with irqs enabled.  Copying
>> patch author.
>>      
> Hmmm... then, it's broken both ways.  The previous code may get
> preempted after scheduling but before the notifier is run (which
> breaks the semantics of the callback horribly), the current code
> doesn't satisfy kvm's requirement.  Another thing is that in the
> previous implementation the context is different between the 'in' and
> 'out' callbacks, which is subtle and nasty.  Can kvm be converted to
> not do smp calls directly?
>    

No.  kvm uses preempt notifiers to manage extended processor registers 
(much like the fpu).  If we're scheduled into cpu A but state is 
currently live on cpu B, we need to go ahead and pull it in.

Technically, we can delay the IPI to happen after the sched in notifier; 
we can set some illegal state in cpu A and handle the exception by 
sending the IPI and fixing up the state.  But that would be slower, and 
not help the problem at all since some accesses happen with interrupts 
disabled.

Since this is essentially the same problem as the fpu, maybe we can 
solve it the same way.  How does the fpu migrate its state across 
processors?  One way would be to save the state when the task is 
selected for migration.

> For the time being, maybe it's best to back out the fix given that the
> only architecture which may be affected by the original bug is ia64
> which is the only one with both kvm and the unlocked context switch.
>    

Agreed.

-- 
error compiling committee.c: too many arguments to function

