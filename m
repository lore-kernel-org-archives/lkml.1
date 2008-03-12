Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYCLAPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYCLAPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCLAO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:14:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4399 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYCLAO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:14:56 -0400
Date: Wed, 12 Mar 2008 00:00:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Message-ID: <20080312000044.GA30908@sirena.org.uk>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <1205230841.13653.204.camel@localhost.localdomain> <200803111436.29073.david-b@pacbell.net> <200803111525.10717.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803111525.10717.david-b@pacbell.net>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 02:25:10PM -0800, David Brownell wrote:
> On Tuesday 11 March 2008, David Brownell wrote:

> > How would you see your notion of a "regulator" (client?)
> > relating to a "power domain"? ?My first thought is that
> > there's a one-to-one correspondence but they may not be

> Actually, it's clearly not one-to-one.  Counter-example:
> a 3V3 regulator powering one of a SOC's I/O power domains,
> which is managed by a digital switch.  That same regulator
> can power several I/O devices too.  It may even feed a 1V8
> regulator.

It's also common for devices to have multiple power inputs which can be
run separately if required but which are normally tied together unless
there is a special reason to do so.

> So the relationship is probably that regulators define a
> domain ... but such domains can be subdivided.  There's
> a tree; it's probably more shallow than the clock tree.

This is pretty much the model that is currently implemented.  A given
power management IC can have several regulators (that is, things which
have regulator IDs registered and can supply power).  Each regulator can
have multiple clients bound to it (that is, things that have called
regulator_get() and can consume power).  It is also possible to tell the
core that one regulator supplies another - if this is done then the core
will take care of ensuring that parents are enabled when their children
need them.

> And enable/disable primitives probably map best to power
> domains, not all of which are entire regulators.

While the leaf enable/disable operations do happen at the client level
the core reference counts the enabled clients to control enabling of the
actual supply.
