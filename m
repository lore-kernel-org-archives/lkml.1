Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbYDMRfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbYDMRfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYDMRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:35:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYDMRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=gUygBAopKBME09NPe8Rw0bL+qbIUl9dUokjMQpwWyb9L+sObGGupFkOYSV5MFm5rlbii95CI7QA57DynPMNcJ5mFIVvzkBRGoxlDsRQ8pfGmtZE/uri25tIdTOWsTO44N9IRUUxzhvhMwN3cOSbI9f1Bddg8r2yCYuFmYcyGab0=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Date: Sun, 13 Apr 2008 19:37:13 +0200
User-Agent: KMail/1.9.9
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121623.17453.inaky@linux.intel.com> <20080413172554.GA31364@khazad-dum.debian.net>
In-Reply-To: <20080413172554.GA31364@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131937.13385.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Inaky Perez-Gonzalez wrote:
> > Most rfkill hw keys are attached to the device. So I can plug wifi, wimax,
> > 3G, UWB and BT dongles (or cards) into a system and they each provide a HW
> > switch (or should provide).
> > 
> > If each overrides another one, we have a problem.
> 
> Yeah, and we have to avoid such problems.
> 
> But let me ask you one thing.  Are we talking of different rfkill
> switches, OR are we talking about different KEYs or BUTTONS in the
> keyboard/keypad/console/remote control?
> 
> Because one thing has very little to do with the other.  No network
> device driver shall generate an input event after I am done with the
> next patch set...

Not sure if that will be the desired course of action.
The original rfkill function didn't work with input devices either and just
handled everything in rfkill.
But the input layer people requested the change to use input devices and let
rfkill hook into that, because a rfkill switch/key can be considered an input device.

I've CC'ed Dmitry into this discussion since he was the one who suggested the
input device interaction initialy (and created the rfkill-input module).

> On the other hand, if you DO have a WiMax, 3G, or EDGE *key* or
> *button*, THEN you need a KEY_WIMAX, KEY_3G, KEY_EDGE, or whatever. Even
> if there was no rfkill class in existence :-) and that's only if you
> would find more than one of them in a keyboard/console/remote
> control/keypad, otherwise KEY_WWAN would be enough.  Adding input events
> is *expensive*.
> 
> The same idea is also true for switches, which must use EV_SW SW_* and
> NEVER try to simulate a switch using KEY_* or BUTTON_*.
> 
> So, we CAN keep RFKILL_TYPE_WIMAX, and this is decoupled to keeping
> KEY_WIMAX.  These are two different decisions, and are not related to
> each other in any way.
> 
> Do we *have* devices with WiMAX keys or buttons that ALSO have non-WiMAX
> WWAN keys or buttons [that support Linux]?  If so, you need KEY_WIMAX
> events (and/or BUTTON_WIMAX, depends on the type of event being
> generated).  This has nothing to do with rfkill.   The same question and
> rationale applies to devices with switches (i.e. stuff that latches to a
> state), and SW_* events.
> 
> Is it a good idea to have WiMAX as a separate type for rfkill switches?
> Probably.  I'd actually say we should have a two-tier approach:
> 
> 1. switch class:
>    WLAN - (wifi stuff and whatever else looks like a WLAN)
>    WWAN - (3G, WiMAX, etch)
>    personal devices (or whatever the right name for this is): UWB, Bluetooth
>    ALL/ANY - "all radios" button/switches/etc
> 
> 2. switch type:
>    802.11abgn(WiFi), 802.16(WiMAX), EDGE/UMTS/X-RTT(Cell), UWB,
>    BLUETOOTH, ANY...  this can certainly be granular to the technology
>    level.
> 
> That would make it easier for rfkill-input to decide on what switches it
> should operate when it gets an specific input event.  We would make it
> operate on all WWAN-class rf switches for KEY_WWAN (and that would
> include WiMAX), and we could make it operate on all switches of a
> specific type, e.g. only bluetooth (and not bluetooth+UWB) for
> KEY_BLUETOOTH.
> 
> > I guess before I didn't have it as clear as I do now, but I am just seeing
> > more and more that each radio has its own kill switch and then the system
> > might have a generic one (for example fn+F5 on thinkpads) for killing all
> > of them at the same time.
> 
> Exactly, and we have to enhance rfkill to address that model properly.
> 
> My current idea of how it could work is:
> 
> 1. "Master" switches: those who are to control an entire class of radios
> (i.e. all devices of the same type), or all radios (type "any").  The
> most typical example is a RO rfkill switch in a laptop or gadget, and
> buttons and hot-keys in laptops or gadgets.  Master switches may issue
> input events when needed (it usually is).
> 
> 2. "slave" switches: this is what you usually have on the chipsets and
> their drivers (typically, two of them: a hardware one driven by an input
> pin in the hardware that the driver can *read* (i.e. it is read-only),
> and a software one in the driver code, which is read-write).  They
> *never* issue input events.
> 
> The big bad thing we need to always keep in mind is that that input pin
> in a radio chipset that is exported as a read-only rfkill switch might
> be a slave in one gadget/platform, and a master in another
> gadget/plaftform.  Let userspace or a platform/gadget-specific platform
> driver configure this.  Place all glue related to this in the rfkill
> class.
> 


