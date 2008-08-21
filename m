Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYHUSRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYHUSRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYHUSQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:16:55 -0400
Received: from gw.goop.org ([64.81.55.164]:40867 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYHUSQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:16:54 -0400
Message-ID: <48ADB114.2000304@goop.org>
Date: Thu, 21 Aug 2008 11:16:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/7] x86/paravirt:  Add paravirt hook for wbinvd_halt
References: <> <1219341888-23191-1-git-send-email-alex.nixon@citrix.com> <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
In-Reply-To: <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> The native case of wb_invd_halt uses inline asm to ensure the compiler doesn't reorder the sequence of instructions, which has the side-effect of skirting around the paravirt hooks for those instructions.  Thus, create a new hook for this case.
>   

Not necessary.  Halting in Xen doesn't require the caches to be flushed
in this way, and I think that would be true for any virtual environment
(and if it were, the invalidate/halt instruction sequence would work
anyway).

The correct fix is to make sure that the native_play_dead calls this,
but the xen_play_dead doesn't (ie, make sure it's not in the common code
path).

    J

> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/paravirt.c  |    1 +
>  include/asm-x86/paravirt.h  |    6 ++++++
>  include/asm-x86/processor.h |    3 ++-
>  3 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 8ffe4d1..66d6d0d 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -299,6 +299,7 @@ struct pv_irq_ops pv_irq_ops = {
>  	.restore_fl = native_restore_fl,
>  	.irq_disable = native_irq_disable,
>  	.irq_enable = native_irq_enable,
> +	.wbinvd_halt = native_wbinvd_halt,
>  	.safe_halt = native_safe_halt,
>  	.halt = native_halt,
>  #ifdef CONFIG_X86_64
> diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
> index fd922c3..5360f3f 100644
> --- a/include/asm-x86/paravirt.h
> +++ b/include/asm-x86/paravirt.h
> @@ -194,6 +194,7 @@ struct pv_irq_ops {
>  	void (*restore_fl)(unsigned long);
>  	void (*irq_disable)(void);
>  	void (*irq_enable)(void);
> +	void (*wbinvd_halt)(void);
>  	void (*safe_halt)(void);
>  	void (*halt)(void);
>  
> @@ -716,6 +717,11 @@ static inline void raw_safe_halt(void)
>  	PVOP_VCALL0(pv_irq_ops.safe_halt);
>  }
>  
> +static inline void wbinvd_halt(void)
> +{
> +	PVOP_VCALL0(pv_irq_ops.wbinvd_halt);
> +}
> +
>  static inline void halt(void)
>  {
>  	PVOP_VCALL0(pv_irq_ops.safe_halt);
> diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
> index bcfc727..75db315 100644
> --- a/include/asm-x86/processor.h
> +++ b/include/asm-x86/processor.h
> @@ -558,6 +558,7 @@ static inline void load_sp0(struct tss_struct *tss,
>  	native_load_sp0(tss, thread);
>  }
>  
> +#define wbinvd_halt native_wbinvd_halt
>  #define set_iopl_mask native_set_iopl_mask
>  #endif /* CONFIG_PARAVIRT */
>  
> @@ -733,7 +734,7 @@ extern unsigned long		idle_nomwait;
>   *
>   * Systems without cache can just go into halt.
>   */
> -static inline void wbinvd_halt(void)
> +static inline void native_wbinvd_halt(void)
>  {
>  	mb();
>  	/* check for clflush to determine if wbinvd is legal */
>   

