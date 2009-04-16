Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZDPF4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZDPF4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZDPFzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:55:11 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:64304
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959AbZDPFzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:55:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkBAJxk5kl8qNY8/2dsb2JhbAAIkUC+W4N9Bg
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="467881704"
Subject: [PATCH 4/9] sa1111ps2: Use disable_irq_nosync() from within irq
	handlers.
From: Ben Nizette <bn@niasdigital.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:43 +1000
Message-Id: <1239861283.29831.120.camel@linux-51e8.site>
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
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 57953c0..f412c69 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -77,7 +77,7 @@ static irqreturn_t ps2_txint(int irq, void *dev_id)
 	spin_lock(&ps2if->lock);
 	status = sa1111_readl(ps2if->base + SA1111_PS2STAT);
 	if (ps2if->head == ps2if->tail) {
-		disable_irq(irq);
+		disable_irq_nosync(irq);
 		/* done */
 	} else if (status & PS2STAT_TXE) {
 		sa1111_writel(ps2if->buf[ps2if->tail], ps2if->base + SA1111_PS2DATA);
-- 
1.6.0.2



