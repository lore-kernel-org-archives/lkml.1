Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZEZAmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZEZAmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZEZAmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:42:11 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:59962 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZEZAmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:42:09 -0400
Date: Mon, 25 May 2009 19:41:46 -0500
From: David Fries <david@fries.net>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: bad endpoint address, MOTU FastLane
Message-ID: <20090526004146.GD4300@spacedout.fries.net>
References: <20090511221203.GB4300@spacedout.fries.net> <4A092B5C.603@ladisch.de> <20090524220756.GC4300@spacedout.fries.net> <4A1A54DB.3090902@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A54DB.3090902@ladisch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 25 May 2009 19:41:50 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:20:43AM +0200, Clemens Ladisch wrote:
> David Fries wrote:
> > On Tue, May 12, 2009 at 09:55:08AM +0200, Clemens Ladisch wrote:
> > > The driver could call usb_set_interface() again for the first interface
> > > so that the USB core takes notice of the first set of endpoints again.
> > > Please try the patch below.
> > > 
> > > I guess I'll have to write another quirk for this.
> > 
> > Adding usb_set_interface lets the device work again, ...
> > 
> > The MOTU Fastlane device is the only one using QUIRK_MIDI_RAW.  How about
> > changing the name to QUIRK_MIDI_FASTLANE to imply it isn't completely
> > generic anymore and adding a comment?
> 
> And while we're at it, the driver should claim interface 1 to prevent
> anyone else from using it.

Before and after the latest patch snd-usb-audio claims interface 1.
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=04 Prot=ff Driver=snd-usb-audio
I:* If#= 1 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=03 Prot=ff Driver=snd-usb-audio

The new snd_usbmidi_detect_fastlane in case 1 returns 1, which then
will return 0 from snd_usb_create_midi_interface, but
ignore_interface_quirk already returns 0 if it was left with the
ignore interface quirk, so I don't see a need for that part of the
patch.

> New patch below.
> 
> Are you okay with the tested-by tag?

Yes, it works.  I'm watching the LEDs blink on the device and data
come across.

> +static int snd_usbmidi_detect_fastlane(struct snd_usb_midi *umidi,
> +				       struct snd_usb_midi_endpoint_info *eps)
> +{
> +	switch (get_iface_desc(umidi->iface->altsetting)->bInterfaceNumber) {
...
> +	case 1:
> +		return 1; /* no MIDI device for this interface, just claim it */

> @@ -1778,9 +1805,13 @@ int snd_usb_create_midi_interface(struct
> +		err = snd_usbmidi_detect_fastlane(umidi, endpoints);
> +		if (err == 1) {
> +			kfree(umidi);
> +			return 0;
> +		}

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
