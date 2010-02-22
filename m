Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0BVTF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:05:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45668 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0BVTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiuzF1Its0XHGyRTs1J5gIAtcOJIlVPIRMz401UBl6Hs4eNDwxyZhJPFx9k4AcqBT/
         L2iBOgrAF+YDzhLPEA6TnQqX4lbrlu7kdmNRG9mNWA2JL+zGClJucHtR8iI1UQbUIpSi
         4Fz9+YQtZyWMX0JGckc17IUAuHDk/dIRr5c1c=
Date: Mon, 22 Feb 2010 20:05:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
	pointers
Message-ID: <20100222190516.GJ5055@nowhere>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-5-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266090518-31120-5-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 01:18:32AM +0530, Rabin Vincent wrote:
> With a new enough GCC, ARM function tracing can be supported without the
> need for frame pointers.  This is essential for Thumb-2 support, since
> frame pointers aren't available then.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/Kconfig.debug         |    5 +++++
>  arch/arm/kernel/armksyms.c     |    2 ++
>  arch/arm/kernel/entry-common.S |    7 +++++++
>  kernel/trace/Kconfig           |    2 +-
>  4 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5cb9326..5501253 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -27,6 +27,11 @@ config ARM_UNWIND
>  	  the performance is not affected. Currently, this feature
>  	  only works with EABI compilers. If unsure say Y.
>  
> +config OLD_MCOUNT
> +	bool
> +	depends on FUNCTION_TRACER && FRAME_POINTER
> +	default y
> +



Btw, you described that mcount is used in some gcc versions and
__gnu_mcount_nc in newers.
Shouldn't we have a gcc version dependency here? (not sure we can
do this from Kconfig though).



>  config DEBUG_USER
>  	bool "Verbose user fault messages"
>  	help
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index 8214bfe..e5e1e53 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -165,6 +165,8 @@ EXPORT_SYMBOL(_find_next_bit_be);
>  #endif
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> +#ifdef CONFIG_OLD_MCOUNT
>  EXPORT_SYMBOL(mcount);
> +#endif
>  EXPORT_SYMBOL(__gnu_mcount_nc);
>  #endif
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index d412d7c..c98e3a3 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -169,6 +169,12 @@ gnu_trace:
>  	ldmia	sp!, {r0-r3, ip, lr}
>  	mov	pc, ip
>  
> +#ifdef CONFIG_OLD_MCOUNT
> +/*
> + * This is under an ifdef in order to force link-time errors for people trying
> + * to build with !FRAME_POINTER with a GCC which doesn't use the new-style
> + * mcount.
> + */
>  ENTRY(mcount)
>  	stmdb	sp!, {r0-r3, lr}
>  	ldr	r0, =ftrace_trace_function
> @@ -187,6 +193,7 @@ trace:
>  	mov	pc, r2
>  	ldr	lr, [fp, #-4]			@ restore lr
>  	ldmia	sp!, {r0-r3, pc}
> +#endif
>  
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 6c22d8a..7468ffe 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -126,7 +126,7 @@ if FTRACE
>  config FUNCTION_TRACER
>  	bool "Kernel Function Tracer"
>  	depends on HAVE_FUNCTION_TRACER
> -	select FRAME_POINTER
> +	select FRAME_POINTER if (!ARM_UNWIND)


So, if I understand well. If people have ARM_UNWIND but
FUNCTION_TRACER, it might crash at link time in case
they don't have a recent enough gcc version to
support the new -pg style?

That doesn't look good.

Ideally, we need HAVE_FUNCTION_TRACER to be enabled in arm
only if (old gcc && frame pointers) || new gcc

And then, we need config OLD_MCOUNT:
	 old gcc && FUNCTION_TRACER

and config NEW_MCOUNT:
	new gcc && FUNCTION_TRACER

so that we can selectively build mcount or __gnu_mcount_nc.

Hmm, I fear we can't check gcc version from Kconfig, as I'm
grepping on Kconfig files...

