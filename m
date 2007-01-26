Return-Path: <linux-kernel-owner+w=401wt.eu-S1030706AbXAZCIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706AbXAZCIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXAZCIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:08:22 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:22579 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030704AbXAZCIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:08:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3KDbaoO3Yb/BMn/yVOiLLjM2m4rt8FpCfU+jxO7Gjd1in2fzXh7vj8N6rI2PpYZv1agiqA8g6OH3hskXjWOe2pM2dx81t86QPjGyjQAz/BusovLQpmjBGbm0SwNga7s1u1+qhK1kYAp7Rn1IF9gcsuY6WwNasTTuOfnRJnpRD5o=  ;
X-YMail-OSG: 1vkVnfgVM1klP9XAcWA5sri_8FfN6tQRL_laBZaXjpQs2PkMa4fskcVnovztFVMDUjFkKCHRhrW2pydstyyF6_2ytLgHFuwFIDA5Lr95h2rjWC7ONxU-
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: 2/5: Updates to SPI and mmc_spi: clock with cs inactive, kernel 2.6.19
Date: Thu, 25 Jan 2007 17:28:11 -0800
User-Agent: KMail/1.7.1
Cc: dbrownell@users.sourceforge.net, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200701250450.l0P4oe3I017089@ignucius.se.axis.com>
In-Reply-To: <200701250450.l0P4oe3I017089@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251728.12119.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 8:50 pm, Hans-Peter Nilsson wrote:
> 
> There was a comment in the mmc_spi.c glue driver at
> <URL:http://www.gossamer-threads.com/lists/linux/kernel/671939#671939>:
> +                * some cards seemed happier if they were initialized first
> +                * by the native MMC stack, not SPI ... and in other cases
> +                * rmmod/modprobe of mmc_spi helped the card work better,
> +                * even without power cycling
> +                *
> +                * FIXME find out what that important state is, which is
> +                * not reset here... and makes robustness problems
> 
> I think I've spotted the problem, or at least a problem with a
> solution that fits the description.  What's missing is "at least
> 74 SD clocks to the SD card with keeping CMD line to high. In
> case of SPI mode, CS shall be held to high during 74 clock
> cycles" (from Section 6.4.1, in "Simplified Physical Layer
> Specification 2.0"). ...
> 
> The gotcha is that the SPI framework didn't have a way to
> express transfers with chip-select inactive.  Sure, you can set
> chip-select to inactive for a period of *time*, but never while
> also toggling the clock. 

Actually it _does_ have a way to handle it, if you think about the
problem a bit differently ... focus on high/low, not "inactive":

	spi->mode |= SPI_CS_HIGH;
	spi_setup(spi);
	// chipselect is now low (conventionally active)

	// ... then high during this next transfer:
	... write 74+ zero bits (10+ bytes)
	// now low again (conventionally "active")

	spi->mode &= ~SPI_CS_HIGH;
	spi_setup(spi);	
	// now high (conventionally "inactive")

That is, for just one one transfer, say the device uses inverse
chipselect polarity:  active-high, not active-low.  Then back to
normal.  Right?  So long as nobody else can access that SPI bus
(the claim/release issue), all should be fine.

That mechanism has been defined for some time, but not widely
implemented; a few chips rquite that semantic for chipselect in
normal operation.

If you agree on this, please update your patch #4 accordingly.
You may need to update your SPI controller driver to handle this
issue too.  (ISTR punting on making the bitbang framework handle
it, but so long as the chipselect is managed with a GPIO this
ought to be almost trivial.)

- Dave

