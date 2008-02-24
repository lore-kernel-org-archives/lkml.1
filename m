Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYBXDFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYBXDFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBXDFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:05:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYBXDFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:05:42 -0500
Date: Sat, 23 Feb 2008 22:04:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86,fpu: split FPU state from task struct
Message-ID: <20080224030442.GA7282@infradead.org>
References: <20080224023547.264625000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224023547.264625000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 06:34:38PM -0800, Suresh Siddha wrote:
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

This sounds like a wonderful idea.  But I'm a little unhappy with
some of the rather cosmetic things in this patch:

>  	if (next_p->fpu_counter>5)
> -		prefetch(&next->i387.fxsave);
> +		prefetch(FXSAVE(next_p));

These macros are rather ugly.  If you really want them please

	a) make them inlines and lowercase with a descriptive name
	b) introduce them in a separate patch before the first real
	   path in the series.

> +++ linux-2.6-x86/kernel/fork.c	2008-02-23 15:08:53.000000000 -0800
> @@ -87,6 +87,7 @@
>  #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
>  # define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
>  # define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
> +# define memcpy_task_struct(dst, src) do { *dst = *src; } while (0)
>  static struct kmem_cache *task_struct_cachep;
>  #endif
>  
> @@ -142,6 +143,8 @@
>  	task_struct_cachep =
>  		kmem_cache_create("task_struct", sizeof(struct task_struct),
>  			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
> +#else
> + 	task_struct_slab_init();
>  #endif
>  
>  	/*
> @@ -181,7 +184,8 @@
>  		return NULL;
>  	}
>  
> -	*tsk = *orig;
> + 	memcpy_task_struct(tsk, orig);

I think this is a bad name for this helper, arch_dup_task_struct
would be more descriptive.

But we actually have an arch hook for this kind of thing called
setup_thread_stack which is used by ia64 and m68k just a few lines
later, so it'd be better to look into having a single hook.
(And possibly rename it to arch_dup_task_struct because the name
is a lot more descriptive)
setup_thread_stack

> +		memset(FSAVE(tsk), 0, math_cntxt_size);
> +		FSAVE(tsk)->cwd = 0xffff037fu;
> +		FSAVE(tsk)->swd = 0xffff0000u;
> +		FSAVE(tsk)->twd = 0xffffffffu;
> +		FSAVE(tsk)->fos = 0xffff0000u;

Also if you reference the save area so often it'd be better to just
have a local variable for it.  Much better readable.

> +struct task_struct * alloc_task_struct(void)

this should be struct task_struct *alloc_task_struct(void)

> +void free_task_struct(struct task_struct *tsk)
> +{
> +	kmem_cache_free(task_cntxt_cachep, tsk->thread.cntxt);
> +	tsk->thread.cntxt=NULL;

missing spaces around the '='

> -#define I387			(current->thread.i387)
> -#define FPU_info		(I387.soft.info)
> +#define I387			(current->thread.cntxt)
> +#define FPU_info		(I387->soft.info)
> +#define SOFT(t)			(&(t->thread.cntxt->soft))

This is quite butt ugly.  But then again it's fpemu, so there's
probably no point touching it until a bored janitor comes around.

