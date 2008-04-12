Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYDLQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYDLQXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYDLQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:23:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:27278 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbYDLQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=kn6lJHWejf+TKNr7w+oRqsogpKuWfEmMBDWg3upkQdBDNlNpHwKHlDA8le4dofPKAlJF2xJirCw6NOtEhEZbKSuVHfFu7HRWnoSHVx9saL8J5Gw9uh192j7r/iRRm2fzqPTW7ToutN7GBN9DHmkFakeDNdMIjBS6Cd9GVh/TLMM=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Date: Sat, 12 Apr 2008 18:24:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121543.10793.IvDoorn@gmail.com> <20080412144340.GG3402@khazad-dum.debian.net>
In-Reply-To: <20080412144340.GG3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121824.45302.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So when there already is a switch of that type present, then the value
> > will be set to the state of the first registered switch (either ON or OFF).
> > When no similar switch is present then it will be set to ON.
> 
> Where in the code do we change the *global* state for a switch type,
> based on the state of a particular switch of that type?  That's the step
> I am missing.

rfkill_switch_all() does exactly that and then calls rfkill_toggle_radio()
for all registered rfkill structures of the changed type.

rfkill_switch_all() is called from rfkill-input

> Here's the timeline of how I think (so far, anyway) these whole thing
> should work:
> 
> 1. rfkill class registers with kernel
>    - all initial global switch states (there are NO switches registered
>      yet) are set to ON (current rfkill) or to either ON or OFF based on
>      rfkill module parameters (with the patch).
> 
>      These are the "desired radio states for each radio type", and
>      are not related to whatever *real* state the hardware is in.  Let's
>      call them "global switch state (per switch type)", or "global
>      switch states" for short.
> 
>      These global switch states are usually manipulated by rfkill-input
>      when it traps input events that affect a certain type of switch
>      (and we should probably have a way to manipulate these global
>      states from userspace as well when rfkill-input is not loaded).

that is provided through sysfs, or some userspace tool that listens
to the input devices which have been registered.

> [user interaction to change these switch states MAY or MAY NOT happen
> here, it doesn't matter.  If it happens, the switch states CAN be
> changed]
> 
> 2. driver with rfkill support is loaded (coldplug, hotplug, etc)
> 
>    2.1 driver allocates an rfkill structure
> 
>    2.2 driver sets rfkill->state to the REAL state of the radio in
>        the hardware  [optional for write-only devices]  -- i'd prefer
>        the API made this mandatory by requesting this state as a
>        parameter of the rfkill_register() call.
> 
>    2.3 driver registers rfkill interface with the rfkill class
> 
>        2.3.1 rfkill class tries to set the radio state
>              (using toggle_radio() and updating rfkill->state if that
> 	     succeeds) to the CURRENT global switch state.
> 
> If we have something different than this, it is a bug.  And I am not
> clear what we should do in 2.3.1 WHEN the switch is a read-only switch,
> but my guess is that we just ignore the failure, as trying to match all
> other switches would break badly if there are more than one read-only
> switches of the same type, and their states don't match.

True but what a user doesn't want is this:

 - wireless key set to "ON"
 - boot kernel
 - press wireless key twice to actually enable the radio

I have a laptop containing 2 read-only keys, one for 802.11 and one for bluetooth,
the global state should be whatever those 2 keys say, otherwise the
status of the various keys can become completely messed up.

I think the chance of having 1 read-only key and multiple read-write/write-only
keys is bigger then having multiple read-only keys.

> > That I the issue that should be addressed with this patch:
> > 
> > - rfkill loads, sets initial state to UNDEFINED/UNITIALIZED
> 
> Which we don't have :(
> 
> > - driver with key X loads
> 
> We better make sure not to confuse the layers here.
> 
> We have a layer that deals with the switches themselves (rfkill), which
> has NOTHING to do with keys at all.  It lets one access the current
> switch state, and modify it.  It should also define the policy for what
> the initial state of the switch should be, IMO.
> 
> Drivers like b43 and thinkpad-acpi are connected to the rfkill layer.
> 
> We have a layer that should be OPTIONAL, and that listen to input events
> and manipulates the rfkill switches in semanthic groups ("switches for
> the same type of hardware").  This is rfkill-input.

right, rfkill-input is optional although I already noticed that at least b43 
makes that module mandatory for some reason.

> No drivers are connected to the rfkill-input layer directly.  When a
> driver can report something like EV_KEY KEY_RADIO or EV_SW SW_RADIO (and
> the type-specific ones, like KEY_WLAN), it connects directly to the
> input layer.

right.

> > - key X is registered to rfkill, driver provides current state in rfkill->state field
> 
> key X is registered to the INPUT LAYER...  so this doesn't make sense,
> or I am getting completely confused.

No sorry. The correct wording would be that:
Driver registered key X to the input layer
Driver registerd rfkill structure (for key X) to rfkill

The initial state of the rfkill structure should be set by the driver during registration
(either by initialization of the field, or as function argument as you suggested).

> > - rfkill checks global state with new state
> >    - if global state is UNDEFINED, then global state = rfkill->state
> 
> IMO, global state should NEVER be undefined.  Setting an initial policy
> for radios is a damn good idea.  And if it is to be hardcoded, we
> hardcode it to "radios OFF" which is always safe (but I'd just make it a
> module parameter).

Ok.

> >    - if global state == rfkill->state happy rfkill, nothing to do
> 
> For write-only switches, you ALWAYS have to set them initially.  If you
> mean the driver needs to do it to whatever it has done to rfkill->state
> BEFORE calling rfkill_register, I am fine with it, but we *NEED* to
> document that and revise all drivers to make sure it is correct.

No letting rfkill handle that would be safer, the driver should be in charge
of determining if toggle_radio() should really do something (in case the interface
hasn't been brought up yet).

> >    - if global state != rfkill->state change global state, toggle all radios
> > 
> > The state UNDEFINED/UNITIALIZED would in this case be a new state which should
> > be the default state during initialization.
> 
> I don't mind adding a new UNDEFINED state, it would be very useful for
> write-only switches which can be messed with by something other than the
> kernel.

Well if we are going to demand the initial state as argument it might not even
be needed. But then the driver should tell rfkill in some way that it is write-only.

> But I don't think it is a good idea at all to have "unknown" be allowed
> into the GLOBAL state.

Ok.

> Please let's go with either an OFF *initial* global state (safe), or a
> user-seletable *initial* global state (module parameter, and I'd say the
> best default would be OFF here too, but AFAIK, it is ON right now).
> 
> And there is absolutely no reason at all (as far as I can see, anyway)
> to let anything set the global state to "unknown".   If some radio
> switch can't follow the global state (e.g. it is read-only), it simply
> won't.  If someone overrides the state of the switch (write to state
> attribute) to be different from the global state, it will be brought
> back in sync the next time the global state changes.
> 
> I just thought of a way to let userspace mess with the global states
> when it wants to control an entire set of switches (and not just one).
> I will send in a patch if you like the idea:  basically, the rfkill
> class module also registers a platform driver, and platform devices for
> every type of switch.  THOSE devices are used to control the global
> state for each type of switch.   This makes rfkill-input functionality
> implementable in userspace, which is good.

Sounds like a good idea.

> > > > or call get_status() during registration to determine the new state itself.
> > > > That way we prevent series of module parameters and initialize to the state
> > > > the driver has indicated..
> > > 
> > > As an user, I do NOT want to have to deal with per-radio-module
> > > parameters in order to set their initial state to ON or OFF.  Yes, it is
> > > what we have right now for some radio devices, and it is extremely
> > > unoptimal.
> > 
> > Agreed, but having all those module parameters gathered into a single
> > module isn't a sound option either.
> 
> Sure it is, if that module is the class that controls all the radio
> switches (which rfkill is).   Unless we now make each rfkill radio type
> a module of its own, which is quite doable, but IMHO a lot of code
> complexity and memory waste for very little gain.

No seperating everything over multiple moduels sounds like a very bad idea.
I would prefer either the OFF default, or a single module parameter.
But again, if others also feel that multiple module parameters should be the way to
go I won't object that much. ;)

> > > > > Add a module parameter that causes all radios to be disabled when their
> > > > > rfkill interface is registered.  Add override parameters for each rfkill
> > > > > switch type as well, just in case the user wants the defaults to be
> > > > > different for a given radio type.
> > > > 
> > > > I am not a big fan of large series of module parameters, so in that aspect
> > > > I am not a fan of this patch.
> > > 
> > > If you think per-radio-type is too much, we just drop that part of the
> > > patch.  It will make it quite smaller, and it will preserve the
> > > functionality that is really needed (let the user tell the kernel to not
> > > try to power up radios by default).
> > 
> > That and my suggestion above about state checking during rfkill registration
> > would indeed improve things.
> 
> How about we have a *single* initial global state parameter, but
> disallow an "unknown" global state parameter?  Less user confusion, less
> module parameters, AND less code complexity.

Ok.

> > > I made it type-aware because I can see an user wanting the long-range
> > > radios off by default, and his personal-device-space radios (UWB,
> > > Bluetooth) on by default.
> > > 
> > > > > We don't change the module default, but I'd really recommed doing so in a
> > > > > future patch.
> > > 
> > > In fact, I better ask it now: do you want me to respin the patch with
> > > just one global switch, and make its default to be "radios offline" ?
> > 
> > If the above is too much to have it included in time for 2.6.26, I would
> > say the default to offline. But that is personal preference and I won't NACK
> > either solution. So I let you choose this one. :)
> 
> Ok, I will put my brains and fingers into high gear and come up with a
> new patchset, but first I have to look at input-pooldev to see if/how I
> can use that for thinkpad-acpi, in order to re-think the read-write
> support.

You can check the implementation in
drivers/net/wireless/rt2x00 or drivers/net/wireless/b43
for an example implementation, both use input-polldev.
I believe only rt2x00 has rfkill-write support while the b43 hardware toggles
the hardware directly and uses rfkill only for notifications.

> BTW: isn't it high time to add yourself as the RFKILL maintainer to
> MAINTAINERS (couldn't find you in there, nor RFKILL for that matter) and

True, I'll do that right away. :)

> also to document the rfkill class in Documentation/ ?

You mean like Documentation/rfkill.txt
It is a bit basic, but I haven't had time to expand it yet.

Ivo
