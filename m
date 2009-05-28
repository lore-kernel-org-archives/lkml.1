Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZE1KCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZE1KCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZE1KCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:02:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:58689 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZE1KCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:02:37 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090528091513.GA14789@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk>
	 <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <1243496236.3171.140.camel@pasglop>
	 <20090528091513.GA14789@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 28 May 2009 20:00:12 +1000
Message-Id: <1243504812.5573.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still uncertain whether that's actually a true statement.  For some
> cases, of course it's true, but I have a nasty suspicion that we have
> corner cases where OF won't cope well with.
> 
> As I see it, if we were to convert to OF, we're boxing ourselves in to
> a corner that would be extremely difficult to get out of.  We would
> never be able to step back from OF.  Lets take an example.  If we were
> to convert PXA to OF including all the PXA SoC drivers, and a board
> configuration came along which required hacks to a driver.  Later on
> we find that most platform authors are applying similar hacks because
> their hardware is subtly different but those differences can't be
> expressed via OF.  At this point, what do we do?  We can't say "well,
> OF doesn't work well on this platform, we want to get rid of it" that
> would be extremely difficult to impossible to do.

I understand your concern. However, I yet have to encounter a case where
the device-tree mechanism doesn't allow to convey the necessary
informations. From my experience, it's always been superior in that area
to any other mechanism we came up with.

However, it's hard to give a final judgment without actual examples. But
I see you are providing one below, let's see...

> For example, how would an IrDA transceiver be expressed in OF?
> 
> Obviously it would have to start off with some sort of UART definition
> for SIR, with a separate (and sometimes unrelated in terms of register
> space and SoC pin configuration) FIR unit.  Whether FIR is used or not
> is platform specific.  So far so good, I don't see a problem yet.

Right. Well, there are various ways to approach this. One is to have the
transceiver be a child of the UART but that doesn't necessarily work
well in term of addressing and conveying the necessary register
informations.

However, it would be reasonably simple and not unheard of to instead for
example stick a property in the UART node, for example "fir-transceiver"
that contains a phandle (a phandle is a pointer to another node) that
points to the node that represents the transceiver and has the necessary
register mapping informations.

We have that kind of cross-node relationships expressed in various ways
for things like network interfaces where the PHY controller sits on a
different part of the SoC for example. It works reasonably well.

> We then have one or two GPIOs doing some function - eg, one GPIO might
> be a simple power on/off while the other controls FIR or SIR mode in
> the transceiver itself.  Or the two lines might be a bit combination
> which selects 'off', 'on + sir', 'on + fir' modes depending on the
> transceiver used.  In the case of one GPIO it might be the mode select
> or it might be the power control.

One approach is to have the FIR node contain a property called
"power-gpio" pointing to the GPIO node for the power GPIO etc...

It's only one way.

If the stuff gets too tricky due to multi-usage or multiplexing of the
said GPIO, you could have instead a node for a "pseudo device" that
would be fir-power-control or whatever else that contains some
information and that the platform uses to provide a callback to the FIR
drivers.

The device-tree doesn't corner yet there. A given device binding might
define the basics for devices of that type, but I yet have to see a case
where you cannot express dependencies reasonably well in the
device-tree.

One thing to keep in mind is that the "tree" doesn't mean that there is
one strict hierarchy of devices. The "main" hierarchy of the device-tree
is generally chosen based on addressing capabilities to convey register
address translations.

But you can cross that via node pointers easily and provide alternate
hierarchies within the tree. It's commonly use for interrupt routing for
example where devices can have an "interrupt-parent" property that
points to the PIC they are attached to (or to a node that convert
interrupt domains when that makes more sense, called an interrupt map,
this is commonly used for PCI). By default, if you don't provide such an
explicit parent, the tree parent is considered as the interrupt parent
(and may itself contain an interrupt-parent property that points to the
PIC for all its children).

The possibilities are almost endless. When you hit a real corner case,
you can always create some kind of pseudo device that is backed by
actual C code to resolve the situation in the kernel, or some kind of
'power-method' property that you can use to lookup a table of platform
provided methods. That's just ideas... 

One thing I agree with is that it takes some time to get familiar with
the various ways the device tree can be used and thus use it
efficiently. As I said earlier, it's a tool, it's very powerful but can
be misused like any tool. I believe a good approach for ARM isn't to
convert altogether to a device-tree based approach that requires all
platforms to use it, but to start providing the infrastructure for
platforms to "opt-in" and see how it goes from there.

And you always still have the choice of hard wiring something in the
platform code if you really want to :-)

> I suspect this can be expressed by having some sort of OF table specifying
> several gpios & their value for each combination of power & mode...
> except some platforms have special control registers in FPGAs which do
> not appear as GPIOs... so how are those expressed?  We have function
> pointers back into platform code to cope with this at present.

You can still do something like that. I don't think the tree limits
your ability to do that sort of thing.

> Another example - LCD displays.  Some platforms need a certain sequence
> of GPIO activations with delays between when powering up and down the
> LCD display.  Currently we express this in the platform support file and
> pass a function pointer into the LCD Driver.  Can this be expressed with
> OF?

The tree itself wouldn't contain a function pointer no. There are
several approaches here. If what you are trying to express can
reasonably well be done via some kind of table of values & delays, you
can define a property format that contains that to stick into the LCD
node.

A more flexible approach may be to have a "power-method" property as I
proposed above. You can then create some kind of mechanism to export
various such methods based on their name that the platforms can provide
or that can be in separate files and have the driver lookup the right
one using the property in the LCD node.

Apple tried to do some ACPI-ish kind of "scripts" in the device-tree
where they actually stick tokenized kinds of sequences of things which
themselves are method calls to other drivers and pseudo-instructions all
in one property.

This is a possibility, and we do have an interpreter for that stuff in
the kernel, but I find it gross and over-engineered myself at least the
way it was done. But if we feel it's worth doing something like that
cleanly, then why not ?

> Another example - backlights.  Some platforms need to twiddle a GPIO
> at a certain point in the brightness scale and reset the PWM, and they
> currently do this via an (optional) function pointer in the generic PWM
> backlight driver.  Can this be expressed with OF?

Similar to the above, there are ways to express things, but to a certain
extent, when things gets too tricky, C code might be the best approach,
however nothing prevents you from having a mechanism to name those
methods and register the callbacks and use that. Or keep your old way.

I think at this stage, it's really a matter of trying it out on a few
platforms and see how it goes.

I don't pretend it's going to magically solve everything or make
everything nicer. But it has the potential of solving many things and
making many things nicer.

> That's just a few examples of areas where we haven't been able to describe
> platforms using pure data-based descriptions, and they're all things that
> we don't want to stuff into the individual drivers (doing so involves lots
> of ifdefs and namespace pollution - we saw that in 2.4 kernels.)

Yup, I understand this problem well, it's what Apple tried to solve in
the example above, and what ACPI tries to solve with AML, and while we
-could- try to define some kind of scripted mechanism, I'm not sure its
worth the challenge and we may as well go back to actual C code for
those special cases. But I don't think having a device-tree makes that
problem any worse than it is, ie, existing solutions would still work.
It has even the potential of making it a bit cleaner to separate the
magic handlers and access them by names.

Now, if we want to go crazy, we can look into the full OF rather than
just the device-tree, ie, bring in the tokenized F-code interpreter in,
and express things as F-code methods :-) but that might be overkill, at
least I believe it is for most our embedded cases on powerpc.

> In order for me to be convinced that OF is not going to cause us grief,
> I'd like to see a range of platforms converted to OF to check that we're
> not going to find any unexpected problems - eg, a load of PXA platforms,
> particularly those with the above kinds of problems.

I think we need to distinguish using the OF-style device-tree, which is
I think what this thread initially is about, from using a full blown OF
as a firmware, and potentially trying to either keep it alive along with
the kernel to be able to call into it (which is possible but hard) or
bring in an f-code interpreter into the kernel.

The former is mostly what I advocate for now for embedded. The later is
something interesting to explore I suppose but not on my personal agenda
right now.

> And no, Dave Miller saying "I've been using this for 15 years on Sparc"
> "Three architectures are using it" isn't going to convince me.  The proof
> is in the code, not the waffle.

Well, sparc has the advantage of having a full OF implementation from
day one with people who have been smart enough to provide reasonably
good representations of things in their device-trees. Also, sparc
doesn't have to deal with some of the intricacies of the embedded world
(same deal with ppc64) so I tend to agree here that the situation isn't
that clear cut.

However, it's probably worth giving it a go.

Cheers,
Ben.


