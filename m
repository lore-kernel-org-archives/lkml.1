Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYLBBWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYLBBWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLBBWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:22:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1299 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYLBBWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:22:38 -0500
Date: Tue, 2 Dec 2008 01:22:32 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc6+] regulator: bugfixes and messaging cleanup
Message-ID: <20081202012231.GA19108@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk> <200812011558.09154.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812011558.09154.david-b@pacbell.net>
X-Cookie: He who laughs last didn't get the joke.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 03:58:08PM -0800, David Brownell wrote:
> On Monday 01 December 2008, Mark Brown wrote:
> > On Mon, Dec 01, 2008 at 01:35:43PM -0800, David Brownell wrote:

> > This could usefuly be split into a patch series, there's rather a lot
> > of different changes in here...

> At most I'd see two patches:  one with bugfixes, one with messaging
> fixes that aren't strictly "bug" fixes (i.e. messages worked but
> violated normal conventions like driver model).

I'd expect that, for example, reordering the startup sequence could also
be usefully pulled out into a separate patch.

> > >  	if (id == NULL) {
> > > -		printk(KERN_ERR "regulator: get() with no identifier\n");
> > > +		dev_dbg(dev, "regulator_get with no identifier\n");
> > >  		return regulator;
> > >  	}

> > dev may legally be NULL here

> The kerneldoc doesn't mention that at all ... seems like a pretty
> major interface artifact.  Hmm, for that matter I notice that if

Well, it matchs the clock API and the fact that there isn't an explicit
check for a NULL dev along with the check for a NULL id.  :)

> you were to run kerneldoc, regulator_register() -- and presumably
> other functions -- would get lots of errors.

I'd not be surprised, I doubt it's ever been checked.

> Allowing it to be NULL seems pretty much contrary to the model that
> a supply name is associated with a device.  I'd call that a bug and
> fix it ... vs calling it a feature and diverging from standard
> framework models.

Ideally everything should use a device but sadly it's not universal yet.

> > which is going to cause upset if the 
> > dev_dbg() is hit.  Things like cpufreq which can use regulators don't
> > use a struct device (currently!) so it's supported.

> Which cpufreq driver(s) in mainline use regulator code?

None that I am aware of.  However, there's an i.MX31 cpufreq driver
queued on merging of the clock API support required (plus a non-cpufreq
implementation of DVFS for the same CPU which also uses the regulator
API).

> I had commented not long ago that the regulator framework needs
> updates to support cpufreq.  For example, trying to enable hardware
> support for DVFS (Dynamic Voltage and Frequency Scaling) on several
> platforms requires configuring more than one voltage ... floor and
> ceiling, switched automatically by a CPU signal, for starters.

I'd actually given some consideration to such regulators - while it's a
*bit* of an abuse of the API the fact that voltages are specified as
limits could probably be used somewhat idiomatically for the purpose,
especially if the CPU is controlling things autonomously rather than
having it done by software.  It does need thought, though - that idea is
giving me a bit of ick but it does reflect what's going on.

> It would be good to overhaul cpufreq before trying to make it use
> things like the clock and regulator frameworks.  Fitting into the
> driver model seems overdue, for one.

Well voulunteered :) .

> > > @@ -971,19 +991,16 @@ static int _regulator_enable(struct regu
> > >  	int ret = -EINVAL;

> > >  	if (!rdev->constraints) {
> > > -		printk(KERN_ERR "%s: %s has no constraints\n",
> > > -		       __func__, rdev->desc->name);
> > > +		dev_err(&rdev->dev, "%s has no constraints\n",
> > > +		       rdev->desc->name);

> > Hrm.  You've downgraded most of the diagnostics to dev_dbg()

> No; just ones in the enable/disable paths, and even there just
> ones where the caller has control over the illegal parameters.

You've adjusted things in the supply registration interface and get() in
this way as well and at least the change to the "unable to find" message
in get() may not be directly due to the caller (it could be due to a
failure on the part of the board code to register the supply name).

> Recall that rdev->constraints can be nulled for various reasons
> that aren't under control of the regulator client.

Well, clearly.  The client has no direct control over the constraints.

> I think this was as consistent as possible with the basic rule
> that when the caller could have prevented it, it's their job to
> handle the fault code they get.

I don't see handling the error code and explaining why it happend as
being orthogonal here.  My inclination would be to always log at least
constraint and setup errors (since callers are likely to just fail and
it's useful to say why), at least until the API becomes more widely used
since almost everyone is on a learning curve here.  People can enable
DEBUG but it's nice to just give the error.

I can see logging all the enable and disable errors becoming too spammy,
though, since they are much more likely to be retried.

> > >  		ret = rdev->desc->ops->enable(rdev);
> > > -		if (ret < 0) {
> > > -			printk(KERN_ERR "%s: failed to enable %s: %d\n",
> > > -			       __func__, rdev->desc->name, ret);
> > > -			return ret;
> > > +		if (ret >= 0) {

> > I have to say I'd be happier keeping the logic as it was here.  The
> > behaviour does stay the same due to fall through but it's not quite so
> > clear since it's not consistent with the error handling style for the
> > rest of the function.

> You mean in this case you'd want to see a (needless) GOTO?  I suppose

Yes, it's a bit harder to parse wth the reversed test - the change in
idiom raises an eyebrow, especially since we fall through into a case
marked fail for both success and failure.

> it could be done.  If you want consistency, I'd get rid of the unique
> message for missing constraints, and rely on unique fault codes ...

The point here is the patterns in the code - something that looks
different breaks the flow.
