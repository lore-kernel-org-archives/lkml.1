Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYEYTbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYEYTbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbYEYTbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:31:41 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4195 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYEYTbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:31:40 -0400
Date: Sun, 25 May 2008 21:30:51 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
       Patrick Boettcher <pb@linuxtv.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] video/dvb: fix MEDIA_TUNER && FW_LOADER build error
In-Reply-To: <20080520193409.GA14869@elte.hu>
Message-ID: <Pine.LNX.4.64.0805252117550.20021@localhost.localdomain>
References: <20080520193409.GA14869@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 20 May 2008, Ingo Molnar wrote:

> the workaround i found was to move the select of FW_LOADER one level up, 
> so that the buggy kconfig tool can notice it and can act appropriately. 
> This problem can probably be worked around in other ways as well, i went 
> for the minimal fix.
> 
> Obviously, the kconfig tool should be fixed, it is not reasonable to 
> expect driver authors to do manual dependency resolution (that kconfig 
> itself already does) and uglify the Kconfig files. The kconfig tool did 
> nothing to warn about this situation and did not prevent this faulty 
> .config from being constructed.

If you had bothered to ask me, I could have told you that the answer is 
rather simple: if you have problems with select, don't use it.
drivers/media/ is abusing select quite heavily, so it's no surprise it's 
getting out of control, the patch below gets rid of select in the tuners 
directory, others should be done in a similiar way.
One could now argue that this sort of thing could be done simpler, then 
I'll agree, but select isn't the answer.

bye, Roman

---
 drivers/media/common/tuners/Kconfig |   91 ++++++++++++++----------------------
 1 file changed, 37 insertions(+), 54 deletions(-)

Index: linux-2.6/drivers/media/common/tuners/Kconfig
===================================================================
--- linux-2.6.orig/drivers/media/common/tuners/Kconfig
+++ linux-2.6/drivers/media/common/tuners/Kconfig
@@ -17,22 +17,9 @@ config MEDIA_ATTACH
 
 	  If unsure say Y.
 
-config MEDIA_TUNER
-	tristate
-	default VIDEO_MEDIA && I2C
-	depends on VIDEO_MEDIA && I2C
-	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE
-	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMIZE
-	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMIZE
-	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMIZE
-	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMIZE
-	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMIZE
-
 menuconfig MEDIA_TUNER_CUSTOMIZE
 	bool "Customize analog and hybrid tuner modules to build"
-	depends on MEDIA_TUNER
+	depends on VIDEO_MEDIA
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
@@ -42,122 +29,118 @@ menuconfig MEDIA_TUNER_CUSTOMIZE
 
 	  If unsure say N.
 
-if MEDIA_TUNER_CUSTOMIZE
-
 config MEDIA_TUNER_SIMPLE
-	tristate "Simple tuner support"
+	tristate "Simple tuner support" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_TDA9887
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for various simple tuners.
 
-config MEDIA_TUNER_TDA8290
-	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
-	depends on VIDEO_MEDIA && I2C
-	select MEDIA_TUNER_TDA827X
-	select MEDIA_TUNER_TDA18271
-	default m if MEDIA_TUNER_CUSTOMIZE
-	help
-	  Say Y here to include support for Philips TDA8290+8275(a) tuner.
-
 config MEDIA_TUNER_TDA827X
-	tristate "Philips TDA827X silicon tuner"
+	tristate "Philips TDA827X silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA18271
-	tristate "NXP TDA18271 silicon tuner"
+	tristate "NXP TDA18271 silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A silicon tuner module. Say Y when you want to support this tuner.
 
+config MEDIA_TUNER_TDA8290
+	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo" if MEDIA_TUNER_CUSTOMIZE
+	depends on VIDEO_MEDIA && I2C
+	depends on MEDIA_TUNER_TDA827X && MEDIA_TUNER_TDA18271
+	default y
+	help
+	  Say Y here to include support for Philips TDA8290+8275(a) tuner.
+
 config MEDIA_TUNER_TDA9887
-	tristate "TDA 9885/6/7 analog IF demodulator"
+	tristate "TDA 9885/6/7 analog IF demodulator" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
 	  analog IF demodulator.
 
 config MEDIA_TUNER_TEA5761
-	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
+	tristate "TEA 5761 radio tuner (EXPERIMENTAL)" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
 	depends on EXPERIMENTAL
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
 
 config MEDIA_TUNER_TEA5767
-	tristate "TEA 5767 radio tuner"
+	tristate "TEA 5767 radio tuner" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config MEDIA_TUNER_MT20XX
-	tristate "Microtune 2032 / 2050 tuners"
+	tristate "Microtune 2032 / 2050 tuners" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config MEDIA_TUNER_MT2060
-	tristate "Microtune MT2060 silicon IF tuner"
+	tristate "Microtune MT2060 silicon IF tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
 config MEDIA_TUNER_MT2266
-	tristate "Microtune MT2266 silicon tuner"
+	tristate "Microtune MT2266 silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A driver for the silicon baseband tuner MT2266 from Microtune.
 
 config MEDIA_TUNER_MT2131
-	tristate "Microtune MT2131 silicon tuner"
+	tristate "Microtune MT2131 silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A driver for the silicon baseband tuner MT2131 from Microtune.
 
 config MEDIA_TUNER_QT1010
-	tristate "Quantek QT1010 silicon tuner"
+	tristate "Quantek QT1010 silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
 config MEDIA_TUNER_XC2028
-	tristate "XCeive xc2028/xc3028 tuners"
+	tristate "XCeive xc2028/xc3028 tuners" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
 	depends on HOTPLUG
 	select FW_LOADER
-	default m if MEDIA_TUNER_CUSTOMIZE
+	default y
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
 
 config MEDIA_TUNER_XC5000
-	tristate "Xceive XC5000 silicon tuner"
+	tristate "Xceive XC5000 silicon tuner" if MEDIA_TUNER_CUSTOMIZE
 	depends on VIDEO_MEDIA && I2C
 	depends on HOTPLUG
 	select FW_LOADER
-	default m if DVB_FE_CUSTOMISE
+	default y
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
 	  This device is only used inside a SiP called togther with a
 	  demodulator for now.
 
 config MEDIA_TUNER_MXL5005S
-	tristate "MaxLinear MSL5005S silicon tuner"
+	tristate "MaxLinear MSL5005S silicon tuner" if MEDIA_TUNER_CUSTOMIZE && DVB_FE_CUSTOMISE
 	depends on VIDEO_MEDIA && I2C
-	default m if DVB_FE_CUSTOMISE
+	default DVB_CAPTURE_DRIVERS
 	help
 	  A driver for the silicon tuner MXL5005S from MaxLinear.
 
-endif # MEDIA_TUNER_CUSTOMIZE
