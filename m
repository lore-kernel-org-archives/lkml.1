Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZK1MOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZK1MOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZK1MOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZK1MOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:14:16 -0500
Message-ID: <4B1113C0.30505@redhat.com>
Date: Sat, 28 Nov 2009 14:12:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2009 06:37 PM, Thomas Gleixner wrote:
> On Fri, 27 Nov 2009, Peter Zijlstra wrote:
>
>    
>> On Fri, 2009-11-27 at 16:03 +0100, Jiri Slaby wrote:
>>      
>>> On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
>>>        
>>>> The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
>>>>          
>>> Hi, when executing qemu-kvm I often get following warning and a hard lockup.
>>>
>>> WARNING: at kernel/smp.c:292 smp_call_function_single+0xbd/0x140()
>>> Hardware name: To Be Filled By O.E.M.
>>> Modules linked in: kvm_intel kvm fuse ath5k ath
>>> Pid: 3265, comm: qemu-kvm Not tainted 2.6.32-rc8-mm1_64 #912
>>> Call Trace:
>>>   [<ffffffff81039678>] warn_slowpath_common+0x78/0xb0
>>>   [<ffffffffa007fd50>] ? __vcpu_clear+0x0/0xd0 [kvm_intel]
>>>   [<ffffffff810396bf>] warn_slowpath_null+0xf/0x20
>>>   [<ffffffff8106410d>] smp_call_function_single+0xbd/0x140
>>>   [<ffffffffa0080af6>] vmx_vcpu_load+0x46/0x170 [kvm_intel]
>>>   [<ffffffffa004dd94>] kvm_arch_vcpu_load+0x24/0x60 [kvm]
>>>   [<ffffffffa0047a8d>] kvm_sched_in+0xd/0x10 [kvm]
>>>   [<ffffffff8102de37>] finish_task_switch+0x67/0xc0
>>>   [<ffffffff814699f8>] schedule+0x2f8/0x9c0
>>>        
>>      
>>> It is a regression against 2009-11-13-19-59.
>>>
>>> Any ideas?
>>>        
>> Looks like kvm is trying to send an IPI from the preempt notifiers,
>> which are called with IRQs disabled, not a sane thing to do.
>>
>> If they really want that, they'll have to use a pre-allocated struct
>> call_single_data and use __smp_call_function_single.
>>      
> Hmm, commit 498657a moved the fire_sched_in_preempt_notifiers() call
> into the irqs disabled section recently.
>
>      sched, kvm: Fix race condition involving sched_in_preempt_notifers
>
>      In finish_task_switch(), fire_sched_in_preempt_notifiers() is
>      called after finish_lock_switch().
>
>      However, depending on architecture, preemption can be enabled after
>      finish_lock_switch() which breaks the semantics of preempt
>      notifiers.
>
>      So move it before finish_arch_switch(). This also makes the in-
>      notifiers symmetric to out- notifiers in terms of locking - now
>      both are called under rq lock.
>
> It's not a surprise that this breaks the existing code which does the
> smp function call.
>    


Yes, kvm expects preempt notifiers to be run with irqs enabled.  Copying 
patch author.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

