Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbYI3GOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbYI3GOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI3GOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:14:32 -0400
Received: from gw.goop.org ([64.81.55.164]:50635 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYI3GOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:14:32 -0400
Message-ID: <48E1C3BD.5020705@goop.org>
Date: Mon, 29 Sep 2008 23:14:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
References: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
In-Reply-To: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> The flag_is_changeable_p() is used by
> has_cpuid_p() which can return different results
> in the code sequence below:
>
>  if (!have_cpuid_p())
>       identify_cpu_without_cpuid(c);
>
>   /* cyrix could have cpuid enabled via c_identify()*/
>   if (!have_cpuid_p())
>       return;
>
> Otherwise, the gcc 3.4.6 optimizes these two calls
> into one which make the code not working correctly.
> Cyrix cpus have the CPUID instruction enabled but
> it is not detected due to the gcc optimization.
> Thus the ARR registers (mtrr like) are not detected
> on such a cpu.
>   

If "asm volatile" changes the code and fixes the bug, it seems like
you're making use of an undocumented - or at least non-portable - behaviour.

Does adding a "memory" clobber also fix the problem?  That would have
better defined characteristics.

    J

> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>
> I have tested the 6x86MX cpu with the CPUID
> disabled. I have used linux-next tree (20080819)
> and Yinghai Lu's patch:
>
> x86: identify_cpu_without_cpuid v2
>
> http://marc.info/?l=linux-kernel&m=122138380004347&w=2
>
> The patch below is required to make the patch
> above working correctly.
>
> diff -urp linux-orig/arch/x86/kernel/cpu/common.c linux-2.6.27/arch/x86/kernel/cpu/common.c
> --- linux-orig/arch/x86/kernel/cpu/common.c	2008-09-29 07:11:54.000000000 +0200
> +++ linux-2.6.27/arch/x86/kernel/cpu/common.c	2008-09-29 18:07:27.667392725 +0200
> @@ -124,18 +124,18 @@ static inline int flag_is_changeable_p(u
>  {
>  	u32 f1, f2;
>  
> -	asm("pushfl\n\t"
> -	    "pushfl\n\t"
> -	    "popl %0\n\t"
> -	    "movl %0,%1\n\t"
> -	    "xorl %2,%0\n\t"
> -	    "pushl %0\n\t"
> -	    "popfl\n\t"
> -	    "pushfl\n\t"
> -	    "popl %0\n\t"
> -	    "popfl\n\t"
> -	    : "=&r" (f1), "=&r" (f2)
> -	    : "ir" (flag));
> +	asm volatile ("pushfl\n\t"
> +		      "pushfl\n\t"
> +		      "popl %0\n\t"
> +		      "movl %0,%1\n\t"
> +		      "xorl %2,%0\n\t"
> +		      "pushl %0\n\t"
> +		      "popfl\n\t"
> +		      "pushfl\n\t"
> +		      "popl %0\n\t"
> +		      "popfl\n\t"
> +		      : "=&r" (f1), "=&r" (f2)
> +		      : "ir" (flag));
>  
>  	return ((f1^f2) & flag) != 0;
>  }
>
> ----------------------------------------------------------------------
> Dzwon taniej na zagraniczne komorki!
> Sprawdz >> http://link.interia.pl/f1f26 
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

