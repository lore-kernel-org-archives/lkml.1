Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXL0ITB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXL0ITB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXL0ISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:18:52 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:57458 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbXL0ISu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:18:50 -0500
Date: Thu, 27 Dec 2007 17:18:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Message-ID: <20071227081822.GA22693@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org
References: <8b67d60712261726l28960f69u2eb2756a6f5176e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712261726l28960f69u2eb2756a6f5176e1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 01:26:47AM +0000, Adrian McMenamin wrote:
> This patch adds support for the CD-Rom drive on the SEGA Dreamcast.
> 
Please fix your mailer to inline the patch, preferably without word
wrapping. This is not a difficult thing, send yourself some test mails
until you get it sorted out.

> diff -rupN linux-2.6-orig/drivers/block/Kconfig linux-2.6/drivers/block/Kconfig
> --- linux-2.6-orig/drivers/block/Kconfig	2007-12-26 17:27:14.000000000 +0000
> +++ linux-2.6/drivers/block/Kconfig	2007-12-27 00:08:39.000000000 +0000
> @@ -105,6 +105,18 @@ config PARIDE
>  	  "MicroSolutions backpack protocol", "DataStor Commuter protocol"
>  	  etc.).
>  
> +config	GDROM

Why is this using a tab?

> +	tristate "SEGA Dreamcast GD-ROM drive"
> +	depends on SH_DREAMCAST
> +	help
> +	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
> +	  "GD-ROM" by SEGA to signify it is capable of reading special disks
> +	  with up to 1 GB of data. This drive will also read standard CD ROM
> +	  disks. Select this option to access any disks in your GD ROM drive.
> +	  Most users will want to say "Y" here.
> +	  You can also build this as a module which will be called gdrom.ko
> +
> +
Superfluous whitespace.

> +static int gdrom_get_last_session(struct cdrom_device_info *cd_info, struct cdrom_multisession *ms_info)
> +{
> +	int fentry, lentry, track, data, tocuse, err;
> +	kfree(gd.toc);
> +	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);

Er, what? The size of this never changes, allocate it once, and just
overload it every time you step in to this function. There's no reason to
free it and reallocate every time. Shove it in your probe routine with
the rest of your kzallocs.

> +/* keep the function loioking like the universal CD Rom specification - returning int*/

looking.

> +static int gdrom_set_command_interrupt_handler(void)
> +{
> +	/* need a queue to wait in */
> +	init_waitqueue_head(&command_queue);
> +	return request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
> +}
> +
> +static int gdrom_set_dma_interrupt_handler(void)
> +{
> +	init_waitqueue_head(&request_queue);
> +	return request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt, IRQF_DISABLED, "gdrom_dma", &gd);
> +}
> +
Having separate functions for these is pretty pointless.

> +	spin_lock(&gdrom_lock);
> +	list_for_each_safe(elem, next, &gdrom_deferred) {
> +		req = list_entry(elem, struct request, queuelist);
> +		spin_unlock(&gdrom_lock);

[snip]

> +		/* now seek to take the request spinlock
> + 		 * before handling ending the request */
> +		spin_lock(&gdrom_lock);
> +		list_del_init(&req->queuelist);
> +		blk_requeue_request(gd.gdrom_rq, req);
> +		if (err)
> +			end_request(req, 0);
> +		else
> +			end_request(req, 1);
> +	}
> +	spin_unlock(&gdrom_lock);
> +	kfree(read_command);
> +}	
> +
This locking is all over the place. What is this lock supposed to be
accomplishing?
