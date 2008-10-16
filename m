Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYJPXX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYJPXX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbYJPXXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:23:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbYJPXXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:23:50 -0400
Date: Thu, 16 Oct 2008 16:17:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Message-Id: <20081016161718.e05864da.akpm@linux-foundation.org>
In-Reply-To: <200810160845.22281.david-b@pacbell.net>
References: <200810160845.22281.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 08:45:22 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> We can get the following oops from gpio_get_value_cansleep()
> when a GPIO controller doesn't provide a get() callback:

We can, but do we? ;)

iow: is this needed in any -stable release?

>  Unable to handle kernel paging request for instruction fetch
>  Faulting instruction address: 0x00000000
>  Oops: Kernel access of bad area, sig: 11 [#1]
>  [...]
>  NIP [00000000] 0x0
>  LR [c0182fb0] gpio_get_value_cansleep+0x40/0x50
>  Call Trace:
>  [c7b79e80] [c0183f28] gpio_value_show+0x5c/0x94
>  [c7b79ea0] [c01a584c] dev_attr_show+0x30/0x7c
>  [c7b79eb0] [c00d6b48] fill_read_buffer+0x68/0xe0
>  [c7b79ed0] [c00d6c54] sysfs_read_file+0x94/0xbc
>  [c7b79ef0] [c008f24c] vfs_read+0xb4/0x16c
>  [c7b79f10] [c008f580] sys_read+0x4c/0x90
>  [c7b79f40] [c0013a14] ret_from_syscall+0x0/0x38
> 
> It's OK to request the value of *any* GPIO; most GPIOs are
> bidirectional, so configuring them as outputs just enables an
> output driver and doesn't disable the input logic.
> 
> So the problem is that gpio_get_value_cansleep() isn't making
> the same sanity check that gpio_get_value() does:  making sure
> this GPIO isn't one of the atypical "no input logic" cases.
> 
> Reported-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/gpio/gpiolib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1056,7 +1056,7 @@ int gpio_get_value_cansleep(unsigned gpi
>  
>  	might_sleep_if(extra_checks);
>  	chip = gpio_to_chip(gpio);
> -	return chip->get(chip, gpio - chip->base);
> +	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
>  }
>  EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
>  
