Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbZLPSUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbZLPSUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbZLPSUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:20:08 -0500
Received: from smtp.nokia.com ([192.100.105.134]:55820 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbZLPSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:20:06 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org
Subject: [PATCH] mfd: twl4030-irq: irq_desc->lock converted to raw_spinlock_t
Date: Wed, 16 Dec 2009 20:18:50 +0200
Message-Id: <1260987530-20221-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
X-OriginalArrivalTime: 16 Dec 2009 18:19:25.0213 (UTC) FILETIME=[4C26B4D0:01CA7E7C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 239007b8440abff689632f50cdf0f2b9e895b534 converted
the spinlock_t to raw_spinlock_t. Unfortunately twl4030-irq
was left aside on the conversion.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgre <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---

I'm not sure this is the expected fix since twl4030-irq handler
should be running in thread context. Currently mask/unmask/set_type
are deferred to a workqueue. Thomas, should this be done ? How
do you expect irq chips on slow busses to implement mask/unmask/set_type ?

 drivers/mfd/twl4030-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 20d29ba..9df9a5a 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -568,12 +568,12 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 
 		bytes[byte] &= ~(0x03 << off);
 
-		spin_lock_irq(&d->lock);
+		raw_spin_lock_irq(&d->lock);
 		if (d->status & IRQ_TYPE_EDGE_RISING)
 			bytes[byte] |= BIT(off + 1);
 		if (d->status & IRQ_TYPE_EDGE_FALLING)
 			bytes[byte] |= BIT(off + 0);
-		spin_unlock_irq(&d->lock);
+		raw_spin_unlock_irq(&d->lock);
 
 		edge_change &= ~BIT(i);
 	}
-- 
1.6.6.rc0

