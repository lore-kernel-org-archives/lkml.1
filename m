Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYFBHNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYFBHNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYFBHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:13:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35444 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753260AbYFBHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:13:06 -0400
Date: Mon, 2 Jun 2008 07:58:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: akpm@linux-foundation.org, wim@iguana.be,
       LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: AT91SAM9/CAP9 watchdog driver
Message-ID: <20080602075808.3b854855@core>
In-Reply-To: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static long at91_wdt_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	int __user *p = argp;

No locking.. so you could get two set timeout calls in parallel. Probably
you need a simple mutex in at91_wdt_settimeout();


> +	res = misc_register(&at91wdt_miscdev);
> +	if (res)
> +		return res;
> +
> +	/* Set watchdog */
> +	if (at91_wdt_settimeout(wdt_timeout) == -EINVAL) {
> +		pr_info("at91sam9_wdt: timeout must be between 1 and %d.\n",
> +			WDT_MAX_TIME);
> +		return 0;

At the moment those two are safe. When the open lock_kernel
goes away it will be possible to get

			misc_register
						open
						ioctl
			wdt_settimout()

So you may want to swap those two around (and disable the timer if the
register fails ?), or lock the open against the register routine.

Otherwise looks good.

Alan
