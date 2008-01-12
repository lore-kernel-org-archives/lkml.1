Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYALUCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYALUCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYALUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:02:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:38137 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbYALUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=PpOMcyHiptkv1ik37NmKeXDtbJphR66m8IqvKUo76mcALcvcb4se75V09u0YYnf7neHRnQaGqIoQ0qd3FZJwQy9SEYDnL6INfpJ0UwGySxyu89gPkCXmoEGRE20Ykgi2PbtaoJX3Lnyjm1pI1lpKjJaWfrZDz4GXnFVv3qi2w5o=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: balbir@linux.vnet.ibm.com
Subject: [PATCH] [RESEND] Assign IRQs to HPET Timers
Date: Sun, 13 Jan 2008 01:45:22 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, amit.shah@qumranet.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       venkatesh.pallipadi@intel.com, clemens@ladisch.de, tglx@linutronix.de,
       mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org
References: <200801120036.11982.balajirrao@gmail.com> <20080112120312.GE25388@balbir.in.ibm.com>
In-Reply-To: <20080112120312.GE25388@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801130145.22517.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace API for the HPET (see Documentation/hpet.txt) did not work. The 
HPET_IE_ON ioctl was failing as there was no IRQ assigned to the timer 
device. This patch fixes it by allocating IRQs to timer blocks in the HPET.

arch/x86/kernel/hpet.c |   13 +++++--------
drivers/char/hpet.c    |   45 ++++++++++++++++++++++++++++++++++++++-------
include/linux/hpet.h   |    2 +-
3 files changed, 44 insertions(+), 16 deletions(-)

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4a86ffd..08ee998 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -116,8 +116,7 @@ int is_hpet_enabled(void)
 static void hpet_reserve_platform_timers(unsigned long id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
-	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
-	unsigned int nrtimers, i;
+	unsigned int nrtimers;
 	struct hpet_data hd;
 
 	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
@@ -132,16 +131,14 @@ static void hpet_reserve_platform_timers(unsigned long 
id)
 #ifdef CONFIG_HPET_EMULATE_RTC
 	hpet_reserve_timer(&hd, 1);
 #endif
-
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
-	for (i = 2; i < nrtimers; timer++, i++)
-		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
-			Tn_INT_ROUTE_CNF_SHIFT;
-
+	/*
+	 * IRQs for the other timers are assigned dynamically
+	 * in hpet_alloc
+	 */
 	hpet_alloc(&hd);
-
 }
 #else
 static void hpet_reserve_platform_timers(unsigned long id) { }
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 4c16778..593b32c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -806,14 +806,14 @@ static unsigned long hpet_calibrate(struct hpets *hpetp)
 
 int hpet_alloc(struct hpet_data *hdp)
 {
-	u64 cap, mcfg;
+	u64 cap, mcfg, hpet_config;
 	struct hpet_dev *devp;
-	u32 i, ntimer;
+	u32 i, ntimer, irq;
 	struct hpets *hpetp;
 	size_t siz;
 	struct hpet __iomem *hpet;
 	static struct hpets *last = NULL;
-	unsigned long period;
+	unsigned long period, irq_bitmap;
 	unsigned long long temp;
 
 	/*
@@ -840,11 +840,41 @@ int hpet_alloc(struct hpet_data *hdp)
 	hpetp->hp_hpet_phys = hdp->hd_phys_address;
 
 	hpetp->hp_ntimer = hdp->hd_nirqs;
+	hpet = hpetp->hp_hpet;
 
-	for (i = 0; i < hdp->hd_nirqs; i++)
-		hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
+	/* Assign IRQs statically for legacy devices */
+	hpetp->hp_dev[0].hd_hdwirq = hdp->hd_irq[0];
+	hpetp->hp_dev[1].hd_hdwirq = hdp->hd_irq[1];
 
-	hpet = hpetp->hp_hpet;
+	/* Assign IRQs dynamically for the others */
+	for (i = 2, devp = &hpetp->hp_dev[2]; i < hdp->hd_nirqs; i++, devp++) {
+		struct hpet_timer __iomem *timer;
+
+		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
+
+		hpet_config = readq(&timer->hpet_config);
+		irq_bitmap = (hpet_config & Tn_INT_ROUTE_CAP_MASK)
+			>> Tn_INT_ROUTE_CAP_SHIFT;
+		if (!irq_bitmap)
+			irq = 0;        /* No valid IRQ Assignable */
+		else {
+			irq = find_first_bit(&irq_bitmap, 32);
+			do {
+				hpet_config |= irq << Tn_INT_ROUTE_CNF_SHIFT;
+				writeq(hpet_config, &timer->hpet_config);
+
+				/*
+				 * Verify whether we have written a valid
+				 * IRQ number by reading it back again
+				 */
+				hpet_config = readq(&timer->hpet_config);
+				if (irq == (hpet_config & Tn_INT_ROUTE_CNF_MASK)
+						>> Tn_INT_ROUTE_CNF_SHIFT)
+					break;  /* Success */
+			} while ((irq = (find_next_bit(&irq_bitmap, 32, irq))));
+		}
+		hpetp->hp_dev[i].hd_hdwirq = irq;
+	}
 
 	cap = readq(&hpet->hpet_cap);
 
@@ -875,7 +905,8 @@ int hpet_alloc(struct hpet_data *hdp)
 		hpetp->hp_which, hdp->hd_phys_address,
 		hpetp->hp_ntimer > 1 ? "s" : "");
 	for (i = 0; i < hpetp->hp_ntimer; i++)
-		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
+		printk("%s %d", i > 0 ? "," : "",
+				hpetp->hp_dev[i].hd_hdwirq);
 	printk("\n");
 
 	printk(KERN_INFO "hpet%u: %u %d-bit timers, %Lu Hz\n",
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
---
