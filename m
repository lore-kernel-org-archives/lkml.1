Return-Path: <linux-kernel-owner+w=401wt.eu-S2992584AbXCBQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992584AbXCBQbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992591AbXCBQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:31:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35865 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992584AbXCBQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:31:09 -0500
Date: Fri, 2 Mar 2007 16:31:02 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: 2.6.21-rc2-mm1 - fb_ddc_read() not defined
In-Reply-To: <200703021603.l22G37Sa022890@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0703021630040.3216@pentafluge.infradead.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
 <200703021603.l22G37Sa022890@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 02 Mar 2007 03:00:26 PST, Andrew Morton said:
> 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> > nvidiafb-bring-back-generic-ddc-reading.patch
> 
> Building with FB_DDC=N results in:
> 
> Kernel: arch/x86_64/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 229 modules
> WARNING: "fb_ddc_read" [drivers/video/nvidia/nvidiafb.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> makes-it-build patch (not sure if it should be "select FB_DDC if MUMBLE"):
> 
> --- linux-2.6.21-rc2-mm1/drivers/video/Kconfig.nvidia	2007-03-02 09:27:48.000000000 -0500
> +++ linux-2.6.21-rc2-mm1/drivers/video/Kconfig	2007-03-02 10:56:54.000000000 -0500
> @@ -710,6 +710,7 @@ config FB_NVIDIA
>  	select I2C_ALGOBIT if FB_NVIDIA_I2C
>  	select I2C if FB_NVIDIA_I2C
>  	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
> +	select FB_DDC
>  	select FB_MODE_HELPERS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA

To have a patch to cleans things up. Give it a try

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index b8f0a11..855a09e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -677,8 +678,6 @@ config FB_S1D13XXX
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
 	depends on FB && PCI
-	select I2C_ALGOBIT if FB_NVIDIA_I2C
-	select I2C if FB_NVIDIA_I2C
 	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -697,6 +696,7 @@ config FB_NVIDIA
 config FB_NVIDIA_I2C
        bool "Enable DDC Support"
        depends on FB_NVIDIA
+       select FB_DDC
        help
 	  This enables I2C support for nVidia Chipsets.  This is used
 	  only for getting EDID information from the attached display
@@ -716,7 +716,6 @@ config FB_NVIDIA_BACKLIGHT
 config FB_RIVA
 	tristate "nVidia Riva support"
 	depends on FB && PCI
-	select FB_DDC if FB_RIVA_I2C
 	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -734,6 +733,7 @@ config FB_RIVA
 config FB_RIVA_I2C
        bool "Enable DDC Support"
        depends on FB_RIVA
+       select FB_DDC
        help
 	  This enables I2C support for nVidia Chipsets.  This is used
 	  only for getting EDID information from the attached display
@@ -812,8 +812,6 @@ config FB_INTEL
 	depends on FB && EXPERIMENTAL && PCI && X86
 	select AGP
 	select AGP_INTEL
-	select I2C_ALGOBIT if FB_INTEL_I2C
-	select I2C if FB_INTEL_I2C
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -846,6 +844,7 @@ config FB_INTEL_DEBUG
 config FB_INTEL_I2C
 	bool "DDC/I2C for Intel framebuffer support"
 	depends on FB_INTEL
+	select FB_DDC
 	default y
 	help
 	  Say Y here if you want DDC/I2C support for your on-board Intel graphics.
@@ -924,8 +923,8 @@ config FB_MATROX_G
 
 config FB_MATROX_I2C
 	tristate "Matrox I2C support"
-	depends on FB_MATROX && I2C
-	select I2C_ALGOBIT
+	depends on FB_MATROX
+	select FB_DDC
 	---help---
 	  This drivers creates I2C buses which are needed for accessing the
 	  DDC (I2C) bus present on all Matroxes, an I2C bus which
@@ -993,7 +992,6 @@ config FB_MATROX_MULTIHEAD
 config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
-	select FB_DDC if FB_RADEON_I2C
 	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
@@ -1018,6 +1016,7 @@ config FB_RADEON
 config FB_RADEON_I2C
 	bool "DDC/I2C for ATI Radeon support"
 	depends on FB_RADEON
+	select FB_DDC
 	default y
 	help
 	  Say Y here if you want DDC/I2C support for your Radeon board. 
@@ -1125,7 +1124,6 @@ config FB_S3
 config FB_SAVAGE
 	tristate "S3 Savage support"
 	depends on FB && PCI && EXPERIMENTAL
-	select FB_DDC if FB_SAVAGE_I2C
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1142,6 +1140,7 @@ config FB_SAVAGE
 config FB_SAVAGE_I2C
        bool "Enable DDC2 Support"
        depends on FB_SAVAGE
+       select FB_DDC
        help
 	  This enables I2C support for S3 Savage Chipsets.  This is used
 	  only for getting EDID information from the attached display
