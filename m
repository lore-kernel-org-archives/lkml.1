Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYJVRov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYJVRov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYJVRf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:35:28 -0400
Received: from kroah.org ([198.145.64.141]:50442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755500AbYJVRf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:35:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Lior Dotan <liodot@gmail.com>
Subject: [PATCH 32/42] Staging: SLICOSS: Free multicast list at driver exit
Date: Wed, 22 Oct 2008 10:29:13 -0700
Message-Id: <1224696563-5170-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lior Dotan <liodot@gmail.com>

The multicast address list is allocated in slic_mcast_add_list() but
never freed.

Signed-off-by: Lior Dotan <liodot@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 6ef9274..8fa9490 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -596,6 +596,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 	uint mmio_len = 0;
 	struct adapter *adapter = (struct adapter *) netdev_priv(dev);
 	struct sliccard *card;
+	struct mcast_address *mcaddr, *mlist;
 
 	ASSERT(adapter);
 	DBG_MSG("slicoss: %s ENTER dev[%p] adapter[%p]\n", __func__, dev,
@@ -615,6 +616,13 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 	DBG_MSG("slicoss: %s iounmap dev->base_addr[%x]\n", __func__,
 		(uint) dev->base_addr);
 	iounmap((void __iomem *)dev->base_addr);
+	/* free multicast addresses */
+	mlist = adapter->mcastaddrs;
+	while (mlist) {
+		mcaddr = mlist;
+		mlist = mlist->next;
+		kfree(mcaddr);
+	}
 	ASSERT(adapter->card);
 	card = adapter->card;
 	ASSERT(card->adapters_allocated);
-- 
1.6.0.2

