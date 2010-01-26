Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568Ab0AZX7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0AZX7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447Ab0AZXn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:29 -0500
Received: from kroah.org ([198.145.64.141]:35221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab0AZXn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.339381227@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [34/98] [SCSI] iscsi class: modify handling of replacement timeout
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit fdd46dcbe4468a1f47a2cc9be442d11c3d21dd68 upstream.

This patch modifies the replacement/recovery_timeout so it works
more like the fc fast io fail tmo.

If userspace tries to set the replacement/recovery_timeout to less than
zero, we will turn off the forced recovery cleanup.

If userspace sets the value to 0 then we will force the recovery
cleanup immediately.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_iscsi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -627,8 +627,10 @@ static void __iscsi_block_session(struct
 	spin_unlock_irqrestore(&session->lock, flags);
 	scsi_target_block(&session->dev);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
-	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
-			   session->recovery_tmo * HZ);
+	if (session->recovery_tmo >= 0)
+		queue_delayed_work(iscsi_eh_timer_workq,
+				   &session->recovery_work,
+				   session->recovery_tmo * HZ);
 }
 
 void iscsi_block_session(struct iscsi_cls_session *session)
@@ -1348,8 +1350,7 @@ iscsi_set_param(struct iscsi_transport *
 	switch (ev->u.set_param.param) {
 	case ISCSI_PARAM_SESS_RECOVERY_TMO:
 		sscanf(data, "%d", &value);
-		if (value != 0)
-			session->recovery_tmo = value;
+		session->recovery_tmo = value;
 		break;
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,


