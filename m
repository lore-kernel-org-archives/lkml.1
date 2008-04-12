Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYDLNlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYDLNlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 09:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYDLNll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 09:41:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:8201 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYDLNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 09:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=B84vBoIr1faztLm68xd1kz2H/MvERQ12sczAiOKRt84r4rvtSRSs+O4hzgTI7KMdCIq/UQj4UxP8ahQF7Zaahb8P9XmA69FJQhckFUkvb0ybIqyfFcXKVP6bsDcl8yp26rEhKDxyGzlWqQSf1Nni89+rI8XnzHQ0V55X81Z2bLY=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Date: Sat, 12 Apr 2008 15:43:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.46626.IvDoorn@gmail.com> <20080412125620.GC3402@khazad-dum.debian.net>
In-Reply-To: <20080412125620.GC3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121543.10793.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > Currently, radios are always enabled when their rfkill interface is
> > > registered.  This is not optimal, the safest state for a radio is to be
> > > offline unless the user turns it on.
> > 
> > It defaults to the current state of the switch type.
> 
> Hmm, I better reword that to "Currently, the desired radio state is
> hardcoded in rfkill to be initially ON."  Would that be more clear?

No your original comment was clear enough, what I meant is that
the radio of the added switch is set to the state which is currently global
for that particular type.
So when there already is a switch of that type present, then the value
will be set to the state of the first registered switch (either ON or OFF).
When no similar switch is present then it will be set to ON.

> The patch changes the initial state of the switch type, the one rfkill
> currently is hardcoded to set to "RADIO IS ON" at module load.  I.e. it
> just removes the hardcoding by making it possible to set the desired
> initial state of all radios at module load time.
> 
> This makes rfkill actually a damn good UI for radio switch
> initialization, IMHO.  You tell the kernel what is the state you want
> for all radios in just one place and rfkill enforces all radios are set
> to that state during bootstrap and initial coldplug party.
> 
> Drivers loaded later will be set to whatever the global state of their
> switch type in rfkill is at the moment.

This is already implemented, the part that is missing is that for the first
added device it doesn't listen to the state of the hardware switch/button.
That I the issue that should be addressed with this patch:

- rfkill loads, sets initial state to UNDEFINED/UNITIALIZED
- driver with key X loads
- key X is registered to rfkill, driver provides current state in rfkill->state field
- rfkill checks global state with new state
   - if global state is UNDEFINED, then global state = rfkill->state
   - if global state == rfkill->state happy rfkill, nothing to do
   - if global state != rfkill->state change global state, toggle all radios

The state UNDEFINED/UNITIALIZED would in this case be a new state which should
be the default state during initialization.

> > What perhaps could be done, is that during registration it either reads
> > the status directly from rfkill to what the device initialized it to,
> 
> I am *all* for a proper init of rfkill->state to match the real hardware
> state.  I have always been, and I complained about that when rfkill
> initially landed in mainline.
> 
> But I do agree that the current "desired behaviour" of rfkill (i.e. what
> it should be doing, barring any bugs): that it will immediately set
> newly registered radios to the state their type switch is at, to be a
> good idea.
> 
> In fact, for write-only radios, you *have* to enforce their initial
> state, because it is effectively unknown.  And in order to do that, you
> must avoid any code paths that would do stuff like "if (rfk->state !=
> desired_state) toggle_radio(desired_state)".

Ok, for those devices we should set the default state to OFF _unless_
other devices of the same type are already present in which case the
default state should be set to the current global state for that type.

> > or call get_status() during registration to determine the new state itself.
> > That way we prevent series of module parameters and initialize to the state
> > the driver has indicated..
> 
> As an user, I do NOT want to have to deal with per-radio-module
> parameters in order to set their initial state to ON or OFF.  Yes, it is
> what we have right now for some radio devices, and it is extremely
> unoptimal.

Agreed, but having all those module parameters gathered into a single
module isn't a sound option either.

> Keeping track of the radio state (including which initial state it
> should be set to) is exactly what something like the rfkill layer is
> supposed to be good at: set parameters for an entire class of hardware
> in a generic way, in a single place, and in one go.

agreed.

> > > Add a module parameter that causes all radios to be disabled when their
> > > rfkill interface is registered.  Add override parameters for each rfkill
> > > switch type as well, just in case the user wants the defaults to be
> > > different for a given radio type.
> > 
> > I am not a big fan of large series of module parameters, so in that aspect
> > I am not a fan of this patch.
> 
> If you think per-radio-type is too much, we just drop that part of the
> patch.  It will make it quite smaller, and it will preserve the
> functionality that is really needed (let the user tell the kernel to not
> try to power up radios by default).

That and my suggestion above about state checking during rfkill registration
would indeed improve things.

> I made it type-aware because I can see an user wanting the long-range
> radios off by default, and his personal-device-space radios (UWB,
> Bluetooth) on by default.
> 
> > > We don't change the module default, but I'd really recommed doing so in a
> > > future patch.
> 
> In fact, I better ask it now: do you want me to respin the patch with
> just one global switch, and make its default to be "radios offline" ?

If the above is too much to have it included in time for 2.6.26, I would
say the default to offline. But that is personal preference and I won't NACK
either solution. So I let you choose this one. :)

Ivo
