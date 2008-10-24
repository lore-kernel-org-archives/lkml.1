Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYJXQXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYJXQXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJXQXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:23:01 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:56192 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJXQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:23:00 -0400
X-Greylist: delayed 2146 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 12:23:00 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4901EE0F.5000508@cam.ac.uk>
Date: Fri, 24 Oct 2008 16:47:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Da903x regulator driver. Bug?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, is lkml the right place to ask questions about regulator drivers?

Secondly, though I can't track down any examples, I'm guessing the following
is a valid board config for the da903x reg etc.

static struct regulator_init_data stargate2_ld8_init_data = {
	.supply_regulator_dev = NULL,
	.constraints = {
		.name = "vdd_mica",
		.min_uV = 1800000,
		.max_uV = 1900000,
		.valid_modes_mask = REGULATOR_CHANGE_VOLTAGE,
	},
};

/* playing with this ld0 as it only goes to an external connector */
static struct da903x_subdev_info stargate2_da9030_subdevs[] = {
	{
		.name = "da903x-regulator",
		.id = DA9030_ID_LDO8,
		.platform_data = &stargate2_ld8_init_data,
	},
};

static struct da903x_platform_data stargate2_da9030_pdata = {
	.num_subdevs = ARRAY_SIZE(stargate2_da9030_subdevs),
	.subdevs = stargate2_da9030_subdevs,
};
static struct i2c_board_info __initdata stargate2_pwr_i2c_board_info [] = {
	{
		.type = "da9030",
		.addr = 0x49,
		.platform_data = &stargate2_da9030_pdata,
		.irq = gpio_to_irq(1),
	},
};

// and relevant registration code.


Now if this is now things are expected to be, there is a bug in
regulators/da903x.c in da903x_regulator_probe

rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);

should be

rdev = regulator_register(&ri->desc, &pdev->dev, ri);

or else you aren't going to get the constraint.  I think the
first will give you the device of the mfd, not the regulator.

Thanks,

Jonathan
