Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXBWJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXBWJiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXBWJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:38:19 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:59559 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXBWJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:38:18 -0500
Date: Fri, 23 Feb 2007 10:36:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch] s390: do not use _local_bh_enable()
Message-ID: <20070223093649.GA8084@osiris.boeblingen.de.ibm.com>
References: <20070223061459.GA10106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223061459.GA10106@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 07:14:59AM +0100, Ingo Molnar wrote:
> 
> Heiko, what do you think about the patch below - is there perhaps some 
> deeper reason to s390's _local_bh_enable() use that i missed?

Yes, both of these usages are quite subtle.

> Index: linux/drivers/s390/char/sclp.c
> ===================================================================
> --- linux.orig/drivers/s390/char/sclp.c
> +++ linux/drivers/s390/char/sclp.c
> @@ -407,8 +407,8 @@ sclp_sync_wait(void)
>  	}
>  	local_irq_disable();
>  	__ctl_load(cr0, 0, 0);
> -	_local_bh_enable();
>  	local_irq_restore(flags);
> +	local_bh_enable();
>  }
> 
>  EXPORT_SYMBOL(sclp_sync_wait);

The code here looks a bit different in the meantime.
See c59d744bd8a0e283daf6726881e4c9aa4bd25261. What we want to do here: the
console driver has requests pending and needs to wait _synchronously_ that
an interrupt arrives. It does that regardless of whatever context we are in:
process/softirq/hardirq/irqs disabled/irqs enabled. That's why we have the
local_irq_save() at the very beginning. Also when we leave this function we
do not want to execute bottom halves, since it could be that interrupts
where disabled before this function was called.
That's why we call _local_bh_enable() instead of local_bh_enable().

> Index: linux/drivers/s390/cio/cio.c
> ===================================================================
> --- linux.orig/drivers/s390/cio/cio.c
> +++ linux/drivers/s390/cio/cio.c
> @@ -140,7 +140,6 @@ cio_tpi(void)
>  	sch = (struct subchannel *)(unsigned long)tpi_info->intparm;
>  	if (!sch)
>  		return 1;
> -	local_bh_disable();
>  	irq_enter ();
>  	spin_lock(sch->lock);
>  	memcpy (&sch->schib.scsw, &irb->scsw, sizeof (struct scsw));
> @@ -148,7 +147,7 @@ cio_tpi(void)
>  		sch->driver->irq(&sch->dev);
>  	spin_unlock(sch->lock);
>  	irq_exit ();
> -	_local_bh_enable();
> +
>  	return 1;
>  }

Same here: this is not really an irq handler but a function that gets called
from different contexts and pretends to be an irq handler. The
local_bh_disable()/_local_bh_enable() pair is just a trick to prevent bottom
halve execution. I think you can blame Martin for this ;)

Probably both of these functions needs some comment I guess... and this one
as well: bf6f6aa46feada857a52cb67d99a7c2fe4a70e87 (our new __udelay
implementation).

-- 
Heiko Carstens
Linux on System z Development

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Johann Weihen
Geschaeftsfuehrung : Herbert Kircher
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
