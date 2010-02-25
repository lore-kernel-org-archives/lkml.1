Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab0BYTju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:39:50 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:10364 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab0BYTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:39:47 -0500
X-Spam-Processed: digidescorp.com, Thu, 25 Feb 2010 13:39:46 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1672ac1db0=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Li Yang <leoli@freescale.com>
Cc: Zhang Wei <zw@zh-kernel.org>, Dan Williams <dan.j.williams@intel.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [async_tx-next PATCH v2 2/2] fsldma: Fix cookie issues
Date: Thu, 25 Feb 2010 13:39:37 -0600
Message-Id: <1267126777-21520-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsl_dma_update_completed_cookie() appears to calculate the last completed
cookie incorrectly in the corner case where DMA on cookie 1 is in progress
just following a cookie wrap.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c	2010-02-22 11:16:36.000000000 -0600
+++ b/drivers/dma/fsldma.c	2010-02-22 11:08:41.000000000 -0600
@@ -819,8 +819,11 @@ static void fsl_dma_update_completed_coo
 	desc = to_fsl_desc(chan->ld_running.prev);
 	if (dma_is_idle(chan))
 		cookie = desc->async_tx.cookie;
-	else
+	else {
 		cookie = desc->async_tx.cookie - 1;
+		if (unlikely(cookie < DMA_MIN_COOKIE))
+			cookie = DMA_MAX_COOKIE;
+	}
 
 	chan->completed_cookie = cookie;
 
diff -uprN a/include/linux/dmaengine.h b/include/linux/dmaengine.h
--- a/include/linux/dmaengine.h	2010-02-22 11:18:11.000000000 -0600
+++ b/include/linux/dmaengine.h	2010-02-22 11:18:30.000000000 -0600
@@ -31,6 +31,8 @@
  * if dma_cookie_t is >0 it's a DMA request cookie, <0 it's an error code
  */
 typedef s32 dma_cookie_t;
+#define DMA_MIN_COOKIE	1
+#define DMA_MAX_COOKIE	((1 << 31) - 1)
 
 #define dma_submit_error(cookie) ((cookie) < 0 ? 1 : 0)
 

