Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXEaM6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXEaM6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXEaM5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:57:55 -0400
Received: from mail.suse.de ([195.135.220.2]:36804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbXEaM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:57:54 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] Conditional Calls - i386 Optimization
References: <20070530140025.917261793@polymtl.ca>
	<20070530140228.349272966@polymtl.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 15:54:32 +0200
In-Reply-To: <20070530140228.349272966@polymtl.ca>
Message-ID: <p73r6oxcd47.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> +#define cond_call_optimized(flags, name, func) \
> +	({ \
> +		static const char __cstrtab_name_##name[] \
> +		__attribute__((section("__cond_call_strings"))) = #name; \
> +		char condition; \
> +		asm (	".section __cond_call, \"a\", @progbits;\n\t" \
> +					".long %1, 0f, %2;\n\t" \
> +					".previous;\n\t" \
> +					".align 2\n\t" \
> +					"0:\n\t" \
> +					"movb %3,%0;\n\t" \
> +				: "=r" (condition) \
> +				: "m" (*__cstrtab_name_##name), \
> +				  "m" (*(char*)flags), \
> +				  "i" ((flags) & CF_STATIC_ENABLE)); \

Remind me what we need the flags again for? 

I would prefer to just eliminate them and always require arming.


> +		(likely(!condition)) ? \
> +			(__typeof__(func))0 : \
> +			(func); \
> +	})
> +
> +/* cond_call macro selecting the generic or optimized version of cond_call,
> + * depending on the flags specified. */
> +#define _cond_call(flags, name, func) \
> +({ \
> +	(((flags) & CF_LOCKDEP) && ((flags) & CF_OPTIMIZED)) ? \

Similar here? unoptimized condcalls don't make much sense.
I also don't understand what the LOCKDEP flag is good for.

> Index: linux-2.6-lttng/arch/i386/kernel/condcall.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/arch/i386/kernel/condcall.c	2007-05-17 01:52:38.000000000 -0400
> @@ -0,0 +1,140 @@
> +/* condcall.c
> + *
> + * - Erratum 49 fix for Intel PIII.
> + * - Still present on newer processors : Intel Core 2 Duo Processor for Intel
> + *   Centrino Duo Processor Technology Specification Update, AH33.
> + *   Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
> + *   Instruction Execution Results.

Can you please define a generic utility function to do self modifying
code? There are other places that do it too.

> +static DEFINE_MUTEX(cond_call_mutex);

All locks need a comment describing what they protect and the hierarchy if 
any.

-Andi
