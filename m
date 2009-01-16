Return-Path: <linux-kernel-owner+w=401wt.eu-S935493AbZAPBJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493AbZAPBJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762239AbZAPBJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:09:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1173 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934803AbZAPBI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:08:59 -0500
Date: Fri, 16 Jan 2009 01:08:45 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090116010844.GA6553@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200901142303.09217.david-b@pacbell.net> <20090115122937.GC2147@sirena.org.uk> <200901151432.31130.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901151432.31130.david-b@pacbell.net>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 02:32:30PM -0800, David Brownell wrote:
> On Thursday 15 January 2009, Mark Brown wrote:

> > > That raises an issue:  how can Linux get such regulators to
> > > turn off?  Clock frameworks have the same issue, and they

> > That's something that should be done by constraints - add a new flag
> > that can be set.

> That doesn't make any sense to me, any more than
> adding a per-clock flag would.

Well, the clock API doesn't have the concept of constraints or machine
selectable per-clock options such as those set in constraints - it's the
biggest difference between the two APIs.

> > > I'm thinking it'd be worth having a similar Kconfig option
> > > for regulators too.  It could kick in regulator core code to
> > > call regulator_ops.disable() whenever regulator_dev.use_count
> > > is zero, possibly warning if !regulator_ops.is_disabled().
> > > (Handling constraints.always_on too.)

> > Given the model the API has of not doing anything unless explicitly
> > told to

> ... e.g. by CONFIG_REGULATOR_DISABLE_UNUSED being explicitly
> set, indicating that the regulator support for that platform
> (and its drivers) is complete enough that it can safely paper
> over such early init issues.

Yeah, but user visible things in Kconfig aren't quite the same thing as
having something in the machine definition set it up.  At present
control is very firmly in the hands of the board setup code.

> > I'd not expect to see this as a Kconfig option but rather as 
> > something enabled per regulator or at least per board.

> Why not, though?  That works well with clocks, once the
> drivers are debugged.  Having dozens of fiddly little knobs
> is not an advantage.

There's got to be an explict knob, it's just a question of where it's
exposed.

For machines where it works it's something I'd expect the kernel to just
do without having a Kconfig variable set up.  The machine driver is
already going to have to explictly set up all the regulators that are in
use in the system for this to work so the additional cost of requesting
the feature if it were per-board doesn't feel onerous.  It also means
that people configuring the kernel don't need to worry about how well
the regulators are mapped out, which would be especially useful to
anyone trying to build kernels that run on multiple boards.

> The "boot_on" flag seems redundant with given "always_on"; as
> a rule you can *tell* if the bootloader enabled a supply, so
> the issue is more like whether it should stay on, even when no
> driver wants it on.  Especially considering that bootloaders
> seldom guarantee to enable only a minimal set of supplies.

Yeah, I think that since there's no clean way for clients to disable a
boot_on regulator currently it's only really useful in the very unsual
case where you can't read the regulator state.  If it just enabled the
regulator without incrementing the use count it may possibly useful for
during boot.  I'd need to have a proper think about it to make sure.
