Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYKOEiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYKOEiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYKOEiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:38:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3532 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYKOEiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:38:00 -0500
Date: Sat, 15 Nov 2008 04:37:54 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20081115043753.GA23711@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811131140.15646.david-b@pacbell.net> <20081113215346.GA3199@sirena.org.uk> <200811141715.14804.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811141715.14804.david-b@pacbell.net>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 05:15:14PM -0800, David Brownell wrote:

It looks like we have several issues here which are confusing each
other.  From the point of view of control and reporting we have two
cases:

 - The system taking non-Linux inputs into account when configuring the
   regulators without altering the configuration done by Linux and where
   the Linux configuration will take over automatically if the external
   configuration is removed.  For exammple, a register enable for a
   regulator and a separate enable controlled elsewhere which are ored
   together (like you've talked about for the TWL4030) or error handling
   in the hardware.
 
 - The Linux regulator configuration being changed outside of the
   control of Linux.  For example, the initial configuration on power on
   or another processor in the system sharing access to the regulator
   configuration registers.

plus how any divergence between the Linux and hardware state is
reported.  In the first case there could two simultaneous states, that
in the configuration and the actual operating state.

Previously you had only talked explicitly about the former case but now
I see that you are talking about the latter as well.  For those cases
then I do completely agree that the information returned by the status
calls should just change along with what the hardware is currently doing
(ideally with a notifier callback when it does).  It's only in the case
where the Linux configuration will persist with no software intervention
that I have any disagreement.

There's also the issue of how we report a regulator which is turned off
- you wish to report this via adding a REGULATOR_MODE_OFF while I don't
feel that fits well with the model the code has and is not adequate for
reporting conditions that might cause the regulator to become disabled.

> On Thursday 13 November 2008, Mark Brown wrote:
> > On Thu, Nov 13, 2008 at 11:40:15AM -0800, David Brownell wrote:

> And I almost forgot (d) system startup until set_mode() is called,
> if indeed it's ever called.

Right, this is...

> > reported.  What the existing drivers are doing is making get_mode() the
> > inverse of set_mode(). 

> I looked at the regulator_ops methods, and what all but one of them
> does is look at the hardware

...roughly what this is about.  

>                               ... which isn't "the inverse".   (That

It's the inverse of set_mode() in the sense that assuming Linux has full
control of the system a calling set_mode() with the result of get_mode()
produces no configuration change.

> > Of the cases you have above I'd be surprised if there were any devices
> > that didn't implement (b) and (c) is provided to at least some extent by
> > the DC-DC convertors in the existing Wolfson drivers (one of the modes
> > they offer automatically adjusts the regulation mode based on load).

> An autoadjust mode can't be requested using today's regulator calls,
> though... REGULATOR_MODE_BEST?  :)

REGULATOR_MODE_NORMAL would likely be a good fit here - do something
sensible over a wide range of loads, probably at a bit lower efficiency
when operating at either of the extremes.

Given that the modes are a bitmask oring them together may make some
sense if explicit support were provided though as you say it's not
supported right now.

> > If reporting the full state via get_mode() the error reporting case in
> > particular would seem to be more involved than adding an off state -

> In that case it would be normal to return some error code.  I always
> like -ERANGE in such cases -- result is out-of-range.  The sysfs code
> will already report "unknown".

I suspect that's due to the use of a bitmask but I do agree that there
should at least be a facility to report a failure to determine the mode.

I'm not sure that regulation failures fit in there, though - I do feel
it's still useful to report the state the hardware is attempting to
operate in since that may well have a bearing on why the error has
occurred (for example, running a regulator in a mode when trying to
supply a load it can't support).

> ... though, hmm, I observe that regulator_ops calls returning modes
> all return "unsigned".  That's clearly broken; it prevents error
> reporting.  And in fact, the wm8350 get_mode() code returns -EINVAL...

Yes, something more like BUG() would be more appropriate there - that's
handling the case of regulators that just aren't supported.

> > Right, if we assume that it reports the instantaneous hardware state.

> Something sure needs to do that... and there's no point to even
> having a get_mode() call if that's not what it does.  If the goal
> is to remember what Linux requested, the framework should have
> been doing it.

When I say the state Linux requested what I really mean is "the state
that is currently being requested in the hardware via the control
interface used by Linux" rather than the last value that was set via the
API.  As I said at the head of the mail I really hadn't been considering
changes in this outside of the control of Linux, only changes to the
operating state of the regulator in addition to this.  This means that...

> > I'm not sure about that to be honest.  From that point of view it'd seem
> > we'd also need to consider all the other configuration that the
> > regulator might have since there's no reason why that couldn't also be
> > overridden by other sources too.

> I'd be fine with an interface which only exposed hardware state,
> and offered ways to change it ... but didn't try to show history
> of requested changes.  That's a very common interface idiom, and
> in fact what most of the regulator stuff already does.

...I think we may actually (mostly?) agree here apart from the question
of what exactly a mode is?

> Most of the sysfs attributes now shown are from the "constraints"
> structure ... and the nine (!) supporting suspend mode operation
> don't relate to things that Linux could examine while suspended.
> So your thought couldn't even apply there.

Right, on the currently supported regulators the suspend mode
configuration is visible and configurable at runtime too - the hardware
provides separate registers the configuration from which is used when
suspended (which is then complicated by the framework handling the
multiple suspend modes Linux has).  The scripts provided by the TWL4030
are rather different here and don't seem to fit quite so well.

> > That's all good and I agree - what you're saying that the only facility
> > in the existing API for reporting back the current hardware status is
> > the error notifier callbacks and that this is really rather too limited.

> Not exactly.  I'm looking at the current methods, transferring
> common idioms from other Linux driver contexts, and observing
> a lot of get_*() methods, which would normally report hardware
> status (else they'd have been part of the framework code, not
> methods provided by the hardware-specific code).

As discussed above I agree with this - when I've been talking about the
configured values I have been talking about the values that are
currently configured in the hardware rather than the last values written
via the API.  This can diverge from the physical output that regulator
is producing, which is what I have been referring to as the current
hardware state, but is still hardware status.

> And then applying that to some voltage regulators, I observe
> no particular issue with get_voltage() or is_enabled() status
> methods ... but get_mode() doesn't support relevant answers,
> or even error returns.  It seems clearly in need of fixes, and
> the discussion with you has strengthened that impression.

So.  Here we're back to the question of what a mode is.  Hopefully what
I've said above has made my position clearer here.  I really do think
you're trying to push too much into get_mode() and I still feel that
your off mode should be a regulator which has either been disabled or is
reporting an error condition.

> This is all extremely young code, and barely used yet; this
> is a common type of interface bug to find at that stage of any
> framework's development.  So I'm saying:  need fixing soon.

No argument about there being room for improvement here.

> > > The top reason to display system state in sysfs is to support
> > > troubleshooting ... and hiding the actual system state makes
> > > that needlessly difficult.

> > No argument here, either.  What I'm not so sure about is that get_mode()
> > alone is the ideal way to report this. 

> On the other hand, it's sufficient in typical cases and even
> in some not-so-typical ones.  And simple.  Platonic Ideals
> are problematic to apply here, as in many pragmatic contexts.

One other part of this is that modes are something that should be the
concern of machine drivers and a few specialist consumers and it should
be a warning flag if they appear elsewhere.  If a standard client has to
consider modes that indicates to me that something is going wrong but
determining if a supply has failed feels like something a normal client
could reasonably want to do.

> > It feels to me like we wold be 
> > better off exposing both physical and configured versions of all the
> > existing status for the regulators (not just mode) plus some additional
> > information for error conditions.

> That's altogether too complex for my taste.

Does what I've said above make what I'm saying seem more reasonable
here?  As I said above, I think we're talking at cross purposes about
what the physical and configured statuses are and I think I've been
making some incorrect assumptions about what your hardware can do.

I'm not saying we should implement any additional reporting interfaces
without hardware that can use them.

> > This caters for any configuration 
> > changes outside of software control and would let errors report without
> > masking any other physical state.

> Of the current set of status reporting calls, get_mode() is the
> only one which can't report errors.  I don't see any need to cater
> any further than letting it report errors, and the actual status.

What is actual status, though?  Is it what's configured in the hardware,
what the hardware is actually managing to do or something else?
