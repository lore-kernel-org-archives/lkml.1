Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZHKMEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZHKMEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZHKMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:04:33 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:48663 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZHKMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:04:32 -0400
From: Martyn Welch <martyn.welch@gefanuc.com>
Subject: [PATCH] Staging: vme: Add syncronize interrupts before removing
	callback
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Date: Tue, 11 Aug 2009 11:01:38 +0100
Message-ID: <20090811095845.16943.54345.stgit@ES-J7S4D2J.amer.consind.ge.com>
In-Reply-To: <4A7D1CD7.2010200@gmail.com>
References: <4A7D1CD7.2010200@gmail.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As identified by Jiri, there is no syncronisation before callback is removed.

Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
---

Jiri: Thanks once again. The pointer is checked before it is called, but I guess
their is a slim chance that we could try to jump to a null pointer, so this probably
makes sense.


 drivers/staging/vme/bridges/vme_tsi148.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index cdc2919..e4bf430 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -480,6 +480,7 @@ int tsi148_request_irq(int level, int statid,
 void tsi148_free_irq(int level, int statid)
 {
 	u32 tmp;
+	struct pci_dev pdev;
 
 	/* Get semaphore */
 	down(&(vme_irq));
@@ -495,6 +496,10 @@ void tsi148_free_irq(int level, int statid)
 		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
 		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
 		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
+
+		pdev = container_of(tsi148_bridge->parent, struct pci_dev, dev);
+
+		synchronize_irq(pdev->irq);
 	}
 
 	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;
