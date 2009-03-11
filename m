Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZCKOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZCKOCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZCKOCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:02:25 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:58806 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZCKOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:02:24 -0400
Date: Wed, 11 Mar 2009 14:02:19 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Message-ID: <20090311140219.GA1475@console-pimps.org>
References: <200903111428.39831.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903111428.39831.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 02:28:39PM +0100, Wolfgang Mües wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> o Some SD cards have very high timeouts in SPI mode.
>   So adjust the timeouts from theory to practice.
> 

[...]

> +	/*
> +	 * Some cards need very high timeouts if driven in SPI mode.
> +	 * The worst observed timeout was 900ms after writing a
> +	 * continuous stream of data until the internal logic
> +	 * overflowed.
> +	 */
> +	if (mmc_host_is_spi(card->host)) {
> +		if (data->flags & MMC_DATA_WRITE) {
> +			if (data->timeout_ns < 1000000000)
> +				data->timeout_ns = 1000000000;	/* 1s */

I am correct in thinking that this patch, in conjuction with your other
patch, "[PATCH 6/7] mmc_spi: convert timeout handling to jiffies and avoid 
busy waiting", will now penalize my working card and mandate a timeout
of 1 second?

Without your patch 6 at least mmc_spi_skip() would busy-wait for the
response, and if my card completed in less than 1 second then it'd just
return quicker.

It seems you've introduced a performance hit on all MMC over SPI cards.
