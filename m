Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZD2GWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZD2GWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZD2GWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:22:34 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:56243 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbZD2GWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:22:33 -0400
Date: Wed, 29 Apr 2009 02:22:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: clean up alternative.h
Message-ID: <20090429062222.GA22188@Krystal>
References: <20090428151346.GA31212@Krystal> <tip-edc953fa4ebc0265ef3b1754fe116a9fd4264e15@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <tip-edc953fa4ebc0265ef3b1754fe116a9fd4264e15@git.kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:20:39 up 60 days,  2:46,  1 user,  load average: 0.40, 0.41,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tip-bot for Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Commit-ID:  edc953fa4ebc0265ef3b1754fe116a9fd4264e15
> Gitweb:     http://git.kernel.org/tip/edc953fa4ebc0265ef3b1754fe116a9fd4264e15
> Author:     Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> AuthorDate: Tue, 28 Apr 2009 11:13:46 -0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 28 Apr 2009 17:42:08 +0200
> 
> x86: clean up alternative.h
> 
> Alternative header duplicates assembly that could be merged in
> one single macro.  Merging this into this macro also allows to
> directly declare ALTERNATIVE() statements within assembly code.
> 
> Uses a __stringify() of the feature bits rather than passing a
> "i" operand.  Leave the old %0 operand as-is (set to 0), unused
> to stay compatible with API.
> 
> (v2: tab alignment fixes)
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> LKML-Reference: <20090428151346.GA31212@Krystal>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/include/asm/alternative.h |   59 ++++++++++++++----------------------
>  1 files changed, 23 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index f6aa18e..1a37bcd 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/stddef.h>
> +#include <linux/stringify.h>
>  #include <asm/asm.h>
>  
>  /*
> @@ -74,6 +75,22 @@ static inline void alternatives_smp_switch(int smp) {}
>  
>  const unsigned char *const *find_nop_table(void);
>  
> +/* alternative assembly primitive: */
> +#define ALTERNATIVE(oldinstr, newinstr, feature)			\
> +									\
> +      "661:\n\t" oldinstr "\n662:\n"					\
> +      ".section .altinstructions,\"a\"\n"				\
> +      _ASM_ALIGN "\n"							\
> +      _ASM_PTR "661b\n"				/* label           */	\
> +      _ASM_PTR "663f\n"				/* new instruction */	\
> +      "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
> +      "	 .byte 662b-661b\n"			/* sourcelen       */	\
> +      "	 .byte 664f-663f\n"			/* replacementlen  */	\

I posted an updated v3 this morning which removes the "tab" before each
of these .byte, as requested by Peter.

Mathieu

> +      ".previous\n"							\
> +      ".section .altinstr_replacement, \"ax\"\n"			\
> +      "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
> +      ".previous"
> +
>  /*
>   * Alternative instructions for different CPU types or capabilities.
>   *
> @@ -87,18 +104,7 @@ const unsigned char *const *find_nop_table(void);
>   * without volatile and memory clobber.
>   */
>  #define alternative(oldinstr, newinstr, feature)			\
> -	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
> -		      ".section .altinstructions,\"a\"\n"		\
> -		      _ASM_ALIGN "\n"					\
> -		      _ASM_PTR "661b\n"		/* label */		\
> -		      _ASM_PTR "663f\n"		/* new instruction */	\
> -		      "	 .byte %c0\n"		/* feature bit */	\
> -		      "	 .byte 662b-661b\n"	/* sourcelen */		\
> -		      "	 .byte 664f-663f\n"	/* replacementlen */	\
> -		      ".previous\n"					\
> -		      ".section .altinstr_replacement,\"ax\"\n"		\
> -		      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
> -		      ".previous" :: "i" (feature) : "memory")
> +	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature) : : : "memory")
>  
>  /*
>   * Alternative inline assembly with input.
> @@ -109,35 +115,16 @@ const unsigned char *const *find_nop_table(void);
>   * Best is to use constraints that are fixed size (like (%1) ... "r")
>   * If you use variable sized constraints like "m" or "g" in the
>   * replacement make sure to pad to the worst case length.
> + * Leaving an unused argument 0 to keep API compatibility.
>   */
>  #define alternative_input(oldinstr, newinstr, feature, input...)	\
> -	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
> -		      ".section .altinstructions,\"a\"\n"		\
> -		      _ASM_ALIGN "\n"					\
> -		      _ASM_PTR "661b\n"		/* label */		\
> -		      _ASM_PTR "663f\n"		/* new instruction */	\
> -		      "	 .byte %c0\n"		/* feature bit */	\
> -		      "	 .byte 662b-661b\n"	/* sourcelen */		\
> -		      "	 .byte 664f-663f\n"	/* replacementlen */	\
> -		      ".previous\n"					\
> -		      ".section .altinstr_replacement,\"ax\"\n"		\
> -		      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
> -		      ".previous" :: "i" (feature), ##input)
> +	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
> +		: : "i" (0), ## input)
>  
>  /* Like alternative_input, but with a single output argument */
>  #define alternative_io(oldinstr, newinstr, feature, output, input...)	\
> -	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
> -		      ".section .altinstructions,\"a\"\n"		\
> -		      _ASM_ALIGN "\n"					\
> -		      _ASM_PTR "661b\n"		/* label */		\
> -		      _ASM_PTR "663f\n"		/* new instruction */	\
> -		      "	 .byte %c[feat]\n"	/* feature bit */	\
> -		      "	 .byte 662b-661b\n"	/* sourcelen */		\
> -		      "	 .byte 664f-663f\n"	/* replacementlen */	\
> -		      ".previous\n"					\
> -		      ".section .altinstr_replacement,\"ax\"\n"		\
> -		      "663:\n\t" newinstr "\n664:\n"  /* replacement */ \
> -		      ".previous" : output : [feat] "i" (feature), ##input)
> +	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
> +		: output : "i" (0), ## input)
>  
>  /*
>   * use this macro(s) if you need more than one output parameter

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
