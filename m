Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbYDNVlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbYDNVlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYDNVle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:41:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45896 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbYDNVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:41:32 -0400
X-Sasl-enc: YvcTM4FeT+06nv8ED7lmk2cEZ6no89+7H6wiM/+6qGhy 1208209290
Date: Mon, 14 Apr 2008 18:41:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414214128.GA9815@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.43547.IvDoorn@gmail.com> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com> <20080414100018.ZZRA012@mailhub.coreip.homeip.net> <20080414143603.GA31298@khazad-dum.debian.net> <20080414105933.ZZRA012@mailhub.coreip.homeip.net> <20080414163357.GA8438@khazad-dum.debian.net> <20080414133917.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414133917.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> On Mon, Apr 14, 2008 at 01:33:57PM -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> > > On Mon, Apr 14, 2008 at 11:36:03AM -0300, Henrique de Moraes Holschuh wrote:
> > > > On Mon, 14 Apr 2008, Dmitry Torokhov wrote:
> > > > > What exactly breaks with user_claim? I think the general issue is that
> > > > 
> > > > The same thing that happens if userspace is in charge and doesn't
> > > > cooperate or if rfkill-input is not loaded:  the rfkill driver state is
> > > > never updated (remember, it is about the radio controller, not the input
> > > > device).
> > > > 
> > > 
> > > And it should not - setting user_claim means userspace controls the
> > > transmitter state. If userspace decides to ignore KEY_* event and not
> > 
> > Nuh-uh.  Here's the root of the bug.  The rfkill controller knowing
> > whether its state is on or off for real has NOTHING to do with the user
> > telling it to change state.
> 
> Nuh-uh. Nothing changed the transmitter sate yet. We just got a
> request from user to do something.

We are talking about different things. Please re-read the last three or
four messages before this one, thread-wise.


> switch until user[space] tells you to do so. I guess firmware could
> work like a hard-wired switch, turnign radio off when battery goes
> extremely low, so yes, I agree that allowing drivers to update their
> state directly is required.

Ok, then we DO agree.  Let's drop this point and go to the next one...

> I agree. Here you are talking about hardwired-like scenarios where
> kernel did not get a chance to interfere with the RF toggle. Still, if

Actually, I am talking about ANY scenario where the kernel did not get a
chance to interfere with the RF toggle.

> there was a button involved it needs to be broadcasted so that the
> rest of RF transmitters can be adjusted according to the used
> policy.

We must only broadcast master events, these switches are often tied to
each other in a tree, you can't report events on the leaves, just the
root.  In a ThinkPad T60, you get an rfkill input device (that can be
read), which is hardwired into the WLAN card's rfkill input pin (that
can ALSO be read, and could potentially be registered as a rfkill
controller).  The WLAN card has also a second rfkill controller, which
is in a config register.

I kept that in mind, that's why I started talking about master and slave
rfkill switches.  Only the master ones can also be used as rfkill input
devices.

So yes, if there is a button involved, it must issue one (and only one)
input event.  We agree on this.

> > So far so good, but it must not be used for something else entirely
> > (namely: keeping rfkill->state consistent to the real hardware state).
> > That's what I am talking about...
> 
> Here I agree.

As far as I can see, we actually agree in most issues related to rfkill,
maybe even in everything... but our terminology is NOT in sync, so it is
not immediately obvious that we do.

> > > If there are drivers sense button presses and alter their actual
> > > transmitter state immediately but then rely on rfkill-input to update
> > > their sysfs rfkill attributes then such drivers should be fixed.
> > 
> > That's the point, yes.  Currently *all* drivers have to do this :) and
> > that's why I did not add thinkpad-acpi rfkill support until I had enough
> > time to tack on rfkill itself to bring it up to speed with the extra
> > requirements stuff like thinkpad-acpi and b43 have.
> 
> No, I dont believe all drivers have to do this. Ivo will correct me if
> Im wrong but I believe he worked with drivers that dont necessarily
> have the switch hard wired.

WHEN the kernel is the ONLY possible source of a radio controller state
change, it is not needed.  For all other cases, we are either ignoring
the status changes (i.e. the kernel's idea of the current controller
state can be wrong), or using the input layer to resync (b43 tries to do
this).

> Should I add attribute for every key on a keyboard just because some
> userspace developers what to use shell scripts everywhere? key_a,
> key_b, key_c and so on? No.

It is a rare application that needs to know if a key is currently
pressed or not.  And usually, it is assumed by the user that he should
not expect an application to know a key was depressed before it started,
nor are such applications usually written using shell script :-)

For switches, that's not rare at all.

> >  There is a big
> > pontential for confusion and misuse of interfaces there, when you recall
> > that it will be COMMON to have the same module (driver) provide both a
> > rfkill controller through the rfkill class, and an input device.
> 
> As soon as people will realize that button and RF transmitter are
> different objects serving different purposes it all goes away. The
> very same module also registers network device, why rfkill is so
> different.

It is not so different.  But you could make the handling of that
information more generic if you could get it using just the rfkill
interface.

> > > > We could fix it in the input subsystem, instead.  How difficult (and
> > > > welcome a change?) would it be for the input device infrastructure to
> > > > provide pollable (for good measure!) "state" attributes for every EV_SW
> > > > event an input device registers in evbits+swbits ?
> > > > 
> > > 
> > > Given the above I don't see the need.
> > 
> > So, we can get the required information using an IOCTL.  That means
> > rfkill class support for read-only devices is no longar mandatory.  It
> > is still not clear to me it is not *desired*, though.
> > 
> > The reasons are:
> >   1. Need to have an easy way to get that information for shell scripts,
> >      and IOCTLs are not (AFAIK).  This can be fixed by adding a shell-
> >      script helper to input-utils.
> > 
> >   2. It might be better to have all information directly related to
> >      rfkill behaviour (i.e. both rfkill controller state and rfkill
> >      input device state) in the same class, and present it in the same
> >      way to userspace.
> 
> No, we need to keep RF transmitetrs and buttons separate. I can assign
> KEY_WLAN to one of the media keys on my laptop (that I dont use
> otherwise). Does it make sense to "move" my keyboard to rfkill
> vicinity? I dont think so. Its just a button.

And it doesn't have much of an existence outside of when it generates an
input event.  You don't ask a button where it is ON or OFF, that's a
switch property.

But that's not true for a real switch. You can ask it whether it is in
the ON or OFF state (for two-state switches, they can have a lot more
than just two states, but that's not relevant for rfkill).

I can see why we'd not want to export that through rfkill now that you
brought external keyboards into the picture.  If I have an external
keyboard with a radio kill SWITCH (not key), I want it to work just like
if it were built-in the platform.

Which means it needs to be done in the input layer. Well, that gives me
my answer, in a rather definitive way too.

> > And there is the all important question about whether I should still
> > export that information in thinkpad-acpi over pollable attributes (which
> > are *really* easy to use) or not.  Other driver writers might want to
> > think about it as well.
> 
> If we export switches then we need to export leds. And keys. And
> axis... It all adds up very quickly and wastes kernel memory. Just
> write ioctl utility for script-users if such is needed and be done
> with it.

Actually, no, we don't.

AFAIK, input layer LEDs should go away, they belong in the LED class.

Keys have usage patterns that make it not necessary to export the
information of whether they are currently pressed or not through sysfs.
Utilities to query keyboard state are around for a long time as well.

Stuff that needs an axis position usually needs to track the axis (i.e.
they need a stream of data), so we are doing everyone a big favour if we
never ever let big bad stupid mistakes like that hdaps "position"
attribute's existence happen again.

As for writing the ioctl utility, it looks that it will be needed
without the sysfs attributes.  But who will write it?   Who will give it
a home?  Maybe util-linux would take it in, if we're very lucky...

> > Well, I do propose that we export any, and *every* radio controller
> > state change through kernel notifier chains (and to userspace using
> > uevents).  Those notifications should include the rfkill type (and type
> > class if we add that), new switch state, and any other relevant
> > information (e.g. that the switch is a master switch -- those usually
> > need input events generated, whether the code that produced the
> > notification will also handle issuing an input event for it or not
> > (duplicate suppresion), etc).
> 
> Notfiers are a good idea for RF transmitter state changes. Not so for
> key/button notifiers because these can be ussued by regular PS/2 or
> USB keyboards and other devices that have no idea about rfkill and
> dont want to know.

Agreed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
