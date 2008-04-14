Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbYDNQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbYDNQeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYDNQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:34:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45657 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111AbYDNQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:34:01 -0400
X-Sasl-enc: BeIdjknKjq9lIm+9Jk9yvBM9SKgHY/5cyHB+a/EWxpkk 1208190840
Date: Mon, 14 Apr 2008 13:33:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414163357.GA8438@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com> <20080414100018.ZZRA012@mailhub.coreip.homeip.net> <20080414143603.GA31298@khazad-dum.debian.net> <20080414105933.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414105933.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> On Mon, Apr 14, 2008 at 11:36:03AM -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> > > What exactly breaks with user_claim? I think the general issue is that
> > 
> > The same thing that happens if userspace is in charge and doesn't
> > cooperate or if rfkill-input is not loaded:  the rfkill driver state is
> > never updated (remember, it is about the radio controller, not the input
> > device).
> > 
> 
> And it should not - setting user_claim means userspace controls the
> transmitter state. If userspace decides to ignore KEY_* event and not

Nuh-uh.  Here's the root of the bug.  The rfkill controller knowing
whether its state is on or off for real has NOTHING to do with the user
telling it to change state.

Something changed the controller's state (the hardware, or the
firmware), and didn't do it using the rfkill class.  That's a fact.  The
rfkill class needs to know of that change through an rfkill->state
update, or it misbehaves (because some stuff takes decisions depending
on the contents of rfkill->state, AND that state is exposed to userspace
which is allowed to also take decisions based on it).  That's another
fact.

And none of it has to do with input events, or what the user wants done.
During this entire process, the kernel did not take ANY active instances
on what should happen to the radio controller.  It didn't change the
radio controller state.  It is just making sure the kernel doesn't think
it is ON when it is OFF, for a particular, specific, radio rfkill
controller.

I propose that we broadcast (through normal kernel notifier chains) that
the state has been changed, and if something is trying to enforce that
no radio rfkill controllers deviate from the global rfkill state for
that radio rfkill controller state, IT should tell the radios to go back
to the state it wants.  But IT is not the rfkill class, nor any input
devices or rfkill devices.  Maybe it is userspace, or rfkill-input, or
another platform-specific policy module.

> turn the radio on or off - that is fine. rfkill-input simply provides
> default kernel policy for reacting to KEY_WLAN, KEY_BLUETOOTH, etc.

So far so good, but it must not be used for something else entirely
(namely: keeping rfkill->state consistent to the real hardware state).
That's what I am talking about...

> If there are drivers sense button presses and alter their actual
> transmitter state immediately but then rely on rfkill-input to update
> their sysfs rfkill attributes then such drivers should be fixed.

That's the point, yes.  Currently *all* drivers have to do this :) and
that's why I did not add thinkpad-acpi rfkill support until I had enough
time to tack on rfkill itself to bring it up to speed with the extra
requirements stuff like thinkpad-acpi and b43 have.

> > > rfkill was originally not supposed to be used with switches that can't
> > > be programmatically controlled. If we have a switch that mechanically
> > 
> > The input layer does not provide a way for userspace to get access to
> > the current state of any switches easily (or at all?).  It just exports
> > events reporting these states sometimes.
> 
> You can use EVIOCGSW to get state of switches. I'd expect applications
> to use it when they open devices first time and then rely on event
> delivery to monitor changes in state of input devices.

Good to know.  But the usual consumers of those are shell scripts, do we
have a swiss-army-knife-for-the-input-layer utility a shell script can
use to do a EVIOCGSW call?  Or to wait for an event?

If we don't, but we provide one to be the companion of lsinput,
input-events and input-kbd, then I agree we can forego the sysfs
attribute.

But DO be warned that userspace developers will see that rfkill exports
a state attribute for the radio rfkill controllers, and will look for
something equally easy to use for the input devices.  There is a big
pontential for confusion and misuse of interfaces there, when you recall
that it will be COMMON to have the same module (driver) provide both a
rfkill controller through the rfkill class, and an input device.

> > We could fix it in the input subsystem, instead.  How difficult (and
> > welcome a change?) would it be for the input device infrastructure to
> > provide pollable (for good measure!) "state" attributes for every EV_SW
> > event an input device registers in evbits+swbits ?
> > 
> 
> Given the above I don't see the need.

So, we can get the required information using an IOCTL.  That means
rfkill class support for read-only devices is no longar mandatory.  It
is still not clear to me it is not *desired*, though.

The reasons are:
  1. Need to have an easy way to get that information for shell scripts,
     and IOCTLs are not (AFAIK).  This can be fixed by adding a shell-
     script helper to input-utils.

  2. It might be better to have all information directly related to
     rfkill behaviour (i.e. both rfkill controller state and rfkill
     input device state) in the same class, and present it in the same
     way to userspace.

Anyone has an opinion about the above?  Provided we can do it without
major complexity (we can, AFAIK, since I did get quite close to it with
the first patchset and the code in there is definately NOT complex), I
think both points could be addressed at the same time, and userspace
can get the information it wants in whichever way it is easier for the
application.

> > If the input subsystem exports that information, we can define that
> > slave read-only radio controllers must NOT be registered as rfkill
> > devices, and drop support for read-only rfkill devices, as all master
> > rfkill devices (which are input devices by definition) would get their
> > state exported to userspace through the input layer.
> > 
> > However, that DOES mean userspace would need to look for rfkill state in
> > two places.  Input layer, to get the current state of the rfkill input
> > devices, and rfkill class to get the current state of the rfkill
> > radio controllers.
> >
> 
> I think you outlined the problem in your other mail quite well. We
> keep confusing button state with the transmitter state. Only for
> buttons that are hardwired to transmitters the states are the same,
> for programmatically controlled RF transmitters state may be
> different. So if you need to see state of transmitters you should look
> in /sys/class/rfkill and for input devices - hook into input devices.

I am not so sure about that last sentence.  See above.  And I really
need to have a very clear and fixed picture of which way to go about
this before I start respinning the rfkill patches :)

> > Let's decide this NOW, then.  But if we decide to not do it in rfkill,
> > you will have to add attributes to every input device which has
> > registered itself as a source of EV_SW events.
> 
> No, since they may not be tied directly to any RF transmitter.

It is valuable information for userspace.  I export the same information
available through SW_TABLET_MODE for example, as a thinkpad-acpi
specific attribute.  Doing EVIOCGSW is not a very friendly interface for
userspace shell scripts right now.

So it *would* be useful.  Whether it is the right way to go about it
(instead of adding a new utility to input-utils to do the EVIOCGSW for
shell scripts and other script languages that are IOCTL-challenged) is
something else.

If you really don't want that exported over sysfs as well, and EVIOCGSW
is the only way to get that information, I feel the immediate need for
an input-ioctl utility for userspace shell scripting.

And there is the all important question about whether I should still
export that information in thinkpad-acpi over pollable attributes (which
are *really* easy to use) or not.  Other driver writers might want to
think about it as well.

> > I better make it clear that I have NO idea how to properly implement the
> > required changes in the input layer if we go that way so if it is left
> > for me to do that work, it won't be ready anytime soon and it might be
> > supbar, so I'd appreciate lots of help in that case.
> 
> Well, let's see.. Do we have any issues with transmitters that can be
> controlled programmatically? Or is it the hardwired ones that give us
> trouble at the moment? I think that exporting all of them in rfkill is

Both, I think.  Any rfkill controller which is not in complete,
exclusive control by the kernel, is currently a problem.  That means
stuff the firmware can change, and it also means any stuff directly tied
to a button or switch that the user can change.

The only things we are handling well right now is pure keys/buttons, and
rfkill radio controllers that are in full control by their kernel driver
(i.e. those with NO sideway control paths that are out of the control of
the rfkill device).

> a good idea, even though originally I thought we would not need to do
> that. Therefore we do need to allow hardwided drivers updating their
> rfkill state directly. The only problem I see is that we need to monitor
> this closely, so non-hardwired cases won't try to use this mechanism.

Well, I do propose that we export any, and *every* radio controller
state change through kernel notifier chains (and to userspace using
uevents).  Those notifications should include the rfkill type (and type
class if we add that), new switch state, and any other relevant
information (e.g. that the switch is a master switch -- those usually
need input events generated, whether the code that produced the
notification will also handle issuing an input event for it or not
(duplicate suppresion), etc).

We can monitor all rfkill radio controllers from userspace or
rfkill-input through those chains.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
