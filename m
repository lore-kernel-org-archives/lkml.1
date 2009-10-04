Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZJDTpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZJDTpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbZJDTpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZJDTpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:45:04 -0400
Date: Sun, 4 Oct 2009 16:43:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] i7core_edac: Use a lockless ringbuffer
Message-ID: <20091004164347.4d483b3d@pedra.chehab.org>
In-Reply-To: <20090924192821.7fcffc80@pedra.chehab.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ece799f1fbe9af74c518c00ab5dd271ba9eb8855 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 4 Oct 2009 10:15:40 -0300
Subject: [PATCH] i7core_edac: Use a lockless ringbuffer

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |   83 +++++++++++++++++++++++++++++---------------
 1 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 97f6d17..94aeca0 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -28,7 +28,6 @@
 #include <linux/edac.h>
 #include <linux/mmzone.h>
 #include <linux/edac_mce.h>
-#include <linux/spinlock.h>
 #include <linux/smp.h>
 #include <asm/processor.h>
 
@@ -239,9 +238,16 @@ struct i7core_pvt {
 
 	/* mcelog glue */
 	struct edac_mce		edac_mce;
+
+	/* Fifo double buffers */
 	struct mce		mce_entry[MCE_LOG_LEN];
-	unsigned		mce_count;
-	spinlock_t		mce_lock;
+	struct mce		mce_outentry[MCE_LOG_LEN];
+
+	/* Fifo in/out counters */
+	unsigned		mce_in, mce_out;
+
+	/* Count indicator to show errors not got */
+	unsigned		mce_overrun;
 };
 
 /* Static vars */
@@ -1617,30 +1623,50 @@ static void i7core_check_error(struct mem_ctl_info *mci)
 	struct i7core_pvt *pvt = mci->pvt_info;
 	int i;
 	unsigned count = 0;
-	struct mce *m = NULL;
-	unsigned long flags;
+	struct mce *m;
 
-	/* Copy all mce errors into a temporary buffer */
-	spin_lock_irqsave(&pvt->mce_lock, flags);
-	if (pvt->mce_count) {
-		m = kmalloc(sizeof(*m) * pvt->mce_count, GFP_ATOMIC);
+	/*
+	 * MCE first step: Copy all mce errors into a temporary buffer
+	 * We use a double buffering here, to reduce the risk of
+	 * loosing an error.
+	 */
+	smp_rmb();
+	count = (pvt->mce_out + sizeof(mce_entry) - pvt->mce_in)
+		% sizeof(mce_entry);
+	if (!count)
+		return;
 
-		if (m) {
-			count = pvt->mce_count;
-			memcpy(m, &pvt->mce_entry, sizeof(*m) * count);
-		}
-		pvt->mce_count = 0;
-	}
+	m = pvt->mce_outentry;
+	if (pvt->mce_in + count > sizeof(mce_entry)) {
+		unsigned l = sizeof(mce_entry) - pvt->mce_in;
 
-	spin_unlock_irqrestore(&pvt->mce_lock, flags);
+		memcpy(m, &pvt->mce_entry[pvt->mce_in], sizeof(*m) * l);
+		smp_wmb();
+		pvt->mce_in = 0;
+		count -= l;
+		m += l;
+	}
+	memcpy(m, &pvt->mce_entry[pvt->mce_in], sizeof(*m) * count);
+	smp_wmb();
+	pvt->mce_in += count;
+
+	smp_rmb();
+	if (pvt->mce_overrun) {
+		i7core_printk(KERN_ERR, "Lost %d memory errors\n",
+			      pvt->mce_overrun);
+		smp_wmb();
+		pvt->mce_overrun = 0;
+	}
 
-	/* proccess mcelog errors */
+	/*
+	 * MCE second step: parse errors and display
+	 */
 	for (i = 0; i < count; i++)
-		i7core_mce_output_error(mci, &m[i]);
+		i7core_mce_output_error(mci, &pvt->mce_outentry[i]);
 
-	kfree(m);
-
-	/* check memory count errors */
+	/*
+	 * Now, let's increment CE error counts
+	 */
 	if (!pvt->is_registered)
 		i7core_udimm_check_mc_ecc_err(mci);
 	else
@@ -1657,7 +1683,6 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 {
 	struct mem_ctl_info *mci = priv;
 	struct i7core_pvt *pvt = mci->pvt_info;
-	unsigned long flags;
 
 	/*
 	 * Just let mcelog handle it if the error is
@@ -1679,12 +1704,15 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 		return 0;
 	}
 
-	spin_lock_irqsave(&pvt->mce_lock, flags);
-	if (pvt->mce_count < MCE_LOG_LEN) {
-		memcpy(&pvt->mce_entry[pvt->mce_count], mce, sizeof(*mce));
-		pvt->mce_count++;
+	smp_rmb();
+	if ((pvt->mce_out + 1) % sizeof(mce_entry) == pvt->mce_in) {
+		smp_wmb();
+		pvt->mce_overrun++;
+		return 0;
 	}
-	spin_unlock_irqrestore(&pvt->mce_lock, flags);
+	smp_wmb();
+	pvt->mce_out = (pvt->mce_out + 1) % sizeof(mce_entry);
+	memcpy(&pvt->mce_entry[pvt->mce_out], mce, sizeof(*mce));
 
 	/* Handle fatal errors immediately */
 	if (mce->mcgstatus & 1)
@@ -1777,7 +1805,6 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev,
 	/* Registers on edac_mce in order to receive memory errors */
 	pvt->edac_mce.priv = mci;
 	pvt->edac_mce.check_error = i7core_mce_check_error;
-	spin_lock_init(&pvt->mce_lock);
 
 	rc = edac_mce_register(&pvt->edac_mce);
 	if (unlikely(rc < 0)) 

-- 

Cheers,
Mauro
