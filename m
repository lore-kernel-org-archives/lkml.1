Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZF0BEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZF0BEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 21:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZF0BEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 21:04:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37700 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZF0BEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 21:04:40 -0400
Date: Sat, 27 Jun 2009 02:04:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.y.miao@gmail.com>, David Brownell <david-b@pacbell.net>,
       Pierre Ossman <pierre@ossman.eu>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Message-ID: <20090627010434.GC4379@sirena.org.uk>
References: <1246057721.10360.318.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246057721.10360.318.camel@brutus>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/2] PCAP regulator driver (for 2.6.32)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 08:08:41PM -0300, Daniel Ribeiro wrote:
> Changed: Removed workaround for regulator use_count issues.

The usual place for these comments is after the --- with the diffstat
(the tools can then deal automatically with them).  Incidentally, the
code you had would only help pxamci with this particular regulator
driver.

> Add (partial) support for the voltage regulators on the PCAP2 PMIC.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

Sorry, I've noticed a race condition below that I didn't spot first time
round below:

> +static int pcap_regulator_set_voltage(struct regulator_dev *rdev,
> +						int min_uV, int max_uV)
> +{
> +	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
> +	void *pcap = rdev_get_drvdata(rdev);
> +	int uV;
> +	u32 tmp;
> +	u8 i;
> +
> +	if (vreg->n_voltages == 1)
> +		return -EINVAL;

It'd be a little more friendly to check if the supported voltage is in
the requested range.  However, that'd only be an issue if constraints
allowed voltage changes which is obviously broken so a comment to that
effect would be enough.  I wouldn't have mentioned it but...

> +{
> +	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
> +	void *pcap = rdev_get_drvdata(rdev);
> +	u32 tmp;
> +
> +	if (vreg->en == NA)
> +		return -EINVAL;
> +
> +	ezx_pcap_read(pcap, vreg->reg, &tmp);
> +	tmp |= (1 << vreg->en);
> +	ezx_pcap_write(pcap, vreg->reg, tmp);

This read/modify/write cycle is racy; the individual regulator is locked
by the core but this register is shared between all regulators on the
chip so if two are being updated at once things will go wrong.  Most of
the MFDs have a set_bits() function that does an atomic read/modify/write
cycle for cases like this.
