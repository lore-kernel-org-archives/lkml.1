Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYEWR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYEWR5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYEWR5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:57:46 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:16070 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYEWR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:57:43 -0400
X-IronPort-AV: E=Sophos;i="4.27,531,1204531200"; 
   d="scan'208";a="49848962"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 23 May 2008 10:57:41 -0700
Message-ID: <adaiqx4aooa.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2008 17:57:41.0899 (UTC) FILETIME=[7F07C5B0:01C8BCFE]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fixes for various issues:

 - Various trivial fixes that get rid of warnings
 - A couple of oopsable bugs fixed
 - Fixes for mthca/mlx4 driver bugs that stop NFS/RDMA from working
 - MAINTAINERS entry for Chelsio drivers

Andrew Morton (1):
      IB/mlx4: Fix uninitialized-var warning in mlx4_ib_post_send()

Dave Olson (1):
      IB/mad: Fix kernel crash when .process_mad() returns SUCCESS|CONSUMED

Jack Morgenstein (1):
      IPoIB: Test for NULL broadcast object in ipiob_mcast_join_finish()

Ralph Campbell (1):
      IB/ipath: Fix UC receive completion opcode for RDMA WRITE with immediate

Roland Dreier (4):
      IB/ipath: Fix printk format for ipath_sdma_status
      RDMA/cxgb3: Fix uninitialized variable warning in iwch_post_send()
      IB/mthca: Fix max_sge value returned by query_device
      IB/mlx4: Fix creation of kernel QP with max number of send s/g entries

Steve Wise (1):
      MAINTAINERS: Add cxgb3 and iw_cxgb3 NIC and iWARP driver entries

 MAINTAINERS                                    |   14 ++++++++++++++
 drivers/infiniband/core/mad.c                  |    4 +++-
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c       |    4 ++--
 drivers/infiniband/hw/ipath/ipath_uc.c         |    4 ++--
 drivers/infiniband/hw/mlx4/qp.c                |   15 +++++++++------
 drivers/infiniband/hw/mthca/mthca_main.c       |   14 +++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 ++++++
 8 files changed, 50 insertions(+), 13 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index bc1c008..907d8c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1239,6 +1239,20 @@ L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 S:	Maintained
 
+CXGB3 ETHERNET DRIVER (CXGB3)
+P:	Divy Le Ray
+M:	divy@chelsio.com
+L:	netdev@vger.kernel.org
+W:	http://www.chelsio.com
+S:	Supported
+
+CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
+P:	Steve Wise
+M:	swise@chelsio.com
+L:	general@lists.openfabrics.org
+W:	http://www.openfabrics.org
+S:	Supported
+
 CYBERPRO FB DRIVER
 P:	Russell King
 M:	rmk@arm.linux.org.uk
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index fbe16d5..1adf2ef 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -747,7 +747,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		break;
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED:
 		kmem_cache_free(ib_mad_cache, mad_priv);
-		break;
+		kfree(local);
+		ret = 1;
+		goto out;
 	case IB_MAD_RESULT_SUCCESS:
 		/* Treat like an incoming receive MAD */
 		port_priv = ib_get_mad_port(mad_agent_priv->agent.device,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 79dbe5b..9926137 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -229,7 +229,7 @@ int iwch_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
 	int err = 0;
-	u8 t3_wr_flit_cnt;
+	u8 uninitialized_var(t3_wr_flit_cnt);
 	enum t3_wr_opcode t3_wr_opcode = 0;
 	enum t3_wr_flags t3_wr_flags;
 	struct iwch_qp *qhp;
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 3697449..0a8c1b8 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -345,7 +345,7 @@ resched:
 	 * state change
 	 */
 	if (jiffies > dd->ipath_sdma_abort_jiffies) {
-		ipath_dbg("looping with status 0x%016llx\n",
+		ipath_dbg("looping with status 0x%08lx\n",
 			  dd->ipath_sdma_status);
 		dd->ipath_sdma_abort_jiffies = jiffies + 5 * HZ;
 	}
@@ -615,7 +615,7 @@ void ipath_restart_sdma(struct ipath_devdata *dd)
 	}
 	spin_unlock_irqrestore(&dd->ipath_sdma_lock, flags);
 	if (!needed) {
-		ipath_dbg("invalid attempt to restart SDMA, status 0x%016llx\n",
+		ipath_dbg("invalid attempt to restart SDMA, status 0x%08lx\n",
 			dd->ipath_sdma_status);
 		goto bail;
 	}
diff --git a/drivers/infiniband/hw/ipath/ipath_uc.c b/drivers/infiniband/hw/ipath/ipath_uc.c
index 7fd18e8..0596ec1 100644
--- a/drivers/infiniband/hw/ipath/ipath_uc.c
+++ b/drivers/infiniband/hw/ipath/ipath_uc.c
@@ -407,12 +407,11 @@ void ipath_uc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 			dev->n_pkt_drops++;
 			goto done;
 		}
-		/* XXX Need to free SGEs */
+		wc.opcode = IB_WC_RECV;
 	last_imm:
 		ipath_copy_sge(&qp->r_sge, data, tlen);
 		wc.wr_id = qp->r_wr_id;
 		wc.status = IB_WC_SUCCESS;
-		wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
 		wc.slid = qp->remote_ah_attr.dlid;
@@ -514,6 +513,7 @@ void ipath_uc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 			goto done;
 		}
 		wc.byte_len = qp->r_len;
+		wc.opcode = IB_WC_RECV_RDMA_WITH_IMM;
 		goto last_imm;
 
 	case OP(RDMA_WRITE_LAST):
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8e02ecf..a80df22 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -333,6 +333,9 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		cap->max_inline_data + sizeof (struct mlx4_wqe_inline_seg)) +
 		send_wqe_overhead(type, qp->flags);
 
+	if (s > dev->dev->caps.max_sq_desc_sz)
+		return -EINVAL;
+
 	/*
 	 * Hermon supports shrinking WQEs, such that a single work
 	 * request can include multiple units of 1 << wqe_shift.  This
@@ -372,9 +375,6 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		qp->sq.wqe_shift = ilog2(roundup_pow_of_two(s));
 
 	for (;;) {
-		if (1 << qp->sq.wqe_shift > dev->dev->caps.max_sq_desc_sz)
-			return -EINVAL;
-
 		qp->sq_max_wqes_per_wr = DIV_ROUND_UP(s, 1U << qp->sq.wqe_shift);
 
 		/*
@@ -395,7 +395,8 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		++qp->sq.wqe_shift;
 	}
 
-	qp->sq.max_gs = ((qp->sq_max_wqes_per_wr << qp->sq.wqe_shift) -
+	qp->sq.max_gs = (min(dev->dev->caps.max_sq_desc_sz,
+			     (qp->sq_max_wqes_per_wr << qp->sq.wqe_shift)) -
 			 send_wqe_overhead(type, qp->flags)) /
 		sizeof (struct mlx4_wqe_data_seg);
 
@@ -411,7 +412,9 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 
 	cap->max_send_wr  = qp->sq.max_post =
 		(qp->sq.wqe_cnt - qp->sq_spare_wqes) / qp->sq_max_wqes_per_wr;
-	cap->max_send_sge = qp->sq.max_gs;
+	cap->max_send_sge = min(qp->sq.max_gs,
+				min(dev->dev->caps.max_sq_sg,
+				    dev->dev->caps.max_rq_sg));
 	/* We don't support inline sends for kernel QPs (yet) */
 	cap->max_inline_data = 0;
 
@@ -1457,7 +1460,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	unsigned ind;
 	int uninitialized_var(stamp);
 	int uninitialized_var(size);
-	unsigned seglen;
+	unsigned uninitialized_var(seglen);
 	int i;
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 9ebadd6..200cf13 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -45,6 +45,7 @@
 #include "mthca_cmd.h"
 #include "mthca_profile.h"
 #include "mthca_memfree.h"
+#include "mthca_wqe.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox InfiniBand HCA low-level driver");
@@ -200,7 +201,18 @@ static int mthca_dev_lim(struct mthca_dev *mdev, struct mthca_dev_lim *dev_lim)
 	mdev->limits.gid_table_len  	= dev_lim->max_gids;
 	mdev->limits.pkey_table_len 	= dev_lim->max_pkeys;
 	mdev->limits.local_ca_ack_delay = dev_lim->local_ca_ack_delay;
-	mdev->limits.max_sg             = dev_lim->max_sg;
+	/*
+	 * Need to allow for worst case send WQE overhead and check
+	 * whether max_desc_sz imposes a lower limit than max_sg; UD
+	 * send has the biggest overhead.
+	 */
+	mdev->limits.max_sg		= min_t(int, dev_lim->max_sg,
+					      (dev_lim->max_desc_sz -
+					       sizeof (struct mthca_next_seg) -
+					       (mthca_is_memfree(mdev) ?
+						sizeof (struct mthca_arbel_ud_seg) :
+						sizeof (struct mthca_tavor_ud_seg))) /
+						sizeof (struct mthca_data_seg));
 	mdev->limits.max_wqes           = dev_lim->max_qp_sz;
 	mdev->limits.max_qp_init_rdma   = dev_lim->max_requester_per_qp;
 	mdev->limits.reserved_qps       = dev_lim->reserved_qps;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index d00a2c1..3f663fb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -194,7 +194,13 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 	/* Set the cached Q_Key before we attach if it's the broadcast group */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
+		spin_lock_irq(&priv->lock);
+		if (!priv->broadcast) {
+			spin_unlock_irq(&priv->lock);
+			return -EAGAIN;
+		}
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
+		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 	}
 
