Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZAJSnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZAJSnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZAJSne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:43:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3149 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZAJSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:43:33 -0500
Date: Sat, 10 Jan 2009 18:43:17 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       lrg@slimlogic.co.uk
Message-ID: <20090110184316.GB31525@sirena.org.uk>
References: <4968C652.2050300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4968C652.2050300@gmail.com>
X-Cookie: Brain off-line, please wait.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regulator consumer and i2c device interaction.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 04:01:22PM +0000, Jonathan Cameron wrote:

[Regulators use a struct device and a supply name for lookup...]

> Now in the case of i2c devices, the struct device  pointer is created
> somewhat later and isn't readily available.

> I think the struct device pointer is only used as device instance specific
> token in the regulator framework.  If so is there any reason it can't be

That's the primary reason - this idiom is also used by at least the
clock API and possibly other things.  It also allows us to do things
like show which devices are supplied by which regulators in sysfs.

> relaxed to a void * thus allowing something else to be used in i2c drivers?

That's doable at the cost of the diagnostic info but...

> If so what could actually be used?  Unfortunately all the data elements
> of i2c_board_info are coppied out (rather than a pointer to the original
> structure being used) so that's not currently available.  I guess it could
> be made so at the cost of a single pointer in each i2c_client structure.

...as you say it's a bit tricky to use right now.  I haven't checked but
I expect that the platform data that you can supply in the i2c board info
would work as a token, though it's far from ideal and there may be no
other need for platform data.

As a temporary workaround note that the regulator API allows the device
to be NULL at the minute, though there is a desire to remove that
option.  Providing your regulators have unique names you will be able to
pass the supply name in as platform data and use that only.  This usage
is not encouraged and will hopefully become invalid over time, it's
there at the minute mainly because we don't have a good idea what to use
for the struct device for cpufreq drivers.

> So the question is how would people prefer to do this?

It'd be nice to be able to access the struct device for i2c devices more
readily at registration time.  Like I say, it's not a regulator specific
issue so it'd be good to come up with a general solution.
