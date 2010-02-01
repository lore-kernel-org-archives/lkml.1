Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0BAWzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:55:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39565 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0BAWzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:55:15 -0500
Message-ID: <4B675BBE.7080800@zytor.com>
Date: Mon, 01 Feb 2010 14:54:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: enlightenment for ticket spinlocks - base	 implementation
References: <4B62A3BD020000780002CA83@vpn.id2.novell.com>
In-Reply-To: <4B62A3BD020000780002CA83@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:00 AM, Jan Beulich wrote:
> @@ -22,9 +36,11 @@
>  #ifdef CONFIG_X86_32
>  # define LOCK_PTR_REG "a"
>  # define REG_PTR_MODE "k"
> +# define REG_PTR_PREFIX "e"
>  #else
>  # define LOCK_PTR_REG "D"
>  # define REG_PTR_MODE "q"
> +# define REG_PTR_PREFIX "r"
>  #endif
>  
>  #if defined(CONFIG_X86_32) && \
> @@ -62,19 +78,54 @@ static __always_inline void __ticket_spi
>  {
>  	short inc = 0x0100;
>  
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
>  	asm volatile (
> +#else
> +	alternative_io(
> +		".L%=orig:\n\t"
> +#endif
>  		LOCK_PREFIX "xaddw %w0, %1\n"
>  		"1:\t"
>  		"cmpb %h0, %b0\n\t"
> -		"je 2f\n\t"
> +		"je .L%=done\n\t"
>  		"rep ; nop\n\t"
>  		"movb %1, %b0\n\t"
>  		/* don't need lfence here, because loads are in-order */
>  		"jmp 1b\n"
> -		"2:"
> -		: "+Q" (inc), "+m" (lock->slock)
> +		".L%=done:"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
>  		:
> +#else
> +		, ".L%=alt:\n\t"
> +		  /* Prevent using rip-relative addressing here. */
> +		  LOCK_PREFIX "xaddw %w0, %P1\n\t"
> +		  "cmpb %h0, %b0\n\t"
> +		  /* jne .L%=callout */
> +		  ".byte 0x0f, 0x85\n\t"
> +		  ".long (.L%=callout - .L%=orig) - (. + 4 - .L%=alt)\n"
> +		  ".previous\n"
> +		  ".subsection 1\n"
> +		  ".L%=callout:\n\t"
> +		  "push $.L%=done\n\t"
> +		  "push %%" REG_PTR_PREFIX "bp\n\t"
> +		  "push %" REG_PTR_MODE "0\n\t"
> +		  "lea %1, %%" REG_PTR_PREFIX "bp\n\t"
> +		  "call %P[stub]\n\t"
> +		  ".subsection 0\n\t"
> +		  ".section .altinstr_replacement",
> +		X86_FEATURE_SPINLOCK_YIELD,
> +#endif
> +		ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock))
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
> +		:
> +#else
> +		, [stub] "i" (virt_spin_lock_stub)
> +#endif
>  		: "memory", "cc");
> +
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	lock->owner = percpu_read(cpu_number);
> +#endif
>  }

I'm really not very happy with the way the asm statement is chopped to
bits here.  It is quite frankly much cleaner to have a little bit of
code replication and have two separate clean asm/alternative_io
implementations.

A thought, however:

the sequence "rep;nop; movb %1,%b0" should be enough bytes to be able to
overwrite it with a call instruction.  I am not sure if the existing
macros allow for overwriting part of an asm statement, but it might be
an interesting thing to do.  That should eliminate the funnies you have
with rip-relative addressing (which may very well be the preferred
addressing modes.)  It should also give you the return address without
having to play games with pushing it onto the stack as anything other
than a return address...

	-hpa





>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -93,14 +144,54 @@ static __always_inline int __ticket_spin
>  		     :
>  		     : "memory", "cc");
>  
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	if (tmp)
> +		lock->owner = percpu_read(cpu_number);
> +#endif
> +
>  	return tmp;
>  }
>  
>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  {
> -	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
> +	asm volatile(
> +#else
> +	unsigned int token;
> +
> +	alternative_io(
> +		     ".L%=orig:\n\t"
> +#endif
> +		     UNLOCK_LOCK_PREFIX "incb %0"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
>  		     : "+m" (lock->slock)
>  		     :
> +#else
> +		     "\n\t"
> +		     ASM_NOP3
> +		     ".L%=done:",
> +		     ".L%=alt:\n\t"
> +		     /* jmp .L%=callout */
> +		     ".byte 0xe9\n\t"
> +		     ".long (.L%=callout - .L%=orig) - (. + 4 - .L%=alt)\n\t"
> +		     ".previous\n\t"
> +		     ".subsection 1\n"
> +		     ".L%=callout:\n\t"
> +		     UNLOCK_LOCK_PREFIX "incb %0\n\t"
> +		     "movzwl %0, %1\n\t"
> +		     "cmpb %h1, %b1\n\t"
> +		     "je .L%=done\n\t"
> +		     "push $.L%=done\n\t"
> +		     "push %%" REG_PTR_PREFIX "bp\n\t"
> +		     "push %" REG_PTR_MODE "1\n\t"
> +		     "lea %0, %%" REG_PTR_PREFIX "bp\n\t"
> +		     "call %P[stub]\n\t"
> +		     ".subsection 0\n\t"
> +		     ".section .altinstr_replacement",
> +		     X86_FEATURE_SPINLOCK_YIELD,
> +		     ASM_OUTPUT2("+m" (lock->slock), "=&Q" (token)),
> +		     [stub] "i" (virt_spin_unlock_stub)
> +#endif
>  		     : "memory", "cc");
>  }
>  #else
> @@ -111,20 +202,58 @@ static __always_inline void __ticket_spi
>  	int inc = 0x00010000;
>  	int tmp;
>  
> -	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
> +	asm volatile(
> +#else
> +	alternative_io(
> +		     ".L%=orig:\n\t"
> +#endif
> +		     LOCK_PREFIX "xaddl %0, %1\n"
>  		     "movzwl %w0, %2\n\t"
>  		     "shrl $16, %0\n\t"
>  		     "1:\t"
>  		     "cmpl %0, %2\n\t"
> -		     "je 2f\n\t"
> +		     "je .L%=done\n\t"
>  		     "rep ; nop\n\t"
>  		     "movzwl %1, %2\n\t"
>  		     /* don't need lfence here, because loads are in-order */
>  		     "jmp 1b\n"
> -		     "2:"
> -		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
> +		     ".L%=done:"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
>  		     :
> +#else
> +		     , ".L%=alt:\n\t"
> +		       /* Prevent using rip-relative addressing here. */
> +		       LOCK_PREFIX "xaddl %0, %P1\n\t"
> +		       "movzwl %w0, %2\n\t"
> +		       "shrl $16, %0\n\t"
> +		       "cmpl %0, %2\n\t"
> +		       /* jne .L%=callout */
> +		       ".byte 0x0f, 0x85\n\t"
> +		       ".long (.L%=callout - .L%=orig) - (. + 4 - .L%=alt)\n"
> +		       ".previous\n"
> +		       ".subsection 1\n"
> +		       ".L%=callout:\n\t"
> +		       "push $.L%=done\n\t"
> +		       "push %%" REG_PTR_PREFIX "bp\n\t"
> +		       "push %" REG_PTR_MODE "0\n\t"
> +		       "lea %1, %%" REG_PTR_PREFIX "bp\n\t"
> +		       "call %P[stub]\n\t"
> +		       ".subsection 0\n\t"
> +		       ".section .altinstr_replacement",
> +		     X86_FEATURE_SPINLOCK_YIELD,
> +#endif
> +		     ASM_OUTPUT2("+r" (inc), "+m" (lock->slock), "=&r" (tmp))
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
> +		     :
> +#else
> +		     , [stub] "i" (virt_spin_lock_stub)
> +#endif
>  		     : "memory", "cc");
> +
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	lock->owner = percpu_read(cpu_number);
> +#endif
>  }
>  
>  static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> @@ -146,14 +275,55 @@ static __always_inline int __ticket_spin
>  		     :
>  		     : "memory", "cc");
>  
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	if (tmp)
> +		lock->owner = percpu_read(cpu_number);
> +#endif
> +
>  	return tmp;
>  }
>  
>  static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
>  {
> -	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
> +	asm volatile(
> +#else
> +	unsigned int token, tmp;
> +
> +	alternative_io(
> +		     ".L%=orig:\n\t"
> +#endif
> +		     UNLOCK_LOCK_PREFIX "incw %0"
> +#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
>  		     : "+m" (lock->slock)
>  		     :
> +#else
> +		     "\n\t"
> +		     ASM_NOP2
> +		     ".L%=done:",
> +		     ".L%=alt:\n\t"
> +		     /* jmp .L%=callout */
> +		     ".byte 0xe9\n\t"
> +		     ".long (.L%=callout - .L%=orig) - (. + 4 - .L%=alt)\n\t"
> +		     ".previous\n\t"
> +		     ".subsection 1\n"
> +		     ".L%=callout:\n\t"
> +		     UNLOCK_LOCK_PREFIX "incw %0\n\t"
> +		     "movl %0, %1\n\t"
> +		     "shldl $16, %1, %2\n\t"
> +		     "cmpw %w2, %w1\n\t"
> +		     "je .L%=done\n\t"
> +		     "push $.L%=done\n\t"
> +		     "push %%" REG_PTR_PREFIX "bp\n\t"
> +		     "push %" REG_PTR_MODE "1\n\t"
> +		     "lea %0, %%" REG_PTR_PREFIX "bp\n\t"
> +		     "call %P[stub]\n\t"
> +		     ".subsection 0\n\t"
> +		     ".section .altinstr_replacement",
> +		     X86_FEATURE_SPINLOCK_YIELD,
> +		     ASM_OUTPUT2("+m" (lock->slock), "=&r" (token), "=&r" (tmp)),
> +		     [stub] "i" (virt_spin_unlock_stub)
> +#endif
>  		     : "memory", "cc");
>  }
>  #endif
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/spinlock_types.h
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/spinlock_types.h
> @@ -5,11 +5,29 @@
>  # error "please don't include this file directly"
>  #endif
>  
> +#include <asm/types.h>
> +
>  typedef struct arch_spinlock {
> -	unsigned int slock;
> +	union {
> +		unsigned int slock;
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +		struct {
> +# if CONFIG_NR_CPUS < 256
> +			u8 cur, seq;
> +# else
> +			u16 cur, seq;
> +# endif
> +# if CONFIG_NR_CPUS <= 256
> +			u8 owner;
> +# else
> +			u16 owner;
> +# endif
> +		};
> +#endif
> +	};
>  } arch_spinlock_t;
>  
> -#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
> +#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
>  
>  typedef struct {
>  	unsigned int lock;
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/alternative.c
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/alternative.c
> @@ -202,7 +202,8 @@ static void *text_poke_early(void *addr,
>     Tough. Make sure you disable such features by hand. */
>  
>  void __init_or_module apply_alternatives(struct alt_instr *start,
> -					 struct alt_instr *end)
> +					 struct alt_instr *end,
> +					 u8 **smp_start, u8 **smp_end)
>  {
>  	struct alt_instr *a;
>  	char insnbuf[MAX_PATCH_LEN];
> @@ -226,6 +227,30 @@ void __init_or_module apply_alternatives
>  		add_nops(insnbuf + a->replacementlen,
>  			 a->instrlen - a->replacementlen);
>  		text_poke_early(instr, insnbuf, a->instrlen);
> +
> +#ifdef CONFIG_SMP
> +		/*
> +		 * Must fix up SMP locks pointers pointing into overwritten
> +		 * code, and should fix up SMP locks pointers pointing into
> +		 * replacement code (as those would otherwise not take effect).
> +		 */
> +		if (smp_start) {
> +			u8 **ptr;
> +
> +			for (ptr = smp_start; ptr < smp_end; ptr++) {
> +				if (*ptr >= instr && *ptr < instr + a->instrlen) {
> +					DPRINTK("invalidating smp lock @ %p\n", *ptr);
> +					*ptr = NULL;
> +				}
> +				if (*ptr >= a->replacement
> +				    && *ptr < a->replacement + a->replacementlen) {
> +					DPRINTK("relocating smp lock %p -> %p\n",
> +						*ptr, *ptr + (instr - a->replacement));
> +					*ptr += instr - a->replacement;
> +				}
> +			}
> +		}
> +#endif
>  	}
>  }
>  
> @@ -440,7 +465,8 @@ void __init alternative_instructions(voi
>  	 * patching.
>  	 */
>  
> -	apply_alternatives(__alt_instructions, __alt_instructions_end);
> +	apply_alternatives(__alt_instructions, __alt_instructions_end,
> +			   __smp_locks, __smp_locks_end);
>  
>  	/* switch to patch-once-at-boottime-only mode and free the
>  	 * tables in case we know the number of CPUs will never ever
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/cpu/hypervisor.c
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/cpu/hypervisor.c
> @@ -25,6 +25,15 @@
>  #include <asm/vmware.h>
>  #include <asm/hypervisor.h>
>  
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +#include <linux/cache.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +void (*__read_mostly virt_spin_lock)(volatile struct arch_spinlock *, unsigned int);
> +void (*__read_mostly virt_spin_unlock)(volatile struct arch_spinlock *, unsigned int);
> +EXPORT_SYMBOL(virt_spin_unlock_stub);
> +#endif
> +
>  static inline void __cpuinit
>  detect_hypervisor_vendor(struct cpuinfo_x86 *c)
>  {
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/module.c
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/module.c
> @@ -208,6 +208,7 @@ int module_finalize(const Elf_Ehdr *hdr,
>  	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
>  		*para = NULL;
>  	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> +	void *lseg;
>  
>  	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
>  		if (!strcmp(".text", secstrings + s->sh_name))
> @@ -220,13 +221,14 @@ int module_finalize(const Elf_Ehdr *hdr,
>  			para = s;
>  	}
>  
> +	lseg = locks && text ? (void *)locks->sh_addr : NULL;
>  	if (alt) {
>  		/* patch .altinstructions */
>  		void *aseg = (void *)alt->sh_addr;
> -		apply_alternatives(aseg, aseg + alt->sh_size);
> +		apply_alternatives(aseg, aseg + alt->sh_size,
> +				   lseg, lseg ? lseg + locks->sh_size : NULL);
>  	}
> -	if (locks && text) {
> -		void *lseg = (void *)locks->sh_addr;
> +	if (lseg) {
>  		void *tseg = (void *)text->sh_addr;
>  		alternatives_smp_module_add(me, me->name,
>  					    lseg, lseg + locks->sh_size,
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/lib/thunk_32.S
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/lib/thunk_32.S
> @@ -45,3 +45,34 @@
>  	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
>  	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
>  #endif
> +
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +#include <asm/dwarf2.h>
> +	.macro virt_spin_stub what, _stub=_stub
> +ENTRY(virt_spin_\what\_stub)
> +	CFI_STARTPROC simple
> +	CFI_DEF_CFA esp, 16
> +	CFI_OFFSET eip, -4
> +	CFI_OFFSET ebp, -8
> +	movl	%edx, (%esp)			# don't need this return address
> +	movl	4(%esp), %edx			# token
> +	movl	%eax, 4(%esp)
> +	movl	%ebp, %eax			# lock pointer
> +	movl	8(%esp), %ebp
> +	CFI_RESTORE ebp
> +	movl	%ecx, 8(%esp)
> +	call	*virt_spin_\what
> +	popl	%edx
> +	CFI_ADJUST_CFA_OFFSET -4
> +	popl	%eax
> +	CFI_ADJUST_CFA_OFFSET -4
> +	popl	%ecx
> +	CFI_ADJUST_CFA_OFFSET -4
> +	ret
> +	CFI_ENDPROC
> +ENDPROC(virt_spin_\what\_stub)
> +	.endm
> +virt_spin_stub lock
> +virt_spin_stub unlock
> +	.purgem virt_spin_stub
> +#endif
> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/lib/thunk_64.S
> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/lib/thunk_64.S
> @@ -79,3 +79,57 @@ restore_norax:	
>  	RESTORE_ARGS 1
>  	ret
>  	CFI_ENDPROC
> +
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	.text
> +	.macro virt_spin_stub what, _stub=_stub
> +ENTRY(virt_spin_\what\_stub)
> +	CFI_STARTPROC simple
> +	CFI_DEF_CFA rsp, 32
> +	CFI_OFFSET rip, -8
> +	CFI_OFFSET rbp, -16
> +	movq	%rsi, (%rsp)			# don't need this return address
> +	movl	8(%rsp), %esi			# token
> +	movq	%rdi, 8(%rsp)
> +	movq	%rbp, %rdi			# lock pointer
> +	movq	16(%rsp), %rbp
> +	movq	%rax, 16(%rsp)
> +	pushq	%rcx
> +	CFI_ADJUST_CFA_OFFSET 8
> +	pushq	%rdx
> +	CFI_ADJUST_CFA_OFFSET 8
> +	pushq	%r8
> +	CFI_ADJUST_CFA_OFFSET 8
> +	pushq	%r9
> +	CFI_ADJUST_CFA_OFFSET 8
> +	pushq	%r10
> +	CFI_ADJUST_CFA_OFFSET 8
> +	pushq	%r11
> +	CFI_ADJUST_CFA_OFFSET 8
> +	call	*virt_spin_\what(%rip)
> +	popq	%r11
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%r10
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%r9
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%r8
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%rdx
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%rcx
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%rsi
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%rdi
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq	%rax
> +	CFI_ADJUST_CFA_OFFSET -8
> +	ret
> +	CFI_ENDPROC
> +ENDPROC(virt_spin_\what\_stub)
> +	.endm
> +virt_spin_stub lock
> +virt_spin_stub unlock
> +	.purgem virt_spin_stub
> +#endif
> 
> 

