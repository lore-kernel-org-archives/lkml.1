Return-Path: <linux-kernel-owner+w=401wt.eu-S936845AbXGSBDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936845AbXGSBDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbXGSBDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:03:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763443AbXGSBD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:03:29 -0400
Date: Wed, 18 Jul 2007 18:02:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu
 unstable
Message-Id: <20070718180223.e1dad55d.akpm@linux-foundation.org>
In-Reply-To: <200707152106.28437.juergen127@kreuzholzen.de>
References: <20070715.210036.157242351.takada@mbf.nifty.com>
	<200707152106.28437.juergen127@kreuzholzen.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 21:06:27 +0200
Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> Replace NSC/Cyrix specific chipset access macros by inlined functions.
> With the macros a line like this fails (and does nothing):
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> With inlined functions this line will work as expected.

I don't get it.  Why would the macros behave differently from inlined
functions?

diff -puN /dev/null include/asm-i386/processor-cyrix.h
> --- /dev/null
> +++ a/include/asm-i386/processor-cyrix.h
> @@ -0,0 +1,20 @@
> +#ifndef __ASM_I386_PROCESSOR_CYRIX_H
> +#define __ASM_I386_PROCESSOR_CYRIX
> +
> +#include <asm/processor-flags.h>
> +/*
> + * NSC/Cyrix CPU indexed register access
> + */
> +static inline u8 getCx86(u8 reg)
> +{
> +	outb(reg, 0x22);
> +	return inb(0x23);
> +}
> +
> +static inline void setCx86(u8 reg, u8 data)
> +{
> +	outb(reg, 0x22);
> +	outb(data, 0x23);
> +}
> +
> +#endif
> diff -puN include/asm-i386/processor.h~i386-geodes-tsc-is-not-neccessary-to-mark-tu-unstable include/asm-i386/processor.h
> --- a/include/asm-i386/processor.h~i386-geodes-tsc-is-not-neccessary-to-mark-tu-unstable
> +++ a/include/asm-i386/processor.h
> @@ -168,17 +168,6 @@ static inline void clear_in_cr4 (unsigne
>  	write_cr4(cr4);
>  }
>  
> -/*
> - *      NSC/Cyrix CPU indexed register access macros
> - */
> -
> -#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
> -
> -#define setCx86(reg, data) do { \
> -	outb((reg), 0x22); \
> -	outb((data), 0x23); \
> -} while (0)
> -
>  /* Stop speculative execution */
>  static inline void sync_core(void)
>  {
> diff -puN include/asm-x86_64/processor.h~i386-geodes-tsc-is-not-neccessary-to-mark-tu-unstable include/asm-x86_64/processor.h
> --- a/include/asm-x86_64/processor.h~i386-geodes-tsc-is-not-neccessary-to-mark-tu-unstable
> +++ a/include/asm-x86_64/processor.h
> @@ -389,17 +389,6 @@ static inline void prefetchw(void *x) 
>  
>  #define cpu_relax()   rep_nop()
>  
> -/*
> - *      NSC/Cyrix CPU indexed register access macros
> - */
> -
> -#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
> -
> -#define setCx86(reg, data) do { \
> -	outb((reg), 0x22); \
> -	outb((data), 0x23); \
> -} while (0)
> -
>  static inline void serialize_cpu(void)
>  {
>  	__asm__ __volatile__ ("cpuid" : : : "ax", "bx", "cx", "dx");
>

