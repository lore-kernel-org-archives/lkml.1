Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYCKFIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYCKFIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYCKFIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:08:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYCKFIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mqaMe7HAm8exGxO3jJOofQbJ4TiDcB6QDIDSC0svmNZ/J67g0pVij4aQD3/sY38bdP+VnZ3u/jEFifldF4ug+f2z1AlvJu32JMyPBbCtI2pvhPnEfDxrmI2xSpZL2JKbAjvzlOyfeOuF9fa526kC7wWm5bFnhcUN2YZHaj3JPT4=
Date: Tue, 11 Mar 2008 08:07:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v5
Message-ID: <20080311050644.GB4589@martell.zuzino.mipt.ru>
References: <20080310222955.565902000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310222955.565902000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 03:28:04PM -0700, Suresh Siddha wrote:
> Split the FPU save area from the task struct. This allows easy migration
> of FPU context, and it's generally cleaner. It also allows the following
> two optimizations:
> 
> 1) only allocate when the application actually uses FPU, so in the first
> lazy FPU trap. This could save memory for non-fpu using apps. Next patch
> does this lazy allocation.
> 
> 2) allocate the right size for the actual cpu rather than 512 bytes always.
> Patches enabling xsave/xrstor support (coming shortly) will take advantage
> of this.

Ugh, not seeing patch, but judging from description it will make
"choose wrong CONFIG_M* and fxsave will corrupt random FPU state" situation
likely?

> --- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
> +++ linux-2.6-x86/arch/x86/kernel/process_64.c
> @@ -634,7 +634,7 @@
>  
>  	/* we're going to use this soon, after a few expensive things */
>  	if (next_p->fpu_counter>5)
> -		prefetch(&next->i387.fxsave);
> +		prefetch(next->xstate);

Can we please give it better name, like fpu_state? It's a member of
task_struct after all.

> --- linux-2.6-x86.orig/arch/x86/kernel/traps_64.c
> +++ linux-2.6-x86/arch/x86/kernel/traps_64.c
> @@ -1157,6 +1157,10 @@
>  #endif
>         
>  	/*
> +	 * initialize the per thread extended state:
> +	 */
> +        init_thread_xstate();

Useless comment after xstate renaming :)

> --- linux-2.6-x86.orig/kernel/fork.c
> +++ linux-2.6-x86/kernel/fork.c
> @@ -144,6 +148,9 @@
>  			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
>  #endif
>  
> +	/* do the arch specific task caches init */
> +	arch_task_cache_init();


Useless comment.

> --- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-03-07 10:24:09.000000000 -0800
> +++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-03-10 10:42:04.000000000 -0700
> @@ -61,10 +74,6 @@
>  void __cpuinit fpu_init(void)
>  {
>  	unsigned long oldcr0 = read_cr0();
> -	extern void __bad_fxsave_alignment(void);
> -
> -	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
> -		__bad_fxsave_alignment();

I think removal of such checks needs giving necessary alignment to cache.
Previously it worked because of __aligned((16)) and L1_CACHE_SHIFT
combo.

> Index: linux-2.6-x86/include/asm-x86/i387.h
> ===================================================================
> --- linux-2.6-x86.orig/include/asm-x86/i387.h	2008-03-07 10:24:11.000000000 -0800
> +++ linux-2.6-x86/include/asm-x86/i387.h	2008-03-10 10:42:04.000000000 -0700
> @@ -324,25 +323,25 @@
>  static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
>  {
>  	if (cpu_has_fxsr) {
> -		return tsk->thread.i387.fxsave.cwd;
> +		return tsk->thread.xstate->fxsave.cwd;
>  	} else {
> -		return (unsigned short)tsk->thread.i387.fsave.cwd;
> +		return (unsigned short) tsk->thread.xstate->fsave.cwd;
				      ^^^
>  	}
>  }
>  
>  static inline unsigned short get_fpu_swd(struct task_struct *tsk)
>  {
>  	if (cpu_has_fxsr) {
> -		return tsk->thread.i387.fxsave.swd;
> +		return tsk->thread.xstate->fxsave.swd;
>  	} else {
> -		return (unsigned short)tsk->thread.i387.fsave.swd;
> +		return (unsigned short) tsk->thread.xstate->fsave.swd;
				      ^^^

> --- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-03-07 10:24:11.000000000 -0800
> +++ linux-2.6-x86/include/asm-x86/processor.h	2008-03-10 10:42:04.000000000 -0700
> @@ -355,7 +355,7 @@
>  	u32			entry_eip;
>  };
>  
> -union i387_union {
> +union thread_xstate {

thread_fpu_state.

> Index: linux-2.6-x86/arch/x86/kernel/process.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-x86/arch/x86/kernel/process.c	2008-03-10 10:42:04.000000000 -0700
> +void free_thread_info(struct thread_info *ti)
> +{
> +	kmem_cache_free(task_xstate_cachep, ti->task->thread.xstate);
> +	ti->task->thread.xstate = NULL;
> +
> +	free_pages((unsigned long)(ti), get_order(THREAD_SIZE));

Uselesss ()			  ^  ^

