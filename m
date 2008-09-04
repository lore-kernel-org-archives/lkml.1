Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYIDS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYIDS37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYIDS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:29:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2662 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYIDS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:29:51 -0400
Message-ID: <48C0291D.6060205@ct.jp.nec.com>
Date: Thu, 04 Sep 2008 11:29:49 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Rui Sousa <rui.p.m.sousa@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is
 not set
References: <200809031753.07292.rui.p.m.sousa@gmail.com> <20080904143918.GA28095@elte.hu> <48C0175B.3070500@ct.jp.nec.com> <200809041947.54339.rui.p.m.sousa@gmail.com>
In-Reply-To: <200809041947.54339.rui.p.m.sousa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Sousa wrote:
> On Thursday 4 September 2008 19:14, Hiroshi Shimamoto wrote:
>> Ingo Molnar wrote:
>>> * Rui Sousa <rui.p.m.sousa@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever
>>>> disabled (which is currently not allowed by Kconfig). Alternatively we
>>>> could just remove the option altogether and the associated code paths.
>>>> Since the compilation error has been in the tree for at least two
>>>> years and no one noticed it, I guess we don't really have the need for
>>>> CONFIG_TRACE_IRQFLAGS_SUPPORT=n. Boot tested on x86 UP.
>>> applied to tip/core/locking - thanks Rui.
>>>
>>> since you fixed it i prefer the fix over the removal. We could still
>>> remove the !TRACE_IRQFLAGS_SUPPORT now (in a separate commit) and
>>> simpify this header a bit that way. Thus if someone needs the
>>> !TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be
>>> restored via a simple revert.
>> Hi, it seems that this patch breaks uml build.
> 
> Hi Hiroshi,
> 
>> kernel/printk.c: In function 'vprintk':
>> kernel/printk.c:674: error: implicit declaration of function
>> 'raw_local_irq_save' kernel/printk.c:772: error: implicit declaration of
>> function 'raw_local_irq_restore'
> 
> With the patch bellow it compiles (make ARCH=um with a x86 host), but I'm 
> really out of my league on this one...

Hi Rui,

with this patch, build and boot (on my x86_64 box) looks ok.

I CC-ed to uml people to check this.

thanks,
Hiroshi Shimamoto

> 
>> thanks,
>> Hiroshi Shimamoto
> 
> Thanks,
> Rui
> 
> ---
> diff --git a/include/asm-um/system-generic.h b/include/asm-um/system-generic.h
> index 5bcfa35..f1ea4da 100644
> --- a/include/asm-um/system-generic.h
> +++ b/include/asm-um/system-generic.h
> @@ -4,15 +4,15 @@
>  #include "asm/arch/system.h"
>  
>  #undef switch_to
> -#undef local_irq_save
> -#undef local_irq_restore
> -#undef local_irq_disable
> -#undef local_irq_enable
> -#undef local_save_flags
> -#undef local_irq_restore
> -#undef local_irq_enable
> -#undef local_irq_disable
> -#undef local_irq_save
> +#undef raw_local_irq_save
> +#undef raw_local_irq_restore
> +#undef raw_local_irq_disable
> +#undef raw_local_irq_enable
> +#undef raw_local_save_flags
> +#undef raw_local_irq_restore
> +#undef raw_local_irq_enable
> +#undef raw_local_irq_disable
> +#undef raw_local_irq_save
>  #undef irqs_disabled
>  
>  extern void *switch_to(void *prev, void *next, void *last);
> @@ -23,21 +23,21 @@ extern int get_signals(void);
>  extern void block_signals(void);
>  extern void unblock_signals(void);
>  
> -#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
> +#define raw_local_save_flags(flags) do { typecheck(unsigned long, flags); \
>  				     (flags) = get_signals(); } while(0)
> -#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
> +#define raw_local_irq_restore(flags) do { typecheck(unsigned long, flags); \
>  				      set_signals(flags); } while(0)
>  
> -#define local_irq_save(flags) do { local_save_flags(flags); \
> -                                   local_irq_disable(); } while(0)
> +#define raw_local_irq_save(flags) do { raw_local_save_flags(flags); \
> +                                   raw_local_irq_disable(); } while(0)
>  
> -#define local_irq_enable() unblock_signals()
> -#define local_irq_disable() block_signals()
> +#define raw_local_irq_enable() unblock_signals()
> +#define raw_local_irq_disable() block_signals()
>  
>  #define irqs_disabled()                 \
>  ({                                      \
>          unsigned long flags;            \
> -        local_save_flags(flags);        \
> +        raw_local_save_flags(flags);        \
>          (flags == 0);                   \
>  })
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

