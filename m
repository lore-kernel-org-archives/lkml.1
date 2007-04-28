Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXD1VDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXD1VDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXD1VDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:03:37 -0400
Received: from www.osadl.org ([213.239.205.134]:53865 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752306AbXD1VDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:03:35 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Flaws with "UIO: Add the User IO core code" (with patch)
Date: Sat, 28 Apr 2007 23:03:06 +0200
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <200704282052.45489.hjk@linutronix.de> <20070428212416.5768cc04@the-village.bc.nu>
In-Reply-To: <20070428212416.5768cc04@the-village.bc.nu>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282303.06727.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 22:24 schrieb Alan Cox:
> > > AFAIK we don't currently have any platform that runs binaries with
> > > different sizes of "int" but this is a) an unsigned value anyway, and b)
> > > should be a fixed type (eg u32)
> > 
> > I reviewed the code once more and find it OK. There is only one legal
> > value for the parameter "count" of uio_read(), and that's sizeof(int).
> 
> If you are a box with multiple supported binary types how big is an
> "int". We use explicit sizes to ensure that uio_read() will work when/if
> we get platforms which support binaries with differing ideas of the size
> of "int". Thus it should use s32 or s64 or similar.

Here's a fix to that effect:

Index: linux-2.6.22-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio.c	2007-04-28 22:46:34.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio.c	2007-04-28 22:59:40.000000000 +0200
@@ -264,7 +264,7 @@
 
 struct uio_listener {
 	struct uio_device *dev;
-	int event_count;
+	s32 event_count;
 };
 
 static int uio_open(struct inode *inode, struct file *filep)
@@ -345,12 +345,12 @@
 	struct uio_device *idev = listener->dev;
 	DECLARE_WAITQUEUE(wait, current);
 	ssize_t retval;
-	int event_count;
+	s32 event_count;
 
 	if (idev->info->irq == UIO_IRQ_NONE)
 		return -EIO;
 
-	if (count != sizeof(int))
+	if (count != sizeof(s32))
 		return -EINVAL;
 
 	add_wait_queue(&idev->wait, &wait);


Thanks,
Hans
