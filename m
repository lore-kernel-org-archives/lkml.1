Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYL2ROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYL2ROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYL2ROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:14:34 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:38480 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYL2ROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:14:33 -0500
Date: Mon, 29 Dec 2008 18:14:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
cc: sparclinux@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [patch 60/71] sparc64: Fix PCI error interrupt registry on
 PSYCHO.
In-Reply-To: <20081007004007.GI3055@suse.de>
Message-ID: <Pine.LNX.4.64.0812291813010.1886@anakin>
References: <20081007002606.723632097@mini.kroah.org> <20081007004007.GI3055@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Greg KH wrote:
> 2.6.26-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: David S. Miller <davem@davemloft.net>
> 
> [ Upstream commit 80a56ab626c70468be92e74cf3d288ffaed23fdb ]
> 
> We need to pass IRQF_SHARED, otherwise we get things like:

But you forgot to update the comment (see below)...

> IRQ handler type mismatch for IRQ 33
> current handler: PSYCHO_UE
> Call Trace:
>  [000000000048394c] request_irq+0xac/0x120
>  [00000000007c5f6c] psycho_scan_bus+0x98/0x158
>  [00000000007c2bc0] pcibios_init+0xdc/0x12c
>  [0000000000426a5c] do_one_initcall+0x1c/0x160
>  [00000000007c0180] kernel_init+0x9c/0xfc
>  [0000000000427050] kernel_thread+0x30/0x60
>  [00000000006ae1d0] rest_init+0x10/0x60
> 
> on e3500 and similar systems.
> 
> On a single board, the UE interrupts of two Psycho nodes
> are funneled through the same interrupt, from of_debug=3
> dump:
> 
> /pci@b,4000: direct translate 2ee --> 21
>  ...
> /pci@b,2000: direct translate 2ee --> 21
> 
> Decimal "33" mentioned above is the hex "21" mentioned here.
> 
> Thanks to Meelis Roos for dumps and testing.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/sparc64/kernel/pci_psycho.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/arch/sparc64/kernel/pci_psycho.c
> +++ b/arch/sparc64/kernel/pci_psycho.c
> @@ -744,16 +744,16 @@ static void psycho_register_error_handle
>  	 * the second will just error out since we do not pass in
                                          ^^^^^^^^^^^^^^^^^^^^^^^
>  	 * IRQF_SHARED.
           ^^^^^^^^^^^
>  	 */
> -	err = request_irq(op->irqs[1], psycho_ue_intr, 0,
> +	err = request_irq(op->irqs[1], psycho_ue_intr, IRQF_SHARED,
>  			  "PSYCHO_UE", pbm);
> -	err = request_irq(op->irqs[2], psycho_ce_intr, 0,
> +	err = request_irq(op->irqs[2], psycho_ce_intr, IRQF_SHARED,
>  			  "PSYCHO_CE", pbm);
>  
>  	/* This one, however, ought not to fail.  We can just warn
>  	 * about it since the system can still operate properly even
>  	 * if this fails.
>  	 */
> -	err = request_irq(op->irqs[0], psycho_pcierr_intr, 0,
> +	err = request_irq(op->irqs[0], psycho_pcierr_intr, IRQF_SHARED,
>  			  "PSYCHO_PCIERR", pbm);
>  	if (err)
>  		printk(KERN_WARNING "%s: Could not register PCIERR, "

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
