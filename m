Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZALWRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZALWRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbZALWQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:16:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbZALWQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:16:47 -0500
Date: Mon, 12 Jan 2009 23:12:02 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@kernel.org
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: u.kleine-koenig@pengutronix.de
Subject: platform_driver's probe functions must not be located in .init.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Message-Id: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org>

Hello,

if the probe function of a platform_driver lives in .init.text (i.e. is
defined using __init) registering a device after the .init sections are
discarded results in an oops.  You can test that by doing

	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/unbind
	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/bind

As a reply to this mail I send 62 patches that fix this kind of error by
moving the respective probe functions to .devinit.text.

This should be safe in general as it only increases the lifetime for the
respective functions.

The alternative is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.  But I choosed changing the section as
this is less intrusive though probably the latter would be the better
fix because it saves some memory.

You cannot blindly change to use platform_driver_probe because if the
devices are only registered after that call (but while .init is still
valid) the driver is already gone.  This is hardly checkable for me
because I don't have the hardware for most drivers I fixed.

Shortlog and diffstat are below.  You can fetch this series from

	git://git.pengutronix.de/git/ukl/linux-2.6.git platsection-master

based on v2.6.29-rc1.

Best regards
Uwe

Uwe Kleine-König (62):
      move acornfb's probe function to .devinit.text
      move am79c961's probe function to .devinit.text
      move arcfb's probe function to .devinit.text
      move at91_ether's probe function to .devinit.text
      move at91_wdt's probe function to .devinit.text
      move bf54x-lq043's probe function to .devinit.text
      move bfin-t350mcqb's probe function to .devinit.text
      move cfag12864bfb's probe function to .devinit.text
      move leds-clevo-mail's probe function to .devinit.text
      move cobalt-lcd's probe function to .devinit.text
      move corgi-keyboard's probe function to .devinit.text
      move corgi-ssp's probe function to .devinit.text
      move corgi-ts's probe function to .devinit.text
      move efifb's probe function to .devinit.text
      move orion-ehci's probe function to .devinit.text
      move epson1355fb's probe function to .devinit.text
      move sh_flctl's probe function to .devinit.text
      move gbefb's probe function to .devinit.text
      move h1940-bt's probe function to .devinit.text
      move h1940-leds's probe function to .devinit.text
      move hgafb's probe function to .devinit.text
      move hitfb's probe function to .devinit.text
      move hp680-bl's probe function to .devinit.text
      move hp-wmi's probe function to .devinit.text
      move jazzsonic's probe function to .devinit.text
      move jornada_ssp's probe function to .devinit.text
      move ks8695_wdt's probe function to .devinit.text
      move macsonic's probe function to .devinit.text
      move meth's probe function to .devinit.text
      move mmci-omap's probe function to .devinit.text
      move mailbox's probe function to .devinit.text
      move omap24xxcam's probe function to .devinit.text
      move mailbox's probe function to .devinit.text
      move omap_hdq's probe function to .devinit.text
      move omap-keypad's probe function to .devinit.text
      move omap_rng's probe function to .devinit.text
      move omap_wdt's probe function to .devinit.text
      move orion_nand's probe function to .devinit.text
      move gen_nand's probe function to .devinit.text
      move q40fb's probe function to .devinit.text
      move r8a66597_hcd's probe function to .devinit.text
      move s3c241xfb's probe function to .devinit.text
      move sa11x0-fb's probe function to .devinit.text
      move flash's probe function to .devinit.text
      move sb1250-mac's probe function to .devinit.text
      move sgiseeq's probe function to .devinit.text
      move sgivwfb's probe function to .devinit.text
      move sgiwd93's probe function to .devinit.text
      move sharpsl-pm's probe function to .devinit.text
      move sh_mobile_lcdc_fb's probe function to .devinit.text
      move snd_powermac's probe function to .devinit.text
      move snirm_53c710's probe function to .devinit.text
      move spitz-keyboard's probe function to .devinit.text
      move stk17ta8's probe function to .devinit.text
      move omap_udc's probe function to .devinit.text
      move vesafb's probe function to .devinit.text
      move vfb's probe function to .devinit.text
      move vga16fb's probe function to .devinit.text
      move w100fb's probe function to .devinit.text
      move wm8400-regulator's probe function to .devinit.text
      move xilinx_spi's probe function to .devinit.text
      move xtsonic's probe function to .devinit.text

 arch/arm/common/sharpsl_pm.c            |    2 +-
 arch/arm/mach-omap1/mailbox.c           |    2 +-
 arch/arm/mach-omap2/mailbox.c           |    2 +-
 arch/arm/mach-pxa/corgi_ssp.c           |    2 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c   |    2 +-
 drivers/auxdisplay/cfag12864bfb.c       |    2 +-
 drivers/char/hw_random/omap-rng.c       |    2 +-
 drivers/input/keyboard/corgikbd.c       |    2 +-
 drivers/input/keyboard/omap-keypad.c    |    2 +-
 drivers/input/keyboard/spitzkbd.c       |    2 +-
 drivers/input/touchscreen/corgi_ts.c    |    2 +-
 drivers/leds/leds-clevo-mail.c          |    2 +-
 drivers/leds/leds-h1940.c               |    2 +-
 drivers/media/video/omap24xxcam.c       |    2 +-
 drivers/mmc/host/omap.c                 |    2 +-
 drivers/mtd/maps/sa1100-flash.c         |    2 +-
 drivers/mtd/nand/orion_nand.c           |    2 +-
 drivers/mtd/nand/plat_nand.c            |    2 +-
 drivers/mtd/nand/sh_flctl.c             |    2 +-
 drivers/net/arm/am79c961a.c             |    2 +-
 drivers/net/arm/at91_ether.c            |    2 +-
 drivers/net/jazzsonic.c                 |    2 +-
 drivers/net/macsonic.c                  |    2 +-
 drivers/net/meth.c                      |    2 +-
 drivers/net/sb1250-mac.c                |    2 +-
 drivers/net/sgiseeq.c                   |    2 +-
 drivers/net/xtsonic.c                   |    2 +-
 drivers/platform/x86/hp-wmi.c           |    4 ++--
 drivers/regulator/wm8400-regulator.c    |    2 +-
 drivers/rtc/rtc-stk17ta8.c              |    2 +-
 drivers/scsi/sgiwd93.c                  |    2 +-
 drivers/scsi/sni_53c710.c               |    2 +-
 drivers/spi/xilinx_spi.c                |    2 +-
 drivers/usb/gadget/omap_udc.c           |    2 +-
 drivers/usb/host/ehci-orion.c           |    2 +-
 drivers/usb/host/r8a66597-hcd.c         |    2 +-
 drivers/video/acornfb.c                 |    2 +-
 drivers/video/arcfb.c                   |    2 +-
 drivers/video/backlight/hp680_bl.c      |    2 +-
 drivers/video/bf54x-lq043fb.c           |    2 +-
 drivers/video/bfin-t350mcqb-fb.c        |    2 +-
 drivers/video/cobalt_lcdfb.c            |    2 +-
 drivers/video/efifb.c                   |    2 +-
 drivers/video/epson1355fb.c             |    2 +-
 drivers/video/gbefb.c                   |    2 +-
 drivers/video/hgafb.c                   |    2 +-
 drivers/video/hitfb.c                   |    2 +-
 drivers/video/q40fb.c                   |    2 +-
 drivers/video/s3c2410fb.c               |    4 ++--
 drivers/video/sa1100fb.c                |    2 +-
 drivers/video/sgivwfb.c                 |    2 +-
 drivers/video/sh_mobile_lcdcfb.c        |    2 +-
 drivers/video/vesafb.c                  |    2 +-
 drivers/video/vfb.c                     |    2 +-
 drivers/video/vga16fb.c                 |    2 +-
 drivers/video/w100fb.c                  |    2 +-
 drivers/w1/masters/omap_hdq.c           |    4 ++--
 drivers/watchdog/at91rm9200_wdt.c       |    2 +-
 drivers/watchdog/ks8695_wdt.c           |    2 +-
 drivers/watchdog/omap_wdt.c             |    2 +-
 sound/ppc/powermac.c                    |    2 +-
 62 files changed, 65 insertions(+), 65 deletions(-)
