Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXKLVhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXKLVhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXKLVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:37:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbXKLVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:36:59 -0500
Date: Mon, 12 Nov 2007 13:36:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-Id: <20071112133638.ff671fa0.akpm@linux-foundation.org>
In-Reply-To: <200711091136.20051.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 11:36:19 -0800 David Brownell <david-b@pacbell.net> wrote:

> Provide new implementation infrastructure that platforms may choose to use
> when implementing the GPIO programming interface.  Platforms can update their
> GPIO support to use this.  In many cases the incremental cost to access a
> non-inlined GPIO should be on the order of a dozen instructions, so it won't
> normally be a problem.  The upside is:
> 
>   * Providing two features which were "want to have (but OK to defer)" when
>     GPIO interfaces were first discussed in November 2006:
> 
>     -	A "struct gpio_chip" to plug in GPIOs that aren't directly supported
> 	by SOC platforms, but come from FPGAs or other multifunction devices
> 	using conventional device registers (like UCB-1x00 or SM501 GPIOs,
> 	and southbridges in PCs with more open specs than usual).
> 
>     -	Full support for message-based GPIO expanders, where registers are
> 	accessed through sleeping I/O calls.  Previous support for these
> 	"cansleep" calls was just stubs.  (One example: the widely used
> 	pcf8574 I2C chips, with 8 GPIOs each.)
> 
>   * Including a non-stub implementation of the gpio_{request,free}() calls,
>     making those calls much more useful.  The diagnostic labels are also
>     recorded given DEBUG_FS, so /sys/kernel/debug/gpio can show a snapshot
>     of all GPIOs known to this infrastructure.
> 
> The driver programming interfaces introduced in 2.6.21 do not change at all;
> this infrastructure is entirely below those covers.
> 
> This opens the door to an augmented programming interface, addressing GPIOs
> by chip and index.  That could be used as a performance tweak (lookup once
> then cache, avoiding locking and lookup overheads) or to support transient
> GPIOs not registered in the integer GPIO namespace (maybe a USB-to-GPIO
> adapter, or GPIOs coupled to some other type of add-on card).
> 
> ...
>
> +
> +/* gpio_lock protects the table of chips and to gpio_chip->requested.
> + * While any gpio is requested, its gpio_chip is not removable.  It's
> + * a raw spinlock to ensure safe access from hardirq contexts, and to
> + * shrink bitbang overhead:  per-bit preemption would be very wrong.
> + */
> +static raw_spinlock_t gpio_lock = __RAW_SPIN_LOCK_UNLOCKED;

Well that's weird.

For starters, this initialisation will confound lockdep: it should use
DEFINE_SPINLOCK.

And the rationale seems dubious.  All you're saving here is a couple of
accesses to task_struct at spin_unlock()-time.  If the current task has a
preemption pending then yes, we'll schedule away but that's a very rare
thing and that's just what we're supposed to do.

So please tell us more about this.  Perhaps there are performance problems
with the current core preemption machinery.

> +	local_irq_save(flags);
> +	__raw_spin_lock(&gpio_lock);
>
> ...
> +	__raw_spin_unlock(&gpio_lock);
> +	local_irq_restore(flags);
> +	return status;
> +}

And of course if this code is converted to conventional locking, the above
becomes spin_lock_irqsave()/spin_lock_irqrestore() in many places.

> +/* There's no value in inlining GPIO calls that may sleep.

There's no value in inlining anything, hardly ;)

> +postcore_initcall(gpiolib_debugfs_init);

postcore_initcall() is unusual, hence a comment describing why it was
employed would be a good thing to have.
