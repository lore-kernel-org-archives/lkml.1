Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXL3Gie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXL3Gie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 01:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXL3GiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 01:38:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXL3GiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 01:38:24 -0500
Message-ID: <47773C2D.8070600@redhat.com>
Date: Sun, 30 Dec 2007 01:35:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
References: <1198466795.6323.12.camel@brick>
In-Reply-To: <1198466795.6323.12.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> Fold some small ifdefs into a helper function.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Masami, Ingo, I had this left in some unsent kprobes unification
> work.  Depends on your tastes, but does reduce ifdefs and is a bit
> better about self-documenting the REX prefix on X86_64.

Basically, I think it is good idea.
Could you use a macro same as the stack_addr() macro, like as below?

#defile is_REX_prefix(insn) ((insn & 0xf0) == 0x40))

This is just a bit checker, so I think a macro is better to do that.

> If I find places that could also use this I'll try to find a suitable
> header any stick a static inline there instead.  Otherwise static to
> kprobes.c is probably more appropriate for now.
> 
>  arch/x86/kernel/kprobes.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 4e33329..b1804e4 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -171,6 +171,19 @@ static void __kprobes set_jmp_op(void *from, void *to)
>  }
>  
>  /*
> + * Check for the REX prefix which can only exist on X86_64
> + * X86_32 always returns 0
> + */
> +static int __kprobes is_REX_prefix(kprobe_opcode_t *insn)
> +{
> +#ifdef CONFIG_X86_64
> +	if ((*insn & 0xf0) == 0x40)
> +		return 1;
> +#endif
> +	return 0;
> +}
> +
> +/*
>   * Returns non-zero if opcode is boostable.
>   * RIP relative instructions are adjusted at copying time in 64 bits mode
>   */
> @@ -239,14 +252,14 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
>  	case 0x9d:		/* popf/popfd */
>  		return 1;
>  	}
> -#ifdef CONFIG_X86_64
> +
>  	/*
> -	 * on 64 bit x86, 0x40-0x4f are prefixes so we need to look
> +	 * on X86_64, 0x40-0x4f are REX prefixes so we need to look
>  	 * at the next byte instead.. but of course not recurse infinitely
>  	 */
> -	if (*insn  >= 0x40 && *insn <= 0x4f)
> +	if (is_REX_prefix(insn))
>  		return is_IF_modifier(++insn);
> -#endif
> +
>  	return 0;
>  }
>  
> @@ -284,7 +297,7 @@ static void __kprobes fix_riprel(struct kprobe *p)
>  	}
>  
>  	/* Skip REX instruction prefix.  */
> -	if ((*insn & 0xf0) == 0x40)
> +	if (is_REX_prefix(insn))
>  		++insn;
>  
>  	if (*insn == 0x0f) {
> @@ -748,11 +761,9 @@ static void __kprobes resume_execution(struct kprobe *p,
>  	unsigned long orig_ip = (unsigned long)p->addr;
>  	kprobe_opcode_t *insn = p->ainsn.insn;
>  
> -#ifdef CONFIG_X86_64
>  	/*skip the REX prefix*/
> -	if (*insn >= 0x40 && *insn <= 0x4f)
> +	if (is_REX_prefix(insn))
>  		insn++;
> -#endif
>  
>  	regs->flags &= ~X86_EFLAGS_TF;
>  	switch (*insn) {

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


