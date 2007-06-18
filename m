Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXFRHg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXFRHg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXFRHgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:36:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbXFRHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:36:15 -0400
Message-ID: <467635D8.5060202@zytor.com>
Date: Mon, 18 Jun 2007 00:35:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
References: <200706180209.36762.vapier@gentoo.org>
In-Reply-To: <200706180209.36762.vapier@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> Most of the macros in msr.h already use __asm__ and __volatile__, this patch
> brings the rest into line.  This is needed since these get exported into
> userspace (need to use strict __asm__ vs asm when gcc compiles with GNU
> extensions turned off).
> ---
> diff --git a/include/asm-x86_64/msr.h b/include/asm-x86_64/msr.h
> index d5c55b8..ed15d2b 100644
> --- a/include/asm-x86_64/msr.h
> +++ b/include/asm-x86_64/msr.h
> @@ -33,7 +33,7 @@
>  
>  /* wrmsr with exception handling */
>  #define wrmsr_safe(msr,a,b) ({ int ret__;			\
> -	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
> +	__asm__ __volatile__("2: wrmsr ; xorl %0,%0\n"			\
>  		     "1:\n\t"					\
>  		     ".section .fixup,\"ax\"\n\t"		\
>  		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
> @@ -50,7 +50,7 @@
>  
>  #define rdmsr_safe(msr,a,b) \
>  	({ int ret__;						\
> -	  asm volatile ("1:       rdmsr\n"			\
> +	  __asm__ __volatile__ ("1:       rdmsr\n"			\
>                        "2:\n"					\
>                        ".section .fixup,\"ax\"\n"		\
>                        "3:       movl %4,%0\n"			\

NAK.

This is wrong for two reasons:

- MSRs are not accessible in user space.
- .section .fixup is not applicable to user space.

Anything MSR-related should be protected by __KERNEL__ instead.

This NAK doesn't apply to rdtsc* and rdpmc* changes, however, as those
instructions are legitimate in userspace.

	-hpa
