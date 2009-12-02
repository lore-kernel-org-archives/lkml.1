Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZLBAxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZLBAxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZLBAxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:53:30 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:53300 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754923AbZLBAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:53:29 -0500
Message-ID: <4B15BAA1.2010408@bluewatersys.com>
Date: Wed, 02 Dec 2009 13:53:53 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx
 CPUs
References: <200911261651.40928.bzolnier@gmail.com>
In-Reply-To: <200911261651.40928.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Based on the older IDE host driver by Joao Ramos and review comments
> for it from Sergei Shtylyov.  Not yet tested with the real hardware.
>

Hi Bartlomiej,

I have got as far as patching this into my kernel and doing a build test
(still need to find a hard-disk to test). I got some build errors, see
below:

> +static void pata_ep93xx_set_piomode(struct ata_port *ap,
> +				    struct ata_device *adev)
> +{
> +	void __iomem *base = ap->host->private_data;
> +	struct ata_device *pair = ata_dev_pair(adev);
> +	const struct ata_timing *t = ata_timing_find_mode(adev->pio_mode);
> +	const struct ata_timing *cmd_t = t;
> +	u32 reg = IDECFG_IDEEN | IDECFG_PIO;
> +	u8 pio = adev->pio_mode - XFER_PIO_0;
> +
> +	if (pair && pair->pio_mode < adev->pio_mode)
> +		cmd_t = ata_timing_find_mode(pair->pio_mode);
> +
> +	/*
> +	 * store the adequate PIO mode timings, to be used later
> +	 * by pata_ep93xx_{read,write}
> +	 */
> +	adev->private_data = (void *)t;
> +	ap->private_data = (void *)cmd_t;

struct ata_device has no member called private_data. Do we need to store
both t and cmd_t, or can we just store cmd_t in ap->private_data?

If we need both, can we have something like this (not sure if the member
names are sensible):

	struct ep93xx_ata_timing {
		struct ata_timing *dev_timing;
		struct ata_timing *pair_timing;
	};

and store that struct in ap?

> +unsigned int pata_ep93xx_data_xfer(struct ata_device *adev, unsigned char *buf,
> +				   unsigned int buflen, int rw)
> +{
> +	struct ata_port *ap = adev->link->ap;
> +	void __iomem *base = ap->host->private_data;
> +	void *data_addr = ap->ioaddr.data_addr;
> +	u16 *data = (u16 *)buf;
> +	struct ata_timing *t = adev->private_data;

This is the only place that uses the ata_timing structure stored in
adev->private_data, can this be changed to:

	struct ata_timing *t = ap->private_data;

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
