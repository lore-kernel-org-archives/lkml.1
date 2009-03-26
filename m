Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZCZUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZCZUrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZCZUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:47:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33484 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755033AbZCZUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:47:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] pluto2: silence spew of card hung up messages
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Date: Thu, 26 Mar 2009 20:47:48 +0000
Message-ID: <20090326204741.4796.80285.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the card is ejected on some systems you get a spew of messages as other
shared IRQ devices interrupt between the card eject and the card IRQ
disable.

We don't need to spew them all out

Closes #7472

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/dvb/pluto2/pluto2.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index d101b30..ee89623 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -116,6 +116,7 @@ struct pluto {
 
 	/* irq */
 	unsigned int overflow;
+	unsigned int dead;
 
 	/* dma */
 	dma_addr_t dma_addr;
@@ -336,8 +337,10 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	if (tscr == 0xffffffff) {
-		// FIXME: maybe recover somehow
-		dev_err(&pluto->pdev->dev, "card hung up :(\n");
+		if (pluto->dead == 0)
+			dev_err(&pluto->pdev->dev, "card has hung or been ejected.\n");
+		/* It's dead Jim */
+		pluto->dead = 1;
 		return IRQ_HANDLED;
 	}
 

