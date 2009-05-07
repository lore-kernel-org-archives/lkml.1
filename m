Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZEGLQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZEGLQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZEGLQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:16:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbZEGLQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:16:09 -0400
Date: Thu, 7 May 2009 13:15:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] genirq: ensure IRQs are lazy disabled before suspend
Message-ID: <20090507111548.GH28398@elte.hu>
References: <1241655468-5750-1-git-send-email-khilman@deeprootsystems.com> <1241655468-5750-2-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241655468-5750-2-git-send-email-khilman@deeprootsystems.com>
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


* Kevin Hilman <khilman@deeprootsystems.com> wrote:

> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21, the default
> behavior of disable_irq() was changed to delay the disable until it is
> next handled.
> 
> However, this leaves open the possibility that the system can go into
> suspend with an interrupt enabled.  For example, if a driver calls
> disable_irq() in its suspend_hook (for example, to prevent that device
> IRQ from causing a system wakeup) there's now a possibility that the
> system is suspended before the lazy disable happens.
> 
> The result is an unwanted wakeup from suspend if the IRQ is capable of
> waking the system (common on embedded SoCs.)
> 
> This patch ensures that the lazy disable is done, and masked by
> the irq_chip before the system goes into suspend.
> 
> Note that even though __disable_irq() also calls irq_chip->disable, it
> is quite common for the irq_chip not to provide a disable hook in
> which case the IRQ is never masked/disabled in hardware before going
> into suspend.
> 
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
>  kernel/irq/manage.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 2734eca..5d2cc1c 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -190,6 +190,11 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
>  		if (!desc->action || (desc->action->flags & IRQF_TIMER))
>  			return;
>  		desc->status |= IRQ_SUSPENDED;
> +
> +		/* Lazy disable: handles case where lazy disable in
> +		 * handler doesn't happen before suspend. */
> +		if (desc->status & IRQ_DISABLED)
> +			desc->chip->mask(irq);

Please look at the rest of the file and follow the multi-line 
comment style that is used in the 29 multi-line comment instances 
there. (which is also what Documentation/CodingStyle specifies)

	Ingo
