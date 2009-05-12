Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZELHz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZELHz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZELHzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:55:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41751 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815AbZELHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:55:11 -0400
X-Sasl-enc: tnPKOpNlPYt4kA6wWTFyjUy+BqsZXiYbOO5/wzgCtiIV 1242114911
Message-ID: <4A092B5C.603@ladisch.de>
Date: Tue, 12 May 2009 09:55:08 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, todd@fries.net
Subject: Re: bad endpoint address, MOTU FastLane
References: <20090511221203.GB4300@spacedout.fries.net>
In-Reply-To: <20090511221203.GB4300@spacedout.fries.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> usb_submit_urb returns -22 EINVAL invalid argument as it is trying to
> submit an interrupt packet to what is registered as an isoc endpoint.
> The second interface has the same end point addresses as the first.
> Any suggestions on how to deal with this class of broken hardware?
> 
> I:* If#= 0 Alt= 0 ...
> E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=1ms
> I:* If#= 1 Alt= 0 ...
> E:  Ad=81(I) Atr=01(Isoc) MxPS=   4 Ivl=1ms

AFAICS the USB core memorizes the descriptor belonging to a specific
endpoint number whenever usb_set_interface() is called.  In this case,
the second interface is initialized later, so the second set of
descriptors wins.

The driver could call usb_set_interface() again for the first interface
so that the USB core takes notice of the first set of endpoints again.
Please try the patch below.

I guess I'll have to write another quirk for this.


--- linux/sound/usb/usbmidi.c
+++ linux/sound/usb/usbmidi.c
@@ -1779,6 +1779,7 @@
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
 	case QUIRK_MIDI_RAW:
+		usb_set_interface(umidi->chip->dev, 0, 0);
 		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
