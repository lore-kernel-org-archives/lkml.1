Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214Ab0AEXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0AEXEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639Ab0AEXEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:04:35 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:43957 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753286Ab0AEXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:04:34 -0500
Date: Tue, 5 Jan 2010 17:59:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 3/4] Optimized add_local()
Message-ID: <20100105225930.GD32584@Krystal>
References: <20100105220417.400092933@quilx.com> <20100105220439.030792114@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100105220439.030792114@quilx.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:57:32 up 20 days,  7:16,  5 users,  load average: 0.02, 0.10,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Use XADD to implement add_local().

xadd should only be used to implement add_local_return, not add_local.

add_local can be implemented with the "add" instruction, which is
significantly faster if my memory serves me correctly.

Thanks,

Mathieu

> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  arch/x86/include/asm/add-local.h |   56 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/include/asm/add-local.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/add-local.h	2010-01-05 15:29:11.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/add-local.h	2010-01-05 15:33:59.000000000 -0600
> @@ -1,2 +1,56 @@
> -#include <asm-generic/add-local.h>
> +#ifndef __ASM_X86_ADD_LOCAL_H
> +#define __ASM_X86_ADD_LOCAL_H
> +
> +#include <linux/types.h>
> +#include <asm-generic/add-local-generic.h>
> +
> +static inline unsigned long __add_return_local(volatile void *ptr,
> +		unsigned long value, int size)
> +{
> +	unsigned long r;
> +
> +#ifdef CONFIG_M386
> +	if (unlikely(boot_cpu_data.x86 <= 3))
> +                return __add_return_local_generic(ptr, value, size);
> +#endif
> +
> +	/*
> +	 * Sanity checking, compile-time.
> +	 */
> +	if (size == 8 && sizeof(unsigned long) != 8)
> +		wrong_size_add_local(ptr);
> +
> +	r = value;
> +	switch (size) {
> +	case 1:
> +		asm volatile("xaddb %0, %1;": "+r" (r), "+m" (*((u8 *)ptr)):
> +			 : "memory");
> +		break;
> +	case 2:
> +		asm volatile("xaddw %0, %1;": "+r" (r), "+m" (*((u16 *)ptr)):
> +			 : "memory");
> +		break;
> +	case 4:
> +		asm volatile("xaddl %0, %1;": "+r" (r), "+m" (*((u32 *)ptr)):
> +			 : "memory");
> +		break;
> +	case 8:
> +		asm volatile("xaddq %0, %1;": "+r" (r), "+m" (*((u64 *)ptr)):
> +			 : "memory");
> +		break;
> +	default:
> +		wrong_size_add_local(ptr);
> +	}
> +	return r + value;
> +}
> +
> +#define add_return_local(ptr, v)				  	\
> +	((__typeof__(*(ptr)))__add_return_local((ptr), (unsigned long)(v), \
> +			sizeof(*(ptr))))
> +
> +#define add_local(ptr, v) (void)__add_return_local((ptr), (unsigned long)(v), \
> +			sizeof(*(ptr)))
> +
> +
> +#endif
>  
> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
