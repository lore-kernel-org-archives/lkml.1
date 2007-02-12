Return-Path: <linux-kernel-owner+w=401wt.eu-S965355AbXBLWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355AbXBLWEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXBLWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:04:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965355AbXBLWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:04:22 -0500
Message-ID: <45D0E486.9020104@redhat.com>
Date: Mon, 12 Feb 2007 17:04:54 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jeff Dike <jdike@addtoit.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [12/29] x86_64: 32-bit ptrace mangles
 sixth system call argument
References: <20070212551.664370000@suse.de> <20070212165132.6518713F45@wotan.suse.de>
In-Reply-To: <20070212165132.6518713F45@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Jeff Dike <jdike@addtoit.com>
> The patch below copies %r9 (where the sixth argument has been
> stashed) into the RBP slot of pt_regs before syscall_trace_enter is
> called.  This fixes ptrace.
> 
> To allow a successful return to userspace, the original value of rbp
> must be restored.  This is done by storing the current value of rbp
> into the RBP slot of pt_regs before the RESTORE_REST.
> 
> --- linux.orig/arch/x86_64/ia32/ia32entry.S
> +++ linux/arch/x86_64/ia32/ia32entry.S
> @@ -148,11 +148,23 @@ sysenter_do_call:	
>  sysenter_tracesys:
>  	CFI_RESTORE_STATE
>  	SAVE_REST
> +	/*
> +	 * We need the 6th system call argument to be in regs->rbp at
> +	 * this point so that ptrace will see it.  It's in r9 now, so copy
> +	 * it to the rbp slot now.
> +	 */
> +	movq	%r9, RBP(%rsp)
>  	CLEAR_RREGS
>  	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
>  	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
>  	call	syscall_trace_enter
>  	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
> +	/*
> +	 * Now, we need the correct value of rbp to be restored.  It
> +	 * was never munged, so we can save it to the rbp slot and
> +	 * just have it restored.
> +	 */
> +	movq	%rbp, RBP(%rsp)
>  	RESTORE_REST
>  	movl	%ebp, %ebp
>  	/* no need to do an access_ok check here because rbp has been

Didn't we have problems with this exact approach before? This one was dropped
because it caused 32-bit programs to crash:
http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13/2.6.13-mm2/broken-out/x86-64-ptrace-ia32-bp-fix.patch

See:
	http://lkml.org/lkml/2005/09/16/261

for the one I proposed instead.

And in any case doesn't cstar_tracesys() need the same fix?

