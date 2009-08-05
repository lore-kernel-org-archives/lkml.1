Return-Path: <linux-kernel-owner+w=401wt.eu-S964819AbZHEQh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbZHEQh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934490AbZHEQhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:37:55 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:57188 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934623AbZHEQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:37:54 -0400
From: Martyn Welch <martyn.welch@gefanuc.com>
Subject: [PATCH v2] Staging: Correct tsi-148 VME interrupt free routine
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       jirislaby@gmail.com
Date: Wed, 05 Aug 2009 17:38:31 +0100
Message-ID: <20090805163802.28044.91999.stgit@ES-J7S4D2J.amer.consind.ge.com>
In-Reply-To: <20090805163219.4903.43629.stgit@ES-J7S4D2J.amer.consind.ge.com>
References: <20090805163219.4903.43629.stgit@ES-J7S4D2J.amer.consind.ge.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As identified by Jiri, the VME interrupt free routine removes the service
routine before disabling the interrupt. Re-order operations to be performed in
the reverse of the request routine.

Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
---

v2: Remember "Signed-off-by"...

 drivers/staging/vme/bridges/vme_tsi148.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index ad6fc2d..cdc2919 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -484,21 +484,22 @@ void tsi148_free_irq(int level, int statid)
 	/* Get semaphore */
 	down(&(vme_irq));
 
-	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;
-	tsi148_bridge->irq[level - 1].callback[statid].priv_data = NULL;
 	tsi148_bridge->irq[level - 1].count--;
 
-	/* Disable IRQ level */
+	/* Disable IRQ level if no more interrupts attached at this level*/
 	if (tsi148_bridge->irq[level - 1].count == 0) {
-		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
-		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
-		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
-
 		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEN);
 		tmp &= ~TSI148_LCSR_INTEN_IRQEN[level - 1];
 		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEN);
+
+		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
+		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
+		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
 	}
 
+	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;
+	tsi148_bridge->irq[level - 1].callback[statid].priv_data = NULL;
+
 	/* Release semaphore */
 	up(&(vme_irq));
 }
