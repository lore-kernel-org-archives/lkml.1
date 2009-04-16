Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZDPF5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZDPF5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZDPFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:35 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:26626
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbZDPFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBANdk5kl8qNY8/2dsb2JhbAAI0B6DfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="343073512"
Subject: [PATCH] rtc-ds1305: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: p_gortmaker@yahoo.com
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:55:06 +1000
Message-Id: <1239861306.29831.126.camel@linux-51e8.site>
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
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index fc372df..5c4f789 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -514,7 +514,7 @@ static irqreturn_t ds1305_irq(int irq, void *p)
 {
 	struct ds1305		*ds1305 = p;
 
-	disable_irq(irq);
+	disable_irq_nosync(irq);
 	schedule_work(&ds1305->work);
 	return IRQ_HANDLED;
 }
-- 
1.6.0.2



