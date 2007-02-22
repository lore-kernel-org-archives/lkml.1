Return-Path: <linux-kernel-owner+w=401wt.eu-S1750830AbXBVLWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830AbXBVLWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXBVLWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:22:05 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:6258 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXBVLWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:22:02 -0500
Date: Thu, 22 Feb 2007 12:20:40 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [POWERPC] Mask 32-bit system call arguments to 32 bits on PPC64 in audit code
Message-ID: <20070222112040.GB7916@osiris.boeblingen.de.ibm.com>
References: <200702081859.l18IxGWm000454@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702081859.l18IxGWm000454@hera.kernel.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:59:16PM +0000, Linux Kernel Mailing List wrote:
> Commit:     cfcd1705b61ecce1ab102b9593cf733fef314a19
> Parent:     0e47e3cca100e7c8e8124378e4e44969c2e042fd
> Author:     David Woodhouse <dwmw2@infradead.org>
> AuthorDate: Sun Jan 14 09:38:18 2007 +0800
> Committer:  Paul Mackerras <paulus@samba.org>
> CommitDate: Wed Jan 24 21:13:58 2007 +1100
>  
>     [POWERPC] Mask 32-bit system call arguments to 32 bits on PPC64 in audit code
>     
>     The system call entry code will clear the high bits of argument
>     registers before invoking the system call; don't report whatever noise
>     happens to be in the high bits of the register before that happens.
>     
>     Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/kernel/ptrace.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
>  
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 975102a..cc44c7b 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -532,16 +532,22 @@ void do_syscall_trace_enter(struct pt_regs *regs)
>  	    && (current->ptrace & PT_PTRACED))
>  		do_syscall_trace();
>  
> -	if (unlikely(current->audit_context))
> -		audit_syscall_entry(
> -#ifdef CONFIG_PPC32
> -				    AUDIT_ARCH_PPC,
> -#else
> -				    test_thread_flag(TIF_32BIT)?AUDIT_ARCH_PPC:AUDIT_ARCH_PPC64,
> +	if (unlikely(current->audit_context)) {
> +#ifdef CONFIG_PPC64
> +		if (!test_thread_flag(TIF_32BIT))
> +			audit_syscall_entry(AUDIT_ARCH_PPC64,
> +					    regs->gpr[0],
> +					    regs->gpr[3], regs->gpr[4],
> +					    regs->gpr[5], regs->gpr[6]);
> +		else
>  #endif
> -				    regs->gpr[0],
> -				    regs->gpr[3], regs->gpr[4],
> -				    regs->gpr[5], regs->gpr[6]);
> +			audit_syscall_entry(AUDIT_ARCH_PPC,
> +					    regs->gpr[0],
> +					    regs->gpr[3] & 0xffffffff,
> +					    regs->gpr[4] & 0xffffffff,
> +					    regs->gpr[5] & 0xffffffff,
> +					    regs->gpr[6] & 0xffffffff);
> +	}
>  }
>  
>  void do_syscall_trace_leave(struct pt_regs *regs)

Why is this needed? The audit code is not supposed to look at the high bits
if the audited task is a compat task.
It does that at at least one place in kernel/auditsc.c:

	case 4: /* socketcall */
		return ((mask & AUDIT_PERM_WRITE) && ctx->argv[0] == SYS_BIND);

So does the audit code assume that the high bits are cleared or is this
a bug in the audit code?

-- 
Heiko Carstens
Linux on System z Development

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Johann Weihen
Geschaeftsfuehrung : Herbert Kircher
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
