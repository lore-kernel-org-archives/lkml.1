Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXJDEOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXJDEOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXJDEOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:14:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11533 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXJDEOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:14:15 -0400
Date: Wed, 03 Oct 2007 22:13:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/3] Sysace: Don't enable IRQ until after interrupt handler is
	registered
In-reply-to: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-id: <20071004041328.20868.98483.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The previous patch to move the interrupt handler registration moved it
below enabling interrupts which could be a problem if the device is on
a shared interrupt line.  This patch fixes the order.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 5b73471..9e7652d 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1005,11 +1005,6 @@ static int __devinit ace_setup(struct ace_device *ace)
 	ace_out(ace, ACE_CTRL, ACE_CTRL_FORCECFGMODE |
 		ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ);
 
-	/* Enable interrupts */
-	val = ace_in(ace, ACE_CTRL);
-	val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
-	ace_out(ace, ACE_CTRL, val);
-
 	/* Now we can hook up the irq handler */
 	if (ace->irq != NO_IRQ) {
 		rc = request_irq(ace->irq, ace_interrupt, 0, "systemace", ace);
@@ -1020,6 +1015,11 @@ static int __devinit ace_setup(struct ace_device *ace)
 		}
 	}
 
+	/* Enable interrupts */
+	val = ace_in(ace, ACE_CTRL);
+	val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
+	ace_out(ace, ACE_CTRL, val);
+
 	/* Print the identification */
 	dev_info(ace->dev, "Xilinx SystemACE revision %i.%i.%i\n",
 		 (version >> 12) & 0xf, (version >> 8) & 0x0f, version & 0xff);

