Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZCQSiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZCQSiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZCQSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:37:59 -0400
Received: from mout3.freenet.de ([195.4.92.93]:56056 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZCQSh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:37:58 -0400
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] r8169: Fix irq masking in rtl8169_interrupt()
Date: Tue, 17 Mar 2009 19:37:53 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903171937.53401.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Only adjust the NAPI bits of the interruptmask, if netif_rx_schedule_prep()
returns true.
Without this, I see interrupt storms here using 2.6.29-rcx and 2.6.27.19 and
device needed rmmod r8169 + modprobe r8169 to start working.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 drivers/net/r8169.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b347340..0c943ba 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3708,12 +3708,11 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 		rtl8169_check_link_status(dev, tp, ioaddr);
 
 	if (status & tp->napi_event) {
-		RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
-		tp->intr_mask = ~tp->napi_event;
-
-		if (likely(netif_rx_schedule_prep(&tp->napi)))
+		if (likely(netif_rx_schedule_prep(&tp->napi))) {
+			RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
+			tp->intr_mask = ~tp->napi_event;
 			__netif_rx_schedule(&tp->napi);
-		else if (netif_msg_intr(tp)) {
+		} else if (netif_msg_intr(tp)) {
 			printk(KERN_INFO "%s: interrupt %04x in poll\n",
 			       dev->name, status);
 		}
-- 
1.6.0.6

