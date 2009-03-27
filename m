Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZC0XWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZC0XWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZC0XV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:21:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZC0XV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:21:58 -0400
Date: Sat, 28 Mar 2009 00:21:53 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [RESENT] platform_driver's probe functions must not be located in
	.init.text
Message-ID: <20090327232153.GA16348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[A very similar series was already posted in January this year, but only
a few patches made it into Linus' tree.  I updated my patches to Linus'
current master and added a few new fixes.  See

http://thread.gmane.org/gmane.linux.kernel/779532

for the old version.  Now I made the effort to find out people to Cc:
for each patch, so I hope to get more patches in this time.]

if the probe function of a platform_driver lives in .init.text (i.e. is
defined using __init) registering a device after the .init sections are
discarded results in an oops.  You can test that by doing

	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/unbind
	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/bind

As a reply to this mail I send 58 patches that fix this kind of error by
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

based on v2.6.29-3321-gbe0ea69.

Best regards
Uwe

Uwe Kleine-König (58):
      move acornfb's probe function to .devinit.text
      move am79c961's probe function to .devinit.text
      move arcfb's probe function to .devinit.text
      move at91_ether's probe function to .devinit.text
      move at91_wdt's probe function to .devinit.text
      move bf54x-lq043's probe function to .devinit.text
      move cfag12864bfb's probe function to .devinit.text
      move leds-clevo-mail's probe function to .devinit.text
      move cobalt-lcd's probe function to .devinit.text
      move corgi-ssp's probe function to .devinit.text
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
      move i2c_omap's probe function to .devinit.text
      move mmci-omap-hs's probe function to .devinit.text
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
      move stk17ta8's probe function to .devinit.text
      move twl4030_usb's probe function to .devinit.text
      move omap_udc's probe function to .devinit.text
      move vesafb's probe function to .devinit.text
      move vfb's probe function to .devinit.text
      move vga16fb's probe function to .devinit.text
      move w100fb's probe function to .devinit.text
      move xtsonic's probe function to .devinit.text

 arch/arm/common/sharpsl_pm.c            |    2 +-
 arch/arm/mach-omap1/mailbox.c           |    2 +-
 arch/arm/mach-omap2/mailbox.c           |    2 +-
 arch/arm/mach-pxa/corgi_ssp.c           |    2 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c   |    2 +-
 drivers/auxdisplay/cfag12864bfb.c       |    2 +-
 drivers/char/hw_random/omap-rng.c       |    2 +-
 drivers/i2c/busses/i2c-omap.c           |    2 +-
 drivers/leds/leds-clevo-mail.c          |    2 +-
 drivers/leds/leds-h1940.c               |    2 +-
 drivers/media/video/omap24xxcam.c       |    2 +-
 drivers/mmc/host/omap.c                 |    2 +-
 drivers/mmc/host/omap_hsmmc.c           |    2 +-
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
 drivers/rtc/rtc-stk17ta8.c              |    2 +-
 drivers/scsi/sgiwd93.c                  |    2 +-
 drivers/scsi/sni_53c710.c               |    2 +-
 drivers/usb/gadget/omap_udc.c           |    2 +-
 drivers/usb/host/ehci-orion.c           |    2 +-
 drivers/usb/host/r8a66597-hcd.c         |    2 +-
 drivers/usb/otg/twl4030-usb.c           |    2 +-
 drivers/video/acornfb.c                 |    2 +-
 drivers/video/arcfb.c                   |    2 +-
 drivers/video/backlight/hp680_bl.c      |    2 +-
 drivers/video/bf54x-lq043fb.c           |    2 +-
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
 58 files changed, 61 insertions(+), 61 deletions(-)

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
