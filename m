Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZDPF5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZDPF5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZDPFzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:54 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:7672
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637AbZDPFzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAMdl5kl8qNY8/2dsb2JhbAAI0B6DfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="419598663"
Subject: [PATCH 8/9] pcf50633: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: sameo@linux.intel.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:55:13 +1000
Message-Id: <1239861313.29831.128.camel@linux-51e8.site>
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
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 7793932..11a6248 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -443,7 +443,7 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 	dev_dbg(pcf->dev, "pcf50633_irq\n");
 
 	get_device(pcf->dev);
-	disable_irq(pcf->irq);
+	disable_irq_nosync(pcf->irq);
 	schedule_work(&pcf->irq_work);
 
 	return IRQ_HANDLED;
-- 
1.6.0.2



