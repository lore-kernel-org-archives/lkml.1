Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYDNOQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYDNOQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYDNOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:16:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10275 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYDNOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h2UN/WYkb4bFsPCF3PKLfRmDEyQzaHAiYeuiP41Es+q0aNgCCevUih2lpDvw2sR7j8feKEQ1YM0g+aWbonFI4ovXrzTgDjAmaU7lzx+iW77pAVe1i4uxi223nTbP9kdlxOctsEGzjMMjz5pnRmfeuVQPawbOCcO90jQNyrUWti0=
Date: Mon, 14 Apr 2008 10:16:06 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414100018.ZZRA012@mailhub.coreip.homeip.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804141400.41319.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 02:00:41PM +0200, Ivo van Doorn wrote:
> On Monday 14 April 2008, Henrique de Moraes Holschuh wrote:
> > On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > > Currently, rfkill supports only write-only rfkill switches.  There is no
> > > > provision for querying the current switch state from the hardware/firmware.
> > > 
> > > No that is by design, the input_polled_dev interface is there for polling.
> > 
> > I have looked into this, now.  And I have to say I am not impressed with
> > the use of the input system for this.  My guess is that somehow the need
> > to issue state changes for "the stuff the user slides/presses" got
> > confused with the need to keep the state of the "hardware and software
> > that enables/disables radios", just because both are called "rfkill
> > switches".
> >
> > The current flow for read/write switches (i.e. using input-polldev) is
> > this:
> > 
> > The players:
> > A: RFKILL class code: write-only with a state cache
> > B: rfkill-input
> > C: the code supporting the device registered with the rfkill class
> > D: something else, like a hardware signal line or firmware
> > 
> > The flow:
> > C: sets initial state, and registers rfkill device with A.
> > A: keeps state cache in sync with any changes that goes through it
> > D: toggles radio state directly, A doesn't know about it.
> > C: using pooling or some other method, finds out what D did.
> > C: issues an INPUT EVENT(!!) to force A to resync itself
> > B: traps the INPUT EVENT, and tells A to change radio state FOR ALL
> >    RADIOS of that type
> > A: toggles the radio to the state B wanted.
> > 
> > It is no surprise that b43 can't work right if it is using that flow.
> > 
> > Here's what is wrong with it:
> > 
> >   1. Usage of input events that matter to an entire group of drivers
> >      to syncronize something that is specific to a single device
> >
> >   2. Dependency of an OPTIONAL input handler to do it, and let's not
> >      forget this can become a MAJOR mess if userspace decides to butt
> >      in, which it is indeed *expected* to do
> 
> The input handler is optional, because userspace *should* actually do all
> the work. Userspace should listen to the registered input device and
> it is userspace that should select the input device it wants to listen to.
> (perhaps the laptop has 2 or more keys, but the user wants all interfaces
> to be toggled when any key has been pressed).
> 
> >   3. (some drivers like b43, not a rfkill class issue): the use of
> >      KEY_  events to set a desired state for a radio is wrong.  That
> >      event tells rfkill to toggle the radio state, and NOT to set it
> >      to a particular state.  One would need EV_SW events for this.
> 
> That is a rfkill issue due to lack of correct documentation and problems
> with the rfkill implementation. I wouldn't blame the drivers for that. ;)
> 
> >   4. Extremely heavy-weight, convoluted, complex information flow
> >      path, prone to races when there are multiple rfkill devices of
> >      the same type involved.
> > 
> >   5. Breaks completely if user_claim is used.
> > 

What exactly breaks with user_claim? I think the general issue is that
rfkill was originally not supposed to be used with switches that can't
be programmatically controlled. If we have a switch that mechanically
cuts off power to the RF transmitter rfkill can't relly do anything.
The input side (input polldev or other kind of button/switch/slider
inmplementation) still can issue KEY_WLAN or something to indicate that
user toggled the state and userspace or kernel may try to shut off the
rest of RF transmitters in the box but as far as this particlular
switch goes it is game over. I expected that here we'd just rely on
netif_carrier_* to notify the network side of things about interface
losing connection.

Unfortunately (or may be fortunately, I am not quite sure yet) rfkill
started to be used for mechanical type switches as well, disabling
user_claim option, so now we do need the "read-only" kind of rfkill
switch support that allows setting switch state directly from the
driver.

-- 
Dmitry
