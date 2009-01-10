Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZAJWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZAJWgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZAJWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:36:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZAJWgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:36:35 -0500
Date: Sat, 10 Jan 2009 23:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [x86-64] remove locked instruction from switch_to()
Message-ID: <20090110223616.GB16719@elte.hu>
References: <20090110212625.GE13467@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110212625.GE13467@kvack.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin LaHaise <bcrl@kvack.org> wrote:

> The patch below removes an unnecessary locked instruction from 
> switch_to().  TIF_FORK is only ever set in copy_thread() on initial 
> process creation, and gets cleared during the first scheduling of the 
> process.  As such, it is safe to use an unlocked test for the flag 
> within switch_to()./
> 
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org
> 
> diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
> index 2ed3f0f..ee2e589 100644
> --- a/arch/x86/include/asm/system.h
> +++ b/arch/x86/include/asm/system.h
> @@ -96,15 +96,15 @@ do {									\
>  	     "thread_return:\n\t"					  \
>  	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
>  	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
> -	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
>  	     "movq %%rax,%%rdi\n\t" 					  \
> -	     "jc   ret_from_fork\n\t"					  \
> +	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"	  \
> +	     "jnz   ret_from_fork\n\t"					  \
>  	     RESTORE_CONTEXT						  \
>  	     : "=a" (last)					  	  \
>  	     : [next] "S" (next), [prev] "D" (prev),			  \
>  	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
>  	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
> -	       [tif_fork] "i" (TIF_FORK),			  	  \
> +	       [_tif_fork] "i" (_TIF_FORK),			  	  \
>  	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
>  	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
>  	     : "memory", "cc" __EXTRA_CLOBBER)
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b86f332..16b4587 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -247,6 +247,7 @@ ENTRY(native_usergs_sysret64)
>   */ 	
>  /* rdi:	prev */	
>  ENTRY(ret_from_fork)
> +	LOCK ; btr $TIF_FORK,TI_flags(%r8)
>  	CFI_DEFAULT_STACK

nice!

Small detail, it does not apply to latest -git cleanly:

 hunk #1 FAILED at 247.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/entry_64.S

Probably trivial - would you mind to repost?

	Ingo
