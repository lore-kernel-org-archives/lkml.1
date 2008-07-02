Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYGBMzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYGBMzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYGBMyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:54:50 -0400
Received: from www.tglx.de ([62.245.132.106]:53807 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYGBMyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:54:49 -0400
Date: Wed, 2 Jul 2008 14:54:00 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       tglx@linutronix.de
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080702125400.GC3199@local>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
> From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> 
> This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> is responsible for acknowledging and re-enabling the interrupt.

This can easily be done without your patch.

> Shared interrupts are not supported by this mode.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Similar code has been posted some time ago as:
>  "[PATCH] uio_pdrv: Unique IRQ Mode"
>  "[PATCH 00/03][RFC] Reusable UIO Platform Driver".

Yes, and in that thread I gave detailed explanations why I won't accept
that.

> 
>  Changes since Uwe's last version:
>   - flags should be unsigned long
>   - simplify uio_userirq_handler()

That's nearly nothing. All you do is sending the same stuff three weeks
later in the hope somebody will merge it this time. NAK.

Thanks,
Hans

> 
>  Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"
> 
>  include/linux/uio_driver.h |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> --- 0020/include/linux/uio_driver.h
> +++ work/include/linux/uio_driver.h	2008-07-02 19:45:55.000000000 +0900
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/interrupt.h>
> +#include <linux/bitops.h>
>  
>  struct uio_map;
>  
> @@ -63,6 +64,7 @@ struct uio_info {
>  	long			irq;
>  	unsigned long		irq_flags;
>  	void			*priv;
> +	unsigned long		flags;
>  	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
>  	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
>  	int (*open)(struct uio_info *info, struct inode *inode);
> @@ -92,4 +94,31 @@ extern void uio_event_notify(struct uio_
>  #define UIO_MEM_LOGICAL	2
>  #define UIO_MEM_VIRTUAL 3
>  
> +/* defines for uio_info->flags */
> +#define UIO_FLAGS_IRQDISABLED 0
> +
> +static inline irqreturn_t uio_userirq_handler(int irq,
> +		struct uio_info *dev_info)
> +{
> +	int ret = -1;
> +
> +	if (likely(dev_info->irqcontrol))
> +		ret = dev_info->irqcontrol(dev_info, 0);
> +
> +	return IRQ_RETVAL(ret == 0);
> +}
> +
> +static inline int uio_userirq_irqcontrol(struct uio_info *info, s32 irq_on)
> +{
> +	if (irq_on) {
> +		if (test_and_clear_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
> +			enable_irq(info->irq);
> +	} else {
> +		if (!test_and_set_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
> +			disable_irq(info->irq);
> +	}
> +
> +	return 0;
> +}
> +
>  #endif /* _LINUX_UIO_DRIVER_H_ */
