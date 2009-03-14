Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbZCNAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbZCNAit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZCNATc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:32 -0400
Received: from kroah.org ([198.145.64.141]:34785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbZCNATS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:47 2009
Message-Id: <20090314000747.763208650@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:06 -0700
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
       alan@lxorguk.ukuu.org.uk, Faisal Latif <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 58/96] RDMA/nes: Dont allow userspace QPs to use STag zero
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=rdma-nes-don-t-allow-userspace-qps-to-use-stag-zero.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Faisal Latif <faisal.latif@intel.com>

commit c12e56ef6951f4fce1afe9ef6aab9243ea9a9b04 upstream.

STag zero is a special STag that allows consumers to access any bus
address without registering memory.  The nes driver unfortunately
allows STag zero to be used even with QPs created by unprivileged
userspace consumers, which means that any process with direct verbs
access to the nes device can read and write any memory accessible to
the underlying PCI device (usually any memory in the system).  Such
access is usually given for cluster software such as MPI to use, so
this is a local privilege escalation bug on most systems running this
driver.

The driver was using STag zero to receive the last streaming mode
data; to allow STag zero to be disabled for unprivileged QPs, the
driver now registers a special MR for this data.

Signed-off-by: Faisal Latif <faisal.latif@intel.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/nes/nes_cm.c    |   37 +++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +
 drivers/infiniband/hw/nes/nes_verbs.h |    1 
 3 files changed, 35 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2474,12 +2474,14 @@ static int nes_disconnect(struct nes_qp 
 	int ret = 0;
 	struct nes_vnic *nesvnic;
 	struct nes_device *nesdev;
+	struct nes_ib_device *nesibdev;
 
 	nesvnic = to_nesvnic(nesqp->ibqp.device);
 	if (!nesvnic)
 		return -EINVAL;
 
 	nesdev = nesvnic->nesdev;
+	nesibdev = nesvnic->nesibdev;
 
 	nes_debug(NES_DBG_CM, "netdev refcnt = %u.\n",
 			atomic_read(&nesvnic->netdev->refcnt));
@@ -2491,6 +2493,8 @@ static int nes_disconnect(struct nes_qp 
 	} else {
 		/* Need to free the Last Streaming Mode Message */
 		if (nesqp->ietf_frame) {
+			if (nesqp->lsmm_mr)
+				nesibdev->ibdev.dereg_mr(nesqp->lsmm_mr);
 			pci_free_consistent(nesdev->pcidev,
 					nesqp->private_data_len+sizeof(struct ietf_mpa_frame),
 					nesqp->ietf_frame, nesqp->ietf_frame_pbase);
@@ -2524,6 +2528,10 @@ int nes_accept(struct iw_cm_id *cm_id, s
 	struct iw_cm_event cm_event;
 	struct nes_hw_qp_wqe *wqe;
 	struct nes_v4_quad nes_quad;
+	struct nes_ib_device *nesibdev;
+	struct ib_mr *ibmr = NULL;
+	struct ib_phys_buf ibphysbuf;
+	struct nes_pd *nespd;
 	u32 crc_value;
 	int ret;
 
@@ -2584,6 +2592,26 @@ int nes_accept(struct iw_cm_id *cm_id, s
 	if (cm_id->remote_addr.sin_addr.s_addr !=
 			cm_id->local_addr.sin_addr.s_addr) {
 		u64temp = (unsigned long)nesqp;
+		nesibdev = nesvnic->nesibdev;
+		nespd = nesqp->nespd;
+		ibphysbuf.addr = nesqp->ietf_frame_pbase;
+		ibphysbuf.size = conn_param->private_data_len +
+					sizeof(struct ietf_mpa_frame);
+		ibmr = nesibdev->ibdev.reg_phys_mr((struct ib_pd *)nespd,
+						&ibphysbuf, 1,
+						IB_ACCESS_LOCAL_WRITE,
+						(u64 *)&nesqp->ietf_frame);
+		if (!ibmr) {
+			nes_debug(NES_DBG_CM, "Unable to register memory region"
+					"for lSMM for cm_node = %p \n",
+					cm_node);
+			return -ENOMEM;
+		}
+
+		ibmr->pd = &nespd->ibpd;
+		ibmr->device = nespd->ibpd.device;
+		nesqp->lsmm_mr = ibmr;
+
 		u64temp |= NES_SW_CONTEXT_ALIGN>>1;
 		set_wqe_64bit_value(wqe->wqe_words,
 			NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX,
@@ -2594,14 +2622,13 @@ int nes_accept(struct iw_cm_id *cm_id, s
 		wqe->wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX] =
 			cpu_to_le32(conn_param->private_data_len +
 			sizeof(struct ietf_mpa_frame));
-		wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_LOW_IDX] =
-			cpu_to_le32((u32)nesqp->ietf_frame_pbase);
-		wqe->wqe_words[NES_IWARP_SQ_WQE_FRAG0_HIGH_IDX] =
-			cpu_to_le32((u32)((u64)nesqp->ietf_frame_pbase >> 32));
+		set_wqe_64bit_value(wqe->wqe_words,
+					NES_IWARP_SQ_WQE_FRAG0_LOW_IDX,
+					(u64)nesqp->ietf_frame);
 		wqe->wqe_words[NES_IWARP_SQ_WQE_LENGTH0_IDX] =
 			cpu_to_le32(conn_param->private_data_len +
 			sizeof(struct ietf_mpa_frame));
-		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = 0;
+		wqe->wqe_words[NES_IWARP_SQ_WQE_STAG0_IDX] = ibmr->lkey;
 
 		nesqp->nesqp_context->ird_ord_sizes |=
 			cpu_to_le32(NES_QPCONTEXT_ORDIRD_LSMM_PRESENT |
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1338,8 +1338,10 @@ static struct ib_qp *nes_create_qp(struc
 					NES_QPCONTEXT_MISC_RQ_SIZE_SHIFT);
 			nesqp->nesqp_context->misc |= cpu_to_le32((u32)nesqp->hwqp.sq_encoded_size <<
 					NES_QPCONTEXT_MISC_SQ_SIZE_SHIFT);
+			if (!udata) {
 				nesqp->nesqp_context->misc |= cpu_to_le32(NES_QPCONTEXT_MISC_PRIV_EN);
 				nesqp->nesqp_context->misc |= cpu_to_le32(NES_QPCONTEXT_MISC_FAST_REGISTER_EN);
+			}
 			nesqp->nesqp_context->cqs = cpu_to_le32(nesqp->nesscq->hw_cq.cq_number +
 					((u32)nesqp->nesrcq->hw_cq.cq_number << 16));
 			u64temp = (u64)nesqp->hwqp.sq_pbase;
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -134,6 +134,7 @@ struct nes_qp {
 	struct ietf_mpa_frame *ietf_frame;
 	dma_addr_t            ietf_frame_pbase;
 	wait_queue_head_t     state_waitq;
+	struct ib_mr          *lsmm_mr;
 	unsigned long         socket;
 	struct nes_hw_qp      hwqp;
 	struct work_struct    work;


