Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0BSQK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:10:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0BSQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:10:54 -0500
Message-ID: <4B7EB6EF.9010405@zytor.com>
Date: Fri, 19 Feb 2010 08:06:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
References: <4B743F7D.3090605@zytor.com> <20100212170649.GC3114@aftab> <4B758FC0.1020600@zytor.com> <20100212174751.GD3114@aftab> <4B75A66A.70005@zytor.com> <4B7BF5D6.3030701@suse.cz> <20100217172040.GC13429@aftab> <4B7C27D8.9050408@suse.cz> <4B7C29C1.10906@suse.cz> <20100218061923.GA1594@liondog.tnic> <20100219142205.GA32533@aftab>
In-Reply-To: <20100219142205.GA32533@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 06:22 AM, Borislav Petkov wrote:
> --- /dev/null
> +++ b/arch/x86/lib/hweight.c
> @@ -0,0 +1,62 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +
> +#ifdef CONFIG_64BIT
> +/* popcnt %rdi, %rax */
> +#define POPCNT ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc7"
> +#define REG_IN "D"
> +#define REG_OUT "a"
> +#else
> +/* popcnt %eax, %eax */
> +#define POPCNT ".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc0"
> +#define REG_IN "a"
> +#define REG_OUT "a"
> +#endif
> +
> +/*
> + * __sw_hweightXX are called from within the alternatives below
> + * and callee-clobbered registers need to be taken care of. See
> + * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
> + * compiler switches.
> + */
> +unsigned int __arch_hweight32(unsigned int w)
> +{
> +	unsigned int res = 0;
> +
> +	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
> +		     : "="REG_OUT (res)
> +		     : REG_IN (w));
> +
> +	return res;
> +}
> +EXPORT_SYMBOL(__arch_hweight32);
> +
> +unsigned int __arch_hweight16(unsigned int w)
> +{
> +	return __arch_hweight32(w & 0xffff);
> +}
> +EXPORT_SYMBOL(__arch_hweight16);
> +
> +unsigned int __arch_hweight8(unsigned int w)
> +{
> +	return __arch_hweight32(w & 0xff);
> +}
> +EXPORT_SYMBOL(__arch_hweight8);
> +
> +unsigned long __arch_hweight64(__u64 w)
> +{
> +	unsigned long res = 0;
> +
> +#ifdef CONFIG_X86_32
> +	return  __arch_hweight32((u32)w) +
> +		__arch_hweight32((u32)(w >> 32));
> +#else
> +	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
> +		     : "="REG_OUT (res)
> +		     : REG_IN (w));
> +#endif /* CONFIG_X86_32 */
> +
> +	return res;
> +}

You're still not inlining these.  They should be: there is absolutely no
reason for code size to not inline them anymore.

> diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
> index 3a7be84..1c82306 100644
> --- a/include/asm-generic/bitops/arch_hweight.h
> +++ b/include/asm-generic/bitops/arch_hweight.h
> @@ -3,9 +3,23 @@
>  
>  #include <asm/types.h>
>  
> -extern unsigned int __arch_hweight32(unsigned int w);
> -extern unsigned int __arch_hweight16(unsigned int w);
> -extern unsigned int __arch_hweight8(unsigned int w);
> -extern unsigned long __arch_hweight64(__u64 w);
> +unsigned int __arch_hweight32(unsigned int w)
> +{
> +	return __sw_hweight32(w);
> +}
>  
> +unsigned int __arch_hweight16(unsigned int w)
> +{
> +	return __sw_hweight16(w);
> +}
> +
> +unsigned int __arch_hweight8(unsigned int w)
> +{
> +	return __sw_hweight8(w);
> +}
> +
> +unsigned long __arch_hweight64(__u64 w)
> +{
> +	return __sw_hweight64(w);
> +}
>  #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */

and these are in a header file and *definitely* should be inlines.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

