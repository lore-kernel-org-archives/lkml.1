Return-Path: <linux-kernel-owner+w=401wt.eu-S1423271AbXD3OSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423271AbXD3OSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423291AbXD3OSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:18:48 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:32768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423271AbXD3OSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:18:47 -0400
Subject: Re: [PATCH 28/36] Use menuconfig objects II - sound
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
In-Reply-To: <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 16:19:14 +0200
Message-Id: <1177942754.5102.76.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

Thanks for doing this.

> --- linux-2.6.21-mm_20070428.orig/sound/aoa/Kconfig
> +++ linux-2.6.21-mm_20070428/sound/aoa/Kconfig
> @@ -1,9 +1,12 @@
[...]

For the aoa bits this ends up having two "Apple Onboard Audio driver"
bits which is a bit confusing. How about this instead? SND_AOA was
pretty much a generic symbol to start with since it will cause snd-aoa
to be compiled but is pretty much useless on it's own. This hence makes
the core bits an invisible symbol.

--- wireless-dev.orig/sound/aoa/Kconfig	2006-10-08 19:56:35.000000000 +0200
+++ wireless-dev/sound/aoa/Kconfig	2007-04-30 16:18:12.935651366 +0200
@@ -1,13 +1,15 @@
-menu "Apple Onboard Audio driver"
-	depends on SND!=n && PPC_PMAC
-
-config SND_AOA
-	tristate "Apple Onboard Audio driver"
-	depends on SND
+menuconfig SND_AOA
+	bool "Apple Onboard Audio driver"
+	depends on PPC_PMAC
 	select SND_PCM
-	---help---
-	This option enables the new driver for the various
-	Apple Onboard Audio components.
+	help
+	  This option enables the new driver for the various
+	  Apple Onboard Audio components.
+
+if SND_AOA
+
+config SND_AOA_CORE
+	tristate
 
 source "sound/aoa/fabrics/Kconfig"
 
@@ -15,4 +17,4 @@ source "sound/aoa/codecs/Kconfig"
 
 source "sound/aoa/soundbus/Kconfig"
 
-endmenu
+endif # SND_AOA
--- wireless-dev.orig/sound/aoa/codecs/Kconfig	2007-04-30 16:15:56.375651366 +0200
+++ wireless-dev/sound/aoa/codecs/Kconfig	2007-04-30 16:16:28.775651366 +0200
@@ -1,8 +1,8 @@
 config SND_AOA_ONYX
 	tristate "support Onyx chip"
-	depends on SND_AOA
 	select I2C
 	select I2C_POWERMAC
+	select SND_AOA_CORE
 	---help---
 	This option enables support for the Onyx (pcm3052)
 	codec chip found in the latest Apple machines
@@ -10,7 +10,7 @@ config SND_AOA_ONYX
 
 config SND_AOA_TOPAZ
 	tristate "support Topaz chips"
-	depends on SND_AOA
+	select SND_AOA_CORE
 	---help---
 	This option enables support for the Topaz (CS84xx)
 	codec chips found in the latest Apple machines,
@@ -22,9 +22,9 @@ config SND_AOA_TOPAZ
 
 config SND_AOA_TAS
 	tristate "support TAS chips"
-	depends on SND_AOA
 	select I2C
 	select I2C_POWERMAC
+	select SND_AOA_CORE
 	---help---
 	This option enables support for the tas chips
 	found in a lot of Apple Machines, especially
@@ -32,7 +32,7 @@ config SND_AOA_TAS
 
 config SND_AOA_TOONIE
 	tristate "support Toonie chip"
-	depends on SND_AOA
+	select SND_AOA_CORE
 	---help---
 	This option enables support for the toonie codec
 	found in the Mac Mini. If you have a Mac Mini and
--- wireless-dev.orig/sound/aoa/core/Makefile	2007-04-30 16:14:29.335651366 +0200
+++ wireless-dev/sound/aoa/core/Makefile	2007-04-30 16:14:51.795651366 +0200
@@ -1,4 +1,4 @@
-obj-$(CONFIG_SND_AOA) += snd-aoa.o
+obj-$(CONFIG_SND_AOA_CORE) += snd-aoa.o
 snd-aoa-objs := snd-aoa-core.o \
 		snd-aoa-alsa.o \
 		snd-aoa-gpio-pmf.o \
--- wireless-dev.orig/sound/aoa/fabrics/Kconfig	2007-04-30 16:15:42.275651366 +0200
+++ wireless-dev/sound/aoa/fabrics/Kconfig	2007-04-30 16:16:31.845651366 +0200
@@ -1,8 +1,8 @@
 config SND_AOA_FABRIC_LAYOUT
 	tristate "layout-id fabric"
-	depends on SND_AOA
 	select SND_AOA_SOUNDBUS
 	select SND_AOA_SOUNDBUS_I2S
+	select SND_AOA_CORE
 	---help---
 	This enables the layout-id fabric for the Apple Onboard
 	Audio driver, the module holding it all together


