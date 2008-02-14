Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYBMWG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYBMWG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935102AbYBMWDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:03:30 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43132 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091AbYBMWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:03:25 -0500
Date: Thu, 14 Feb 2008 00:03:32 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: felipe.balbi@nokia.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg
	devices
Message-ID: <20080214050332.GY4769@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802121232.35280.david-b@pacbell.net> <20080213162905.GD4769@gandalf.research.nokia.com> <200802131336.00475.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802131336.00475.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 13 Feb 2008 22:02:58.0404 (UTC) FILETIME=[31713A40:01C86E8C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 01:36:00PM -0800, David Brownell wrote:
> On Wednesday 13 February 2008, Felipe Balbi wrote:
> > On Tue, Feb 12, 2008 at 12:32:34PM -0800, David Brownell wrote:
> > >
> > > Your proposal is to strike the "is_b_host" check.  In  terms of the
> > > OTG (1.3) state machine, that removes a b_host --> b_peripheral
> > > state transition.
> > 
> > Not at all, we're just not doing transition right now.
> 
> When *would* it happen then?  And why not do it as soon as it's
> known that the device on the other end of the cable is unsupported?

Whenever we finnish using the bus we'd suspend it. This would sinalize
a_peripheral switch back to a_host. Also, even though it's not on our
TPL it doesn't mean we can't work with it.

> 
> 
> > > BUT:  notice it doesn't replace it with the ONLY other valid state
> > > transition, b_host --> b_idle.   In fact, that can not be initiated
> > > by the B-device...
> > > 
> > > So the current code *is* correct.
> > > 
> > > 	... deletia ...
> > > 
> > > > We should at least try to enumerate a_peripheral, if it can't due to
> > > > our power capabilities i.e. 100mA, we'll fall into overcurrent
> > > > protection and we'll suspend the bus and disconnect, which would give
> > > > a_device another change to enumerate us.
> > > > 
> > > > This sound much better to me.
> > > 
> > > You're overlooking something:  this is the "!is_targeted(udev)"
> > > case, so we have already enumerated the a_peripheral as much as
> > > we can.  There is *nothing* more we can do with it.  Sitting
> > > around in the b_host state would be utterly pointless.
> > 
> > And you're overlooking something: tpl is not an enumeration blocker at
> > all. The only blockers are drivers and power limits.
> 
> The device has already been enumerated at this point.  This is just
> whether to set up communication with, and use, the device ... which
> activity *IS* predicated on device support, "on the TPL" (as it says
> in 6.8.1.4 of the spec for the A_HOST role, later reusing that language
> where it describes the B_HOST role).
> 

It only tell us to output a message to the user indicating it's not
supported. Same for b_host. It never says we should end the session at
that point.

OTG Rev 1.3 is unclear about this. That's why I consulted Richard Pietre
and asked him what would be the most sane way of handling hnp and he
told me to implement it always trying to work with the device even
though it's not tpl'ed.

> > Imagine what happens on n810, we have 3 mass storage devices listed on
> > its tpl: 770, n800 and itself. Besides that, we allow enumeration of any
> > mass storage device as long as it draws less than 100mA. 
> 
> While it makes sense to me that an OTG device support things like
> mass storage class devices, I still see that spec language saying
> that classes can't be on the TPL ... and that only devices on the
> TPL get communication beyond what's needed for enumeration.

It doesn't say your last point.

Besides, it says:
"The Targeted Peripheral List shall not list supported USB Classes or
similar devices."

By "similar" we can understand several mass storage devices. It doesn't
really matter on usb otg point of view whether we support mass storage
device A or mass storage device B, both should work if they meet otg
requirements (power consumption being the most significant issue).

We can also see the TPL example on otg rev 1.3 is not listing "similar"
devices. They are all different. Quoting from otg rev 1.3 Section 3.3:

	Vendor	       Model      Speed         Transport        VID	PID    Description
1.     Logitech       M-BJ58        LS           Int             0x046D 0xC00E USB Wheel Mouse
2.     Yamaha       YST-MS35D       FS         Isoch             0x0499 0x3002 USB Speakers
3. TEAC Corporation  FD-05PUB       FS          Bulk             0x0644 0x0000 USB Floppy Drive
4.  Hewlett Packard   D125XI        FS          Bulk             0x03F0 0x2311 All-In-One Printer/Scanner/Copier

This sounds like another clue that we should be able to "try" to work
with any mouse, any speekers, any floppy and any printer as long as they
meet power requirements because we have support for them built into the
otg device.

> Regardless, that's a red herring.  If you allow sane things like
> arbitrary flash memory sticks to be used, you've effectively put
> a device class on the TPL.  But this discussion is about things
> that are NOT on the TPL.

No cuz I'm still notifying my user the device is unsupported even though
it's not even a requirement, if the device meet otg
constraints*(explained below). Which means it might or might not work.
If it happen to work, that's fine, if it doesn't the user has been
notified about that possibility. One other thing "Device is Not
Supported" is just an example message.

* In section 3.4 OTG says:
(...) and the OTG device does not support the type of communitcation
being requested by the user, then the OTG device shall provide messages
to the user that allow him or her to understand the problem (...)"

Which means that we should notify our user if, and only if, we _really_
can't work with the device.

TPL is a list of well tested devices against the otg device under use,
it's not meant to be a list of the only workable devices we have.

> > These tips I 
> > got from otg chairman himself and from OTG Clarification document, you
> > can find it in compliance.usb.org.
> 
> Well, I'm glad at least one person there is talking sanely about
> the TPL, but there is no such clarification that I can find.

I'll ask him to send me a copy and I'll mail you, that's a not a problem
:-)

> I've observed USB-IF to be slow to address bugs in their specs,
> maybe that's what's going on here.  Bugs are often written into
> specs as political compromises, and they can linger for various
> reasons.  (Including members with hidden agendas to block success,
> and people who prefer to deny inconvenient realities.)

I agree with you here :-)

That's why I joined OTG working group and I'm trying hard to get in
touch with them about such bugs in the specs.

I can say to you next otg spec will be much clearer about tpl ;-)

> > So, what I'm trying to say is if 
> > a_device let us become host, we shold at least try to do, let's call it,
> > full enumeration. Which means attaching any unlisted mass storage device
> > should work.
> 
> Attaching works, sure.  If you are willing to communicate with
> that device, then it's on the Targeted Peripherals List (TPL),
> so this code branch doesn't apply.
> 
> Put it this way:  there is no *OTHER* mechanism for deciding not
> to talk with a device; and that's the entire purpose of the TPL.

Well there is. Kernel drivers (on the case of b_host) and kernel drivers
plus power constraints (on the case of a_host).

If we don't have kernel drivers, we, for sure, can't communicate with
that device. Or maybe if we have kernel drivers for mass storage but
we attach some kind of messed up storage device using iso endpoints,
which we don't have support on musb (hypothetical situation :-p), we
can't, again, communicate with that device.

> > > >  4. B-device become b_host, checks a_peripheral is not on its tpl, even
> > > >     though it has support for that device class
> > > 
> > > If it supports a device class I'd say that should be included
> > > in the TPL ("whitelist").  Though if it tries to do that, it's
> > > an explicit violation of the OTG spec (sect 3.3):
> > 
> > We can't support classes. What I'm trying to say is we have usb mass
> > storage support enabled in kernel and we can handle _any_ mass storage
> > devices as long as they meet otg requirements.
> 
> I think that detail of the OTG spec is stupid and misguided.
> 
> Of *course* it should be possible to support, for example,
> devices that weren't shipped before your product's TPL was
> defined.  How ever you define the list of Targeted/supported
> peripherals, that's got to be able to include classes and
> similar mechanisms.  That spec stupidity is one issue;
> for the scope of this discussion I'll assume the TPL (which
> has an algorithmic check) can pass things like flash sticks.

Gotcha

> 
> The other issue is what you call the part of your product
> documentation which says what devices it can talk to.  The
> only term for such stuff in the OTG spec is "Targeted
> Peripherals List".  If you're assuming some other design
> abstraction packages that notion, that doesn't match what
> the Linux-USB code does.

TPL is a list of well tested devices, like I said up there. We ship the
device with such a list, warning the user that any other device might or
might not work. This is how it should be according otg working group.

> If you wanted to *add* such an abstraction, you'd have to put
> it everywhere the current whitelist is used ... better IMO to
> just update the current whitelist/TPL code to handle classes.
> Right where the comment says to do it.

Did you see my patches proposing a tpl rework ?
I'm only missing the match class thing so I'm still notifying the user,
even though we allow communication with such devices.

> > > > According to otg tpl clarification, they should work in this scenario,
> > > > shouldn't they ? Or should they stay in an hnp loop until someone
> > > > decides to end the session ?
> > > 
> > > Shouldn't work, because your points 1 and 4 violate specs.
> > 
> > Not true, check again Chapter 6 Host Negotiation Protocol and OTG
> > Clarification regarding TPL.
> 
> There is no such "OTG Clarification" on the website I just
> looked at.

Mailing otg working group. I'll get it for everybody interested ;-)

> > > Though it would make sense to me to have the host record
> > > whether it already gave up on the peripheral once ... and
> > > if it did, then power it off.
> > 
> > Good catch. That'd be nice.
> 
> That's a patch I wouldn't NAK.  :)

heh, I'll try to make it work.
Good we're trying to address things here.

Thanks for all your time Dave :-)

-- 
	- Balbi
