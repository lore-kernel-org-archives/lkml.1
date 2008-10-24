Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYJXSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYJXSxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYJXSxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:53:30 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:39953 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYJXSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:53:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <490219B1.6010502@cam.ac.uk>
Date: Fri, 24 Oct 2008 19:53:37 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Liam Girdwood <lrg@kernel.org>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: Da903x regulator driver. Bug?
References: <4901EE0F.5000508@cam.ac.uk>  <490204A3.6010505@gmail.com> <1224872665.28382.73.camel@dell-desktop.example.com>
In-Reply-To: <1224872665.28382.73.camel@dell-desktop.example.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I'm not sure if this is a valid config for this board. Eric will
> probably know for sure.  
>>> static struct regulator_init_data stargate2_ld8_init_data = {
>>> 	.supply_regulator_dev = NULL,
>>> 	.constraints = {
>>> 		.name = "vdd_mica",
>>> 		.min_uV = 1800000,
>>> 		.max_uV = 1900000,
>>> 		.valid_modes_mask = REGULATOR_CHANGE_VOLTAGE,
>>> 	},
>>> };
>>>
>>> /* playing with this ld0 as it only goes to an external connector */
>>> static struct da903x_subdev_info stargate2_da9030_subdevs[] = {
>>> 	{
>>> 		.name = "da903x-regulator",
>>> 		.id = DA9030_ID_LDO8,
>>> 		.platform_data = &stargate2_ld8_init_data,
>>> 	},
>>> };
>>>
>>> static struct da903x_platform_data stargate2_da9030_pdata = {
>>> 	.num_subdevs = ARRAY_SIZE(stargate2_da9030_subdevs),
>>> 	.subdevs = stargate2_da9030_subdevs,
>>> };
>>> static struct i2c_board_info __initdata stargate2_pwr_i2c_board_info [] = {
>>> 	{
>>> 		.type = "da9030",
>>> 		.addr = 0x49,
>>> 		.platform_data = &stargate2_da9030_pdata,
>>> 		.irq = gpio_to_irq(1),
>>> 	},
>>> };
>>>
>>> // and relevant registration code.
>>>
>>>
>>> Now if this is now things are expected to be, there is a bug in
>>> regulators/da903x.c in da903x_regulator_probe
>>>
>>> rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);
>>>
>>> should be
>>>
>>> rdev = regulator_register(&ri->desc, &pdev->dev, ri);
> 
> wm8350 and wm8400 (other mfd regulators) both register using the bottom
> case. 

Yup, guessing that the constraints stuff got added without all devices
being tested (but then this is only rc1 ;)
 
>>>   
>> Unfortunately this fix causes other issues as now the i2c_client
>> is 2 layers down rather than one requiring quite a few changes
>> to   
>>  struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>> from
>>     struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>>
>> So either a change to the regulator framework is needed to
>> allow mfd's or these extra ->parent lines need to go in in lots
>> of places.
>>
>> Which do people prefer?
>>
> 
> Could you fix in a similar method to the wm8350/wm8400. 
Based on a quick look, I think this involves carrying around
an additional copy of the device pointer inside the driver data.

If so that would indeed work.

> I would also move the da903x_regulator_info lookup into each regulator
> function, rather than at probe(). This would free up the registration
> private data. da903x_regulator_info is an array so we should be able to
> use regulator->id as the index.  
> 
Sounds sensible to me, but I'll leave decision on that for the guys who
wrote the driver.

I'm just getting my head around how the whole framework is used (have been
waiting for the da903x driver to merge for a while).

Looks very nice!

Thanks,

Jonathan
