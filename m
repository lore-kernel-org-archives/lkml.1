Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYJ2ULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYJ2ULT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYJ2ULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:11:05 -0400
Received: from www.tglx.de ([62.245.132.106]:56027 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYJ2ULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:11:04 -0400
Date: Wed, 29 Oct 2008 21:10:54 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Manuel Traut <manut@linutronix.de>
Cc: hjk@linutronix.de, b.spranger@linutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: UIO: don't check irq_enabled flag in uio_cif irq handler
Message-ID: <20081029201054.GB2951@local>
References: <20081028224137.GA25357@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028224137.GA25357@www.tglx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:41:37PM +0100, Manuel Traut wrote:
> Below patch ignores INT1_ENABLED flag in the uio_cif irq handler.
> 
> On a Hilscher DeviceNet Slave card, the INT_ENABLE flag is (probably) reseted 
> by the firmware.

If this is actually the case, then this definetly a firmware bug. If
firmware clears the interrupt enable bit, you have no chance of knowing
if the irq was enabled or not. As a consequence, you cannot find out
whether your card caused the interrupt or not.
A hardware with such a behaviour is simply not a decent PCI card, which
should support shared interrupts.

Send a bug report to the firmware author.

> Without this patch, every interrupt produced by this card is
> dropped.

Yes, probably you'll need that patch if you want to make a card with
such broken behaviour work. But _with_ this patch, you'll run into
problems if you have two such PCI cards that share the same interrupt.

I consider this a workaround that might be OK for your usecase, but it's
not something that should go to mainline.

So, NAK to this.

Thanks,
Hans

> 
> This patch is tested and works with a DeviceNet Slave and a Profibus Slave card.
> 
> Signed-off-by: Manuel Traut <manut@linutronix.de>
> 
> --- linux-git/drivers/uio/uio_cif.c	2008-10-28 23:42:18.000000000 +0100
> +++ uio/drivers/uio/uio_cif.c	2008-10-28 23:41:43.000000000 +0100
> @@ -18,7 +18,6 @@
>  #define PLX9030_INTCSR		0x4C
>  #define INTSCR_INT1_ENABLE	0x01
>  #define INTSCR_INT1_STATUS	0x04
> -#define INT1_ENABLED_AND_ACTIVE	(INTSCR_INT1_ENABLE | INTSCR_INT1_STATUS)
>  
>  #define PCI_SUBVENDOR_ID_PEP	0x1518
>  #define CIF_SUBDEVICE_PROFIBUS	0x430
> @@ -30,8 +29,8 @@
>  	void __iomem *plx_intscr = dev_info->mem[0].internal_addr
>  					+ PLX9030_INTCSR;
>  
> -	if ((ioread8(plx_intscr) & INT1_ENABLED_AND_ACTIVE)
> -	    != INT1_ENABLED_AND_ACTIVE)
> +	if ((ioread8(plx_intscr) & INT1_STATUS)
> +	    != INT1_STATUS)
>  		return IRQ_NONE;
>  
>  	/* Disable interrupt */
