Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYEPGGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYEPGGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYEPGGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:06:02 -0400
Received: from mail.windriver.com ([147.11.1.11]:62772 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYEPGF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:05:57 -0400
Subject: [PATCH] x86: Get irq for hpet timer
From: Kevin Hao <kexin.hao@windriver.com>
To: venkatesh.pallipadi@intel.com, clemens@ladisch.de, bob.picco@hp.com,
       mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 May 2008 14:05:12 +0800
Message-Id: <1210917912.10881.1.camel@kevin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 06:04:59.0954 (UTC) FILETIME=[C6088920:01C8B71A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi,

x86: get irq for hpet timer
    
HPET timer's IRQ is 0 by default, so we have to select which irq
will be used for these timers. We wait to set the timer's irq until
we really turn on interrupt in order to reduce the chance of
conflicting with some legacy device.
    
Signed-off-by: Kevin Hao <kexin.hao@windriver.com>

---
 drivers/char/hpet.c  |   62 +++++++++++++++++++++++++++++++++++++------------
 include/linux/hpet.h |    3 +-
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e7fb0bc..67714c2 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -383,6 +383,51 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
 
+static int hpet_timer_get_irq(struct hpet_dev *devp)
+{
+	struct hpet_timer __iomem *timer;
+	struct hpet __iomem *hpet;
+	struct hpets *hpetp;
+	unsigned long cap, irq_flags;
+	int irq;
+
+	timer = devp->hd_timer;
+	hpet = devp->hd_hpet;
+	hpetp = devp->hd_hpets;
+
+	irq = devp->hd_hdwirq;
+
+	sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
+	irq_flags = devp->hd_flags & HPET_SHARED_IRQ
+					? IRQF_SHARED : IRQF_DISABLED;
+	if (irq) {
+		if (request_irq(irq, hpet_interrupt, irq_flags,
+				devp->hd_name, (void *)devp)) {
+			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
+			irq = 0;
+		}
+		return irq;
+	}
+
+	cap = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK)
+				 >> Tn_INT_ROUTE_CAP_SHIFT;
+
+	for (irq = find_first_bit(&cap, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
+		irq = find_next_bit(&cap, HPET_MAX_IRQ, 1 + irq)) {
+		if (request_irq(irq, hpet_interrupt, irq_flags,
+				devp->hd_name, (void *)devp)) {
+			printk(KERN_WARNING "hpet: IRQ %d is not free\n", irq);
+			continue;
+		}
+		break;
+	}
+
+	if  (irq >= HPET_MAX_IRQ)
+		irq = 0;
+
+	return irq;
+}
+
 static int hpet_ioctl_ieon(struct hpet_dev *devp)
 {
 	struct hpet_timer __iomem *timer;
@@ -412,21 +457,7 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		devp->hd_flags |= HPET_SHARED_IRQ;
 	spin_unlock_irq(&hpet_lock);
 
-	irq = devp->hd_hdwirq;
-
-	if (irq) {
-		unsigned long irq_flags;
-
-		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
-		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
-						? IRQF_SHARED : IRQF_DISABLED;
-		if (request_irq(irq, hpet_interrupt, irq_flags,
-				devp->hd_name, (void *)devp)) {
-			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
-			irq = 0;
-		}
-	}
-
+	irq = hpet_timer_get_irq(devp);
 	if (irq == 0) {
 		spin_lock_irq(&hpet_lock);
 		devp->hd_flags ^= HPET_IE;
@@ -438,6 +469,7 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	t = devp->hd_ireqfreq;
 	v = readq(&timer->hpet_config);
 	g = v | Tn_INT_ENB_CNF_MASK;
+	g |= irq << Tn_INT_ROUTE_CNF_SHIFT;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
 		write_counter(t, &timer->hpet_compare);
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 2dc29ce..440ca72 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -37,6 +37,7 @@ struct hpet {
 #define	hpet_compare	_u1._hpet_compare
 
 #define	HPET_MAX_TIMERS	(32)
+#define HPET_MAX_IRQ	(32)
 
 /*
  * HPET general capabilities register
@@ -64,7 +65,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)

