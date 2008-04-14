Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYDNBUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYDNBUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYDNBUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:20:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33749 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbYDNBUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:20:43 -0400
X-Sasl-enc: ZciS92tnCHNVl3HXMFDT76X9/fUwxA5ONectDw+C1nXi 1208136042
Date: Sun, 13 Apr 2008 22:20:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414012038.GB14406@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-5-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121236.43547.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > Currently, rfkill supports only write-only rfkill switches.  There is no
> > provision for querying the current switch state from the hardware/firmware.
> 
> No that is by design, the input_polled_dev interface is there for polling.

I have looked into this, now.  And I have to say I am not impressed with
the use of the input system for this.  My guess is that somehow the need
to issue state changes for "the stuff the user slides/presses" got
confused with the need to keep the state of the "hardware and software
that enables/disables radios", just because both are called "rfkill
switches".

The current flow for read/write switches (i.e. using input-polldev) is
this:

The players:
A: RFKILL class code: write-only with a state cache
B: rfkill-input
C: the code supporting the device registered with the rfkill class
D: something else, like a hardware signal line or firmware

The flow:
C: sets initial state, and registers rfkill device with A.
A: keeps state cache in sync with any changes that goes through it
D: toggles radio state directly, A doesn't know about it.
C: using pooling or some other method, finds out what D did.
C: issues an INPUT EVENT(!!) to force A to resync itself
B: traps the INPUT EVENT, and tells A to change radio state FOR ALL
   RADIOS of that type
A: toggles the radio to the state B wanted.

It is no surprise that b43 can't work right if it is using that flow.

Here's what is wrong with it:

  1. Usage of input events that matter to an entire group of drivers
     to syncronize something that is specific to a single device

  2. Dependency of an OPTIONAL input handler to do it, and let's not
     forget this can become a MAJOR mess if userspace decides to butt
     in, which it is indeed *expected* to do

  3. (some drivers like b43, not a rfkill class issue): the use of
     KEY_  events to set a desired state for a radio is wrong.  That
     event tells rfkill to toggle the radio state, and NOT to set it
     to a particular state.  One would need EV_SW events for this.

  4. Extremely heavy-weight, convoluted, complex information flow
     path, prone to races when there are multiple rfkill devices of
     the same type involved.

  5. Breaks completely if user_claim is used.

There might be more issues with this approach, but the above is damn
good enough reason to change the approach, already.

IMPORTANT: do note that there is nothing wrong with using input-polldev
to monitor a hardware GPIO pin or somesuch, and issue input events every
time there is a change in the state of a rfkill switch (in the "the
stuff the user slides/presses" sense).   That's not what I am talking
about.

> > This is bad on hardware where the switch state can change behind the
> > kernel's back (which is rather common).  There is no reason to keep kernel
> > state incorrect, when we have the possibility to match reality.
> > 
> > There is also the issue of read-only rfkill switches (support to be added
> > in a later patch), which absolutely requires support to read the current
> > state from the hardware in order to be implemented.
> 
> See rt2x00 and b43 in driver-wireless for an example implementation
> of pollable input device and rfkill

They're broken by design, at least in b43's case.  Someone (Carlos, I
believe?) posted an example of a ping-pong scenario using b43.

> I'm going to NACK this patch.

Given the above, would you ACK the idea that we implement a read path
for rfkill state (in the "hardware and software that enables/disables
radios" sense), which might as well be something very close to what this
patch did, AND leave input-polldev for the input device side of things?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
