Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZAaAs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZAaAs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZAaAsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:48:16 -0500
Received: from gw.goop.org ([64.81.55.164]:60618 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZAaAsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:48:15 -0500
Message-ID: <49839FCB.3010509@goop.org>
Date: Fri, 30 Jan 2009 16:48:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
 00000100, exited with 00010100?" in tip.git
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com> <49825B8B.2000202@goop.org> <20090130150859.GB27549@elte.hu> <20090130221747.GA6877@elte.hu> <20090130223455.GA4151@elte.hu>
In-Reply-To: <20090130223455.GA4151@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>>>>> Call Trace:
>>>>>> [<ffffffff80238c1f>] __schedule_bug+0x62/0x66
>>>>>> [<ffffffff80211d2d>] ? retint_restore_args+0x5/0x20
>>>>>> [<ffffffff80503921>] __schedule+0x95/0x792
>>>>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>>>>> [<ffffffff802093aa>] ? _stext+0x3aa/0x1000
>>>>>> [<ffffffff805040c2>] schedule+0xe/0x22
>>>>>> [<ffffffff8020ff04>] cpu_idle+0x70/0x72
>>>>>> [<ffffffff804fc3a0>] cpu_bringup_and_idle+0x13/0x15
>>>>>> Creating initial device nodes
>>>>>> Setting up hotplug.
>>>>>>
>>>>>>
>>>>>> From what I can see, softirq 8 is the RCU softirq.  I don't know if 
>>>>>> the "scheduling while atomic" is related or not, but its two new 
>>>>>> schedulerish symptoms appearing at once, so I think its likely 
>>>>>> they're related.
>>>>>>     
>>>>>>             
>>>>> Hmmm...  Mysterious, as you seem to be using classic RCU, which hasn't
>>>>> changed in awhile.  Which branch of the tip tree are you using?
>>>>>   
>>>>>           
>>>> tip/master.  It looks like this appeared since -rc1.  Mu current  
>>>> suspicion is the percpu changes, since I'm seeing some other strange  
>>>> symptoms.
>>>>         
>>> Cc:-ed more folks - it's either the percpu changes or the APIC changes 
>>> (both occured at about the same time). Or maybe something from upstream.
>>>       
>> managed to bisect one of the boot crashes i've been seeing:
>>
>> a698c823e15149941b0f0281527d0c0d1daf2639 is first bad commit
>> commit a698c823e15149941b0f0281527d0c0d1daf2639
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Tue Jan 13 20:41:35 2009 +0900
>>
>>     x86: make vmlinux_32.lds.S use PERCPU() macro
>>     
>>     Make vmlinux_32.lds.S use the generic PERCPU() macro instead of open
>>     coding it.  This will ease future changes.
>>     
>>     Signed-off-by: Tejun Heo <tj@kernel.org>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>>  # bad:  [b16884e8] Merge branch 'x86/urgent'
>>  # good: [f2257b70] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>>  # good: [345fa66b] Merge branch 'core/locking'
>>  # bad:  [f534caca] Merge branch 'oprofile'
>>  # bad:  [3eb3963f] Merge branch 'cpus4096' into core/percpu
>>  # bad:  [1b437c8c] x86-64: Move irq stats from PDA to per-cpu and con
>>  # good: [54da5b3d] x86: fix broken flush_tlb_others_ipi(), fix
>>  # good: [c2c21745] x86: replacing mp_config_intsrc with mpc_intsrc
>>  # bad:  [c8f3329a] x86: use static _cpu_pda array
>>  # good: [7de6883f] x86: fix pda_to_op()
>>  # bad:  [a698c823] x86: make vmlinux_32.lds.S use PERCPU() macro
>>  # good: [c90aa894] x86: cleanup early setup_percpu references
>>
>> testing the revert now.
>>
>> This might be similar to the other 32-bit linker bug that was tracked 
>> down yesterday and reverted - maybe that revert unearthed a problem with 
>> this commit?
>>     
>
> seems to do the trick.
>
> Tejun, a detail, this config has:
>
>   CONFIG_RELOCATABLE=y
>
> Have you considered 32-bit relocatable kernels too? Config attached.
>   

I found my bug.  Turns out all my CPUs were sharing the same kernel 
stack (!), which means it was working surprisingly well, considering...

    J
