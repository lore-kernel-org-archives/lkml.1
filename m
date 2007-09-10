Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbXIJJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbXIJJcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXIJJcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:32:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbXIJJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:32:42 -0400
Date: Mon, 10 Sep 2007 02:32:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: The AmigaLinux A2232 Driver Project <A2232@gmx.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ser_a2232.c bug removed: handles "IRQ request denied"
 case
Message-Id: <20070910023205.d7aaefc7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708301609120.21063@haneman.hacenet>
References: <Pine.LNX.4.64.0708301609120.21063@haneman.hacenet>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 16:13:55 +0100 (BST) The AmigaLinux A2232 Driver Project <A2232@gmx.net> wrote:

> 
> 
> This patch handles the case in which the request for the
> vertical blank interrupt could not be granted. Thanks to
> Nazia Zaman for spotting it.
> 
> Applies to latest 2.6.x kernels.
> 
> 
> --- linux/drivers/char/ser_a2232.c.org	2007-08-30 15:41:25.000000000 +0100
> +++ linux/drivers/char/ser_a2232.c	2007-08-30 15:46:17.000000000 +0100
> @@ -787,7 +787,7 @@ static int __init a2232board_init(void)
> 
>   	}
> 
> -	printk("Total: %d A2232 boards initialized.\n", nr_a2232); /* Some status report if no card was found */
> +	printk("Total: %d A2232 boards detected.\n", nr_a2232); /* Some status report if no card was found */
> 
>   	a2232_init_portstructs();
> 
> @@ -795,9 +795,13 @@ static int __init a2232board_init(void)
>   		a2232_init_drivers also registers the drivers. Must be here because all boards
>   		have to be detected first.
>   	*/
> -	if (a2232_init_drivers()) return -ENODEV; // maybe we should use a different -Exxx?
> +	if (a2232_init_drivers())
> +		return -ENODEV; // maybe we should use a different -Exxx?
> 
> -	request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID);
> +	if (request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID))
> +		return -ENODEV;

We're going to need to undo the things which a2232_init_drivers() just did.
There's a memory leak and the registered tty driver might even cause a
crash if someone tries to use it?

Perhaps requesting the IRQ before running a2232_init_drivers() would be a
suitable approach.


> +	printk("A2232 driver initialized successfully.\n");
>   	return 0;
>   }
> 


