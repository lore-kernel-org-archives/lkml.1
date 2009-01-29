Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZA2DRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZA2DRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZA2DQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:16:51 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:9136 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbZA2DQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:16:50 -0500
Date: Thu, 29 Jan 2009 12:13:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-mtd <linux-mtd@vger.kernel.org>
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and clean up maple bus driver (1/3)
Message-ID: <20090129031341.GD31096@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-input <linux-input@vger.kernel.org>,
	linux-mtd <linux-mtd@vger.kernel.org>
References: <1233186456.6734.16.camel@localhost.localdomain> <1233187069.6734.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233187069.6734.21.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:57:49PM +0000, Adrian McMenamin wrote:
> Rework the maple bus driver to support block reads and writes, while
> also cleaning up the code and aiming for a consistent namespace for
> functions.
> 
> Changes to the maple.h header file to support block reads and writes.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> 
> diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
> index 63f0de2..4d9b8b3 100644
> --- a/drivers/sh/maple/maple.c
> +++ b/drivers/sh/maple/maple.c
> @@ -1,16 +1,10 @@
>  /*
>   * Core maple bus functionality
>   *
> - *  Copyright (C) 2007, 2008 Adrian McMenamin
> + *  Copyright (C) 2007 - 2009 Adrian McMenamin
>   *  Copyright (C) 2001 - 2008 Paul Mundt
> - *
> - * Based on 2.4 code by:
> - *
> - *  Copyright (C) 2000-2001 YAEGASHI Takeshi
> + *  Copyright (C) 2000 - 2001 YAEGASHI Takeshi
>   *  Copyright (C) 2001 M. R. Brown
> - *  Copyright (C) 2001 Paul Mundt
> - *
> - * and others.
>   *

Uhm.. ok.

>  static struct mapleq *maple_allocq(struct maple_device *mdev)
>  {
>  	struct mapleq *mq;
>  
> -	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
> +	mq = kzalloc(sizeof(*mq), GFP_KERNEL);
>  	if (!mq)
>  		goto failed_nomem;
>  
>  	mq->dev = mdev;
> -	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
> -	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
> +	mq->recvbuf = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
>  	if (!mq->recvbuf)
>  		goto failed_p2;
> -	/*
> -	 * most devices do not need the mutex - but
> -	 * anything that injects block reads or writes
> -	 * will rely on it
> -	 */
> -	mutex_init(&mq->mutex);
> +	mq->recvbuf->buf = (void *)P2SEGADDR(&((mq->recvbuf->bufx)[0]));
>  
Please do not abuse P2SEGADDR in this fashion. No new code should be
using P2SEGADDR anyways. maple is particularly abusive in this case since
it bounces back and forth between P2SEGADDR and PHYSADDR to try and
ignore the fact cache flushing has to be handled.

You may also wish to consider ioremap/ioremap_nocache().

>  	return mq;
>  
>  failed_p2:
>  	kfree(mq);
>  failed_nomem:
> +	printk(KERN_INFO "maple: could not allocate memory\n");
>  	return NULL;
>  }
>  
printk() is pretty useless throughout all of this code, you have a struct
device, use it. dev_info()/dev_err()/etc/etc. with &mdev->dev will also
give you some meaningful indicator of which device in particular is
having issues.

> @@ -272,12 +201,16 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
>  {
>  	struct maple_device *mdev;
>  
> +	/* zero this out to avoid kobj subsystem
> +	* thinking it has already been registered */
> +
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>  	if (!mdev)
>  		return NULL;
>  
>  	mdev->port = port;
>  	mdev->unit = unit;
> +
>  	mdev->mq = maple_allocq(mdev);
>  
>  	if (!mdev->mq) {
> @@ -286,19 +219,18 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
>  	}
>  	mdev->dev.bus = &maple_bus_type;
>  	mdev->dev.parent = &maple_bus;
> +	init_waitqueue_head(&mdev->maple_wait);
> +	mdev->busy = 0;
> +	mdev->callback = NULL;
> +	mdev->canunload = NULL;
> +	mdev->fileerrhandler = NULL;
>  	return mdev;

All of these beyond the waitqueue initialization are superfluous, given
that you are kzalloc()'ing mdev in the first place.

>  	mdev->function = function;
>  	mdev->dev.release = &maple_release_device;
> -	retval = device_register(&mdev->dev);
> -	if (retval) {
> +
> +	if (device_register(&mdev->dev)) {

This is not an improvement. There are many places throughout this code
where you have a perfectly usable errno value handed back to you that you
simply ignore in favour of a fixed error value. If you have an indicator
of what went wrong, it helps to pass that along in the error case,
especially if you are trying to debug an error.

> @@ -477,21 +418,25 @@ static int detach_maple_device(struct device *device, void *portptr)
>  static int setup_maple_commands(struct device *device, void *ignored)
>  {
>  	int add;
> -	struct maple_device *maple_dev = to_maple_dev(device);
> -
> -	if ((maple_dev->interval > 0)
> -	    && time_after(jiffies, maple_dev->when)) {
> -		/* bounce if we cannot lock */
> -		add = maple_add_packet(maple_dev,
> -			be32_to_cpu(maple_dev->devinfo.function),
> +	struct maple_device *mdev = to_maple_dev(device);
> +	if ((mdev->interval > 0)
> +	    && time_after(jiffies, mdev->when)) {

&&'s at the end of the first line.

> @@ -52,11 +68,15 @@ struct maple_device {
>  	struct maple_driver *driver;
>  	struct mapleq *mq;
>  	void (*callback) (struct mapleq * mq);
> +	void (*fileerrhandler)(struct maple_device * mdev, void * recvbuf);
> +	int (*canunload)(struct maple_device * mdev);

I find it rather entertaining that you have no qualms about using
ridiculously long device and driver names even with fancy caps yet can't
bring yourself to insert an _ in your function pointer names.
