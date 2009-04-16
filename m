Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZDPFzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZDPFzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZDPFym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:54:42 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:64070
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbZDPFyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:54:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAJxk5kl8qNY8/2dsb2JhbAAI0BuDfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="467881295"
Subject: [PATCH 1/9] ipu_idmac: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: dan.j.williams@intel.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:12 +1000
Message-Id: <1239861252.29831.114.camel@linux-51e8.site>
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

Note the 2 handlers in question are only used #ifdef DEBUG so
I imagine these code paths don't get hit often.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index e202a6c..3a4deea 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1547,7 +1547,7 @@ static irqreturn_t ic_sof_irq(int irq, void *dev_id)
 	struct idmac_channel *ichan = dev_id;
 	printk(KERN_DEBUG "Got SOF IRQ %d on Channel %d\n",
 	       irq, ichan->dma_chan.chan_id);
-	disable_irq(irq);
+	disable_irq_nosync(irq);
 	return IRQ_HANDLED;
 }
 
@@ -1556,7 +1556,7 @@ static irqreturn_t ic_eof_irq(int irq, void *dev_id)
 	struct idmac_channel *ichan = dev_id;
 	printk(KERN_DEBUG "Got EOF IRQ %d on Channel %d\n",
 	       irq, ichan->dma_chan.chan_id);
-	disable_irq(irq);
+	disable_irq_nosync(irq);
 	return IRQ_HANDLED;
 }
 
-- 
1.6.0.2



