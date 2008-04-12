Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYDLOnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYDLOnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 10:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYDLOnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 10:43:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39207 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbYDLOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 10:43:45 -0400
X-Sasl-enc: G/dHnncf9NHaeuPdKGXp24I+NpzfVALgPF+gCTHmSmS1 1208011423
Date: Sat, 12 Apr 2008 11:43:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Message-ID: <20080412144340.GG3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.46626.IvDoorn@gmail.com> <20080412125620.GC3402@khazad-dum.debian.net> <200804121543.10793.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121543.10793.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> > On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > > Currently, radios are always enabled when their rfkill interface is
> > > > registered.  This is not optimal, the safest state for a radio is to be
> > > > offline unless the user turns it on.
> > > 
> > > It defaults to the current state of the switch type.
> > 
> > Hmm, I better reword that to "Currently, the desired radio state is
> > hardcoded in rfkill to be initially ON."  Would that be more clear?
> 
> No your original comment was clear enough, what I meant is that
> the radio of the added switch is set to the state which is currently global
> for that particular type.

Which is exactly what should be done, yes.  So far, I understood the
code correctly.

> So when there already is a switch of that type present, then the value
> will be set to the state of the first registered switch (either ON or OFF).
> When no similar switch is present then it will be set to ON.

Where in the code do we change the *global* state for a switch type,
based on the state of a particular switch of that type?  That's the step
I am missing.

Here's the timeline of how I think (so far, anyway) these whole thing
should work:

1. rfkill class registers with kernel
   - all initial global switch states (there are NO switches registered
     yet) are set to ON (current rfkill) or to either ON or OFF based on
     rfkill module parameters (with the patch).

     These are the "desired radio states for each radio type", and
     are not related to whatever *real* state the hardware is in.  Let's
     call them "global switch state (per switch type)", or "global
     switch states" for short.

     These global switch states are usually manipulated by rfkill-input
     when it traps input events that affect a certain type of switch
     (and we should probably have a way to manipulate these global
     states from userspace as well when rfkill-input is not loaded).

[user interaction to change these switch states MAY or MAY NOT happen
here, it doesn't matter.  If it happens, the switch states CAN be
changed]

2. driver with rfkill support is loaded (coldplug, hotplug, etc)

   2.1 driver allocates an rfkill structure

   2.2 driver sets rfkill->state to the REAL state of the radio in
       the hardware  [optional for write-only devices]  -- i'd prefer
       the API made this mandatory by requesting this state as a
       parameter of the rfkill_register() call.

   2.3 driver registers rfkill interface with the rfkill class

       2.3.1 rfkill class tries to set the radio state
             (using toggle_radio() and updating rfkill->state if that
	     succeeds) to the CURRENT global switch state.

If we have something different than this, it is a bug.  And I am not
clear what we should do in 2.3.1 WHEN the switch is a read-only switch,
but my guess is that we just ignore the failure, as trying to match all
other switches would break badly if there are more than one read-only
switches of the same type, and their states don't match.

> > The patch changes the initial state of the switch type, the one rfkill
> > currently is hardcoded to set to "RADIO IS ON" at module load.  I.e. it
> > just removes the hardcoding by making it possible to set the desired
> > initial state of all radios at module load time.
> > 
> > This makes rfkill actually a damn good UI for radio switch
> > initialization, IMHO.  You tell the kernel what is the state you want
> > for all radios in just one place and rfkill enforces all radios are set
> > to that state during bootstrap and initial coldplug party.
> > 
> > Drivers loaded later will be set to whatever the global state of their
> > switch type in rfkill is at the moment.
> 
> This is already implemented, the part that is missing is that for the first
> added device it doesn't listen to the state of the hardware switch/button.

Why should it?  See below for my comments on centralizing this policy on
the "initial state of radios" on rfkill.

> That I the issue that should be addressed with this patch:
> 
> - rfkill loads, sets initial state to UNDEFINED/UNITIALIZED

Which we don't have :(

> - driver with key X loads

We better make sure not to confuse the layers here.

We have a layer that deals with the switches themselves (rfkill), which
has NOTHING to do with keys at all.  It lets one access the current
switch state, and modify it.  It should also define the policy for what
the initial state of the switch should be, IMO.

Drivers like b43 and thinkpad-acpi are connected to the rfkill layer.

We have a layer that should be OPTIONAL, and that listen to input events
and manipulates the rfkill switches in semanthic groups ("switches for
the same type of hardware").  This is rfkill-input.

No drivers are connected to the rfkill-input layer directly.  When a
driver can report something like EV_KEY KEY_RADIO or EV_SW SW_RADIO (and
the type-specific ones, like KEY_WLAN), it connects directly to the
input layer.

> - key X is registered to rfkill, driver provides current state in rfkill->state field

key X is registered to the INPUT LAYER...  so this doesn't make sense,
or I am getting completely confused.

> - rfkill checks global state with new state
>    - if global state is UNDEFINED, then global state = rfkill->state

IMO, global state should NEVER be undefined.  Setting an initial policy
for radios is a damn good idea.  And if it is to be hardcoded, we
hardcode it to "radios OFF" which is always safe (but I'd just make it a
module parameter).

>    - if global state == rfkill->state happy rfkill, nothing to do

For write-only switches, you ALWAYS have to set them initially.  If you
mean the driver needs to do it to whatever it has done to rfkill->state
BEFORE calling rfkill_register, I am fine with it, but we *NEED* to
document that and revise all drivers to make sure it is correct.

>    - if global state != rfkill->state change global state, toggle all radios
> 
> The state UNDEFINED/UNITIALIZED would in this case be a new state which should
> be the default state during initialization.

I don't mind adding a new UNDEFINED state, it would be very useful for
write-only switches which can be messed with by something other than the
kernel.

But I don't think it is a good idea at all to have "unknown" be allowed
into the GLOBAL state.

If we have an *initial* global state of "unknown", it will confuse
users, as that will make the effective initial state of an entire radio
type change during coldplug depending on the initial state of the first
device of that type registered, which is NOT deterministic at all.

Please let's go with either an OFF *initial* global state (safe), or a
user-seletable *initial* global state (module parameter, and I'd say the
best default would be OFF here too, but AFAIK, it is ON right now).

And there is absolutely no reason at all (as far as I can see, anyway)
to let anything set the global state to "unknown".   If some radio
switch can't follow the global state (e.g. it is read-only), it simply
won't.  If someone overrides the state of the switch (write to state
attribute) to be different from the global state, it will be brought
back in sync the next time the global state changes.

I just thought of a way to let userspace mess with the global states
when it wants to control an entire set of switches (and not just one).
I will send in a patch if you like the idea:  basically, the rfkill
class module also registers a platform driver, and platform devices for
every type of switch.  THOSE devices are used to control the global
state for each type of switch.   This makes rfkill-input functionality
implementable in userspace, which is good.

> > > What perhaps could be done, is that during registration it either reads
> > > the status directly from rfkill to what the device initialized it to,
> > 
> > I am *all* for a proper init of rfkill->state to match the real hardware
> > state.  I have always been, and I complained about that when rfkill
> > initially landed in mainline.
> > 
> > But I do agree that the current "desired behaviour" of rfkill (i.e. what
> > it should be doing, barring any bugs): that it will immediately set
> > newly registered radios to the state their type switch is at, to be a
> > good idea.
> > 
> > In fact, for write-only radios, you *have* to enforce their initial
> > state, because it is effectively unknown.  And in order to do that, you
> > must avoid any code paths that would do stuff like "if (rfk->state !=
> > desired_state) toggle_radio(desired_state)".
> 
> Ok, for those devices we should set the default state to OFF _unless_
> other devices of the same type are already present in which case the
> default state should be set to the current global state for that type.

Or, if we forbit an undefined global state to begin with (see above), we
just set it to the global state (which will be ON or OFF), have less
complex code, AND reduce user confusion...

> > > or call get_status() during registration to determine the new state itself.
> > > That way we prevent series of module parameters and initialize to the state
> > > the driver has indicated..
> > 
> > As an user, I do NOT want to have to deal with per-radio-module
> > parameters in order to set their initial state to ON or OFF.  Yes, it is
> > what we have right now for some radio devices, and it is extremely
> > unoptimal.
> 
> Agreed, but having all those module parameters gathered into a single
> module isn't a sound option either.

Sure it is, if that module is the class that controls all the radio
switches (which rfkill is).   Unless we now make each rfkill radio type
a module of its own, which is quite doable, but IMHO a lot of code
complexity and memory waste for very little gain.

> > Keeping track of the radio state (including which initial state it
> > should be set to) is exactly what something like the rfkill layer is
> > supposed to be good at: set parameters for an entire class of hardware
> > in a generic way, in a single place, and in one go.
> 
> agreed.
> 
> > > > Add a module parameter that causes all radios to be disabled when their
> > > > rfkill interface is registered.  Add override parameters for each rfkill
> > > > switch type as well, just in case the user wants the defaults to be
> > > > different for a given radio type.
> > > 
> > > I am not a big fan of large series of module parameters, so in that aspect
> > > I am not a fan of this patch.
> > 
> > If you think per-radio-type is too much, we just drop that part of the
> > patch.  It will make it quite smaller, and it will preserve the
> > functionality that is really needed (let the user tell the kernel to not
> > try to power up radios by default).
> 
> That and my suggestion above about state checking during rfkill registration
> would indeed improve things.

How about we have a *single* initial global state parameter, but
disallow an "unknown" global state parameter?  Less user confusion, less
module parameters, AND less code complexity.

> > I made it type-aware because I can see an user wanting the long-range
> > radios off by default, and his personal-device-space radios (UWB,
> > Bluetooth) on by default.
> > 
> > > > We don't change the module default, but I'd really recommed doing so in a
> > > > future patch.
> > 
> > In fact, I better ask it now: do you want me to respin the patch with
> > just one global switch, and make its default to be "radios offline" ?
> 
> If the above is too much to have it included in time for 2.6.26, I would
> say the default to offline. But that is personal preference and I won't NACK
> either solution. So I let you choose this one. :)

Ok, I will put my brains and fingers into high gear and come up with a
new patchset, but first I have to look at input-pooldev to see if/how I
can use that for thinkpad-acpi, in order to re-think the read-write
support.

BTW: isn't it high time to add yourself as the RFKILL maintainer to
MAINTAINERS (couldn't find you in there, nor RFKILL for that matter) and
also to document the rfkill class in Documentation/ ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
