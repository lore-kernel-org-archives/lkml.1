Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXJaICz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXJaICz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXJaICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:02:42 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:45305 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753369AbXJaICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:02:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AHiXGczBI9bBH6/PFclgzYtKgiZp5AF1q2uRYBxC1P1zSjTQaGPtQkh7+9jjItE6Fb59v3Tj5Ue1AZ4LiPphGssvLOKL2L1PneZ+WwUhQwNklISoQCQvW10Mt1S3osQG3WNU/5FghPHt+4xwRk4o7BTGgJqKo6HicCWwZ53cms0=  ;
X-YMail-OSG: u4zo1DAVM1l0zXx5VYBNI9OIAp_D49cP.tcQoAaZZ0KwIctkEeHnIVw26V_CQFUn9GPv8.vPBw--
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Wed, 31 Oct 2007 01:02:36 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <200710310011.33545.david-b@pacbell.net> <1193816110.6971.50.camel@roc-laptop>
In-Reply-To: <1193816110.6971.50.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710310102.36542.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007, Bryan Wu wrote:
> IMO, the spi_transfer.speed_hz <= spi_board_info.max_speed_hz and if
> spi_trasnfer.speed_hz is 0, we should use spi_board_info.max_speed_hz.
> From the meaning of max_speed_hz, the spi_transfer.speed_hz should not
> beyond max_speed_hz.

According to the interface spec that's not how it works; so I'm
not sure what you base your opinion on.  It's not defined with
such constraints.

That might be a reasonable policy to adopt in many cases, and
nothing prevents any given protocol driver from choosing to follow
it.  But likewise, if the driver chooses _not_ to follow it, it's
wrong for a controller driver to add its own private rules.


> In your explanation, the max_speed_hz is just a default value. the
> transfer speed_hz can beyond max_speed_hz.

Kerneldoc for board info says;

 * @max_speed_hz: Initializes spi_device.max_speed_hz; based on limits
 *      from the chip datasheet and board-specific signal quality issues.

So yes -- initial value, it can be changed.  If a driver says

	spi->max_speed_hz = X;
	spi_setup(spi);

that's how it requests a different clock rate ceiling.  It can lower
the rate; it can raise it.


The reason it's called max_speed_hz is that most systems compute the
clock rate by dividing a base clock, and few can achieve that exact
value.  The name indicates that it's to be treated as an upper limit,
not a lower limit or exact value.  The controller driver should get
as close to that rate as it can, without going over.


> We found the bug in M25P16 
> should be related this missing checking of the transfer  speed_hz.

The m25p80 driver doesn't change that value...

So if there was any issue there, it must have been related to
something else in your controller driver.

- Dave
