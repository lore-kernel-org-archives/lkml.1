Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZJSHeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZJSHeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZJSHeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:34:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZJSHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:34:13 -0400
Date: Mon, 19 Oct 2009 09:33:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
	signal stack
Message-ID: <20091019073358.GE17960@elte.hu>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed more folks, quoted mail and patch can be found below.)

* Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> The stack pointer can be either first incremented/decremented and then
> used (lets call it PRE) or incremented/decremented after its use (lets
> call it POST). The difference is whether the stack pointer points to the
> last variable on the stack or to the first free slot. This tiny little
> detail caused Debian bug #544905 on AMD64. gcc-4.3 with -O2 optimized
> the code in a way where the signal stack pointer had the same value as
> the real stack pointer. The stack pointer is PRE_DEC and therefore we
> are not on the alternative stack yet.
> This patch should handle all corned cases now. AVR is the only
> architecture which has a POST operation defined and a Linux port
> avaiable. All other architectures are POST_DEC except PA-RISC which is
> POST_INC
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
> I have also a reduced testcase at [0] which is AMD64 only. Most other
> architectures I've looked at store some register(s) between the stack
> pointer and the first/last variable so I could only trigger it on AMD64.
> 
> Haavard: The AVR32 assumption is pure on gcc's STACK_PUSH_CODE which is
> POST_DEC. Could you please ack/nak it?
> 
> [0] http://download.breakpoint.cc/tc-sig-stack.c
> 
>  arch/avr32/Kconfig    |    3 +++
>  include/linux/sched.h |   24 ++++++++++++++++++++++--
>  2 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index 35e3bd9..520c489 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -70,6 +70,9 @@ config GENERIC_BUG
>  	def_bool y
>  	depends on BUG
>  
> +config STACK_STORE_POST
> +	def_bool y
> +
>  source "init/Kconfig"
>  
>  source "kernel/Kconfig.freezer"
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 75e6e60..23e6eb6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2086,11 +2086,31 @@ static inline int is_si_special(const struct siginfo *info)
>  	return info <= SEND_SIG_FORCED;
>  }
>  
> -/* True if we are on the alternate signal stack.  */
> -
> +/*
> + * True if we are on the alternate signal stack, based on the follwoing
> + * example: The alternative stack handler starts at 0x10 and its size is 0x20
> + * bytes. The numbers behind PRE and POST are aimed as the result.
> + * PRE means the stack is first decremented and than the content of the variale
> + * is stored. This means, the stack pointer points in the PRE case to the last
> + * variable on the stack. In the POST case it points to the first free slot.
> + *
> + *         0   5       10    15   30     40   80
> + *         +-----------+-----------+----------+
> + *         |           | SIG STACK |          |
> + *         +-----------+-----------+----------+
> + * POST        0       1     1     0     0
> + * PRE         0       0     1     1     0
> + */
>  static inline int on_sig_stack(unsigned long sp)
>  {
> +#if defined(CONFIG_STACK_STORE_POST)
>  	return (sp - current->sas_ss_sp < current->sas_ss_size);
> +
> +#else
> +	if (!(sp - current->sas_ss_sp))
> +		return 0;
> +	return (sp - current->sas_ss_sp <= current->sas_ss_size);
> +#endif
>  }
>  
>  static inline int sas_ss_flags(unsigned long sp)
> -- 
> 1.6.4.GIT
