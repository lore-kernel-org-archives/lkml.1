Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYDLTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYDLTOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYDLTOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:14:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:27272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYDLTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=KgM+39faXisXzKPlkP00DPoJ6XD5cxYE3YKp5Fv5qygtKeaLxw04u8CuxlfIbLVDgoeMVM5o9/o/rrQ5BurNehkLzJIp2yXnz8C8IxpV1eVK3SBkmfAG3nLce3bACkrWS0g6W8L1hHY6+onkU9Rn9Vw/jrlqKbPPtXZOHUGPcMU=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Date: Sat, 12 Apr 2008 21:15:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121824.45302.IvDoorn@gmail.com> <20080412183607.GJ3402@khazad-dum.debian.net>
In-Reply-To: <20080412183607.GJ3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122115.46128.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > > So when there already is a switch of that type present, then the value
> > > > will be set to the state of the first registered switch (either ON or OFF).
> > > > When no similar switch is present then it will be set to ON.
> > > 
> > > Where in the code do we change the *global* state for a switch type,
> > > based on the state of a particular switch of that type?  That's the step
> > > I am missing.
> > 
> > rfkill_switch_all() does exactly that and then calls rfkill_toggle_radio()
> > for all registered rfkill structures of the changed type.
> > 
> > rfkill_switch_all() is called from rfkill-input
> 
> So, we don't mess with the global state when we register the first
> device for a type at all, which is how I thought the code worked indeed.
> 
> I don't understand what you mean with "So when there already is a switch
> of that type present, then the value will be set to the state of the
> first registered switch", then.

Consider the following events:

1) rfkill initializes all types to RFKILL_STATE_ON
2) driver X registers rfkill structure
3) input-polldev polls X switches state to RFKILL_STATE_OFF
4) driver Y registers rfkill structure

at that time, what should the status for driver Y be? Should it be changed
to reflect the global state (RFKILL_STATE_OFF) or the state of the driver
(RFKILL_STATE_ON)

The current approach will set Y to RFKILL_STATE_ON, see rfkill_add_switch()

> > > Here's the timeline of how I think (so far, anyway) these whole thing
> > > should work:
> > > 
> > > 1. rfkill class registers with kernel
> > >    - all initial global switch states (there are NO switches registered
> > >      yet) are set to ON (current rfkill) or to either ON or OFF based on
> > >      rfkill module parameters (with the patch).
> > > 
> > >      These are the "desired radio states for each radio type", and
> > >      are not related to whatever *real* state the hardware is in.  Let's
> > >      call them "global switch state (per switch type)", or "global
> > >      switch states" for short.
> > > 
> > >      These global switch states are usually manipulated by rfkill-input
> > >      when it traps input events that affect a certain type of switch
> > >      (and we should probably have a way to manipulate these global
> > >      states from userspace as well when rfkill-input is not loaded).
> > 
> > that is provided through sysfs, or some userspace tool that listens
> > to the input devices which have been registered.
> 
> Err, where in sysfs can I set the global state of all bluetooth
> switches, for example?  I *can* loop all over the switches, find the
> ones with a type of bluetooth, and change them.  But that's NOT the same
> thing.

Ok, I didn't mean the global state for sysfs.
But that is where your previous suggestion comes in to create devices
for each type. This could be done at the moment the first rfkill structure of
that type is added.

> Right now one needs rfkill-input loaded, and one has to send an
> KEY_BLUETOOTH event from userspace.  In the dark, I should say, because
> one can't ask the kernel what the global state is, and any rfkill switch
> could have its state different from the global state if someone
> interacted with it directly over sysfs.

Well all devices of the same type should be in the same state. That is because
during rfkill registration the status of the registrant will be changed to the
current global state.
This does open a hole when the status is changed through sysfs.

> I will address this in a patch, I think.  It will add a much cleaner way
> for userspace to interact with the global states, and it will let the
> used chose rfkill-input as an optional lightweight policy for the rfkill
> switches and input events, OR to implement a heavy-weight one in
> userspace.

That difference has always been the setup for rfkill.
rfkill-input should be used when there is no userspace agent running
that will handle the events. That is why drivers shouldn't depend on rfkill-input
and only work with rfkill.

> > >        2.3.1 rfkill class tries to set the radio state
> > >              (using toggle_radio() and updating rfkill->state if that
> > > 	     succeeds) to the CURRENT global switch state.
> > > 
> > > If we have something different than this, it is a bug.  And I am not
> > > clear what we should do in 2.3.1 WHEN the switch is a read-only switch,
> > > but my guess is that we just ignore the failure, as trying to match all
> > > other switches would break badly if there are more than one read-only
> > > switches of the same type, and their states don't match.
> > 
> > True but what a user doesn't want is this:
> > 
> >  - wireless key set to "ON"
> >  - boot kernel
> >  - press wireless key twice to actually enable the radio
> > 
> > I have a laptop containing 2 read-only keys, one for 802.11 and one for bluetooth,
> > the global state should be whatever those 2 keys say, otherwise the
> > status of the various keys can become completely messed up.
> > 
> > I think the chance of having 1 read-only key and multiple read-write/write-only
> > keys is bigger then having multiple read-only keys.
> 
> Ok.  So we assume the read-only ones are more important, and for the
> *first* read-only rfkill switch registered for a type, we change the
> global state for that type to match the switch state.
> 
> For read-only switches of type "any", we do that for all types that have
> NO read-only switches registered, I suppose.
> 
> Let's call that behaviour a "master" rfkill switch.  Its initial state
> is forced on the global state when it is registered, and when it toggles
> state, the global state is ALSO toggled.

right. I think this would be the correct implementation for all systems
as I seriously doubt any device to have 2 read-only keys for exactly the same
radio type.

> > > > That I the issue that should be addressed with this patch:
> > > > 
> > > > - rfkill loads, sets initial state to UNDEFINED/UNITIALIZED
> > > 
> > > Which we don't have :(
> > > 
> > > > - driver with key X loads
> > > 
> > > We better make sure not to confuse the layers here.
> > > 
> > > We have a layer that deals with the switches themselves (rfkill), which
> > > has NOTHING to do with keys at all.  It lets one access the current
> > > switch state, and modify it.  It should also define the policy for what
> > > the initial state of the switch should be, IMO.
> > > 
> > > Drivers like b43 and thinkpad-acpi are connected to the rfkill layer.
> > > 
> > > We have a layer that should be OPTIONAL, and that listen to input events
> > > and manipulates the rfkill switches in semanthic groups ("switches for
> > > the same type of hardware").  This is rfkill-input.
> > 
> > right, rfkill-input is optional although I already noticed that at least b43 
> > makes that module mandatory for some reason.
> 
> We better ask the b43 maintainer about it, then.

Yes, when the behavior discussed in this thread is implemented to
have rfkill and rfkill-input do the right actions then I'll browse the kernel
tree to look for rfkill implementations and check if the correct approach is taken.

> > > >    - if global state == rfkill->state happy rfkill, nothing to do
> > > 
> > > For write-only switches, you ALWAYS have to set them initially.  If you
> > > mean the driver needs to do it to whatever it has done to rfkill->state
> > > BEFORE calling rfkill_register, I am fine with it, but we *NEED* to
> > > document that and revise all drivers to make sure it is correct.
> > 
> > No letting rfkill handle that would be safer, the driver should be in charge
> > of determining if toggle_radio() should really do something (in case the interface
> > hasn't been brought up yet).
> 
> So, it is better to make the initial state something drivers have to
> provide in the rfkill_register call, IMHO.  Otherwise, people will
> forget to initialize that field, and we can't find that out unless we
> manually inspect every code that calls rfkill_register.

Agreed.

> > > >    - if global state != rfkill->state change global state, toggle all radios
> > > > 
> > > > The state UNDEFINED/UNITIALIZED would in this case be a new state which should
> > > > be the default state during initialization.
> > > 
> > > I don't mind adding a new UNDEFINED state, it would be very useful for
> > > write-only switches which can be messed with by something other than the
> > > kernel.
> > 
> > Well if we are going to demand the initial state as argument it might not even
> > be needed. But then the driver should tell rfkill in some way that it is write-only.
> 
> Can we just have a bitfield flags field for rfkill devices, and use it
> to host such information?  Could be useful to define a read/write switch
> as a "master" switch (i.e. one that behaves like the read-only switches
> shall in the next round of these patches, and toggle the global state)
> for example.

Sounds good to me.

> I really have some good uses for such a field, and it has to do with the
> global states.  You'll see it in the new patchset, when I finish it.

Excellent. Thanks.

> > > also to document the rfkill class in Documentation/ ?
> > 
> > You mean like Documentation/rfkill.txt
> 
> Drat, I wonder why I didn't find it when I searched for it in latest
> mainline.  I will read it now, and update it in any patches I write.

Ok.
When you have the new patches that change the behavior I'll
write an update for the documentation. To make sure driver authors
will have at least a correct reference.

Ivo
