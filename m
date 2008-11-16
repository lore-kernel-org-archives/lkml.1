Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYKPXG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYKPXG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYKPXFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:05:21 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40684 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754030AbYKPXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:05:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ioBDQr1jRVFRed+y/zGj7xIq9MBvw363bnuSdK05+GMIKQihz70AHXlFfs/6maTV81G9FFTbiANa0mhOoFwLeZlytxcg/jIgLeSAxMAWkMQ5n+ZB+Ppv+lhcsEuJcy2pYy/tAsLcjjfLZPOlkPkA2MVhfFOVP7Umv5pbd2XQMOQ=  ;
X-YMail-OSG: LnW0d3cVM1mYLkJCepLcCh.YFpBfcRCd5RiBcFNAw6WpaSeJP4pYhx8Z2R.8qnZwuS0y23relE47bcMag6YyDipbAlNGA.JWNHik2uci9gctMHRia0MjgaaiBl6M3oEwaVU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811141715.14804.david-b@pacbell.net> <20081115043753.GA23711@sirena.org.uk>
In-Reply-To: <20081115043753.GA23711@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 16 Nov 2008 14:58:16 -0800
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200811161458.17212.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008, Mark Brown wrote:
> It looks like we have several issues here which are confusing each
> other.  From the point of view of control and reporting we have two
> cases:

Succinctly:  (control) inputs, of which Linux is not the exclusive
source; and (reporting) outputs, which for the sake of discussion I
think we're assuming are highly observable by software.

There are of course cases where the software observability is poor.
Consider a four pin regulator with Vin, Vout, GND, and enable ...
it might shut down on overcurrent, with no report to Linux.  Even if
there were another pin for an overcurrent signal, it might not get
fed to a Linux IRQ handler.  And if it has multiple operational modes,
five pins wouldn't seem to allow reporting which one was current.


>  - The system taking non-Linux inputs into account when configuring the
>    regulators without altering the configuration done by Linux ...
>  
>  - The Linux regulator configuration being changed outside of the
>    control of Linux.  For example, the initial configuration ...
> 
> plus how any divergence between the Linux and hardware state is
> reported.  In the first case there could two simultaneous states, that
> in the configuration and the actual operating state.

That still doesn't make sense to me.  Inputs != outputs; they're
different, so **OF COURSE** they diverge ... inputs from "other"
sources, or observability gaps, just make that more obvious.


> Previously you had only talked explicitly about the former case but now
> I see that you are talking about the latter as well.

Mostly just to highlight that a model based exclusively on
inputs from Linux has deep output-shaped holes.


> There's also the issue of how we report a regulator which is turned off
> - you wish to report this via adding a REGULATOR_MODE_OFF while I don't
> feel that fits well with the model the code has and is not adequate for
> reporting conditions that might cause the regulator to become disabled.

Yet you still haven't suggested a solution you like better than
just having regulator_ops.get_mode() report the regulator's state...

Describing fault conditions is IMO an entirely different issue
from reporting the current regulator state.


> On Fri, Nov 14, 2008 at 05:15:14PM -0800, David Brownell wrote:
> > On Thursday 13 November 2008, Mark Brown wrote:
> > > On Thu, Nov 13, 2008 at 11:40:15AM -0800, David Brownell wrote:
> 
> > And I almost forgot (d) system startup until set_mode() is called,
> > if indeed it's ever called.
> 
> Right, this is...
> 
> > > reported.  What the existing drivers are doing is making get_mode() the
> > > inverse of set_mode(). 
> 
> > I looked at the regulator_ops methods, and what all but one of them
> > does is look at the hardware
> 
> ...roughly what this is about.  
> 
> >                               ... which isn't "the inverse".   (That
> 
> It's the inverse of set_mode() in the sense that assuming Linux has full
> control of the system a calling set_mode() with the result of get_mode()
> produces no configuration change.

But Linux *never* has full control.  Inputs always include at
least pre-Linux hardware and firmware actions, and the load
presented to the regulator.  And quite possibly more ... the
set_mode() input is only one factor in the regulator state.

A sensible control model for regulators could be exposed through
the current regulator_ops calls.  But it requires a more useful
definition of what ops.get_mode() does ... as an output, not a
mirror to one of the inputs, and with more return value options.


> 	As I said at the head of the mail I really hadn't been considering
> changes in this outside of the control of Linux, only changes to the
> operating state of the regulator in addition to this.  This means that...
> 
> > > I'm not sure about that to be honest.  From that point of view it'd seem
> > > we'd also need to consider all the other configuration that the
> > > regulator might have since there's no reason why that couldn't also be
> > > overridden by other sources too.
> 
> > I'd be fine with an interface which only exposed hardware state,
> > and offered ways to change it ... but didn't try to show history
> > of requested changes.  That's a very common interface idiom, and
> > in fact what most of the regulator stuff already does.
> 
> ...I think we may actually (mostly?) agree here apart from the question
> of what exactly a mode is?

I hope we converge at some point.

 - For ops.set_mode() it's clearly an input from Linux, applying
   only when regulators are enabled.  One glitch there is that most
   of the regulators I happen to have worked with have one mode
   configuration register, with OFF (disabled) as an option...

 - For ops.get_mode() I'm still not clear whether you agree that
   it's reporting an output -- the actual mode -- or else reporting
   an input -- some "requested" mode.  (OFF is again an issue.)

You seem to be going back and forth about whether get_mode() is
reporting a hardware output, or just a recorded input.  (Which
may have been recorded in hardware, but is still just an input.)
I'd like to see agreement that it reports an OUTPUT ...


Minor sidelight:  as I mentioned previously, I found out how
to implement ops.set_mode() on twl4030.  You can think of it
as accessing one of three write-only mode-request registers
associated with that power resource.  So it's not practical
to report that input, using ops.get_mode() or any other call.
However it's trivial to report the mode the hardware computes
from all its inputs (including those three registers).

 
> > Most of the sysfs attributes now shown are from the "constraints"
> > structure ... and the nine (!) supporting suspend mode operation
> > don't relate to things that Linux could examine while suspended.
> > So your thought couldn't even apply there.
> 
> Right, on the currently supported regulators the suspend mode
> configuration is visible and configurable at runtime too - the hardware
> provides separate registers

I'd sure hope the framework isn't trying to be specific to,
say, that Wolfson hardware...


By the way:  how have you envisioned putting those mode+enable
inputs into the right part of the PM sequence?

It'd seem to me that having the regulator clients handle this
stuff would always be correct -- and is in any case necessary
for runtime PM -- but if regulators get involved, goofing the
sequence would be easy:  regulator off, then driver relying on
it has some work to do ... but it can't, since it's off.


> 	the configuration from which is used when 
> suspended (which is then complicated by the framework handling the
> multiple suspend modes Linux has).  The scripts provided by the TWL4030
> are rather different here and don't seem to fit quite so well.

That's putting it mildly.  But on the plus side, nobody using
a twl4030 is ever likely to care about "system suspend states"
since that model is a poor match for very low-power hardware.

Truly low power designs leverage runtime power saving, in both
hardware and software, to the extent that the normal idle loop
may use what a PC would call suspend-to-RAM ... but wake into
a mode where pretty much every device is in a low power state,
except if it's in active use.

It's a ways off yet, but I catch myself wondering if we'll be
able to put regulators for MMC cards into low power mode when
they're idle.  We'd want to know the card's internal controller
was done working though.  If we can't know that, we'll have to
make sure nothing accidentally kicks in that mode...


> > And then applying that to some voltage regulators, I observe
> > no particular issue with get_voltage() or is_enabled() status
> > methods ... but get_mode() doesn't support relevant answers,
> > or even error returns.  It seems clearly in need of fixes, and
> > the discussion with you has strengthened that impression.
> 
> So.  Here we're back to the question of what a mode is.  Hopefully what
> I've said above has made my position clearer here.  I really do think
> you're trying to push too much into get_mode() and I still feel that
> your off mode should be a regulator which has either been disabled or is
> reporting an error condition.

I already showed why that wouldn't be appropriate.  That
"disabled" attribute is an input ... but regulator state
is an output.

Are you arguing that there should be some new regulator_ops
call to expose the actual regulator state?  If so, then
what should happen to the get_mode() call?  As I've noted,
if that's not reporting an output, it's a superfluous call.


> > > > The top reason to display system state in sysfs is to support
> > > > troubleshooting ... and hiding the actual system state makes
> > > > that needlessly difficult.
> 
> > > No argument here, either.  What I'm not so sure about is that get_mode()
> > > alone is the ideal way to report this. 
> 
> > On the other hand, it's sufficient in typical cases and even
> > in some not-so-typical ones.  And simple.  Platonic Ideals
> > are problematic to apply here, as in many pragmatic contexts.
> 
> One other part of this is that modes are something that should be the
> concern of machine drivers and a few specialist consumers

Though it does imply something about what a "standard client"
might be.  Something that's barely power-aware will just stick
to enable/disable.  Something that's trying to avoid cutting a
day off the use cycle of a 1000 uAh battery might have lots of
reason to care about regulator modes... those clients would be
"standard" on certain kinds of hardware.  :)

That said, such power-sensitive drivers will set_mode(), or
maybe set_optimimum_mode(), and not care about get_mode().

The primary use for get_mode() seems to be looking at what a
system is actually doing -- not driver support.


> and it should 
> be a warning flag if they appear elsewhere.  If a standard client has to
> consider modes that indicates to me that something is going wrong but
> determining if a supply has failed feels like something a normal client
> could reasonably want to do.

Given that's true, why are you pushing so hard against making
the ops.get_mode() reflect the actual regulator state??  (That
is, to reflect regulator output, not be a record of an input.)


> > > It feels to me like we wold be 
> > > better off exposing both physical and configured versions of all the
> > > existing status for the regulators (not just mode) plus some additional
> > > information for error conditions.
> 
> > That's altogether too complex for my taste.
> 
> Does what I've said above make what I'm saying seem more reasonable
> here? 

What do you mean by status then?  mode, enabled, voltage min/max,
current min/max ... everything that can get into a set() interface?

I'm just trying to make sure the interfaces don't seem broken for
the hardware I'm currently working with.  For that purpose, the
only real problem relates to get_mode():  it can't report one of
the three basic hardware output states (OFF), or for that matter
any communication errors talking to the regulator.


> As I said above, I think we're talking at cross purposes about 
> what the physical and configured statuses are and I think I've been
> making some incorrect assumptions about what your hardware can do.
> 
> I'm not saying we should implement any additional reporting interfaces
> without hardware that can use them.

I'm still trying to determine whether you expect get_mode() to
report a regulator input or output ... then

 - if it's an input, why is it querying the hardware vs say just
   accessing a regulator_dev field the driver initializes and then
   the framework maintains ... and how to get an output;

 - else if it's an output, how to report the missing modes like
   OFF, error, and maybe FAULT.

It's seeming unduly difficult to get this interface sorted out...

- Dave

