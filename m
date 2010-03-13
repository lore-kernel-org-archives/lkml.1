Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935926Ab0CMA4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:56:24 -0500
Received: from kroah.org ([198.145.64.141]:46872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935324Ab0CMAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:25 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.510649775@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [049/145] SCSI: qla2xxx: Obtain proper host structure during response-queue processing.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

commit a67093d46e3caed1a42d694a7de452b61db30562 upstream.

Original code incorrectly assumed only status-type-0
IOCBs would be queued to the response-queue, and thus all
entries would safely reference a VHA from the IOCB
'handle.'

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_isr.c |   29 +----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |    6 +++++-
 3 files changed, 6 insertions(+), 30 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -453,6 +453,5 @@ extern void qla24xx_wrt_req_reg(struct q
 extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern struct scsi_qla_host * qla25xx_get_host(struct rsp_que *);
 
 #endif /* _QLA_GBL_H */
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2018,7 +2018,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	vha = qla25xx_get_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->mqenable) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -2357,30 +2357,3 @@ int qla25xx_request_irq(struct rsp_que *
 	msix->rsp = rsp;
 	return ret;
 }
-
-struct scsi_qla_host *
-qla25xx_get_host(struct rsp_que *rsp)
-{
-	srb_t *sp;
-	struct qla_hw_data *ha = rsp->hw;
-	struct scsi_qla_host *vha = NULL;
-	struct sts_entry_24xx *pkt;
-	struct req_que *req;
-	uint16_t que;
-	uint32_t handle;
-
-	pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
-	que = MSW(pkt->handle);
-	handle = (uint32_t) LSW(pkt->handle);
-	req = ha->req_q_map[que];
-	if (handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = req->outstanding_cmds[handle];
-		if (sp)
-			return  sp->fcport->vha;
-		else
-			goto base_que;
-	}
-base_que:
-	vha = pci_get_drvdata(ha->pdev);
-	return vha;
-}
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -638,11 +638,15 @@ failed:
 
 static void qla_do_work(struct work_struct *work)
 {
+	unsigned long flags;
 	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
 	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha = rsp->hw;
 
-	vha = qla25xx_get_host(rsp);
+	spin_lock_irqsave(&rsp->hw->hardware_lock, flags);
+	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
+	spin_unlock_irqrestore(&rsp->hw->hardware_lock, flags);
 }
 
 /* create response queue */


