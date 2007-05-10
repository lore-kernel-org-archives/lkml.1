Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXEJIsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXEJIsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXEJIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:48:05 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:34492 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbXEJIsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:48:03 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: andrew@sanpeople.com
Subject: [PATCH] at91: fix enable/disable_irq_wake symmetry in pcmcia driver
Date: Thu, 10 May 2007 09:52:59 +0200
User-Agent: KMail/1.9.5
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100952.59310.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from Marc Pignat <marc.pignat@hevs.ch>

fix enable_irq_wake and disable_irq_wake symmetry in at91 pcmcia driver

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---
This patch applies to the 2.6.21.1 kernel.

disable_irq_wake call must be symmetric with enable_irq_wake. This patch fix 
that problem for the at91_pcmia driver.
It seems that this patch was forgotten when we've fixed irq_wake symmetry in 
all at91 related drivers.
It was discussed in the "at91 drivers and [enable/disable]_irq_wake (wrong?) 
usage" thread on the linux-arm-kernel mailing list.

Regards

Marc

--- 2.6.21.1/drivers/pcmcia/at91_cf.c.orig	2007-05-10 08:43:16.000000000 +0200
+++ 2.6.21.1/drivers/pcmcia/at91_cf.c	2007-05-10 09:07:06.000000000 +0200
@@ -336,16 +336,18 @@ static int at91_cf_suspend(struct platfo
 		enable_irq_wake(board->det_pin);
 		if (board->irq_pin)
 			enable_irq_wake(board->irq_pin);
-	} else {
-		disable_irq_wake(board->det_pin);
-		if (board->irq_pin)
-			disable_irq_wake(board->irq_pin);
 	}
 	return 0;
 }

 static int at91_cf_resume(struct platform_device *pdev)
 {
+	if (device_may_wakeup(&pdev->dev)) {
+		disable_irq_wake(board->det_pin);
+		if (board->irq_pin)
+			disable_irq_wake(board->irq_pin);
+	}
+
 	pcmcia_socket_dev_resume(&pdev->dev);
 	return 0;
 }

