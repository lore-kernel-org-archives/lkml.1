Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZJRLnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZJRLnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 07:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZJRLnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 07:43:12 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63718 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZJRLnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 07:43:11 -0400
Date: Sun, 18 Oct 2009 13:43:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: Best option for handling dependencies between sysfs params.
Message-ID: <20091018134311.10cde3ce@hyperion.delvare>
In-Reply-To: <4ADA0BC9.4010506@cam.ac.uk>
References: <4ADA0BC9.4010506@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Sat, 17 Oct 2009 19:24:09 +0100, Jonathan Cameron wrote:
> The tsl2561 ambient light sensor has separate controls for integration
> time and for gain.
> 
> Now, discussions about the tsl2550 driver suggested that range be handled
> by an illuminance0_max_range parameter.  In that particular device things
> are simple as there is one internal variable effecting the range.
> 
> So to try and match interfaces, I'm intending to have the
> same illuminance0_max_range and also an integration time parameter.
> (avoiding for now the more complex manual option!)
> 
> My current approach is to use writes to illuminance0_max_range to store
> a 'requested' max gain value.  Thus a later change to the integration time
> parameter may well result in the internal gain parameter also changing
> in order to meet this desired value.
> 
> Reading this parameter will always return the max range value for
> the current configuration.
> 
> Do people think this is a valid approach?  More or less corresponds to 
> 'integration time priority' in the language of photography. In effect
> it makes the internal gain an automatic parameter rather than integration
> time. Could just as easily do the other way round though.
> 
> All comments welcome.

This sounds like a valid approach indeed. I agree that it makes more
sense to let users chose the integration time, as it determines how
averaged the values are, than the gain which doesn't serve much purpose
by itself. Even though the TSL2550 changes the integration time, not
the gain, to select the range. But I can imagine other light sensor
chips could change the gain and not the integration range, so it's not
really relevant.

That being said, I am curious if you consider the integration time a
valuable tweaking knob for the user, as it would be to a photographer,
or not. If not, I imagine that we could set both the gain and the
integration time based on illuminance0_max_range. Just arbitrarily
decide which is set first and how, and which is computed then to match
the request. That would be a more simple user-interface.

I'm not saying that making the user-interface simple is the ultimate
goal here. I am raising the point because I simply don't know. If there
is no immediate need for integration time tweaking, then I see a value
to make all chips use the same simple interface.

Looking at the TSL2561 datasheet, I see that the integration time has
only 3 possible values (13.7 ms, 101 ms and 402 ms), and the gain only
2 (x1 and x16), for a total of 6 possible ranges. This is more than the
2 possibilities offered by the TSL2550, but still doesn't strike me as
fine-tuning capable. Arbitrarily considering integration time of 402 ms
and gain of x1 as the "standard" range, here go the possibilities:

13.7 ms,  x1: 0 -  0.034
101  ms,  x1: 0 -  0.252
13.7 ms, x16: 0 -  0.544
402  ms,  x1: 0 -  1.000
101  ms, x16: 0 -  4.032
402  ms, x16: 0 - 16.000

There's not much overlapping, which gives me the impression that
setting both the integration time and the gain based on the requested
range is a valid option, at least for the TSL2561. What do you think?

(I'm curious if I missed something though, as the datasheet claims
1,000,000-to-1 dynamic range, when the above suggests 470-to-1.)

-- 
Jean Delvare
