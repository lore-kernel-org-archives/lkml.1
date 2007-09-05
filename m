Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXIETZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXIETZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXIETZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:25:21 -0400
Received: from smtp.nokia.com ([131.228.20.172]:37553 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbXIETZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:25:20 -0400
Message-ID: <46DF0257.5050303@nokia.com>
Date: Wed, 05 Sep 2007 22:24:07 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: ext Andi Kleen <andi@firstfloor.org>
CC: ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700
 system
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com> <20070905163724.GC31880@one.firstfloor.org>
In-Reply-To: <20070905163724.GC31880@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2007 19:25:08.0670 (UTC) FILETIME=[7888BDE0:01C7EFF2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Andi Kleen wrote:
>> flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge cmov pat 
>> clflush acpi mmx fxsr sse sse2 tm up pni est tm2 rng rng_en ace ace_en 
> 
> Hmm, I can't really see anything wrong. This means the original
> version of the patch you found had a few problems, but they
> were all fixed later and only applied with CONFIG_PARAVIRT enabled anyways.
> 
> As a stab in the dark since the CPU has clflush can you please 
> comment out the  
> 
>   if (cpu_has_clflush)
>                 asm("clflush (%0) " :: "r" (addr) : "memory");
> 
> statement in arch/i386/kernel/alternative.c and see if it makes a difference?
> Perhaps your CPU doesn't like that (it seems to have clflush) 
> 
> If that doesn't help it might be needed to revert the patch
> hunk by hunk to see which text_poke() invocation caused it.

OK, I reset my working area to the master branch (i.e. 2.6.23-rc5-gitX) 
and then changed text_poke() to read

void __kprobes text_poke(void *addr, unsigned char *opcode, int len)
{
	memcpy(addr, opcode, len);
	sync_core();
	/* Not strictly needed, but can speed CPU recovery up. Ignore cross 
cacheline
	   case. */
#if 0
	if (cpu_has_clflush)
		asm("clflush (%0) " :: "r" (addr) : "memory");
#endif
}

This kernel boots up OK. Looking at the preprocessed C code the 
following code in alternative_instructions() is compiled in:

#ifdef CONFIG_SMP
	if (smp_alt_once) {
		if (1 == num_possible_cpus()) {
			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ This I still see at bootup

			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
			set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
						_text, _etext);

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ this function uses text_poke()
---> BOOM
		}
		free_init_pages("SMP alternatives",
				(unsigned long)__smp_locks,
				(unsigned long)__smp_locks_end);

So what can we do about the clflush on this CPU?

Regards,

	Stefan

