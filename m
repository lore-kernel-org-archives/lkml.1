Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXD1SxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXD1SxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXD1SxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:53:14 -0400
Received: from www.osadl.org ([213.239.205.134]:48596 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbXD1SxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:53:12 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Flaws with "UIO: Add the User IO core code" (with patch)
Date: Sat, 28 Apr 2007 20:52:45 +0200
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <11777142582534-git-send-email-gregkh@suse.de> <20070428001923.15074234@the-village.bc.nu>
In-Reply-To: <20070428001923.15074234@the-village.bc.nu>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282052.45489.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 01:19 schrieb Alan Cox:
> > +static ssize_t uio_read(struct file *filep, char __user *buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	struct uio_listener *listener = filep->private_data;
> > +	struct uio_device *idev = listener->dev;
> > +	DECLARE_WAITQUEUE(wait, current);
> > +	ssize_t retval;
> > +	int event_count;
> > +
> > +	if (idev->info->irq == UIO_IRQ_NONE)
> > +		return -EIO;
> > +
> > +	if (count != sizeof(int))
> > +		return -EINVAL;
> 
> AFAIK we don't currently have any platform that runs binaries with
> different sizes of "int" but this is a) an unsigned value anyway, and b)
> should be a fixed type (eg u32)

I reviewed the code once more and find it OK. There is only one legal
value for the parameter "count" of uio_read(), and that's sizeof(int).
The data that is actually read is the element "event" of struct uio_device,
which is of type atomic_t. The latter has the size of an int.

Unfortunately, the fact that the read count _must_ be sizeof(int) is not
mentioned in the documentation. I'll send a patch for that ASAP.

> 
> Otherwise it looks ok at the momenmt, although there is a real nasty
> waiting for anyone who tries to use it. At the point open is possible or
> IRQs can be enabled you are safe in the core merged as idev->info is
> always valid, but any driver module trying to go back via info->uio_dev
> has a NULL pointer for an early IRQ or open event.

This patch should fix it:


Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-04-28 20:01:02.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-04-28 20:15:00.000000000 +0200
@@ -633,6 +633,8 @@
 	if (ret)
 		goto err_uio_dev_add_attributes;
 
+	info->uio_dev = idev;
+
 	if (idev->info->irq >= 0) {
 		ret = request_irq(idev->info->irq, uio_interrupt,
 				  idev->info->irq_flags, idev->info->name, idev);
@@ -640,7 +642,6 @@
 			goto err_request_irq;
 	}
 
-	info->uio_dev = idev;
 	return 0;
 
 err_request_irq:


Thanks for your review,
Hans

