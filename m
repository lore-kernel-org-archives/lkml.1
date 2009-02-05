Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZBEDRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZBEDRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZBEDRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:17:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:57102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZBEDRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:17:17 -0500
Date: Wed, 4 Feb 2009 19:16:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-input@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch 1/2] input: introduce a tougher i8042.reset
Message-ID: <20090204191631.21783c62@infradead.org>
In-Reply-To: <20090204191540.2d6abd87@infradead.org>
References: <20090204191540.2d6abd87@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 2c5ccde448ae5f4062802bcd6002f856acbd268f Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 3 Feb 2009 16:26:16 -0800
Subject: [PATCH] input: introduce a tougher i8042.reset

Some touchpads don't reset right the first time (MSI Wind U-100 for
example). This patch will retry the reset up to 5 times.

In addition, this patch also adds a module parameter to not treat
reset failures as fatal to the usage of the device. This prevents
a touchpad failure from also disabling the keyboard....

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 drivers/input/serio/i8042.c         |   33 ++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ac613a6..a43e3bd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -855,6 +855,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
 	i8042.reset	[HW] Reset the controller during init and cleanup
+	i8042.nonfatal  [HW] Don't treat i8042.reset failures as fatal for the
+			     device initialization.
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
 	i810=		[HW,DRM]
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 170f71e..2473a9a 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -47,6 +47,10 @@ static unsigned int i8042_reset;
 module_param_named(reset, i8042_reset, bool, 0);
 MODULE_PARM_DESC(reset, "Reset controller during init and cleanup.");
 
+static unsigned int i8042_nonfatal;
+module_param_named(nonfatal, i8042_nonfatal, bool, 0);
+MODULE_PARM_DESC(reset, "Treat controller test failures as non-fatal.");
+
 static unsigned int i8042_direct;
 module_param_named(direct, i8042_direct, bool, 0);
 MODULE_PARM_DESC(direct, "Put keyboard port into non-translated mode.");
@@ -712,22 +716,33 @@ static int i8042_controller_check(void)
 static int i8042_controller_selftest(void)
 {
 	unsigned char param;
+	int i = 0;
 
 	if (!i8042_reset)
 		return 0;
 
-	if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-		printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
-		return -ENODEV;
-	}
+	/*
+	 * We try this 5 times; on some really fragile systems this does not
+	 * take the first time...
+	 */
+	do {
+
+		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
+			printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
+			return -ENODEV;
+		}
+
+		if (param == I8042_RET_CTL_TEST)
+			return 0;
 
-	if (param != I8042_RET_CTL_TEST) {
 		printk(KERN_ERR "i8042.c: i8042 controller selftest failed. (%#x != %#x)\n",
-			 param, I8042_RET_CTL_TEST);
-		return -EIO;
-	}
+			param, I8042_RET_CTL_TEST);
+		msleep(50);
+	} while (i++ < 5);
 
-	return 0;
+	if (i8042_nonfatal)
+		return 0;
+	return -EIO;
 }
 
 /*
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
