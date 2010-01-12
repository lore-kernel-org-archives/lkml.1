Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984Ab0ALVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0ALVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 16:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438Ab0ALVic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 16:38:32 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:34488 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0ALVic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 16:38:32 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-i2c@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: do not use device name after device_unregister
Date: Tue, 12 Jan 2010 19:36:43 -0200
Message-Id: <1263332203-5542-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_dbg outputs dev_name, which is released with device_unregister. This bug
resulted in output like this:

[ 7860.470713] i2c Xy2�0: adapter [SMBus I801 adapter at 1880] unregistered

The right output would be:
[   60.639233] i2c i2c-0: adapter [SMBus I801 adapter at 1880] unregistered

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/i2c/i2c-core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 0ac2f90..d5db0f4 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -843,6 +843,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 				 adap->dev.parent);
 #endif
 
+	/* device name is gone after device_unregister */
+	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
+
 	/* clean up the sysfs representation */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -855,8 +858,6 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	idr_remove(&i2c_adapter_idr, adap->nr);
 	mutex_unlock(&core_lock);
 
-	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));
-- 
1.6.5.7

