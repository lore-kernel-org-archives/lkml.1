Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYGFM2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYGFM2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 08:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYGFM2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 08:28:17 -0400
Received: from www.tglx.de ([62.245.132.106]:44053 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYGFM2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 08:28:16 -0400
Date: Sun, 6 Jul 2008 14:27:43 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] uio: User IRQ Mode V2
Message-ID: <20080706122743.GA3198@local>
References: <20080705042121.4647.29429.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080705042121.4647.29429.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 01:21:21PM +0900, Magnus Damm wrote:
> This is V2 of the UIO "User IRQ Mode" patch.
> 
> In User IRQ Mode the kernel space interrupt handler simply disables
> the serviced interrupt in the interrupt controller and makes the
> user space driver responsible for acknowledging the interrupt in
> the device and reenabling the interrupt in the interrupt controller.
> 
> Shared interrupts are not supported by the User IRQ Mode since the
> generic in-kernel interrupt handler will disable the shared interrupt
> in the interrupt controller, and in a shared interrupt configuration
> this will stop other devices from delivering interrupts.

Hi Magnus,
since you (and others) insist on having this, I thought about a way how
we can get it merged. What do you think about this solution:

We already have Uwe's uio_pdrv. It allows generic handling of UIO
platform devices by defining struct uio_info and the irq handler
together with struct platform_device in board support. An irqcontrol()
function can optionally be defined if needed.

Your idea takes this one step further. You say we can even omit the irq
handler and the irqcontrol() function if we know that the platform
devices's irq is not shared. We can then replace both functions with
generic ones using disable_irq_nosync(). As a consequence, the userspace
part of the driver must reenable the interrupt using write().

As this is a special version of uio_pdrv, it should be implemented in a
similar way. I suggest calling it uio_pdrv_genirq because the difference
to uio_pdrv is that irqs are handled in a generic way in the kernel (as
I already said, I find the term "User IRQ mode" misleading).

uio_pdrv_genirq would be quite similar to uio_pdrv, with the following
differences:

- Its probe() function should fail if either (*handler) or (*irqcontrol)
  is not NULL, because obviously the user didn't get the idea.
- It should instead fill in the generic functions from your patch below.
  These can be implemented in uio_pdrv_genirq.c, no need to patch them
  into the UIO core header file.
- The Kconfig help text should state clearly that this only works for
  non-shared interrupts. Maybe it should be disabled on x86.

One of your first implementations of that idea patched it into uio_pdrv.
I didn't like this because it adds stuff that doesn't work on every
platform to something that does. Although uio_pdrv and uio_pdrv_genirq
would share some code, I find it justified to have two separate
implementation files, as both differ in platform dependencies and
possible use cases. Having two separate drivers clearly shows a user
which choices he has. Trying to save a few lines by putting it all in
one file would mainly add confusion and #ifdefs.

Implementing it this way, we also have the advantage that we don't have
to change any existing UIO core files (aside from adding the "flags"
element to struct uio_info, which is OK for me).

If you implemented it like this, uio_pdrv_genirq would become a part of
the UIO framework, and I'd explain it in the docs (I need to describe
uio_pdrv there anyway).

Would this approach be acceptable to you? If yes, please send a patch, I
think it can be merged soon.

Sorry I didn't have that idea earlier. I didn't feel well rejecting your
implementations without having something better to offer. I really hope
we can settle it this way.

Thanks for your contributions and patience,
Hans



> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
> 
>  Changes since V1
>   - use disable_irq_nosync() in interrupt handler, thanks Alan!
> 
>  Changes since Uwe's last version:
>   - flags should be unsigned long
>   - simplify uio_userirq_handler()
> 
>  Similar code has been posted some time ago as:
>  "[PATCH] uio_pdrv: Unique IRQ Mode"
>  "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
> 
>  Needs "[PATCH 0/1] UIO: Add a write() function to enable/disable interrupts"
> 
>  include/linux/uio_driver.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> --- 0001/include/linux/uio_driver.h
> +++ work/include/linux/uio_driver.h	2008-07-05 12:46:09.000000000 +0900
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
> @@ -92,4 +94,28 @@ extern void uio_event_notify(struct uio_
>  #define UIO_MEM_LOGICAL	2
>  #define UIO_MEM_VIRTUAL 3
>  
> +/* defines for uio_info->flags */
> +#define UIO_FLAGS_IRQDISABLED 0
> +
> +static inline irqreturn_t uio_userirq_handler(int irq, struct uio_info *info)
> +{
> +	if (!test_and_set_bit(UIO_FLAGS_IRQDISABLED, &info->flags))
> +		disable_irq_nosync(info->irq);
> +
> +	return IRQ_HANDLED;
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
