Return-Path: <linux-kernel-owner+w=401wt.eu-S934324AbXEESgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324AbXEESgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbXEESgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:36:10 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:36641 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325AbXEESgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:36:05 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Sat, 5 May 2007 20:35:57 +0200
User-Agent: KMail/1.9.1
Cc: "Paul Fulghum" <paulkf@microgate.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com> <1178384675.3379.26.camel@x2> <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com>
In-Reply-To: <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052035.58782.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 5. Mai 2007 20:08 schrieb Antonino Ingargiola:
> Now I don't want to abuse your kindness, but I (personally) would be
> *really* interested in a similar fix for the FTDI usb-serial driver,
> because many measurements I do use an FTDI device.

Does this work?

	Regards
		Oliver
----

--- a/drivers/usb/serial/ftdi_sio.c	2007-05-05 20:21:41.000000000 +0200
+++ b/drivers/usb/serial/ftdi_sio.c	2007-05-05 20:27:09.000000000 +0200
@@ -1749,10 +1749,6 @@ static void ftdi_process_read (struct wo
 			length = 0;
 		}
 
-		if (priv->rx_flags & THROTTLED) {
-			dbg("%s - throttled", __FUNCTION__);
-			break;
-		}
 		if (tty_buffer_request_room(tty, length) < length) {
 			/* break out & wait for throttling/unthrottling to happen */
 			dbg("%s - receive room low", __FUNCTION__);
@@ -1825,16 +1821,6 @@ static void ftdi_process_read (struct wo
 		dbg("%s - incomplete, %d bytes processed, %d remain",
 				__FUNCTION__, packet_offset,
 				urb->actual_length - packet_offset);
-		/* check if we were throttled while processing */
-		spin_lock_irqsave(&priv->rx_lock, flags);
-		if (priv->rx_flags & THROTTLED) {
-			priv->rx_flags |= ACTUALLY_THROTTLED;
-			spin_unlock_irqrestore(&priv->rx_lock, flags);
-			dbg("%s - deferring remainder until unthrottled",
-					__FUNCTION__);
-			return;
-		}
-		spin_unlock_irqrestore(&priv->rx_lock, flags);
 		/* if the port is closed stop trying to read */
 		if (port->open_count > 0){
 			/* delay processing of remainder */
@@ -1856,9 +1842,15 @@ static void ftdi_process_read (struct wo
 			      port->read_urb->transfer_buffer, port->read_urb->transfer_buffer_length,
 			      ftdi_read_bulk_callback, port);
 
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-		if (result)
-			err("%s - failed resubmitting read urb, error %d", __FUNCTION__, result);
+		spin_lock_irqsave(&priv->rx_lock, flags);
+		if (priv->rx_flags & THROTTLED) {
+			priv->rx_flags |= ACTUALLY_THROTTLED;
+		} else {
+			result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+			if (result)
+				err("%s - failed resubmitting read urb, error %d", __FUNCTION__, result);
+		}
+		spin_unlock_irqrestore(&priv->rx_lock, flags);
 	}
 
 	return;
