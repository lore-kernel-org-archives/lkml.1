Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYJXRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYJXRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYJXRXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:23:37 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:56177 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYJXRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:23:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <490204A3.6010505@gmail.com>
Date: Fri, 24 Oct 2008 18:23:47 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: Da903x regulator driver. Bug?
References: <4901EE0F.5000508@cam.ac.uk>
In-Reply-To: <4901EE0F.5000508@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> Firstly, is lkml the right place to ask questions about regulator drivers?
>
> Secondly, though I can't track down any examples, I'm guessing the following
> is a valid board config for the da903x reg etc.
>
> static struct regulator_init_data stargate2_ld8_init_data = {
> 	.supply_regulator_dev = NULL,
> 	.constraints = {
> 		.name = "vdd_mica",
> 		.min_uV = 1800000,
> 		.max_uV = 1900000,
> 		.valid_modes_mask = REGULATOR_CHANGE_VOLTAGE,
> 	},
> };
>
> /* playing with this ld0 as it only goes to an external connector */
> static struct da903x_subdev_info stargate2_da9030_subdevs[] = {
> 	{
> 		.name = "da903x-regulator",
> 		.id = DA9030_ID_LDO8,
> 		.platform_data = &stargate2_ld8_init_data,
> 	},
> };
>
> static struct da903x_platform_data stargate2_da9030_pdata = {
> 	.num_subdevs = ARRAY_SIZE(stargate2_da9030_subdevs),
> 	.subdevs = stargate2_da9030_subdevs,
> };
> static struct i2c_board_info __initdata stargate2_pwr_i2c_board_info [] = {
> 	{
> 		.type = "da9030",
> 		.addr = 0x49,
> 		.platform_data = &stargate2_da9030_pdata,
> 		.irq = gpio_to_irq(1),
> 	},
> };
>
> // and relevant registration code.
>
>
> Now if this is now things are expected to be, there is a bug in
> regulators/da903x.c in da903x_regulator_probe
>
> rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);
>
> should be
>
> rdev = regulator_register(&ri->desc, &pdev->dev, ri);
>
>   
Unfortunately this fix causes other issues as now the i2c_client
is 2 layers down rather than one requiring quite a few changes
to   
 struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
from
    struct device *da9034_dev = rdev_get_dev(rdev)->parent;

So either a change to the regulator framework is needed to
allow mfd's or these extra ->parent lines need to go in in lots
of places.

Which do people prefer?

Jonathan
