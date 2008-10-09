Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbYJIMx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbYJIMx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbYJIMxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:53:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57254 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757852AbYJIMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:53:19 -0400
Date: Thu, 9 Oct 2008 13:53:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] mfd: Core support for the WM8350 AudioPlus PMIC
Message-ID: <20081009125316.GA18321@rakim.wolfsonmicro.main>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main> <1223296688-9960-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com> <1223296688-9960-8-git-send-email-broonie@opensource.wolfsonmicro.com> <1223553948.6814.291.camel@dell-desktop.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223553948.6814.291.camel@dell-desktop.example.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 01:05:48PM +0100, Liam Girdwood wrote:
> On Mon, 2008-10-06 at 13:38 +0100, Mark Brown wrote:

> > +config MFD_WM8350_CONFIG_MODE_0
> > +	bool "Support WM8350 in configuration mode 0"

> I would make the WM8350 mode configuration selectable by the target
> machines Kconfig rather than let the user choose. Wrong choices would
> probably mean broken hardware.   

Machines can still select config modes - this just allows people to
enable additional modes.  That said, on reflection I can't actually see
much use for that so I'll just hide the options from the user menus
(patch below).

> > +	case 3:
> > +		reg_map = wm8350_mode3_defaults;
> > +		break;
> > +#endif

> Shouldn't this be #elif for each mode ?
> Ditto for the default register values.

This is a deliberate decision in order to allow people to build kernel
images supporting multiple boards - the driver will check the mode with
the hardware and error out at probe time if support for the mode isn't
compiled in.  If the register maps were smaller I'd just compile them
all in.

>                                        I would also #error if no mode
> was selected just to make it's correctly set by machine/board authors.

Yeah, that'd be nice but if the driver does that then it'll be harder
for people like subsystem maintainers to do build tests with WM8350
drivers and they won't get picked up by things like allmodconfig checks.

The patch below adds a build time warning for this case - the runtime
checks will mean that the driver should be safe since it won't run on
unknown hardware.

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9556547..1597c23 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -82,48 +82,20 @@ config MFD_WM8350
 	tristate
 
 config MFD_WM8350_CONFIG_MODE_0
-	bool "Support WM8350 in configuration mode 0"
+	bool
 	depends on MFD_WM8350
-	default y
-	help
-	  The WM8350 offers four configuration modes with different
-	  initial register states.  This option enables support for the
-	  WM8350 in mode 0.
-
-	  If unsure say Y
 
 config MFD_WM8350_CONFIG_MODE_1
-	bool "Support WM8350 in configuration mode 1"
+	bool
 	depends on MFD_WM8350
-	default y
-	help
-	  The WM8350 offers four configuration modes with different
-	  initial register states.  This option enables support for the
-	  WM8350 in mode 1.
-	  
-	  If unsure say Y
 
 config MFD_WM8350_CONFIG_MODE_2
-	bool "Support WM8350 in configuration mode 2"
+	bool
 	depends on MFD_WM8350
-	default y
-	help
-	  The WM8350 offers four configuration modes with different
-	  initial register states.  This option enables support for the
-	  WM8350 in mode 2.
-	  
-	  If unsure say Y
 
 config MFD_WM8350_CONFIG_MODE_3
-	bool "Support WM8350 in configuration mode 3"
+	bool
 	depends on MFD_WM8350
-	default y
-	help
-	  The WM8350 offers four configuration modes with different
-	  initial register states.  This option enables support for the
-	  WM8350 in mode 3.
-	  
-	  If unsure say Y
 
 config MFD_WM8350_I2C
 	tristate "Support Wolfson Microelectronics WM8350 with I2C"
diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index b062cc1..7cb2f4d 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -15,6 +15,10 @@
 #include <linux/mfd/wm8350/core.h>
 
 #ifdef CONFIG_MFD_WM8350_CONFIG_MODE_0
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
 const u16 wm8350_mode0_defaults[] = {
 	0x17FF,     /* R0   - Reset/ID */
 	0x1000,     /* R1   - ID */
@@ -276,6 +280,10 @@ const u16 wm8350_mode0_defaults[] = {
 #endif
 
 #ifdef CONFIG_MFD_WM8350_CONFIG_MODE_1
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
 const u16 wm8350_mode1_defaults[] = {
 	0x17FF,     /* R0   - Reset/ID */
 	0x1000,     /* R1   - ID */
@@ -537,6 +545,10 @@ const u16 wm8350_mode1_defaults[] = {
 #endif
 
 #ifdef CONFIG_MFD_WM8350_CONFIG_MODE_2
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
 const u16 wm8350_mode2_defaults[] = {
 	0x17FF,     /* R0   - Reset/ID */
 	0x1000,     /* R1   - ID */
@@ -798,6 +810,10 @@ const u16 wm8350_mode2_defaults[] = {
 #endif
 
 #ifdef CONFIG_MFD_WM8350_CONFIG_MODE_3
+
+#undef WM8350_HAVE_CONFIG_MODE
+#define WM8350_HAVE_CONFIG_MODE
+
 const u16 wm8350_mode3_defaults[] = {
 	0x17FF,     /* R0   - Reset/ID */
 	0x1000,     /* R1   - ID */
@@ -1058,6 +1074,14 @@ const u16 wm8350_mode3_defaults[] = {
 };
 #endif
 
+/* The register defaults for the config mode used must be compiled in but
+ * due to the impact on kernel size it is possible to disable 
+ */
+#ifndef WM8350_HAVE_CONFIG_MODE
+#warning No WM8350 config modes supported - select at least one of the
+#warning MFD_WM8350_CONFIG_MODE_n options from the board driver.
+#endif
+
 /*
  * Access masks.
  */
