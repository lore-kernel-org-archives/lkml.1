Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0BRS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:19 -0500
Received: from smtp.nokia.com ([192.100.105.134]:33998 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab0BRS5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:17 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 06/12] drivers: net: optimize hex2bin()
Date: Thu, 18 Feb 2010 20:55:45 +0200
Message-Id: <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0332 (UTC) FILETIME=[2FAF6040:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
hex_to_bin() implementation introduced by one of previous path in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/net/ps3_gelic_wireless.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 227b141..073d0a0 100644
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
+		*bin++ = (u8)((h << 4) + l);
 	}
 	return 0;
 };
-- 
1.5.6.5

