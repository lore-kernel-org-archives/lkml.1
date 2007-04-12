Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXDLTKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXDLTKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXDLTKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:10:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXDLTKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:10:36 -0400
Date: Thu, 12 Apr 2007 12:10:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add keyboard blink driver
Message-Id: <20070412121028.d7e5c4b6.akpm@linux-foundation.org>
In-Reply-To: <200704121727.27892.ak@novell.com>
References: <200704121727.27892.ak@novell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 17:27:27 +0200
Andi Kleen <ak@novell.com> wrote:

> Add a blink driver for debugging
> 
> Simple driver that blinks the keyboard LEDs when loaded. Useful
> for checking that the kernel is still alive or for crashdumping.
> The kdump kernel currently typically doesn't give any feedback
> on the screen because it often cannot reinitialize the graphics
> state. This patch allows it to at least show blinking lights
> like panic.

OK..

> --- /dev/null
> +++ linux/drivers/misc/blink.c
> @@ -0,0 +1,26 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/timer.h>
> +#include <linux/jiffies.h>
> +
> +static void do_blink(unsigned long data);
> +
> +static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
> +
> +static void do_blink(unsigned long data)
> +{
> +	static long count;
> +	panic_blink(count++);
> +	blink_timer.expires = jiffies + msecs_to_jiffies(1);
> +	add_timer(&blink_timer);
> +}
> +
> +static int blink_init(void)
> +{
> +	printk(KERN_INFO "Enabling keyboard blinking\n");
> +	do_blink(0);
> +	return 0;
> +}
> +
> +module_init(blink_init);

panic_blink is NULL in lots of setups.  `modprobe blink' will be deadly.

I wonder if this facility would be more effective if it were to use
schedule_delayed_work().  That way, we're using more of the kernel and it
will more reliably detect kernel deadness.

