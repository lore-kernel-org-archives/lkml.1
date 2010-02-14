Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0BNAaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:30:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33927 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0BNAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:30:18 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>
	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 16:30:07 -0800
In-Reply-To: <4B773CEB.9010609@kernel.org> (Yinghai Lu's message of "Sat\, 13 Feb 2010 15\:59\:39 -0800")
Message-ID: <m1sk94mzg0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:
>
> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>
> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
> of handle_irq.
> use vector_desc to reduce the calling of irq_to_desc.
>
> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc
>
> -v2: irq should be unsigned in 32bit handle_irq according to Eric
>      also reset vector_desc for lguest in setup_irq
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Index: linux-2.6/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irq_32.c
> +++ linux-2.6/arch/x86/kernel/irq_32.c
> @@ -76,7 +76,7 @@ static void call_on_stack(void *func, vo
>  }
>  
>  static inline int
> -execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
> +execute_on_irq_stack(int overflow, struct irq_desc *desc)
>  {
>  	union irq_ctx *curctx, *irqctx;
>  	u32 *isp, arg1, arg2;
> @@ -189,24 +189,22 @@ asmlinkage void do_softirq(void)

This looks like it will fail to build here.
Don't you need to update the assembly to use desc->irq instead
of the now removed irq parameter?

>  
>  #else
>  static inline int
> -execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
> +execute_on_irq_stack(int overflow, struct irq_desc *desc) { return 0; }
>  #endif
>  
> -bool handle_irq(unsigned irq, struct pt_regs *regs)
> +bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
>  {
> -	struct irq_desc *desc;
>  	int overflow;
>  
>  	overflow = check_stack_overflow();
>  
> -	desc = irq_to_desc(irq);
>  	if (unlikely(!desc))
>  		return false;
>  
> -	if (!execute_on_irq_stack(overflow, desc, irq)) {
> +	if (!execute_on_irq_stack(overflow, desc)) {
>  		if (unlikely(overflow))
>  			print_stack_overflow();
> -		desc->handle_irq(irq, desc);
> +		desc->handle_irq(desc->irq, desc);
>  	}
>  
>  	return true;

Eric
