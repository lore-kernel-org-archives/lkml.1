Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXDZESN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXDZESN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXDZESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:18:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbXDZESM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:18:12 -0400
Date: Wed, 25 Apr 2007 21:18:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: irq probe can be done without risking an IRQ
 storm
Message-Id: <20070425211808.54b86293.akpm@linux-foundation.org>
In-Reply-To: <20070405140936.46fb6ba4@the-village.bc.nu>
References: <20070405140936.46fb6ba4@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 14:09:36 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Nowdays you can ask for an IRQ to be allocated but not enabled, when
> PCMCIA was written this was not true and this feature is thus not used
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c
> --- linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 16:52:14.000000000 +0100
> +++ linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 17:10:42.000000000 +0100
> @@ -810,8 +810,11 @@
>  		type = IRQF_SHARED;
>  	if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
>  		type = IRQF_SHARED;	
>  #ifdef CONFIG_PCMCIA_PROBE
> +	if (!(req->Attributes & IRQ_HANDLE_PRESENT))
> +		type |= IRQ_NOAUTOEN;
> +
>  	if (s->irq.AssignedIRQ != 0) {
>  		/* If the interrupt is already assigned, it must be the same */
>  		irq = s->irq.AssignedIRQ;

alpha:

drivers/pcmcia/pcmcia_resource.c: In function 'pcmcia_request_irq':
drivers/pcmcia/pcmcia_resource.c:816: error: 'IRQ_NOAUTOEN' undeclared (first use in this function)
drivers/pcmcia/pcmcia_resource.c:816: error: (Each undeclared identifier is reported only once
drivers/pcmcia/pcmcia_resource.c:816: error: for each function it appears in.)

Problem is, IRQ_NOAUTOEN is a generic-irq thing, so architectures which
don't use generic-irqs break.  And it's defined in linux/irq.h which
(stupidly) cannot be included in generic code.

