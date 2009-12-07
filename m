Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbZLGMRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbZLGMRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbZLGMRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:17:35 -0500
Received: from smtp.nokia.com ([192.100.105.134]:28579 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934474AbZLGMRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:17:34 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: gadiyar@ti.com, List Linux Kernel <linux-kernel@vger.kernel.org>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: [PATCH 1/1] mfd: twl4030: clarify the return value for read and write
Date: Mon,  7 Dec 2009 14:17:29 +0200
Message-Id: <449d505b874c236e4d0df0c1f765918386a4d58b.1260187781.git.amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0309DAC23C@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0309DAC23C@dbde02.ent.ti.com>
X-OriginalArrivalTime: 07 Dec 2009 12:17:31.0250 (UTC) FILETIME=[3FE72520:01CA7737]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Infact, we can just return -EIO so that caller knows for sure that all
messages were not tranferred. Please consider fixed patch instead.

We should be checking if all the messages were tranferred or not. And return
-1 for failure. Currently we return success (0) even if none of messages were
transferred successfully.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 drivers/mfd/twl4030-core.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 56f1de5..3d2c413 100644
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
+		return -EIO;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_write);
 
@@ -344,10 +348,14 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
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
+		return -EIO;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_read);
 
-- 
1.6.3.3

