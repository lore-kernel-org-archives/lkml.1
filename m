Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbYKRJVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbYKRJVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYKRJUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:20:45 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:64292 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYKRJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:20:43 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62694870"
From: Bryan Wu <cooloney@kernel.org>
To: bigeasy@linutronix.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Date: Tue, 18 Nov 2008 17:22:11 +0800
Message-Id: <1227000131-19145-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/host/isp1760-hcd.c |   67 ++++++++++++++++++++++++++++-----------
 1 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 8017f1c..00bece2 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -136,12 +136,21 @@ static void priv_read_copy(struct isp1760_hcd *priv, u32 *src,
 		return;
 	}
 
-	while (len >= 4) {
-		*src = __raw_readl(dst);
-		len -= 4;
-		src++;
-		dst++;
-	}
+	if (unlikely((u32)src & 0x3)) {
+		while (len >= 4) {
+			put_unaligned(__raw_readl(dst), src);
+			len -= 4;
+			src++;
+			dst++;
+		}
+	} else {
+		while (len >= 4) {
+			*src = __raw_readl(dst);
+			len -= 4;
+			src++;
+			dst++;
+		}
+	} 
 
 	if (!len)
 		return;
@@ -159,25 +168,45 @@ static void priv_read_copy(struct isp1760_hcd *priv, u32 *src,
 		len--;
 		buff8++;
 	}
+
 }
 
 static void priv_write_copy(const struct isp1760_hcd *priv, const u32 *src,
 		__u32 __iomem *dst, u32 len)
 {
-	while (len >= 4) {
-		__raw_writel(*src, dst);
-		len -= 4;
-		src++;
-		dst++;
-	}
 
-	if (!len)
-		return;
-	/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
-	 * extra bytes should not be read by the HW
-	 */
-
-	__raw_writel(*src, dst);
+	if (unlikely((u32)src & 0x3)) {
+		while (len >= 4) {
+			__raw_writel(get_unaligned(src), dst);
+			len -= 4;
+			src++;
+			dst++;
+		}
+	
+		if (!len)
+			return;
+		/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
+		 * extra bytes should not be read by the HW
+		 */
+	
+		__raw_writel(get_unaligned(src), dst);
+	
+	} else{
+		while (len >= 4) {
+			__raw_writel(*src, dst);
+			len -= 4;
+			src++;
+			dst++;
+		}
+	
+		if (!len)
+			return;
+		/* in case we have 3, 2 or 1 by left. The buffer is allocated and the
+		 * extra bytes should not be read by the HW
+		 */
+	
+		__raw_writel(*src, dst);	
+	}
 }
 
 /* memory management of the 60kb on the chip from 0x1000 to 0xffff */
-- 
1.5.6.3
