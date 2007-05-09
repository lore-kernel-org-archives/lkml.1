Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXEILDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXEILDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXEILDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:03:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:53796 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEILDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oJS2QhOTN22ebssDyQw+DlmUNdBkw/QOtkz6IyiaEzOuoMnoWwMQqUvyMe/f2JD/kGQWfUvYf4UuP/WNAccdocBzhGF243myTUePGYcfJX/V3ht+qKpeAFsOnTZiCqFHv38ZYkp1mmU25rXi1Dwl06wfJRQDSWixUSjeUkdZmww=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Wed, 9 May 2007 07:02:48 -0400
User-Agent: KMail/1.9.6
Cc: "Antonino Ingargiola" <tritemio@gmail.com>,
       "Paul Fulghum" <paulkf@microgate.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com> <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com> <200705052035.58782.oliver@neukum.org>
In-Reply-To: <200705052035.58782.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705090702.48576.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2007, Oliver Neukum wrote:
>Am Samstag, 5. Mai 2007 20:08 schrieb Antonino Ingargiola:
>> Now I don't want to abuse your kindness, but I (personally) would be
>> *really* interested in a similar fix for the FTDI usb-serial driver,
>> because many measurements I do use an FTDI device.
>
>Does this work?
>
>	Regards
>		Oliver
>----
>
>--- a/drivers/usb/serial/ftdi_sio.c	2007-05-05 20:21:41.000000000 +0200
>+++ b/drivers/usb/serial/ftdi_sio.c	2007-05-05 20:27:09.000000000 +0200
>@@ -1749,10 +1749,6 @@ static void ftdi_process_read (struct wo
> 			length = 0;
> 		}
>
>-		if (priv->rx_flags & THROTTLED) {
>-			dbg("%s - throttled", __FUNCTION__);
>-			break;
>-		}
> 		if (tty_buffer_request_room(tty, length) < length) {
> 			/* break out & wait for throttling/unthrottling to happen */
> 			dbg("%s - receive room low", __FUNCTION__);
>@@ -1825,16 +1821,6 @@ static void ftdi_process_read (struct wo
> 		dbg("%s - incomplete, %d bytes processed, %d remain",
> 				__FUNCTION__, packet_offset,
> 				urb->actual_length - packet_offset);
>-		/* check if we were throttled while processing */
>-		spin_lock_irqsave(&priv->rx_lock, flags);
>-		if (priv->rx_flags & THROTTLED) {
>-			priv->rx_flags |= ACTUALLY_THROTTLED;
>-			spin_unlock_irqrestore(&priv->rx_lock, flags);
>-			dbg("%s - deferring remainder until unthrottled",
>-					__FUNCTION__);
>-			return;
>-		}
>-		spin_unlock_irqrestore(&priv->rx_lock, flags);
> 		/* if the port is closed stop trying to read */
> 		if (port->open_count > 0){
> 			/* delay processing of remainder */
>@@ -1856,9 +1842,15 @@ static void ftdi_process_read (struct wo
> 			      port->read_urb->transfer_buffer,
> port->read_urb->transfer_buffer_length, ftdi_read_bulk_callback, port);
>
>-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
>-		if (result)
>-			err("%s - failed resubmitting read urb, error %d", __FUNCTION__,
> result); +		spin_lock_irqsave(&priv->rx_lock, flags);
>+		if (priv->rx_flags & THROTTLED) {
>+			priv->rx_flags |= ACTUALLY_THROTTLED;
>+		} else {
>+			result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
>+			if (result)
>+				err("%s - failed resubmitting read urb, error %d", __FUNCTION__,
> result); +		}
>+		spin_unlock_irqrestore(&priv->rx_lock, flags);
> 	}
>
> 	return;
>-
Oliver:

While running kernel-2.6.21.1-sd-0.48 + this and the other patch I mentioned,

Unforch, this patch doesn't seem to have effected my usb-serial problems, for 
upsd anyway, it's running at 47% of the cpu right now, while running sd-0.48.

Occasionally a stop and restart will fix it...  Nope.  On the restart, its 
about 3% _until_ something starts reading its output data file, which could 
be gkrellmBUPS, or its own gui, either one bounces it back up to 45+% of the 
cpu.  On a kernel where it works sorta right, as in a recent fedora kernel, 
its about 1.5%, and on even older 2.6.18ish stuff, this utility ran at .1% of 
the cpu regardless of who read its output data.  But that was with a pl2303 
adapter, which no longer works at all so I bought some ftdi based ones.

So the next boot will be to cfs-v10 + these.



>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
For certain people, after fifty, litigation takes the place of sex.
		-- Gore Vidal
