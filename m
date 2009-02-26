Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZBZDCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZBZDCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZBZDC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:02:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36037 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZBZDC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:02:28 -0500
Date: Thu, 26 Feb 2009 04:02:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Message-ID: <20090226030218.GA7526@elte.hu>
References: <1235594749-24585-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235594749-24585-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> The current definition of CALLER_ADDRx isn't suitable for all platforms.
> E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> AFAIK for powerpc there are no frame pointers needed to have a working
> __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> macros in <asm/ftrace.h> and let these take precedence.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I think I don't break any architecture with this patch:
> 
> 	$ for arch in $(ls arch/); do if test ! -d arch/$arch; then continue; fi; test -f arch/$arch/include/asm/ftrace.h || test -f include/asm-$arch/ftrace.h || { echo -n "$arch: "; git grep FTRACE arch/$arch | wc -l; } done
> 	alpha: 0
> 	avr32: 0
> 	blackfin: 0
> 	cris: 0
> 	frv: 0
> 	h8300: 0
> 	m32r: 0
> 	m68k: 0
> 	m68knommu: 0
> 	mips: 0
> 	mn10300: 0
> 	parisc: 0
> 	um: 0
> 	xtensa: 0
> 
> So all archs that don't have <asm/ftrace.h> seem not to use FTRACE.
> 
> Best regards
> Uwe
> 
>  include/linux/ftrace.h |   41 +++++++++++++++++++++--------------------
>  1 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 847bb3c..9d8d362 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -11,6 +11,8 @@
>  #include <linux/bitops.h>
>  #include <linux/sched.h>
>  
> +#include <asm/ftrace.h>
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  
>  extern int ftrace_enabled;
> @@ -103,8 +105,6 @@ struct ftrace_func_command {
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -/* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
> -#include <asm/ftrace.h>
>  
>  int ftrace_arch_code_modify_prepare(void);
>  int ftrace_arch_code_modify_post_process(void);
> @@ -282,24 +282,25 @@ static inline void __ftrace_enabled_restore(int enabled)
>  #endif
>  }
>  
> -#ifdef CONFIG_FRAME_POINTER
> -/* TODO: need to fix this for ARM */
> -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> -# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> -# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> -# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> -# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> -# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> -# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> -#else
> -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> -# define CALLER_ADDR1 0UL
> -# define CALLER_ADDR2 0UL
> -# define CALLER_ADDR3 0UL
> -# define CALLER_ADDR4 0UL
> -# define CALLER_ADDR5 0UL
> -# define CALLER_ADDR6 0UL
> -#endif
> +#ifndef CALLER_ADDR0
> +# ifdef CONFIG_FRAME_POINTER
> +#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> +#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> +#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> +#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> +#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> +#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> +# else
> +#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#  define CALLER_ADDR1 0UL
> +#  define CALLER_ADDR2 0UL
> +#  define CALLER_ADDR3 0UL
> +#  define CALLER_ADDR4 0UL
> +#  define CALLER_ADDR5 0UL
> +#  define CALLER_ADDR6 0UL
> +# endif
> +#endif /* ifndef CALLER_ADDR0 */

Makes sense!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
