Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbZD0VNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbZD0VNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZD0VM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:12:56 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:44677 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZD0VMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:12:55 -0400
To: eric.miao@marvell.com
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: Patch to add mioa701 glue for voltage regulation
References: <87iqkvp6i3.fsf@free.fr>
	<1240566136.27410.3291.camel@vega.slimlogic.co.uk>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 27 Apr 2009 23:11:28 +0200
In-Reply-To: <1240566136.27410.3291.camel@vega.slimlogic.co.uk> (Liam Girdwood's message of "Fri\, 24 Apr 2009 10\:42\:16 +0100")
Message-ID: <87d4ax7qf3.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood <lrg@slimlogic.co.uk> writes:

> On Thu, 2009-04-23 at 20:30 +0200, Robert Jarzmik wrote:
>> Hi Mark and Eric,
>> 
>> I have that patch which adds voltage regulation definitions to mioa701
>> board. The trick is, this patch depends on two others :
>> 
>>  - one which will be merged through Mark's regulator tree.
>>    This one is mandatory as a compiling dependency exists through include files.
>> 
>>  - one which will be merge through Eric pxa tree.
>>    This is the cpufreq one, and has a "very weak" dependency, as only the
>>    "vcc_core" name _is_ the dependency.
>> 
>> I think the easiest way to solve the compiling dependency
>> (include/linux/regulator.max1586.h) is to make that patch go through regulator
>> tree as well for linux-next, even if it's arm machine specific, don't you ?
>> 
>
> If fine with this going through regulator providing I get an ACK from
> Eric.

Eric,

Since Liam took the max1586 regulator through his tree, would you state if you
ack that please ?

Cheers.

--
Robert

From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 20 Apr 2009 16:52:25 +0200
Subject: [PATCH] mioa701: add Maxim 1586 voltage regulator

On this board, the PXA272 CPU voltage VCC_CORE is provided
by a Maxim 1586 voltage regulator. Use the regulator
framework to provide VCC_CORE control. When cpufreq will be
updated to ask for vcc_core, this will optimize power
drained by the board.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/mioa701.c |   52 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 204263d..facff90 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -37,6 +37,7 @@
 #include <linux/wm97xx_batt.h>
 #include <linux/mtd/physmap.h>
 #include <linux/usb/gpio_vbus.h>
+#include <linux/regulator/max1586.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -716,6 +717,48 @@ static struct wm97xx_batt_info mioa701_battery_data = {
 };
 
 /*
+ * Voltage regulation
+ */
+static struct regulator_consumer_supply max1586_consumers[] = {
+	{
+		.supply = "vcc_core",
+	}
+};
+
+static struct regulator_init_data max1586_v3_info = {
+	.constraints = {
+		.name = "vcc_core range",
+		.min_uV = 1000000,
+		.max_uV = 1705000,
+		.always_on = 1,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(max1586_consumers),
+	.consumer_supplies = max1586_consumers,
+};
+
+static struct regulator_init_data max1586_v6_info = {
+	.constraints = {
+		.name = "vcc_usim range",
+		.min_uV = 1,
+		.max_uV = 3000000,
+		.always_on = 1,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	},
+	.num_consumer_supplies = 0,
+};
+
+static struct max1586_subdev_data max1586_subdevs[] = {
+	{ .name = "vcc_core", .id = MAX1586_V3,
+	  .platform_data = &max1586_v3_info },
+};
+
+static struct max1586_platform_data max1586_info = {
+	.subdevs = max1586_subdevs,
+	.num_subdevs = ARRAY_SIZE(max1586_subdevs),
+};
+
+/*
  * Camera interface
  */
 struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
@@ -733,6 +776,13 @@ static struct i2c_board_info __initdata mioa701_i2c_devices[] = {
 	},
 };
 
+static struct i2c_board_info __initdata mioa701_pi2c_devices[] = {
+	{
+		I2C_BOARD_INFO("max1586", 0x14),
+		.platform_data = &max1586_info,
+	},
+};
+
 static struct soc_camera_link iclink = {
 	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
 	.board_info	= &mioa701_i2c_devices[0],
@@ -827,7 +877,9 @@ static void __init mioa701_machine_init(void)
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 	gsm_init();
 
+	i2c_register_board_info(1, ARRAY_AND_SIZE(mioa701_pi2c_devices));
 	pxa_set_i2c_info(&i2c_pdata);
+	pxa27x_set_i2c_power_info(NULL);
 	pxa_set_camera_info(&mioa701_pxacamera_platform_data);
 }
 
-- 
1.6.2.1
