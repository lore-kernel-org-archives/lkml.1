Return-Path: <linux-kernel-owner+w=401wt.eu-S935745AbXJSSFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935745AbXJSSFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764215AbXJSSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:04:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36876 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbXJSSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:04:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075508.GB6407@havoc.gtf.org>
Date: Fri, 19 Oct 2007 12:04:47 -0600
In-Reply-To: <20071019075508.GB6407@havoc.gtf.org> (Jeff Garzik's message of
	"Fri, 19 Oct 2007 03:55:08 -0400")
Message-ID: <m1ir53gev4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> commit 008b5fcf3c1d8456005de26ddd4256b1369225e8
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 00:45:51 2007 -0400
>
>     [IRQ ARG REMOVAL] core interrupt delivery infrastructure updates
>
>  include/asm-generic/irq_regs.h |   25 +++++++++++++++++++++++++
>  include/linux/interrupt.h      |    4 ++--
>  kernel/irq/handle.c            |    5 +++--
>  kernel/irq/manage.c            |    4 ++--
>  kernel/irq/spurious.c          |    3 ++-
>  lib/irq_regs.c                 |    5 +++++
>  6 files changed, 39 insertions(+), 7 deletions(-)
>
> 008b5fcf3c1d8456005de26ddd4256b1369225e8
> diff --git a/include/asm-generic/irq_regs.h b/include/asm-generic/irq_regs.h
> index 5ae1d07..1d99ef4 100644
> --- a/include/asm-generic/irq_regs.h
> +++ b/include/asm-generic/irq_regs.h
> @@ -34,4 +34,29 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs
> *new_regs)
>  	return old_regs;
>  }
>  
> +DECLARE_PER_CPU(unsigned int, __irqfunc_irqs);
> +
> +static inline unsigned int get_irqfunc_irq(void)
> +{
> +	return __get_cpu_var(__irqfunc_irqs);
> +}
> +
> +#if 0
> +static inline unsigned int set_irqfunc_irq(unsigned int new_irq)
> +{
> +	unsigned int old_irq, *pirq = &__get_cpu_var(__irqfunc_irqs);
> +
> +	old_irq = *pirq;
> +	*pirq = new_irq;
> +	return old_irq;
> +}
> +#else
> +static inline void set_irqfunc_irq(unsigned int new_irq)
> +{
> +	int *pirq = &__get_cpu_var(__irqfunc_irqs);
> +
> +	*pirq = new_irq;
> +}
> +#endif

Please look at handle_IRQ_event.  Local irqs are enabled so irq
recursion can happen.  So not handling old_irq is a big nasty
bug.

Eric
