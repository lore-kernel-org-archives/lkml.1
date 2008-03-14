Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYCNVHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYCNVHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCNVHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:07:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbYCNVHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:07:38 -0400
Message-ID: <47DAE909.20006@redhat.com>
Date: Fri, 14 Mar 2008 17:07:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com>
In-Reply-To: <47D8FD33.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2008 05:08 AM, Jan Beulich wrote:
> This (simplified) piece of code didn't behave as expected due to
> incorrect constraints in some of the bitops functions, when
> X86_FEATURE_xxx is referring to other than the first long:
> 
> int test(struct cpuinfo_x86 *c) {
> 	if (cpu_has(c, X86_FEATURE_xxx))
> 		clear_cpu_cap(c, X86_FEATURE_xxx);
> 	return cpu_has(c, X86_FEATURE_xxx);
> }
> 

This is a long-standing bug and your patch appears to fix it.

> --- linux-2.6.25-rc5/include/asm-x86/bitops.h	2008-03-10 13:24:33.000000000 +0100
> +++ 2.6.25-rc5-x86-clear-bit/include/asm-x86/bitops.h	2008-03-13 08:45:40.000000000 +0100
> @@ -24,9 +24,12 @@
>  /* Technically wrong, but this avoids compilation errors on some gcc
>     versions. */
>  #define ADDR "=m" (*(volatile long *) addr)
> +#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
>  #else
>  #define ADDR "+m" (*(volatile long *) addr)
> +#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
>  #endif
> +#define BASE_ADDR "m" (*(volatile int *) addr)

Can't you just do everything with unsigned longs, like this?

In include/asm-x86/types.h:

 ifdef CONFIG_X86_32
 # define BITS_PER_LONG 32
+# define BITMAP_ORDER 5
 #else
 # define BITS_PER_LONG 64
+# define BITMAP_ORDER 6
 #endif

Then:

>  #define ADDR "=m" (*(volatile long *) addr)
> +#define BIT_ADDR "=m" (((volatile long *) addr)[nr >> BITMAP_ORDER])
>  #else
>  #define ADDR "+m" (*(volatile long *) addr)
> +#define BIT_ADDR "+m" (((volatile long *) addr)[nr >> BITMAP_ORDER])
>  #endif

No need for BASE_ADDR that way (or ADDR could be renamed to that.)
