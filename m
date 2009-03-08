Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbZCHFCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbZCHFCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 00:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZCHFCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 00:02:03 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:28854 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZCHFCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 00:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pAJC9MVsInq+q0yQ6K+cImSKHdp1C76lielVhu7Yy5YMNw7fvfww9kWlf2zxiQ64Pw
         KP+IxZ4hU25ONrgq+t5rvv8uvPl62+CcSa5SF9lHMDWOcFU4MsWZhQBv2VrxzMR4I+QL
         D4RmUMjpaFQfXUacg3yqNxWjRO99kvhHZ2AI8=
MIME-Version: 1.0
In-Reply-To: <1236321988-19457-2-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
	 <1236321988-19457-2-git-send-email-tj@kernel.org>
Date: Sun, 8 Mar 2009 13:01:58 +0800
X-Google-Sender-Auth: 0379e2a6f490ee28
Message-ID: <386072610903072101o2b8c137ds19fc17760cce8816@mail.gmail.com>
Subject: Re: [PATCH 1/8] percpu: clean up percpu constants
From: Bryan Wu <cooloney@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 2:46 PM, Tejun Heo <tj@kernel.org> wrote:
> Impact: cleaup
>
> Make the following cleanups.
>
> * There isn't much arch-specific about PERCPU_MODULE_RESERVE.  Always
>  define it whether arch overrides PERCPU_ENOUGH_ROOM or not.
>
> * blackfin overrides PERCPU_ENOUGH_ROOM to align static area size.  Do
>  it by default.
>

Acked-by: Bryan Wu <cooloney@kernel.org>

Thanks
-Bryan

> * percpu allocation sizes doesn't have much to do with the page size.
>  Don't use PAGE_SHIFT in their definition.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bryan Wu <cooloney@kernel.org>
> ---
>  arch/blackfin/include/asm/percpu.h |   10 ----------
>  include/linux/percpu.h             |   24 +++++++++++++-----------
>  2 files changed, 13 insertions(+), 21 deletions(-)
>
> diff --git a/arch/blackfin/include/asm/percpu.h b/arch/blackfin/include/asm/percpu.h
> index 797c0c1..c94c7bc 100644
> --- a/arch/blackfin/include/asm/percpu.h
> +++ b/arch/blackfin/include/asm/percpu.h
> @@ -3,14 +3,4 @@
>
>  #include <asm-generic/percpu.h>
>
> -#ifdef CONFIG_MODULES
> -#define PERCPU_MODULE_RESERVE 8192
> -#else
> -#define PERCPU_MODULE_RESERVE 0
> -#endif
> -
> -#define PERCPU_ENOUGH_ROOM \
> -       (ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
> -        PERCPU_MODULE_RESERVE)
> -
>  #endif /* __ARCH_BLACKFIN_PERCPU__ */
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 545b068..2d34b03 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -5,6 +5,7 @@
>  #include <linux/slab.h> /* For kmalloc() */
>  #include <linux/smp.h>
>  #include <linux/cpumask.h>
> +#include <linux/pfn.h>
>
>  #include <asm/percpu.h>
>
> @@ -52,17 +53,18 @@
>  #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
>  #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
>
> -/* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
> -#ifndef PERCPU_ENOUGH_ROOM
> +/* enough to cover all DEFINE_PER_CPUs in modules */
>  #ifdef CONFIG_MODULES
> -#define PERCPU_MODULE_RESERVE  8192
> +#define PERCPU_MODULE_RESERVE          (8 << 10)
>  #else
> -#define PERCPU_MODULE_RESERVE  0
> +#define PERCPU_MODULE_RESERVE          0
>  #endif
>
> +#ifndef PERCPU_ENOUGH_ROOM
>  #define PERCPU_ENOUGH_ROOM                                             \
> -       (__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
> -#endif /* PERCPU_ENOUGH_ROOM */
> +       (ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) +      \
> +        PERCPU_MODULE_RESERVE)
> +#endif
>
>  /*
>  * Must be an lvalue. Since @var must be a simple identifier,
> @@ -79,7 +81,7 @@
>  #ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
>
>  /* minimum unit size, also is the maximum supported allocation size */
> -#define PCPU_MIN_UNIT_SIZE             (16UL << PAGE_SHIFT)
> +#define PCPU_MIN_UNIT_SIZE             PFN_ALIGN(64 << 10)
>
>  /*
>  * PERCPU_DYNAMIC_RESERVE indicates the amount of free area to piggy
> @@ -96,15 +98,15 @@
>  #ifndef PERCPU_DYNAMIC_RESERVE
>  #  if BITS_PER_LONG > 32
>  #    ifdef CONFIG_MODULES
> -#      define PERCPU_DYNAMIC_RESERVE   (6 << PAGE_SHIFT)
> +#      define PERCPU_DYNAMIC_RESERVE   (24 << 10)
>  #    else
> -#      define PERCPU_DYNAMIC_RESERVE   (4 << PAGE_SHIFT)
> +#      define PERCPU_DYNAMIC_RESERVE   (16 << 10)
>  #    endif
>  #  else
>  #    ifdef CONFIG_MODULES
> -#      define PERCPU_DYNAMIC_RESERVE   (4 << PAGE_SHIFT)
> +#      define PERCPU_DYNAMIC_RESERVE   (16 << 10)
>  #    else
> -#      define PERCPU_DYNAMIC_RESERVE   (2 << PAGE_SHIFT)
> +#      define PERCPU_DYNAMIC_RESERVE   (8 << 10)
>  #    endif
>  #  endif
>  #endif /* PERCPU_DYNAMIC_RESERVE */
> --
> 1.6.0.2
>
>
