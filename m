Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYDNL6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYDNL6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYDNL57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:57:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:31487 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYDNL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=sRNrw3CmC0To3K70PlRYCSXqOvlUSkgie0B88+PruFOtYGu9aq8nxIPCrolQS4GKZXjM1cHQNwtqG6p3zji3l+vlY6buELi676RkLVL581uyCRJFzk7Oypfa9HabCgeOUp0d5Uc/GDw06r7r1Sjk5Q3hXqk71EV+n1Y1FUP/Fco=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Mon, 14 Apr 2008 14:00:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net>
In-Reply-To: <20080414012038.GB14406@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141400.41319.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > Currently, rfkill supports only write-only rfkill switches.  There is no
> > > provision for querying the current switch state from the hardware/firmware.
> > 
> > No that is by design, the input_polled_dev interface is there for polling.
> 
> I have looked into this, now.  And I have to say I am not impressed with
> the use of the input system for this.  My guess is that somehow the need
> to issue state changes for "the stuff the user slides/presses" got
> confused with the need to keep the state of the "hardware and software
> that enables/disables radios", just because both are called "rfkill
> switches".
>
> The current flow for read/write switches (i.e. using input-polldev) is
> this:
> 
> The players:
> A: RFKILL class code: write-only with a state cache
> B: rfkill-input
> C: the code supporting the device registered with the rfkill class
> D: something else, like a hardware signal line or firmware
> 
> The flow:
> C: sets initial state, and registers rfkill device with A.
> A: keeps state cache in sync with any changes that goes through it
> D: toggles radio state directly, A doesn't know about it.
> C: using pooling or some other method, finds out what D did.
> C: issues an INPUT EVENT(!!) to force A to resync itself
> B: traps the INPUT EVENT, and tells A to change radio state FOR ALL
>    RADIOS of that type
> A: toggles the radio to the state B wanted.
> 
> It is no surprise that b43 can't work right if it is using that flow.
> 
> Here's what is wrong with it:
> 
>   1. Usage of input events that matter to an entire group of drivers
>      to syncronize something that is specific to a single device
>
>   2. Dependency of an OPTIONAL input handler to do it, and let's not
>      forget this can become a MAJOR mess if userspace decides to butt
>      in, which it is indeed *expected* to do

The input handler is optional, because userspace *should* actually do all
the work. Userspace should listen to the registered input device and
it is userspace that should select the input device it wants to listen to.
(perhaps the laptop has 2 or more keys, but the user wants all interfaces
to be toggled when any key has been pressed).

>   3. (some drivers like b43, not a rfkill class issue): the use of
>      KEY_  events to set a desired state for a radio is wrong.  That
>      event tells rfkill to toggle the radio state, and NOT to set it
>      to a particular state.  One would need EV_SW events for this.

That is a rfkill issue due to lack of correct documentation and problems
with the rfkill implementation. I wouldn't blame the drivers for that. ;)

>   4. Extremely heavy-weight, convoluted, complex information flow
>      path, prone to races when there are multiple rfkill devices of
>      the same type involved.
> 
>   5. Breaks completely if user_claim is used.
> 
> There might be more issues with this approach, but the above is damn
> good enough reason to change the approach, already.

True.

> IMPORTANT: do note that there is nothing wrong with using input-polldev
> to monitor a hardware GPIO pin or somesuch, and issue input events every
> time there is a change in the state of a rfkill switch (in the "the
> stuff the user slides/presses" sense).   That's not what I am talking
> about.

Right.
But note that network hardware with such keys will have a driver that handles
both features. So such network drivers will have a input device and will send
a signal that the key was pressed regardless of the current state they are in.

> > > This is bad on hardware where the switch state can change behind the
> > > kernel's back (which is rather common).  There is no reason to keep kernel
> > > state incorrect, when we have the possibility to match reality.
> > > 
> > > There is also the issue of read-only rfkill switches (support to be added
> > > in a later patch), which absolutely requires support to read the current
> > > state from the hardware in order to be implemented.
> > 
> > See rt2x00 and b43 in driver-wireless for an example implementation
> > of pollable input device and rfkill
> 
> They're broken by design, at least in b43's case.  Someone (Carlos, I
> believe?) posted an example of a ping-pong scenario using b43.

Thats true. But was that a scenario where there were 2 keys for the same radio type?
Or was that a matter of the driver indicating a key pressed event while it has no
attached key to it, and only checked the register for the key status and the current radio
status and saw it was different?

For example rt2x00 does:
hasHardwareKey()
 yes -> register input_polldev, check key status
 no -> don't do anything.

Note that write-only support hasn't been implemented yet, so rt2x00 will do nothing
if the hardware doesn't have a hardware key attached to it.

> > I'm going to NACK this patch.
> 
> Given the above, would you ACK the idea that we implement a read path
> for rfkill state (in the "hardware and software that enables/disables
> radios" sense), which might as well be something very close to what this
> patch did, AND leave input-polldev for the input device side of things?

Depends on the implementation, I think we should at least have the following requirements:
 - _all_ wireless (wifi, bluetooth, etc) network drivers register themselves to rfkill
 - radio-key driver polls or listens to hardware events and sends them through the input layer
 - it must be caught by either:
	1) userspace (default): This can either run a lot of scripts of send a notification to rfkill
	2) rfkill-input: sens notification to rfkill
 - rfkill goes past all registered rfkill instances to toggle the status.

Note that the rfkill and rfkill-input description is incomplete since that is where this thread
is about. So the actions that those 2 layers should exactly do is not defined yet in this list.
However the first 2 points should be the case regardless of how rfkill handles things.

Ivo
