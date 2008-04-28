Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbYD1ND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbYD1ND7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbYD1NDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:03:50 -0400
Received: from www.tglx.de ([62.245.132.106]:58192 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbYD1NDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:03:49 -0400
Date: Mon, 28 Apr 2008 15:03:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
Message-ID: <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1271678536-1209387812=:3261"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1271678536-1209387812=:3261
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 28 Apr 2008, Uwe Kleine-König wrote:
> Consider two devices A and B sharing an irq and B already asserts the irq on
> a booting machine.
> If the driver for A is loaded first the irq starts triggering and gets
> disabled after some time by note_interrupt().  Later when the driver for B
> is loaded the interrupt should be reenabled---other wise both A and B don't
> work properly.

Oh no. There is lots of code in drivers, which does:

   disable_irq();
   do_some_protected_stuff();
   enable_irq();

So when the second driver is loaded on another CPU it would see the
IRQ_DISABLED bit set and unconditionally reenable the interrupt. 

This unprotects the protected operation and definitely triggers the
WARN_ON() in enable_irq() where we check for desc->depth == 0.

I can see the rationale for your patch, as we have no way to silence
stupid hardware or hardware which was left in that state by the BIOS
other than disabling the interrupt line completely.

Waht kind of scenario/devices do you have which trigger this ?

Thanks,
	tglx

> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/irq/manage.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 438a014..831ebb2 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -365,11 +365,18 @@ int setup_irq(unsigned int irq, struct irqaction *new)
>  
>  		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
>  				  IRQ_INPROGRESS);
> +	}
> +
> +	/* in the shared case the interrupt might be disabled if a device
> +	 * asserts the irq but the corresponding driver wasn't the first to be
> +	 * loaded.  So retry enabling the irq.
> +	 */
> +	if (!shared || desc->status & IRQ_DISABLED) {
>  
>  		if (!(desc->status & IRQ_NOAUTOEN)) {
>  			desc->depth = 0;
>  			desc->status &= ~IRQ_DISABLED;
> -			if (desc->chip->startup)
> +			if (!shared && desc->chip->startup)
>  				desc->chip->startup(irq);
>  			else
>  				desc->chip->enable(irq);
> -- 
> 1.5.5.1
> 
--8323328-1271678536-1209387812=:3261--
