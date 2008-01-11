Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYAKSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYAKSwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYAKSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:52:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:64095 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbYAKSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tGLv1N7pVVcs/pI6IxCDov2iFFzbP8g050I853ub7t3uoV6gi5DPSJXckgdSKe1WhViRQONfRnz3bkhYon3jvGCnbF64RiAh+uR2Tz+qpnsqjiUlchV+7ZcjLMI5/v/lCr1EDXx+H26YejClvhsMmcn2k8Xyde+gnqgghDotWX4=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Assign IRQs to HPET Timers
Date: Sat, 12 Jan 2008 00:36:11 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: amit.shah@qumranet.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, venkatesh.pallipadi@intel.com,
       clemens@ladisch.de, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801120036.11982.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign an IRQ to HPET Timer devices when interrupt enable is requested.
This now makes the HPET userspace API work.

drivers/char/hpet.c  |   31 +++++++++++++++++++++++++++++--
include/linux/hpet.h |    2 +-
2 files changed, 30 insertions(+), 3 deletions(-)

Signed-off-by: Balaji Rao R <balajirrao@gmail.com>

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 4c16778..92bd889 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -390,7 +390,8 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	struct hpets *hpetp;
 	int irq;
 	unsigned long g, v, t, m;
-	unsigned long flags, isr;
+	unsigned long flags, isr, irq_bitmap;
+	u64 hpet_config;
 
 	timer = devp->hd_timer;
 	hpet = devp->hd_hpet;
@@ -412,7 +413,29 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		devp->hd_flags |= HPET_SHARED_IRQ;
 	spin_unlock_irq(&hpet_lock);
 
-	irq = devp->hd_hdwirq;
+	/* Assign an IRQ to the timer */
+	hpet_config = readq(&timer->hpet_config);
+	irq_bitmap =
+		(hpet_config & Tn_INT_ROUTE_CAP_MASK) >> Tn_INT_ROUTE_CAP_SHIFT;
+	if (!irq_bitmap)
+		irq = 0;	/* No IRQ Assignable */
+	else {
+		irq = find_first_bit(&irq_bitmap, 32);
+		do {
+			hpet_config |= irq << Tn_INT_ROUTE_CNF_SHIFT;
+			writeq(hpet_config, &timer->hpet_config);
+
+			/* Check whether we wrote a valid IRQ
+			 * number by reading back the field
+			 */
+			hpet_config = readq(&timer->hpet_config);
+			if (irq == (hpet_config & Tn_INT_ROUTE_CNF_MASK)
+					>> Tn_INT_ROUTE_CNF_SHIFT) {
+				devp->hd_hdwirq = irq;
+				break;	/* Success */
+			}
+		} while ((irq = (find_next_bit(&irq_bitmap, 32, irq))));
+	}
 
 	if (irq) {
 		unsigned long irq_flags;
@@ -509,6 +532,10 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 			break;
 		v = readq(&timer->hpet_config);
 		v &= ~Tn_INT_ENB_CNF_MASK;
+
+		/* Zero out the IRQ field*/
+		v &= ~Tn_INT_ROUTE_CNF_MASK;
+
 		writeq(v, &timer->hpet_config);
 		if (devp->hd_irq) {
 			free_irq(devp->hd_irq, devp);
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 707f7cb..e3c0b2a 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -64,7 +64,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)
