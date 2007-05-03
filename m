Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXECXlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXECXlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXECXlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:41:50 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:25249 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754723AbXECXlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:41:49 -0400
Message-ID: <463A7291.1050600@tungstengraphics.com>
Date: Fri, 04 May 2007 01:38:57 +0200
From: Roland Scheidegger <sroland@tungstengraphics.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20061107 SUSE/1.1.1-0.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: [PATCH] input: fix aux port detection with some i8042 chips
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Scheidegger <sroland@tungstengraphics.com>

The i8042 driver fails detection of the AUX port with some chips,
because they apparently do not change the I8042_CTR_AUXDIS bit
immediately. This is known to affect at least HP500 / HP510 notebooks,
consequently the built-in touchpad will not work. The patch will simply
reread the value until it gets the expected value or a retry limit is
hit, without touching other workaround code in the same area.

Signed-off-by: Roland Scheidegger <sroland@tungstengraphics.com>

---
There is some discussion about non-working touchpads in HP500 notebooks
in ubuntu and a (ugly) workaround for this problem here:
http://ubuntuforums.org/showthread.php?t=344103. I've got a HP510 and
even with 2.6.21 the aux port would get disabled. Works with the patch,
for the record the i8042 here needs around 6 tries (sometimes a bit
more, sometimes less) until it reads the I8042_CTR_AUXDIS bit correctly,
both after disabling and enabling the aux port.
(please CC: on any replies)

Signed-off-by: Roland Scheidegger <sroland@tungstengraphics.com>

--- linux-2.6/drivers/input/serio/i8042.c.orig	2007-05-03
16:32:26.000000000 +0200
+++ linux-2.6/drivers/input/serio/i8042.c	2007-05-03 16:56:00.000000000
+0200
@@ -537,6 +537,7 @@ static int __devinit i8042_check_aux(voi
 	int retval = -1;
 	int irq_registered = 0;
 	int aux_loop_broken = 0;
+	int i = 0;
 	unsigned long flags;
 	unsigned char param;

@@ -582,14 +583,27 @@ static int __devinit i8042_check_aux(voi

 	if (i8042_command(&param, I8042_CMD_AUX_DISABLE))
 		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (~param &
I8042_CTR_AUXDIS)) {
+	/* some chips need some time to set the I8042_CTR_AUXDIS bit */
+	for (i = 0; i < 100; i++) {
+		if (!i8042_command(&param, I8042_CMD_CTL_RCTR) && (param &
I8042_CTR_AUXDIS))
+			break;
+		udelay(50);
+	}
+	if (i == 100) {
 		printk(KERN_WARNING "Failed to disable AUX port, but continuing
anyway... Is this a SiS?\n");
 		printk(KERN_WARNING "If AUX port is really absent please use the
'i8042.noaux' option.\n");
 	}

 	if (i8042_command(&param, I8042_CMD_AUX_ENABLE))
 		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (param &
I8042_CTR_AUXDIS))
+	for (i = 0; i < 100; i++) {
+		if (i8042_command(&param, I8042_CMD_CTL_RCTR))
+			return -1;
+		if (~param & I8042_CTR_AUXDIS)
+			break;
+		udelay(50);
+	}
+	if (i == 100)
 		return -1;

 /*
