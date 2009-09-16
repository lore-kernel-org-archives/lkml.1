Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZIPXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZIPXjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbZIPXju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:39:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45307 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654AbZIPXiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 08/11] USB: musb: clear the Blackfin interrupt pending bits early in the ISR
Date: Wed, 16 Sep 2009 19:38:42 -0400
Message-Id: <1253144325-1203-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

If we clear the interrupt pending bits at the end, we sometimes return too
fast and have the same interrupt assert itself.  There is no way in a
Blackfin system to force a sync of this state, so the hardware manual
instructs people to clear interrupt flags early in their ISR.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/musbhsdma.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index 5e83f96..c767387 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -259,6 +259,11 @@ static irqreturn_t dma_controller_irq(int irq, void *private_data)
 	if (!int_hsdma)
 		goto done;
 
+#ifdef CONFIG_BLACKFIN
+	/* Clear DMA interrupt flags */
+	musb_writeb(mbase, MUSB_HSDMA_INTR, int_hsdma);
+#endif
+
 	for (bchannel = 0; bchannel < MUSB_HSDMA_CHANNELS; bchannel++) {
 		if (int_hsdma & (1 << bchannel)) {
 			musb_channel = (struct musb_dma_channel *)
@@ -324,11 +329,6 @@ static irqreturn_t dma_controller_irq(int irq, void *private_data)
 		}
 	}
 
-#ifdef CONFIG_BLACKFIN
-	/* Clear DMA interrup flags */
-	musb_writeb(mbase, MUSB_HSDMA_INTR, int_hsdma);
-#endif
-
 	retval = IRQ_HANDLED;
 done:
 	spin_unlock_irqrestore(&musb->lock, flags);
-- 
1.6.5.rc1

