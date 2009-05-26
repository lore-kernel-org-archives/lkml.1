Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZEZUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZEZUnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZEZUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:43:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35261 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZEZUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:43:08 -0400
Date: Tue, 26 May 2009 21:43:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20090526204302.GB4951@sirena.org.uk>
References: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
X-Cookie: Biggest security gap -- an open mouth.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator/max1586: support increased V3 voltage range
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 09:39:08PM +0200, Philipp Zabel wrote:

Please don't use my @wolfsonmicro.com address for anything kernel
related - use @opensource.wolfsonmicro.com or @sirena.org.uk.

> -#define MAX1586_V3_MIN_UV   700000
> -#define MAX1586_V3_MAX_UV  1475000
> -#define MAX1586_V3_STEP_UV   25000

I don't see these values being re-added elsewhere in the code?

> +	selector = (min_uV - max1586->min_uV) * 31 / range_uV;
> +	if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
>  		return -EINVAL;

Might be nice to have a #define for the 31 but then it's the only
reference to it.

>  	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>  		       GFP_KERNEL);
>  	if (!rdev)
> -		return -ENOMEM;
> +		goto out;
> +
> +	max1586 = kzalloc(sizeof(struct max1586_data *), GFP_KERNEL);
> +	if (!max1586)
> +		goto out_unmap;

Could perhaps make these one struct?  But either way is fine.

> +       switch (pdata->r24) {
> +       case MAX1586_R24_3k32:

This switch statement doesn't reject invalid values which I'd expect it
to and...

> + * @r24: external regulator to increase V3 range
> + *       (0, MAX1586_R24_3k32, MAX1586_R24_5k11 or MAX1586_R24_7k5)

...I think I'd be more comfortable if an explicit configuration were
required for the no feedback case since otherwise the driver will
happily start up and begin producing the wrong output voltages by
default on platforms which have this feedback resistor fitted.  This
could make the system non-obviously unstable and in the worst case
possibly lead to long term hardware damage if something is consistently
driven over voltage.
