Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZBFFCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZBFFCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 00:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZBFFCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 00:02:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:32780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbZBFFCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 00:02:18 -0500
Message-ID: <498BC412.3090900@kernel.org>
Date: Thu, 05 Feb 2009 21:01:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: [PATCH] forcedeth: disable irq at first before schedule rx
References: <498BC3A8.9040203@kernel.org>
In-Reply-To: <498BC3A8.9040203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

schedule it later after disable it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/net/forcedeth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.orig/drivers/net/forcedeth.c
+++ linux-2.6/drivers/net/forcedeth.c
@@ -3708,13 +3708,13 @@ static irqreturn_t nv_nic_irq_rx(int foo
 	u32 events;
 
 	events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_RX_ALL;
-	writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
 
 	if (events) {
-		netif_rx_schedule(&np->napi);
 		/* disable receive interrupts on the nic */
 		writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
 		pci_push(base);
+		writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
+		netif_rx_schedule(&np->napi);
 	}
 	return IRQ_HANDLED;
 }
