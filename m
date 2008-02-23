Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbYBWIZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbYBWIZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765936AbYBWIJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:46 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933220AbYBWIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:11 -0500
Date: Sat, 23 Feb 2008 00:07:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux/kernel/irq/chip.c IRQ disable, shutdown bug
Message-Id: <20080223000717.3ed3a4c1.akpm@linux-foundation.org>
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC124E5D34@limkexm2.ad.analog.com>
References: <600D5CB4DFD93545BF61FF01473D11AC124E5D34@limkexm2.ad.analog.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 14:10:18 -0000 "Hennerich, Michael" <Michael.Hennerich@analog.com> wrote:

> free_irq() does not disable/mask the irq, in case disable or shutdown in struct irq_chip is left uninitilazied.
> 
> /**
>  * struct irq_chip - hardware interrupt chip descriptor
>  *
>  * @name:		name for /proc/interrupts
>  * @startup:		start up the interrupt (defaults to ->enable if NULL)
>  * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
>  * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
>  * @disable:		disable the interrupt (defaults to chip->mask if NULL)
> 
> 
> According to linux/irq.h struct irq_chip information,
> chip->disable should default to chip->mask if NULL.
> However irq_chip_set_defaults(struct irq_chip *chip) will set it to default_disable a empty function.
> 
> 
> Looking through various architectures, it's pretty common that disable and shutdown is NULL.
> So this bug affects many architectures.
> 
> This patch fixes the issue.
> 

Please send a Signed-off-by: for this work, as per
Documentation/SubmittingPatches, thanks.


> Index: irq/chip.c
> ===================================================================
> --- irq/chip.c  (revision 4276)
> +++ irq/chip.c  (working copy)

Please prepare future patches in `patch -p1' form.  This should have been

> --- a/kernel/irq/chip.c
> +++ a/kernel/irq/chip.c


> @@ -233,6 +233,10 @@
>   */
>  static void default_disable(unsigned int irq)
>  {
> +       struct irq_desc *desc = irq_desc + irq;
> +
> +       desc->chip->mask(irq);
> +       desc->status |= IRQ_MASKED;
>  }
> 
>  /*

Ingo, Thomas: ack?
