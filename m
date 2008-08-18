Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbYHRTLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbYHRTLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYHRTGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:06:41 -0400
Received: from mail.suse.de ([195.135.220.2]:44373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762958AbYHRTGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:06:39 -0400
Date: Mon, 18 Aug 2008 11:45:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Seokmann Ju <seokmann.ju@qlogic.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 54/60] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io
	callback support.
Message-ID: <20080818184533.GC29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="qla2xxx-add-dev_loss_tmo_callbk-terminate_rport_io-callback-support.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Seokmann Ju <seokmann.ju@qlogic.com>

[ Upstream commit 5f3a9a207f1fccde476dd31b4c63ead2967d934f ]

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_attr.c |   31 +++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    1 
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |   16 +++---------
 drivers/scsi/qla2xxx/qla_os.c   |   53 ++++++++++++++++++++++++++++++----------
 5 files changed, 78 insertions(+), 25 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -994,6 +994,33 @@ qla2x00_set_rport_loss_tmo(struct fc_rpo
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 }
 
+static void
+qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
+{
+	struct Scsi_Host *host = rport_to_shost(rport);
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+
+	qla2x00_abort_fcport_cmds(fcport);
+
+	/*
+	 * Transport has effectively 'deleted' the rport, clear
+	 * all local references.
+	 */
+	spin_lock_irq(host->host_lock);
+	fcport->rport = NULL;
+	*((fc_port_t **)rport->dd_data) = NULL;
+	spin_unlock_irq(host->host_lock);
+}
+
+static void
+qla2x00_terminate_rport_io(struct fc_rport *rport)
+{
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+
+	qla2x00_abort_fcport_cmds(fcport);
+	scsi_target_unblock(&rport->dev);
+}
+
 static int
 qla2x00_issue_lip(struct Scsi_Host *shost)
 {
@@ -1253,6 +1280,8 @@ struct fc_function_template qla2xxx_tran
 	.show_rport_dev_loss_tmo = 1,
 
 	.issue_fc_host_lip = qla2x00_issue_lip,
+	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
+	.terminate_rport_io = qla2x00_terminate_rport_io,
 	.get_fc_host_stats = qla2x00_get_fc_host_stats,
 
 	.vport_create = qla24xx_vport_create,
@@ -1296,6 +1325,8 @@ struct fc_function_template qla2xxx_tran
 	.show_rport_dev_loss_tmo = 1,
 
 	.issue_fc_host_lip = qla2x00_issue_lip,
+	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
+	.terminate_rport_io = qla2x00_terminate_rport_io,
 	.get_fc_host_stats = qla2x00_get_fc_host_stats,
 };
 
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1544,7 +1544,6 @@ typedef struct fc_port {
 	int login_retry;
 	atomic_t port_down_timer;
 
-	spinlock_t rport_lock;
 	struct fc_rport *rport, *drport;
 	u32 supported_classes;
 
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -71,6 +71,8 @@ extern int qla2x00_post_aen_work(struct 
 extern int qla2x00_post_hwe_work(struct scsi_qla_host *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
+extern void qla2x00_abort_fcport_cmds(fc_port_t *);
+
 /*
  * Global Functions in qla_mid.c source file.
  */
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1864,12 +1864,11 @@ qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
 	struct fc_rport *rport;
-	unsigned long flags;
 
-	spin_lock_irqsave(&fcport->rport_lock, flags);
+	spin_lock_irq(fcport->ha->host->host_lock);
 	rport = fcport->drport;
 	fcport->drport = NULL;
-	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+	spin_unlock_irq(fcport->ha->host->host_lock);
 	if (rport)
 		fc_remote_port_delete(rport);
 }
@@ -1898,7 +1897,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
-	spin_lock_init(&fcport->rport_lock);
 
 	return fcport;
 }
@@ -2243,28 +2241,24 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 {
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
-	unsigned long flags;
 
 	if (fcport->drport)
 		qla2x00_rport_del(fcport);
-	if (fcport->rport)
-		return;
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |
 	    fcport->d_id.b.area << 8 | fcport->d_id.b.al_pa;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
-	rport = fc_remote_port_add(ha->host, 0, &rport_ids);
+	fcport->rport = rport = fc_remote_port_add(ha->host, 0, &rport_ids);
 	if (!rport) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
-	spin_lock_irqsave(&fcport->rport_lock, flags);
-	fcport->rport = rport;
+	spin_lock_irq(fcport->ha->host->host_lock);
 	*((fc_port_t **)rport->dd_data) = fcport;
-	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+	spin_unlock_irq(fcport->ha->host->host_lock);
 
 	rport->supported_classes = fcport->supported_classes;
 
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -388,7 +388,7 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 	}
 
 	/* Close window on fcport/rport state-transitioning. */
-	if (!*(fc_port_t **)rport->dd_data) {
+	if (fcport->drport) {
 		cmd->result = DID_IMM_RETRY << 16;
 		goto qc_fail_command;
 	}
@@ -455,7 +455,7 @@ qla24xx_queuecommand(struct scsi_cmnd *c
 	}
 
 	/* Close window on fcport/rport state-transitioning. */
-	if (!*(fc_port_t **)rport->dd_data) {
+	if (fcport->drport) {
 		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
@@ -617,6 +617,40 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 	return (return_status);
 }
 
+void
+qla2x00_abort_fcport_cmds(fc_port_t *fcport)
+{
+	int cnt;
+	unsigned long flags;
+	srb_t *sp;
+	scsi_qla_host_t *ha = fcport->ha;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
+
+	spin_lock_irqsave(&pha->hardware_lock, flags);
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = pha->outstanding_cmds[cnt];
+		if (!sp)
+			continue;
+		if (sp->fcport != fcport)
+			continue;
+
+		spin_unlock_irqrestore(&pha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(ha, sp)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "Abort failed --  %lx\n", sp->cmd->serial_number));
+		} else {
+			if (qla2x00_eh_wait_on_command(ha, sp->cmd) !=
+			    QLA_SUCCESS)
+				DEBUG2(qla_printk(KERN_WARNING, ha,
+				    "Abort failed while waiting --  %lx\n",
+				    sp->cmd->serial_number));
+
+		}
+		spin_lock_irqsave(&pha->hardware_lock, flags);
+	}
+	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+}
+
 static void
 qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
 {
@@ -1813,7 +1847,6 @@ static inline void
 qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
     int defer)
 {
-	unsigned long flags;
 	struct fc_rport *rport;
 
 	if (!fcport->rport)
@@ -1821,19 +1854,13 @@ qla2x00_schedule_rport_del(struct scsi_q
 
 	rport = fcport->rport;
 	if (defer) {
-		spin_lock_irqsave(&fcport->rport_lock, flags);
+		spin_lock_irq(ha->host->host_lock);
 		fcport->drport = rport;
-		fcport->rport = NULL;
-		*(fc_port_t **)rport->dd_data = NULL;
-		spin_unlock_irqrestore(&fcport->rport_lock, flags);
+		spin_unlock_irq(ha->host->host_lock);
 		set_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
-	} else {
-		spin_lock_irqsave(&fcport->rport_lock, flags);
-		fcport->rport = NULL;
-		*(fc_port_t **)rport->dd_data = NULL;
-		spin_unlock_irqrestore(&fcport->rport_lock, flags);
+		qla2xxx_wake_dpc(ha);
+	} else
 		fc_remote_port_delete(rport);
-	}
 }
 
 /*

-- 
