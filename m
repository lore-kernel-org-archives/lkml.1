Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600Ab0BZRhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:51 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39718 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965521Ab0BZRhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:37:46 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 12:37:45 EST
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com
Subject: [PATCH 1/7] mmc: at91_mci: fix pointer errors
Date: Fri, 26 Feb 2010 19:39:29 +0100
Message-Id: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Fixes two pointer errors, one which leads to memory overwrites if used with
large chunks of data.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 63924e0..6835104 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -227,11 +227,13 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 			for (index = 0; index < (amount / 4); index++)
 				*dmabuf++ = swab32(sgbuffer[index]);
 		} else {
-			memcpy(dmabuf, sgbuffer, amount);
-			dmabuf += amount;
+			char *tmpv = (char *)dmabuf;
+			memcpy(tmpv, sgbuffer, amount);
+			tmpv += amount;
+			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
 
 		if (size == 0)
 			break;
-- 
1.5.6.5

