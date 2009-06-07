Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFGH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFGH5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 03:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZFGH5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 03:57:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZFGH5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 03:57:00 -0400
Date: Sun, 7 Jun 2009 09:56:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Subject: Re: [PATCH] Fix non-lazy GS handling in sys_vm86()
Message-ID: <20090607075613.GA3962@elte.hu>
References: <1244312605.28613.4.camel@bimbo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244312605.28613.4.camel@bimbo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lubomir Rintel <lkundrak@v3.sk> wrote:

> This fixes a stack corruption panic or null dereference oops due to
> a bad GS in resume_userspace() when returning from sys_vm86() and calling
> lockdep_sys_exit().
> 
> Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR enabled.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  arch/x86/kernel/vm86_32.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
> index d7ac84e..177d976 100644
> --- a/arch/x86/kernel/vm86_32.c
> +++ b/arch/x86/kernel/vm86_32.c
> @@ -287,10 +287,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
>  	info->regs.pt.ds = 0;
>  	info->regs.pt.es = 0;
>  	info->regs.pt.fs = 0;
> -
> -/* we are clearing gs later just before "jmp resume_userspace",
> - * because it is not saved/restored.
> - */
> +#ifndef CONFIG_X86_32_LAZY_GS
> +	info->regs.pt.gs = 0;
> +#endif
>  
>  /*
>   * The flags register is also special: we cannot trust that the user
> @@ -343,10 +342,12 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
>  	__asm__ __volatile__(
>  		"movl %0,%%esp\n\t"
>  		"movl %1,%%ebp\n\t"
> -		"mov  %2, %%gs\n\t"
> +#ifdef CONFIG_X86_32_LAZY_GS
> +		"mov  $0, %%gs\n\t"
> +#endif

That bit looks rather untested - i dont think there's an immediate 
constant instruction variant for segment register moves ...

	Ingo
