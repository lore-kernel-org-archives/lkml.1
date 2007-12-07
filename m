Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbXLIMqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbXLIMqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXLIMq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:46:29 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54719 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbXLIMq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:46:27 -0500
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 07:46:27 EST
Date: Fri, 7 Dec 2007 16:06:35 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] qla2xxx driver: convert mbx_intr_sem to completion
Message-ID: <20071207150635.GG480@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-driver@qlogic.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QLA2XXX driver: convert the semaphore mbx_intr_sem to a completion

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 04e8cbc..ae3b3f4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2418,7 +2418,7 @@ typedef struct scsi_qla_host {
 
 	struct semaphore mbx_cmd_sem;	/* Serialialize mbx access */
 	struct semaphore vport_sem;	/* Virtual port synchronization */
-	struct semaphore mbx_intr_sem;  /* Used for completion notification */
+	struct completion mbx_intr_cmp;	/* Used for completion notification */
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1104bd2..4c2868d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -104,7 +104,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_cmp);
 	}
 
 	return (IRQ_HANDLED);
@@ -216,7 +216,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_cmp);
 	}
 
 	return (IRQ_HANDLED);
@@ -1621,7 +1621,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_cmp);
 	}
 
 	return IRQ_HANDLED;
@@ -1758,7 +1758,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_cmp);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ccd662a..115600e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -9,17 +9,17 @@
 #include <linux/delay.h>
 
 static void
-qla2x00_mbx_sem_timeout(unsigned long data)
+qla2x00_mbx_cmp_timeout(unsigned long data)
 {
-	struct semaphore	*sem_ptr = (struct semaphore *)data;
+	struct completion	*cmp_ptr = (struct completion *)data;
 
-	DEBUG11(printk("qla2x00_sem_timeout: entered.\n"));
+	DEBUG11(printk("qla2x00_mbx_cmp_timeout: entered.\n"));
 
-	if (sem_ptr != NULL) {
-		up(sem_ptr);
+	if (cmp_ptr != NULL) {
+		complete(cmp_ptr);
 	}
 
-	DEBUG11(printk("qla2x00_mbx_sem_timeout: exiting.\n"));
+	DEBUG11(printk("qla2x00_mbx_cmp_timeout: exiting.\n"));
 }
 
 /*
@@ -140,10 +140,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		    __func__, ha->host_no));
 
 		init_timer(&tmp_intr_timer);
-		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_sem;
+		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_cmp;
 		tmp_intr_timer.expires = jiffies + mcp->tov * HZ;
 		tmp_intr_timer.function =
-		    (void (*)(unsigned long))qla2x00_mbx_sem_timeout;
+		    (void (*)(unsigned long))qla2x00_mbx_cmp_timeout;
 
 		DEBUG11(printk("%s(%ld): Adding timer.\n", __func__,
 		    ha->host_no));
@@ -163,7 +163,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		/* Wait for either the timer to expire
 		 * or the mbox completion interrupt
 		 */
-		down(&ha->mbx_intr_sem);
+		wait_for_completion(&ha->mbx_intr_cmp);
 
 		DEBUG11(printk("%s(%ld): waking up. time=0x%lx\n", __func__,
 		    ha->host_no, jiffies));
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 821ee74..102b765 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -413,7 +413,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
 	init_MUTEX(&vha->mbx_cmd_sem);
-	init_MUTEX_LOCKED(&vha->mbx_intr_sem);
+	init_completion(&vha->mbx_intr_cmp);
 
 	INIT_LIST_HEAD(&vha->list);
 	INIT_LIST_HEAD(&vha->fcports);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5bcf1f..64379a2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1703,7 +1703,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	init_MUTEX(&ha->mbx_cmd_sem);
 	init_MUTEX(&ha->vport_sem);
-	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
+	init_completion(&ha->mbx_intr_cmp);
 
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              You can't separate peace from freedom because no
               one can be at peace unless he has his freedom
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
