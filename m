Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbZJNMRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbZJNMRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbZJNMRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:17:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22709 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759593AbZJNMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:17:41 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: twl4030-power: fix undefined resconfig value checks
Date: Wed, 14 Oct 2009 15:15:50 +0300
Message-Id: <1255522550-15199-2-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com>
References: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com>
X-OriginalArrivalTime: 14 Oct 2009 12:15:56.0776 (UTC) FILETIME=[15490E80:01CA4CC8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code tries to skip values initialized with -1, but since the values
are unsigned the comparison is always true.

The patch eliminates the following compiler warnings:

drivers/mfd/twl4030-power.c: In function 'twl4030_configure_resource':
drivers/mfd/twl4030-power.c:338: warning: comparison is always true due to limited range of data type
drivers/mfd/twl4030-power.c:358: warning: comparison is always true due to limited range of data type
drivers/mfd/twl4030-power.c:363: warning: comparison is always true due to limited range of data type

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/mfd/twl4030-power.c |    6 +++---
 include/linux/i2c/twl4030.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index eae6cda..2f7c805 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -335,7 +335,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->devgroup >= 0) {
+	if (rconfig->devgroup != TWL4030_RESCONFIG_UNDEF) {
 		grp &= ~DEVGROUP_MASK;
 		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
 		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
@@ -355,12 +355,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->type >= 0) {
+	if (rconfig->type != TWL4030_RESCONFIG_UNDEF) {
 		type &= ~TYPE_MASK;
 		type |= rconfig->type << TYPE_SHIFT;
 	}
 
-	if (rconfig->type2 >= 0) {
+	if (rconfig->type2 != TWL4030_RESCONFIG_UNDEF) {
 		type &= ~TYPE2_MASK;
 		type |= rconfig->type2 << TYPE2_SHIFT;
 	}
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 508824e..99e5d7b 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -391,6 +391,7 @@ struct twl4030_resconfig {
 	u8 devgroup;	/* Processor group that Power resource belongs to */
 	u8 type;	/* Power resource addressed, 6 / broadcast message */
 	u8 type2;	/* Power resource addressed, 3 / broadcast message */
+#define TWL4030_RESCONFIG_UNDEF	((u8)-1)
 };
 
 struct twl4030_power_data {
-- 
1.6.0.4

