Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbXGVHWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbXGVHWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXGVHWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:22:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbXGVHWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:22:07 -0400
Date: Sun, 22 Jul 2007 08:22:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
Message-ID: <20070722072206.GT21668@ftp.linux.org.uk>
References: <20070721.232207.26531557.davem@davemloft.net> <20070722063149.GQ21668@ftp.linux.org.uk> <20070722063511.GR21668@ftp.linux.org.uk> <20070721.233949.35357470.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721.233949.35357470.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 11:39:49PM -0700, David Miller wrote:
> No objections.

>From 6fc7f305af19f2020c14a002061a8ce8b7812307 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 22 Jul 2007 03:14:37 -0400
Subject: [PATCH] deal with rtc/sun_mostek_rtc conflict on sparc32

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/defconfig      |    2 +-
 drivers/char/Kconfig      |   24 +++++++++++++++++++++++-
 drivers/char/Makefile     |    3 +++
 drivers/sbus/char/Kconfig |    1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/defconfig b/arch/sparc/defconfig
index 38bd79f..fdc6723 100644
--- a/arch/sparc/defconfig
+++ b/arch/sparc/defconfig
@@ -600,7 +600,7 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
 # CONFIG_WATCHDOG is not set
 CONFIG_HW_RANDOM=m
-CONFIG_RTC=m
+CONFIG_JS_RTC=m
 # CONFIG_R3964 is not set
 # CONFIG_APPLICOM is not set
 # CONFIG_DRM is not set
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 67c9f1f..0675292 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -726,7 +726,7 @@ config NVRAM
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC64 && (!SPARC32 || PCI) && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -750,6 +750,28 @@ config RTC
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtc.
 
+config JS_RTC
+	tristate "Enhanced Real Time Clock Support"
+	depends on SPARC32 && PCI
+	---help---
+	  If you say Y here and create a character special file /dev/rtc with
+	  major number 10 and minor number 135 using mknod ("man mknod"), you
+	  will get access to the real time clock (or hardware clock) built
+	  into your computer.
+
+	  Every PC has such a clock built in. It can be used to generate
+	  signals from as low as 1Hz up to 8192Hz, and can also be used
+	  as a 24 hour alarm. It reports status information via the file
+	  /proc/driver/rtc and its behaviour is set by various ioctls on
+	  /dev/rtc.
+
+	  If you think you have a use for such a device (such as periodic data
+	  sampling), then say Y here, and read <file:Documentation/rtc.txt>
+	  for details.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called js-rtc.
+
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
 	depends on SGI_IP22
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 8fecaf4..23b26b8 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -109,6 +109,9 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 
+obj-$(CONFIG_JS_RTC)		+= js-rtc.o
+js-rtc-y = rtc.o
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 35a7316..400c65b 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -15,6 +15,7 @@ config SUN_OPENPROMIO
 
 config SUN_MOSTEK_RTC
 	tristate "Mostek real time clock support"
+	depends on SPARC32
 	help
 	  The Mostek RTC chip is used on all known Sun computers except
 	  some JavaStations. For a JavaStation you need to say Y both here
-- 
1.5.3.GIT

