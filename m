Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZHYJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZHYJDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZHYJDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:03:35 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40859 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZHYJDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TsdKCo7VwfyENSxoz9r6Z20JaNQAU8VNQGEHmlkhoWaCYMPAWIkug3ZxfA7gQSMh+y
         xqzFHcvulahDWA1MybPYdCGt85Hbzw2YuWi1aE3aJD6adVTR1A7P6ofmjS8fz5T7OHwZ
         bbSeEkkY2kSs0dBuEGgPEjvtryumy2BhnaEkA=
MIME-Version: 1.0
In-Reply-To: <1251190466.7261.12.camel@penberg-laptop>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu>
	 <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu>
	 <1251190466.7261.12.camel@penberg-laptop>
Date: Tue, 25 Aug 2009 11:03:35 +0200
Message-ID: <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized memory 
	(f6f6e1a4), by kmemleak's scan_block()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/25 Pekka Enberg <penberg@cs.helsinki.fi>:
> I thik this should be fine for -tip.
>
>                        Pekka
>
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index 2c55ed0..528bf95 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -331,6 +331,20 @@ static void kmemcheck_read_strict(struct pt_regs *regs,
>        kmemcheck_shadow_set(shadow, size);
>  }
>
> +bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
> +{
> +       enum kmemcheck_shadow status;
> +       void *shadow;
> +
> +       shadow = kmemcheck_shadow_lookup(addr);
> +       if (!shadow)
> +               return true;
> +
> +       status = kmemcheck_shadow_test(shadow, size);
> +
> +       return status == KMEMCHECK_SHADOW_INITIALIZED;
> +}
> +
>  /* Access may cross page boundary */
>  static void kmemcheck_read(struct pt_regs *regs,
>        unsigned long addr, unsigned int size)
> diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
> index 47b39b7..dc2fd54 100644
> --- a/include/linux/kmemcheck.h
> +++ b/include/linux/kmemcheck.h
> @@ -34,6 +34,8 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
>  int kmemcheck_show_addr(unsigned long address);
>  int kmemcheck_hide_addr(unsigned long address);
>
> +bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
> +
>  #else
>  #define kmemcheck_enabled 0
>
> @@ -99,6 +101,11 @@ static inline void kmemcheck_mark_initialized_pages(struct page *p,
>  {
>  }
>
> +static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
> +{
> +       return true;
> +}
> +
>  #endif /* CONFIG_KMEMCHECK */
>
>  /*
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 6debe0d..73947e4 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -97,6 +97,7 @@
>  #include <asm/processor.h>
>  #include <asm/atomic.h>
>
> +#include <linux/kmemcheck.h>
>  #include <linux/kmemleak.h>
>
>  /*
> @@ -951,6 +952,8 @@ static void scan_object(struct kmemleak_object *object)
>        if (!(object->flags & OBJECT_ALLOCATED))
>                /* already freed object */
>                goto out;
> +       if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
> +               goto out;
>        if (hlist_empty(&object->area_list)) {
>                void *start = (void *)object->pointer;
>                void *end = (void *)(object->pointer + object->size);
>
>
>


I don't know so much about the kmemleak internals, but this I can say
about the kmemcheck part: According to your definition, an object is
initialized if all the bytes of an object are initialized.

Is it possible that because of this, if we have a partially
uninitialized object, kmemleak will not record the pointers found in
that object? If so, it might skip valid pointers, and deem an object
unreferenced. Which could make kmemleak give false-positives.

I think it would be better to ask kmemcheck on a per-pointer basis
(i.e. for each pointer-sized word in the object), whether it is
initialized or not.


Vegard
