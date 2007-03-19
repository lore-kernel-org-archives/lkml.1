Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXCSKjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXCSKjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXCSKjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:39:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:46789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXCSKjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:39:15 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-usb-devel@lists.sourceforge.net
Subject: [PATCH]Re: [linux-usb-devel] drivers/usb/misc/iowarrior.c: NULL dereference
Date: Mon, 19 Mar 2007 11:39:13 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Christian Lucht <lucht@codemercs.com>,
       Robert Marquardt <marquardt@codemercs.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070319092533.GN752@stusta.de>
In-Reply-To: <20070319092533.GN752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703191139.14026.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. März 2007 10:25 schrieb Adrian Bunk:
> The Coverity checker spotted the following NULL dereference:

And this fixes an oops upon allocation failures.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>
-----

--- linux-2.6.21-rc4/drivers/usb/misc/iowarrior.c.alt	2007-03-19 11:05:37.000000000 +0100
+++ linux-2.6.21-rc4/drivers/usb/misc/iowarrior.c	2007-03-19 11:07:30.000000000 +0100
@@ -417,14 +417,14 @@
 		if (!int_out_urb) {
 			retval = -ENOMEM;
 			dbg("%s Unable to allocate urb ", __func__);
-			goto error;
+			goto error_no_urb;
 		}
 		buf = usb_buffer_alloc(dev->udev, dev->report_size,
 				       GFP_KERNEL, &int_out_urb->transfer_dma);
 		if (!buf) {
 			retval = -ENOMEM;
 			dbg("%s Unable to allocate buffer ", __func__);
-			goto error;
+			goto error_no_buffer;
 		}
 		usb_fill_int_urb(int_out_urb, dev->udev,
 				 usb_sndintpipe(dev->udev,
@@ -459,7 +459,9 @@
 error:
 	usb_buffer_free(dev->udev, dev->report_size, buf,
 			int_out_urb->transfer_dma);
+error_no_buffer:
 	usb_free_urb(int_out_urb);
+error_no_urb:
 	atomic_dec(&dev->write_busy);
 	wake_up_interruptible(&dev->write_wait);
 exit:
