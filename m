Return-Path: <linux-kernel-owner+w=401wt.eu-S1765324AbZGABCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765324AbZGABCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759836AbZGAAfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:02 -0400
Received: from kroah.org ([198.145.64.141]:60434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761491AbZGAAe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:31 2009
Message-Id: <20090701002430.902345957@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jack Morgenstein <jackm@dev.mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 057/108] IB/mlx4: Add strong ordering to local inval and fast reg work requests
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ib-mlx4-add-strong-ordering-to-local-inval-and-fast-reg-work-requests.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 2ac6bf4ddc87c3b6b609f8fa82f6ebbffeac12f4 upstream.

The ConnectX Programmer's Reference Manual states that the "SO" bit
must be set when posting Fast Register and Local Invalidate send work
requests.  When this bit is set, the work request will be executed
only after all previous work requests on the send queue have been
executed.  (If the bit is not set, Fast Register and Local Invalidate
WQEs may begin execution too early, which violates the defined
semantics for these operations)

This fixes the issue with NFS/RDMA reported in
<http://lists.openfabrics.org/pipermail/general/2009-April/059253.html>

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mlx4/qp.c |    4 ++++
 include/linux/mlx4/qp.h         |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1585,12 +1585,16 @@ int mlx4_ib_post_send(struct ib_qp *ibqp
 				break;
 
 			case IB_WR_LOCAL_INV:
+				ctrl->srcrb_flags |=
+					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
 				set_local_inv_seg(wqe, wr->ex.invalidate_rkey);
 				wqe  += sizeof (struct mlx4_wqe_local_inval_seg);
 				size += sizeof (struct mlx4_wqe_local_inval_seg) / 16;
 				break;
 
 			case IB_WR_FAST_REG_MR:
+				ctrl->srcrb_flags |=
+					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
 				set_fmr_seg(wqe, wr);
 				wqe  += sizeof (struct mlx4_wqe_fmr_seg);
 				size += sizeof (struct mlx4_wqe_fmr_seg) / 16;
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -165,6 +165,7 @@ enum {
 	MLX4_WQE_CTRL_IP_CSUM		= 1 << 4,
 	MLX4_WQE_CTRL_TCP_UDP_CSUM	= 1 << 5,
 	MLX4_WQE_CTRL_INS_VLAN		= 1 << 6,
+	MLX4_WQE_CTRL_STRONG_ORDER	= 1 << 7,
 };
 
 struct mlx4_wqe_ctrl_seg {


