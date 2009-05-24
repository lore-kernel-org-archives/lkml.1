Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZEXWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZEXWOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbZEXWJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:09:18 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:37650 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097AbZEXWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:09:16 -0400
Date: Sun, 24 May 2009 17:07:56 -0500
From: David Fries <david@fries.net>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: bad endpoint address, MOTU FastLane
Message-ID: <20090524220756.GC4300@spacedout.fries.net>
References: <20090511221203.GB4300@spacedout.fries.net> <4A092B5C.603@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A092B5C.603@ladisch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 24 May 2009 17:08:02 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:55:08AM +0200, Clemens Ladisch wrote:
> David Fries wrote:
> > usb_submit_urb returns -22 EINVAL invalid argument as it is trying to
> > submit an interrupt packet to what is registered as an isoc endpoint.
> > The second interface has the same end point addresses as the first.
> > Any suggestions on how to deal with this class of broken hardware?
> > 
> > I:* If#= 0 Alt= 0 ...
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=1ms
> > I:* If#= 1 Alt= 0 ...
> > E:  Ad=81(I) Atr=01(Isoc) MxPS=   4 Ivl=1ms
> 
> AFAICS the USB core memorizes the descriptor belonging to a specific
> endpoint number whenever usb_set_interface() is called.  In this case,
> the second interface is initialized later, so the second set of
> descriptors wins.
> 
> The driver could call usb_set_interface() again for the first interface
> so that the USB core takes notice of the first set of endpoints again.
> Please try the patch below.
> 
> I guess I'll have to write another quirk for this.

Thanks for the quick response, sorry for taking so long to test it.
Adding usb_set_interface lets the device work again, I had been
tracking this down for a while, I'm glad you knew what to do.

The MOTU Fastlane device is the only one using QUIRK_MIDI_RAW.  How about
changing the name to QUIRK_MIDI_FASTLANE to imply it isn't completely
generic anymore and adding a comment?  I can write up that patch if
it's agreeable.  The only danger I see is if there are some MOTU
Fastlane devices with a corrected descriptor record, but if that were
the case setting it to the 0 alternative setting would be a no-op in
that case, so it sounds good to me.

	case QUIRK_MIDI_FASTLANE:
		/* MOTU Fastlane has two interfaces with the second
		 * interface reusing the endpoint addresses voilating
		 * the standard.  Select interface 0 again to reload
		 * that configuration.
		 */
		usb_set_interface(umidi->chip->dev, 0, 0);
		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
		break;

> --- linux/sound/usb/usbmidi.c
> +++ linux/sound/usb/usbmidi.c
> @@ -1779,6 +1779,7 @@
>  		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
>  		break;
>  	case QUIRK_MIDI_RAW:
> +		usb_set_interface(umidi->chip->dev, 0, 0);
>  		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
>  		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
>  		break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
