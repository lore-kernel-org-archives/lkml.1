Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYAPWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYAPWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYAPWq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:46:28 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59676 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYAPWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:46:27 -0500
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 16 Jan 2008 14:46:21 -0800
Message-ID: <ada63xtz8w2.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jan 2008 22:46:22.0280 (UTC) FILETIME=[9DE82C80:01C85891]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the commit below, which moves a little code around to
make a couple of major MPI implementations work on ipath devices:

 drivers/infiniband/hw/ipath/ipath_ud.c |   44 ++++++++++++++++----------------
 1 files changed, 22 insertions(+), 22 deletions(-)

commit 0a69631b2869093d7306e8f66cca8eb0a05aa919
Author: Ralph Campbell <ralph.campbell@qlogic.com>
Date:   Tue Jan 15 15:58:13 2008 -0800

    IB/ipath: Fix receiving UD messages with immediate data
    
    This fixes a small bug in ipath_ud_rcv()'s handling of UD messages
    with immediate data.  We need to test whether immediate data is
    present and update the header size accordingly *before* testing the
    packet size from the header against the actual received length.
    Otherwise the wrong header size will be used and all messages with
    immediate data will be dropped.
    
    This bug keeps MVAPICH-UD and HP MPI from working at all on ipath devices.
    
    Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/infiniband/hw/ipath/ipath_ud.c
index 16a2a93..b3df6f3 100644
--- a/drivers/infiniband/hw/ipath/ipath_ud.c
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c
@@ -455,6 +455,28 @@ void ipath_ud_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 		}
 	}
 
+	/*
+	 * The opcode is in the low byte when its in network order
+	 * (top byte when in host order).
+	 */
+	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
+	if (qp->ibqp.qp_num > 1 &&
+	    opcode == IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE) {
+		if (header_in_data) {
+			wc.imm_data = *(__be32 *) data;
+			data += sizeof(__be32);
+		} else
+			wc.imm_data = ohdr->u.ud.imm_data;
+		wc.wc_flags = IB_WC_WITH_IMM;
+		hdrsize += sizeof(u32);
+	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
+		wc.imm_data = 0;
+		wc.wc_flags = 0;
+	} else {
+		dev->n_pkt_drops++;
+		goto bail;
+	}
+
 	/* Get the number of bytes the message was padded by. */
 	pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
 	if (unlikely(tlen < (hdrsize + pad + 4))) {
@@ -482,28 +504,6 @@ void ipath_ud_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 	wc.byte_len = tlen + sizeof(struct ib_grh);
 
 	/*
-	 * The opcode is in the low byte when its in network order
-	 * (top byte when in host order).
-	 */
-	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
-	if (qp->ibqp.qp_num > 1 &&
-	    opcode == IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE) {
-		if (header_in_data) {
-			wc.imm_data = *(__be32 *) data;
-			data += sizeof(__be32);
-		} else
-			wc.imm_data = ohdr->u.ud.imm_data;
-		wc.wc_flags = IB_WC_WITH_IMM;
-		hdrsize += sizeof(u32);
-	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
-		wc.imm_data = 0;
-		wc.wc_flags = 0;
-	} else {
-		dev->n_pkt_drops++;
-		goto bail;
-	}
-
-	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
 	if (qp->r_reuse_sge)
