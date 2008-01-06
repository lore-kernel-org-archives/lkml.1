Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYAFLRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYAFLRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 06:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAFLRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 06:17:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:59349 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYAFLRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 06:17:04 -0500
Subject: Re: [patch 5/5] PowerPC: switch to generic WARN_ON / BUG_ON
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
In-Reply-To: <20080105191245.06cb2d8a@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	 <20080105191245.06cb2d8a@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 22:16:04 +1100
Message-Id: <1199618164.7291.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 19:12 -0800, Arjan van de Ven wrote:
> From: Olof Johansson <olof@lixom.net>
> 
> Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> 4K text on a ppc64_defconfig.  The main reason seems to be that prepping
> the arguments to the conditional trap instructions is more work than just
> doing a compare and branch.

I'm a bit annoyed by that one ... for obvious reasons... I wish gcc
could be better here. Also, we can't completely remove the support for
the trap since we use that in asm in various places...

Ben.

> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: <linux-arch@vger.kernel.org>
> Cc: Scott Wood <scottwood@freescale.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>, 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/asm-powerpc/bug.h |   37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> Index: linux-2.6.24-rc6/include/asm-powerpc/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-powerpc/bug.h
> +++ linux-2.6.24-rc6/include/asm-powerpc/bug.h
> @@ -54,12 +54,6 @@
>  	".previous\n"
>  #endif
>  
> -/*
> - * BUG_ON() and WARN_ON() do their best to cooperate with compile-time
> - * optimisations. However depending on the complexity of the condition
> - * some compiler versions may not produce optimal results.
> - */
> -
>  #define BUG() do {						\
>  	__asm__ __volatile__(					\
>  		"1:	twi 31,0,0\n"				\
> @@ -69,20 +63,6 @@
>  	for(;;) ;						\
>  } while (0)
>  
> -#define BUG_ON(x) do {						\
> -	if (__builtin_constant_p(x)) {				\
> -		if (x)						\
> -			BUG();					\
> -	} else {						\
> -		__asm__ __volatile__(				\
> -		"1:	"PPC_TLNEI"	%4,0\n"			\
> -		_EMIT_BUG_ENTRY					\
> -		: : "i" (__FILE__), "i" (__LINE__), "i" (0),	\
> -		  "i" (sizeof(struct bug_entry)),		\
> -		  "r" ((__force long)(x)));			\
> -	}							\
> -} while (0)
> -
>  #define __WARN() do {						\
>  	__asm__ __volatile__(					\
>  		"1:	twi 31,0,0\n"				\
> @@ -92,23 +72,6 @@
>  		  "i" (sizeof(struct bug_entry)));		\
>  } while (0)
>  
> -#define WARN_ON(x) ({						\
> -	int __ret_warn_on = !!(x);				\
> -	if (__builtin_constant_p(__ret_warn_on)) {		\
> -		if (__ret_warn_on)				\
> -			__WARN();				\
> -	} else {						\
> -		__asm__ __volatile__(				\
> -		"1:	"PPC_TLNEI"	%4,0\n"			\
> -		_EMIT_BUG_ENTRY					\
> -		: : "i" (__FILE__), "i" (__LINE__),		\
> -		  "i" (BUGFLAG_WARNING),			\
> -		  "i" (sizeof(struct bug_entry)),		\
> -		  "r" (__ret_warn_on));				\
> -	}							\
> -	unlikely(__ret_warn_on);				\
> -})
> -
>  #endif /* __ASSEMBLY __ */
>  #endif /* CONFIG_BUG */
>  
> 
> 

