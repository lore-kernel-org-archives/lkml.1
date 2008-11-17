Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYKQBvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYKQBvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKQBvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:51:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1110 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYKQBvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:51:32 -0500
Date: Mon, 17 Nov 2008 01:51:28 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20081117015127.GA10883@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811141715.14804.david-b@pacbell.net> <20081115043753.GA23711@sirena.org.uk> <200811161458.17212.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811161458.17212.david-b@pacbell.net>
X-Cookie: Must be over 18.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 02:58:16PM -0800, David Brownell wrote:
> On Friday 14 November 2008, Mark Brown wrote:

[Snipping much of this - I think we're in strong agreement except for
the main point left...]

> Describing fault conditions is IMO an entirely different issue from
> reporting the current regulator state.

Interesting...  I'd agree that detail can go into a separate function
I think status reporting should at least include an error indication
since error conditions often mean that the operational status isn't
clear (eg, poor regulation could potentially mean that the output has
collapsed and looks a lot like it's disabled).

>  - For ops.set_mode() it's clearly an input from Linux, applying only
>  when regulators are enabled.  One glitch there is that most of the
>  regulators I happen to have worked with have one mode configuration
>  register, with OFF (disabled) as an option...

My experience has been more that regulators either don't have any mode
configuration or clearly distinguish between mode configuration and
enabling.  Clearly we do need to cater for both, though.

>  - For ops.get_mode() I'm still not clear whether you agree that it's
>  reporting an output -- the actual mode -- or else reporting an input
>  -- some "requested" mode.  (OFF is again an issue.)

> You seem to be going back and forth about whether get_mode() is
> reporting a hardware output, or just a recorded input.  (Which may
> have been recorded in hardware, but is still just an input.) I'd like

An input.  I think most of the back and forth comes because it's been
written from that point of view while you were talking about it as an
output so we weren't understanding each other.

> to see agreement that it reports an OUTPUT ...

No.

> > Right, on the currently supported regulators the suspend mode
> > configuration is visible and configurable at runtime too - the
> > hardware provides separate registers

> I'd sure hope the framework isn't trying to be specific to, say, that
> Wolfson hardware...

It was actually added to meet the needs of people working on a part from
another (National, IIRC) manufacturer.  I can't say I've actually looked
in detail at what other parts do here.

> By the way:  how have you envisioned putting those mode+enable inputs
> into the right part of the PM sequence?

The idea is that suspend states only come into play while software has
stopped running...

> It'd seem to me that having the regulator clients handle this stuff
> would always be correct -- and is in any case necessary for runtime PM
> -- but if regulators get involved, goofing the sequence would be easy:
> regulator off, then driver relying on it has some work to do ... but
> it can't, since it's off.

...and that while software is running the client drivers have full
control (within the constraints that have been set).  It's expected that
these settings are activiated by hardware as the CPU stops running and
reset to the normal configuration when the CPU restarts.

> Are you arguing that there should be some new regulator_ops call to
> expose the actual regulator state?  If so, then what should happen to

Yes, exactly - possibly multiple calls.

> the get_mode() call?  As I've noted, if that's not reporting an
> output, it's a superfluous call.

I don't think so - if nothing else, it's useful for reading back the
status when it has not been configured by Linux (for example, when
constraints don't allow mode configuration so it's up to the bootloader
and hardware).  It also allows us to read back what's happened if
something else overwrites the configuration (but I'd expect that to be
rare).

> > One other part of this is that modes are something that should be the
> > concern of machine drivers and a few specialist consumers

> Though it does imply something about what a "standard client"
> might be.  Something that's barely power-aware will just stick
> to enable/disable.  Something that's trying to avoid cutting a
> day off the use cycle of a 1000 uAh battery might have lots of
> reason to care about regulator modes... those clients would be
> "standard" on certain kinds of hardware.  :)

Indeed, though there's quite a bit of fuzz in the mode definitions -
a more beefy regulator will have a different idea about what low power
is to one designed for very low power situations that can't scale up as
far and many regulators just don't have modes.

> That said, such power-sensitive drivers will set_mode(), or
> maybe set_optimimum_mode(), and not care about get_mode().

Yes, I'd expect they'd use get_mode() for at most bootstrapping only.

> > and it should 
> > be a warning flag if they appear elsewhere.  If a standard client has to
> > consider modes that indicates to me that something is going wrong but
> > determining if a supply has failed feels like something a normal client
> > could reasonably want to do.

> Given that's true, why are you pushing so hard against making
> the ops.get_mode() reflect the actual regulator state??  (That
> is, to reflect regulator output, not be a record of an input.)

A combination of seeing it as an input and not wanting to see clients
have to make decisions about regulator modes being suitable for them -
mode is often not an immediately useful peiece of information since it's
system specific what is appropriate.  When the API says "mode" that says
"configuration" to me.

I'd see status reporting as a mostly orthogonal issue to having modes -
there's no need for a regulator to support both (I'd expect most with
modes to have status reporting but there's probably corner cases there)
and I think a useful interface for reporting status would be different
to one reporting modes.

> > Does what I've said above make what I'm saying seem more reasonable
> > here? 

> What do you mean by status then?  mode, enabled, voltage min/max,
> current min/max ... everything that can get into a set() interface?

For reading back the configuration, yes.  For operational status
I guess anything that can be determined (I'm not saying this all has to
be in one call).

> I'm just trying to make sure the interfaces don't seem broken for
> the hardware I'm currently working with.  For that purpose, the
> only real problem relates to get_mode():  it can't report one of
> the three basic hardware output states (OFF), or for that matter
> any communication errors talking to the regulator.

For hardware like that I'd have a disabled regulator either report
whatever would be set when the regulator is enabled or report nothing.
The former is more what the interface expects but a bit odd.

Communication errors would go under status reporting - at the minute the
only thing for that is to fail configuration operations and/or raise a
notification.

> I'm still trying to determine whether you expect get_mode() to
> report a regulator input or output ... then

>  - if it's an input, why is it querying the hardware vs say just
>    accessing a regulator_dev field the driver initializes and then
>    the framework maintains ... and how to get an output;

Mostly just because it's been easier to query it when needed.  The
boostrapping case is an important one (most regulators will have their
configuration left alone at runtime and just enable/disable) and it
avoids needing to consider if these things may actually be volatile.  If
it were causing performance, locking or similar issues we'd probably go
to storing it in the class.  The same considerations apply to all the
other configuration readback.

As to how to get an output, we need to add a new API for that.

> It's seeming unduly difficult to get this interface sorted out...

It's the input/output thing which is a massive conceptual mismatch and
wasn't immediately apparent since it was obscured by the focus on shared
control.
