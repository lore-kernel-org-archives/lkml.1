Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZGXOfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZGXOfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZGXOft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:35:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46008 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752200AbZGXOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:35:49 -0400
Date: Fri, 24 Jul 2009 15:35:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
Message-ID: <20090724143547.GC28228@rakim.wolfsonmicro.main>
References: <1246057668.10360.316.camel@brutus>
 <200906301936.20818.david-b@pacbell.net>
 <20090701114603.GA22063@rakim.wolfsonmicro.main>
 <200907221403.07985.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907221403.07985.david-b@pacbell.net>
X-Cookie: Yow!  Are we laid back yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 02:03:07PM -0700, David Brownell wrote:

> 	/* that this simple idiom would finally work */
> 	if (regulator_is_enabled(r))
> 		regulator_disable(r);

For the avoidance of future disappointment please note that an exclusive
access request does not remove the reference counting on the regulator,
it only changes the way in which it is intialised.  This means that the
above code is only guaranteed to cause the regulator to be disabled so
long as the consumer never calls enable() twice without a matching
disable().  It will, however, not return an error due to unbalanced
enables and disables which I believe is your primary requirement here.

> of which were within (d) an ever-increasing number of constraints
> you grew with each new iteration.  I had to try so many different
> approaches since nothing seemed to be getting through.  The lack

For clarity and in the hope that this helps to avoid future issues
let me list the three major constraints in this area:

 - The API supports shared regulators.
 - Regulator enabling by software is reference counted.
 - Changing the state of regulators before drivers have had a chance to
   take control of the devices is very disruptive to the system and
   needs to be avoided as a result.

Everything else flows from those, in conjunction with the standard
considerations about making sure that any transitions are managed in as
graceful a fashion as possible.

I'm leaving the rest of your mail because I don't think discussing that
further here is going to get us anywhere.
