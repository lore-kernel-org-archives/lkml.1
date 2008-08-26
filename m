Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYHZWqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYHZWqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYHZWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:45:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:26917 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYHZWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nGmDrXFdHCMRBhN7kMDbIl2UOHCrgb7d4XVedXY4ph+NRgkzJEwrKmuXhw3U147sxN
         LiOC4i5rW+XNgZR3BMFCpr+V4PXzlyGXZ0/YrCZPXleAUq+myuKzVAB7fCo/cQmy2FlK
         9+1n6uiwNYnmqmahIj8xNds6yxgNEQ/K7IzN4=
Subject: [PATCH] hwmon: ibmpex.c remove inline wrapper of be16_to_cpup
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 15:45:55 -0700
Message-Id: <1219790755.6069.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse noticed the helper was missing a cast:
drivers/hwmon/ibmpex.c:43:23: warning: incorrect type in argument 1 (different base types)
drivers/hwmon/ibmpex.c:43:23:    expected restricted __be16 const [usertype] *p
drivers/hwmon/ibmpex.c:43:23:    got unsigned short [usertype] *<noident>

Just open-code the helper as it didn't add anything.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/hwmon/ibmpex.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 4e9b19c..abc8fb0 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -38,11 +38,6 @@
 #define PEX_NET_FUNCTION	0x3A
 #define PEX_COMMAND		0x3C
 
-static inline u16 extract_value(const char *data, int offset)
-{
-	return be16_to_cpup((u16 *)&data[offset]);
-}
-
 #define TEMP_SENSOR		1
 #define POWER_SENSOR		2
 
@@ -165,7 +160,7 @@ static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
 		 "v%d.%d %d-%02d-%02d on interface %d\n",
 		 data->sensor_major,
 		 data->sensor_minor,
-		 extract_value(data->rx_msg_data, 2),
+		 be16_to_cpup((__be16 *)&data->rx_msg_data[2]),
 		 data->rx_msg_data[4],
 		 data->rx_msg_data[5],
 		 data->interface);
@@ -247,11 +242,11 @@ static void ibmpex_update_device(struct ibmpex_bmc_data *data)
 		if (err)
 			continue;
 		data->sensors[i].values[0] =
-			extract_value(data->rx_msg_data, 16);
+			be16_to_cpup((__be16 *)&data->rx_msg_data[16]);
 		data->sensors[i].values[1] =
-			extract_value(data->rx_msg_data, 18);
+			be16_to_cpup((__be16 *)&data->rx_msg_data[18]);
 		data->sensors[i].values[2] =
-			extract_value(data->rx_msg_data, 20);
+			be16_to_cpup((__be16 *)&data->rx_msg_data[20]);
 	}
 
 	data->last_updated = jiffies;
-- 
1.6.0.340.g84854



