Return-Path: <linux-kernel-owner+w=401wt.eu-S937171AbXG0RB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937171AbXG0RB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXG0RBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:01:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60303 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbXG0RBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:01:16 -0400
Date: Fri, 27 Jul 2007 13:01:15 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-scsi@vger.kernel.org, erich@areca.com.tw
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] arcmsr: irq handler fixes, cleanups, micro-opts
Message-ID: <20070727170114.GA27441@havoc.gtf.org>
References: <20070727170048.GA27353@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727170048.GA27353@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 97618f90f021d457c5078ab85f0f443553f93d51
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 27 12:58:00 2007 -0400

    [SCSI] arcmsr: interrupt handling fixes, cleanups, micro-opts
    
    * Remove IRQF_DISABLED, it is clearly wrong for this driver.
    
    * Remove wasteful spin_lock_irqsave() in interrupt handler.
      The lighter-weight spin_lock() is all that's needed.
    
    * Annotate with FIXME where arcmsr_interrupt() is called
      without any spinlock being acquired.
    
    * Eliminate pointless cast from void pointer in arcmsr_do_interrupt()
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/arcmsr/arcmsr_hba.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

97618f90f021d457c5078ab85f0f443553f93d51
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ae26ed4..d9fadb4 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -159,14 +159,12 @@ static struct pci_driver arcmsr_pci_driver = {
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)
 {
 	irqreturn_t handle_state;
-	struct AdapterControlBlock *acb;
-	unsigned long flags;
-
-	acb = (struct AdapterControlBlock *)dev_id;
+	struct AdapterControlBlock *acb = dev_id;
 
-	spin_lock_irqsave(acb->host->host_lock, flags);
+	spin_lock(acb->host->host_lock);
 	handle_state = arcmsr_interrupt(acb);
-	spin_unlock_irqrestore(acb->host->host_lock, flags);
+	spin_unlock(acb->host->host_lock);
+
 	return handle_state;
 }
 
@@ -331,7 +329,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
 		goto out_iounmap;
 
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "arcmsr", acb);
+			    IRQF_SHARED, "arcmsr", acb);
 	if (error)
 		goto out_free_ccb_pool;
 
@@ -421,7 +419,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	for (poll_count = 0; poll_count < 256; poll_count++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);	/* FIXME: need spinlock */
 		msleep(25);
 	}
 
@@ -1452,7 +1450,7 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 	for (i = 0; i < 400; i++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);	/* FIXME: need spinlock */
 		msleep(25);
 	}
 	arcmsr_iop_reset(acb);
