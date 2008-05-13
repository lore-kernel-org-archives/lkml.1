Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYEMMg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYEMMg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbYEMMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:36:19 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:59335 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbYEMMgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:36:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAFAoKUhMROPA/2dsb2JhbACBU6sb
Date: Tue, 13 May 2008 08:36:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH]: Sparc64 immediate values
Message-ID: <20080513123615.GA29334@Krystal>
References: <20080513.044011.204136790.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080513.044011.204136790.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:07:12 up 74 days,  8:18,  3 users,  load average: 1.13, 0.96,
	1.19
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> 
> As described in the commit log I think that two instruction sequences
> can be done properly, and we'd need that to support 16-bit and 32-bit
> values on sparc64 since the available instructions are "load high
> 22-bits" and "or in signed low 13 bits".
> 
> One idea is to capture all cpus other than the immediate value
> updating cpu.
> 
> These other cpus look to see if their program counter falls
> on an immediate value instruction sequence.  Much like how we
> lookup exceptions we can sort the table and use binary search
> so that it isn't too slow.
> 
> If they find themselves in such a sequence, they examine the
> destination register in the last instruction, load that register with
> the proper immediate value, and advance the program counter.  Then
> they wait to be released.
> 
> The updater does the instruction update unimpeded, flushes the
> instruction cache or whatever needs to be done, and then releases the
> other cpus.
> 
> PowerPC could use this scheme too, if it does in fact work.
> 

I did use a "stop_machine" with interrupts disabled implementation in
the "simple immediate values version". It is really heavy; it busy-loops
all cpus with interrupts disabled except one while the immediate value
is updated. This is required so we stop interrupt contexts from
executing those instructions. However, it does not protect from having a
thread preempted in the middle of this instruction sequence and
therefore to see incoherent values. Are there non-maskable interrupts on
sparc64 ? That would make the stop_machine approach a bit more fragile
against this execution context.

The one thing we could do to allow such updates without using
stop_machine is to create something similar to the read seqlock using
immediate values.

In this case, the read-side would look like (pseudo-code) :

1:
  mov 22-bits MSB-lock to r2 (1)
  mov 13-bits LSB to r1 low  (2)
  mov 22-bits MSB to r1 high (3)
  mov 22-bits MSB-lock to r3 (4)
  compare r2,r3              (5)
  jne 1b

Write side :

Increment MSB-lock value in instruction (1)
smp_wmb()
update instructions 2 and 3
smp_wmb()
Increment MSB-lock value in instruction (2)

We would then have a 22-bits detection power of updates done while a
context is interrupted or preempted. It means that, in the worse case,
we could have a kernel thread preempted right in the middle of (2) and
(3), which comes back after exactly 2^22 write-side executions and
thinks the lock is correct when it actually isn't. We have the same
problem with the read seqlock anyway. One way to fix this would be to
put all threads in the freezer, which is a really-really heavy lock,
each time the MSB-lock counter reaches overflow. The performance impact
of this approach should be carefully considered though : added branch,
added instruction cache impact..

If it makes sense, we could put all threads in the freezer and use
stop_machine, but I guess it's a bit heavy. In any case, I would like
the 8-bit immediate value update not to depend on such heavy lock and to
support nmi-like contexts.

> Please add to the ftrace tree, thanks.
> 

The following patch looks good! Although I have not looked at the
sparc64 instruction set details, it follows the general immediate values
mindset.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> commit f2b14974b823a9cd9b6f5c0d423945caa15de8a2
> Author: David S. Miller <davem@davemloft.net>
> Date:   Tue May 13 04:29:30 2008 -0700
> 
>     sparc64: Optimized immediate value implementation.
>     
>     We can only do byte sized values currently.
>     
>     In order to support even 16-bit immediates we would need a 2
>     instruction sequence.
>     
>     I believe that can be made to work with a suitable breakpoint or some
>     other kind of special patching sequence, but that isn't attempted
>     here.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
> index eb36f3b..4c40862 100644
> --- a/arch/sparc64/Kconfig
> +++ b/arch/sparc64/Kconfig
> @@ -14,6 +14,7 @@ config SPARC64
>  	select HAVE_IDE
>  	select HAVE_LMB
>  	select HAVE_ARCH_KGDB
> +	select HAVE_IMMEDIATE
>  
>  config GENERIC_TIME
>  	bool
> diff --git a/arch/sparc64/kernel/Makefile b/arch/sparc64/kernel/Makefile
> index ec4f5eb..311c797 100644
> --- a/arch/sparc64/kernel/Makefile
> +++ b/arch/sparc64/kernel/Makefile
> @@ -25,6 +25,7 @@ obj-$(CONFIG_MODULES) += module.o
>  obj-$(CONFIG_US3_FREQ) += us3_cpufreq.o
>  obj-$(CONFIG_US2E_FREQ) += us2e_cpufreq.o
>  obj-$(CONFIG_KPROBES) += kprobes.o
> +obj-$(CONFIG_IMMEDIATE) += immediate.o
>  obj-$(CONFIG_SUN_LDOMS) += ldc.o vio.o viohs.o ds.o
>  obj-$(CONFIG_AUDIT) += audit.o
>  obj-$(CONFIG_AUDIT)$(CONFIG_COMPAT) += compat_audit.o
> diff --git a/arch/sparc64/kernel/immediate.c b/arch/sparc64/kernel/immediate.c
> new file mode 100644
> index 0000000..be76f28
> --- /dev/null
> +++ b/arch/sparc64/kernel/immediate.c
> @@ -0,0 +1,48 @@
> +#include <linux/module.h>
> +#include <linux/immediate.h>
> +#include <linux/string.h>
> +#include <linux/kprobes.h>
> +
> +#include <asm/system.h>
> +
> +int arch_imv_update(const struct __imv *imv, int early)
> +{
> +	unsigned long imv_vaddr = imv->imv;
> +	unsigned long var_vaddr = imv->var;
> +	u32 insn, *ip = (u32 *) imv_vaddr;
> +
> +	insn = *ip;
> +
> +#ifdef CONFIG_KPROBES
> +	switch (imv->size) {
> +	case 1:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (unlikely(!early &&
> +		     (insn == BREAKPOINT_INSTRUCTION ||
> +		      insn == BREAKPOINT_INSTRUCTION_2))) {
> +		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
> +				    "Variable at %p, "
> +				    "instruction at %p, size %u\n",
> +				    ip, (void *)var_vaddr, imv->size);
> +		return -EBUSY;
> +	}
> +#endif
> +
> +	switch (imv->size) {
> +	case 1:
> +		if ((insn & 0x1fff) == *(uint8_t *)var_vaddr)
> +			return 0;
> +		insn &= ~0x00001fff;
> +		insn |= (u32) (*(uint8_t *)var_vaddr);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	*ip = insn;
> +	flushi(ip);
> +	return 0;
> +}
> diff --git a/include/asm-sparc64/immediate.h b/include/asm-sparc64/immediate.h
> new file mode 100644
> index 0000000..3673afd
> --- /dev/null
> +++ b/include/asm-sparc64/immediate.h
> @@ -0,0 +1,37 @@
> +#ifndef _ASM_SPARC64_IMMEDIATE_H
> +#define _ASM_SPARC64_IMMEDIATE_H
> +
> +struct __imv {
> +	unsigned int var;
> +	unsigned int imv;
> +	unsigned char size;
> +} __attribute__ ((packed));
> +
> +#define imv_read(name)							\
> +	({								\
> +		__typeof__(name##__imv) value;				\
> +		BUILD_BUG_ON(sizeof(value) > 8);			\
> +		switch (sizeof(value)) {				\
> +		case 1:							\
> +			asm(".section __imv,\"aw\",@progbits\n\t"	\
> +					".uaword %c1, 1f\n\t"		\
> +					".byte 1\n\t"			\
> +					".previous\n\t"			\
> +					"1: mov 0, %0\n\t"		\
> +				: "=r" (value)				\
> +				: "i" (&name##__imv));			\
> +			break;						\
> +		case 2:							\
> +		case 4:							\
> +		case 8:	value = name##__imv;				\
> +			break;						\
> +		};							\
> +		value;							\
> +	})
> +
> +#define imv_cond(name)	imv_read(name)
> +#define imv_cond_end()
> +
> +extern int arch_imv_update(const struct __imv *imv, int early);
> +
> +#endif /* _ASM_SPARC64_IMMEDIATE_H */
> diff --git a/kernel/immediate.c b/kernel/immediate.c
> index 3668a7f..1b4c5cf 100644
> --- a/kernel/immediate.c
> +++ b/kernel/immediate.c
> @@ -62,8 +62,8 @@ void imv_update_range(struct __imv *begin,
>  				"Invalid immediate value. "
>  				"Variable at %p, "
>  				"instruction at %p, size %hu\n",
> -				(void *)iter->imv,
> -				(void *)iter->var, iter->size);
> +			        (void *)(long)iter->imv,
> +			        (void *)(long)iter->var, iter->size);
>  skip:
>  		mutex_unlock(&imv_mutex);
>  	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
