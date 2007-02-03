Return-Path: <linux-kernel-owner+w=401wt.eu-S1946239AbXBCCv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946239AbXBCCv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946258AbXBCCvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:51:42 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52861 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946233AbXBCChQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:37:16 -0500
Message-Id: <20070203024122.763664000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:28 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Erez Zilber <erezz@voltaire.com>, Roland Dreier <rdreier@cisco.com>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: [patch 24/59] IB/iser: return error code when PDUs may not be sent
Content-Disposition: inline; filename=ib-iser-return-error-code-when-pdus-may-not-be-sent.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Erez Zilber <erezz@voltaire.com>

iSER limits the number of outstanding PDUs to send. When this threshold is
reached, it should return an error code (-ENOBUFS) instead of setting the
suspend_tx bit (which should be used only by libiscsi). Without this fix, 
during logout, open-iscsi over iSER tries to logout forever.

Signed-off-by: Erez Zilber <erezz@voltaire.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    4 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   26 ++++++++++++--------------
 2 files changed, 14 insertions(+), 16 deletions(-)

--- linux-2.6.19.2.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.19.2/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -177,7 +177,7 @@ iscsi_iser_mtask_xmit(struct iscsi_conn 
 	 * - if yes, the mtask is recycled at iscsi_complete_pdu
 	 * - if no,  the mtask is recycled at iser_snd_completion
 	 */
-	if (error && error != -EAGAIN)
+	if (error && error != -ENOBUFS)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 
 	return error;
@@ -241,7 +241,7 @@ iscsi_iser_ctask_xmit(struct iscsi_conn 
 		error = iscsi_iser_ctask_xmit_unsol_data(conn, ctask);
 
  iscsi_iser_ctask_xmit_exit:
-	if (error && error != -EAGAIN)
+	if (error && error != -ENOBUFS)
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	return error;
 }
--- linux-2.6.19.2.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.19.2/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -304,18 +304,14 @@ int iser_conn_set_full_featured_mode(str
 static int
 iser_check_xmit(struct iscsi_conn *conn, void *task)
 {
-	int rc = 0;
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 
-	write_lock_bh(conn->recv_lock);
 	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
 	    ISER_QP_MAX_REQ_DTOS) {
-		iser_dbg("%ld can't xmit task %p, suspending tx\n",jiffies,task);
-		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-		rc = -EAGAIN;
+		iser_dbg("%ld can't xmit task %p\n",jiffies,task);
+		return -ENOBUFS;
 	}
-	write_unlock_bh(conn->recv_lock);
-	return rc;
+	return 0;
 }
 
 
@@ -340,7 +336,7 @@ int iser_send_command(struct iscsi_conn 
 		return -EPERM;
 	}
 	if (iser_check_xmit(conn, ctask))
-		return -EAGAIN;
+		return -ENOBUFS;
 
 	edtl = ntohl(hdr->data_length);
 
@@ -426,7 +422,7 @@ int iser_send_data_out(struct iscsi_conn
 	}
 
 	if (iser_check_xmit(conn, ctask))
-		return -EAGAIN;
+		return -ENOBUFS;
 
 	itt = ntohl(hdr->itt);
 	data_seg_len = ntoh24(hdr->dlength);
@@ -500,7 +496,7 @@ int iser_send_control(struct iscsi_conn 
 	}
 
 	if (iser_check_xmit(conn,mtask))
-		return -EAGAIN;
+		return -ENOBUFS;
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
@@ -609,6 +605,7 @@ void iser_snd_completion(struct iser_des
 	struct iscsi_iser_conn *iser_conn = ib_conn->iser_conn;
 	struct iscsi_conn      *conn = iser_conn->iscsi_conn;
 	struct iscsi_mgmt_task *mtask;
+	int resume_tx = 0;
 
 	iser_dbg("Initiator, Data sent dto=0x%p\n", dto);
 
@@ -617,15 +614,16 @@ void iser_snd_completion(struct iser_des
 	if (tx_desc->type == ISCSI_TX_DATAOUT)
 		kmem_cache_free(ig.desc_cache, tx_desc);
 
+	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
+	    ISER_QP_MAX_REQ_DTOS)
+		resume_tx = 1;
+
 	atomic_dec(&ib_conn->post_send_buf_count);
 
-	write_lock(conn->recv_lock);
-	if (conn->suspend_tx) {
+	if (resume_tx) {
 		iser_dbg("%ld resuming tx\n",jiffies);
-		clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 		scsi_queue_work(conn->session->host, &conn->xmitwork);
 	}
-	write_unlock(conn->recv_lock);
 
 	if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */

--
