Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZFZK4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZFZK4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZFZKz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:55:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52524 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZFZKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:55:57 -0400
Date: Fri, 26 Jun 2009 11:55:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Message-ID: <20090626105550.GE5415@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
 <20090625233723.GA13150@sirena.org.uk>
 <1245996263.10360.122.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245996263.10360.122.camel@brutus>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 03:04:23AM -0300, Daniel Ribeiro wrote:
> Em Sex, 2009-06-26 às 00:37 +0100, Mark Brown escreveu:

> > actively being used off is likely to cause issues.  Regulator drivers
> > should just leave everything as they find it and leave it up to the core
> > and machine drivers to make any changes.

> So, the regulator is enabled at boot, but it can't be disabled because
> use_count is 0. This is the same issue as twl4030-mmc, but instead of a
> enable/disable pair on pxamci.c i opted to disable it at pcap's

At the minute you need to use the enable/disable pair since (as we've
previously discussed) the API needs to support regulators which are
shared between multiple users (potentially including multiple users from
the same consumer).

> regulator probe(). VAUX2 and VAUX3 are only used for MMC on all the
> hardware that I know of, so it is safe.

I've heard that one before :)

> I can move this hack to pxamci.c if you want me to (as David did for
> twl4030), but this issue really should be fixed on regulator/core.c:

You need to either do that or add an API allowing consumers to claim a
regulator for exclusive use.  If the regulator is claimed for exclusive
use then other consumers wouldn't be able to access it and there would
be no issue with interfering with other users.

> With the current code if you use a regulator which can be disabled as
> the supplier for the CPU core, then the regulator framework will power
> off the CPU at boot.

This will only be done if the board has said that it has fully specified
the regulator configuration - if the board hasn't done that then the
state of the regulators will stay unchanged.  The regulator API is very
dependant on boards supplying good constraints, if bad constraints are
provided the consequences could include even more serious things like
lasting hardware damage.  This is just an example of what can go wrong
with a bad board setup.

> Maybe you should simply allow disable() if use_count is 0, and not
> auto-disable() on regulator_init_complete() ?

That doesn't fulfil the same need since it requires that there be a
consumer for the regulator to actively sit there and disable it.  It's
not intended to help if a consumer actively needs to have the regulator
disabled right now, it's there to disable the regulator if nothing wants
to have it on which isn't quite the same thing.
