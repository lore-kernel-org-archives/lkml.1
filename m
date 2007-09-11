Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbXIKPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbXIKPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXIKPCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:02:15 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:47594 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXIKPCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:02:14 -0400
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no> <46E6A737.6080805@anagramm.de>
Date: Tue, 11 Sep 2007 17:02:10 +0200
In-Reply-To: <46E6A737.6080805@anagramm.de> (Clemens Koller's message of "Tue,
	11 Sep 2007 16:33:27 +0200")
Message-ID: <ujrabrt2qkt.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller <clemens.koller@anagramm.de> writes:
> It looks odd to me to do only differential up and down adjustments.
> I would prefer read_calibration_register and write_calibration_register
> access and let the userspace decide how much it wants to
> increment/decrement the register.

Without knowing exacly which chip is present, there is no way for the
userland calibration tool to know how big a difference a calibration
step makes.  I don't see the value in telling the caller that the
current calibration value is N when it actually has no idea what N
means, what the allowable range is, if the scale is linear,
logarithmic, exponential, discontinuous...

The M41T11, for instance, has a calibration register that runs from
-31 to +31, with negative values are multiples of ~2.034 ppm while
positive values are multiples of ~4.068 ppm.

Therefore, I prefer to leave it to the driver author to decide what a
reasonable step in either direction is.  The only consequence for the
userland calibration tool is that the RTC may take longer to converge
on hardware that has smaller calibration steps.

> Or - do you adjust your date also after you changed your battery
> with +1567days,7h,34m,12sec instead of telling it's 11th Sept. 2007, 4:33pm ?

No, the calibration process should start by setting the RTC to the
same time as the reference clock once it becomes available, then
waiting for a sufficient amount of time (at least three or four hours
to begin with, then progressively longer as the divergence decreases)
before measuring and adjusting.

Alternatively, if you don't want to set the RTC, you measure the
delta, wait sufficiently long, measure the delta again, and compare
the two deltas (this method is actually exactly the same as the one
outlined above, except that above the initial delta is 0)

DES
-- 
Dag-Erling Smørgrav
Senior Software Developer
Linpro AS - www.linpro.no
