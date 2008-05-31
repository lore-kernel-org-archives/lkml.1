Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYFEJ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYFEJ47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYFEJx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:53:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbYFEJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:53:27 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 31 May 2008 15:20:37 +0300
Subject: [PATCH 11/18] ihex: request_ihex_firmware() function to load and validate firmware
Message-Id: <E1K4C9v-0001dG-6u@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a helper to load the file and validate it in one call, to
simplify error handling in the drivers which are going to use it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 include/linux/ihex.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/ihex.h b/include/linux/ihex.h
index 3da4855..2f3d8b4 100644
--- a/include/linux/ihex.h
+++ b/include/linux/ihex.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/firmware.h>
+#include <linux/device.h>
 
 struct ihex_binrec {
 	__be32 addr;
@@ -41,4 +42,27 @@ static inline int ihex_validate_fw(const struct firmware *fw)
 	}
 	return 0;
 }
+
+/* Request firmware and validate it so that we can trust we won't
+ * run off the end while reading records... */
+static inline int request_ihex_firmware(const struct firmware **fw,
+					const char *fw_name,
+					struct device *dev)
+{
+	const struct firmware *lfw;
+	int ret;
+
+	ret = request_firmware(&lfw, fw_name, dev);
+	if (ret)
+		return ret;
+	ret = ihex_validate_fw(lfw);
+	if (ret) {
+		dev_err(dev, "Firmware \"%s\" not valid IHEX records\n",
+			fw_name);
+		release_firmware(lfw);
+		return ret;
+	}
+	*fw = lfw;
+	return 0;
+}
 #endif /* __LINUX_IHEX_H__ */
-- 
1.5.4.5

