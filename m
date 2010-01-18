Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976Ab0ARPeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0ARPeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120Ab0ARPeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:34:36 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:39250 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0ARPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:34:35 -0500
Date: Mon, 18 Jan 2010 10:34:30 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org
Subject: Re: [PATCH] geode-mfgpt: restore previous behavior for selecting
 IRQ
Message-ID: <20100118103430.6480d1a8@mycelium.queued.net>
In-Reply-To: <4B4C4B86.7090509@LiPPERTEmbedded.de>
References: <4B4C4B86.7090509@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 11:14:30 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> geode-mfgpt: restore previous behavior for selecting IRQ
> 
> The MFGPT IRQ used to be, in order of decreasing priority,
> * IRQ supplied by the user as a boot-time parameter,
> * IRQ previously set by the BIOS or another driver,
> * default IRQ given at compile time.
> 
> Return to this behavior, which got broken when splitting the
> MFGPT/clocksource driver for 2.6.33-rc1.
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> ---
> 
> Hi Andres,
> 
> a bit more detail. Up to 2.6.32 the MFGPT IRQ was chosen like this:
> 
> static int irq;
> static int __init mfgpt_setup(char *str)
> {
> 	get_option(&str, &irq);
> 	return 1;
> }
> __setup("mfgpt_irq=", mfgpt_setup);
> [...]
> /* Choose IRQ: if none supplied, keep IRQ already set or use default
> */ if (!*irq)
> 	*irq = (zsel >> shift) & 0xF;	// may have been set by
> the BIOS if (!*irq)
> 	*irq = MFGPT_DEFAULT_IRQ;	// #defined as 7
> 
> The code in 2.6.33-rc3 after the MFGPT/clocksource split looks like
> this:
> 
> static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;	//
> defaults to 7 module_param_named(irq, timer_irq, int, 0644);
> [...]
> if (!*irq)
> 	*irq = (zsel >> shift) & 0xF;		// gets ignored
> now if (!*irq)
> 	*irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;	// again!?
> 
> The patch removes the first of the two ocurrances of
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ, reverting the IRQ selection to the
> previous (working) behavior.

You're right, thanks.  For the patch below:

Acked-by: Andres Salomon <dilinger@collabora.co.uk>


> 
> 
> BTW, while looking into this I stumbled upon the fact that
> cs5535_mfgpt_init() doesn't free up the timer in the error path if
> cs5535_mfgpt_setup_irq() or setup_irq() fail. However, some comments
> in cs5535-mfgpt.c (stating that it's not possible to release the
> individual timer hardware) make me think this might have been skipped
> on purpose? Could you please have a look?

Oh, you mean in the clockevt driver?  Yeah, we can't really free the
timer, unfortunately.

It actually might not be a bad idea to reverse the code so that the IRQ
allocation happens first, since we can clean that up if mfgpt
allocation fails.   Feel like sending a patch? :)



> 
> Thanks,
> Jens
> 
> --- linux-2.6.33-rc3-git4/drivers/clocksource/cs5535-clockevt.c
> +++ previous_behavior/drivers/clocksource/cs5535-clockevt.c
> @@ -21,7 +21,7 @@
>  
>  #define DRV_NAME "cs5535-clockevt"
>  
> -static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;
> +static int timer_irq;
>  module_param_named(irq, timer_irq, int, 0644);
>  MODULE_PARM_DESC(irq, "Which IRQ to use for the clock source MFGPT
> ticks."); 
> _
> 
