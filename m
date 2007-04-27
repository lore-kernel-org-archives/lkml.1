Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXD0XQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXD0XQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXD0XQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:16:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54887 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757873AbXD0XQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:16:02 -0400
Date: Sat, 28 Apr 2007 00:19:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Flaws with "UIO: Add the User IO core code"
Message-ID: <20070428001923.15074234@the-village.bc.nu>
In-Reply-To: <11777142582534-git-send-email-gregkh@suse.de>
References: <20070427224957.GA17967@kroah.com>
	<11777142582534-git-send-email-gregkh@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static ssize_t uio_read(struct file *filep, char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct uio_listener *listener = filep->private_data;
> +	struct uio_device *idev = listener->dev;
> +	DECLARE_WAITQUEUE(wait, current);
> +	ssize_t retval;
> +	int event_count;
> +
> +	if (idev->info->irq == UIO_IRQ_NONE)
> +		return -EIO;
> +
> +	if (count != sizeof(int))
> +		return -EINVAL;

AFAIK we don't currently have any platform that runs binaries with
different sizes of "int" but this is a) an unsigned value anyway, and b)
should be a fixed type (eg u32)

Otherwise it looks ok at the momenmt, although there is a real nasty
waiting for anyone who tries to use it. At the point open is possible or
IRQs can be enabled you are safe in the core merged as idev->info is
always valid, but any driver module trying to go back via info->uio_dev
has a NULL pointer for an early IRQ or open event.

This means that the fasync support in the current code is basically
unusable until this is fixed

Alan
