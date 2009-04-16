Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbZDPF5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbZDPF5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZDPFz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:57 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:7672
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbZDPFz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAMdl5kl8qNY8/2dsb2JhbAAI0B6DfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="419598763"
Subject: [PATCH 9/9] omap mmc host: Use disable_irq_nosync() from within
	irq handlers.
From: Ben Nizette <bn@niasdigital.com>
To: linux-omap@vger.kernel.org
Cc: pierre@ossman.eu, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:55:21 +1000
Message-Id: <1239861321.29831.130.camel@linux-51e8.site>
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
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 5570849..d5ea652 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -824,7 +824,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		del_timer(&host->cmd_abort_timer);
 		host->abort = 1;
 		OMAP_MMC_WRITE(host, IE, 0);
-		disable_irq(host->irq);
+		disable_irq_nosync(host->irq);
 		schedule_work(&host->cmd_abort_work);
 		return IRQ_HANDLED;
 	}
-- 
1.6.0.2



