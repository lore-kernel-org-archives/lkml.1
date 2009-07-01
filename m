Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZGAJB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZGAJB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZGAJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:01:17 -0400
Received: from fe02x03-cgp.akado.ru ([77.232.31.165]:61109 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977AbZGAJBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:01:11 -0400
From: Arseniy Lartsev <ars3n@yandex.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Wed, 1 Jul 2009 13:01:06 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc1-git3-0.1-default; KDE/4.1.3; i686; ; )
Cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011301.06574.ars3n@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009 01:01:00 Alan Stern wrote:
> This looks like your problem.  Low-speed devices are not allowed to
> have bulk endpoints.  Linux internally changes them to interrupt
> endpoints with interval = 1 and maxpacket size no larger than 8.

Maybe this device is a little "buggy". But Linux should support buggy devices 
as well.

What about something like

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -387,6 +387,7 @@ static void acm_rx_tasklet(unsigned long
 	struct acm_ru *rcv;
 	unsigned long flags;
 	unsigned char throttled;
+	struct usb_host_endpoint *ep;
 
 	dbg("Entering acm_rx_tasklet");
 
@@ -462,11 +463,20 @@ urbs:
 
 		rcv->buffer = buf;
 
-		usb_fill_bulk_urb(rcv->urb, acm->dev,
-				  acm->rx_endpoint,
-				  buf->base,
-				  acm->readsize,
-				  acm_read_bulk, rcv);
+		ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in : acm->dev->ep_out)
+				[usb_pipeendpoint(acm->rx_endpoint)];
+		if (usb_endpoint_xfer_int(&ep->desc))
+			usb_fill_int_urb(rcv->urb, acm->dev,
+					 acm->rx_endpoint,
+					 buf->base,
+					 acm->readsize,
+					 acm_read_bulk, rcv, 0xff);
+		else
+			usb_fill_bulk_urb(rcv->urb, acm->dev,
+					  acm->rx_endpoint,
+					  buf->base,
+					  acm->readsize,
+					  acm_read_bulk, rcv);
 		rcv->urb->transfer_dma = buf->dma;
 		rcv->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -1227,9 +1237,14 @@ made_compressed_probe:
 			goto alloc_fail7;
 		}
 
-		usb_fill_bulk_urb(snd->urb, usb_dev,
-			usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
-			NULL, acm->writesize, acm_write_bulk, snd);
+		if (usb_endpoint_xfer_int(epwrite))
+			usb_fill_int_urb(snd->urb, usb_dev,
+				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+				NULL, acm->writesize, acm_write_bulk, snd, 0xff);
+		else
+			usb_fill_bulk_urb(snd->urb, usb_dev,
+				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+				NULL, acm->writesize, acm_write_bulk, snd);
 		snd->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		snd->instance = acm;
 	}

It should work around devices like mine, but should not affect previously 
supported devices.

