Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbZINFSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbZINFSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZINFSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:18:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56540 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZINFSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:18:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] Revert "[Bluetooth] Eliminate checks for impossible conditions in IRQ handler"
Date: Mon, 14 Sep 2009 01:18:24 -0400
Message-Id: <1252905504-26666-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac019360fe3 changed the irq handler logic to BUG_ON rather than
returning IRQ_NONE when the incoming argument is invalid.  While this
works in most cases, it doesn't work when the IRQ is shared with other
devices (or when DEBUG_SHIRQ is enabled).

So revert the previous change and replace the warning message with a
comment.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/bluetooth/bluecard_cs.c |    4 +++-
 drivers/bluetooth/bt3c_cs.c     |    4 +++-
 drivers/bluetooth/btuart_cs.c   |    4 +++-
 drivers/bluetooth/dtl1_cs.c     |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index b0e569b..a3a8f4d 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -503,7 +503,9 @@ static irqreturn_t bluecard_interrupt(int irq, void *dev_inst)
 	unsigned int iobase;
 	unsigned char reg;
 
-	BUG_ON(!info->hdev);
+	if (!info || !info->hdev)
+		/* our irq handler is shared */
+		return IRQ_NONE;
 
 	if (!test_bit(CARD_READY, &(info->hw_state)))
 		return IRQ_HANDLED;
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index d58e22b..9a7578e 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -345,7 +345,9 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 	int iir;
 	irqreturn_t r = IRQ_NONE;
 
-	BUG_ON(!info->hdev);
+	if (!info || !info->hdev)
+		/* our irq handler is shared */
+		return IRQ_NONE;
 
 	iobase = info->p_dev->io.BasePort1;
 
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index efd689a..cd9cb6c 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -295,7 +295,9 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 	int iir, lsr;
 	irqreturn_t r = IRQ_NONE;
 
-	BUG_ON(!info->hdev);
+	if (!info || !info->hdev)
+		/* our irq handler is shared */
+		return IRQ_NONE;
 
 	iobase = info->p_dev->io.BasePort1;
 
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 2cc7b32..588678a 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -299,7 +299,9 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 	int iir, lsr;
 	irqreturn_t r = IRQ_NONE;
 
-	BUG_ON(!info->hdev);
+	if (!info || !info->hdev)
+		/* our irq handler is shared */
+		return IRQ_NONE;
 
 	iobase = info->p_dev->io.BasePort1;
 
-- 
1.6.4.2

