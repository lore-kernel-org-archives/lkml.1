Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0BNX3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:29:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:39929 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab0BNX3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:29:52 -0500
Subject: Re: [PATCH 18/28] powerpc,kgdb: Introduce low level trap catching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1266014143-29444-19-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	 <1266014143-29444-19-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 10:29:27 +1100
Message-ID: <1266190167.16346.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 16:35 -0600, Jason Wessel wrote:

> @@ -115,7 +116,9 @@ void kgdb_roundup_cpus(unsigned long flags)
>  /* KGDB functions to use existing PowerPC64 hooks. */
>  static int kgdb_debugger(struct pt_regs *regs)
>  {
> -	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
> +	if (kgdb_handle_exception(1, computeSignal(TRAP(regs)), DIE_OOPS, regs))
> +		return 0;
> +	return 1;
>  }

I'm no fan of logic inversions like that but I suppose you are trying to
fit into existing hooks. However, I'd rather then do:

	return !kgdb...


>  static int kgdb_handle_breakpoint(struct pt_regs *regs)
> @@ -123,7 +126,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  	if (user_mode(regs))
>  		return 0;
>  
> -	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
> +	if (kgdb_handle_exception(1, SIGTRAP, 0, regs) != 0)
>  		return 0;
>  
>  	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index d069ff8..379104a 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -809,12 +809,19 @@ void __kprobes program_check_exception(struct pt_regs *regs)
>  		return;
>  	}
>  	if (reason & REASON_TRAP) {
> +
> +#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
> +		if (debugger_bpt(regs))
> +			return;
> +#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
>  		/* trap exception */
>  		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
>  				== NOTIFY_STOP)
>  			return;
> +#ifndef CONFIG_KGDB_LOW_LEVEL_TRAP
>  		if (debugger_bpt(regs))
>  			return;
> +#endif /* ! CONFIG_KGDB_LOW_LEVEL_TRAP */
>  
>  		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
>  		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> index 0a0e049..2b1601b 100644
> --- a/lib/Kconfig.kgdb
> +++ b/lib/Kconfig.kgdb
> @@ -59,7 +59,7 @@ config KGDB_TESTS_BOOT_STRING
>  
>  config KGDB_LOW_LEVEL_TRAP
>         bool "KGDB: Allow debugging with traps in notifiers"
> -       depends on X86
> +       depends on X86 || PPC
>         default n
>         help
>           This will add an extra call back to kgdb for the breakpoint

No firm objection, but it -is- a bit ugly... Should we just
unconditionally move the debugger_bpt() early on with a comment about
why we do so ? Is there any drawback you can think of ?

Cheers,
Ben.


