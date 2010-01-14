Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600Ab0ANUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0ANUHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585Ab0ANUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:07:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab0ANUHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:07:05 -0500
Message-ID: <4B4F7951.7090607@redhat.com>
Date: Thu, 14 Jan 2010 15:06:41 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       arjan@infradead.org, jkenisto@us.ibm.com, prasanna@in.ibm.com
Subject: Re: Did we really need to clear the IF flag at prepare_singlestep()
 	of x86 kprobes?
References: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>	 <4B4D65B1.3010204@redhat.com> <ce2c83091001132245q2b42b533vd6519cb3fd0d01af@mail.gmail.com>
In-Reply-To: <ce2c83091001132245q2b42b533vd6519cb3fd0d01af@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongdong Deng wrote:
> On Wed, Jan 13, 2010 at 2:18 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>> Hi Dongdong,
>>
>> Hmm, can that be applied on other x86 compat cpus too?
>> And, when is the debug trap exception actually happened?
> 
>> 1: int3 ->
>> 2:  -> pre_kprobe_handler
>> 3:  -> prepare_singlestep
>> 4: <- iret
>> 5: execute instruction
>> 6: debug trap ->
>> 7: -> post_kprobe_handler
>> ...
>>
>> If we have an interrupt before step4, does that interrupt
>> really executed *after* step5? or step4?
> 
> 
> Hi Masami,
> 
> Thanks for your detail explain, it is the key of my question. :)
> 
> I write a test case to proving it.
> 
> The test case required run on uniprocessor systems,
> 
> My machine is intel Xeon-Dual, so I disable the SMP support when
> building kernel.
> 
> 
> The test case works.
> 
> 1: delay a long time during INT3 handler of kprobes.
> 
> 2: add a printk at the net driver interrupt handler.(I am using
> e10000e net-card)
> 
> 3: startup system
> 
> 4: using other PC to ping current machine all the while, thereby it
> could generate net-card interrupt during INT3.
> 
> 5: insmod the samples/kprobes/kprobe_example.ko .
> 
> 6: using the following script to trigger kprobe.
> 
> #!/bin/bash
> a=0 ; while [ $a != 8000 ]; do(ls ./); a=$(( $a + 1 )); done
> 
> 
> Test output result:
> 
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU            5138  @ 2.13GHz
> stepping        : 11
> cpu MHz         : 2133.324
> cache size      : 4096 KB
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca lahf_lm
> bogomips        : 4266.64
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 38 bits physical, 48 bits virtual
> power management:
> 
> # insmod  kprobe_example.ko
> Planted kprobe at ffffffff8022df60
> 
> # /bin/bash 1.sh
> pre_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df61, flags = 0x246
> prepare_singlestep didn't clear X86_EFLAGS_IF
> Got a e1000 intrrupt during kprobe single step!!!!
> post_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df62, flags = 0x246
> pre_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df61, flags = 0x246
> prepare_singlestep didn't clear X86_EFLAGS_IF
> Got a e1000 intrrupt during kprobe single step!!!!
> post_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df62, flags = 0x246
> 1.sh               kprobe_example.ko
> pre_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df61, flags = 0x246
> prepare_singlestep didn't clear X86_EFLAGS_IF
> Got a e1000 intrrupt during kprobe single step!!!!
> post_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df62, flags = 0x246
> 1.sh               kprobe_example.ko
> pre_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df61, flags = 0x246
> prepare_singlestep didn't clear X86_EFLAGS_IF
> Got a e1000 intrrupt during kprobe single step!!!!
> post_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df62, flags = 0x246
> 1.sh               kprobe_example.ko
> pre_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df61, flags = 0x246
> prepare_singlestep didn't clear X86_EFLAGS_IF
> Got a e1000 intrrupt during kprobe single step!!!!
> post_handler: p->addr = 0xffffffff8022df60, ip = ffffffff8022df62, flags = 0x246
> 1.sh               kprobe_example.ko
> 
> 
> From the result of test cause,  the processor really tries to execute
> interrupt right after step4.

Thank you for testing it!

>>
>> If the processor really tries to execute interrupt
>> right after step5, your logic seems correct, but if it
>> is done right after step4, clearing IF seems correct.
> 
> But I couldn't make sure that this test case is suitable or not.
> If the test case is OK, my logic seems wrong.

Hmm, your test case seems correct on up, so we can't remove
IF clearing line. But anyway, thank you again for ensuring it!


Thanks,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

