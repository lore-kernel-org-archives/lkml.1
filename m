Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0BVSL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:57 -0500
Received: from smtp.nokia.com ([192.100.122.233]:26293 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0BVSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:53 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "Richard Russon (FlatCap)" <ldm@flatcap.org>
Subject: [PATCH 09/11] fs: ldm: don't use own implementation of hex_to_bin()
Date: Mon, 22 Feb 2010 20:09:08 +0200
Message-Id: <1592c1379a6fda43140d113bb8001badce461bd9.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1c143f904aaf005e81f1adf057d8c8df8b6ea294.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <1c143f904aaf005e81f1adf057d8c8df8b6ea294.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:35.0204 (UTC) FILETIME=[5454C040:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by starter patch in the series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
---
 fs/partitions/ldm.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 8652fb9..cb445fb 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/stringify.h>
+#include <linux/kernel.h>
 #include "ldm.h"
 #include "check.h"
 #include "msdos.h"
@@ -77,17 +78,16 @@ static int ldm_parse_hexbyte (const u8 *src)
 	int h;
 
 	/* high part */
-	if      ((x = src[0] - '0') <= '9'-'0') h = x;
-	else if ((x = src[0] - 'a') <= 'f'-'a') h = x+10;
-	else if ((x = src[0] - 'A') <= 'F'-'A') h = x+10;
-	else return -1;
-	h <<= 4;
+	x = h = hex_to_bin(src[0]);
+	if (h < 0)
+		return -1;
 
 	/* low part */
-	if ((x = src[1] - '0') <= '9'-'0') return h | x;
-	if ((x = src[1] - 'a') <= 'f'-'a') return h | (x+10);
-	if ((x = src[1] - 'A') <= 'F'-'A') return h | (x+10);
-	return -1;
+	h = hex_to_bin(src[1]);
+	if (h < 0)
+		return -1;
+
+	return (x << 4) + h;
 }
 
 /**
-- 
1.5.6.5

