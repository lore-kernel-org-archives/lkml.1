Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXLRNwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXLRNwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXLRNvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:51:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbXLRNvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:51:54 -0500
Message-ID: <4767D02C.6030704@redhat.com>
Date: Tue, 18 Dec 2007 08:50:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] x86: add kprobe-booster to X86_64
References: <1197930464.23402.112.camel@brick>	 <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick>
In-Reply-To: <1197978160.7734.31.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Thank you for cleaning this up.

Harvey Harrison wrote:
> Subject: [PATCH] x86: kprobes leftover cleanups
> 
> Eliminate __always_inline, all of these static functions are
> only called once.  Minor whitespace cleanup.  Eliminate one
> supefluous return at end of void function.  Reverse sense of
> #ifndef to be #ifdef to show the case only affects X86_32.

Unfortunately, to prevent kprobe recursive call, all functions which
is called from kprobes must be inlined or have __kprobes.
If __always_inline macro still work, I prefer to use it. If not,
it must have a __kprobe attribute like as below.

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/kernel/kprobes.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 9aadd4d..1a0d96d 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -159,7 +159,7 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
>  const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
>  
>  /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
> -static __always_inline void set_jmp_op(void *from, void *to)
> +static void set_jmp_op(void *from, void *to)

+static void __kprobes set_jmp_op(void *from, void *to)

>  {
>  	struct __arch_jmp_op {
>  		char op;
> @@ -174,7 +174,7 @@ static __always_inline void set_jmp_op(void *from, void *to)
>   * Returns non-zero if opcode is boostable.
>   * RIP relative instructions are adjusted at copying time in 64 bits mode
>   */
> -static __always_inline int can_boost(kprobe_opcode_t *opcodes)
> +static int can_boost(kprobe_opcode_t *opcodes)

+static int __kprobes can_boost(kprobe_opcode_t *opcodes)


>  {
>  	kprobe_opcode_t opcode;
>  	kprobe_opcode_t *orig_opcodes = opcodes;
> @@ -392,13 +392,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
>  		kcb->kprobe_saved_flags &= ~IF_MASK;
>  }
>  
> -static __always_inline void clear_btf(void)
> +static void clear_btf(void)

+static void __kprobes clear_btf(void)

>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
>  }
>  
> -static __always_inline void restore_btf(void)
> +static void restore_btf(void)

+static void __kprobes restore_btf(void)

>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
> @@ -409,7 +409,7 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
>  	clear_btf();
>  	regs->flags |= TF_MASK;
>  	regs->flags &= ~IF_MASK;
> -	/*single step inline if the instruction is an int3*/
> +	/* single step inline if the instruction is an int3 */
>  	if (p->opcode == BREAKPOINT_INSTRUCTION)
>  		regs->ip = (unsigned long)p->addr;
>  	else
> @@ -767,7 +767,7 @@ static void __kprobes resume_execution(struct kprobe *p,
>  	case 0xe8:	/* call relative - Fix return addr */
>  		*tos = orig_ip + (*tos - copy_ip);
>  		break;
> -#ifndef CONFIG_X86_64
> +#ifdef CONFIG_X86_32
>  	case 0x9a:	/* call absolute -- same as call absolute, indirect */
>  		*tos = orig_ip + (*tos - copy_ip);
>  		goto no_change;
> @@ -813,8 +813,6 @@ static void __kprobes resume_execution(struct kprobe *p,
>  
>  no_change:
>  	restore_btf();
> -
> -	return;
>  }
>  
>  /*

Thanks again!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

