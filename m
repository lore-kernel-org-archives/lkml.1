Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXDTWcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXDTWcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXDTWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:32:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:4727 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXDTWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:32:48 -0400
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="414003415:sNHT230871602"
Subject: [PATCH 2/6] [RFC]mlx4_core rest of files
In-Reply-To: <20074201532.IZZ23OZ6UzBQwQQb@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.d6hTKIczPSz0SeTA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:37.0074 (UTC) FILETIME=[CC197B20:01C7839B]
Authentication-Results: sj-dkim-7; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rest of mlx4_core code.

Signed-off-by: Roland Dreier <rolandd@cisco.com>

---

 alloc.c |  179 ++++++++++++++++
 cq.c    |  254 +++++++++++++++++++++++
 eq.c    |  704 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 icm.c   |  379 ++++++++++++++++++++++++++++++++++
 icm.h   |  135 ++++++++++++
 mcg.c   |  370 +++++++++++++++++++++++++++++++++
 mr.c    |  482 +++++++++++++++++++++++++++++++++++++++++++
 pd.c    |  102 +++++++++
 qp.c    |  270 ++++++++++++++++++++++++
 srq.c   |  227 ++++++++++++++++++++
 10 files changed, 3102 insertions(+)

diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
new file mode 100644
index 0000000..9ffdb9d
--- /dev/null
+++ b/drivers/net/mlx4/alloc.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (c) 2006, 2007 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/bitmap.h>
+
+#include "mlx4.h"
+
+u32 mlx4_bitmap_alloc(struct mlx4_bitmap *bitmap)
+{
+	u32 obj;
+
+	spin_lock(&bitmap->lock);
+
+	obj = find_next_zero_bit(bitmap->table, bitmap->max, bitmap->last);
+	if (obj >= bitmap->max) {
+		bitmap->top = (bitmap->top + bitmap->max) & bitmap->mask;
+		obj = find_first_zero_bit(bitmap->table, bitmap->max);
+	}
+
+	if (obj < bitmap->max) {
+		set_bit(obj, bitmap->table);
+		obj |= bitmap->top;
+		bitmap->last = obj + 1;
+	} else
+		obj = -1;
+
+	spin_unlock(&bitmap->lock);
+
+	return obj;
+}
+
+void mlx4_bitmap_free(struct mlx4_bitmap *bitmap, u32 obj)
+{
+	obj &= bitmap->max - 1;
+
+	spin_lock(&bitmap->lock);
+	clear_bit(obj, bitmap->table);
+	bitmap->last = min(bitmap->last, obj);
+	bitmap->top = (bitmap->top + bitmap->max) & bitmap->mask;
+	spin_unlock(&bitmap->lock);
+}
+
+int mlx4_bitmap_init(struct mlx4_bitmap *bitmap, u32 num, u32 mask, u32 reserved)
+{
+	int i;
+
+	/* num must be a power of 2 */
+	if (num != roundup_pow_of_two(num))
+		return -EINVAL;
+
+	bitmap->last = 0;
+	bitmap->top  = 0;
+	bitmap->max  = num;
+	bitmap->mask = mask;
+	spin_lock_init(&bitmap->lock);
+	bitmap->table = kzalloc(BITS_TO_LONGS(num) * sizeof (long), GFP_KERNEL);
+	if (!bitmap->table)
+		return -ENOMEM;
+
+	for (i = 0; i < reserved; ++i)
+		set_bit(i, bitmap->table);
+
+	return 0;
+}
+
+void mlx4_bitmap_cleanup(struct mlx4_bitmap *bitmap)
+{
+	kfree(bitmap->table);
+}
+
+/*
+ * Handling for queue buffers -- we allocate a bunch of memory and
+ * register it in a memory region at HCA virtual address 0.  If the
+ * requested size is > max_direct, we split the allocation into
+ * multiple pages, so we don't require too much contiguous memory.
+ */
+
+int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
+		   struct mlx4_buf *buf)
+{
+	dma_addr_t t;
+
+	if (size <= max_direct) {
+		buf->nbufs        = 1;
+		buf->npages       = 1;
+		buf->page_shift   = get_order(size) + PAGE_SHIFT;
+		buf->u.direct.buf = dma_alloc_coherent(&dev->pdev->dev,
+						       size, &t, GFP_KERNEL);
+		if (!buf->u.direct.buf)
+			return -ENOMEM;
+
+		buf->u.direct.map = t;
+
+		while (t & ((1 << buf->page_shift) - 1)) {
+			--buf->page_shift;
+			buf->npages *= 2;
+		}
+
+		memset(buf->u.direct.buf, 0, size);
+	} else {
+		int i;
+
+		buf->nbufs       = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+		buf->npages      = buf->nbufs;
+		buf->page_shift  = PAGE_SHIFT;
+		buf->u.page_list = kzalloc(buf->nbufs * sizeof *buf->u.page_list,
+					   GFP_KERNEL);
+		if (!buf->u.page_list)
+			return -ENOMEM;
+
+		for (i = 0; i < buf->nbufs; ++i) {
+			buf->u.page_list[i].buf =
+				dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
+						   &t, GFP_KERNEL);
+			if (!buf->u.page_list[i].buf)
+				goto err_free;
+
+			buf->u.page_list[i].map = t;
+
+			memset(buf->u.page_list[i].buf, 0, PAGE_SIZE);
+		}
+	}
+
+	return 0;
+
+err_free:
+	mlx4_buf_free(dev, size, buf);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(mlx4_buf_alloc);
+
+void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf)
+{
+	int i;
+
+	if (buf->nbufs == 1)
+		dma_free_coherent(&dev->pdev->dev, size, buf->u.direct.buf,
+				  buf->u.direct.map);
+	else {
+		for (i = 0; i < buf->nbufs; ++i)
+			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+					  buf->u.page_list[i].buf,
+					  buf->u.page_list[i].map);
+		kfree(buf->u.page_list);
+	}
+}
+EXPORT_SYMBOL_GPL(mlx4_buf_free);
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
new file mode 100644
index 0000000..47e84c7
--- /dev/null
+++ b/drivers/net/mlx4/cq.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/hardirq.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+#include "icm.h"
+
+struct mlx4_cq_context {
+	__be32			flags;
+	u16			reserved1[3];
+	__be16			page_offset;
+	__be32			logsize_usrpage;
+	u8			reserved2;
+	u8			cq_period;
+	u8			reserved3;
+	u8			cq_max_count;
+	u8			reserved4[3];
+	u8			comp_eqn;
+	u8			log_page_size;
+	u8			reserved5[2];
+	u8			mtt_base_addr_h;
+	__be32			mtt_base_addr_l;
+	__be32			last_notified_index;
+	__be32			solicit_producer_index;
+	__be32			consumer_index;
+	__be32			producer_index;
+	u8			reserved6[2];
+	__be64			db_rec_addr;
+};
+
+#define MLX4_CQ_STATUS_OK		( 0 << 28)
+#define MLX4_CQ_STATUS_OVERFLOW		( 9 << 28)
+#define MLX4_CQ_STATUS_WRITE_FAIL	(10 << 28)
+#define MLX4_CQ_FLAG_CC			( 1 << 18)
+#define MLX4_CQ_FLAG_OI			( 1 << 17)
+#define MLX4_CQ_STATE_ARMED		( 9 <<  8)
+#define MLX4_CQ_STATE_ARMED_SOL		( 6 <<  8)
+#define MLX4_EQ_STATE_FIRED		(10 <<  8)
+
+void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
+{
+	struct mlx4_cq *cq;
+
+	cq = radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
+			       cqn & (dev->caps.num_cqs - 1));
+	if (!cq) {
+		mlx4_warn(dev, "Completion event for bogus CQ %08x\n", cqn);
+		return;
+	}
+
+	++cq->arm_sn;
+
+	cq->comp(cq);
+}
+
+void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
+{
+	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
+	struct mlx4_cq *cq;
+
+	spin_lock(&cq_table->lock);
+
+	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
+	if (cq)
+		atomic_inc(&cq->refcount);
+
+	spin_unlock(&cq_table->lock);
+
+	if (!cq) {
+		mlx4_warn(dev, "Async event for bogus CQ %08x\n", cqn);
+		return;
+	}
+
+	cq->event(cq, event_type);
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
+}
+
+static int mlx4_SW2HW_CQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			 int cq_num)
+{
+	return mlx4_cmd(dev, mailbox->dma, cq_num, 0, MLX4_CMD_SW2HW_CQ,
+			MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_HW2SW_CQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			 int cq_num)
+{
+	return mlx4_cmd_box(dev, 0, mailbox ? mailbox->dma : 0, cq_num,
+			    mailbox ? 0 : 1, MLX4_CMD_HW2SW_CQ,
+			    MLX4_CMD_TIME_CLASS_A);
+}
+
+int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
+		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cq_table *cq_table = &priv->cq_table;
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_cq_context *cq_context;
+	u64 mtt_addr;
+	int err;
+
+	cq->cqn = mlx4_bitmap_alloc(&cq_table->bitmap);
+	if (cq->cqn == -1)
+		return -ENOMEM;
+
+	err = mlx4_table_get(dev, &cq_table->table, cq->cqn);
+	if (err)
+		goto err_out;
+
+	err = mlx4_table_get(dev, &cq_table->cmpt_table, cq->cqn);
+	if (err)
+		goto err_put;
+
+	spin_lock_irq(&cq_table->lock);
+	err = radix_tree_insert(&cq_table->tree, cq->cqn, cq);
+	spin_unlock_irq(&cq_table->lock);
+	if (err)
+		goto err_cmpt_put;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = PTR_ERR(mailbox);
+		goto err_radix;
+	}
+
+	cq_context = mailbox->buf;
+	memset(cq_context, 0, sizeof *cq_context);
+
+	cq_context->logsize_usrpage = cpu_to_be32((ilog2(nent) << 24) | uar->index);
+	cq_context->comp_eqn        = priv->eq_table.eq[MLX4_EQ_COMP].eqn;
+	cq_context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
+
+	mtt_addr = mlx4_mtt_addr(dev, mtt);
+	cq_context->mtt_base_addr_h = mtt_addr >> 32;
+	cq_context->mtt_base_addr_l = cpu_to_be32(mtt_addr & 0xffffffff);
+	cq_context->db_rec_addr     = cpu_to_be64(db_rec);
+
+	err = mlx4_SW2HW_CQ(dev, mailbox, cq->cqn);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	if (err)
+		goto err_radix;
+
+	cq->cons_index = 0;
+	cq->arm_sn     = 1;
+	cq->uar        = uar;
+	atomic_set(&cq->refcount, 1);
+	init_completion(&cq->free);
+
+	return 0;
+
+err_radix:
+	spin_lock_irq(&cq_table->lock);
+	radix_tree_delete(&cq_table->tree, cq->cqn);
+	spin_unlock_irq(&cq_table->lock);
+
+err_cmpt_put:
+	mlx4_table_put(dev, &cq_table->cmpt_table, cq->cqn);
+
+err_put:
+	mlx4_table_put(dev, &cq_table->table, cq->cqn);
+
+err_out:
+	mlx4_bitmap_free(&cq_table->bitmap, cq->cqn);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_cq_alloc);
+
+void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cq_table *cq_table = &priv->cq_table;
+	int err;
+
+	err = mlx4_HW2SW_CQ(dev, NULL, cq->cqn);
+	if (err)
+		mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n", err, cq->cqn);
+
+	synchronize_irq(priv->eq_table.eq[MLX4_EQ_COMP].irq);
+
+	spin_lock_irq(&cq_table->lock);
+	radix_tree_delete(&cq_table->tree, cq->cqn);
+	spin_unlock_irq(&cq_table->lock);
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
+	wait_for_completion(&cq->free);
+
+	mlx4_table_put(dev, &cq_table->table, cq->cqn);
+	mlx4_bitmap_free(&cq_table->bitmap, cq->cqn);
+}
+EXPORT_SYMBOL_GPL(mlx4_cq_free);
+
+int __devinit mlx4_init_cq_table(struct mlx4_dev *dev)
+{
+	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
+	int err;
+
+	spin_lock_init(&cq_table->lock);
+	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
+
+	err = mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
+			       dev->caps.num_cqs - 1, dev->caps.reserved_cqs);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void mlx4_cleanup_cq_table(struct mlx4_dev *dev)
+{
+	/* Nothing to do to clean up radix_tree */
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->cq_table.bitmap);
+}
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
new file mode 100644
index 0000000..99fccd1
--- /dev/null
+++ b/drivers/net/mlx4/eq.c
@@ -0,0 +1,704 @@
+/*
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems, Inc.	 All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+#include "fw.h"
+
+enum {
+	MLX4_NUM_ASYNC_EQE	= 0x100,
+	MLX4_NUM_SPARE_EQE	= 0x80,
+	MLX4_EQ_ENTRY_SIZE	= 0x20
+};
+
+/*
+ * Must be packed because start is 64 bits but only aligned to 32 bits.
+ */
+struct mlx4_eq_context {
+	__be32			flags;
+	u16			reserved1[3];
+	__be16			page_offset;
+	u8			log_eq_size;
+	u8			reserved2[4];
+	u8			eq_period;
+	u8			reserved3;
+	u8			eq_max_count;
+	u8			reserved4[3];
+	u8			intr;
+	u8			log_page_size;
+	u8			reserved5[2];
+	u8			mtt_base_addr_h;
+	__be32			mtt_base_addr_l;
+	u32			reserved6[2];
+	__be32			consumer_index;
+	__be32			producer_index;
+	u32			reserved7[4];
+};
+
+#define MLX4_EQ_STATUS_OK	   ( 0 << 28)
+#define MLX4_EQ_STATUS_WRITE_FAIL  (10 << 28)
+#define MLX4_EQ_OWNER_SW	   ( 0 << 24)
+#define MLX4_EQ_OWNER_HW	   ( 1 << 24)
+#define MLX4_EQ_FLAG_EC		   ( 1 << 18)
+#define MLX4_EQ_FLAG_OI		   ( 1 << 17)
+#define MLX4_EQ_STATE_ARMED	   ( 9 <<  8)
+#define MLX4_EQ_STATE_FIRED	   (10 <<  8)
+#define MLX4_EQ_STATE_ALWAYS_ARMED (11 <<  8)
+
+#define MLX4_ASYNC_EVENT_MASK ((1ull << MLX4_EVENT_TYPE_PATH_MIG)	    | \
+			       (1ull << MLX4_EVENT_TYPE_COMM_EST)	    | \
+			       (1ull << MLX4_EVENT_TYPE_SQ_DRAINED)	    | \
+			       (1ull << MLX4_EVENT_TYPE_CQ_ERROR)	    | \
+			       (1ull << MLX4_EVENT_TYPE_WQ_CATAS_ERROR)	    | \
+			       (1ull << MLX4_EVENT_TYPE_EEC_CATAS_ERROR)    | \
+			       (1ull << MLX4_EVENT_TYPE_PATH_MIG_FAILED)    | \
+			       (1ull << MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR) | \
+			       (1ull << MLX4_EVENT_TYPE_WQ_ACCESS_ERROR)    | \
+			       (1ull << MLX4_EVENT_TYPE_LOCAL_CATAS_ERROR)  | \
+			       (1ull << MLX4_EVENT_TYPE_PORT_CHANGE)	    | \
+			       (1ull << MLX4_EVENT_TYPE_ECC_DETECT)	    | \
+			       (1ull << MLX4_EVENT_TYPE_SRQ_CATAS_ERROR)    | \
+			       (1ull << MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE)    | \
+			       (1ull << MLX4_EVENT_TYPE_SRQ_LIMIT)	    | \
+			       (1ull << MLX4_EVENT_TYPE_CMD))
+#define MLX4_CATAS_EVENT_MASK  (1ull << MLX4_EVENT_TYPE_LOCAL_CATAS_ERROR)
+
+struct mlx4_eqe {
+	u8			reserved1;
+	u8			type;
+	u8			reserved2;
+	u8			subtype;
+	union {
+		u32		raw[6];
+		struct {
+			__be32	cqn;
+		} __attribute__((packed)) comp;
+		struct {
+			u16	reserved1;
+			__be16	token;
+			u32	reserved2;
+			u8	reserved3[3];
+			u8	status;
+			__be64	out_param;
+		} __attribute__((packed)) cmd;
+		struct {
+			__be32	qpn;
+		} __attribute__((packed)) qp;
+		struct {
+			__be32	srqn;
+		} __attribute__((packed)) srq;
+		struct {
+			__be32	cqn;
+			u32	reserved1;
+			u8	reserved2[3];
+			u8	syndrome;
+		} __attribute__((packed)) cq_err;
+		struct {
+			u32	reserved1[2];
+			__be32	port;
+		} __attribute__((packed)) port_change;
+	}			event;
+	u8			reserved3[3];
+	u8			owner;
+} __attribute__((packed));
+
+static void eq_set_ci(struct mlx4_eq *eq, int req_not)
+{
+	__raw_writel((__force u32) cpu_to_be32((eq->cons_index & 0xffffff) |
+					       req_not << 31),
+		     eq->doorbell);
+	/* We still want ordering, just not swabbing, so add a barrier */
+	mb();
+}
+
+static struct mlx4_eqe *get_eqe(struct mlx4_eq *eq, u32 entry)
+{
+	unsigned long off = (entry & (eq->nent - 1)) * MLX4_EQ_ENTRY_SIZE;
+	return eq->page_list[off / PAGE_SIZE].buf + off % PAGE_SIZE;
+}
+
+static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq)
+{
+	struct mlx4_eqe *eqe = get_eqe(eq, eq->cons_index);
+	return !!(eqe->owner & 0x80) ^ !!(eq->cons_index & eq->nent) ? NULL : eqe;
+}
+
+static void port_change(struct mlx4_dev *dev, int port, int active)
+{
+	mlx4_dbg(dev, "Port change to %s for port %d\n",
+		 active ? "active" : "down", port);
+}
+
+static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
+{
+	struct mlx4_eqe *eqe;
+	int cqn;
+	int eqes_found = 0;
+	int set_ci = 0;
+
+	while ((eqe = next_eqe_sw(eq))) {
+		/*
+		 * Make sure we read EQ entry contents after we've
+		 * checked the ownership bit.
+		 */
+		rmb();
+
+		switch (eqe->type) {
+		case MLX4_EVENT_TYPE_COMP:
+			cqn = be32_to_cpu(eqe->event.comp.cqn) & 0xffffff;
+			mlx4_cq_completion(dev, cqn);
+			break;
+
+		case MLX4_EVENT_TYPE_PATH_MIG:
+		case MLX4_EVENT_TYPE_COMM_EST:
+		case MLX4_EVENT_TYPE_SQ_DRAINED:
+		case MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE:
+		case MLX4_EVENT_TYPE_WQ_CATAS_ERROR:
+		case MLX4_EVENT_TYPE_PATH_MIG_FAILED:
+		case MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
+			mlx4_qp_event(dev, be32_to_cpu(eqe->event.qp.qpn) & 0xffffff,
+				      eqe->type);
+			break;
+
+		case MLX4_EVENT_TYPE_SRQ_LIMIT:
+		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
+			mlx4_srq_event(dev, be32_to_cpu(eqe->event.srq.srqn) & 0xffffff,
+				      eqe->type);
+			break;
+
+		case MLX4_EVENT_TYPE_CMD:
+			mlx4_cmd_event(dev,
+				       be16_to_cpu(eqe->event.cmd.token),
+				       eqe->event.cmd.status,
+				       be64_to_cpu(eqe->event.cmd.out_param));
+			break;
+
+		case MLX4_EVENT_TYPE_PORT_CHANGE:
+			port_change(dev,
+				    (be32_to_cpu(eqe->event.port_change.port) >> 28) & 3,
+				    eqe->subtype == 0x4);
+			break;
+
+		case MLX4_EVENT_TYPE_CQ_ERROR:
+			mlx4_warn(dev, "CQ %s on CQN %06x\n",
+				  eqe->event.cq_err.syndrome == 1 ?
+				  "overrun" : "access violation",
+				  be32_to_cpu(eqe->event.cq_err.cqn) & 0xffffff);
+			mlx4_cq_event(dev, be32_to_cpu(eqe->event.cq_err.cqn),
+				      eqe->type);
+			break;
+
+		case MLX4_EVENT_TYPE_EQ_OVERFLOW:
+			mlx4_warn(dev, "EQ overrun on EQN %d\n", eq->eqn);
+			break;
+
+		case MLX4_EVENT_TYPE_EEC_CATAS_ERROR:
+		case MLX4_EVENT_TYPE_ECC_DETECT:
+		default:
+			mlx4_warn(dev, "Unhandled event %02x(%02x) on EQ %d at index %u\n",
+				  eqe->type, eqe->subtype, eq->eqn, eq->cons_index);
+			break;
+		};
+
+		++eq->cons_index;
+		eqes_found = 1;
+		++set_ci;
+
+		/*
+		 * The HCA will think the queue has overflowed if we
+		 * don't tell it we've been processing events.  We
+		 * create our EQs with MLX4_NUM_SPARE_EQE extra
+		 * entries, so we must update our consumer index at
+		 * least that often.
+		 */
+		if (unlikely(set_ci >= MLX4_NUM_SPARE_EQE)) {
+			/*
+			 * Conditional on hca_type is OK here because
+			 * this is a rare case, not the fast path.
+			 */
+			eq_set_ci(eq, 0);
+			set_ci = 0;
+		}
+	}
+
+	if (eqes_found)
+		eq_set_ci(eq, 1);
+
+	return eqes_found;
+}
+
+static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
+{
+	struct mlx4_dev *dev = dev_ptr;
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int work = 0;
+	int i;
+
+	writel(priv->eq_table.clr_mask, priv->eq_table.clr_int);
+
+	for (i = 0; i < MLX4_EQ_CATAS; ++i)
+		work |= mlx4_eq_int(dev, &priv->eq_table.eq[i]);
+
+	return IRQ_RETVAL(work);
+}
+
+static irqreturn_t mlx4_msi_x_interrupt(int irq, void *eq_ptr)
+{
+	struct mlx4_eq  *eq  = eq_ptr;
+	struct mlx4_dev *dev = eq->dev;
+
+	mlx4_eq_int(dev, eq);
+
+	/* MSI-X vectors always belong to us */
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mlx4_catas_interrupt(int irq, void *eq_ptr)
+{
+	struct mlx4_eq  *eq  = eq_ptr;
+	struct mlx4_dev *dev = eq->dev;
+
+	mlx4_err(dev, "catastrophic error detected.\n");
+	/* FIXME handle catastrophic error */
+
+	/* MSI-X vectors always belong to us */
+	return IRQ_HANDLED;
+}
+
+static int mlx4_MAP_EQ(struct mlx4_dev *dev, u64 event_mask, int unmap,
+			int eq_num)
+{
+	return mlx4_cmd(dev, event_mask, (unmap << 31) | eq_num,
+			0, MLX4_CMD_MAP_EQ, MLX4_CMD_TIME_CLASS_B);
+}
+
+static int mlx4_SW2HW_EQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			 int eq_num)
+{
+	return mlx4_cmd(dev, mailbox->dma, eq_num, 0, MLX4_CMD_SW2HW_EQ,
+			MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_HW2SW_EQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			 int eq_num)
+{
+	return mlx4_cmd_box(dev, 0, mailbox->dma, eq_num, 0, MLX4_CMD_HW2SW_EQ,
+			    MLX4_CMD_TIME_CLASS_A);
+}
+
+static void __devinit __iomem *mlx4_get_eq_uar(struct mlx4_dev *dev,
+					       struct mlx4_eq *eq)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int index;
+
+	index = eq->eqn / 4 - dev->caps.reserved_eqs / 4;
+
+	if (!priv->eq_table.uar_map[index]) {
+		priv->eq_table.uar_map[index] =
+			ioremap(pci_resource_start(dev->pdev, 2) +
+				((eq->eqn / 4) << PAGE_SHIFT),
+				PAGE_SIZE);
+		if (!priv->eq_table.uar_map[index]) {
+			mlx4_err(dev, "Couldn't map EQ doorbell for EQN 0x%06x\n",
+				 eq->eqn);
+			return NULL;
+		}
+	}
+
+	return priv->eq_table.uar_map[index] + 0x800 + 8 * (eq->eqn % 4);
+}
+
+static int __devinit mlx4_create_eq(struct mlx4_dev *dev, int nent,
+				    u8 intr, struct mlx4_eq *eq)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_eq_context *eq_context;
+	int npages;
+	u64 *dma_list = NULL;
+	dma_addr_t t;
+	u64 mtt_addr;
+	int err = -ENOMEM;
+	int i;
+
+	eq->dev   = dev;
+	eq->nent  = roundup_pow_of_two(max(nent, 2));
+	npages = PAGE_ALIGN(eq->nent * MLX4_EQ_ENTRY_SIZE) / PAGE_SIZE;
+
+	eq->page_list = kmalloc(npages * sizeof *eq->page_list,
+				GFP_KERNEL);
+	if (!eq->page_list)
+		goto err_out;
+
+	for (i = 0; i < npages; ++i)
+		eq->page_list[i].buf = NULL;
+
+	dma_list = kmalloc(npages * sizeof *dma_list, GFP_KERNEL);
+	if (!dma_list)
+		goto err_out_free;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		goto err_out_free;
+	eq_context = mailbox->buf;
+
+	for (i = 0; i < npages; ++i) {
+		eq->page_list[i].buf = dma_alloc_coherent(&dev->pdev->dev,
+							  PAGE_SIZE, &t, GFP_KERNEL);
+		if (!eq->page_list[i].buf)
+			goto err_out_free_pages;
+
+		dma_list[i] = t;
+		eq->page_list[i].map = t;
+
+		memset(eq->page_list[i].buf, 0, PAGE_SIZE);
+	}
+
+	eq->eqn = mlx4_bitmap_alloc(&priv->eq_table.bitmap);
+	if (eq->eqn == -1)
+		goto err_out_free_pages;
+
+	eq->doorbell = mlx4_get_eq_uar(dev, eq);
+	if (!eq->doorbell) {
+		err = -ENOMEM;
+		goto err_out_free_eq;
+	}
+
+	err = mlx4_mtt_init(dev, npages, PAGE_SHIFT, &eq->mtt);
+	if (err)
+		goto err_out_free_eq;
+
+	err = mlx4_write_mtt(dev, &eq->mtt, 0, npages, dma_list);
+	if (err)
+		goto err_out_free_mtt;
+
+	memset(eq_context, 0, sizeof *eq_context);
+	eq_context->flags	  = cpu_to_be32(MLX4_EQ_STATUS_OK   |
+						MLX4_EQ_STATE_ARMED);
+	eq_context->log_eq_size	  = ilog2(eq->nent);
+	eq_context->intr	  = intr;
+	eq_context->log_page_size = PAGE_SHIFT - MLX4_ICM_PAGE_SHIFT;
+
+	mtt_addr = mlx4_mtt_addr(dev, &eq->mtt);
+	eq_context->mtt_base_addr_h = mtt_addr >> 32;
+	eq_context->mtt_base_addr_l = cpu_to_be32(mtt_addr & 0xffffffff);
+
+	err = mlx4_SW2HW_EQ(dev, mailbox, eq->eqn);
+	if (err) {
+		mlx4_warn(dev, "SW2HW_EQ failed (%d)\n", err);
+		goto err_out_free_mtt;
+	}
+
+	kfree(dma_list);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+	eq->cons_index = 0;
+
+	return err;
+
+err_out_free_mtt:
+	mlx4_mtt_cleanup(dev, &eq->mtt);
+
+err_out_free_eq:
+	mlx4_bitmap_free(&priv->eq_table.bitmap, eq->eqn);
+
+err_out_free_pages:
+	for (i = 0; i < npages; ++i)
+		if (eq->page_list[i].buf)
+			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+					  eq->page_list[i].buf,
+					  eq->page_list[i].map);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+err_out_free:
+	kfree(eq->page_list);
+	kfree(dma_list);
+
+err_out:
+	return err;
+}
+
+static void mlx4_free_eq(struct mlx4_dev *dev,
+			 struct mlx4_eq *eq)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+	int npages = PAGE_ALIGN(MLX4_EQ_ENTRY_SIZE * eq->nent) / PAGE_SIZE;
+	int i;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return;
+
+	err = mlx4_HW2SW_EQ(dev, mailbox, eq->eqn);
+	if (err)
+		mlx4_warn(dev, "HW2SW_EQ failed (%d)\n", err);
+
+	if (0) {
+		mlx4_dbg(dev, "Dumping EQ context %02x:\n", eq->eqn);
+		for (i = 0; i < sizeof (struct mlx4_eq_context) / 4; ++i) {
+			if (i % 4 == 0)
+				printk("[%02x] ", i * 4);
+			printk(" %08x", be32_to_cpup(mailbox->buf + i * 4));
+			if ((i + 1) % 4 == 0)
+				printk("\n");
+		}
+	}
+
+	mlx4_mtt_cleanup(dev, &eq->mtt);
+	for (i = 0; i < npages; ++i)
+		pci_free_consistent(dev->pdev, PAGE_SIZE,
+				    eq->page_list[i].buf,
+				    eq->page_list[i].map);
+
+	kfree(eq->page_list);
+	mlx4_bitmap_free(&priv->eq_table.bitmap, eq->eqn);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+}
+
+static void mlx4_free_irqs(struct mlx4_dev *dev)
+{
+	struct mlx4_eq_table *eq_table = &mlx4_priv(dev)->eq_table;
+	int i;
+
+	if (eq_table->have_irq)
+		free_irq(dev->pdev->irq, dev);
+	for (i = 0; i < MLX4_NUM_EQ; ++i)
+		if (eq_table->eq[i].have_irq)
+			free_irq(eq_table->eq[i].irq, eq_table->eq + i);
+}
+
+static int __devinit mlx4_map_clr_int(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	priv->clr_base = ioremap(pci_resource_start(dev->pdev, priv->fw.clr_int_bar) +
+				 priv->fw.clr_int_base, MLX4_CLR_INT_SIZE);
+	if (!priv->clr_base) {
+		mlx4_err(dev, "Couldn't map interrupt clear register, aborting.\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mlx4_unmap_clr_int(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	iounmap(priv->clr_base);
+}
+
+int __devinit mlx4_map_eq_icm(struct mlx4_dev *dev, u64 icm_virt)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int ret;
+
+	/*
+	 * We assume that mapping one page is enough for the whole EQ
+	 * context table.  This is fine with all current HCAs, because
+	 * we only use 32 EQs and each EQ uses 64 bytes of context
+	 * memory, or 1 KB total.
+	 */
+	priv->eq_table.icm_virt = icm_virt;
+	priv->eq_table.icm_page = alloc_page(GFP_HIGHUSER);
+	if (!priv->eq_table.icm_page)
+		return -ENOMEM;
+	priv->eq_table.icm_dma  = pci_map_page(dev->pdev, priv->eq_table.icm_page, 0,
+					       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+	if (pci_dma_mapping_error(priv->eq_table.icm_dma)) {
+		__free_page(priv->eq_table.icm_page);
+		return -ENOMEM;
+	}
+
+	ret = mlx4_MAP_ICM_page(dev, priv->eq_table.icm_dma, icm_virt);
+	if (ret) {
+		pci_unmap_page(dev->pdev, priv->eq_table.icm_dma, PAGE_SIZE,
+			       PCI_DMA_BIDIRECTIONAL);
+		__free_page(priv->eq_table.icm_page);
+	}
+
+	return ret;
+}
+
+void mlx4_unmap_eq_icm(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	mlx4_UNMAP_ICM(dev, priv->eq_table.icm_virt, 1);
+	pci_unmap_page(dev->pdev, priv->eq_table.icm_dma, PAGE_SIZE,
+		       PCI_DMA_BIDIRECTIONAL);
+	__free_page(priv->eq_table.icm_page);
+}
+
+int __devinit mlx4_init_eq_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+	int i;
+
+	err = mlx4_bitmap_init(&priv->eq_table.bitmap, dev->caps.num_eqs,
+			       dev->caps.num_eqs - 1, dev->caps.reserved_eqs);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(priv->eq_table.uar_map); ++i)
+		priv->eq_table.uar_map[i] = NULL;
+
+	err = mlx4_map_clr_int(dev);
+	if (err)
+		goto err_out_free;
+
+	priv->eq_table.clr_mask =
+		swab32(1 << (priv->eq_table.inta_pin & 31));
+	priv->eq_table.clr_int  = priv->clr_base +
+		(priv->eq_table.inta_pin < 32 ? 4 : 0);
+
+	err = mlx4_create_eq(dev, dev->caps.num_cqs + MLX4_NUM_SPARE_EQE,
+			     (dev->flags & MLX4_FLAG_MSI_X) ? MLX4_EQ_COMP : 0,
+			     &priv->eq_table.eq[MLX4_EQ_COMP]);
+	if (err)
+		goto err_out_unmap;
+
+	err = mlx4_create_eq(dev, MLX4_NUM_ASYNC_EQE + MLX4_NUM_SPARE_EQE,
+			     (dev->flags & MLX4_FLAG_MSI_X) ? MLX4_EQ_ASYNC : 0,
+			     &priv->eq_table.eq[MLX4_EQ_ASYNC]);
+	if (err)
+		goto err_out_comp;
+
+	if (dev->flags & MLX4_FLAG_MSI_X) {
+		static const char *eq_name[] = {
+			[MLX4_EQ_COMP]  = DRV_NAME " (comp)",
+			[MLX4_EQ_ASYNC] = DRV_NAME " (async)",
+			[MLX4_EQ_CATAS] = DRV_NAME " (catas)"
+		};
+
+		err = mlx4_create_eq(dev, 1, MLX4_EQ_CATAS,
+				     &priv->eq_table.eq[MLX4_EQ_CATAS]);
+		if (err)
+			goto err_out_async;
+
+		for (i = 0; i <= MLX4_EQ_CATAS; ++i) {
+			err = request_irq(priv->eq_table.eq[i].irq,
+					  i == MLX4_EQ_CATAS ?
+					  mlx4_catas_interrupt :
+					  mlx4_msi_x_interrupt,
+					  0, eq_name[i], priv->eq_table.eq + i);
+			if (err)
+				goto err_out_catas;
+
+			priv->eq_table.eq[i].have_irq = 1;
+		}
+	} else {
+		err = request_irq(dev->pdev->irq, mlx4_interrupt,
+				  SA_SHIRQ, DRV_NAME, dev);
+		if (err)
+			goto err_out_catas;
+
+		priv->eq_table.have_irq = 1;
+	}
+
+	err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+			  priv->eq_table.eq[MLX4_EQ_ASYNC].eqn);
+	if (err)
+		mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
+			   priv->eq_table.eq[MLX4_EQ_ASYNC].eqn, err);
+
+	for (i = 0; i < MLX4_EQ_CATAS; ++i)
+		eq_set_ci(&priv->eq_table.eq[i], 1);
+
+	if (dev->flags & MLX4_FLAG_MSI_X) {
+		err = mlx4_MAP_EQ(dev, MLX4_CATAS_EVENT_MASK, 0,
+				  priv->eq_table.eq[MLX4_EQ_CATAS].eqn);
+		if (err)
+			mlx4_warn(dev, "MAP_EQ for catas EQ %d failed (%d)\n",
+				  priv->eq_table.eq[MLX4_EQ_CATAS].eqn, err);
+		eq_set_ci(&priv->eq_table.eq[MLX4_EQ_CATAS], 1);
+	}
+
+	return 0;
+
+err_out_catas:
+	if (dev->flags & MLX4_FLAG_MSI_X)
+		mlx4_free_eq(dev, &priv->eq_table.eq[MLX4_EQ_CATAS]);
+
+err_out_async:
+	mlx4_free_eq(dev, &priv->eq_table.eq[MLX4_EQ_ASYNC]);
+
+err_out_comp:
+	mlx4_free_eq(dev, &priv->eq_table.eq[MLX4_EQ_COMP]);
+
+err_out_unmap:
+	mlx4_unmap_clr_int(dev);
+	mlx4_free_irqs(dev);
+
+err_out_free:
+	mlx4_bitmap_cleanup(&priv->eq_table.bitmap);
+	return err;
+}
+
+void mlx4_cleanup_eq_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int i;
+
+	if (dev->flags & MLX4_FLAG_MSI_X)
+		mlx4_MAP_EQ(dev, MLX4_CATAS_EVENT_MASK, 1,
+			    priv->eq_table.eq[MLX4_EQ_CATAS].eqn);
+
+	mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 1,
+		    priv->eq_table.eq[MLX4_EQ_ASYNC].eqn);
+
+	mlx4_free_irqs(dev);
+
+	for (i = 0; i < MLX4_EQ_CATAS; ++i)
+		mlx4_free_eq(dev, &priv->eq_table.eq[i]);
+	if (dev->flags & MLX4_FLAG_MSI_X)
+		mlx4_free_eq(dev, &priv->eq_table.eq[MLX4_EQ_CATAS]);
+
+	mlx4_unmap_clr_int(dev);
+
+	for (i = 0; i < ARRAY_SIZE(priv->eq_table.uar_map); ++i)
+		if (priv->eq_table.uar_map[i])
+			iounmap(priv->eq_table.uar_map[i]);
+
+	mlx4_bitmap_cleanup(&priv->eq_table.bitmap);
+}
diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
new file mode 100644
index 0000000..6a6c372
--- /dev/null
+++ b/drivers/net/mlx4/icm.c
@@ -0,0 +1,379 @@
+/*
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+#include "icm.h"
+#include "fw.h"
+
+/*
+ * We allocate in as big chunks as we can, up to a maximum of 256 KB
+ * per chunk.
+ */
+enum {
+	MLX4_ICM_ALLOC_SIZE	= 1 << 18,
+	MLX4_TABLE_CHUNK_SIZE	= 1 << 18
+};
+
+void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm)
+{
+	struct mlx4_icm_chunk *chunk, *tmp;
+	int i;
+
+	list_for_each_entry_safe(chunk, tmp, &icm->chunk_list, list) {
+		if (chunk->nsg > 0)
+			pci_unmap_sg(dev->pdev, chunk->mem, chunk->npages,
+				     PCI_DMA_BIDIRECTIONAL);
+
+		for (i = 0; i < chunk->npages; ++i)
+			__free_pages(chunk->mem[i].page,
+				     get_order(chunk->mem[i].length));
+
+		kfree(chunk);
+	}
+
+	kfree(icm);
+}
+
+struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
+				gfp_t gfp_mask)
+{
+	struct mlx4_icm *icm;
+	struct mlx4_icm_chunk *chunk = NULL;
+	int cur_order;
+
+	icm = kmalloc(sizeof *icm, gfp_mask & ~(__GFP_HIGHMEM | __GFP_NOWARN));
+	if (!icm)
+		return icm;
+
+	icm->refcount = 0;
+	INIT_LIST_HEAD(&icm->chunk_list);
+
+	cur_order = get_order(MLX4_ICM_ALLOC_SIZE);
+
+	while (npages > 0) {
+		if (!chunk) {
+			chunk = kmalloc(sizeof *chunk,
+					gfp_mask & ~(__GFP_HIGHMEM | __GFP_NOWARN));
+			if (!chunk)
+				goto fail;
+
+			chunk->npages = 0;
+			chunk->nsg    = 0;
+			list_add_tail(&chunk->list, &icm->chunk_list);
+		}
+
+		while (1 << cur_order > npages)
+			--cur_order;
+
+		chunk->mem[chunk->npages].page = alloc_pages(gfp_mask, cur_order);
+		if (chunk->mem[chunk->npages].page) {
+			chunk->mem[chunk->npages].length = PAGE_SIZE << cur_order;
+			chunk->mem[chunk->npages].offset = 0;
+
+			if (++chunk->npages == MLX4_ICM_CHUNK_LEN) {
+				chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
+							chunk->npages,
+							PCI_DMA_BIDIRECTIONAL);
+
+				if (chunk->nsg <= 0)
+					goto fail;
+
+				chunk = NULL;
+			}
+
+			npages -= 1 << cur_order;
+		} else {
+			--cur_order;
+			if (cur_order < 0)
+				goto fail;
+		}
+	}
+
+	if (chunk) {
+		chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
+					chunk->npages,
+					PCI_DMA_BIDIRECTIONAL);
+
+		if (chunk->nsg <= 0)
+			goto fail;
+	}
+
+	return icm;
+
+fail:
+	mlx4_free_icm(dev, icm);
+	return NULL;
+}
+
+static int mlx4_MAP_ICM(struct mlx4_dev *dev, struct mlx4_icm *icm, u64 virt)
+{
+	return mlx4_map_cmd(dev, MLX4_CMD_MAP_ICM, icm, virt);
+}
+
+int mlx4_UNMAP_ICM(struct mlx4_dev *dev, u64 virt, u32 page_count)
+{
+	return mlx4_cmd(dev, virt, page_count, 0, MLX4_CMD_UNMAP_ICM,
+			MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_MAP_ICM_page(struct mlx4_dev *dev, u64 dma_addr, u64 virt)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	__be64 *inbox;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	inbox = mailbox->buf;
+
+	inbox[0] = cpu_to_be64(virt);
+	inbox[1] = cpu_to_be64(dma_addr);
+
+	err = mlx4_cmd(dev, mailbox->dma, 1, 0, MLX4_CMD_MAP_ICM,
+		       MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+	if (!err)
+		mlx4_dbg(dev, "Mapped page at %llx to %llx for ICM.\n",
+			  (unsigned long long) dma_addr, (unsigned long long) virt);
+
+	return err;
+}
+
+int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm)
+{
+	return mlx4_map_cmd(dev, MLX4_CMD_MAP_ICM_AUX, icm, -1);
+}
+
+int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev)
+{
+	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_UNMAP_ICM_AUX, MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj)
+{
+	int i = (obj & (table->num_obj - 1)) / (MLX4_TABLE_CHUNK_SIZE / table->obj_size);
+	int ret = 0;
+
+	mutex_lock(&table->mutex);
+
+	if (table->icm[i]) {
+		++table->icm[i]->refcount;
+		goto out;
+	}
+
+	table->icm[i] = mlx4_alloc_icm(dev, MLX4_TABLE_CHUNK_SIZE >> PAGE_SHIFT,
+				       (table->lowmem ? GFP_KERNEL : GFP_HIGHUSER) |
+				       __GFP_NOWARN);
+	if (!table->icm[i]) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (mlx4_MAP_ICM(dev, table->icm[i], table->virt +
+			 (u64) i * MLX4_TABLE_CHUNK_SIZE)) {
+		mlx4_free_icm(dev, table->icm[i]);
+		table->icm[i] = NULL;
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	++table->icm[i]->refcount;
+
+out:
+	mutex_unlock(&table->mutex);
+	return ret;
+}
+
+void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj)
+{
+	int i;
+
+	i = (obj & (table->num_obj - 1)) / (MLX4_TABLE_CHUNK_SIZE / table->obj_size);
+
+	mutex_lock(&table->mutex);
+
+	if (--table->icm[i]->refcount == 0) {
+		mlx4_UNMAP_ICM(dev, table->virt + i * MLX4_TABLE_CHUNK_SIZE,
+			       MLX4_TABLE_CHUNK_SIZE / MLX4_ICM_PAGE_SIZE);
+		mlx4_free_icm(dev, table->icm[i]);
+		table->icm[i] = NULL;
+	}
+
+	mutex_unlock(&table->mutex);
+}
+
+void *mlx4_table_find(struct mlx4_icm_table *table, int obj)
+{
+	int idx, offset, i;
+	struct mlx4_icm_chunk *chunk;
+	struct mlx4_icm *icm;
+	struct page *page = NULL;
+
+	if (!table->lowmem)
+		return NULL;
+
+	mutex_lock(&table->mutex);
+
+	idx = obj & (table->num_obj - 1);
+	icm = table->icm[idx / (MLX4_TABLE_CHUNK_SIZE / table->obj_size)];
+	offset = idx % (MLX4_TABLE_CHUNK_SIZE / table->obj_size);
+
+	if (!icm)
+		goto out;
+
+	list_for_each_entry(chunk, &icm->chunk_list, list) {
+		for (i = 0; i < chunk->npages; ++i) {
+			if (chunk->mem[i].length > offset) {
+				page = chunk->mem[i].page;
+				goto out;
+			}
+			offset -= chunk->mem[i].length;
+		}
+	}
+
+out:
+	mutex_unlock(&table->mutex);
+	return page ? lowmem_page_address(page) + offset : NULL;
+}
+
+int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			 int start, int end)
+{
+	int inc = MLX4_TABLE_CHUNK_SIZE / table->obj_size;
+	int i, err;
+
+	for (i = start; i <= end; i += inc) {
+		err = mlx4_table_get(dev, table, i);
+		if (err)
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	while (i > start) {
+		i -= inc;
+		mlx4_table_put(dev, table, i);
+	}
+
+	return err;
+}
+
+void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			  int start, int end)
+{
+	int i;
+
+	for (i = start; i <= end; i += MLX4_TABLE_CHUNK_SIZE / table->obj_size)
+		mlx4_table_put(dev, table, i);
+}
+
+int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			u64 virt, int obj_size,	int nobj, int reserved,
+			int use_lowmem)
+{
+	int obj_per_chunk;
+	int num_icm;
+	unsigned chunk_size;
+	int i;
+
+	obj_per_chunk = MLX4_TABLE_CHUNK_SIZE / obj_size;
+	num_icm = (nobj + obj_per_chunk - 1) / obj_per_chunk;
+
+	table->icm      = kcalloc(num_icm, sizeof *table->icm, GFP_KERNEL);
+	if (!table->icm)
+		return -ENOMEM;
+	table->virt     = virt;
+	table->num_icm  = num_icm;
+	table->num_obj  = nobj;
+	table->obj_size = obj_size;
+	table->lowmem   = use_lowmem;
+	mutex_init(&table->mutex);
+
+	for (i = 0; i * MLX4_TABLE_CHUNK_SIZE < reserved * obj_size; ++i) {
+		chunk_size = MLX4_TABLE_CHUNK_SIZE;
+		if ((i + 1) * MLX4_TABLE_CHUNK_SIZE > nobj * obj_size)
+			chunk_size = PAGE_ALIGN(nobj * obj_size - i * MLX4_TABLE_CHUNK_SIZE);
+
+		table->icm[i] = mlx4_alloc_icm(dev, chunk_size >> PAGE_SHIFT,
+					       (use_lowmem ? GFP_KERNEL : GFP_HIGHUSER) |
+					       __GFP_NOWARN);
+		if (!table->icm[i])
+			goto err;
+		if (mlx4_MAP_ICM(dev, table->icm[i], virt + i * MLX4_TABLE_CHUNK_SIZE)) {
+			mlx4_free_icm(dev, table->icm[i]);
+			table->icm[i] = NULL;
+			goto err;
+		}
+
+		/*
+		 * Add a reference to this ICM chunk so that it never
+		 * gets freed (since it contains reserved firmware objects).
+		 */
+		++table->icm[i]->refcount;
+	}
+
+	return 0;
+
+err:
+	for (i = 0; i < num_icm; ++i)
+		if (table->icm[i]) {
+			mlx4_UNMAP_ICM(dev, virt + i * MLX4_TABLE_CHUNK_SIZE,
+				       MLX4_TABLE_CHUNK_SIZE / MLX4_ICM_PAGE_SIZE);
+			mlx4_free_icm(dev, table->icm[i]);
+		}
+
+	return -ENOMEM;
+}
+
+void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->num_icm; ++i)
+		if (table->icm[i]) {
+			mlx4_UNMAP_ICM(dev, table->virt + i * MLX4_TABLE_CHUNK_SIZE,
+				       MLX4_TABLE_CHUNK_SIZE / MLX4_ICM_PAGE_SIZE);
+			mlx4_free_icm(dev, table->icm[i]);
+		}
+
+	kfree(table->icm);
+}
diff --git a/drivers/net/mlx4/icm.h b/drivers/net/mlx4/icm.h
new file mode 100644
index 0000000..7119edb
--- /dev/null
+++ b/drivers/net/mlx4/icm.h
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_ICM_H
+#define MLX4_ICM_H
+
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/mutex.h>
+
+#define MLX4_ICM_CHUNK_LEN						\
+	((256 - sizeof (struct list_head) - 2 * sizeof (int)) /		\
+	 (sizeof (struct scatterlist)))
+
+enum {
+	MLX4_ICM_PAGE_SHIFT	= 12,
+	MLX4_ICM_PAGE_SIZE	= 1 << MLX4_ICM_PAGE_SHIFT,
+};
+
+struct mlx4_icm_chunk {
+	struct list_head	list;
+	int			npages;
+	int			nsg;
+	struct scatterlist	mem[MLX4_ICM_CHUNK_LEN];
+};
+
+struct mlx4_icm {
+	struct list_head	chunk_list;
+	int			refcount;
+};
+
+struct mlx4_icm_iter {
+	struct mlx4_icm	       *icm;
+	struct mlx4_icm_chunk  *chunk;
+	int			page_idx;
+};
+
+struct mlx4_dev;
+
+struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages, gfp_t gfp_mask);
+void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm);
+
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
+void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
+int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			 int start, int end);
+void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			  int start, int end);
+int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			u64 virt, int obj_size,	int nobj, int reserved,
+			int use_lowmem);
+void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table);
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
+void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, int obj);
+void *mlx4_table_find(struct mlx4_icm_table *table, int obj);
+int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			 int start, int end);
+void mlx4_table_put_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
+			  int start, int end);
+
+static inline void mlx4_icm_first(struct mlx4_icm *icm,
+				  struct mlx4_icm_iter *iter)
+{
+	iter->icm      = icm;
+	iter->chunk    = list_empty(&icm->chunk_list) ?
+		NULL : list_entry(icm->chunk_list.next,
+				  struct mlx4_icm_chunk, list);
+	iter->page_idx = 0;
+}
+
+static inline int mlx4_icm_last(struct mlx4_icm_iter *iter)
+{
+	return !iter->chunk;
+}
+
+static inline void mlx4_icm_next(struct mlx4_icm_iter *iter)
+{
+	if (++iter->page_idx >= iter->chunk->nsg) {
+		if (iter->chunk->list.next == &iter->icm->chunk_list) {
+			iter->chunk = NULL;
+			return;
+		}
+
+		iter->chunk = list_entry(iter->chunk->list.next,
+					 struct mlx4_icm_chunk, list);
+		iter->page_idx = 0;
+	}
+}
+
+static inline dma_addr_t mlx4_icm_addr(struct mlx4_icm_iter *iter)
+{
+	return sg_dma_address(&iter->chunk->mem[iter->page_idx]);
+}
+
+static inline unsigned long mlx4_icm_size(struct mlx4_icm_iter *iter)
+{
+	return sg_dma_len(&iter->chunk->mem[iter->page_idx]);
+}
+
+int mlx4_UNMAP_ICM(struct mlx4_dev *dev, u64 virt, u32 page_count);
+int mlx4_MAP_ICM_page(struct mlx4_dev *dev, u64 dma_addr, u64 virt);
+int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
+int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev);
+
+#endif /* MLX4_ICM_H */
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
new file mode 100644
index 0000000..a44dfd4
--- /dev/null
+++ b/drivers/net/mlx4/mcg.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+
+struct mlx4_mgm {
+	__be32			next_gid_index;
+	__be32			members_count;
+	u32			reserved[2];
+	u8			gid[16];
+	__be32			qp[MLX4_QP_PER_MGM];
+};
+
+static const u8 zero_gid[16];	/* automatically initialized to 0 */
+
+static int mlx4_READ_MCG(struct mlx4_dev *dev, int index,
+			 struct mlx4_cmd_mailbox *mailbox)
+{
+	return mlx4_cmd_box(dev, 0, mailbox->dma, index, 0, MLX4_CMD_READ_MCG,
+			    MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_WRITE_MCG(struct mlx4_dev *dev, int index,
+			  struct mlx4_cmd_mailbox *mailbox)
+{
+	return mlx4_cmd(dev, mailbox->dma, index, 0, MLX4_CMD_WRITE_MCG,
+			MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  u16 *hash)
+{
+	u64 imm;
+	int err;
+
+	err = mlx4_cmd_imm(dev, mailbox->dma, &imm, 0, 0, MLX4_CMD_MGID_HASH,
+			   MLX4_CMD_TIME_CLASS_A);
+
+	if (!err)
+		*hash = imm;
+
+	return err;
+}
+
+/*
+ * Caller must hold MCG table semaphore.  gid and mgm parameters must
+ * be properly aligned for command interface.
+ *
+ *  Returns 0 unless a firmware command error occurs.
+ *
+ * If GID is found in MGM or MGM is empty, *index = *hash, *prev = -1
+ * and *mgm holds MGM entry.
+ *
+ * if GID is found in AMGM, *index = index in AMGM, *prev = index of
+ * previous entry in hash chain and *mgm holds AMGM entry.
+ *
+ * If no AMGM exists for given gid, *index = -1, *prev = index of last
+ * entry in hash chain and *mgm holds end of hash chain.
+ */
+static int find_mgm(struct mlx4_dev *dev,
+		    u8 *gid, struct mlx4_cmd_mailbox *mgm_mailbox,
+		    u16 *hash, int *prev, int *index)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm = mgm_mailbox->buf;
+	u8 *mgid;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return -ENOMEM;
+	mgid = mailbox->buf;
+
+	memcpy(mgid, gid, 16);
+
+	err = mlx4_MGID_HASH(dev, mailbox, hash);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	if (err)
+		return err;
+
+	if (0)
+		mlx4_dbg(dev, "Hash for %04x:%04x:%04x:%04x:"
+			  "%04x:%04x:%04x:%04x is %04x\n",
+			  be16_to_cpu(((__be16 *) gid)[0]),
+			  be16_to_cpu(((__be16 *) gid)[1]),
+			  be16_to_cpu(((__be16 *) gid)[2]),
+			  be16_to_cpu(((__be16 *) gid)[3]),
+			  be16_to_cpu(((__be16 *) gid)[4]),
+			  be16_to_cpu(((__be16 *) gid)[5]),
+			  be16_to_cpu(((__be16 *) gid)[6]),
+			  be16_to_cpu(((__be16 *) gid)[7]),
+			  *hash);
+
+	*index = *hash;
+	*prev  = -1;
+
+	do {
+		err = mlx4_READ_MCG(dev, *index, mgm_mailbox);
+		if (err)
+			return err;
+
+		if (!memcmp(mgm->gid, zero_gid, 16)) {
+			if (*index != *hash) {
+				mlx4_err(dev, "Found zero MGID in AMGM.\n");
+				err = -EINVAL;
+			}
+			return err;
+		}
+
+		if (!memcmp(mgm->gid, gid, 16))
+			return err;
+
+		*prev = *index;
+		*index = be32_to_cpu(mgm->next_gid_index) >> 6;
+	} while (*index);
+
+	*index = -1;
+	return err;
+}
+
+int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	u32 members_count;
+	u16 hash;
+	int index, prev;
+	int link = 0;
+	int i;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	mgm = mailbox->buf;
+
+	mutex_lock(&priv->mcg_table.mutex);
+
+	err = find_mgm(dev, gid, mailbox, &hash, &prev, &index);
+	if (err)
+		goto out;
+
+	if (index != -1) {
+		if (!memcmp(mgm->gid, zero_gid, 16))
+			memcpy(mgm->gid, gid, 16);
+	} else {
+		link = 1;
+
+		index = mlx4_bitmap_alloc(&priv->mcg_table.bitmap);
+		if (index == -1) {
+			mlx4_err(dev, "No AMGM entries left\n");
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = mlx4_READ_MCG(dev, index, mailbox);
+		if (err)
+			goto out;
+
+		memset(mgm, 0, sizeof *mgm);
+		memcpy(mgm->gid, gid, 16);
+	}
+
+	members_count = be32_to_cpu(mgm->members_count);
+	if (members_count == MLX4_QP_PER_MGM) {
+		mlx4_err(dev, "MGM at index %x is full.\n", index);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < members_count; ++i)
+		if (mgm->qp[i] == cpu_to_be32(qp->qpn)) {
+			mlx4_dbg(dev, "QP %06x already a member of MGM\n", qp->qpn);
+			err = 0;
+			goto out;
+		}
+
+	mgm->qp[members_count++] = cpu_to_be32(qp->qpn);
+	mgm->members_count       = cpu_to_be32(members_count);
+
+	err = mlx4_WRITE_MCG(dev, index, mailbox);
+	if (err)
+		goto out;
+
+	if (!link)
+		goto out;
+
+	err = mlx4_READ_MCG(dev, prev, mailbox);
+	if (err)
+		goto out;
+
+	mgm->next_gid_index = cpu_to_be32(index << 6);
+
+	err = mlx4_WRITE_MCG(dev, prev, mailbox);
+	if (err)
+		goto out;
+
+out:
+	if (err && link && index != -1) {
+		BUG_ON(index < dev->caps.num_mgms);
+		mlx4_bitmap_free(&priv->mcg_table.bitmap, index);
+	}
+	mutex_unlock(&priv->mcg_table.mutex);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_multicast_attach);
+
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	u32 members_count;
+	u16 hash;
+	int prev, index;
+	int i, loc;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	mgm = mailbox->buf;
+
+	mutex_lock(&priv->mcg_table.mutex);
+
+	err = find_mgm(dev, gid, mailbox, &hash, &prev, &index);
+	if (err)
+		goto out;
+
+	if (index == -1) {
+		mlx4_err(dev, "MGID %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x "
+			  "not found\n",
+			  be16_to_cpu(((__be16 *) gid)[0]),
+			  be16_to_cpu(((__be16 *) gid)[1]),
+			  be16_to_cpu(((__be16 *) gid)[2]),
+			  be16_to_cpu(((__be16 *) gid)[3]),
+			  be16_to_cpu(((__be16 *) gid)[4]),
+			  be16_to_cpu(((__be16 *) gid)[5]),
+			  be16_to_cpu(((__be16 *) gid)[6]),
+			  be16_to_cpu(((__be16 *) gid)[7]));
+		err = -EINVAL;
+		goto out;
+	}
+
+	members_count = be32_to_cpu(mgm->members_count);
+	for (loc = -1, i = 0; i < members_count; ++i)
+		if (mgm->qp[i] == cpu_to_be32(qp->qpn))
+			loc = i;
+
+	if (loc == -1) {
+		mlx4_err(dev, "QP %06x not found in MGM\n", qp->qpn);
+		err = -EINVAL;
+		goto out;
+	}
+
+
+	mgm->members_count = cpu_to_be32(--members_count);
+	mgm->qp[loc]       = mgm->qp[i - 1];
+	mgm->qp[i - 1]     = 0;
+
+	err = mlx4_WRITE_MCG(dev, index, mailbox);
+	if (err)
+		goto out;
+
+	if (i != 1)
+		goto out;
+
+	if (prev == -1) {
+		/* Remove entry from MGM */
+		int amgm_index_to_free = be32_to_cpu(mgm->next_gid_index) >> 6;
+		if (amgm_index_to_free) {
+			err = mlx4_READ_MCG(dev, amgm_index_to_free, mailbox);
+			if (err)
+				goto out;
+		} else
+			memset(mgm->gid, 0, 16);
+
+		err = mlx4_WRITE_MCG(dev, index, mailbox);
+		if (err)
+			goto out;
+
+		if (amgm_index_to_free) {
+			BUG_ON(amgm_index_to_free < dev->caps.num_mgms);
+			mlx4_bitmap_free(&priv->mcg_table.bitmap, amgm_index_to_free);
+		}
+	} else {
+		/* Remove entry from AMGM */
+		int curr_next_index = be32_to_cpu(mgm->next_gid_index) >> 6;
+		err = mlx4_READ_MCG(dev, prev, mailbox);
+		if (err)
+			goto out;
+
+		mgm->next_gid_index = cpu_to_be32(curr_next_index << 6);
+
+		err = mlx4_WRITE_MCG(dev, prev, mailbox);
+		if (err)
+			goto out;
+
+		BUG_ON(index < dev->caps.num_mgms);
+		mlx4_bitmap_free(&priv->mcg_table.bitmap, index);
+	}
+
+out:
+	mutex_unlock(&priv->mcg_table.mutex);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_multicast_detach);
+
+int __devinit mlx4_init_mcg_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int table_size;
+	int err;
+
+	table_size = dev->caps.num_mgms + dev->caps.num_amgms;
+	err = mlx4_bitmap_init(&priv->mcg_table.bitmap,
+			       table_size, table_size - 1,
+			       dev->caps.num_mgms);
+	if (err)
+		return err;
+
+	mutex_init(&priv->mcg_table.mutex);
+
+	return 0;
+}
+
+void mlx4_cleanup_mcg_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->mcg_table.bitmap);
+}
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
new file mode 100644
index 0000000..da6d49a
--- /dev/null
+++ b/drivers/net/mlx4/mr.c
@@ -0,0 +1,482 @@
+/*
+ * Copyright (c) 2004 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+#include "icm.h"
+
+/*
+ * Must be packed because mtt_seg is 64 bits but only aligned to 32 bits.
+ */
+struct mlx4_mpt_entry {
+	__be32 flags;
+	__be32 qpn;
+	__be32 key;
+	__be32 pd;
+	__be64 start;
+	__be64 length;
+	__be32 lkey;
+	__be32 win_cnt;
+	u8	reserved1[3];
+	u8	mtt_rep;
+	__be64 mtt_seg;
+	__be32 mtt_sz;
+	__be32 entity_size;
+	__be32 first_byte_offset;
+} __attribute__((packed));
+
+#define MLX4_MPT_FLAG_SW_OWNS	    (0xfUL << 28)
+#define MLX4_MPT_FLAG_MIO	    (1 << 17)
+#define MLX4_MPT_FLAG_BIND_ENABLE   (1 << 15)
+#define MLX4_MPT_FLAG_PHYSICAL	    (1 <<  9)
+#define MLX4_MPT_FLAG_REGION	    (1 <<  8)
+
+#define MLX4_MTT_FLAG_PRESENT		1
+
+static u32 mlx4_buddy_alloc(struct mlx4_buddy *buddy, int order)
+{
+	int o;
+	int m;
+	u32 seg;
+
+	spin_lock(&buddy->lock);
+
+	for (o = order; o <= buddy->max_order; ++o) {
+		m = 1 << (buddy->max_order - o);
+		seg = find_first_bit(buddy->bits[o], m);
+		if (seg < m)
+			goto found;
+	}
+
+	spin_unlock(&buddy->lock);
+	return -1;
+
+ found:
+	clear_bit(seg, buddy->bits[o]);
+
+	while (o > order) {
+		--o;
+		seg <<= 1;
+		set_bit(seg ^ 1, buddy->bits[o]);
+	}
+
+	spin_unlock(&buddy->lock);
+
+	seg <<= order;
+
+	return seg;
+}
+
+static void mlx4_buddy_free(struct mlx4_buddy *buddy, u32 seg, int order)
+{
+	seg >>= order;
+
+	spin_lock(&buddy->lock);
+
+	while (test_bit(seg ^ 1, buddy->bits[order])) {
+		clear_bit(seg ^ 1, buddy->bits[order]);
+		seg >>= 1;
+		++order;
+	}
+
+	set_bit(seg, buddy->bits[order]);
+
+	spin_unlock(&buddy->lock);
+}
+
+static int __devinit mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
+{
+	int i, s;
+
+	buddy->max_order = max_order;
+	spin_lock_init(&buddy->lock);
+
+	buddy->bits = kzalloc((buddy->max_order + 1) * sizeof (long *),
+			      GFP_KERNEL);
+	if (!buddy->bits)
+		goto err_out;
+
+	for (i = 0; i <= buddy->max_order; ++i) {
+		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
+		buddy->bits[i] = kmalloc(s * sizeof (long), GFP_KERNEL);
+		if (!buddy->bits[i])
+			goto err_out_free;
+		bitmap_zero(buddy->bits[i], 1 << (buddy->max_order - i));
+	}
+
+	set_bit(0, buddy->bits[buddy->max_order]);
+
+	return 0;
+
+err_out_free:
+	for (i = 0; i <= buddy->max_order; ++i)
+		kfree(buddy->bits[i]);
+
+	kfree(buddy->bits);
+
+err_out:
+	return -ENOMEM;
+}
+
+static void mlx4_buddy_cleanup(struct mlx4_buddy *buddy)
+{
+	int i;
+
+	for (i = 0; i <= buddy->max_order; ++i)
+		kfree(buddy->bits[i]);
+
+	kfree(buddy->bits);
+}
+
+static u32 mlx4_alloc_mtt_range(struct mlx4_dev *dev, int order)
+{
+	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
+	u32 seg;
+
+	seg = mlx4_buddy_alloc(&mr_table->mtt_buddy, order);
+	if (seg == -1)
+		return -1;
+
+	if (mlx4_table_get_range(dev, &mr_table->mtt_table, seg,
+				 seg + (1 << order) - 1)) {
+		mlx4_buddy_free(&mr_table->mtt_buddy, seg, order);
+		return -1;
+	}
+
+	return seg;
+}
+
+int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
+		  struct mlx4_mtt *mtt)
+{
+	int i;
+
+	if (!npages) {
+		mtt->order      = -1;
+		mtt->page_shift = MLX4_ICM_PAGE_SHIFT;
+		return 0;
+	} else
+		mtt->page_shift = page_shift;
+
+	for (mtt->order = 0, i = MLX4_MTT_ENTRY_PER_SEG; i < npages; i <<= 1)
+		++mtt->order;
+
+	mtt->first_seg = mlx4_alloc_mtt_range(dev, mtt->order);
+	if (mtt->first_seg == -1)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_mtt_init);
+
+void mlx4_mtt_cleanup(struct mlx4_dev *dev, struct mlx4_mtt *mtt)
+{
+	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
+
+	if (mtt->order < 0)
+		return;
+
+	mlx4_buddy_free(&mr_table->mtt_buddy, mtt->first_seg, mtt->order);
+	mlx4_table_put_range(dev, &mr_table->mtt_table, mtt->first_seg,
+			     mtt->first_seg + (1 << mtt->order) - 1);
+}
+EXPORT_SYMBOL_GPL(mlx4_mtt_cleanup);
+
+u64 mlx4_mtt_addr(struct mlx4_dev *dev, struct mlx4_mtt *mtt)
+{
+	return (u64) mtt->first_seg * dev->caps.mtt_entry_sz;
+}
+EXPORT_SYMBOL_GPL(mlx4_mtt_addr);
+
+static u32 hw_index_to_key(u32 ind)
+{
+	return (ind >> 24) | (ind << 8);
+}
+
+static u32 key_to_hw_index(u32 key)
+{
+	return (key << 24) | (key >> 8);
+}
+
+static int mlx4_SW2HW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  int mpt_index)
+{
+	return mlx4_cmd(dev, mailbox->dma, mpt_index, 0, MLX4_CMD_SW2HW_MPT,
+			MLX4_CMD_TIME_CLASS_B);
+}
+
+static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  int mpt_index)
+{
+	return mlx4_cmd_box(dev, 0, mailbox ? mailbox->dma : 0, mpt_index,
+			    !mailbox, MLX4_CMD_HW2SW_MPT, MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
+		  int npages, int page_shift, struct mlx4_mr *mr)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	u32 index;
+	int err;
+
+	index = mlx4_bitmap_alloc(&priv->mr_table.mpt_bitmap);
+	if (index == -1) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	mr->iova       = iova;
+	mr->size       = size;
+	mr->pd	       = pd;
+	mr->access     = access;
+	mr->enabled    = 0;
+	mr->key	       = hw_index_to_key(index);
+
+	err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
+	if (err)
+		goto err_index;
+
+	return 0;
+
+err_index:
+	mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, index);
+
+err:
+	kfree(mr);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_alloc);
+
+void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+
+	/*FIXME don't do this yet -- FW (2.0.138) seems to barf if we do */
+	return;
+
+	if (mr->enabled) {
+		err = mlx4_HW2SW_MPT(dev, NULL,
+				     key_to_hw_index(mr->key) &
+				     (dev->caps.num_mpts - 1));
+		if (err)
+			mlx4_warn(dev, "HW2SW_MPT failed (%d)\n", err);
+	}
+
+	mlx4_mtt_cleanup(dev, &mr->mtt);
+	mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, key_to_hw_index(mr->key));
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_free);
+
+int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
+{
+	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mpt_entry *mpt_entry;
+	int err;
+
+	err = mlx4_table_get(dev, &mr_table->dmpt_table, key_to_hw_index(mr->key));
+	if (err)
+		return err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = PTR_ERR(mailbox);
+		goto err_table;
+	}
+	mpt_entry = mailbox->buf;
+
+	memset(mpt_entry, 0, sizeof *mpt_entry);
+
+	mpt_entry->flags = cpu_to_be32(MLX4_MPT_FLAG_SW_OWNS	 |
+				       MLX4_MPT_FLAG_MIO	 |
+				       MLX4_MPT_FLAG_REGION	 |
+				       mr->access);
+	if (mr->mtt.order < 0)
+		mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
+
+	mpt_entry->key	       = cpu_to_be32(key_to_hw_index(mr->key));
+	mpt_entry->pd	       = cpu_to_be32(mr->pd);
+	mpt_entry->start       = cpu_to_be64(mr->iova);
+	mpt_entry->length      = cpu_to_be64(mr->size);
+	mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
+	mpt_entry->mtt_seg     = cpu_to_be64(mlx4_mtt_addr(dev, &mr->mtt));
+
+	err = mlx4_SW2HW_MPT(dev, mailbox,
+			     key_to_hw_index(mr->key) & (dev->caps.num_mpts - 1));
+	if (err) {
+		mlx4_warn(dev, "SW2HW_MPT failed (%d)\n", err);
+		goto err_cmd;
+	}
+
+	mr->enabled = 1;
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+	return 0;
+
+err_cmd:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+err_table:
+	mlx4_table_put(dev, &mr_table->dmpt_table, key_to_hw_index(mr->key));
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_enable);
+
+static int mlx4_WRITE_MTT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  int num_mtt)
+{
+	return mlx4_cmd(dev, mailbox->dma, num_mtt, 0, MLX4_CMD_WRITE_MTT,
+			MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		   int start_index, int npages, u64 *page_list)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	__be64 *mtt_entry;
+	int i;
+	int err = 0;
+
+	if (mtt->order < 0)
+		return -EINVAL;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	mtt_entry = mailbox->buf;
+
+	while (npages > 0) {
+		mtt_entry[0] = cpu_to_be64(mlx4_mtt_addr(dev, mtt) + start_index * 8);
+		mtt_entry[1] = 0;
+
+		for (i = 0; i < npages && i < MLX4_MAILBOX_SIZE / 8 - 2; ++i)
+			mtt_entry[i + 2] = cpu_to_be64(page_list[i] |
+						       MLX4_MTT_FLAG_PRESENT);
+
+		/*
+		 * If we have an odd number of entries to write, add
+		 * one more dummy entry for firmware efficiency.
+		 */
+		if (i & 1)
+			mtt_entry[i + 2] = 0;
+
+		err = mlx4_WRITE_MTT(dev, mailbox, (i + 1) & ~1);
+		if (err)
+			goto out;
+
+		npages      -= i;
+		start_index += i;
+		page_list   += i;
+	}
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_write_mtt);
+
+int mlx4_buf_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		       struct mlx4_buf *buf)
+{
+	u64 *page_list;
+	int err;
+	int i;
+
+	page_list = kmalloc(buf->npages * sizeof *page_list, GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	for (i = 0; i < buf->npages; ++i)
+		if (buf->nbufs == 1)
+			page_list[i] = buf->u.direct.map + (i << buf->page_shift);
+		else
+			page_list[i] = buf->u.page_list[i].map;
+
+	err = mlx4_write_mtt(dev, mtt, 0, buf->npages, page_list);
+
+	kfree(page_list);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_buf_write_mtt);
+
+int __devinit mlx4_init_mr_table(struct mlx4_dev *dev)
+{
+	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
+	int err;
+
+	err = mlx4_bitmap_init(&mr_table->mpt_bitmap, dev->caps.num_mpts,
+			       ~0, dev->caps.reserved_mrws);
+	if (err)
+		return err;
+
+	err = mlx4_buddy_init(&mr_table->mtt_buddy,
+			      ilog2(dev->caps.num_mtt_segs));
+	if (err)
+		goto err_buddy;
+
+	if (dev->caps.reserved_mtts) {
+		if (mlx4_alloc_mtt_range(dev, ilog2(dev->caps.reserved_mtts)) == -1) {
+			mlx4_warn(dev, "MTT table of order %d is too small.\n",
+				  mr_table->mtt_buddy.max_order);
+			err = -ENOMEM;
+			goto err_reserve_mtts;
+		}
+	}
+
+	return 0;
+
+err_reserve_mtts:
+	mlx4_buddy_cleanup(&mr_table->mtt_buddy);
+
+err_buddy:
+	mlx4_bitmap_cleanup(&mr_table->mpt_bitmap);
+
+	return err;
+}
+
+void mlx4_cleanup_mr_table(struct mlx4_dev *dev)
+{
+	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
+
+	mlx4_buddy_cleanup(&mr_table->mtt_buddy);
+	mlx4_bitmap_cleanup(&mr_table->mpt_bitmap);
+}
diff --git a/drivers/net/mlx4/pd.c b/drivers/net/mlx4/pd.c
new file mode 100644
index 0000000..d2c369d
--- /dev/null
+++ b/drivers/net/mlx4/pd.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include <asm/page.h>
+
+#include "mlx4.h"
+#include "icm.h"
+
+int mlx4_pd_alloc(struct mlx4_dev *dev, u32 *pdn)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	*pdn = mlx4_bitmap_alloc(&priv->pd_bitmap);
+	if (*pdn == -1)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_pd_alloc);
+
+void mlx4_pd_free(struct mlx4_dev *dev, u32 pdn)
+{
+	mlx4_bitmap_free(&mlx4_priv(dev)->pd_bitmap, pdn);
+}
+EXPORT_SYMBOL_GPL(mlx4_pd_free);
+
+int __devinit mlx4_init_pd_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	return mlx4_bitmap_init(&priv->pd_bitmap, dev->caps.num_pds,
+				(1 << 24) - 1, dev->caps.reserved_pds);
+}
+
+void mlx4_cleanup_pd_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->pd_bitmap);
+}
+
+
+int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar)
+{
+	uar->index = mlx4_bitmap_alloc(&mlx4_priv(dev)->uar_table.bitmap);
+	if (uar->index == -1)
+		return -ENOMEM;
+
+	uar->pfn = (pci_resource_start(dev->pdev, 2) >> PAGE_SHIFT) + uar->index;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_uar_alloc);
+
+void mlx4_uar_free(struct mlx4_dev *dev, struct mlx4_uar *uar)
+{
+	mlx4_bitmap_free(&mlx4_priv(dev)->uar_table.bitmap, uar->index);
+}
+EXPORT_SYMBOL_GPL(mlx4_uar_free);
+
+int mlx4_init_uar_table(struct mlx4_dev *dev)
+{
+	return mlx4_bitmap_init(&mlx4_priv(dev)->uar_table.bitmap,
+				dev->caps.num_uars, dev->caps.num_uars - 1,
+				max(128, dev->caps.reserved_uars));
+}
+
+void mlx4_cleanup_uar_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->uar_table.bitmap);
+}
diff --git a/drivers/net/mlx4/qp.c b/drivers/net/mlx4/qp.c
new file mode 100644
index 0000000..824e0f6
--- /dev/null
+++ b/drivers/net/mlx4/qp.c
@@ -0,0 +1,270 @@
+/*
+ * Copyright (c) 2004 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+
+#include <linux/mlx4/cmd.h>
+#include <linux/mlx4/qp.h>
+
+#include "mlx4.h"
+#include "icm.h"
+
+void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
+{
+	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
+	struct mlx4_qp *qp;
+
+	spin_lock(&qp_table->lock);
+
+	qp = __mlx4_qp_lookup(dev, qpn);
+	if (qp)
+		atomic_inc(&qp->refcount);
+
+	spin_unlock(&qp_table->lock);
+
+	if (!qp) {
+		mlx4_warn(dev, "Async event for bogus QP %08x\n", qpn);
+		return;
+	}
+
+	qp->event(qp, event_type);
+
+	if (atomic_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+}
+
+int mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		   enum mlx4_qp_state cur_state, enum mlx4_qp_state new_state,
+		   struct mlx4_qp_context *context, enum mlx4_qp_optpar optpar,
+		   int sqd_event, struct mlx4_qp *qp)
+{
+	static const u16 op[MLX4_QP_NUM_STATE][MLX4_QP_NUM_STATE] = {
+		[MLX4_QP_STATE_RST] = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_INIT]	= MLX4_CMD_RST2INIT_QP,
+		},
+		[MLX4_QP_STATE_INIT]  = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_INIT]	= MLX4_CMD_INIT2INIT_QP,
+			[MLX4_QP_STATE_RTR]	= MLX4_CMD_INIT2RTR_QP,
+		},
+		[MLX4_QP_STATE_RTR]   = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_RTS]	= MLX4_CMD_RTR2RTS_QP,
+		},
+		[MLX4_QP_STATE_RTS]   = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_RTS]	= MLX4_CMD_RTS2RTS_QP,
+			[MLX4_QP_STATE_SQD]	= MLX4_CMD_RTS2SQD_QP,
+		},
+		[MLX4_QP_STATE_SQD] = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_RTS]	= MLX4_CMD_SQD2RTS_QP,
+			[MLX4_QP_STATE_SQD]	= MLX4_CMD_SQD2SQD_QP,
+		},
+		[MLX4_QP_STATE_SQER] = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+			[MLX4_QP_STATE_RTS]	= MLX4_CMD_SQERR2RTS_QP,
+		},
+		[MLX4_QP_STATE_ERR] = {
+			[MLX4_QP_STATE_RST]	= MLX4_CMD_2RST_QP,
+			[MLX4_QP_STATE_ERR]	= MLX4_CMD_2ERR_QP,
+		}
+	};
+
+	struct mlx4_cmd_mailbox *mailbox;
+	int ret = 0;
+
+	if (cur_state < 0 || cur_state >= MLX4_QP_NUM_STATE ||
+	    new_state < 0 || cur_state >= MLX4_QP_NUM_STATE ||
+	    !op[cur_state][new_state])
+		return -EINVAL;
+
+	if (op[cur_state][new_state] == MLX4_CMD_2RST_QP)
+		return mlx4_cmd(dev, 0, qp->qpn, 2,
+				MLX4_CMD_2RST_QP, MLX4_CMD_TIME_CLASS_A);
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	if (cur_state == MLX4_QP_STATE_RST && new_state == MLX4_QP_STATE_INIT) {
+		u64 mtt_addr = mlx4_mtt_addr(dev, mtt);
+		context->mtt_base_addr_h = mtt_addr >> 32;
+		context->mtt_base_addr_l = cpu_to_be32(mtt_addr & 0xffffffff);
+		context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
+	}
+
+	*(__be32 *) mailbox->buf = cpu_to_be32(optpar);
+	memcpy(mailbox->buf + 8, context, sizeof *context);
+
+	ret = mlx4_cmd(dev, mailbox->dma, qp->qpn | (!!sqd_event << 31),
+		       new_state == MLX4_QP_STATE_RST ? 2 : 0,
+		       op[cur_state][new_state], MLX4_CMD_TIME_CLASS_C);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mlx4_qp_modify);
+
+int mlx4_qp_alloc(struct mlx4_dev *dev, int sqpn, struct mlx4_qp *qp)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_qp_table *qp_table = &priv->qp_table;
+	int err;
+
+	if (sqpn)
+		qp->qpn = sqpn;
+	else {
+		qp->qpn = mlx4_bitmap_alloc(&qp_table->bitmap);
+		if (qp->qpn == -1)
+			return -ENOMEM;
+	}
+
+	err = mlx4_table_get(dev, &qp_table->qp_table, qp->qpn);
+	if (err)
+		goto err_out;
+
+	err = mlx4_table_get(dev, &qp_table->auxc_table, qp->qpn);
+	if (err)
+		goto err_put_qp;
+
+	err = mlx4_table_get(dev, &qp_table->altc_table, qp->qpn);
+	if (err)
+		goto err_put_auxc;
+
+	err = mlx4_table_get(dev, &qp_table->rdmarc_table, qp->qpn);
+	if (err)
+		goto err_put_altc;
+
+	err = mlx4_table_get(dev, &qp_table->cmpt_table, qp->qpn);
+	if (err)
+		goto err_put_rdmarc;
+
+	spin_lock_irq(&qp_table->lock);
+	err = radix_tree_insert(&dev->qp_table_tree, qp->qpn & (dev->caps.num_qps - 1), qp);
+	spin_unlock_irq(&qp_table->lock);
+	if (err)
+		goto err_put_cmpt;
+
+	return 0;
+
+err_put_cmpt:
+	mlx4_table_put(dev, &qp_table->cmpt_table, qp->qpn);
+
+err_put_rdmarc:
+	mlx4_table_put(dev, &qp_table->rdmarc_table, qp->qpn);
+
+err_put_altc:
+	mlx4_table_put(dev, &qp_table->altc_table, qp->qpn);
+
+err_put_auxc:
+	mlx4_table_put(dev, &qp_table->auxc_table, qp->qpn);
+
+err_put_qp:
+	mlx4_table_put(dev, &qp_table->qp_table, qp->qpn);
+
+err_out:
+	if (!sqpn)
+		mlx4_bitmap_free(&qp_table->bitmap, qp->qpn);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_qp_alloc);
+
+void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp)
+{
+	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp_table->lock, flags);
+	radix_tree_delete(&dev->qp_table_tree, qp->qpn & (dev->caps.num_qps - 1));
+	spin_unlock_irqrestore(&qp_table->lock, flags);
+}
+EXPORT_SYMBOL_GPL(mlx4_qp_remove);
+
+void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp)
+{
+	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
+
+	mlx4_table_put(dev, &qp_table->cmpt_table, qp->qpn);
+	mlx4_table_put(dev, &qp_table->rdmarc_table, qp->qpn);
+	mlx4_table_put(dev, &qp_table->altc_table, qp->qpn);
+	mlx4_table_put(dev, &qp_table->auxc_table, qp->qpn);
+	mlx4_table_put(dev, &qp_table->qp_table, qp->qpn);
+
+	mlx4_bitmap_free(&qp_table->bitmap, qp->qpn);
+}
+EXPORT_SYMBOL_GPL(mlx4_qp_free);
+
+static int mlx4_CONF_SPECIAL_QP(struct mlx4_dev *dev, u32 base_qpn)
+{
+	return mlx4_cmd(dev, 0, base_qpn, 0, MLX4_CMD_CONF_SPECIAL_QP,
+			MLX4_CMD_TIME_CLASS_B);
+}
+
+int __devinit mlx4_init_qp_table(struct mlx4_dev *dev)
+{
+	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
+	int err;
+
+	spin_lock_init(&qp_table->lock);
+	INIT_RADIX_TREE(&dev->qp_table_tree, GFP_ATOMIC);
+
+	/*
+	 * We reserve 2 extra QPs per port for the special QPs.  The
+	 * block of special QPs must be aligned to a multiple of 8, so
+	 * round up.
+	 */
+	dev->caps.sqp_start = ALIGN(dev->caps.reserved_qps, 8);
+	err = mlx4_bitmap_init(&qp_table->bitmap, dev->caps.num_qps,
+			       (1 << 24) - 1, dev->caps.sqp_start + 8);
+	if (err)
+		return err;
+
+	return mlx4_CONF_SPECIAL_QP(dev, dev->caps.sqp_start);
+}
+
+void mlx4_cleanup_qp_table(struct mlx4_dev *dev)
+{
+	mlx4_CONF_SPECIAL_QP(dev, 0);
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->qp_table.bitmap);
+}
diff --git a/drivers/net/mlx4/srq.c b/drivers/net/mlx4/srq.c
new file mode 100644
index 0000000..09b43ed
--- /dev/null
+++ b/drivers/net/mlx4/srq.c
@@ -0,0 +1,227 @@
+/*
+ * Copyright (c) 2006 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/init.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4.h"
+#include "icm.h"
+
+struct mlx4_srq_context {
+	__be32			state_logsize_srqn;
+	u8			logstride;
+	u8			reserved1[3];
+	u8			pg_offset;
+	u8			reserved2[3];
+	u32			reserved3;
+	u8			log_page_size;
+	u8			reserved4[2];
+	u8			mtt_base_addr_h;
+	__be32			mtt_base_addr_l;
+	__be32			pd;
+	__be16			limit_watermark;
+	__be16			wqe_cnt;
+	u16			reserved5;
+	__be16			wqe_counter;
+	u32			reserved6;
+	__be64			db_rec_addr;
+};
+
+void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
+	struct mlx4_srq *srq;
+
+	spin_lock(&srq_table->lock);
+
+	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
+	if (srq)
+		atomic_inc(&srq->refcount);
+
+	spin_unlock(&srq_table->lock);
+
+	if (!srq) {
+		mlx4_warn(dev, "Async event for bogus SRQ %08x\n", srqn);
+		return;
+	}
+
+	srq->event(srq, event_type);
+
+	if (atomic_dec_and_test(&srq->refcount))
+		complete(&srq->free);
+}
+
+static int mlx4_SW2HW_SRQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  int srq_num)
+{
+	return mlx4_cmd(dev, mailbox->dma, srq_num, 0, MLX4_CMD_SW2HW_SRQ,
+			MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_HW2SW_SRQ(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			  int srq_num)
+{
+	return mlx4_cmd_box(dev, 0, mailbox ? mailbox->dma : 0, srq_num,
+			    mailbox ? 0 : 1, MLX4_CMD_HW2SW_SRQ,
+			    MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_ARM_SRQ(struct mlx4_dev *dev, int srq_num, int limit_watermark)
+{
+	return mlx4_cmd(dev, limit_watermark, srq_num, 0, MLX4_CMD_ARM_SRQ,
+			MLX4_CMD_TIME_CLASS_B);
+}
+
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
+		   u64 db_rec, struct mlx4_srq *srq)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_srq_context *srq_context;
+	u64 mtt_addr;
+	int err;
+
+	srq->srqn = mlx4_bitmap_alloc(&srq_table->bitmap);
+	if (srq->srqn == -1)
+		return -ENOMEM;
+
+	err = mlx4_table_get(dev, &srq_table->table, srq->srqn);
+	if (err)
+		goto err_out;
+
+	err = mlx4_table_get(dev, &srq_table->cmpt_table, srq->srqn);
+	if (err)
+		goto err_put;
+
+	spin_lock_irq(&srq_table->lock);
+	err = radix_tree_insert(&srq_table->tree, srq->srqn, srq);
+	spin_unlock_irq(&srq_table->lock);
+	if (err)
+		goto err_cmpt_put;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = PTR_ERR(mailbox);
+		goto err_radix;
+	}
+
+	srq_context = mailbox->buf;
+	memset(srq_context, 0, sizeof *srq_context);
+
+	srq_context->state_logsize_srqn = cpu_to_be32((ilog2(srq->max) << 24) |
+						      srq->srqn);
+	srq_context->logstride          = srq->wqe_shift - 4;
+	srq_context->log_page_size      = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
+
+	mtt_addr = mlx4_mtt_addr(dev, mtt);
+	srq_context->mtt_base_addr_h    = mtt_addr >> 32;
+	srq_context->mtt_base_addr_l    = cpu_to_be32(mtt_addr & 0xffffffff);
+	srq_context->pd			= cpu_to_be32(pdn);
+	srq_context->db_rec_addr        = cpu_to_be64(db_rec);
+
+	err = mlx4_SW2HW_SRQ(dev, mailbox, srq->srqn);
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	if (err)
+		goto err_radix;
+
+	atomic_set(&srq->refcount, 1);
+	init_completion(&srq->free);
+
+	return 0;
+
+err_radix:
+	spin_lock_irq(&srq_table->lock);
+	radix_tree_delete(&srq_table->tree, srq->srqn);
+	spin_unlock_irq(&srq_table->lock);
+
+err_cmpt_put:
+	mlx4_table_put(dev, &srq_table->cmpt_table, srq->srqn);
+
+err_put:
+	mlx4_table_put(dev, &srq_table->table, srq->srqn);
+
+err_out:
+	mlx4_bitmap_free(&srq_table->bitmap, srq->srqn);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_alloc);
+
+void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
+	int err;
+
+	err = mlx4_HW2SW_SRQ(dev, NULL, srq->srqn);
+	if (err)
+		mlx4_warn(dev, "HW2SW_SRQ failed (%d) for SRQN %06x\n", err, srq->srqn);
+
+	spin_lock_irq(&srq_table->lock);
+	radix_tree_delete(&srq_table->tree, srq->srqn);
+	spin_unlock_irq(&srq_table->lock);
+
+	if (atomic_dec_and_test(&srq->refcount))
+		complete(&srq->free);
+	wait_for_completion(&srq->free);
+
+	mlx4_table_put(dev, &srq_table->table, srq->srqn);
+	mlx4_bitmap_free(&srq_table->bitmap, srq->srqn);
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_free);
+
+int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark)
+{
+	return mlx4_ARM_SRQ(dev, srq->srqn, limit_watermark);
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_arm);
+
+int __devinit mlx4_init_srq_table(struct mlx4_dev *dev)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
+	int err;
+
+	spin_lock_init(&srq_table->lock);
+	INIT_RADIX_TREE(&srq_table->tree, GFP_ATOMIC);
+
+	err = mlx4_bitmap_init(&srq_table->bitmap, dev->caps.num_srqs,
+			       dev->caps.num_srqs - 1, dev->caps.reserved_srqs);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void mlx4_cleanup_srq_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->srq_table.bitmap);
+}
