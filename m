Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZBJJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZBJJbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZBJJbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:31:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64972 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBJJbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:31:10 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dmaengine: Fix oops on dmatest module unload.
Date: Tue, 10 Feb 2009 10:31:03 +0100
Message-Id: <1234258263-1805-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.5.6.5
X-Provags-ID: V01U2FsdGVkX1/NN4HFYsZwHYl2oa93SoANzefF4zPAJsdSCVd
 Kgy0QgazcVTp5LgNxflS25seMFVV8Im74QDryvWxg9CaLcjVh7
 /gw6WOrkNiR1H06gtyz0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an oops that happens when the dmatest module is unloaded. The
dma_release_channel() function is called on channels that have already been
cleaned up (and therefore freed) with dmatest_cleanup_channel().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 732fa1e..d12219c 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -433,10 +433,10 @@ static void __exit dmatest_exit(void)
 
 	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
 		list_del(&dtc->node);
+		dma_release_channel(dtc->chan);
 		dmatest_cleanup_channel(dtc);
 		pr_debug("dmatest: dropped channel %s\n",
 			 dma_chan_name(dtc->chan));
-		dma_release_channel(dtc->chan);
 	}
 }
 module_exit(dmatest_exit);
-- 
tg: (8e49215..) adx/dma (depends on: adx/master)
