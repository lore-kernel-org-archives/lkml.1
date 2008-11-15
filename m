Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYKOBPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYKOBPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 20:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYKOBPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 20:15:23 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34254 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751546AbYKOBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 20:15:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6dtUV3Pgt8IcyWTl0WLu5xpub9si9fzwLrVL7vfVac5+Rikp8ITy8mtV3sAuW7I+qVhaXgnPrDN+eRpbSdjU/UkPVR8ZpLn3u3H0+mh5iMZXlyjie7qgsc+8H9Q1u6FyxWoB25eAHpR9/lFhngObhkvZ8xVHJtXFc342ztqYD44=  ;
X-YMail-OSG: 4RagOl4VM1lmTqamnpKmEnb2s.jGWFglWMPJj0P8wU9dKt9U6NV8QLkQI6Z03mGbqXyh8twqBK6UfQVgc8UL.iH.OIobJv24Lf1aK7NpOOhENhbph8tUEUvLp4SYv4aafFc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Fri, 14 Nov 2008 17:15:14 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811131140.15646.david-b@pacbell.net> <20081113215346.GA3199@sirena.org.uk>
In-Reply-To: <20081113215346.GA3199@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141715.14804.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008, Mark Brown wrote:
> On Thu, Nov 13, 2008 at 11:40:15AM -0800, David Brownell wrote:
> 
> > And having regulator_ops.get_mode() be the call to report that
> > hardware state is straightforward.  Especially once you consider
> > that the actual state *will* be what Linux requested, except in
> > cases like:  (a) shared regulators, like the scenario above, for
> > which I suspect twl4030 is the first case in Linux; (b) hardware
> > fault handling, like overcurrent/overtemp shutdown; and maybe
> > (c) "smart" regulators that switch modes automatically.

And I almost forgot (d) system startup until set_mode() is called,
if indeed it's ever called.


> So.  This does rather assume that the mode should be expected to change
> in a software visible fashion and that this should be the main thing
> reported.  What the existing drivers are doing is making get_mode() the
> inverse of set_mode().  

I looked at the regulator_ops methods, and what all but one of them
does is look at the hardware ... which isn't "the inverse".   (That
exception always returns NORMAL, and isn't paired with a set_mode.)


> Of the cases you have above I'd be surprised if there were any devices
> that didn't implement (b) and (c) is provided to at least some extent by
> the DC-DC convertors in the existing Wolfson drivers (one of the modes
> they offer automatically adjusts the regulation mode based on load).

An autoadjust mode can't be requested using today's regulator calls,
though... REGULATOR_MODE_BEST?  :)


> If reporting the full state via get_mode() the error reporting case in
> particular would seem to be more involved than adding an off state -
> you'd probably want an explicit out of regulation state, for example.
> If a regulator goes out of regulation it's clearly neither off nor
> functioning properly in the mode the hardware is configured for.

In that case it would be normal to return some error code.  I always
like -ERANGE in such cases -- result is out-of-range.  The sysfs code
will already report "unknown".

... though, hmm, I observe that regulator_ops calls returning modes
all return "unsigned".  That's clearly broken; it prevents error
reporting.  And in fact, the wm8350 get_mode() code returns -EINVAL...


> > Not entirely true.  In this case the issue is exposing regulator
> > output state ... the regulator_ops suffice for inputs, which would
> > combine with other inputs to determine the actual regulator state
> > that's reported using by regulator_ops.get_mode().
> 
> Right, if we assume that it reports the instantaneous hardware state.

Something sure needs to do that... and there's no point to even
having a get_mode() call if that's not what it does.  If the goal
is to remember what Linux requested, the framework should have
been doing it.


> > It seems we've almost converged on the result of get_mode()
> > being that regulator state output, which is a function of more
> > than just the inputs from Linux.
> 
> I'm not sure about that to be honest.  From that point of view it'd seem
> we'd also need to consider all the other configuration that the
> regulator might have since there's no reason why that couldn't also be
> overridden by other sources too.

I'd be fine with an interface which only exposed hardware state,
and offered ways to change it ... but didn't try to show history
of requested changes.  That's a very common interface idiom, and
in fact what most of the regulator stuff already does.

Most of the sysfs attributes now shown are from the "constraints"
structure ... and the nine (!) supporting suspend mode operation
don't relate to things that Linux could examine while suspended.
So your thought couldn't even apply there.


> > > The expectation when writing this was that anything 
> > > software controlled would be fully software controlled.
> 
> > The problem is that the current code *also* ignores the fact
> > that hardware status is a function of more inputs than just
> > those from Linux.  Like thermal shutdown from overcurrent.
> > The configuration inputs might be fine, but the output of
> > a regulator necessarily incorporates other inputs.
> 
> That's all good and I agree - what you're saying that the only facility
> in the existing API for reporting back the current hardware status is
> the error notifier callbacks and that this is really rather too limited.

Not exactly.  I'm looking at the current methods, transferring
common idioms from other Linux driver contexts, and observing
a lot of get_*() methods, which would normally report hardware
status (else they'd have been part of the framework code, not
methods provided by the hardware-specific code).

And then applying that to some voltage regulators, I observe
no particular issue with get_voltage() or is_enabled() status
methods ... but get_mode() doesn't support relevant answers,
or even error returns.  It seems clearly in need of fixes, and
the discussion with you has strengthened that impression.

This is all extremely young code, and barely used yet; this
is a common type of interface bug to find at that stage of any
framework's development.  So I'm saying:  need fixing soon.


> > The top reason to display system state in sysfs is to support
> > troubleshooting ... and hiding the actual system state makes
> > that needlessly difficult.
> 
> No argument here, either.  What I'm not so sure about is that get_mode()
> alone is the ideal way to report this. 

On the other hand, it's sufficient in typical cases and even
in some not-so-typical ones.  And simple.  Platonic Ideals
are problematic to apply here, as in many pragmatic contexts.


> It feels to me like we wold be 
> better off exposing both physical and configured versions of all the
> existing status for the regulators (not just mode) plus some additional
> information for error conditions.

That's altogether too complex for my taste.

If get_mode() is just used better, more like other hardware status
reporting calls, that will solve most of the real problems I've seen.
Other stuff could be added later of course, if needed.


> This caters for any configuration 
> changes outside of software control and would let errors report without
> masking any other physical state.

Of the current set of status reporting calls, get_mode() is the
only one which can't report errors.  I don't see any need to cater
any further than letting it report errors, and the actual status.

There may be *other* reasons to expand the framework, but I'm not
seeing the issues I've turned up as including such reasons.

- Dave

