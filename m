Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYDJPoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYDJPoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYDJPnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:43:55 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:45626 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207AbYDJPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:43:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIGAOrR/UdMQWoK/2dsb2JhbACBXaoL
Date: Thu, 10 Apr 2008 11:43:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault
Message-ID: <20080410154351.GA14396@Krystal>
References: <20080410153800.GA13858@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080410153800.GA13858@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:42:37 up 41 days, 11:53,  6 users,  load average: 0.75, 0.97,
	0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I misspelled Andrew's email in the original mail. Sorry)

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Implements an alternative iret with popf and far return so trap and exception
> handlers can return to the NMI handler without issuing iret. iret would cause
> NMIs to be reenabled prematurely.
> 
> It allows placing immediate values (and therefore optimized trace_marks) in NMI
> code and accessing vmalloc'd memory, which allows executing module code or
> accessing vmapped or vmalloc'd areas from NMI context. This is very useful to
> tracers like LTTng.
> 
> This patch makes all faults, traps and exception safe to be called from NMI
> context *except* single-stepping, which requires iret to restore the TF (trap
> flag) and jump to the return address in a single instruction. Sorry, no kprobes
> support in NMI handlers because of this limitation.  We cannot single-step an
> NMI handler, because iret must set the TF flag and return back to the
> instruction to single-step in a single instruction. This cannot be emulated with
> popf/lret, because lret would be single-stepped. It does not apply to immediate
> values because they do not use single-stepping. This code detects if the TF
> flag is set and uses the iret path for single-stepping, even if it reactivates
> NMIs prematurely.
> 
> alpha and avr32 use the active count bit 31. This patch moves them to 28.
> 
> TODO : support paravirt ops.
> TODO : test x86_64
> TODO : test alpha and avr32 active count modification
> 
> tested on x86_32 (tests implemented in a separate patch) :
> - instrumented the return path to export the EIP, CS and EFLAGS values when
>   taken so we know the return path code has been executed.
> - trace_mark, using immediate values, with 10ms delay with the breakpoint
>   activated. Runs well through the return path.
> - tested vmalloc faults in NMI handler by placing a non-optimized marker in the
>   NMI handler (so no breakpoint is executed) and connecting a probe which
>   touches every pages of a 20MB vmalloc'd buffer. It executes trough the return
>   path without problem.
> 
> "This way lies madness. Don't go there."
> - Andi
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: akpm@osdl.org
> CC: mingo@elte.hu
> ---
>  arch/x86/kernel/entry_32.S      |    9 +++++++
>  arch/x86/kernel/entry_64.S      |    6 +++++
>  include/asm-alpha/thread_info.h |    2 -
>  include/asm-avr32/thread_info.h |    2 -
>  include/asm-x86/irqflags.h      |   48 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/hardirq.h         |   24 ++++++++++++++++++--
>  6 files changed, 87 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/hardirq.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/hardirq.h	2008-04-09 19:17:37.000000000 -0400
> +++ linux-2.6-lttng/include/linux/hardirq.h	2008-04-09 21:24:03.000000000 -0400
> @@ -22,10 +22,13 @@
>   * PREEMPT_MASK: 0x000000ff
>   * SOFTIRQ_MASK: 0x0000ff00
>   * HARDIRQ_MASK: 0x0fff0000
> + * HARDNMI_MASK: 0x40000000
>   */
>  #define PREEMPT_BITS	8
>  #define SOFTIRQ_BITS	8
>  
> +#define HARDNMI_BITS	1
> +
>  #ifndef HARDIRQ_BITS
>  #define HARDIRQ_BITS	12
>  
> @@ -45,16 +48,19 @@
>  #define PREEMPT_SHIFT	0
>  #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
>  #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
> +#define HARDNMI_SHIFT	(30)
>  
>  #define __IRQ_MASK(x)	((1UL << (x))-1)
>  
>  #define PREEMPT_MASK	(__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
>  #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
>  #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
> +#define HARDNMI_MASK	(__IRQ_MASK(HARDNMI_BITS) << HARDNMI_SHIFT)
>  
>  #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
>  #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
>  #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
> +#define HARDNMI_OFFSET	(1UL << HARDNMI_SHIFT)
>  
>  #if PREEMPT_ACTIVE < (1 << (HARDIRQ_SHIFT + HARDIRQ_BITS))
>  #error PREEMPT_ACTIVE is too low!
> @@ -63,6 +69,7 @@
>  #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
>  #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
>  #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
> +#define hardnmi_count()	(preempt_count() & HARDNMI_MASK)
>  
>  /*
>   * Are we doing bottom half or hardware interrupt processing?
> @@ -71,6 +78,7 @@
>  #define in_irq()		(hardirq_count())
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
> +#define in_nmi()		(hardnmi_count())
>  
>  /*
>   * Are we running in atomic context?  WARNING: this macro cannot
> @@ -159,7 +167,19 @@ extern void irq_enter(void);
>   */
>  extern void irq_exit(void);
>  
> -#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
> -#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
> +#define nmi_enter()					\
> +	do {						\
> +		lockdep_off();				\
> +		BUG_ON(hardnmi_count());		\
> +		add_preempt_count(HARDNMI_OFFSET);	\
> +		__irq_enter();				\
> +	} while (0)
> +
> +#define nmi_exit()					\
> +	do {						\
> +		__irq_exit();				\
> +		sub_preempt_count(HARDNMI_OFFSET);	\
> +		lockdep_on();				\
> +	} while (0)
>  
>  #endif /* LINUX_HARDIRQ_H */
> Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2008-04-09 19:21:08.000000000 -0400
> +++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2008-04-10 11:03:33.000000000 -0400
> @@ -265,6 +265,8 @@ END(ret_from_exception)
>  #ifdef CONFIG_PREEMPT
>  ENTRY(resume_kernel)
>  	DISABLE_INTERRUPTS(CLBR_ANY)
> +	testl $0x40000000,TI_preempt_count(%ebp)	# nested over NMI ?
> +	jnz return_to_nmi
>  	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
>  	jnz restore_nocheck
>  need_resched:
> @@ -411,6 +413,13 @@ restore_nocheck_notrace:
>  	CFI_ADJUST_CFA_OFFSET -4
>  irq_return:
>  	INTERRUPT_RETURN
> +return_to_nmi:
> +	TRACE_IRQS_IRET
> +	RESTORE_REGS
> +	addl $4, %esp			# skip orig_eax/error_code
> +	CFI_ADJUST_CFA_OFFSET -4
> +	INTERRUPT_RETURN_NMI_SAFE
> +
>  .section .fixup,"ax"
>  iret_exc:
>  	pushl $0			# no error code
> Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2008-04-09 19:21:08.000000000 -0400
> +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2008-04-09 21:01:19.000000000 -0400
> @@ -824,8 +824,14 @@ paranoid_swapgs\trace:
>  	.endif
>  	SWAPGS_UNSAFE_STACK
>  paranoid_restore\trace:
> +	GET_THREAD_INFO(%rcx)
> +	testl $0x40000000,threadinfo_preempt_count(%rcx) /* Nested over NMI ? */
> +	jnz return_to_nmi\trace
>  	RESTORE_ALL 8
>  	jmp irq_return
> +return_to_nmi\trace:
> +	RESTORE_ALL 8
> +	INTERRUPT_RETURN_NMI_SAFE
>  paranoid_userspace\trace:
>  	GET_THREAD_INFO(%rcx)
>  	movl threadinfo_flags(%rcx),%ebx
> Index: linux-2.6-lttng/include/asm-x86/irqflags.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-x86/irqflags.h	2008-04-09 19:17:37.000000000 -0400
> +++ linux-2.6-lttng/include/asm-x86/irqflags.h	2008-04-10 10:53:24.000000000 -0400
> @@ -138,12 +138,60 @@ static inline unsigned long __raw_local_
>  
>  #ifdef CONFIG_X86_64
>  #define INTERRUPT_RETURN	iretq
> +
> +/*
> + * Protected mode only, no V8086. Implies that protected mode must
> + * be entered before NMIs or MCEs are enabled. Only returns from a trap or
> + * exception to a NMI context (intra-privilege level return). Should be used
> + * upon trap or exception return when nested over a NMI context so no iret is
> + * issued.
> + *
> + * The stack, at that point, looks like :
> + *
> + * 0(esp)  EIP
> + * 8(esp)  CS
> + * 16(esp) EFLAGS
> + *
> + * Upon execution :
> + * Copy the stack eflags to top of stack
> + * Pop eflags into the eflags register
> + * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
> + */
> +#define INTERRUPT_RETURN_NMI_SAFE	pushl 16(%esp);	\
> +					popfl;		\
> +					.byte 0xCA;	\
> +					.word 8;
> +
>  #define ENABLE_INTERRUPTS_SYSCALL_RET			\
>  			movq	%gs:pda_oldrsp, %rsp;	\
>  			swapgs;				\
>  			sysretq;
>  #else
>  #define INTERRUPT_RETURN		iret
> +
> +/*
> + * Protected mode only, no V8086. Implies that protected mode must
> + * be entered before NMIs or MCEs are enabled. Only returns from a trap or
> + * exception to a NMI context (intra-privilege level return). Should be used
> + * upon trap or exception return when nested over a NMI context so no iret is
> + * issued.
> + *
> + * The stack, at that point, looks like :
> + *
> + * 0(esp) EIP
> + * 4(esp) CS
> + * 8(esp) EFLAGS
> + *
> + * Upon execution :
> + * Copy the stack eflags to top of stack
> + * Pop eflags into the eflags register
> + * Far return: pop EIP and CS into their register, and additionally pop EFLAGS.
> + */
> +#define INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
> +					popfl;		\
> +					.byte 0xCA;	\
> +					.word 4;
> +
>  #define ENABLE_INTERRUPTS_SYSCALL_RET	sti; sysexit
>  #define GET_CR0_INTO_EAX		movl %cr0, %eax
>  #endif
> Index: linux-2.6-lttng/include/asm-alpha/thread_info.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-alpha/thread_info.h	2008-04-09 20:02:09.000000000 -0400
> +++ linux-2.6-lttng/include/asm-alpha/thread_info.h	2008-04-09 20:02:46.000000000 -0400
> @@ -57,7 +57,7 @@ register struct thread_info *__current_t
>  
>  #endif /* __ASSEMBLY__ */
>  
> -#define PREEMPT_ACTIVE		0x40000000
> +#define PREEMPT_ACTIVE		0x10000000
>  
>  /*
>   * Thread information flags:
> Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2008-04-09 20:02:58.000000000 -0400
> +++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2008-04-09 20:03:07.000000000 -0400
> @@ -70,7 +70,7 @@ static inline struct thread_info *curren
>  
>  #endif /* !__ASSEMBLY__ */
>  
> -#define PREEMPT_ACTIVE		0x40000000
> +#define PREEMPT_ACTIVE		0x10000000
>  
>  /*
>   * Thread information flags
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
