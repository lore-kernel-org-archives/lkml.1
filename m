Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYLAX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYLAX6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYLAX6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:58:12 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43639 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751068AbYLAX6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:58:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JgBaO8zqyERXsQew6BseOBkVM1y8hVJNu6rGtxHG/zKumVIz/jM2a4NfNgjn5ZvvgvcatINSeAYSaefpDoJ5SJ3i/dVtAhYnfS+Y/j0V2RYWvZk6Ps4NH4PlTVKo1jlhNoqMbJH9LRpxgmRqphPSQocxyiffEzWt0ZWOmDGfvsU=  ;
X-YMail-OSG: h7xioTkVM1nahFWsJoS.OvVm_hYD23HTrwtnXTsls_Dwvy7v0ZN2gf54Wa8XpHJGZrfgR7RCwky6vhgyfzHn7UdWKEubp2ymeQYWeIiWz.YdmuNP7aRp1g1EE774bSIdqhvgHvzN2H9K.O8SwK7zQLR.YDvTLklAUT4gzOg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc6+] regulator: bugfixes and messaging cleanup
Date: Mon, 1 Dec 2008 15:58:08 -0800
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk>
In-Reply-To: <20081201225312.GA6699@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011558.09154.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008, Mark Brown wrote:
> On Mon, Dec 01, 2008 at 01:35:43PM -0800, David Brownell wrote:
> 
> > Regulator core bugfixes:
> 
> ...
> 
> > And messaging updates;
> 
> This could usefuly be split into a patch series, there's rather a lot
> of different changes in here...

Could be ... I was mostly just collecting core updates involved in
making sure I could regulator_enable() on one board.  The messaging
in the current code was decidedly un-helpful for that task.

At most I'd see two patches:  one with bugfixes, one with messaging
fixes that aren't strictly "bug" fixes (i.e. messages worked but
violated normal conventions like driver model).


> On the whole it looks good, a few 
> things, though:
> 
> > @@ -894,7 +915,7 @@ struct regulator *regulator_get(struct d
> >  	struct regulator *regulator = ERR_PTR(-ENODEV);
> >  
> >  	if (id == NULL) {
> > -		printk(KERN_ERR "regulator: get() with no identifier\n");
> > +		dev_dbg(dev, "regulator_get with no identifier\n");
> >  		return regulator;
> >  	}
> 
> dev may legally be NULL here

The kerneldoc doesn't mention that at all ... seems like a pretty
major interface artifact.  Hmm, for that matter I notice that if
you were to run kerneldoc, regulator_register() -- and presumably
other functions -- would get lots of errors.

Allowing it to be NULL seems pretty much contrary to the model that
a supply name is associated with a device.  I'd call that a bug and
fix it ... vs calling it a feature and diverging from standard
framework models.


> which is going to cause upset if the 
> dev_dbg() is hit.  Things like cpufreq which can use regulators don't
> use a struct device (currently!) so it's supported.

Which cpufreq driver(s) in mainline use regulator code?

I had commented not long ago that the regulator framework needs
updates to support cpufreq.  For example, trying to enable hardware
support for DVFS (Dynamic Voltage and Frequency Scaling) on several
platforms requires configuring more than one voltage ... floor and
ceiling, switched automatically by a CPU signal, for starters.

It would be good to overhaul cpufreq before trying to make it use
things like the clock and regulator frameworks.  Fitting into the
driver model seems overdue, for one.


> > @@ -971,19 +991,16 @@ static int _regulator_enable(struct regu
> >  	int ret = -EINVAL;
> >  
> >  	if (!rdev->constraints) {
> > -		printk(KERN_ERR "%s: %s has no constraints\n",
> > -		       __func__, rdev->desc->name);
> > +		dev_err(&rdev->dev, "%s has no constraints\n",
> > +		       rdev->desc->name);
> 
> Hrm.  You've downgraded most of the diagnostics to dev_dbg()

No; just ones in the enable/disable paths, and even there just
ones where the caller has control over the illegal parameters.

Recall that rdev->constraints can be nulled for various reasons
that aren't under control of the regulator client.


> but left 
> this as KERN_ERR.  It'd be nice to be a bit more consistent.  My
> personal preference is to make things in the constraints and machine
> definitions display at dev_err() since they should never happen and a
> plain text error is often helpful for new users but it's not a very
> strong one either way.

I think this was as consistent as possible with the basic rule
that when the caller could have prevented it, it's their job to
handle the fault code they get.


> 
> >  		ret = rdev->desc->ops->enable(rdev);
> > -		if (ret < 0) {
> > -			printk(KERN_ERR "%s: failed to enable %s: %d\n",
> > -			       __func__, rdev->desc->name, ret);
> > -			return ret;
> > +		if (ret >= 0) {
> > +			dev_dbg(&rdev->dev, "enabled %s\n", rdev->desc->name);
> > +			rdev->use_count++;
> 
> I have to say I'd be happier keeping the logic as it was here.  The
> behaviour does stay the same due to fall through but it's not quite so
> clear since it's not consistent with the error handling style for the
> rest of the function.

You mean in this case you'd want to see a (needless) GOTO?  I suppose
it could be done.  If you want consistency, I'd get rid of the unique
message for missing constraints, and rely on unique fault codes ...

- Dave





