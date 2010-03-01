Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0CAKx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:53:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0CAKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:53:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/6] mfd/mc13783: new function reading irq mask and status register
Date: Mon,  1 Mar 2010 11:53:43 +0100
Message-Id: <1267440825-14694-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for the mc13783 rtc needs to know if the TODA irq is pending.

Instead of tracking in the rtc driver if the irq is enabled provide that
information, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c  |   35 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/mc13783.h |    2 ++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index f89d12d..2a5334a 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -269,6 +269,41 @@ int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
 }
 EXPORT_SYMBOL(mc13783_irq_unmask);
 
+int mc13783_irq_status(struct mc13783 *mc13783, int irq,
+		int *enabled, int *pending)
+{
+	int ret;
+	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
+	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+
+	if (irq < 0 || irq >= MC13783_NUM_IRQ)
+		return -EINVAL;
+
+	if (enabled) {
+		u32 mask;
+
+		ret = mc13783_reg_read(mc13783, offmask, &mask);
+		if (ret)
+			return ret;
+
+		*enabled = mask & irqbit;
+	}
+
+	if (pending) {
+		u32 stat;
+
+		ret = mc13783_reg_read(mc13783, offstat, &stat);
+		if (ret)
+			return ret;
+
+		*pending = stat & irqbit;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13783_irq_status);
+
 int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
 {
 	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 05619f0..9d1dbc9 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -29,6 +29,8 @@ int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev);
 
 int mc13783_irq_mask(struct mc13783 *mc13783, int irq);
 int mc13783_irq_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_status(struct mc13783 *mc13783, int irq,
+		int *enabled, int *pending);
 int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
 
 static inline int mc13783_mask(struct mc13783 *mc13783, int irq) __deprecated;
-- 
1.7.0

