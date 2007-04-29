Return-Path: <linux-kernel-owner+w=401wt.eu-S1161303AbXD2VCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303AbXD2VCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXD2VCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:02:37 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48255 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161303AbXD2VCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:02:36 -0400
Message-id: <484326980603325451@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 14/21] Char: cyclades, timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:02:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, timers cleanup

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 86d2bb56b6a8f3c51b7bd537634645fa14862085
tree cfd901e1b728863f734124200ae9ce8220625a24
parent 147542c38691d4e5049b916b083dc93bc3bf8c3b
author Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 16:12:25 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:32 +0200

 drivers/char/cyclades.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9160953..14652c1 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -932,15 +932,9 @@ do_softint(struct work_struct *work)
 	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event))
 		wake_up_interruptible(&info->open_wait);
 #ifdef CONFIG_CYZ_INTR
-	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event)) {
-		if (cyz_rx_full_timer[info->line].function == NULL) {
-			cyz_rx_full_timer[info->line].expires = jiffies + 1;
-			cyz_rx_full_timer[info->line].function = cyz_rx_restart;
-			cyz_rx_full_timer[info->line].data =
-						(unsigned long)info;
-			add_timer(&cyz_rx_full_timer[info->line]);
-		}
-	}
+	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event) &&
+			!timer_pending(&cyz_rx_full_timer[info->line]))
+		mod_timer(&cyz_rx_full_timer[info->line], jiffies + 1);
 #endif
 	if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event))
 		wake_up_interruptible(&info->delta_msr_wait);
@@ -1887,7 +1881,6 @@ static void cyz_rx_restart(unsigned long arg)
 		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
 	}
-	cyz_rx_full_timer[info->line].function = NULL;
 	CY_UNLOCK(info, flags);
 }
 
@@ -4529,8 +4522,8 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo)
 			else
 				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
 #ifdef CONFIG_CYZ_INTR
-			init_timer(&cyz_rx_full_timer[port]);
-			cyz_rx_full_timer[port].function = NULL;
+			setup_timer(&cyz_rx_full_timer[port],
+				cyz_rx_restart, (unsigned long)info);
 #endif
 		} else {
 			info->type = PORT_CIRRUS;
