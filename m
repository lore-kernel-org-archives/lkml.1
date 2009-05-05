Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZEEKJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZEEKJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZEEKJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:09:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:59766 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZEEKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:09:35 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] isl29003: fix resume functionality
Date: Tue,  5 May 2009 12:09:25 +0200
Message-Id: <1241518165-12469-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The isl29003 does not interpret the return value of
i2c_smbus_write_byte_data() correctly and hence causes an error on
system resume.

Also introduce power_state_before_suspend and restore the chip's power
state upon wakeup.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/misc/isl29003.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index 2e2a592..a71e245 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -64,6 +64,7 @@ struct isl29003_data {
 	struct i2c_client *client;
 	struct mutex lock;
 	u8 reg_cache[ISL29003_NUM_CACHABLE_REGS];
+	u8 power_state_before_suspend;
 };
 
 static int gain_range[] = {
@@ -411,6 +412,9 @@ static int __devexit isl29003_remove(struct i2c_client *client)
 #ifdef CONFIG_PM
 static int isl29003_suspend(struct i2c_client *client, pm_message_t mesg)
 {
+	struct isl29003_data *data = i2c_get_clientdata(client);
+
+	data->power_state_before_suspend = isl29003_get_power_state(client);
 	return isl29003_set_power_state(client, 0);
 }
 
@@ -421,10 +425,11 @@ static int isl29003_resume(struct i2c_client *client)
 
 	/* restore registers from cache */
 	for (i = 0; i < ARRAY_SIZE(data->reg_cache); i++)
-		if (!i2c_smbus_write_byte_data(client, i, data->reg_cache[i]))
+		if (i2c_smbus_write_byte_data(client, i, data->reg_cache[i]))
 			return -EIO;
 
-	return 0;
+	return isl29003_set_power_state(client,
+		data->power_state_before_suspend);
 }
 
 #else
-- 
1.6.2.1

