Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0CBIAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:00:55 -0500
Received: from smtp.nokia.com ([192.100.122.233]:55226 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0CBIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:00:54 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [PATCHv2] drivers: net: optimize hex2bin()
Date: Tue,  2 Mar 2010 09:59:26 +0200
Message-Id: <1267516766-25977-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4B8C485A.8000409@am.sony.com>
References: <4B8C485A.8000409@am.sony.com>
X-OriginalArrivalTime: 02 Mar 2010 08:00:41.0492 (UTC) FILETIME=[74156D40:01CAB9DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
hex_to_bin() implementation introduced by starter patch [1] in series.

[1] http://patchwork.kernel.org/patch/81224/

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
---
 drivers/net/ps3_gelic_wireless.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 227b141..7c3d7f1 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1394,23 +1394,20 @@ static int gelic_wl_get_mode(struct net_device *netdev,
 static int hex2bin(u8 *str, u8 *bin, unsigned int len)
 {
 	unsigned int i;
-	static unsigned char *hex = "0123456789ABCDEF";
-	unsigned char *p, *q;
-	u8 tmp;
 
 	if (len != WPA_PSK_LEN * 2)
 		return -EINVAL;
 
 	for (i = 0; i < WPA_PSK_LEN * 2; i += 2) {
-		p = strchr(hex, toupper(str[i]));
-		q = strchr(hex, toupper(str[i + 1]));
-		if (!p || !q) {
+		int h = hex_to_bin(str[i]);
+		int l = hex_to_bin(str[i+1]);
+
+		if ((h == -1) || (l == -1)) {
 			pr_info("%s: unconvertible PSK digit=%d\n",
 				__func__, i);
 			return -EINVAL;
 		}
-		tmp = ((p - hex) << 4) + (q - hex);
-		*bin++ = tmp;
+		*bin++ = (h << 4) + l;
 	}
 	return 0;
 };
-- 
1.5.6.5

