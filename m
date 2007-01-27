Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbXA0UHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbXA0UHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXA0UHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:07:11 -0500
Received: from ns1.mvista.com ([63.81.120.158]:57368 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbXA0UHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:07:09 -0500
Message-ID: <45BBB09C.7020509@mvista.com>
Date: Sat, 27 Jan 2007 10:05:48 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] PM: fast power off - driver
Content-Type: multipart/mixed;
 boundary="------------020306050307000805070104"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020306050307000805070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

My apologies, I cc'd the wrong list the first time around.

- Armin
---

--------------020306050307000805070104
Content-Type: text/x-patch;
 name="fastpoweroff-1.0_driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fastpoweroff-1.0_driver.patch"


Fastpoweroff default profile driver

signed-off-by: Armin Kuster <AKuster@mvista.com>
---
 kernel/power/fastoff/Kconfig      |    8 ++++
 kernel/power/fastoff/Makefile     |    2 -
 kernel/power/fastoff/fastoffdrv.c |   69 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

Index: linux-2.6_dev/kernel/power/fastoff/fastoffdrv.c
===================================================================
--- /dev/null
+++ linux-2.6_dev/kernel/power/fastoff/fastoffdrv.c
@@ -0,0 +1,69 @@
+/*
+ * kernel/power/fastoff/fastoffdrv.c
+ *
+ * This provides a sysfs interface that allows the user to
+ * bypass running rc kill scripts in the advent the user
+ * needed to power down as fast as possible. This could be
+ * in a low battery conditon and you want to try to keep
+ * data from being corrupted.
+ *
+ * Author: Armin Kuster <AKuster@mvista.com, or source@mvista.com>
+ *
+ * 2006, 2007  (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+
+#include "../power.h"
+#include "fpo.h"
+
+static int fsd_default_off(void)
+{
+	/*
+	 * Actions taken:
+	 *
+	 *    1. Freeze all user processes.
+	 *
+	 *    2. Power off
+	 *
+	 *    3. Power off devices
+	 */
+
+	printk(KERN_EMERG "Fast Power Off initiated.\n");
+	fastpoweroff_prepare();
+	fastpoweroff();
+	fastpoweroff_standby();
+	return 1;
+}
+
+static struct fpo_driver fpo_default = {
+	.name = "default",
+	.policy = fsd_default_off,
+};
+
+static int __init fsd_default_init(void)
+{
+	int ret = 0;
+
+	if(( ret = fastpoweroff_register(&fpo_default)) < 0) {
+		printk(KERN_ERR "PM: Fastpoweroff: %s profile registation failed %d.\n",
+			fpo_default.name,ret);
+		goto errout;
+	}
+
+	printk(KERN_INFO "PM: Fastpoweroff, %s profile added\n",fpo_default.name);
+errout:
+	return ret;
+}
+
+module_init(fsd_default_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Armin Kuster <akuster@mvista.com>");
+
Index: linux-2.6_dev/kernel/power/fastoff/Kconfig
===================================================================
--- linux-2.6_dev.orig/kernel/power/fastoff/Kconfig
+++ linux-2.6_dev/kernel/power/fastoff/Kconfig
@@ -10,4 +10,12 @@ config FAST_POWER_OFF
 	---help---
 	  Say yes if you want core support for sysfs/power/fastoff
 
+config FAST_POWER_DOWN
+	tristate "Fast power of profile"
+	depends on FAST_POWER_OFF
+	default n
+	---help---
+	  Say yes if want to bypass the rc kill scripts
+	  and shut the machine down
+
 endmenu
Index: linux-2.6_dev/kernel/power/fastoff/Makefile
===================================================================
--- linux-2.6_dev.orig/kernel/power/fastoff/Makefile
+++ linux-2.6_dev/kernel/power/fastoff/Makefile
@@ -5,4 +5,4 @@
 #
 
 obj-$(CONFIG_FAST_POWER_OFF)	:= fpo.o
-
+obj-$(CONFIG_FAST_POWER_DOWN)	+= fastoffdrv.o

--------------020306050307000805070104--
