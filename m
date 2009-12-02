Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZLBOBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZLBOBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZLBOBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:01:09 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43033 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZLBOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:01:08 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: [PATCHv2] mfd: twl4030: clarify the return value for read and write
Date: Wed,  2 Dec 2009 16:00:50 +0200
Message-Id: <1259762450-7385-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259760678-18707-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259760678-18707-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 02 Dec 2009 14:00:53.0327 (UTC) FILETIME=[DC903DF0:01CA7357]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Infact, we can just return -1 so that caller knows for sure that all messages
were not tranferred. Please consider fixed patch instead.

We should be checking if all the messages were tranferred or not. And return
-1 for failure. Currently we return success (0) even if none of messages were
transferred successfully.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 drivers/mfd/twl4030-core.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 56f1de5..8f9ba79 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -292,10 +292,14 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 1) {
+		pr_err("%s: i2c_write failed to transfer all messages\n",
+			DRIVER_NAME);
+		return -1;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_write);
 
@@ -344,10 +348,15 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 2) {
+		pr_err("%s: i2c_read failed to transfer all messages\n",
+			DRIVER_NAME);
+		return -1;
+	}
+	else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_read);
 
-- 
1.6.3.3

