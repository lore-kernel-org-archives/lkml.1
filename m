Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZINK5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZINK5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZINK5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:57:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55564 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751547AbZINK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:57:13 -0400
Date: Mon, 14 Sep 2009 11:57:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: regulator: adding constraints to regulator_desc?
Message-ID: <20090914105714.GA16736@rakim.wolfsonmicro.main>
References: <20090914104101.GB3164@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914104101.GB3164@pengutronix.de>
X-Cookie: Satire is what closes in New Haven.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:41:01PM +0200, Wolfram Sang wrote:
> the constraints on the power-domain-level. As we also have constraints on the
> regulator-level, all the regulator drivers do sanity checks in their
> set_voltage()-functions. These checks differ and it is not always clear to me
> if additional checks other drivers have were forgotten or intentionally omitted
> for a specific driver. I also wondered about code-duplication and if it was
> maybe worthwhile to simply add 'min' and 'max' members to struct regulator_desc
> and let the core do sanity checks (like it does for the constraints on the
> power-domain-level). Has this been considered already?

The checks at the regulator level should be checking more than can be
specified in the constraints - they should also be checking that the
regulator can actually deliver the requested voltage.  It is possible
that a request could be within the constraints but in between two steps
that the regulator can deliver and therefore not supportable.  Drivers
that don't do the additional checks should really be doing them.

These checks could be factored out if we change the API for setting
voltage to work in terms of voltage selectors and force the
implementation of list_voltage() but it's never seemed worth the hassle
yet since we've got cross-tree merge issues caused by the fact that half
the regulator drivers end up getting merged via the MFD tree.  Those
could be dealt with by supporting both methods for a release cycle.  I
might have a look again today, I'm going to be looking at some regulator
drivers anyway.

> One thing which also raised my attention was the beginning of
> regulator_check_voltage(). It starts with

> 	BUG_ON(*min_uV > *max_uV);

> Is it really necessary to halt the kernel? Wouldn't a big warning and -EINVAL
> do like at the end of the function?

That should also be OK, yes.  The risk is that once you start loosing
the plot on regulator stuff the system will often die anyway due to
power problems but WARN_ON and an error would cover the diagnostics just
as well.
