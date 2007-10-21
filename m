Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXJUHy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXJUHy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJUHwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38216 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbXJUHwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:35 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: paulkf@microgate.com
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 9/17] drivers/char/{synclink,tpm}: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075235.25BC519041C@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:35 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 81ccec23142e4fe42b3f72faecccb7b64f84007e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:27:19 2007 -0400

    drivers/char/{synclink,tpm}: irq handler cleanups
    
    * no need to use 'irq' function arg
    
    * delete pointless test, pointless casts
    
    * add KERN_xxx prefixes where appropriate
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/synclink.c    |   21 +++++++++------------
 drivers/char/synclink_gt.c |   13 ++++---------
 drivers/char/synclinkmp.c  |   22 +++++++++-------------
 drivers/char/tpm/tpm_tis.c |    2 +-
 4 files changed, 23 insertions(+), 35 deletions(-)

81ccec23142e4fe42b3f72faecccb7b64f84007e
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..aa09909 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -1696,20 +1696,16 @@ static void mgsl_isr_transmit_dma( struct mgsl_struct *info )
  * 	
  * Return Value: None
  */
-static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
+static irqreturn_t mgsl_interrupt(int dummy, void *dev_id)
 {
-	struct mgsl_struct * info;
+	struct mgsl_struct *info = dev_id;
 	u16 UscVector;
 	u16 DmaVector;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
-		printk("%s(%d):mgsl_interrupt(%d)entry.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):mgsl_interrupt(%d)entry.\n",
+			__FILE__, __LINE__, info->irq_level);
 
-	info = (struct mgsl_struct *)dev_id;	
-	if (!info)
-		return IRQ_NONE;
-		
 	spin_lock(&info->irq_spinlock);
 
 	for(;;) {
@@ -1733,8 +1729,8 @@ static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
 			mgsl_isr_receive_dma(info);
 
 		if ( info->isr_overflow ) {
-			printk(KERN_ERR"%s(%d):%s isr overflow irq=%d\n",
-				__FILE__,__LINE__,info->device_name, irq);
+			printk(KERN_ERR "%s(%d):%s isr overflow irq=%d\n",
+				__FILE__, __LINE__, info->device_name, info->irq_level);
 			usc_DisableMasterIrqBit(info);
 			usc_DisableDmaInterrupts(info,DICR_MASTER);
 			break;
@@ -1756,8 +1752,9 @@ static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
 	spin_unlock(&info->irq_spinlock);
 	
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
-		printk("%s(%d):mgsl_interrupt(%d)exit.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):mgsl_interrupt(%d)exit.\n",
+			__FILE__, __LINE__, info->irq_level);
+
 	return IRQ_HANDLED;
 }	/* end of mgsl_interrupt() */
 
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 64e835f..468dae1 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -492,7 +492,6 @@ static void isr_serial(struct slgt_info *info);
 static void isr_rdma(struct slgt_info *info);
 static void isr_txeom(struct slgt_info *info, unsigned short status);
 static void isr_tdma(struct slgt_info *info);
-static irqreturn_t slgt_interrupt(int irq, void *dev_id);
 
 static int  alloc_dma_bufs(struct slgt_info *info);
 static void free_dma_bufs(struct slgt_info *info);
@@ -2321,17 +2320,13 @@ static void isr_gpio(struct slgt_info *info, unsigned int changed, unsigned int
  * 	irq	interrupt number
  * 	dev_id	device ID supplied during interrupt registration
  */
-static irqreturn_t slgt_interrupt(int irq, void *dev_id)
+static irqreturn_t slgt_interrupt(int dummy, void *dev_id)
 {
-	struct slgt_info *info;
+	struct slgt_info *info = dev_id;
 	unsigned int gsr;
 	unsigned int i;
 
-	DBGISR(("slgt_interrupt irq=%d entry\n", irq));
-
-	info = dev_id;
-	if (!info)
-		return IRQ_NONE;
+	DBGISR(("slgt_interrupt irq=%d entry\n", info->irq_level));
 
 	spin_lock(&info->lock);
 
@@ -2380,7 +2375,7 @@ static irqreturn_t slgt_interrupt(int irq, void *dev_id)
 
 	spin_unlock(&info->lock);
 
-	DBGISR(("slgt_interrupt irq=%d exit\n", irq));
+	DBGISR(("slgt_interrupt irq=%d exit\n", info->irq_level));
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index c63013b..f79c8b2 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -2587,9 +2587,9 @@ void isr_io_pin( SLMP_INFO *info, u16 status )
  * 	dev_id		device ID supplied during interrupt registration
  * 	regs		interrupted processor context
  */
-static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
+static irqreturn_t synclinkmp_interrupt(int dummy, void *dev_id)
 {
-	SLMP_INFO * info;
+	SLMP_INFO *info = dev_id;
 	unsigned char status, status0, status1=0;
 	unsigned char dmastatus, dmastatus0, dmastatus1=0;
 	unsigned char timerstatus0, timerstatus1=0;
@@ -2598,12 +2598,8 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 	unsigned short tmp;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
-		printk("%s(%d): synclinkmp_interrupt(%d)entry.\n",
-			__FILE__,__LINE__,irq);
-
-	info = (SLMP_INFO *)dev_id;
-	if (!info)
-		return IRQ_NONE;
+		printk(KERN_DEBUG "%s(%d): synclinkmp_interrupt(%d)entry.\n",
+			__FILE__, __LINE__, info->irq_level);
 
 	spin_lock(&info->lock);
 
@@ -2616,9 +2612,9 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 		timerstatus0 = read_reg(info, ISR2);
 
 		if ( debug_level >= DEBUG_LEVEL_ISR )
-			printk("%s(%d):%s status0=%02x, dmastatus0=%02x, timerstatus0=%02x\n",
-				__FILE__,__LINE__,info->device_name,
-				status0,dmastatus0,timerstatus0);
+			printk(KERN_DEBUG "%s(%d):%s status0=%02x, dmastatus0=%02x, timerstatus0=%02x\n",
+				__FILE__, __LINE__, info->device_name,
+				status0, dmastatus0, timerstatus0);
 
 		if (info->port_count == 4) {
 			/* get status for SCA1 (ports 2-3) */
@@ -2703,8 +2699,8 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 	spin_unlock(&info->lock);
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
-		printk("%s(%d):synclinkmp_interrupt(%d)exit.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):synclinkmp_interrupt(%d)exit.\n",
+			__FILE__, __LINE__, info->irq_level);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index fd771a4..9e12638 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -399,7 +399,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t tis_int_handler(int irq, void *dev_id)
+static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
