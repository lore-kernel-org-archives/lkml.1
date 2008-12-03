Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYLCUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYLCUPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYLCTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:41 -0500
Received: from kroah.org ([198.145.64.141]:60411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754480AbYLCTyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:40 -0500
Date: Wed, 3 Dec 2008 11:53:18 -0800
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
       alan@lxorguk.ukuu.org.uk, Jack Morgenstein <jackm@dev.mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 065/104] IB/mlx4: Fix MTT leakage in resize CQ
Message-ID: <20081203195318.GN8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-mlx4-fix-mtt-leakage-in-resize-cq.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 42ab01c31526ac1d06d193f81a498bf3cf2acfe4 upstream.

When resizing a CQ, MTTs associated with the old CQE buffer were not
freed.  As a result, if any app used resize CQ repeatedly, all MTTs
were eventually exhausted, which led to all memory registration
operations failing until the driver is reloaded.

Once the RESIZE_CQ command returns successfully from FW, FW no longer
accesses the old CQ buffer, so it is safe to deallocate the MTT
entries used by the old CQ buffer.

Finally, if the RESIZE_CQ command fails, the MTTs allocated for the
new CQEs buffer also need to be de-allocated.

This fixes <https://bugs.openfabrics.org/show_bug.cgi?id=1416>.

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mlx4/cq.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -343,6 +343,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibcq->device);
 	struct mlx4_ib_cq *cq = to_mcq(ibcq);
+	struct mlx4_mtt mtt;
 	int outst_cqe;
 	int err;
 
@@ -376,10 +377,13 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq
 			goto out;
 	}
 
+	mtt = cq->buf.mtt;
+
 	err = mlx4_cq_resize(dev->dev, &cq->mcq, entries, &cq->resize_buf->buf.mtt);
 	if (err)
 		goto err_buf;
 
+	mlx4_mtt_cleanup(dev->dev, &mtt);
 	if (ibcq->uobject) {
 		cq->buf      = cq->resize_buf->buf;
 		cq->ibcq.cqe = cq->resize_buf->cqe;
@@ -406,6 +410,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq
 	goto out;
 
 err_buf:
+	mlx4_mtt_cleanup(dev->dev, &cq->resize_buf->buf.mtt);
 	if (!ibcq->uobject)
 		mlx4_ib_free_cq_buf(dev, &cq->resize_buf->buf,
 				    cq->resize_buf->cqe);

