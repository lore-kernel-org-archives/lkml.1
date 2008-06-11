Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYFKDMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYFKDMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYFKDMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:12:13 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:38936 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754751AbYFKDMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:12:10 -0400
Message-ID: <484F42AC.9030709@bluewatersys.com>
Date: Wed, 11 Jun 2008 15:12:44 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<20080609135739.GE30971@flint.arm.linux.org.uk>	<484D947D.1090900@bluewatersys.com>	<200806091359.12791.david-b@pacbell.net>	<484DA046.4010804@bluewatersys.com> <20080610085708.12c2d2a2@hyperion.delvare>
In-Reply-To: <20080610085708.12c2d2a2@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 10 Jun 2008 09:27:34 +1200, Ryan Mallon wrote:
>   
>> David Brownell wrote:
>>     
>>> On Monday 09 June 2008, Ryan Mallon wrote:
>>>   
>>>       
>>>>> Talk to i2c and framebuffer people about changing the link order.
>>>>>
>>>>> i2c should really be initialised before framebuffer devices because
>>>>> framebuffer devices tend to want to read DDC from monitors, which is
>>>>> basically a I2C EEPROM in the monitor.
>>>>>           
>
> This is already the case. i2c-core is initialized with
> subsys_initcall(), so it's available to all drivers initialized with
> module_init().
>
>   
>>>>> ... but there's probably some reason why it's done the way it is today,
>>>>> and changing it could well cause stuff to break.
>>>>>       
>>>>>           
>>>> We have made i2c the first driver subsystem to come up in our 2.6.20
>>>> kernel since we use i2c io expanders for power domain control. All we
>>>> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is at
>>>> the very top of the file. We didn't have any problems with doing this.
>>>> YMMV of course.
>>>>         
>
> Why don't you simply initialize the drivers in question with
> subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> tps65010 are doing at the moment.
>   
I still think its a bit nasty marking a driver as subsys_initcall 
just because one particular setup needs it to be that way. We will
eventually end up with half of the busses/drivers in i2c marked
as subsys_initcall for random boards :-).

How about this patch instead, which replaces module_init and 
subsys_initcalls in drivers/i2c with a new macro called
i2c_module_init. If CONFIG_I2C_EARLY is set then it will #define
to subsys_initcall, otherwise it becomes module_init. This way
boards that need i2c early can just select CONFIG_I2C_EARLY and
get all of i2c at subsys_initcall time. The link order should
guarantee that everything still comes up in the correct order in
the i2c driver subsystem.

I have tested this on an ARM ep93xx board with a bit-bashed
i2c bus, a ds1339 rtc, and two max7311 IO expanders (using 
the pca953x) both with and without CONFIG_I2C_EARLY_INIT selected.
Of course it would need much more testing to verify it :-)

~Ryan

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

 drivers/i2c/Kconfig                    |    3 +++
 drivers/i2c/busses/i2c-acorn.c         |    2 +-
 drivers/i2c/busses/i2c-ali1535.c       |    2 +-
 drivers/i2c/busses/i2c-ali1563.c       |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c       |    2 +-
 drivers/i2c/busses/i2c-amd756-s4882.c  |    2 +-
 drivers/i2c/busses/i2c-amd756.c        |    2 +-
 drivers/i2c/busses/i2c-amd8111.c       |    2 +-
 drivers/i2c/busses/i2c-at91.c          |    2 +-
 drivers/i2c/busses/i2c-au1550.c        |    2 +-
 drivers/i2c/busses/i2c-bfin-twi.c      |    2 +-
 drivers/i2c/busses/i2c-davinci.c       |    2 +-
 drivers/i2c/busses/i2c-elektor.c       |    2 +-
 drivers/i2c/busses/i2c-gpio.c          |    2 +-
 drivers/i2c/busses/i2c-hydra.c         |    2 +-
 drivers/i2c/busses/i2c-i801.c          |    2 +-
 drivers/i2c/busses/i2c-i810.c          |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c       |    2 +-
 drivers/i2c/busses/i2c-iop3xx.c        |    2 +-
 drivers/i2c/busses/i2c-ixp2000.c       |    2 +-
 drivers/i2c/busses/i2c-mpc.c           |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c       |    2 +-
 drivers/i2c/busses/i2c-nforce2.c       |    2 +-
 drivers/i2c/busses/i2c-ocores.c        |    2 +-
 drivers/i2c/busses/i2c-omap.c          |    2 +-
 drivers/i2c/busses/i2c-parport-light.c |    2 +-
 drivers/i2c/busses/i2c-parport.c       |    2 +-
 drivers/i2c/busses/i2c-pasemi.c        |    2 +-
 drivers/i2c/busses/i2c-pca-isa.c       |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c  |    2 +-
 drivers/i2c/busses/i2c-piix4.c         |    2 +-
 drivers/i2c/busses/i2c-pmcmsp.c        |    2 +-
 drivers/i2c/busses/i2c-pnx.c           |    2 +-
 drivers/i2c/busses/i2c-powermac.c      |    2 +-
 drivers/i2c/busses/i2c-prosavage.c     |    2 +-
 drivers/i2c/busses/i2c-pxa.c           |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c       |    2 +-
 drivers/i2c/busses/i2c-savage4.c       |    2 +-
 drivers/i2c/busses/i2c-sh7760.c        |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c     |    2 +-
 drivers/i2c/busses/i2c-sibyte.c        |    2 +-
 drivers/i2c/busses/i2c-simtec.c        |    2 +-
 drivers/i2c/busses/i2c-sis5595.c       |    2 +-
 drivers/i2c/busses/i2c-sis630.c        |    2 +-
 drivers/i2c/busses/i2c-sis96x.c        |    2 +-
 drivers/i2c/busses/i2c-stub.c          |    2 +-
 drivers/i2c/busses/i2c-taos-evm.c      |    2 +-
 drivers/i2c/busses/i2c-tiny-usb.c      |    2 +-
 drivers/i2c/busses/i2c-versatile.c     |    2 +-
 drivers/i2c/busses/i2c-via.c           |    2 +-
 drivers/i2c/busses/i2c-viapro.c        |    2 +-
 drivers/i2c/busses/i2c-voodoo3.c       |    2 +-
 drivers/i2c/busses/scx200_acb.c        |    2 +-
 drivers/i2c/busses/scx200_i2c.c        |    2 +-
 drivers/i2c/chips/ds1682.c             |    2 +-
 drivers/i2c/chips/eeprom.c             |    2 +-
 drivers/i2c/chips/isp1301_omap.c       |    2 +-
 drivers/i2c/chips/max6875.c            |    2 +-
 drivers/i2c/chips/menelaus.c           |    2 +-
 drivers/i2c/chips/pca9539.c            |    2 +-
 drivers/i2c/chips/pcf8574.c            |    2 +-
 drivers/i2c/chips/pcf8575.c            |    2 +-
 drivers/i2c/chips/pcf8591.c            |    2 +-
 drivers/i2c/chips/tps65010.c           |    2 +-
 drivers/i2c/chips/tsl2550.c            |    2 +-
 drivers/i2c/i2c-dev.c                  |    2 +-
 include/linux/i2c.h                    |    6 ++++++
 67 files changed, 74 insertions(+), 65 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 9686734..ab54207 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -23,6 +23,9 @@ menuconfig I2C
 
 if I2C
 
+config I2C_EARLY_INIT
+	boolean
+
 config I2C_BOARDINFO
 	boolean
 	default y
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index 7c2be35..fc4f941 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -94,4 +94,4 @@ static int __init i2c_ioc_init(void)
 	return i2c_bit_add_bus(&ioc_ops);
 }
 
-module_init(i2c_ioc_init);
+i2c_module_init(i2c_ioc_init);
diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
index f14372a..ae8e3e3 100644
--- a/drivers/i2c/busses/i2c-ali1535.c
+++ b/drivers/i2c/busses/i2c-ali1535.c
@@ -532,5 +532,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 MODULE_DESCRIPTION("ALI1535 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_ali1535_init);
+i2c_module_init(i2c_ali1535_init);
 module_exit(i2c_ali1535_exit);
diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index 6b68074..0cd833b 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -421,7 +421,7 @@ static int __init ali1563_init(void)
 	return pci_register_driver(&ali1563_pci_driver);
 }
 
-module_init(ali1563_init);
+i2c_module_init(ali1563_init);
 
 static void __exit ali1563_exit(void)
 {
diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 93bf87d..be1f5ed 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -526,5 +526,5 @@ MODULE_AUTHOR ("Frodo Looijaard <frodol@dds.nl>, "
 MODULE_DESCRIPTION("ALI15X3 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_ali15x3_init);
+i2c_module_init(i2c_ali15x3_init);
 module_exit(i2c_ali15x3_exit);
diff --git a/drivers/i2c/busses/i2c-amd756-s4882.c b/drivers/i2c/busses/i2c-amd756-s4882.c
index c38a0a1..f3ec72b 100644
--- a/drivers/i2c/busses/i2c-amd756-s4882.c
+++ b/drivers/i2c/busses/i2c-amd756-s4882.c
@@ -260,5 +260,5 @@ MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("S4882 SMBus multiplexing");
 MODULE_LICENSE("GPL");
 
-module_init(amd756_s4882_init);
+i2c_module_init(amd756_s4882_init);
 module_exit(amd756_s4882_exit);
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index 43508d6..9f7e541 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -428,5 +428,5 @@ MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(amd756_smbus);
 
-module_init(amd756_init)
+i2c_module_init(amd756_init)
 module_exit(amd756_exit)
diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index 5d1a27e..7e8309a 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -416,5 +416,5 @@ static void __exit i2c_amd8111_exit(void)
 	pci_unregister_driver(&amd8111_driver);
 }
 
-module_init(i2c_amd8111_init);
+i2c_module_init(i2c_amd8111_init);
 module_exit(i2c_amd8111_exit);
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 73d6194..f4a6a3a 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -321,7 +321,7 @@ static void __exit at91_i2c_exit(void)
 	platform_driver_unregister(&at91_i2c_driver);
 }
 
-module_init(at91_i2c_init);
+i2c_module_init(at91_i2c_init);
 module_exit(at91_i2c_exit);
 
 MODULE_AUTHOR("Rick Bronson");
diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index cae9dc8..9acecc4 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -474,5 +474,5 @@ MODULE_DESCRIPTION("SMBus adapter Alchemy pb1550");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:au1xpsc_smbus");
 
-module_init (i2c_au1550_init);
+i2c_module_init (i2c_au1550_init);
 module_exit (i2c_au1550_exit);
diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 48d084b..caa8e74 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -735,7 +735,7 @@ static void __exit i2c_bfin_twi_exit(void)
 	platform_driver_unregister(&i2c_bfin_twi_driver);
 }
 
-module_init(i2c_bfin_twi_init);
+i2c_module_init(i2c_bfin_twi_init);
 module_exit(i2c_bfin_twi_exit);
 
 MODULE_AUTHOR("Bryan Wu, Sonic Zhang");
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 7ecbfc4..14ac794 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -570,7 +570,7 @@ static int __init davinci_i2c_init_driver(void)
 {
 	return platform_driver_register(&davinci_i2c_driver);
 }
-subsys_initcall(davinci_i2c_init_driver);
+i2c_module_init(davinci_i2c_init_driver);
 
 static void __exit davinci_i2c_exit_driver(void)
 {
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index b7a9977..d8efced 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -346,5 +346,5 @@ module_param(clock, int, 0);
 module_param(own, int, 0);
 module_param(mmapped, int, 0);
 
-module_init(i2c_pcfisa_init);
+i2c_module_init(i2c_pcfisa_init);
 module_exit(i2c_pcfisa_exit);
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index 7c1b762..fea7ccd 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -209,7 +209,7 @@ static int __init i2c_gpio_init(void)
 
 	return ret;
 }
-module_init(i2c_gpio_init);
+i2c_module_init(i2c_gpio_init);
 
 static void __exit i2c_gpio_exit(void)
 {
diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
index f9972f9..98a6d76 100644
--- a/drivers/i2c/busses/i2c-hydra.c
+++ b/drivers/i2c/busses/i2c-hydra.c
@@ -177,6 +177,6 @@ MODULE_AUTHOR("Geert Uytterhoeven <geert@linux-m68k.org>");
 MODULE_DESCRIPTION("i2c for Apple Hydra Mac I/O");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_hydra_init);
+i2c_module_init(i2c_hydra_init);
 module_exit(i2c_hydra_exit);
 
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index b0f771f..148391c 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -739,5 +739,5 @@ MODULE_AUTHOR("Mark D. Studebaker <mdsxyz123@yahoo.com>, "
 MODULE_DESCRIPTION("I801 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_i801_init);
+i2c_module_init(i2c_i801_init);
 module_exit(i2c_i801_exit);
diff --git a/drivers/i2c/busses/i2c-i810.c b/drivers/i2c/busses/i2c-i810.c
index 42e8d94..c14d67d 100644
--- a/drivers/i2c/busses/i2c-i810.c
+++ b/drivers/i2c/busses/i2c-i810.c
@@ -256,5 +256,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 MODULE_DESCRIPTION("I810/I815 I2C/DDC driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_i810_init);
+i2c_module_init(i2c_i810_init);
 module_exit(i2c_i810_exit);
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 85dbf34..511e9d5 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -1013,5 +1013,5 @@ static void __exit iic_exit(void)
 }
 #endif /* CONFIG_IBM_OCP */
 
-module_init(iic_init);
+i2c_module_init(iic_init);
 module_exit(iic_exit);
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 39884e7..d494417 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -544,7 +544,7 @@ i2c_iop3xx_exit (void)
 	return;
 }
 
-module_init (i2c_iop3xx_init);
+i2c_module_init (i2c_iop3xx_init);
 module_exit (i2c_iop3xx_exit);
 
 MODULE_AUTHOR("D-TACQ Solutions Ltd <www.d-tacq.com>");
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
index 5af9e65..4e549a6 100644
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ b/drivers/i2c/busses/i2c-ixp2000.c
@@ -158,7 +158,7 @@ static void __exit ixp2000_i2c_exit(void)
 	platform_driver_unregister(&ixp2000_i2c_driver);
 }
 
-module_init(ixp2000_i2c_init);
+i2c_module_init(ixp2000_i2c_init);
 module_exit(ixp2000_i2c_exit);
 
 MODULE_AUTHOR ("Deepak Saxena <dsaxena@plexity.net>");
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index a076129..34dd681 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -413,7 +413,7 @@ static void __exit fsl_i2c_exit(void)
 	platform_driver_unregister(&fsl_i2c_driver);
 }
 
-module_init(fsl_i2c_init);
+i2c_module_init(fsl_i2c_init);
 module_exit(fsl_i2c_exit);
 
 MODULE_AUTHOR("Adrian Cox <adrian@humboldt.co.uk>");
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 036e6a8..07c7047 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -597,7 +597,7 @@ mv64xxx_i2c_exit(void)
 	platform_driver_unregister(&mv64xxx_i2c_driver);
 }
 
-module_init(mv64xxx_i2c_init);
+i2c_module_init(mv64xxx_i2c_init);
 module_exit(mv64xxx_i2c_exit);
 
 MODULE_AUTHOR("Mark A. Greer <mgreer@mvista.com>");
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 43c9f8d..f927d08 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -434,6 +434,6 @@ static void __exit nforce2_exit(void)
 	pci_unregister_driver(&nforce2_driver);
 }
 
-module_init(nforce2_init);
+i2c_module_init(nforce2_init);
 module_exit(nforce2_exit);
 
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index f145692..c50f966 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -334,7 +334,7 @@ static void __exit ocores_i2c_exit(void)
 	platform_driver_unregister(&ocores_i2c_driver);
 }
 
-module_init(ocores_i2c_init);
+i2c_module_init(ocores_i2c_init);
 module_exit(ocores_i2c_exit);
 
 MODULE_AUTHOR("Peter Korsgaard <jacmet@sunsite.dk>");
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e7eb7bf..abadcbe 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -682,7 +682,7 @@ omap_i2c_init_driver(void)
 {
 	return platform_driver_register(&omap_i2c_driver);
 }
-subsys_initcall(omap_i2c_init_driver);
+i2c_module_init(omap_i2c_init_driver);
 
 static void __exit omap_i2c_exit_driver(void)
 {
diff --git a/drivers/i2c/busses/i2c-parport-light.c b/drivers/i2c/busses/i2c-parport-light.c
index c6faf9b..73e3a34 100644
--- a/drivers/i2c/busses/i2c-parport-light.c
+++ b/drivers/i2c/busses/i2c-parport-light.c
@@ -261,5 +261,5 @@ MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("I2C bus over parallel port (light)");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_parport_init);
+i2c_module_init(i2c_parport_init);
 module_exit(i2c_parport_exit);
diff --git a/drivers/i2c/busses/i2c-parport.c b/drivers/i2c/busses/i2c-parport.c
index 59ba208..1a786d0 100644
--- a/drivers/i2c/busses/i2c-parport.c
+++ b/drivers/i2c/busses/i2c-parport.c
@@ -264,5 +264,5 @@ MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("I2C bus over parallel port");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_parport_init);
+i2c_module_init(i2c_parport_init);
 module_exit(i2c_parport_exit);
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 1603c81..c50a388 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -428,5 +428,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR ("Olof Johansson <olof@lixom.net>");
 MODULE_DESCRIPTION("PA Semi PWRficient SMBus driver");
 
-module_init(pasemi_smb_init);
+i2c_module_init(pasemi_smb_init);
 module_exit(pasemi_smb_exit);
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index a119784..c8bb260 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -193,5 +193,5 @@ MODULE_PARM_DESC(irq, "IRQ");
 module_param(clock, int, 0);
 MODULE_PARM_DESC(clock, "Clock rate as described in table 1 of PCA9564 datasheet");
 
-module_init(pca_isa_init);
+i2c_module_init(pca_isa_init);
 module_exit(pca_isa_exit);
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 9d75f51..53e3f15 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -293,6 +293,6 @@ MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
 MODULE_DESCRIPTION("I2C-PCA9564 platform driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_pca_pf_init);
+i2c_module_init(i2c_pca_pf_init);
 module_exit(i2c_pca_pf_exit);
 
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index ac91659..0e89912 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -491,5 +491,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 MODULE_DESCRIPTION("PIIX4 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_piix4_init);
+i2c_module_init(i2c_piix4_init);
 module_exit(i2c_piix4_exit);
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 63b3e2c..b155077 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -652,5 +652,5 @@ static void __exit pmcmsptwi_exit(void)
 MODULE_DESCRIPTION("PMC MSP TWI/SMBus/I2C driver");
 MODULE_LICENSE("GPL");
 
-module_init(pmcmsptwi_init);
+i2c_module_init(pmcmsptwi_init);
 module_exit(pmcmsptwi_exit);
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index 1ca2108..82e86a8 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -700,5 +700,5 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pnx-i2c");
 
 /* We need to make sure I2C is initialized before USB */
-subsys_initcall(i2c_adap_pnx_init);
+i2c_module_init(i2c_adap_pnx_init);
 module_exit(i2c_adap_pnx_exit);
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 22f6d5c..a2fda94 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -287,5 +287,5 @@ static void __exit i2c_powermac_cleanup(void)
 	platform_driver_unregister(&i2c_powermac_driver);
 }
 
-module_init(i2c_powermac_init);
+i2c_module_init(i2c_powermac_init);
 module_exit(i2c_powermac_cleanup);
diff --git a/drivers/i2c/busses/i2c-prosavage.c b/drivers/i2c/busses/i2c-prosavage.c
index 07c1f1e..dd8cb43 100644
--- a/drivers/i2c/busses/i2c-prosavage.c
+++ b/drivers/i2c/busses/i2c-prosavage.c
@@ -321,5 +321,5 @@ MODULE_AUTHOR("Henk Vergonet");
 MODULE_DESCRIPTION("ProSavage VIA 8365/8375 smbus driver");
 MODULE_LICENSE("GPL");
 
-module_init (i2c_prosavage_init);
+i2c_module_init (i2c_prosavage_init);
 module_exit (i2c_prosavage_exit);
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index eb69fba..e34bf3c 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1134,5 +1134,5 @@ static void __exit i2c_adap_pxa_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pxa2xx-i2c");
 
-module_init(i2c_adap_pxa_init);
+i2c_module_init(i2c_adap_pxa_init);
 module_exit(i2c_adap_pxa_exit);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 1305ef1..a89b670 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -942,7 +942,7 @@ static void __exit i2c_adap_s3c_exit(void)
 	platform_driver_unregister(&s3c2440_i2c_driver);
 }
 
-module_init(i2c_adap_s3c_init);
+i2c_module_init(i2c_adap_s3c_init);
 module_exit(i2c_adap_s3c_exit);
 
 MODULE_DESCRIPTION("S3C24XX I2C Bus driver");
diff --git a/drivers/i2c/busses/i2c-savage4.c b/drivers/i2c/busses/i2c-savage4.c
index 8adf4ab..9e7e4c8 100644
--- a/drivers/i2c/busses/i2c-savage4.c
+++ b/drivers/i2c/busses/i2c-savage4.c
@@ -181,5 +181,5 @@ MODULE_AUTHOR("Alexander Wold <awold@bigfoot.com> "
 MODULE_DESCRIPTION("Savage4 I2C/SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_savage4_init);
+i2c_module_init(i2c_savage4_init);
 module_exit(i2c_savage4_exit);
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 5e0e254..62ed4a4 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -569,7 +569,7 @@ static void __exit sh7760_i2c_exit(void)
 	platform_driver_unregister(&sh7760_i2c_drv);
 }
 
-module_init(sh7760_i2c_init);
+i2c_module_init(sh7760_i2c_init);
 module_exit(sh7760_i2c_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index 840e634..ccf4185 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -492,7 +492,7 @@ static void __exit sh_mobile_i2c_adap_exit(void)
 	platform_driver_unregister(&sh_mobile_i2c_driver);
 }
 
-module_init(sh_mobile_i2c_adap_init);
+i2c_module_init(sh_mobile_i2c_adap_init);
 module_exit(sh_mobile_i2c_adap_exit);
 
 MODULE_DESCRIPTION("SuperH Mobile I2C Bus Controller driver");
diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
index 114634d..de68ed6 100644
--- a/drivers/i2c/busses/i2c-sibyte.c
+++ b/drivers/i2c/busses/i2c-sibyte.c
@@ -190,7 +190,7 @@ static void __exit i2c_sibyte_exit(void)
 	i2c_del_adapter(&sibyte_board_adapter[1]);
 }
 
-module_init(i2c_sibyte_init);
+i2c_module_init(i2c_sibyte_init);
 module_exit(i2c_sibyte_exit);
 
 MODULE_AUTHOR("Kip Walker (Broadcom Corp.), Steven J. Hill <sjhill@realitydiluted.com>");
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 042fda2..55f918e 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -181,7 +181,7 @@ static void __exit i2c_adap_simtec_exit(void)
 	platform_driver_unregister(&simtec_i2c_driver);
 }
 
-module_init(i2c_adap_simtec_init);
+i2c_module_init(i2c_adap_simtec_init);
 module_exit(i2c_adap_simtec_exit);
 
 MODULE_DESCRIPTION("Simtec Generic I2C Bus driver");
diff --git a/drivers/i2c/busses/i2c-sis5595.c b/drivers/i2c/busses/i2c-sis5595.c
index 9ca8f91..3d9f7fe 100644
--- a/drivers/i2c/busses/i2c-sis5595.c
+++ b/drivers/i2c/busses/i2c-sis5595.c
@@ -424,5 +424,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>");
 MODULE_DESCRIPTION("SIS5595 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_sis5595_init);
+i2c_module_init(i2c_sis5595_init);
 module_exit(i2c_sis5595_exit);
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 3765dd7..986342e 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -519,5 +519,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Malysh <amalysh@web.de>");
 MODULE_DESCRIPTION("SIS630 SMBus driver");
 
-module_init(i2c_sis630_init);
+i2c_module_init(i2c_sis630_init);
 module_exit(i2c_sis630_exit);
diff --git a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
index dc235bb..3f50c88 100644
--- a/drivers/i2c/busses/i2c-sis96x.c
+++ b/drivers/i2c/busses/i2c-sis96x.c
@@ -343,6 +343,6 @@ MODULE_DESCRIPTION("SiS96x SMBus driver");
 MODULE_LICENSE("GPL");
 
 /* Register initialization functions using helper macros */
-module_init(i2c_sis96x_init);
+i2c_module_init(i2c_sis96x_init);
 module_exit(i2c_sis96x_exit);
 
diff --git a/drivers/i2c/busses/i2c-stub.c b/drivers/i2c/busses/i2c-stub.c
index d08eeec..e68e6d8 100644
--- a/drivers/i2c/busses/i2c-stub.c
+++ b/drivers/i2c/busses/i2c-stub.c
@@ -188,6 +188,6 @@ MODULE_AUTHOR("Mark M. Hoffman <mhoffman@lightlink.com>");
 MODULE_DESCRIPTION("I2C stub driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_stub_init);
+i2c_module_init(i2c_stub_init);
 module_exit(i2c_stub_exit);
 
diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index de9db49..5b56a98 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -325,5 +325,5 @@ MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("TAOS evaluation module driver");
 MODULE_LICENSE("GPL");
 
-module_init(taos_init);
+i2c_module_init(taos_init);
 module_exit(taos_exit);
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index b1c050f..963be25 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -271,7 +271,7 @@ static void __exit usb_i2c_tiny_usb_exit(void)
 	usb_deregister(&i2c_tiny_usb_driver);
 }
 
-module_init(usb_i2c_tiny_usb_init);
+i2c_module_init(usb_i2c_tiny_usb_init);
 module_exit(usb_i2c_tiny_usb_exit);
 
 /* ----- end of usb layer ------------------------------------------------ */
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index 4678bab..9d478b9 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -146,7 +146,7 @@ static void __exit i2c_versatile_exit(void)
 	platform_driver_unregister(&i2c_versatile_driver);
 }
 
-module_init(i2c_versatile_init);
+i2c_module_init(i2c_versatile_init);
 module_exit(i2c_versatile_exit);
 
 MODULE_DESCRIPTION("ARM Versatile I2C bus driver");
diff --git a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
index 61716f6..bb064cd 100644
--- a/drivers/i2c/busses/i2c-via.c
+++ b/drivers/i2c/busses/i2c-via.c
@@ -180,5 +180,5 @@ MODULE_AUTHOR("Kyösti Mälkki <kmalkki@cc.hut.fi>");
 MODULE_DESCRIPTION("i2c for Via vt82c586b southbridge");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_vt586b_init);
+i2c_module_init(i2c_vt586b_init);
 module_exit(i2c_vt586b_exit);
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index 77b13d0..7eb9724 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -489,5 +489,5 @@ MODULE_AUTHOR("Kyosti Malkki <kmalkki@cc.hut.fi>, "
 MODULE_DESCRIPTION("vt82c596 SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_vt596_init);
+i2c_module_init(i2c_vt596_init);
 module_exit(i2c_vt596_exit);
diff --git a/drivers/i2c/busses/i2c-voodoo3.c b/drivers/i2c/busses/i2c-voodoo3.c
index 88a3447..86a0430 100644
--- a/drivers/i2c/busses/i2c-voodoo3.c
+++ b/drivers/i2c/busses/i2c-voodoo3.c
@@ -249,5 +249,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 MODULE_DESCRIPTION("Voodoo3 I2C/SMBus driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_voodoo3_init);
+i2c_module_init(i2c_voodoo3_init);
 module_exit(i2c_voodoo3_exit);
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 61abe0f..624e6b6 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -651,5 +651,5 @@ static void __exit scx200_acb_cleanup(void)
 	mutex_unlock(&scx200_acb_list_mutex);
 }
 
-module_init(scx200_acb_init);
+i2c_module_init(scx200_acb_init);
 module_exit(scx200_acb_cleanup);
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
index c3022a0..e8458ef 100644
--- a/drivers/i2c/busses/scx200_i2c.c
+++ b/drivers/i2c/busses/scx200_i2c.c
@@ -120,7 +120,7 @@ static void scx200_i2c_cleanup(void)
 	i2c_del_adapter(&scx200_i2c_ops);
 }
 
-module_init(scx200_i2c_init);
+i2c_module_init(scx200_i2c_init);
 module_exit(scx200_i2c_cleanup);
 
 /*
diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 23be4d4..cf6dd46 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -264,5 +264,5 @@ MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_DESCRIPTION("DS1682 Elapsed Time Indicator driver");
 MODULE_LICENSE("GPL");
 
-module_init(ds1682_init);
+i2c_module_init(ds1682_init);
 module_exit(ds1682_exit);
diff --git a/drivers/i2c/chips/eeprom.c b/drivers/i2c/chips/eeprom.c
index 7dee001..c04232a 100644
--- a/drivers/i2c/chips/eeprom.c
+++ b/drivers/i2c/chips/eeprom.c
@@ -266,5 +266,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 MODULE_DESCRIPTION("I2C EEPROM driver");
 MODULE_LICENSE("GPL");
 
-module_init(eeprom_init);
+i2c_module_init(eeprom_init);
 module_exit(eeprom_exit);
diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index b1b45dd..548b85b 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -1638,7 +1638,7 @@ static int __init isp_init(void)
 {
 	return i2c_add_driver(&isp1301_driver);
 }
-module_init(isp_init);
+i2c_module_init(isp_init);
 
 static void __exit isp_exit(void)
 {
diff --git a/drivers/i2c/chips/max6875.c b/drivers/i2c/chips/max6875.c
index cf507b3..9356935 100644
--- a/drivers/i2c/chips/max6875.c
+++ b/drivers/i2c/chips/max6875.c
@@ -266,5 +266,5 @@ MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("MAX6875 driver");
 MODULE_LICENSE("GPL");
 
-module_init(max6875_init);
+i2c_module_init(max6875_init);
 module_exit(max6875_exit);
diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
index b36db17..0866663 100644
--- a/drivers/i2c/chips/menelaus.c
+++ b/drivers/i2c/chips/menelaus.c
@@ -1282,5 +1282,5 @@ MODULE_AUTHOR("Texas Instruments, Inc. (and others)");
 MODULE_DESCRIPTION("I2C interface for Menelaus.");
 MODULE_LICENSE("GPL");
 
-module_init(menelaus_init);
+i2c_module_init(menelaus_init);
 module_exit(menelaus_exit);
diff --git a/drivers/i2c/chips/pca9539.c b/drivers/i2c/chips/pca9539.c
index f43c4e7..0b99b16 100644
--- a/drivers/i2c/chips/pca9539.c
+++ b/drivers/i2c/chips/pca9539.c
@@ -191,6 +191,6 @@ MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("PCA9539 driver");
 MODULE_LICENSE("GPL");
 
-module_init(pca9539_init);
+i2c_module_init(pca9539_init);
 module_exit(pca9539_exit);
 
diff --git a/drivers/i2c/chips/pcf8574.c b/drivers/i2c/chips/pcf8574.c
index e5b3132..9d52a57 100644
--- a/drivers/i2c/chips/pcf8574.c
+++ b/drivers/i2c/chips/pcf8574.c
@@ -230,5 +230,5 @@ MODULE_AUTHOR
 MODULE_DESCRIPTION("PCF8574 driver");
 MODULE_LICENSE("GPL");
 
-module_init(pcf8574_init);
+i2c_module_init(pcf8574_init);
 module_exit(pcf8574_exit);
diff --git a/drivers/i2c/chips/pcf8575.c b/drivers/i2c/chips/pcf8575.c
index 3ea08ac..36c4ebb 100644
--- a/drivers/i2c/chips/pcf8575.c
+++ b/drivers/i2c/chips/pcf8575.c
@@ -210,5 +210,5 @@ MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>, "
 MODULE_DESCRIPTION("pcf8575 driver");
 MODULE_LICENSE("GPL");
 
-module_init(pcf8575_init);
+i2c_module_init(pcf8575_init);
 module_exit(pcf8575_exit);
diff --git a/drivers/i2c/chips/pcf8591.c b/drivers/i2c/chips/pcf8591.c
index 66c7c3b..bb6713f 100644
--- a/drivers/i2c/chips/pcf8591.c
+++ b/drivers/i2c/chips/pcf8591.c
@@ -338,5 +338,5 @@ MODULE_AUTHOR("Aurelien Jarno <aurelien@aurel32.net>");
 MODULE_DESCRIPTION("PCF8591 driver");
 MODULE_LICENSE("GPL");
 
-module_init(pcf8591_init);
+i2c_module_init(pcf8591_init);
 module_exit(pcf8591_exit);
diff --git a/drivers/i2c/chips/tps65010.c b/drivers/i2c/chips/tps65010.c
index 8594968..a86a4d4 100644
--- a/drivers/i2c/chips/tps65010.c
+++ b/drivers/i2c/chips/tps65010.c
@@ -1054,7 +1054,7 @@ static int __init tps_init(void)
  * That is, much earlier than on PC-type systems, which don't often use
  * I2C as a core system bus.
  */
-subsys_initcall(tps_init);
+i2c_module_init(tps_init);
 
 static void __exit tps_exit(void)
 {
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
index 1a9cc13..7007e17 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -485,5 +485,5 @@ MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
-module_init(tsl2550_init);
+i2c_module_init(tsl2550_init);
 module_exit(tsl2550_exit);
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index d34c14c..626b7b4 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -611,5 +611,5 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 MODULE_DESCRIPTION("I2C /dev entries driver");
 MODULE_LICENSE("GPL");
 
-module_init(i2c_dev_init);
+i2c_module_init(i2c_dev_init);
 module_exit(i2c_dev_exit);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index fb9af6a..86283bb 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -556,6 +556,12 @@ union i2c_smbus_data {
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_I2C_EARLY_INIT
+#define i2c_module_init subsys_initcall
+#else
+#define i2c_module_init module_init
+#endif
+
 /* These defines are used for probing i2c client addresses */
 /* The length of the option lists */
 #define I2C_CLIENT_MAX_OPTS 48

