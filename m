Return-Path: <linux-kernel-owner+w=401wt.eu-S965166AbXAYCHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166AbXAYCHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXAYCHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:07:04 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5391 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965166AbXAYCHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:07:01 -0500
X-Greylist: delayed 6822 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 21:07:01 EST
X-BigFish: V
Message-ID: <45B7F5E2.4070800@am.sony.com>
Date: Wed, 24 Jan 2007 16:12:18 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init: support preset lpj value as config option
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Often, it is useful to preserve the preset loops_per_jiffy
value for a machine in a config option. Right now, you can
specify a preset lpj value on the kernel command line. But this
means the value is preserved in the firmware, which is less
portable between developers.

This patch provides a config option for preset lpj, which means
the value can be easily preserved, and conveyed between developers
in a config file.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>

----
diff -pruN linux-2.6.20-rc5-git2.orig/init/Kconfig linux-2.6.20-rc5-git2/init/Kconfig
--- linux-2.6.20-rc5-git2.orig/init/Kconfig	2007-01-12 10:54:26.000000000 -0800
+++ linux-2.6.20-rc5-git2/init/Kconfig	2007-01-24 16:03:30.000000000 -0800
@@ -466,6 +466,35 @@ config VM_EVENT_COUNTERS
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.

+config PRESET_LPJ
+	int "Preset loops_per_jiffy" if EMBEDDED
+	default 0
+	help
+	  Set this to preset the number of loops used by delay() to
+	  achieve a single jiffy of delay inside the kernel.  This is
+	  normally calculated at boot time, but that calibration can
+	  take up to 250 ms per CPU.  Specifying a constant value here
+	  eliminates the calibration, and improves bootup time.
+
+	  A value of 0 results in the normal autodetect behavior.
+
+	  To determine the correct value for your kernel, first set this
+	  option to 0, compile and boot the kernel on your target hardware,
+	  then see what value is printed during the kernel boot.  Use that
+	  value here.
+
+	  The kernel command line parameter "lpj=" can be used to override
+	  the value configured here.
+
+	  Note that on SMP systems the preset will be applied to all CPUs,
+	  which could cause problems if for some reason your CPUs need
+	  significantly divergent settings.
+
+	  If unsure, set this to 0. An incorrect value will cause delays in
+	  the kernel to be wrong, leading to unpredictable I/O errors and
+	  other breakage.  Although unlikely, in the extreme case this might
+	  damage your hardware.
+
 endmenu		# General setup

 config RT_MUTEXES
diff -pruN linux-2.6.20-rc5-git2.orig/init/calibrate.c linux-2.6.20-rc5-git2/init/calibrate.c
--- linux-2.6.20-rc5-git2.orig/init/calibrate.c	2007-01-12 10:54:26.000000000 -0800
+++ linux-2.6.20-rc5-git2/init/calibrate.c	2007-01-23 11:23:39.000000000 -0800
@@ -10,7 +10,7 @@

 #include <asm/timex.h>

-static unsigned long preset_lpj;
+static unsigned long preset_lpj = CONFIG_PRESET_LPJ;
 static int __init lpj_setup(char *str)
 {
 	preset_lpj = simple_strtoul(str,NULL,0);

