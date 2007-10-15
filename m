Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbXJOXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbXJOXbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXJOXbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:31:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXJOXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:31:39 -0400
Date: Mon, 15 Oct 2007 16:31:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Misc: phantom, improved data passing
Message-Id: <20071015163134.3ed17496.akpm@linux-foundation.org>
In-Reply-To: <2571023650266415239@pripojeni.net>
References: <3012721321185026886@pripojeni.net>
	<2571023650266415239@pripojeni.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 09:33:49 -0700
Jiri Slaby <jirislaby@gmail.com> wrote:

> phantom, improved data passing
> 
> this new version guarantees amb_bit switch in small enough intervals, so
> that the device won't stop working in the middle of a movement anymore.
> However it preserves old (openhaptics) functionality.
> 
> ...
>
> +
> +		/* preserve amp bit (don't allow to change it when in NOT_OH) */
> +		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
> +			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
> +				(dev->ctl_reg & PHN_CTL_AMP);

hm, is that coded as clearly and as simply as possible?  Don't think so :(


> +		spin_lock_irqsave(&dev->regs_lock, flags);
> +		if (dev->status & PHB_NOT_OH)
> +			memcpy(&dev->oregs, &rs, sizeof(rs));
> +		else {
> +			for (i = 0; i < min(rs.count, 8U); i++)

We evaluate min() each time around the loop.  Doesn't matter much here I guess.

> +				if (rs.mask & BIT(i))
> +					iowrite32(rs.values[i], dev->oaddr + i);
> +			ioread32(dev->iaddr); /* PCI posting */
> +		}
> +		spin_unlock_irqrestore(&dev->regs_lock, flags);
>  		break;
>  	case PHN_GET_REG:
>  		if (copy_from_user(&r, argp, sizeof(r)))
>
> ...
>
>  static irqreturn_t phantom_isr(int irq, void *data)
>  {
>  	struct phantom_device *dev = data;
> +	unsigned int i;
> +	u32 ctl;
>  
> -	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
> +	spin_lock(&dev->regs_lock);
> +	ctl = ioread32(dev->iaddr + PHN_CONTROL);
> +	if (!(ctl & PHN_CTL_IRQ)) {
> +		spin_unlock(&dev->regs_lock);
>  		return IRQ_NONE;
> +	}
>  
>  	iowrite32(0, dev->iaddr);
>  	iowrite32(0xc0, dev->iaddr);
> +
> +	if (dev->status & PHB_NOT_OH)
> +		for (i = 0; i < min(dev->oregs.count, 8U); i++)

But this is the interrupt handler, and there's a pointer chase as well as
the min() each time around the loop (I assume).  I doubt if the world will
end, but it seems a bit lazy?

> +			if (dev->oregs.mask & BIT(i))
> +				iowrite32(dev->oregs.values[i], dev->oaddr + i);
> +
> +	dev->ctl_reg ^= PHN_CTL_AMP;
> +	iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
> +	spin_unlock(&dev->regs_lock);
> +

