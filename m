Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXEIKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXEIKmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXEIKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:42:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:43885 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbXEIKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YRTU4kb25/hC8wJH7Zuzy3NnzBUd3n9pvFqe1iZPNpFe9OZk75Qdv8cggItZGUgJcnDZWGEBUx7a7LIZ9IDGMw22KaYCTVQh33byUwE2Q30MMFxk7SI9+xIW50iKivVzWPNqv3MOYDWFui5M38zvBgQRVmtuiPTNA4tbQdWQXWQ=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Wed, 9 May 2007 06:42:35 -0400
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
Message-Id: <200705090642.35522.gene.heskett@gmail.com>
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

Sort of late, but,

I have a couple of kernels building with this patch applied, one with the 
sd-0.48 patch where FTDI stuff is a 40+% cpu hog and can't be used, and one 
with the cfs-v10 patch where it can be co-erced into working if I screw with 
it enough.

I have also been using another serial patch that for unk reasons, also helps 
the usb-serial case here, but vger won't let me repost that without stripping 
off the headers.  That patch has some resemblance to 
this:8250-clear-on-read-bits-LSR-MSR where I usually replace spaces with 
dashes so I don't have to use "to surround the name" in my scripts.

So these test kernels will have both patches.

I'll let you know how they work later this morning.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Oh my GOD -- the SUN just fell into YANKEE STADIUM!!
