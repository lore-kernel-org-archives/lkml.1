Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXJaIxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXJaIxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXJaIwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:52:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:20904 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbXJaIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:52:49 -0400
X-IronPort-AV: i="4.21,350,1188792000"; 
   d="scan'208"; a="55264714:sNHT5008008579"
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with
	SPI flash ST25P16 on bf548
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: bryan.wu@analog.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <200710310102.36542.david-b@pacbell.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <200710310011.33545.david-b@pacbell.net>
	 <1193816110.6971.50.camel@roc-laptop>
	 <200710310102.36542.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 31 Oct 2007 16:52:30 +0800
Message-Id: <1193820750.6971.69.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 31 Oct 2007 08:52:35.0100 (UTC) FILETIME=[61938DC0:01C81B9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 01:02 -0700, David Brownell wrote:
> On Wednesday 31 October 2007, Bryan Wu wrote:
> > IMO, the spi_transfer.speed_hz <= spi_board_info.max_speed_hz and if
> > spi_trasnfer.speed_hz is 0, we should use spi_board_info.max_speed_hz.
> > From the meaning of max_speed_hz, the spi_transfer.speed_hz should not
> > beyond max_speed_hz.
> 
> According to the interface spec that's not how it works; so I'm
> not sure what you base your opinion on.  It's not defined with
> such constraints.
> 
My opinion is based on the name of max_speed_hz.
Actually, I know it is for the controller to compute the baud rate from
system bus clock or something similar.

> That might be a reasonable policy to adopt in many cases, and
> nothing prevents any given protocol driver from choosing to follow
> it.  But likewise, if the driver chooses _not_ to follow it, it's
> wrong for a controller driver to add its own private rules.
> 
> > In your explanation, the max_speed_hz is just a default value. the
> > transfer speed_hz can beyond max_speed_hz.
> 
> Kerneldoc for board info says;
> 
>  * @max_speed_hz: Initializes spi_device.max_speed_hz; based on limits
>  *      from the chip datasheet and board-specific signal quality issues.
> 
> So yes -- initial value, it can be changed.  If a driver says
> 
> 	spi->max_speed_hz = X;
> 	spi_setup(spi);
> 
> that's how it requests a different clock rate ceiling.  It can lower
> the rate; it can raise it.
> 
> 
> The reason it's called max_speed_hz is that most systems compute the
> clock rate by dividing a base clock, and few can achieve that exact
> value.  The name indicates that it's to be treated as an upper limit,
> not a lower limit or exact value.  The controller driver should get
> as close to that rate as it can, without going over.
> 

Thanks for this clarification.
max_speed_hz acts as a default clock rate ceiling in the spi_setup(spi)
At the beginning of each real spi transfer, we should check the
spi_transfer.speed_hz like this:

---
		/* Speed setup (surely valid because already checked) */
		tmp = transfer->speed_hz;
		if (tmp == 0)
			tmp = chip->max_speed_hz;
		spi_set_baud_rate(tmp);
---

-Bryan
