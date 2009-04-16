Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZDPF4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZDPF4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZDPFz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:27 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:64546
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207AbZDPFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAJxk5kl8qNY8/2dsb2JhbAAI0BuDfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="467881930"
Subject: [PATCH 6/9] ucb1400: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:58 +1000
Message-Id: <1239861298.29831.124.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


disable_irq() should wait for all running handlers to complete
before returning.  As such, if it's used to disable an interrupt
from that interrupt's handler it will deadlock.  This replaces
the dangerous instances with the _nosync() variant which doesn't
have this problem.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index e868264..f100c7f 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -256,7 +256,7 @@ static irqreturn_t ucb1400_hard_irq(int irqnr, void *devid)
 	struct ucb1400_ts *ucb = devid;
 
 	if (irqnr == ucb->irq) {
-		disable_irq(ucb->irq);
+		disable_irq_nosync(ucb->irq);
 		ucb->irq_pending = 1;
 		wake_up(&ucb->ts_wait);
 		return IRQ_HANDLED;
-- 
1.6.0.2



