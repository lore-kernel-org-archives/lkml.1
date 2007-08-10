Return-Path: <linux-kernel-owner+w=401wt.eu-S938260AbXHJOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938260AbXHJOSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbXHJOSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:18:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42853 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762039AbXHJOSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:18:45 -0400
Date: Fri, 10 Aug 2007 10:18:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Zwell <dzwell@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       David Brownell <david-b@pacbell.net>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: USB hard disk broken
In-Reply-To: <46BB9335.4070101@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708101010170.3722-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Dan Zwell wrote:

> > What makes you think the problem you see is the same as the one 
> > described by Tino?  Do you get the "scatterlist error 0/-121" line in 
> > your log?
> > 
> > Please provide a dmesg log showing your problem with CONFIG_USB_DEBUG 
> > enabled.
> > 
> > Alan Stern
> > 
> > 
> 
> You're right, it probably isn't the same error, unfortunately. I jumped 
> to conclusions when I read Tino's description of the problem, "my 
> external USB hard disk went mad", which is a very good description of 
> what is happening to me. When any attempt is made to access the USB 
> disk, it (logically) disconnects and reconnects. When using hald's 
> automounting facilities, this leads to (endlessly repeated) madness.
> 
> I have attached my dmesg output (and a sanitized version that should 
> contain all the important information, but is easier to read). It looks 
> like the drive is auto suspended, but the resume process fails. Then the 
> process is repeated.
> 
> [  126.512815] usb 1-1: usb auto-resume
> [  126.543447] uhci_hcd 0000:00:1f.2: port 1 portsc 00a5,01
> [  126.559426] usb 1-1: finish resume
> [  126.561435] usb 1-1: gone after usb resume? status -19
> [  126.561445] usb 1-1: can't resume, status -19
> [  126.561451] hub 1-0:1.0: logical disconnect on port 1
> [  126.562486] sd 5:0:0:0: [sdb] Result: hostbyte=DID_ERROR 
> driverbyte=DRIVER_OK,SUGGEST_OK

This suggests a bug in the device's firmware, probably it sends a 
1-byte Device-Status reply instead of a 2-byte reply as required by the 
USB spec.  You could find out for certain by using usbmon.

But if that is indeed the problem, the patch below should help.  I've 
seen it before; perhaps we should adopt this workaround permanently.

> Relevant info:
> -obviously, I'm using uhci
> -the drive is SATA, connected to USB with a SATA/IDE to USB adapter
> -this problem does not occur with a USB flash drive
> -reverting the commit that introduced auto-suspend prevents this error.

If necessary you could disable autosuspend for your drive.  But first 
test this patch.

Alan Stern



Index: 2.6.23-rc1/drivers/usb/core/hub.c
===================================================================
--- 2.6.23-rc1.orig/drivers/usb/core/hub.c
+++ 2.6.23-rc1/drivers/usb/core/hub.c
@@ -1644,9 +1644,10 @@ static int finish_port_resume(struct usb
 	 * and device drivers will know about any resume quirks.
 	 */
 	if (status == 0) {
+		devstatus = 0;
 		status = usb_get_status(udev, USB_RECIP_DEVICE, 0, &devstatus);
 		if (status >= 0)
-			status = (status == 2 ? 0 : -ENODEV);
+			status = (status > 0 ? 0 : -ENODEV);
 	}
 
 	if (status) {

