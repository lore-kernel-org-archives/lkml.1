Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYJVXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYJVXvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYJVXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:51:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:18452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYJVXvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,467,1220252400"; 
   d="scan'208";a="454540694"
Date: Wed, 22 Oct 2008 16:51:03 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: lenb@kernel.org
Cc: randy.dunlap@oracle.com, Andi Kleen <ak@linux.intel.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Cleanup of i7300_idle based on review comments
Message-ID: <20081022235103.GA31369@linux-os.sc.intel.com>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <48FE07AE.4010203@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com> <48FED3FA.6040703@linux.intel.com> <20081022233451.GA28775@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022233451.GA28775@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cleanup of i7300 idle driver based on review comments from Randy Dunlap,
Andi Kleen and Len Brown.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/idle/Kconfig      |   11 ++++++-----
 drivers/idle/i7300_idle.c |   33 ++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 20 deletions(-)

Index: linux-acpi-2.6/drivers/idle/Kconfig
===================================================================
--- linux-acpi-2.6.orig/drivers/idle/Kconfig	2008-10-22 11:43:08.000000000 -0700
+++ linux-acpi-2.6/drivers/idle/Kconfig	2008-10-22 11:43:37.000000000 -0700
@@ -5,12 +5,13 @@ config I7300_IDLE_IOAT_CHANNEL
 	bool
 
 config I7300_IDLE
-	tristate "Intel chipset idle power saving driver"
+	tristate "Intel chipset idle memory power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on X86_64
+	depends on X86_64 && EXPERIMENTAL
 	help
-	  Enable idle power savings with certain Intel server chipsets.
-	  The chipset must have I/O AT support, such as the Intel 7300.
-	  The power savings depends on the type and quantity of DRAM devices.
+	  Enable memory power savings when idle with certain Intel server
+	  chipsets. The chipset must have I/O AT support, such as the
+	  Intel 7300. The power savings depends on the type and quantity of
+	  DRAM devices.
 
 endmenu
Index: linux-acpi-2.6/drivers/idle/i7300_idle.c
===================================================================
--- linux-acpi-2.6.orig/drivers/idle/i7300_idle.c	2008-10-22 11:43:08.000000000 -0700
+++ linux-acpi-2.6/drivers/idle/i7300_idle.c	2008-10-22 11:43:37.000000000 -0700
@@ -35,6 +35,8 @@
 #define I7300_IDLE_DRIVER_VERSION	"1.55"
 #define I7300_PRINT			"i7300_idle:"
 
+#define MAX_STOP_RETRIES	10
+
 static int debug;
 module_param_named(debug, debug, uint, 0644);
 MODULE_PARM_DESC(debug, "Enable debug printks in this driver");
@@ -47,12 +49,12 @@ MODULE_PARM_DESC(debug, "Enable debug pr
  *  0 = No throttling
  *  1 = Throttle when > 4 activations per eval window (Maximum throttling)
  *  2 = Throttle when > 8 activations
- *  168 = Throttle when > 168 activations (Minimum throttling)
+ *  168 = Throttle when > 672 activations (Minimum throttling)
  */
-#define MAX_THRTLWLIMIT		168
-static uint i7300_idle_thrtlowlm = 1;
-module_param_named(thrtlwlimit, i7300_idle_thrtlowlm, uint, 0644);
-MODULE_PARM_DESC(thrtlwlimit,
+#define MAX_THROTTLE_LOW_LIMIT		168
+static uint throttle_low_limit = 1;
+module_param_named(throttle_low_limit, throttle_low_limit, uint, 0644);
+MODULE_PARM_DESC(throttle_low_limit,
 		"Value for THRTLOWLM activation field "
 		"(0 = disable throttle, 1 = Max throttle, 168 = Min throttle)");
 
@@ -111,9 +113,9 @@ static int i7300_idle_ioat_start(void)
 static void i7300_idle_ioat_stop(void)
 {
 	int i;
-	u8 sts;
+	u64 sts;
 
-	for (i = 0; i < 5; i++) {
+	for (i = 0; i < MAX_STOP_RETRIES; i++) {
 		writeb(IOAT_CHANCMD_RESET,
 			ioat_chanbase + IOAT1_CHANCMD_OFFSET);
 
@@ -127,9 +129,10 @@ static void i7300_idle_ioat_stop(void)
 
 	}
 
-	if (i == 5)
-		dprintk("failed to suspend+reset I/O AT after 5 retries\n");
-
+	if (i == MAX_STOP_RETRIES) {
+		dprintk("failed to stop I/O AT after %d retries\n",
+			MAX_STOP_RETRIES);
+	}
 }
 
 /* Test I/O AT by copying 1024 byte from 2k to 1k */
@@ -276,7 +279,7 @@ static void __exit i7300_idle_ioat_exit(
 	i7300_idle_ioat_stop();
 
 	/* Wait for a while for the channel to halt before releasing */
-	for (i = 0; i < 10; i++) {
+	for (i = 0; i < MAX_STOP_RETRIES; i++) {
 		writeb(IOAT_CHANCMD_RESET,
 		       ioat_chanbase + IOAT1_CHANCMD_OFFSET);
 
@@ -390,9 +393,9 @@ static void i7300_idle_start(void)
 	new_ctl = i7300_idle_thrtctl_saved & ~DIMM_THRTCTL_THRMHUNT;
 	pci_write_config_byte(fbd_dev, DIMM_THRTCTL, new_ctl);
 
-	limit = i7300_idle_thrtlowlm;
-	if (unlikely(limit > MAX_THRTLWLIMIT))
-		limit = MAX_THRTLWLIMIT;
+	limit = throttle_low_limit;
+	if (unlikely(limit > MAX_THROTTLE_LOW_LIMIT))
+		limit = MAX_THROTTLE_LOW_LIMIT;
 
 	pci_write_config_byte(fbd_dev, DIMM_THRTLOW, limit);
 
@@ -441,7 +444,7 @@ static int i7300_idle_notifier(struct no
 	static ktime_t idle_begin_time;
 	static int time_init = 1;
 
-	if (!i7300_idle_thrtlowlm)
+	if (!throttle_low_limit)
 		return 0;
 
 	if (unlikely(time_init)) {
