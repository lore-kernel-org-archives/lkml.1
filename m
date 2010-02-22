Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0BVSLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:22 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27401 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0BVSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:15 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [PATCH 03/11] drivers: net: optimize hex2bin()
Date: Mon, 22 Feb 2010 20:09:02 +0200
Message-Id: <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:34.0564 (UTC) FILETIME=[53F31840:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
hex_to_bin() implementation introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
---
 drivers/net/ps3_gelic_wireless.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 227b141..43e9688 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1394,23 +1394,19 @@ static int gelic_wl_get_mode(struct net_device *netdev,
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

