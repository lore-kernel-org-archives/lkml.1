Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbYB2Xw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbYB2Xw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYB2XwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:52:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532AbYB2XwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:52:13 -0500
Date: Fri, 29 Feb 2008 15:51:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Schuster <olivers137@aol.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] add watchdog driver IT8716 IT8726 IT8712J/K
Message-Id: <20080229155136.49c34bed.akpm@linux-foundation.org>
In-Reply-To: <47C579FA.7060403@aol.com>
References: <47C579FA.7060403@aol.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 15:55:54 +0100
Oliver Schuster <olivers137@aol.com> wrote:

> Hi,
> this patch add a hardware watchdog device driver. It supports the
> 16 bit watchdog timer on superio chip it8712f-j, it 8712f-k, it8716f
> and it8726f. Today it was tested under vanilla 2.6.24.3, vanilla
> 2.6.24.2 and Mandriva with 2.6.24.2 and 2.6.24 kernel.
> 
> ...
>

> static  int exclusiv = DEFAULT_EXCLUSIV;

Could we put the "e" back into "exclusive" please?

> +static int wdt_set_timeout(int t)
> +{
> +	unsigned long flags;
> +
> +	if (t < 1 || t > 65535)
> +		return -EINVAL;
> +
> +	timeout = t;
> +
> +	if (wdt_status & BIT_MASK(WDTS_TIMER_RUN)) {
> +		spin_lock_irqsave(&spinlock, flags);

Are you sure we are OK testing WDTS_TIMER_RUN prior to taking the lock? 
Should that test happen inside the lock?


> +		superio_enter();
> +
> +		superio_select(GPIO);
> +		superio_outb(t>>8, WDTVALMSB);
> +		superio_outb(t, WDTVALLSB);
> +
> +		superio_exit();
> +		spin_unlock_irqrestore(&spinlock, flags);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * The status bit does not allow to distinguish between a regular
> + * system reset and a watchdog forced reset. But, in testmode it
> + * is useful, so it is supported through WDIOC_GETSTATUS
> + */
> +
> +static int wdt_get_status(int *status)
> +{
> +	int new_status = 0;
> +	unsigned long flags;
> +
> +	if (testmode) {
> +		spin_lock_irqsave(&spinlock, flags);
> +		superio_enter();
> +
> +		superio_select(GPIO);
> +		new_status = superio_inb(WDTCTRL);
> +		superio_outb(new_status & 0xfe, WDTCTRL);
> +		new_status &= 0x01;
> +
> +		superio_exit();
> +		spin_unlock_irqrestore(&spinlock, flags);
> +	}
> +	*status = 0;
> +	if (new_status)
> +		*status |= WDIOF_CARDRESET;
> +	if (wdt_status & BIT_MASK(WDTS_KEEPALIVE))

The driver uses set_bit(&wdt_status, ...) to modify bits, but it uses this
open-coded test when reading bits.  Please switch all instances of this to
use plain old test_bit().

> +		*status |= WDIOF_KEEPALIVEPING;
> +	clear_bit(WDTS_KEEPALIVE, &wdt_status);
> +	return 0;
> +}
>
> ...
>
> +/*
> + *      wdt_write:
> + *      @file: file handle to the watchdog
> + *      @buf: buffer to write (unused as data does not matter here)

Is this comment about `buf' true?

> + *      @count: count of bytes
> + *      @ppos: pointer to the position to write. No seeks allowed
> + *
> + *      A write to a watchdog device is defined as a keepalive signal. Any
> + *      write of data will do, as we we don't define content meaning.
> + */
> +
> +static ssize_t wdt_write(struct file *file, const char __user *buf,
> +			    size_t count, loff_t *ppos)
> +{
> +	if (count) {
> +		if (!nowayout) {
> +			size_t ofs;
> +
> +	/* note: just in case someone wrote the magic character long ago */
> +			expect_close = 0;
> +			for (ofs = 0; ofs != count; ofs++) {
> +				char c;
> +				if (get_user(c, buf + ofs))
> +					return -EFAULT;
> +				if (c == 'V')
> +					expect_close = WD_MAGIC;

So we support a write of "VVVVVVVVVVV"?  Seems odd.

> +			}
> +		}
> +		wdt_keepalive();
> +	}
> +	return count;
> +}
> +
> +/*
> + *      wdt_ioctl:
> + *      @inode: inode of the device
> + *      @file: file handle to the device
> + *      @cmd: watchdog command
> + *      @arg: argument pointer
> + *
> + *      The watchdog API defines a common set of functions for all watchdogs
> + *      according to their available features.
> + */

The comments in this file are _almost_ in kerneldoc format, but they
actually aren't.  Please convert them fully (and test it!)

> +static struct watchdog_info ident = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
> +	.firmware_version =	1,
> +	.identity = WATCHDOG_NAME,
> +};
> +
>
> ...
>
> +config IT87_WDT
> +	tristate "IT87 Watchdog Timer"
> +	depends on EXPERIMENTAL
> +	---help---
> +	  This is the driver for the hardware watchdog on the ITE IT8716F,
> +	  IT8726F, IT8712F(Version J,K) Super I/O chips.  This watchdog 
> +	  simply watches your kernel to make sure it doesn't freeze, and
> +	  if it does, it reboots your computer after a certain amount of
> +	  time.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called it87_wdt.

Surely this needs more dependencies.  The driver is x86(?)-specific and
blindly pokes at IO ports prior to determining whether the device is
actually present.  We don't want people who try loading this driver on
their ia64 servers to crash the machine, scribble on their disk drives, etc.


