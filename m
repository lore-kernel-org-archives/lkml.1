Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYJTQR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYJTQR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYJTQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:17:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45207 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798AbYJTQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:17:46 -0400
Date: Mon, 20 Oct 2008 12:17:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Oliver Neukum <oliver@neukum.org>, Mike Isely <isely@pobox.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <alpine.DEB.1.10.0810201121090.4791@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Justin Piszcz wrote:

> >> http://home.comcast.net/~jpiszcz/20081019/trace_before_trigger.txt
> >> http://home.comcast.net/~jpiszcz/20081019/trace_after_trigger.txt
> >
> > Your trace is incomplete.  You might need to increase the size of the
> > kernel log buffer (CONFIG_LOG_BUF_SHIFT) or the size of the buffer used
> > by dmesg (the -s option).
> >
> > Alan Stern
> >
> 
> You're right, I set it to 128 KiB and here is the full log, including the 
> initial dmesg:
> 
> http://home.comcast.net/~jpiszcz/20081019/kern.log

Okay, I see the problem. It's the same as we saw with the speedtouch
driver last week: The pvrusb2 driver resets its device but doesn't
define a pre_reset or a post_reset method.  As a result it gets
disconnected during the reset, and the recursive call causes it to
hang.

This patch should fix the problem.  It's not entirely correct, but it 
should at least allow the driver to work like it did in 2.6.26.

Alan Stern



Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
===================================================================
--- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
+++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
@@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
 #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
 }
 
+static int pvr_pre_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
+static int pvr_post_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
 static int pvr_probe(struct usb_interface *intf,
 		     const struct usb_device_id *devid)
 {
@@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
 	.name =         "pvrusb2",
 	.id_table =     pvr2_device_table,
 	.probe =        pvr_probe,
-	.disconnect =   pvr_disconnect
+	.disconnect =   pvr_disconnect,
+	.pre_reset =	pvr_pre_reset,
+	.post_reset =	pvr_post_reset,
 };
 
 /*

