Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZHYJZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZHYJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZHYJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:25:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZHYJZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:25:26 -0400
Date: Tue, 25 Aug 2009 11:25:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090825092517.GD14003@elte.hu>
References: <20090825071959.GA25877@elte.hu> <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com> <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop> <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop> <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com> <1251191507.26351.0.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251191507.26351.0.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-08-25 at 11:03 +0200, Vegard Nossum wrote:
> > I don't know so much about the kmemleak internals, but this I can say
> > about the kmemcheck part: According to your definition, an object is
> > initialized if all the bytes of an object are initialized.
> > 
> > Is it possible that because of this, if we have a partially
> > uninitialized object, kmemleak will not record the pointers found in
> > that object? If so, it might skip valid pointers, and deem an object
> > unreferenced. Which could make kmemleak give false-positives.
> > 
> > I think it would be better to ask kmemcheck on a per-pointer basis
> > (i.e. for each pointer-sized word in the object), whether it is
> > initialized or not.
> 
> Yeah, makes sense.
> 
> 			Pekka
> 
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index 2c55ed0..528bf95 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -331,6 +331,20 @@ static void kmemcheck_read_strict(struct pt_regs *regs,
>  	kmemcheck_shadow_set(shadow, size);
>  }
>  
> +bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
> +{
> +	enum kmemcheck_shadow status;
> +	void *shadow;
> +
> +	shadow = kmemcheck_shadow_lookup(addr);
> +	if (!shadow)
> +		return true;
> +
> +	status = kmemcheck_shadow_test(shadow, size);
> +
> +	return status == KMEMCHECK_SHADOW_INITIALIZED;
> +}
> +
>  /* Access may cross page boundary */
>  static void kmemcheck_read(struct pt_regs *regs,
>  	unsigned long addr, unsigned int size)
> diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
> index 47b39b7..dc2fd54 100644
> --- a/include/linux/kmemcheck.h
> +++ b/include/linux/kmemcheck.h
> @@ -34,6 +34,8 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
>  int kmemcheck_show_addr(unsigned long address);
>  int kmemcheck_hide_addr(unsigned long address);
>  
> +bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
> +
>  #else
>  #define kmemcheck_enabled 0
>  
> @@ -99,6 +101,11 @@ static inline void kmemcheck_mark_initialized_pages(struct page *p,
>  {
>  }
>  
> +static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
> +{
> +	return true;
> +}
> +
>  #endif /* CONFIG_KMEMCHECK */
>  
>  /*
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 6debe0d..b075bf0 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -97,6 +97,7 @@
>  #include <asm/processor.h>
>  #include <asm/atomic.h>
>  
> +#include <linux/kmemcheck.h>
>  #include <linux/kmemleak.h>
>  
>  /*
> @@ -885,7 +886,8 @@ static void scan_block(void *_start, void *_end,
>  
>  	for (ptr = start; ptr < end; ptr++) {
>  		unsigned long flags;
> -		unsigned long pointer = *ptr;
> +		unsigned long pointer;
> +
>  		struct kmemleak_object *object;
>  
>  		if (allow_resched)
> @@ -893,6 +895,13 @@ static void scan_block(void *_start, void *_end,
>  		if (scan_should_stop())
>  			break;
>  
> +		/* Don't scan uninitialized memory. */
> +		if (!kmemcheck_is_obj_initialized((unsigned long) ptr,
> +							sizeof(unsigned long)))
> +			continue;

Nice. In fact this improves kmemleak efficiency as it reduces the 
amount of false negatives: we wont interpret a random old pointer in 
already-freed memory as a true 'reference'.

kmemcheck+kmemleak combo bootups might be Da Bomb of the future, in 
terms of testing ;-)

	Ingo
