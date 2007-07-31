Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXGaQIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXGaQIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXGaQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:07:55 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:58286 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046AbXGaQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:07:54 -0400
From: David Vrabel <david.vrabel@csr.com>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@csr.com>, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: sdio: parameterize SDIO FBR register defines
Date: Tue, 31 Jul 2007 16:36:31 +0100
Message-Id: <11858961931710-git-send-email-david.vrabel@csr.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11858961933491-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: david@pear.davidvrabel.org.uk
X-SA-Exim-Scanned: No (on pear.davidvrabel.org.uk); SAEximRunCond expanded to false
X-Originating-Pythagoras-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Vrabel <david.vrabel@csr.com>

---
commit 51755c3d59be1ba778bef45888f9f5e341dc4af4
tree c7bbb562b2d801197eefb619a17c94467c1299cd
parent 1cf0b6019aa3916197eecafe058bd2f3d700d24a
author David Vrabel <david.vrabel@csr.com> Mon, 30 Jul 2007 19:20:59 +0100
committer David Vrabel <dvrabel@cantab.net> Mon, 30 Jul 2007 19:28:30 +0100

 drivers/mmc/core/sdio.c     |    4 ++--
 drivers/mmc/core/sdio_cis.c |    2 +-
 include/linux/mmc/sdio.h    |   16 +++++++++-------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 6589fd6..08f579c 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -30,7 +30,7 @@ static int sdio_read_fbr(struct sdio_func *func)
 	unsigned char data;
 
 	ret = mmc_io_rw_direct(func->card, 0, 0,
-		func->num * 0x100 + SDIO_FBR_STD_IF, 0, &data);
+		SDIO_FBR_STD_IF(func->num), 0, &data);
 	if (ret != MMC_ERR_NONE)
 		goto out;
 
@@ -38,7 +38,7 @@ static int sdio_read_fbr(struct sdio_func *func)
 
 	if (data == 0x0f) {
 		ret = mmc_io_rw_direct(func->card, 0, 0,
-			func->num * 0x100 + SDIO_FBR_STD_IF_EXT, 0, &data);
+			SDIO_FBR_STD_IF_EXT(func->num), 0, &data);
 		if (ret != MMC_ERR_NONE)
 			goto out;
 	}
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index b0c6697..8aa4666 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -215,7 +215,7 @@ int sdio_read_cis(struct sdio_func *func, unsigned int fn)
 	for (i = 0; i < 3; i++) {
 		unsigned char x;
 		ret = mmc_io_rw_direct(func->card, 0, 0,
-				       fn * 0x100 + SDIO_FBR_CIS + i, 0, &x);
+				       SDIO_FBR_CIS(fn) + i, 0, &x);
 		if (ret != MMC_ERR_NONE)
 			return -EIO;
 		ptr |= x << (i * 8);
diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
index 145ce23..e2bda4b 100644
--- a/include/linux/mmc/sdio.h
+++ b/include/linux/mmc/sdio.h
@@ -132,26 +132,28 @@
  * Function Basic Registers (FBR)
  */
 
-#define SDIO_FBR_STD_IF		0x00
+#define __SDIO_FBR(f, r)	((f) * 0x100 + (r))
+
+#define SDIO_FBR_STD_IF(f)	__SDIO_FBR((f), 0x00)
 
 #define  SDIO_FBR_SUPPORTS_CSA	0x40	/* supports Code Storage Area */
 #define  SDIO_FBR_ENABLE_CSA	0x80	/* enable Code Storage Area */
 
-#define SDIO_FBR_STD_IF_EXT	0x01
+#define SDIO_FBR_STD_IF_EXT(f)	__SDIO_FBR((f), 0x01)
 
-#define SDIO_FBR_POWER		0x02
+#define SDIO_FBR_POWER(f)	__SDIO_FBR((f), 0x02)
 
 #define  SDIO_FBR_POWER_SPS	0x01	/* Supports Power Selection */
 #define  SDIO_FBR_POWER_EPS	0x02	/* Enable (low) Power Selection */
 
-#define SDIO_FBR_CIS		0x09	/* CIS pointer (3 bytes) */
+#define SDIO_FBR_CIS(f)		__SDIO_FBR((f), 0x09) /* CIS pointer (3 bytes) */
 
 
-#define SDIO_FBR_CSA		0x0C	/* CSA pointer (3 bytes) */
+#define SDIO_FBR_CSA(f)		__SDIO_FBR((f), 0x0C) /* CSA pointer (3 bytes) */
 
-#define SDIO_FBR_CSA_DATA	0x0F
+#define SDIO_FBR_CSA_DATA(f)	__SDIO_FBR((f), 0x0F)
 
-#define SDIO_FBR_BLKSIZE	0x10	/* block size (2 bytes) */
+#define SDIO_FBR_BLKSIZE(f)	__SDIO_FBR((f), 0x10) /* block size (2 bytes) */
 
 #endif
 
