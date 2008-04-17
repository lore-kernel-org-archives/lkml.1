Return-Path: <linux-kernel-owner+w=401wt.eu-S934453AbYDQQ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbYDQQ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDQQ3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:29:45 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:64081 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719AbYDQQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:29:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloFAF8YB0hMROPA/2dsb2JhbACBYKtK
Date: Thu, 17 Apr 2008 12:29:32 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
Message-ID: <20080417162932.GA23351@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48063E19.9090701@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:07:27 up 48 days, 12:18,  4 users,  load average: 0.91, 0.32,
	0.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> "This way lies madness. Don't go there."
>>   
>
> It is a large amount of... stuff.  This immediate values thing makes a big 
> improvement then?
>

As ingo said : the nmi-safe traps and exception is not only usefu lto
immediate values, but also to oprofile. On top of that, the LTTng kernel
tracer has to write into vmalloc'd memory, so it's required there too.

For the immediate values, I doubt kernel developers will like the idea
of adding Kernel Markers in their code if it implies an added data cache
hit for every added marker. That's the problem immediate values solve.

>> Index: linux-2.6-lttng/include/linux/hardirq.h
>> ===================================================================
>> --- linux-2.6-lttng.orig/include/linux/hardirq.h	2008-04-16 
>> 11:25:18.000000000 -0400
>> +++ linux-2.6-lttng/include/linux/hardirq.h	2008-04-16 11:29:30.000000000 
>> -0400
>> @@ -22,10 +22,13 @@
>>   * PREEMPT_MASK: 0x000000ff
>>   * SOFTIRQ_MASK: 0x0000ff00
>>   * HARDIRQ_MASK: 0x0fff0000
>> + * HARDNMI_MASK: 0x40000000
>>   */
>>  #define PREEMPT_BITS	8
>>  #define SOFTIRQ_BITS	8
>>  +#define HARDNMI_BITS	1
>> +
>>  #ifndef HARDIRQ_BITS
>>  #define HARDIRQ_BITS	12
>>  @@ -45,16 +48,19 @@
>>  #define PREEMPT_SHIFT	0
>>  #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
>>  #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
>> +#define HARDNMI_SHIFT	(30)
>>   
>
> Why at 30, rather than HARDIRQ_SHIFT+HARDIRQ_BITS?
>

Because bit 28 (HARDIRQ_SHIFT+HARDIRQ_BITS) is used for the
PREEMPT_ACTIVE flag. I tried to find the bit the less used across the
various architectures.

>>   #define __IRQ_MASK(x)	((1UL << (x))-1)
>>   #define PREEMPT_MASK	(__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
>>  #define SOFTIRQ_MASK	(__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
>>  #define HARDIRQ_MASK	(__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
>> +#define HARDNMI_MASK	(__IRQ_MASK(HARDNMI_BITS) << HARDNMI_SHIFT)
>>   #define PREEMPT_OFFSET	(1UL << PREEMPT_SHIFT)
>>  #define SOFTIRQ_OFFSET	(1UL << SOFTIRQ_SHIFT)
>>  #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
>> +#define HARDNMI_OFFSET	(1UL << HARDNMI_SHIFT)
>>   #if PREEMPT_ACTIVE < (1 << (HARDIRQ_SHIFT + HARDIRQ_BITS))
>>  #error PREEMPT_ACTIVE is too low!
>> @@ -63,6 +69,7 @@
>>  #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
>>  #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
>>  #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
>> +#define hardnmi_count()	(preempt_count() & HARDNMI_MASK)
>>   /*
>>   * Are we doing bottom half or hardware interrupt processing?
>> @@ -71,6 +78,7 @@
>>  #define in_irq()		(hardirq_count())
>>  #define in_softirq()		(softirq_count())
>>  #define in_interrupt()		(irq_count())
>> +#define in_nmi()		(hardnmi_count())
>>   /*
>>   * Are we running in atomic context?  WARNING: this macro cannot
>> @@ -159,7 +167,19 @@ extern void irq_enter(void);
>>   */
>>  extern void irq_exit(void);
>>  -#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
>> -#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
>> +#define nmi_enter()					\
>> +	do {						\
>> +		lockdep_off();				\
>> +		BUG_ON(hardnmi_count());		\
>> +		add_preempt_count(HARDNMI_OFFSET);	\
>> +		__irq_enter();				\
>> +	} while (0)
>> +
>> +#define nmi_exit()					\
>> +	do {						\
>> +		__irq_exit();				\
>> +		sub_preempt_count(HARDNMI_OFFSET);	\
>> +		lockdep_on();				\
>> +	} while (0)
>>   #endif /* LINUX_HARDIRQ_H */
>> Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
>> ===================================================================
>> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2008-04-16 
>> 11:25:18.000000000 -0400
>> +++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2008-04-16 
>> 12:06:30.000000000 -0400
>> @@ -79,7 +79,6 @@ VM_MASK		= 0x00020000
>>  #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); 
>> TRACE_IRQS_OFF
>>  #else
>>  #define preempt_stop(clobbers)
>> -#define resume_kernel		restore_nocheck
>>  #endif
>>   .macro TRACE_IRQS_IRET
>> @@ -265,6 +264,8 @@ END(ret_from_exception)
>>  #ifdef CONFIG_PREEMPT
>>  ENTRY(resume_kernel)
>>  	DISABLE_INTERRUPTS(CLBR_ANY)
>> +	testl $0x40000000,TI_preempt_count(%ebp)	# nested over NMI ?
>> +	jnz return_to_nmi
>>  	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
>>  	jnz restore_nocheck
>>  need_resched:
>> @@ -276,6 +277,12 @@ need_resched:
>>  	call preempt_schedule_irq
>>  	jmp need_resched
>>  END(resume_kernel)
>> +#else
>> +ENTRY(resume_kernel)
>> +	testl $0x40000000,TI_preempt_count(%ebp)	# nested over NMI ?
>>   
>
> HARDNMI_MASK?
>

Will fix.

>> +	jnz return_to_nmi
>> +	jmp restore_nocheck
>> +END(resume_kernel)
>>  #endif
>>  	CFI_ENDPROC
>>  @@ -411,6 +418,22 @@ restore_nocheck_notrace:
>>  	CFI_ADJUST_CFA_OFFSET -4
>>  irq_return:
>>  	INTERRUPT_RETURN
>> +return_to_nmi:
>> +	testl $X86_EFLAGS_TF, PT_EFLAGS(%esp)
>> +	jnz restore_nocheck		/*
>> +					 * If single-stepping an NMI handler,
>> +					 * use the normal iret path instead of
>> +					 * the popf/lret because lret would be
>> +					 * single-stepped. It should not
>> +					 * happen : it will reactivate NMIs
>> +					 * prematurely.
>> +					 */
>> +	TRACE_IRQS_IRET
>> +	RESTORE_REGS
>> +	addl $4, %esp			# skip orig_eax/error_code
>> +	CFI_ADJUST_CFA_OFFSET -4
>> +	INTERRUPT_RETURN_NMI_SAFE
>> +
>>  .section .fixup,"ax"
>>  iret_exc:
>>  	pushl $0			# no error code
>> Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
>> ===================================================================
>> --- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2008-04-16 
>> 11:25:18.000000000 -0400
>> +++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2008-04-16 
>> 12:06:31.000000000 -0400
>> @@ -581,12 +581,27 @@ retint_restore_args:	/* return to kernel
>>  	 * The iretq could re-enable interrupts:
>>  	 */
>>  	TRACE_IRQS_IRETQ
>> +	testl $0x40000000,threadinfo_preempt_count(%rcx) /* Nested over NMI ? */
>>   
>
> HARDNMI_MASK?  (ditto below)
>

Will fix too.

>> +	jnz return_to_nmi
>>  restore_args:
>>  	RESTORE_ARGS 0,8,0
>>   irq_return:
>>  	INTERRUPT_RETURN
>>  +return_to_nmi:				/*
>> +					 * If single-stepping an NMI handler,
>> +					 * use the normal iret path instead of
>> +					 * the popf/lret because lret would be
>> +					 * single-stepped. It should not
>> +					 * happen : it will reactivate NMIs
>> +					 * prematurely.
>> +					 */
>> +	bt $8,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
>>   
>
> test[bwl] is a bit more usual; then you can use X86_EFLAGS_TF.
>

Ok. I tried to follow the coding style in entry_64.S, but I agree test
is more elegant. testw should be ok for 0x00000100.

>> +	jc restore_args
>> +	RESTORE_ARGS 0,8,0
>> +	INTERRUPT_RETURN_NMI_SAFE
>> +
>>  	.section __ex_table, "a"
>>  	.quad irq_return, bad_iret
>>  	.previous
>> @@ -802,6 +817,10 @@ END(spurious_interrupt)
>>  	.macro paranoidexit trace=1
>>  	/* ebx:	no swapgs flag */
>>  paranoid_exit\trace:
>> +	GET_THREAD_INFO(%rcx)
>> +	testl $0x40000000,threadinfo_preempt_count(%rcx) /* Nested over NMI ? */
>> +	jnz paranoid_return_to_nmi\trace
>> +paranoid_exit_no_nmi\trace:
>>  	testl %ebx,%ebx				/* swapgs needed? */
>>  	jnz paranoid_restore\trace
>>  	testl $3,CS(%rsp)
>> @@ -814,6 +833,18 @@ paranoid_swapgs\trace:
>>  paranoid_restore\trace:
>>  	RESTORE_ALL 8
>>  	jmp irq_return
>> +paranoid_return_to_nmi\trace:		/*
>> +					 * If single-stepping an NMI handler,
>> +					 * use the normal iret path instead of
>> +					 * the popf/lret because lret would be
>> +					 * single-stepped. It should not
>> +					 * happen : it will reactivate NMIs
>> +					 * prematurely.
>> +					 */
>> +	bt $8,EFLAGS-0(%rsp)		/* trap flag? */
>> +	jc paranoid_exit_no_nmi\trace
>> +	RESTORE_ALL 8
>> +	INTERRUPT_RETURN_NMI_SAFE
>>   
>
> Does this need to be repeated verbatim?
>

The comment : no, will fix. The code : yes, because the ARGOFFSET is
different.

>>  paranoid_userspace\trace:
>>  	GET_THREAD_INFO(%rcx)
>>  	movl threadinfo_flags(%rcx),%ebx
>> Index: linux-2.6-lttng/include/asm-x86/irqflags.h
>> ===================================================================
>> --- linux-2.6-lttng.orig/include/asm-x86/irqflags.h	2008-04-16 
>> 11:25:18.000000000 -0400
>> +++ linux-2.6-lttng/include/asm-x86/irqflags.h	2008-04-16 
>> 11:29:30.000000000 -0400
>> @@ -138,12 +138,73 @@ static inline unsigned long __raw_local_
>>   #ifdef CONFIG_X86_64
>>  #define INTERRUPT_RETURN	iretq
>> +
>> +/*
>> + * Only returns from a trap or exception to a NMI context 
>> (intra-privilege
>> + * level near return) to the same SS and CS segments. Should be used
>> + * upon trap or exception return when nested over a NMI context so no 
>> iret is
>> + * issued. It takes care of modifying the eflags, rsp and returning to 
>> the
>> + * previous function.
>> + *
>> + * The stack, at that point, looks like :
>> + *
>> + * 0(rsp)  RIP
>> + * 8(rsp)  CS
>> + * 16(rsp) EFLAGS
>> + * 24(rsp) RSP
>> + * 32(rsp) SS
>> + *
>> + * Upon execution :
>> + * Copy EIP to the top of the return stack
>> + * Update top of return stack address
>> + * Pop eflags into the eflags register
>> + * Make the return stack current
>> + * Near return (popping the return address from the return stack)
>> + */
>> +#define INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
>> +					pushq %rbx;		\
>> +					movq 40(%rsp), %rax;	\
>> +					movq 16(%rsp), %rbx;	\
>>   
>
> Use X+16(%rsp) notation here, so that the offsets correspond to the comment 
> above.
>

Ok.

>> +					subq $8, %rax;		\
>> +					movq %rbx, (%rax);	\
>> +					movq %rax, 40(%rsp);	\
>> +					popq %rbx;		\
>> +					popq %rax;		\
>> +					addq $16, %rsp;		\
>> +					popfq;			\
>> +					movq (%rsp), %rsp;	\
>> +					ret;			\
>>   
>
> How about something like
>
> 	pushq	%rax
> 	mov	%rsp, %rax		/* old stack */
> 	mov	24+8(%rax), %rsp	/* switch stacks */
> 	pushq	 0+8(%rax)		/* push return rip */
> 	pushq	16+8(%rax)		/* push return rflags */
> 	movq	(%rax), %rax		/* restore %rax */
> 	popfq				/* restore flags */
> 	ret				/* restore rip */
>

Yup, it looks nice, thanks.

>
>> +
>>  #define ENABLE_INTERRUPTS_SYSCALL_RET			\
>>  			movq	%gs:pda_oldrsp, %rsp;	\
>>  			swapgs;				\
>>  			sysretq;
>>  #else
>>  #define INTERRUPT_RETURN		iret
>> +
>> +/*
>> + * Protected mode only, no V8086. Implies that protected mode must
>> + * be entered before NMIs or MCEs are enabled. Only returns from a trap 
>> or
>> + * exception to a NMI context (intra-privilege level far return). Should 
>> be used
>> + * upon trap or exception return when nested over a NMI context so no 
>> iret is
>> + * issued.
>> + *
>> + * The stack, at that point, looks like :
>> + *
>> + * 0(esp) EIP
>> + * 4(esp) CS
>> + * 8(esp) EFLAGS
>> + *
>> + * Upon execution :
>> + * Copy the stack eflags to top of stack
>> + * Pop eflags into the eflags register
>> + * Far return: pop EIP and CS into their register, and additionally pop 
>> EFLAGS.
>> + */
>> +#define INTERRUPT_RETURN_NMI_SAFE	pushl 8(%esp);	\
>> +					popfl;		\
>> +					.byte 0xCA;	\
>> +					.word 4;
>>   
>
> Why not "lret $4"?
>

Because my punch card reader is broken ;)  will fix.

I'll repost a new version including these changes. We will have to
figure out a way to support PARAVIRT better than I currently do : a
PARAVIRT kernel running on bare metal still currently use iret. :(

Thanks for the review,

Mathieu
>    J
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
