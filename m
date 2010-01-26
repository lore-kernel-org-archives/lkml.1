Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581Ab0AZXnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0AZXnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486Ab0AZXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:38 -0500
Received: from kroah.org ([198.145.64.141]:35272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab0AZXnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.015346545@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Reed <mdr@sgi.com>, James Smart <james.smart@emulex.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [39/98] [SCSI] scsi_transport_fc: remove invalid BUG_ON
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Reed <mdr@sgi.com>

commit 8798a694da59486e4a3ff0abeec183202fb34c20 upstream.

I was doing some large lun count testing with 2.6.31 and hit
a BUG_ON() in fc_timeout_deleted_rport(), and it seems like it
should have been just a matter of time before someone did.

It seems invalid to set port_state under lock, then expect it to
remain set after releasing the lock.  Another thread called
fc_remote_port_add() when the lock was released, changing the
port_state.

This patch removes the BUG_ON and moves the test of the
port_state to inside the host_lock.  It's been running for
several weeks now with no ill effect.

Signed-off-by: Michael Reed <mdr@sgi.com>
Acked-by:  James Smart <james.smart@emulex.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_fc.c |   68 ++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 26 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2395,6 +2395,7 @@ fc_rport_final_delete(struct work_struct
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
+	int do_callback = 0;
 
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that
@@ -2433,8 +2434,15 @@ fc_rport_final_delete(struct work_struct
 	 * Avoid this call if we already called it when we preserved the
 	 * rport for the binding.
 	 */
+	spin_lock_irqsave(shost->host_lock, flags);
 	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
-	    (i->f->dev_loss_tmo_callbk))
+	    (i->f->dev_loss_tmo_callbk)) {
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		do_callback = 1;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (do_callback)
 		i->f->dev_loss_tmo_callbk(rport);
 
 	fc_bsg_remove(rport->rqst_q);
@@ -2981,6 +2989,7 @@ fc_timeout_deleted_rport(struct work_str
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
+	int do_callback = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -3046,7 +3055,6 @@ fc_timeout_deleted_rport(struct work_str
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
-	rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
 
 	/*
 	 * Pre-emptively kill I/O rather than waiting for the work queue
@@ -3056,32 +3064,40 @@ fc_timeout_deleted_rport(struct work_str
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	fc_terminate_rport_io(rport);
 
-	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
+	spin_lock_irqsave(shost->host_lock, flags);
 
-	/* remove the identifiers that aren't used in the consisting binding */
-	switch (fc_host->tgtid_bind_type) {
-	case FC_TGTID_BIND_BY_WWPN:
-		rport->node_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_WWNN:
-		rport->port_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_ID:
-		rport->node_name = -1;
-		rport->port_name = -1;
-		break;
-	case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
-		break;
+	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */
+
+		/* remove the identifiers that aren't used in the consisting binding */
+		switch (fc_host->tgtid_bind_type) {
+		case FC_TGTID_BIND_BY_WWPN:
+			rport->node_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_WWNN:
+			rport->port_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_ID:
+			rport->node_name = -1;
+			rport->port_name = -1;
+			break;
+		case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
+			break;
+		}
+
+		/*
+		 * As this only occurs if the remote port (scsi target)
+		 * went away and didn't come back - we'll remove
+		 * all attached scsi devices.
+		 */
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		fc_queue_work(shost, &rport->stgt_delete_work);
+
+		do_callback = 1;
 	}
 
-	/*
-	 * As this only occurs if the remote port (scsi target)
-	 * went away and didn't come back - we'll remove
-	 * all attached scsi devices.
-	 */
-	fc_queue_work(shost, &rport->stgt_delete_work);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
 	 * Notify the driver that the rport is now dead. The LLDD will
@@ -3089,7 +3105,7 @@ fc_timeout_deleted_rport(struct work_str
 	 *
 	 * Note: we set the CALLBK_DONE flag above to correspond
 	 */
-	if (i->f->dev_loss_tmo_callbk)
+	if (do_callback && i->f->dev_loss_tmo_callbk)
 		i->f->dev_loss_tmo_callbk(rport);
 }
 


