Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZELOIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZELOIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZELOIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:08:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57500 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751062AbZELOID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:08:03 -0400
Date: Tue, 12 May 2009 10:08:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: David Fries <david@fries.net>, David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <todd@fries.net>
Subject: Re: bad endpoint address, MOTU FastLane
In-Reply-To: <4A092B5C.603@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.0905121000020.2799-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Clemens Ladisch wrote:

> David Fries wrote:
> > usb_submit_urb returns -22 EINVAL invalid argument as it is trying to
> > submit an interrupt packet to what is registered as an isoc endpoint.

How does one know which type the endpoint really is?  Through prior 
experience with the device?

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
> 
> 
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

This is only a bandaid.  The underlying problem is still there.  
Basically, the second interface shouldn't exist at all.  The only
proper way to deal with it is to pretend there's only one interface --
which would mean changing the descriptors before the kernel parses
them.

A much easier approach is to throw the device away and replace it with 
something that _is_ compliant with the USB specification.

Alan Stern

