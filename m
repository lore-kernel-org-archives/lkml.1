Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZCWQjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZCWQjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZCWQiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:38:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47176 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZCWQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:38:53 -0400
Date: Mon, 23 Mar 2009 22:09:10 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [BUGFIX][PATCH -tip] x86: kretprobe-booster interrupt
	emulation code fix
Message-ID: <20090323163910.GB3858@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <49C7995C.2010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C7995C.2010601@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:14:52AM -0400, Masami Hiramatsu wrote:
> Fix interrupt emulation code in kretprobe-booster according to
> pt_regs update (es/ds change and gs adding).
> 
> This issue has been reported on systemtap-bugzilla:
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=9965

Do you want to put some of the details from the bugzilla entry
to this patch description so that one is not forced to look
at the bugzilla in future when git log is done ?

> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  arch/x86/kernel/kprobes.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 55b9461..64dba72 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -638,13 +638,13 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
>  #else
>  			"	pushf\n"
>  			/*
> -			 * Skip cs, ip, orig_ax.
> +			 * Skip cs, ip, orig_ax and gs.
>  			 * trampoline_handler() will plug in these values
>  			 */
> -			"	subl $12, %esp\n"
> +			"	subl $16, %esp\n"
>  			"	pushl %fs\n"
> -			"	pushl %ds\n"
>  			"	pushl %es\n"
> +			"	pushl %ds\n"
>  			"	pushl %eax\n"
>  			"	pushl %ebp\n"
>  			"	pushl %edi\n"
> @@ -655,10 +655,10 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
>  			"	movl %esp, %eax\n"
>  			"	call trampoline_handler\n"
>  			/* Move flags to cs */
> -			"	movl 52(%esp), %edx\n"
> -			"	movl %edx, 48(%esp)\n"
> +			"	movl 56(%esp), %edx\n"
> +			"	movl %edx, 52(%esp)\n"
>  			/* Replace saved flags with true return address. */
> -			"	movl %eax, 52(%esp)\n"
> +			"	movl %eax, 56(%esp)\n"
>  			"	popl %ebx\n"
>  			"	popl %ecx\n"
>  			"	popl %edx\n"
> @@ -666,8 +666,8 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
>  			"	popl %edi\n"
>  			"	popl %ebp\n"
>  			"	popl %eax\n"
> -			/* Skip ip, orig_ax, es, ds, fs */
> -			"	addl $20, %esp\n"
> +			/* Skip ds, es, fs, gs, orig_ax and ip */
> +			"	addl $24, %esp\n"
>  			"	popf\n"
>  #endif
>  			"	ret\n");
> @@ -694,6 +694,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
>  #endif
>  	regs->ip = trampoline_address;
>  	regs->orig_ax = ~0UL;
> +	regs->gs = 0;
> 
>  	/*
>  	 * It is possible to have multiple instances associated with a given
> 

This change works for me. I no longer see "BUG: sleeping from invalid context"
messages with kretprobe after this change.

Regards,
Bharata.
