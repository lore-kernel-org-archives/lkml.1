Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZFZPJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZFZPJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZFZPI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:08:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49529 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZFZPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:08:57 -0400
Date: Fri, 26 Jun 2009 16:08:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Message-ID: <20090626150849.GA5504@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
 <20090625233723.GA13150@sirena.org.uk>
 <1245996263.10360.122.camel@brutus>
 <20090626105550.GE5415@sirena.org.uk>
 <1246019192.10360.202.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246019192.10360.202.camel@brutus>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:26:32AM -0300, Daniel Ribeiro wrote:
> Em Sex, 2009-06-26 às 11:55 +0100, Mark Brown escreveu:

> > You need to either do that or add an API allowing consumers to claim a
> > regulator for exclusive use.  If the regulator is claimed for exclusive
> > use then other consumers wouldn't be able to access it and there would
> > be no issue with interfering with other users.

> I'm not proposing an API for exclusive use. Allowing the enable bit to
> be turn off case use_count is 0 shouldn't break regulator sharing for
> other consumers, as far as the regulator framework is concerned there
> are no other consumers.

What breaks things for non-exclusive use is that the driver is doing a
disable when it didn't do the corresponding enable.  This means that if
whatever did the enable still cares about the device being enabled then
it will get upset.  The reason the regulator API complains here is to 
help catch problems in drivers rather than because it itself will fall
over.

> What about increasing use_count at regulator_get() if the regulator is
> already on and use_count == 0? If a consumer requests a regulator that
> was previously ON, then there is no reason for it to enable/disable it.
> If it is requested, and its already ON, then the regulator framework can
> assume it is already being used.

Think about the shared use case here.  If the regulator is enabled when
a consumer starts then the consumer can't tell if this was because the
regulator happened to be left on at system startup or if it was because
some other user of the regulator has enabled it.  This means that none
of the consumers can ever drop that use count so it's stuck there and
the regulator can never actually be disabled.

> If the above is not possible, then regulator_is_enabled() doesn't match
> regulator_enable()/regulator_disable() pair. Maybe the API should make
> this clear?

Frankly I'm not sure how much any documentation is going to help here.
There's already a note about the fact that the regulator might've been
enabled elsewhere, it could be strengthened a bit but it still relies on
people reading it.

Fundamentally, if your consumer is trying to explicitly force the
regulator off then it's not able to cope with the regulator being
shared.  I suspect that if someone does add a non-shared API then the
problem will go away, half the problem is with consumers thinking they
have exclusive use of the regulator.
