Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXDTWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXDTWmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXDTWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:42:19 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:46784 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbXDTWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:42:13 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 18:42:12 EDT
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="480194563:sNHT204592036"
Subject: [PATCH 1/6] [RFC]mlx4_core main files
In-Reply-To: <20074201532.4PiF0gUjC19I1fhy@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.IZZ23OZ6UzBQwQQb@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:37.0015 (UTC) FILETIME=[CC107A70:01C7839B]
Authentication-Results: sj-dkim-2; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCI driver and firmware command handling code from mlx4_core.
    
Signed-off-by: Roland Dreier <rolandd@cisco.com>

---

 cmd.c     |  429 ++++++++++++++++++++++++++++
 fw.c      |  758 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fw.h      |  165 ++++++++++
 main.c    |  939 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mlx4.h    |  334 ++++++++++++++++++++++
 profile.c |  238 +++++++++++++++
 reset.c   |  172 +++++++++++
 7 files changed, 3035 insertions(+)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
new file mode 100644
index 0000000..41bf47c
--- /dev/null
+++ b/drivers/net/mlx4/cmd.c
@@ -0,0 +1,429 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems, Inc.  All rights reserved.
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
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/errno.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include <asm/io.h>
+
+#include "mlx4.h"
+
+#define CMD_POLL_TOKEN 0xffff
+
+enum {
+	/* command completed successfully: */
+	CMD_STAT_OK		= 0x00,
+	/* Internal error (such as a bus error) occurred while processing command: */
+	CMD_STAT_INTERNAL_ERR	= 0x01,
+	/* Operation/command not supported or opcode modifier not supported: */
+	CMD_STAT_BAD_OP		= 0x02,
+	/* Parameter not supported or parameter out of range: */
+	CMD_STAT_BAD_PARAM	= 0x03,
+	/* System not enabled or bad system state: */
+	CMD_STAT_BAD_SYS_STATE	= 0x04,
+	/* Attempt to access reserved or unallocaterd resource: */
+	CMD_STAT_BAD_RESOURCE	= 0x05,
+	/* Requested resource is currently executing a command, or is otherwise busy: */
+	CMD_STAT_RESOURCE_BUSY	= 0x06,
+	/* Required capability exceeds device limits: */
+	CMD_STAT_EXCEED_LIM	= 0x08,
+	/* Resource is not in the appropriate state or ownership: */
+	CMD_STAT_BAD_RES_STATE	= 0x09,
+	/* Index out of range: */
+	CMD_STAT_BAD_INDEX	= 0x0a,
+	/* FW image corrupted: */
+	CMD_STAT_BAD_NVMEM	= 0x0b,
+	/* Attempt to modify a QP/EE which is not in the presumed state: */
+	CMD_STAT_BAD_QP_STATE   = 0x10,
+	/* Bad segment parameters (Address/Size): */
+	CMD_STAT_BAD_SEG_PARAM	= 0x20,
+	/* Memory Region has Memory Windows bound to: */
+	CMD_STAT_REG_BOUND	= 0x21,
+	/* HCA local attached memory not present: */
+	CMD_STAT_LAM_NOT_PRE	= 0x22,
+	/* Bad management packet (silently discarded): */
+	CMD_STAT_BAD_PKT	= 0x30,
+	/* More outstanding CQEs in CQ than new CQ size: */
+	CMD_STAT_BAD_SIZE	= 0x40
+};
+
+enum {
+	HCR_IN_PARAM_OFFSET	= 0x00,
+	HCR_IN_MODIFIER_OFFSET	= 0x08,
+	HCR_OUT_PARAM_OFFSET	= 0x0c,
+	HCR_TOKEN_OFFSET	= 0x14,
+	HCR_STATUS_OFFSET	= 0x18,
+
+	HCR_OPMOD_SHIFT		= 12,
+	HCR_T_BIT		= 21,
+	HCR_E_BIT		= 22,
+	HCR_GO_BIT		= 23
+};
+
+enum {
+	GO_BIT_TIMEOUT		= 10000
+};
+
+struct mlx4_cmd_context {
+	struct completion	done;
+	int			result;
+	int			next;
+	u64			out_param;
+	u16			token;
+};
+
+static int mlx4_status_to_errno(u8 status) {
+	static const int trans_table[] = {
+		[CMD_STAT_INTERNAL_ERR]	  = -EIO,
+		[CMD_STAT_BAD_OP]	  = -EPERM,
+		[CMD_STAT_BAD_PARAM]	  = -EINVAL,
+		[CMD_STAT_BAD_SYS_STATE]  = -ENXIO,
+		[CMD_STAT_BAD_RESOURCE]	  = -EBADF,
+		[CMD_STAT_RESOURCE_BUSY]  = -EBUSY,
+		[CMD_STAT_EXCEED_LIM]	  = -ENOMEM,
+		[CMD_STAT_BAD_RES_STATE]  = -EBADF,
+		[CMD_STAT_BAD_INDEX]	  = -EBADF,
+		[CMD_STAT_BAD_NVMEM]	  = -EFAULT,
+		[CMD_STAT_BAD_QP_STATE]   = -EINVAL,
+		[CMD_STAT_BAD_SEG_PARAM]  = -EFAULT,
+		[CMD_STAT_REG_BOUND]	  = -EBUSY,
+		[CMD_STAT_LAM_NOT_PRE]	  = -EAGAIN,
+		[CMD_STAT_BAD_PKT]	  = -EINVAL,
+		[CMD_STAT_BAD_SIZE]	  = -ENOMEM,
+	};
+
+	if (status >= ARRAY_SIZE(trans_table) ||
+	    (status != CMD_STAT_OK && trans_table[status] == 0))
+		return -EIO;
+
+	return trans_table[status];
+}
+
+static int cmd_pending(struct mlx4_dev *dev)
+{
+	u32 status = readl(mlx4_priv(dev)->cmd.hcr + HCR_STATUS_OFFSET);
+
+	return (status & swab32(1 << HCR_GO_BIT)) ||
+		(mlx4_priv(dev)->cmd.toggle ==
+		 !!(status & swab32(1 << HCR_T_BIT)));
+}
+
+static int mlx4_cmd_post(struct mlx4_dev *dev, u64 in_param, u64 out_param,
+			 u32 in_modifier, u8 op_modifier, u16 op, u16 token,
+			 int event)
+{
+	struct mlx4_cmd *cmd = &mlx4_priv(dev)->cmd;
+	u32 __iomem *hcr = cmd->hcr;
+	int ret = -EAGAIN;
+	unsigned long end;
+
+	mutex_lock(&cmd->hcr_mutex);
+
+	end = jiffies;
+	if (event)
+		end += HZ * 10;
+
+	while (cmd_pending(dev)) {
+		if (time_after_eq(jiffies, end))
+			goto out;
+		cond_resched();
+	}
+
+	/*
+	 * We use writel (instead of something like memcpy_toio)
+	 * because writes of less than 32 bits to the HCR don't work
+	 * (and some architectures such as ia64 implement memcpy_toio
+	 * in terms of writeb).
+	 */
+	__raw_writel((__force u32) cpu_to_be32(in_param >> 32),		  hcr + 0);
+	__raw_writel((__force u32) cpu_to_be32(in_param & 0xfffffffful),  hcr + 1);
+	__raw_writel((__force u32) cpu_to_be32(in_modifier),		  hcr + 2);
+	__raw_writel((__force u32) cpu_to_be32(out_param >> 32),	  hcr + 3);
+	__raw_writel((__force u32) cpu_to_be32(out_param & 0xfffffffful), hcr + 4);
+	__raw_writel((__force u32) cpu_to_be32(token << 16),		  hcr + 5);
+
+	/* __raw_writel may not order writes. */
+	wmb();
+
+	__raw_writel((__force u32) cpu_to_be32((1 << HCR_GO_BIT)		|
+					       (cmd->toggle << HCR_T_BIT)	|
+					       (event ? (1 << HCR_E_BIT) : 0)	|
+					       (op_modifier << HCR_OPMOD_SHIFT) |
+					       op),			  hcr + 6);
+	cmd->toggle = cmd->toggle ^ 1;
+
+	ret = 0;
+
+out:
+	mutex_unlock(&cmd->hcr_mutex);
+	return ret;
+}
+
+static int mlx4_cmd_poll(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+			 int out_is_imm, u32 in_modifier, u8 op_modifier,
+			 u16 op, unsigned long timeout)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	void __iomem *hcr = priv->cmd.hcr;
+	int err = 0;
+	unsigned long end;
+
+	down(&priv->cmd.poll_sem);
+
+	err = mlx4_cmd_post(dev, in_param, out_param ? *out_param : 0,
+			    in_modifier, op_modifier, op, CMD_POLL_TOKEN, 0);
+	if (err)
+		goto out;
+
+	end = msecs_to_jiffies(timeout) + jiffies;
+	while (cmd_pending(dev) && time_before(jiffies, end))
+		cond_resched();
+
+	if (cmd_pending(dev)) {
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	if (out_is_imm)
+		*out_param =
+			(u64) be32_to_cpu((__force __be32)
+					  __raw_readl(hcr + HCR_OUT_PARAM_OFFSET)) << 32 |
+			(u64) be32_to_cpu((__force __be32)
+					  __raw_readl(hcr + HCR_OUT_PARAM_OFFSET + 4));
+
+	err = mlx4_status_to_errno(be32_to_cpu((__force __be32)
+					       __raw_readl(hcr + HCR_STATUS_OFFSET)) >> 24);
+
+out:
+	up(&priv->cmd.poll_sem);
+	return err;
+}
+
+void mlx4_cmd_event(struct mlx4_dev *dev, u16 token, u8 status, u64 out_param)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_cmd_context *context =
+		&priv->cmd.context[token & priv->cmd.token_mask];
+
+	/* previously timed out command completing at long last */
+	if (token != context->token)
+		return;
+
+	context->result    = mlx4_status_to_errno(status);
+	context->out_param = out_param;
+
+	context->token += priv->cmd.token_mask + 1;
+
+	complete(&context->done);
+}
+
+static int mlx4_cmd_wait(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+			 int out_is_imm, u32 in_modifier, u8 op_modifier,
+			 u16 op, unsigned long timeout)
+{
+	struct mlx4_cmd *cmd = &mlx4_priv(dev)->cmd;
+	struct mlx4_cmd_context *context;
+	int err = 0;
+
+	down(&cmd->event_sem);
+
+	spin_lock(&cmd->context_lock);
+	BUG_ON(cmd->free_head < 0);
+	context = &cmd->context[cmd->free_head];
+	cmd->free_head = context->next;
+	spin_unlock(&cmd->context_lock);
+
+	init_completion(&context->done);
+
+	mlx4_cmd_post(dev, in_param, out_param ? *out_param : 0,
+		      in_modifier, op_modifier, op, context->token, 1);
+
+	if (!wait_for_completion_timeout(&context->done, msecs_to_jiffies(timeout))) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = context->result;
+	if (err)
+		goto out;
+
+	if (out_is_imm)
+		*out_param = context->out_param;
+
+out:
+	spin_lock(&cmd->context_lock);
+	context->next = cmd->free_head;
+	cmd->free_head = context - cmd->context;
+	spin_unlock(&cmd->context_lock);
+
+	up(&cmd->event_sem);
+	return err;
+}
+
+int __mlx4_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+	       int out_is_imm, u32 in_modifier, u8 op_modifier,
+	       u16 op, unsigned long timeout)
+{
+	if (mlx4_priv(dev)->cmd.use_events)
+		return mlx4_cmd_wait(dev, in_param, out_param, out_is_imm,
+				     in_modifier, op_modifier, op, timeout);
+	else
+		return mlx4_cmd_poll(dev, in_param, out_param, out_is_imm,
+				     in_modifier, op_modifier, op, timeout);
+}
+EXPORT_SYMBOL_GPL(__mlx4_cmd);
+
+int mlx4_cmd_init(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	mutex_init(&priv->cmd.hcr_mutex);
+	sema_init(&priv->cmd.poll_sem, 1);
+	priv->cmd.use_events = 0;
+	priv->cmd.toggle     = 1;
+
+	priv->cmd.hcr = ioremap(pci_resource_start(dev->pdev, 0) + MLX4_HCR_BASE,
+				MLX4_HCR_SIZE);
+	if (!priv->cmd.hcr) {
+		mlx4_err(dev, "Couldn't map command register.");
+		return -ENOMEM;
+	}
+
+	priv->cmd.pool = pci_pool_create("mlx4_cmd", dev->pdev,
+					 MLX4_MAILBOX_SIZE,
+					 MLX4_MAILBOX_SIZE, 0);
+	if (!priv->cmd.pool) {
+		iounmap(priv->cmd.hcr);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void mlx4_cmd_cleanup(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	pci_pool_destroy(priv->cmd.pool);
+	iounmap(priv->cmd.hcr);
+}
+
+/*
+ * Switch to using events to issue FW commands (can only be called
+ * after event queue for command events has been initialized).
+ */
+int mlx4_cmd_use_events(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int i;
+
+	priv->cmd.context = kmalloc(priv->cmd.max_cmds *
+				   sizeof (struct mlx4_cmd_context),
+				   GFP_KERNEL);
+	if (!priv->cmd.context)
+		return -ENOMEM;
+
+	for (i = 0; i < priv->cmd.max_cmds; ++i) {
+		priv->cmd.context[i].token = i;
+		priv->cmd.context[i].next  = i + 1;
+	}
+
+	priv->cmd.context[priv->cmd.max_cmds - 1].next = -1;
+	priv->cmd.free_head = 0;
+
+	sema_init(&priv->cmd.event_sem, priv->cmd.max_cmds);
+	spin_lock_init(&priv->cmd.context_lock);
+
+	for (priv->cmd.token_mask = 1;
+	     priv->cmd.token_mask < priv->cmd.max_cmds;
+	     priv->cmd.token_mask <<= 1)
+		; /* nothing */
+	--priv->cmd.token_mask;
+
+	priv->cmd.use_events = 1;
+
+	down(&priv->cmd.poll_sem);
+
+	return 0;
+}
+
+/*
+ * Switch back to polling (used when shutting down the device)
+ */
+void mlx4_cmd_use_polling(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int i;
+
+	priv->cmd.use_events = 0;
+
+	for (i = 0; i < priv->cmd.max_cmds; ++i)
+		down(&priv->cmd.event_sem);
+
+	kfree(priv->cmd.context);
+
+	up(&priv->cmd.poll_sem);
+}
+
+struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+
+	mailbox = kmalloc(sizeof *mailbox, GFP_KERNEL);
+	if (!mailbox)
+		return ERR_PTR(-ENOMEM);
+
+	mailbox->buf = pci_pool_alloc(mlx4_priv(dev)->cmd.pool, GFP_KERNEL,
+				      &mailbox->dma);
+	if (!mailbox->buf) {
+		kfree(mailbox);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return mailbox;
+}
+EXPORT_SYMBOL_GPL(mlx4_alloc_cmd_mailbox);
+
+void mlx4_free_cmd_mailbox(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox)
+{
+	if (!mailbox)
+		return;
+
+	pci_pool_free(mlx4_priv(dev)->cmd.pool, mailbox->buf, mailbox->dma);
+	kfree(mailbox);
+}
+EXPORT_SYMBOL_GPL(mlx4_free_cmd_mailbox);
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
new file mode 100644
index 0000000..0066eb7
--- /dev/null
+++ b/drivers/net/mlx4/fw.c
@@ -0,0 +1,758 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems, Inc.  All rights reserved.
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
+#include <linux/mlx4/cmd.h>
+
+#include "fw.h"
+#include "icm.h"
+
+extern void __buggy_use_of_MLX4_GET(void);
+extern void __buggy_use_of_MLX4_PUT(void);
+
+#define MLX4_GET(dest, source, offset)				      \
+	do {							      \
+		void *__p = (char *) (source) + (offset);	      \
+		switch (sizeof (dest)) {			      \
+		case 1: (dest) = *(u8 *) __p;	    break;	      \
+		case 2: (dest) = be16_to_cpup(__p); break;	      \
+		case 4: (dest) = be32_to_cpup(__p); break;	      \
+		case 8: (dest) = be64_to_cpup(__p); break;	      \
+		default: __buggy_use_of_MLX4_GET();		      \
+		}						      \
+	} while (0)
+
+#define MLX4_PUT(dest, source, offset)				      \
+	do {							      \
+		void *__d = ((char *) (dest) + (offset));	      \
+		switch (sizeof(source)) {			      \
+		case 1: *(u8 *) __d = (source);		       break; \
+		case 2:	*(__be16 *) __d = cpu_to_be16(source); break; \
+		case 4:	*(__be32 *) __d = cpu_to_be32(source); break; \
+		case 8:	*(__be64 *) __d = cpu_to_be64(source); break; \
+		default: __buggy_use_of_MLX4_PUT();		      \
+		}						      \
+	} while (0)
+
+static void dump_dev_cap_flags(struct mlx4_dev *dev, u32 flags)
+{
+	static const char *fname[] = {
+		[ 0] = "RC transport",
+		[ 1] = "UC transport",
+		[ 2] = "UD transport",
+		[ 3] = "SRC transport",
+		[ 4] = "reliable multicast",
+		[ 5] = "FCoIB support",
+		[ 6] = "SRQ support",
+		[ 7] = "IPoIB checksum offload",
+		[ 8] = "P_Key violation counter",
+		[ 9] = "Q_Key violation counter",
+		[10] = "VMM",
+		[16] = "MW support",
+		[17] = "APM support",
+		[18] = "Atomic ops support",
+		[19] = "Raw multicast support",
+		[20] = "Address vector port checking support",
+		[21] = "UD multicast support",
+		[24] = "Demand paging support",
+		[25] = "Router support"
+	};
+	int i;
+
+	mlx4_dbg(dev, "DEV_CAP flags:\n");
+	for (i = 0; i < 32; ++i)
+		if (fname[i] && (flags & (1 << i)))
+			mlx4_dbg(dev, "    %s\n", fname[i]);
+}
+
+int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *outbox;
+	u8 field;
+	u16 size;
+	u16 stat_rate;
+	int err;
+
+#define QUERY_DEV_CAP_OUT_SIZE		       0x100
+#define QUERY_DEV_CAP_MAX_SRQ_SZ_OFFSET		0x10
+#define QUERY_DEV_CAP_MAX_QP_SZ_OFFSET		0x11
+#define QUERY_DEV_CAP_RSVD_QP_OFFSET		0x12
+#define QUERY_DEV_CAP_MAX_QP_OFFSET		0x13
+#define QUERY_DEV_CAP_RSVD_SRQ_OFFSET		0x14
+#define QUERY_DEV_CAP_MAX_SRQ_OFFSET		0x15
+#define QUERY_DEV_CAP_RSVD_EEC_OFFSET		0x16
+#define QUERY_DEV_CAP_MAX_EEC_OFFSET		0x17
+#define QUERY_DEV_CAP_MAX_CQ_SZ_OFFSET		0x19
+#define QUERY_DEV_CAP_RSVD_CQ_OFFSET		0x1a
+#define QUERY_DEV_CAP_MAX_CQ_OFFSET		0x1b
+#define QUERY_DEV_CAP_MAX_MPT_OFFSET		0x1d
+#define QUERY_DEV_CAP_RSVD_EQ_OFFSET		0x1e
+#define QUERY_DEV_CAP_MAX_EQ_OFFSET		0x1f
+#define QUERY_DEV_CAP_RSVD_MTT_OFFSET		0x20
+#define QUERY_DEV_CAP_MAX_MRW_SZ_OFFSET		0x21
+#define QUERY_DEV_CAP_RSVD_MRW_OFFSET		0x22
+#define QUERY_DEV_CAP_MAX_MTT_SEG_OFFSET	0x23
+#define QUERY_DEV_CAP_MAX_AV_OFFSET		0x27
+#define QUERY_DEV_CAP_MAX_REQ_QP_OFFSET		0x29
+#define QUERY_DEV_CAP_MAX_RES_QP_OFFSET		0x2b
+#define QUERY_DEV_CAP_MAX_RDMA_OFFSET		0x2f
+#define QUERY_DEV_CAP_RSZ_SRQ_OFFSET		0x33
+#define QUERY_DEV_CAP_ACK_DELAY_OFFSET		0x35
+#define QUERY_DEV_CAP_MTU_WIDTH_OFFSET		0x36
+#define QUERY_DEV_CAP_VL_PORT_OFFSET		0x37
+#define QUERY_DEV_CAP_MAX_GID_OFFSET		0x3b
+#define QUERY_DEV_CAP_RATE_SUPPORT_OFFSET	0x3c
+#define QUERY_DEV_CAP_MAX_PKEY_OFFSET		0x3f
+#define QUERY_DEV_CAP_FLAGS_OFFSET		0x44
+#define QUERY_DEV_CAP_RSVD_UAR_OFFSET		0x48
+#define QUERY_DEV_CAP_UAR_SZ_OFFSET		0x49
+#define QUERY_DEV_CAP_PAGE_SZ_OFFSET		0x4b
+#define QUERY_DEV_CAP_MAX_SG_SQ_OFFSET		0x51
+#define QUERY_DEV_CAP_MAX_DESC_SZ_SQ_OFFSET	0x52
+#define QUERY_DEV_CAP_MAX_SG_RQ_OFFSET		0x55
+#define QUERY_DEV_CAP_MAX_DESC_SZ_RQ_OFFSET	0x56
+#define QUERY_DEV_CAP_MAX_QP_MCG_OFFSET		0x61
+#define QUERY_DEV_CAP_RSVD_MCG_OFFSET		0x62
+#define QUERY_DEV_CAP_MAX_MCG_OFFSET		0x63
+#define QUERY_DEV_CAP_RSVD_PD_OFFSET		0x64
+#define QUERY_DEV_CAP_MAX_PD_OFFSET		0x65
+#define QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET	0x80
+#define QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET	0x82
+#define QUERY_DEV_CAP_AUX_ENTRY_SZ_OFFSET	0x84
+#define QUERY_DEV_CAP_ALTC_ENTRY_SZ_OFFSET	0x86
+#define QUERY_DEV_CAP_EQC_ENTRY_SZ_OFFSET	0x88
+#define QUERY_DEV_CAP_CQC_ENTRY_SZ_OFFSET	0x8a
+#define QUERY_DEV_CAP_SRQ_ENTRY_SZ_OFFSET	0x8c
+#define QUERY_DEV_CAP_C_MPT_ENTRY_SZ_OFFSET	0x8e
+#define QUERY_DEV_CAP_MTT_ENTRY_SZ_OFFSET	0x90
+#define QUERY_DEV_CAP_D_MPT_ENTRY_SZ_OFFSET	0x92
+#define QUERY_DEV_CAP_BMME_FLAGS_OFFSET		0x97
+#define QUERY_DEV_CAP_RSVD_LKEY_OFFSET		0x98
+#define QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET		0xa0
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	outbox = mailbox->buf;
+
+	err = mlx4_cmd_box(dev, 0, mailbox->dma, 0, 0, MLX4_CMD_QUERY_DEV_CAP,
+			   MLX4_CMD_TIME_CLASS_A);
+
+	if (err)
+		goto out;
+
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_QP_OFFSET);
+	dev_cap->reserved_qps = 1 << (field & 0xf);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_OFFSET);
+	dev_cap->max_qps = 1 << (field & 0x1f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_SRQ_OFFSET);
+	dev_cap->reserved_srqs = 1 << (field >> 4);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_SRQ_OFFSET);
+	dev_cap->max_srqs = 1 << (field & 0x1f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_CQ_SZ_OFFSET);
+	dev_cap->max_cq_sz = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_CQ_OFFSET);
+	dev_cap->reserved_cqs = 1 << (field & 0xf);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_CQ_OFFSET);
+	dev_cap->max_cqs = 1 << (field & 0x1f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MPT_OFFSET);
+	dev_cap->max_mpts = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_EQ_OFFSET);
+	dev_cap->reserved_eqs = 1 << (field & 0xf);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_EQ_OFFSET);
+	dev_cap->max_eqs = 1 << (field & 0x7);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_MTT_OFFSET);
+	dev_cap->reserved_mtts = 1 << (field >> 4);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MRW_SZ_OFFSET);
+	dev_cap->max_mrw_sz = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_MRW_OFFSET);
+	dev_cap->reserved_mrws = 1 << (field & 0xf);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MTT_SEG_OFFSET);
+	dev_cap->max_mtt_seg = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_REQ_QP_OFFSET);
+	dev_cap->max_requester_per_qp = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_RES_QP_OFFSET);
+	dev_cap->max_responder_per_qp = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_RDMA_OFFSET);
+	dev_cap->max_rdma_global = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_ACK_DELAY_OFFSET);
+	dev_cap->local_ca_ack_delay = field & 0x1f;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MTU_WIDTH_OFFSET);
+	dev_cap->max_mtu	= field >> 4;
+	dev_cap->max_port_width = field & 0xf;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_VL_PORT_OFFSET);
+	dev_cap->max_vl    = field >> 4;
+	dev_cap->num_ports = field & 0xf;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_GID_OFFSET);
+	dev_cap->max_gids = 1 << (field & 0xf);
+	MLX4_GET(stat_rate, outbox, QUERY_DEV_CAP_RATE_SUPPORT_OFFSET);
+	dev_cap->stat_rate_support = stat_rate;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PKEY_OFFSET);
+	dev_cap->max_pkeys = 1 << (field & 0xf);
+	MLX4_GET(dev_cap->flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
+	dev_cap->reserved_uars = field >> 4;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_UAR_SZ_OFFSET);
+	dev_cap->uar_size = 1 << ((field & 0x3f) + 20);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_PAGE_SZ_OFFSET);
+	dev_cap->min_page_sz = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_SG_SQ_OFFSET);
+	dev_cap->max_sq_sg = field;
+
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_MAX_DESC_SZ_SQ_OFFSET);
+	dev_cap->max_sq_desc_sz = size;
+
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_MCG_OFFSET);
+	dev_cap->max_qp_per_mcg = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_MCG_OFFSET);
+	dev_cap->reserved_mgms = field & 0xf;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MCG_OFFSET);
+	dev_cap->max_mcgs = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_PD_OFFSET);
+	dev_cap->reserved_pds = field >> 4;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PD_OFFSET);
+	dev_cap->max_pds = 1 << (field & 0x3f);
+
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET);
+	dev_cap->rdmarc_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET);
+	dev_cap->qpc_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_AUX_ENTRY_SZ_OFFSET);
+	dev_cap->aux_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_ALTC_ENTRY_SZ_OFFSET);
+	dev_cap->altc_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_EQC_ENTRY_SZ_OFFSET);
+	dev_cap->eqc_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_CQC_ENTRY_SZ_OFFSET);
+	dev_cap->cqc_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_SRQ_ENTRY_SZ_OFFSET);
+	dev_cap->srq_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_C_MPT_ENTRY_SZ_OFFSET);
+	dev_cap->cmpt_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_MTT_ENTRY_SZ_OFFSET);
+	dev_cap->mtt_entry_sz = size;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_D_MPT_ENTRY_SZ_OFFSET);
+	dev_cap->dmpt_entry_sz = size;
+
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_SRQ_SZ_OFFSET);
+	dev_cap->max_srq_sz = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_SZ_OFFSET);
+	dev_cap->max_qp_sz = 1 << field;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSZ_SRQ_OFFSET);
+	dev_cap->resize_srq = field & 1;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_SG_RQ_OFFSET);
+	dev_cap->max_rq_sg = field;
+	MLX4_GET(size, outbox, QUERY_DEV_CAP_MAX_DESC_SZ_RQ_OFFSET);
+	dev_cap->max_rq_desc_sz = size;
+
+	MLX4_GET(dev_cap->bmme_flags, outbox,
+		 QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
+	MLX4_GET(dev_cap->reserved_lkey, outbox,
+		 QUERY_DEV_CAP_RSVD_LKEY_OFFSET);
+	MLX4_GET(dev_cap->max_icm_sz, outbox,
+		 QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET);
+
+	if (dev_cap->bmme_flags & 1)
+		mlx4_dbg(dev, "Base MM extensions: yes "
+			 "(flags %d, rsvd L_Key %08x)\n",
+			 dev_cap->bmme_flags, dev_cap->reserved_lkey);
+	else
+		mlx4_dbg(dev, "Base MM extensions: no\n");
+
+	/*
+	 * Each UAR has 4 EQ doorbells; so if a UAR is reserved, then
+	 * we can't use any EQs whose doorbell falls on that page,
+	 * even if the EQ itself isn't reserved.
+	 */
+	dev_cap->reserved_eqs = max(dev_cap->reserved_uars * 4,
+				    dev_cap->reserved_eqs);
+
+	mlx4_dbg(dev, "Max ICM size %lld MB\n",
+		 (unsigned long long) dev_cap->max_icm_sz >> 20);
+	mlx4_dbg(dev, "Max QPs: %d, reserved QPs: %d, entry size: %d\n",
+		 dev_cap->max_qps, dev_cap->reserved_qps, dev_cap->qpc_entry_sz);
+	mlx4_dbg(dev, "Max SRQs: %d, reserved SRQs: %d, entry size: %d\n",
+		 dev_cap->max_srqs, dev_cap->reserved_srqs, dev_cap->srq_entry_sz);
+	mlx4_dbg(dev, "Max CQs: %d, reserved CQs: %d, entry size: %d\n",
+		 dev_cap->max_cqs, dev_cap->reserved_cqs, dev_cap->cqc_entry_sz);
+	mlx4_dbg(dev, "Max EQs: %d, reserved EQs: %d, entry size: %d\n",
+		 dev_cap->max_eqs, dev_cap->reserved_eqs, dev_cap->eqc_entry_sz);
+	mlx4_dbg(dev, "reserved MPTs: %d, reserved MTTs: %d\n",
+		 dev_cap->reserved_mrws, dev_cap->reserved_mtts);
+	mlx4_dbg(dev, "Max PDs: %d, reserved PDs: %d, reserved UARs: %d\n",
+		 dev_cap->max_pds, dev_cap->reserved_pds, dev_cap->reserved_uars);
+	mlx4_dbg(dev, "Max QP/MCG: %d, reserved MGMs: %d\n",
+		 dev_cap->max_pds, dev_cap->reserved_mgms);
+	mlx4_dbg(dev, "Max CQEs: %d, max WQEs: %d, max SRQ WQEs: %d\n",
+		 dev_cap->max_cq_sz, dev_cap->max_qp_sz, dev_cap->max_srq_sz);
+	mlx4_dbg(dev, "Local CA ACK delay: %d, max MTU: %d, port width cap: %d\n",
+		 dev_cap->local_ca_ack_delay, 128 << dev_cap->max_mtu,
+		 dev_cap->max_port_width);
+	mlx4_dbg(dev, "Max SQ desc size: %d, max SQ S/G: %d\n",
+		 dev_cap->max_sq_desc_sz, dev_cap->max_sq_sg);
+	mlx4_dbg(dev, "Max RQ desc size: %d, max RQ S/G: %d\n",
+		 dev_cap->max_rq_desc_sz, dev_cap->max_rq_sg);
+
+	dump_dev_cap_flags(dev, dev_cap->flags);
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mlx4_map_cmd(struct mlx4_dev *dev, u16 op, struct mlx4_icm *icm, u64 virt)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_icm_iter iter;
+	__be64 *pages;
+	int lg;
+	int nent = 0;
+	int i;
+	int err = 0;
+	int ts = 0, tc = 0;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	memset(mailbox->buf, 0, MLX4_MAILBOX_SIZE);
+	pages = mailbox->buf;
+
+	for (mlx4_icm_first(icm, &iter);
+	     !mlx4_icm_last(&iter);
+	     mlx4_icm_next(&iter)) {
+		/*
+		 * We have to pass pages that are aligned to their
+		 * size, so find the least significant 1 in the
+		 * address or size and use that as our log2 size.
+		 */
+		lg = ffs(mlx4_icm_addr(&iter) | mlx4_icm_size(&iter)) - 1;
+		if (lg < MLX4_ICM_PAGE_SHIFT) {
+			mlx4_warn(dev, "Got FW area not aligned to %d (%llx/%lx).\n",
+				   MLX4_ICM_PAGE_SIZE,
+				   (unsigned long long) mlx4_icm_addr(&iter),
+				   mlx4_icm_size(&iter));
+			err = -EINVAL;
+			goto out;
+		}
+
+		for (i = 0; i < mlx4_icm_size(&iter) >> lg; ++i) {
+			if (virt != -1) {
+				pages[nent * 2] = cpu_to_be64(virt);
+				virt += 1 << lg;
+			}
+
+			pages[nent * 2 + 1] =
+				cpu_to_be64((mlx4_icm_addr(&iter) + (i << lg)) |
+					    (lg - MLX4_ICM_PAGE_SHIFT));
+			ts += 1 << (lg - 10);
+			++tc;
+
+			if (++nent == MLX4_MAILBOX_SIZE / 16) {
+				err = mlx4_cmd(dev, mailbox->dma, nent, 0, op,
+						MLX4_CMD_TIME_CLASS_B);
+				if (err)
+					goto out;
+				nent = 0;
+			}
+		}
+	}
+
+	if (nent)
+		err = mlx4_cmd(dev, mailbox->dma, nent, 0, op, MLX4_CMD_TIME_CLASS_B);
+	if (err)
+		goto out;
+
+	switch (op) {
+	case MLX4_CMD_MAP_FA:
+		mlx4_dbg(dev, "Mapped %d chunks/%d KB for FW.\n", tc, ts);
+		break;
+	case MLX4_CMD_MAP_ICM_AUX:
+		mlx4_dbg(dev, "Mapped %d chunks/%d KB for ICM aux.\n", tc, ts);
+		break;
+	case MLX4_CMD_MAP_ICM:
+		mlx4_dbg(dev, "Mapped %d chunks/%d KB at %llx for ICM.\n",
+			  tc, ts, (unsigned long long) virt - (ts << 10));
+		break;
+	}
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mlx4_MAP_FA(struct mlx4_dev *dev, struct mlx4_icm *icm)
+{
+	return mlx4_map_cmd(dev, MLX4_CMD_MAP_FA, icm, -1);
+}
+
+int mlx4_UNMAP_FA(struct mlx4_dev *dev)
+{
+	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_UNMAP_FA, MLX4_CMD_TIME_CLASS_B);
+}
+
+
+int mlx4_RUN_FW(struct mlx4_dev *dev)
+{
+	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_RUN_FW, MLX4_CMD_TIME_CLASS_A);
+}
+
+int mlx4_QUERY_FW(struct mlx4_dev *dev)
+{
+	struct mlx4_fw  *fw  = &mlx4_priv(dev)->fw;
+	struct mlx4_cmd *cmd = &mlx4_priv(dev)->cmd;
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *outbox;
+	int err = 0;
+	u64 fw_ver;
+	u8 lg;
+
+#define QUERY_FW_OUT_SIZE             0x100
+#define QUERY_FW_VER_OFFSET            0x00
+#define QUERY_FW_MAX_CMD_OFFSET        0x0f
+#define QUERY_FW_ERR_START_OFFSET      0x30
+#define QUERY_FW_ERR_SIZE_OFFSET       0x38
+#define QUERY_FW_ERR_BAR_OFFSET        0x3c
+
+#define QUERY_FW_SIZE_OFFSET           0x00
+#define QUERY_FW_CLR_INT_BASE_OFFSET   0x20
+#define QUERY_FW_CLR_INT_BAR_OFFSET    0x28
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	outbox = mailbox->buf;
+
+	err = mlx4_cmd_box(dev, 0, mailbox->dma, 0, 0, MLX4_CMD_QUERY_FW,
+			    MLX4_CMD_TIME_CLASS_A);
+	if (err)
+		goto out;
+
+	MLX4_GET(fw_ver, outbox, QUERY_FW_VER_OFFSET);
+	/*
+	 * FW subminor version is at more signifant bits than minor
+	 * version, so swap here.
+	 */
+	dev->caps.fw_ver = (fw_ver & 0xffff00000000ull) |
+		((fw_ver & 0xffff0000ull) >> 16) |
+		((fw_ver & 0x0000ffffull) << 16);
+
+	MLX4_GET(lg, outbox, QUERY_FW_MAX_CMD_OFFSET);
+	cmd->max_cmds = 1 << lg;
+
+	mlx4_dbg(dev, "FW version %d.%d.%03d, max commands %d\n",
+		 (int) (dev->caps.fw_ver >> 32),
+		 (int) (dev->caps.fw_ver >> 16) & 0xffff,
+		 (int) dev->caps.fw_ver & 0xffff,
+		 cmd->max_cmds);
+
+	MLX4_GET(fw->catas_addr, outbox, QUERY_FW_ERR_START_OFFSET);
+	MLX4_GET(fw->catas_size, outbox, QUERY_FW_ERR_SIZE_OFFSET);
+	MLX4_GET(fw->catas_bar,  outbox, QUERY_FW_ERR_BAR_OFFSET);
+	fw->catas_bar = (fw->catas_bar >> 6) * 2;
+
+	mlx4_dbg(dev, "Catastrophic error buffer at 0x%llx, size 0x%x, BAR %d\n",
+		 (unsigned long long) fw->catas_addr, fw->catas_size, fw->catas_bar);
+
+	MLX4_GET(fw->fw_pages,     outbox, QUERY_FW_SIZE_OFFSET);
+	MLX4_GET(fw->clr_int_base, outbox, QUERY_FW_CLR_INT_BASE_OFFSET);
+	MLX4_GET(fw->clr_int_bar,  outbox, QUERY_FW_CLR_INT_BAR_OFFSET);
+	fw->clr_int_bar = (fw->clr_int_bar >> 6) * 2;
+
+	mlx4_dbg(dev, "FW size %d KB\n", fw->fw_pages >> 2);
+
+	/*
+	 * Round up number of system pages needed in case
+	 * MLX4_ICM_PAGE_SIZE < PAGE_SIZE.
+	 */
+	fw->fw_pages =
+		ALIGN(fw->fw_pages, PAGE_SIZE / MLX4_ICM_PAGE_SIZE) >>
+		(PAGE_SHIFT - MLX4_ICM_PAGE_SHIFT);
+
+	mlx4_dbg(dev, "Clear int @ %llx, BAR %d\n",
+		 (unsigned long long) fw->clr_int_base, fw->clr_int_bar);
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+static void get_board_id(void *vsd, char *board_id)
+{
+	int i;
+
+#define VSD_OFFSET_SIG1		0x00
+#define VSD_OFFSET_SIG2		0xde
+#define VSD_OFFSET_MLX_BOARD_ID	0xd0
+#define VSD_OFFSET_TS_BOARD_ID	0x20
+
+#define VSD_SIGNATURE_TOPSPIN	0x5ad
+
+	memset(board_id, 0, MLX4_BOARD_ID_LEN);
+
+	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
+	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
+		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MLX4_BOARD_ID_LEN);
+	} else {
+		/*
+		 * The board ID is a string but the firmware byte
+		 * swaps each 4-byte word before passing it back to
+		 * us.  Therefore we need to swab it before printing.
+		 */
+		for (i = 0; i < 4; ++i)
+			((u32 *) board_id)[i] =
+				swab32(*(u32 *) (vsd + VSD_OFFSET_MLX_BOARD_ID + i * 4));
+	}
+}
+
+int mlx4_QUERY_ADAPTER(struct mlx4_dev *dev, struct mlx4_adapter *adapter)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *outbox;
+	int err;
+
+#define QUERY_ADAPTER_OUT_SIZE             0x100
+#define QUERY_ADAPTER_VENDOR_ID_OFFSET     0x00
+#define QUERY_ADAPTER_DEVICE_ID_OFFSET     0x04
+#define QUERY_ADAPTER_REVISION_ID_OFFSET   0x08
+#define QUERY_ADAPTER_INTA_PIN_OFFSET      0x10
+#define QUERY_ADAPTER_VSD_OFFSET           0x20
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	outbox = mailbox->buf;
+
+	err = mlx4_cmd_box(dev, 0, mailbox->dma, 0, 0, MLX4_CMD_QUERY_ADAPTER,
+			   MLX4_CMD_TIME_CLASS_A);
+	if (err)
+		goto out;
+
+	MLX4_GET(adapter->vendor_id, outbox,   QUERY_ADAPTER_VENDOR_ID_OFFSET);
+	MLX4_GET(adapter->device_id, outbox,   QUERY_ADAPTER_DEVICE_ID_OFFSET);
+	MLX4_GET(adapter->revision_id, outbox, QUERY_ADAPTER_REVISION_ID_OFFSET);
+	MLX4_GET(adapter->inta_pin, outbox,    QUERY_ADAPTER_INTA_PIN_OFFSET);
+
+	get_board_id(outbox + QUERY_ADAPTER_VSD_OFFSET / 4,
+		     adapter->board_id);
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	__be32 *inbox;
+	int err;
+
+#define INIT_HCA_IN_SIZE		 0x200
+#define INIT_HCA_VERSION_OFFSET		 0x000
+#define	 INIT_HCA_VERSION		 2
+#define INIT_HCA_FLAGS_OFFSET		 0x014
+#define INIT_HCA_QPC_OFFSET		 0x020
+#define	 INIT_HCA_QPC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x10)
+#define	 INIT_HCA_LOG_QP_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x17)
+#define	 INIT_HCA_SRQC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x28)
+#define	 INIT_HCA_LOG_SRQ_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x2f)
+#define	 INIT_HCA_CQC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x30)
+#define	 INIT_HCA_LOG_CQ_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x37)
+#define	 INIT_HCA_ALTC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x40)
+#define	 INIT_HCA_AUXC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x50)
+#define	 INIT_HCA_EQC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x60)
+#define	 INIT_HCA_LOG_EQ_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x67)
+#define	 INIT_HCA_RDMARC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x70)
+#define	 INIT_HCA_LOG_RD_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x77)
+#define INIT_HCA_MCAST_OFFSET		 0x0c0
+#define	 INIT_HCA_MC_BASE_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x00)
+#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x12)
+#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x16)
+#define	 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x1b)
+#define INIT_HCA_TPT_OFFSET		 0x0f0
+#define	 INIT_HCA_DMPT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x00)
+#define	 INIT_HCA_LOG_MPT_SZ_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x0b)
+#define	 INIT_HCA_MTT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x10)
+#define	 INIT_HCA_CMPT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x18)
+#define INIT_HCA_UAR_OFFSET		 0x120
+#define	 INIT_HCA_LOG_UAR_SZ_OFFSET	 (INIT_HCA_UAR_OFFSET + 0x0a)
+#define  INIT_HCA_UAR_PAGE_SZ_OFFSET     (INIT_HCA_UAR_OFFSET + 0x0b)
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	inbox = mailbox->buf;
+
+	memset(inbox, 0, INIT_HCA_IN_SIZE);
+
+	*((u8 *) mailbox->buf + INIT_HCA_VERSION_OFFSET) = INIT_HCA_VERSION;
+
+#if defined(__LITTLE_ENDIAN)
+	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) &= ~cpu_to_be32(1 << 1);
+#elif defined(__BIG_ENDIAN)
+	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 1);
+#else
+#error Host endianness not defined
+#endif
+	/* Check port for UD address vector: */
+	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1);
+
+	/* QPC/EEC/CQC/EQC/RDMARC attributes */
+
+	MLX4_PUT(inbox, param->qpc_base,      INIT_HCA_QPC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_num_qps,   INIT_HCA_LOG_QP_OFFSET);
+	MLX4_PUT(inbox, param->srqc_base,     INIT_HCA_SRQC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_num_srqs,  INIT_HCA_LOG_SRQ_OFFSET);
+	MLX4_PUT(inbox, param->cqc_base,      INIT_HCA_CQC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_num_cqs,   INIT_HCA_LOG_CQ_OFFSET);
+	MLX4_PUT(inbox, param->altc_base,     INIT_HCA_ALTC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->auxc_base,     INIT_HCA_AUXC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->eqc_base,      INIT_HCA_EQC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_num_eqs,   INIT_HCA_LOG_EQ_OFFSET);
+	MLX4_PUT(inbox, param->rdmarc_base,   INIT_HCA_RDMARC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_rd_per_qp, INIT_HCA_LOG_RD_OFFSET);
+
+	/* multicast attributes */
+
+	MLX4_PUT(inbox, param->mc_base,		INIT_HCA_MC_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_mc_entry_sz, INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET);
+	MLX4_PUT(inbox, param->log_mc_hash_sz,  INIT_HCA_LOG_MC_HASH_SZ_OFFSET);
+	MLX4_PUT(inbox, param->log_mc_table_sz, INIT_HCA_LOG_MC_TABLE_SZ_OFFSET);
+
+	/* TPT attributes */
+
+	MLX4_PUT(inbox, param->dmpt_base,  INIT_HCA_DMPT_BASE_OFFSET);
+	MLX4_PUT(inbox, param->log_mpt_sz, INIT_HCA_LOG_MPT_SZ_OFFSET);
+	MLX4_PUT(inbox, param->mtt_base,   INIT_HCA_MTT_BASE_OFFSET);
+	MLX4_PUT(inbox, param->cmpt_base,  INIT_HCA_CMPT_BASE_OFFSET);
+
+	/* UAR attributes */
+
+	MLX4_PUT(inbox, (u8) (PAGE_SHIFT - 12), INIT_HCA_UAR_PAGE_SZ_OFFSET);
+	MLX4_PUT(inbox, param->log_uar_sz,      INIT_HCA_LOG_UAR_SZ_OFFSET);
+
+	err = mlx4_cmd(dev, mailbox->dma, 0, 0, MLX4_CMD_INIT_HCA, 1000);
+
+	if (err)
+		mlx4_err(dev, "INIT_HCA returns %d\n", err);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mlx4_INIT_PORT(struct mlx4_dev *dev, struct mlx4_init_port_param *param, int port)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *inbox;
+	int err;
+	u32 flags;
+
+#define INIT_PORT_IN_SIZE          256
+#define INIT_PORT_FLAGS_OFFSET     0x00
+#define INIT_PORT_FLAG_SIG         (1 << 18)
+#define INIT_PORT_FLAG_NG          (1 << 17)
+#define INIT_PORT_FLAG_G0          (1 << 16)
+#define INIT_PORT_VL_SHIFT         4
+#define INIT_PORT_PORT_WIDTH_SHIFT 8
+#define INIT_PORT_MTU_OFFSET       0x04
+#define INIT_PORT_MAX_GID_OFFSET   0x06
+#define INIT_PORT_MAX_PKEY_OFFSET  0x0a
+#define INIT_PORT_GUID0_OFFSET     0x10
+#define INIT_PORT_NODE_GUID_OFFSET 0x18
+#define INIT_PORT_SI_GUID_OFFSET   0x20
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	inbox = mailbox->buf;
+
+	memset(inbox, 0, INIT_PORT_IN_SIZE);
+
+	flags = 0;
+	flags |= param->set_guid0     ? INIT_PORT_FLAG_G0  : 0;
+	flags |= param->set_node_guid ? INIT_PORT_FLAG_NG  : 0;
+	flags |= param->set_si_guid   ? INIT_PORT_FLAG_SIG : 0;
+	flags |= (param->vl_cap & 0xf) << INIT_PORT_VL_SHIFT;
+	flags |= (param->port_width_cap & 0xf) << INIT_PORT_PORT_WIDTH_SHIFT;
+	MLX4_PUT(inbox, flags,            INIT_PORT_FLAGS_OFFSET);
+
+	MLX4_PUT(inbox, param->mtu,       INIT_PORT_MTU_OFFSET);
+	MLX4_PUT(inbox, param->max_gid,   INIT_PORT_MAX_GID_OFFSET);
+	MLX4_PUT(inbox, param->max_pkey,  INIT_PORT_MAX_PKEY_OFFSET);
+	MLX4_PUT(inbox, param->guid0,     INIT_PORT_GUID0_OFFSET);
+	MLX4_PUT(inbox, param->node_guid, INIT_PORT_NODE_GUID_OFFSET);
+	MLX4_PUT(inbox, param->si_guid,   INIT_PORT_SI_GUID_OFFSET);
+
+	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_INIT_PORT,
+		       MLX4_CMD_TIME_CLASS_A);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_INIT_PORT);
+
+int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port)
+{
+	return mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT, 1000);
+}
+EXPORT_SYMBOL_GPL(mlx4_CLOSE_PORT);
+
+int mlx4_CLOSE_HCA(struct mlx4_dev *dev, int panic)
+{
+	return mlx4_cmd(dev, 0, 0, panic, MLX4_CMD_CLOSE_HCA, 1000);
+}
+
+int mlx4_SET_ICM_SIZE(struct mlx4_dev *dev, u64 icm_size, u64 *aux_pages)
+{
+	int ret = mlx4_cmd_imm(dev, icm_size, aux_pages, 0, 0,
+			       MLX4_CMD_SET_ICM_SIZE,
+			       MLX4_CMD_TIME_CLASS_A);
+	if (ret)
+		return ret;
+
+	/*
+	 * Round up number of system pages needed in case
+	 * MLX4_ICM_PAGE_SIZE < PAGE_SIZE.
+	 */
+	*aux_pages = ALIGN(*aux_pages, PAGE_SIZE / MLX4_ICM_PAGE_SIZE) >>
+		(PAGE_SHIFT - MLX4_ICM_PAGE_SHIFT);
+
+	return 0;
+}
+
+int mlx4_NOP(struct mlx4_dev *dev)
+{
+	/* Input modifier of 0x1f means "finish as soon as possible." */
+	return mlx4_cmd(dev, 0, 0x1f, 0, MLX4_CMD_NOP, 100);
+}
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
new file mode 100644
index 0000000..63cdd4e
--- /dev/null
+++ b/drivers/net/mlx4/fw.h
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 Cisco Systems.  All rights reserved.
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
+#ifndef MLX4_FW_H
+#define MLX4_FW_H
+
+#include "mlx4.h"
+#include "icm.h"
+
+struct mlx4_dev_cap {
+	int max_srq_sz;
+	int max_qp_sz;
+	int reserved_qps;
+	int max_qps;
+	int reserved_srqs;
+	int max_srqs;
+	int max_cq_sz;
+	int reserved_cqs;
+	int max_cqs;
+	int max_mpts;
+	int reserved_eqs;
+	int max_eqs;
+	int reserved_mtts;
+	int max_mrw_sz;
+	int reserved_mrws;
+	int max_mtt_seg;
+	int max_requester_per_qp;
+	int max_responder_per_qp;
+	int max_rdma_global;
+	int local_ca_ack_delay;
+	int max_mtu;
+	int max_port_width;
+	int max_vl;
+	int num_ports;
+	int max_gids;
+	u16 stat_rate_support;
+	int max_pkeys;
+	u32 flags;
+	int reserved_uars;
+	int uar_size;
+	int min_page_sz;
+	int max_sq_sg;
+	int max_sq_desc_sz;
+	int max_rq_sg;
+	int max_rq_desc_sz;
+	int max_qp_per_mcg;
+	int reserved_mgms;
+	int max_mcgs;
+	int reserved_pds;
+	int max_pds;
+	int qpc_entry_sz;
+	int rdmarc_entry_sz;
+	int altc_entry_sz;
+	int aux_entry_sz;
+	int srq_entry_sz;
+	int cqc_entry_sz;
+	int eqc_entry_sz;
+	int dmpt_entry_sz;
+	int cmpt_entry_sz;
+	int mtt_entry_sz;
+	int resize_srq;
+	u8  bmme_flags;
+	u32 reserved_lkey;
+	u64 max_icm_sz;
+};
+
+struct mlx4_adapter {
+	u32  vendor_id;
+	u32  device_id;
+	u32  revision_id;
+	char board_id[MLX4_BOARD_ID_LEN];
+	u8   inta_pin;
+};
+
+struct mlx4_init_hca_param {
+	u64 qpc_base;
+	u64 rdmarc_base;
+	u64 auxc_base;
+	u64 altc_base;
+	u64 srqc_base;
+	u64 cqc_base;
+	u64 eqc_base;
+	u64 mc_base;
+	u64 dmpt_base;
+	u64 cmpt_base;
+	u64 mtt_base;
+	u16 log_mc_entry_sz;
+	u16 log_mc_hash_sz;
+	u8  log_num_qps;
+	u8  log_num_srqs;
+	u8  log_num_cqs;
+	u8  log_num_eqs;
+	u8  log_rd_per_qp;
+	u8  log_mc_table_sz;
+	u8  log_mpt_sz;
+	u8  log_uar_sz;
+};
+
+struct mlx4_init_ib_param {
+	int port_width;
+	int vl_cap;
+	int mtu_cap;
+	u16 gid_cap;
+	u16 pkey_cap;
+	int set_guid0;
+	u64 guid0;
+	int set_node_guid;
+	u64 node_guid;
+	int set_si_guid;
+	u64 si_guid;
+};
+
+struct mlx4_set_ib_param {
+	int set_si_guid;
+	int reset_qkey_viol;
+	u64 si_guid;
+	u32 cap_mask;
+};
+
+int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap);
+int mlx4_MAP_FA(struct mlx4_dev *dev, struct mlx4_icm *icm);
+int mlx4_UNMAP_FA(struct mlx4_dev *dev);
+int mlx4_RUN_FW(struct mlx4_dev *dev);
+int mlx4_QUERY_FW(struct mlx4_dev *dev);
+int mlx4_QUERY_ADAPTER(struct mlx4_dev *dev, struct mlx4_adapter *adapter);
+int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param);
+int mlx4_CLOSE_HCA(struct mlx4_dev *dev, int panic);
+int mlx4_map_cmd(struct mlx4_dev *dev, u16 op, struct mlx4_icm *icm, u64 virt);
+int mlx4_SET_ICM_SIZE(struct mlx4_dev *dev, u64 icm_size, u64 *aux_pages);
+int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
+int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev);
+int mlx4_NOP(struct mlx4_dev *dev);
+
+#endif /* MLX4_FW_H */
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
new file mode 100644
index 0000000..a63cb8b
--- /dev/null
+++ b/drivers/net/mlx4/main.c
@@ -0,0 +1,939 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+
+#include <linux/mlx4/device.h>
+#include <linux/mlx4/doorbell.h>
+
+#include "mlx4.h"
+#include "fw.h"
+#include "icm.h"
+
+MODULE_AUTHOR("Roland Dreier");
+MODULE_DESCRIPTION("Mellanox ConnectX HCA low-level driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+
+#ifdef CONFIG_MLX4_DEBUG
+
+int mlx4_debug_level = 0;
+module_param_named(debug_level, mlx4_debug_level, int, 0644);
+MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
+
+#endif /* CONFIG_MLX4_DEBUG */
+
+#ifdef CONFIG_PCI_MSI
+
+static int msi_x = 0;
+module_param(msi_x, int, 0444);
+MODULE_PARM_DESC(msi_x, "attempt to use MSI-X if nonzero");
+
+#else /* CONFIG_PCI_MSI */
+
+#define msi_x (0)
+
+#endif /* CONFIG_PCI_MSI */
+
+static const char mlx4_version[] __devinitdata =
+	DRV_NAME ": Mellanox ConnectX core driver v"
+	DRV_VERSION " (" DRV_RELDATE ")\n";
+
+static struct mlx4_profile default_profile = {
+	.num_qp		= 1 << 16,
+	.num_srq	= 1 << 16,
+	.rdmarc_per_qp	= 4,
+	.num_cq		= 1 << 16,
+	.num_mcg	= 1 << 13,
+	.num_mpt	= 1 << 17,
+	.num_mtt	= 1 << 20,
+};
+
+static int __devinit mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
+{
+	int err;
+
+	err = mlx4_QUERY_DEV_CAP(dev, dev_cap);
+	if (err) {
+		mlx4_err(dev, "QUERY_DEV_CAP command failed, aborting.\n");
+		return err;
+	}
+
+	if (dev_cap->min_page_sz > PAGE_SIZE) {
+		mlx4_err(dev, "HCA minimum page size of %d bigger than "
+			 "kernel PAGE_SIZE of %ld, aborting.\n",
+			 dev_cap->min_page_sz, PAGE_SIZE);
+		return -ENODEV;
+	}
+	if (dev_cap->num_ports > MLX4_MAX_PORTS) {
+		mlx4_err(dev, "HCA has %d ports, but we only support %d, "
+			 "aborting.\n",
+			 dev_cap->num_ports, MLX4_MAX_PORTS);
+		return -ENODEV;
+	}
+
+	if (dev_cap->uar_size > pci_resource_len(dev->pdev, 2)) {
+		mlx4_err(dev, "HCA reported UAR size of 0x%x bigger than "
+			 "PCI resource 2 size of 0x%llx, aborting.\n",
+			 dev_cap->uar_size,
+			 (unsigned long long) pci_resource_len(dev->pdev, 2));
+		return -ENODEV;
+	}
+
+	dev->caps.num_ports          = dev_cap->num_ports;
+	dev->caps.num_uars	     = dev_cap->uar_size / PAGE_SIZE;
+	dev->caps.vl_cap             = dev_cap->max_vl;
+	dev->caps.mtu_cap            = dev_cap->max_mtu;
+	dev->caps.gid_table_len      = dev_cap->max_gids;
+	dev->caps.pkey_table_len     = dev_cap->max_pkeys;
+	dev->caps.local_ca_ack_delay = dev_cap->local_ca_ack_delay;
+	dev->caps.max_sq_sg          = dev_cap->max_sq_sg;
+	dev->caps.max_rq_sg          = dev_cap->max_rq_sg;
+	dev->caps.max_wqes           = dev_cap->max_qp_sz;
+	dev->caps.max_qp_init_rdma   = dev_cap->max_requester_per_qp;
+	dev->caps.reserved_qps       = dev_cap->reserved_qps;
+	dev->caps.max_srq_wqes       = dev_cap->max_srq_sz;
+	dev->caps.max_srq_sge        = dev_cap->max_rq_sg - 1;
+	dev->caps.reserved_srqs      = dev_cap->reserved_srqs;
+	dev->caps.max_sq_desc_sz     = dev_cap->max_sq_desc_sz;
+	dev->caps.max_rq_desc_sz     = dev_cap->max_rq_desc_sz;
+	/*
+	 * Subtract 1 from the limit because we need to allocate a
+	 * spare CQE so the HCA HW can tell the difference between an
+	 * empty CQ and a full CQ.
+	 */
+	dev->caps.max_cqes           = dev_cap->max_cq_sz - 1;
+	dev->caps.reserved_cqs       = dev_cap->reserved_cqs;
+	dev->caps.reserved_eqs       = dev_cap->reserved_eqs;
+	dev->caps.reserved_mtts      = dev_cap->reserved_mtts;
+	dev->caps.reserved_mrws      = dev_cap->reserved_mrws;
+	dev->caps.reserved_uars      = dev_cap->reserved_uars;
+	dev->caps.reserved_pds       = dev_cap->reserved_pds;
+	dev->caps.port_width_cap     = dev_cap->max_port_width;
+	dev->caps.mtt_entry_sz       = MLX4_MTT_ENTRY_PER_SEG * dev_cap->mtt_entry_sz;
+	dev->caps.page_size_cap      = ~(u32) (dev_cap->min_page_sz - 1);
+	dev->caps.flags              = dev_cap->flags;
+	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
+
+	return 0;
+}
+
+static int __devinit mlx4_load_fw(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+
+	priv->fw.fw_icm = mlx4_alloc_icm(dev, priv->fw.fw_pages,
+					 GFP_HIGHUSER | __GFP_NOWARN);
+	if (!priv->fw.fw_icm) {
+		mlx4_err(dev, "Couldn't allocate FW area, aborting.\n");
+		return -ENOMEM;
+	}
+
+	err = mlx4_MAP_FA(dev, priv->fw.fw_icm);
+	if (err) {
+		mlx4_err(dev, "MAP_FA command failed, aborting.\n");
+		goto err_free;
+	}
+
+	err = mlx4_RUN_FW(dev);
+	if (err) {
+		mlx4_err(dev, "RUN_FW command failed, aborting.\n");
+		goto err_unmap_fa;
+	}
+
+	return 0;
+
+err_unmap_fa:
+	mlx4_UNMAP_FA(dev);
+
+err_free:
+	mlx4_free_icm(dev, priv->fw.fw_icm);
+	return err;
+}
+
+static int __devinit mlx4_init_cmpt_table(struct mlx4_dev *dev, u64 cmpt_base,
+					  int cmpt_entry_sz)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+
+	err = mlx4_init_icm_table(dev, &priv->qp_table.cmpt_table,
+				  cmpt_base +
+				  ((u64) (MLX4_CMPT_TYPE_QP *
+					  cmpt_entry_sz) << MLX4_CMPT_SHIFT),
+				  cmpt_entry_sz, dev->caps.num_qps,
+				  dev->caps.reserved_qps, 0);
+	if (err)
+		goto err;
+
+	err = mlx4_init_icm_table(dev, &priv->srq_table.cmpt_table,
+				  cmpt_base +
+				  ((u64) (MLX4_CMPT_TYPE_SRQ *
+					  cmpt_entry_sz) << MLX4_CMPT_SHIFT),
+				  cmpt_entry_sz, dev->caps.num_srqs,
+				  dev->caps.reserved_srqs, 0);
+	if (err)
+		goto err_qp;
+
+	err = mlx4_init_icm_table(dev, &priv->cq_table.cmpt_table,
+				  cmpt_base +
+				  ((u64) (MLX4_CMPT_TYPE_CQ *
+					  cmpt_entry_sz) << MLX4_CMPT_SHIFT),
+				  cmpt_entry_sz, dev->caps.num_cqs,
+				  dev->caps.reserved_cqs, 0);
+	if (err)
+		goto err_srq;
+
+	err = mlx4_init_icm_table(dev, &priv->eq_table.cmpt_table,
+				  cmpt_base +
+				  ((u64) (MLX4_CMPT_TYPE_EQ *
+					  cmpt_entry_sz) << MLX4_CMPT_SHIFT),
+				  cmpt_entry_sz,
+				  roundup_pow_of_two(MLX4_NUM_EQ +
+						     dev->caps.reserved_eqs),
+				  MLX4_NUM_EQ + dev->caps.reserved_eqs, 0);
+	if (err)
+		goto err_cq;
+
+	return 0;
+
+err_cq:
+	mlx4_cleanup_icm_table(dev, &priv->cq_table.cmpt_table);
+
+err_srq:
+	mlx4_cleanup_icm_table(dev, &priv->srq_table.cmpt_table);
+
+err_qp:
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.cmpt_table);
+
+err:
+	return err;
+}
+
+static int __devinit mlx4_init_icm(struct mlx4_dev *dev,
+				   struct mlx4_dev_cap *dev_cap,
+				   struct mlx4_init_hca_param *init_hca,
+				   u64 icm_size)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	u64 aux_pages;
+	int err;
+
+	err = mlx4_SET_ICM_SIZE(dev, icm_size, &aux_pages);
+	if (err) {
+		mlx4_err(dev, "SET_ICM_SIZE command failed, aborting.\n");
+		return err;
+	}
+
+	mlx4_dbg(dev, "%lld KB of HCA context requires %lld KB aux memory.\n",
+		 (unsigned long long) icm_size >> 10,
+		 (unsigned long long) aux_pages << 2);
+
+	priv->fw.aux_icm = mlx4_alloc_icm(dev, aux_pages,
+					  GFP_HIGHUSER | __GFP_NOWARN);
+	if (!priv->fw.aux_icm) {
+		mlx4_err(dev, "Couldn't allocate aux memory, aborting.\n");
+		return -ENOMEM;
+	}
+
+	err = mlx4_MAP_ICM_AUX(dev, priv->fw.aux_icm);
+	if (err) {
+		mlx4_err(dev, "MAP_ICM_AUX command failed, aborting.\n");
+		goto err_free_aux;
+	}
+
+	err = mlx4_init_cmpt_table(dev, init_hca->cmpt_base, dev_cap->cmpt_entry_sz);
+	if (err) {
+		mlx4_err(dev, "Failed to map cMPT context memory, aborting.\n");
+		goto err_unmap_aux;
+	}
+
+	err = mlx4_map_eq_icm(dev, init_hca->eqc_base);
+	if (err) {
+		mlx4_err(dev, "Failed to map EQ context memory, aborting.\n");
+		goto err_unmap_cmpt;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->mr_table.mtt_table,
+				  init_hca->mtt_base,
+				  dev->caps.mtt_entry_sz,
+				  dev->caps.num_mtt_segs,
+				  dev->caps.reserved_mtts, 1);
+	if (err) {
+		mlx4_err(dev, "Failed to map MTT context memory, aborting.\n");
+		goto err_unmap_eq;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->mr_table.dmpt_table,
+				  init_hca->dmpt_base,
+				  dev_cap->dmpt_entry_sz,
+				  dev->caps.num_mpts,
+				  dev->caps.reserved_mrws, 1);
+	if (err) {
+		mlx4_err(dev, "Failed to map dMPT context memory, aborting.\n");
+		goto err_unmap_mtt;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->qp_table.qp_table,
+				  init_hca->qpc_base,
+				  dev_cap->qpc_entry_sz,
+				  dev->caps.num_qps,
+				  dev->caps.reserved_qps, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map QP context memory, aborting.\n");
+		goto err_unmap_dmpt;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->qp_table.auxc_table,
+				  init_hca->auxc_base,
+				  dev_cap->aux_entry_sz,
+				  dev->caps.num_qps,
+				  dev->caps.reserved_qps, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map AUXC context memory, aborting.\n");
+		goto err_unmap_qp;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->qp_table.altc_table,
+				  init_hca->altc_base,
+				  dev_cap->altc_entry_sz,
+				  dev->caps.num_qps,
+				  dev->caps.reserved_qps, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map ALTC context memory, aborting.\n");
+		goto err_unmap_auxc;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->qp_table.rdmarc_table,
+				  init_hca->rdmarc_base,
+				  dev_cap->rdmarc_entry_sz << priv->qp_table.rdmarc_shift,
+				  dev->caps.num_qps,
+				  dev->caps.reserved_qps, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map RDMARC context memory, aborting\n");
+		goto err_unmap_altc;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->cq_table.table,
+				  init_hca->cqc_base,
+				  dev_cap->cqc_entry_sz,
+				  dev->caps.num_cqs,
+				  dev->caps.reserved_cqs, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map CQ context memory, aborting.\n");
+		goto err_unmap_rdmarc;
+	}
+
+	err = mlx4_init_icm_table(dev, &priv->srq_table.table,
+				  init_hca->srqc_base,
+				  dev_cap->srq_entry_sz,
+				  dev->caps.num_srqs,
+				  dev->caps.reserved_srqs, 0);
+	if (err) {
+		mlx4_err(dev, "Failed to map SRQ context memory, aborting.\n");
+		goto err_unmap_cq;
+	}
+
+	/*
+	 * It's not strictly required, but for simplicity just map the
+	 * whole multicast group table now.  The table isn't very big
+	 * and it's a lot easier than trying to track ref counts.
+	 */
+	err = mlx4_init_icm_table(dev, &priv->mcg_table.table,
+				  init_hca->mc_base, MLX4_MGM_ENTRY_SIZE,
+				  dev->caps.num_mgms + dev->caps.num_amgms,
+				  dev->caps.num_mgms + dev->caps.num_amgms,
+				  0);
+	if (err) {
+		mlx4_err(dev, "Failed to map MCG context memory, aborting.\n");
+		goto err_unmap_srq;
+	}
+
+	return 0;
+
+err_unmap_srq:
+	mlx4_cleanup_icm_table(dev, &priv->srq_table.table);
+
+err_unmap_cq:
+	mlx4_cleanup_icm_table(dev, &priv->cq_table.table);
+
+err_unmap_rdmarc:
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.rdmarc_table);
+
+err_unmap_altc:
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.altc_table);
+
+err_unmap_auxc:
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.auxc_table);
+
+err_unmap_qp:
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.qp_table);
+
+err_unmap_dmpt:
+	mlx4_cleanup_icm_table(dev, &priv->mr_table.dmpt_table);
+
+err_unmap_mtt:
+	mlx4_cleanup_icm_table(dev, &priv->mr_table.mtt_table);
+
+err_unmap_eq:
+	mlx4_unmap_eq_icm(dev);
+
+err_unmap_cmpt:
+	mlx4_cleanup_icm_table(dev, &priv->eq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->cq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->srq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.cmpt_table);
+
+err_unmap_aux:
+	mlx4_UNMAP_ICM_AUX(dev);
+
+err_free_aux:
+	mlx4_free_icm(dev, priv->fw.aux_icm);
+
+	return err;
+}
+
+static void mlx4_free_icms(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	mlx4_cleanup_icm_table(dev, &priv->mcg_table.table);
+	mlx4_cleanup_icm_table(dev, &priv->srq_table.table);
+	mlx4_cleanup_icm_table(dev, &priv->cq_table.table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.rdmarc_table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.altc_table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.auxc_table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.qp_table);
+	mlx4_cleanup_icm_table(dev, &priv->mr_table.dmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->mr_table.mtt_table);
+	mlx4_cleanup_icm_table(dev, &priv->eq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->cq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->srq_table.cmpt_table);
+	mlx4_cleanup_icm_table(dev, &priv->qp_table.cmpt_table);
+	mlx4_unmap_eq_icm(dev);
+
+	mlx4_UNMAP_ICM_AUX(dev);
+	mlx4_free_icm(dev, priv->fw.aux_icm);
+}
+
+static void mlx4_close_hca(struct mlx4_dev *dev)
+{
+	mlx4_CLOSE_HCA(dev, 0);
+	mlx4_free_icms(dev);
+	mlx4_UNMAP_FA(dev);
+	mlx4_free_icm(dev, mlx4_priv(dev)->fw.fw_icm);
+}
+
+static int __devinit mlx4_init_hca(struct mlx4_dev *dev)
+{
+	struct mlx4_priv          *priv = mlx4_priv(dev);
+	struct mlx4_adapter        adapter;
+	struct mlx4_dev_cap        dev_cap;
+	struct mlx4_profile        profile;
+	struct mlx4_init_hca_param init_hca;
+	u64 icm_size;
+	int err;
+
+	err = mlx4_QUERY_FW(dev);
+	if (err) {
+		mlx4_err(dev, "QUERY_FW command failed, aborting.\n");
+		return err;
+	}
+
+	err = mlx4_load_fw(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to start FW, aborting.\n");
+		return err;
+	}
+
+	err = mlx4_dev_cap(dev, &dev_cap);
+	if (err) {
+		mlx4_err(dev, "QUERY_DEV_CAP command failed, aborting.\n");
+		goto err_stop_fw;
+	}
+
+	profile = default_profile;
+
+	icm_size = mlx4_make_profile(dev, &profile, &dev_cap, &init_hca);
+	if ((long long) icm_size < 0) {
+		err = icm_size;
+		goto err_stop_fw;
+	}
+
+	init_hca.log_uar_sz = ilog2(dev->caps.num_uars);
+
+	err = mlx4_init_icm(dev, &dev_cap, &init_hca, icm_size);
+	if (err)
+		goto err_stop_fw;
+
+	err = mlx4_INIT_HCA(dev, &init_hca);
+	if (err) {
+		mlx4_err(dev, "INIT_HCA command failed, aborting.\n");
+		goto err_free_icm;
+	}
+
+	err = mlx4_QUERY_ADAPTER(dev, &adapter);
+	if (err) {
+		mlx4_err(dev, "QUERY_ADAPTER command failed, aborting.\n");
+		goto err_close;
+	}
+
+	priv->eq_table.inta_pin = adapter.inta_pin;
+	priv->rev_id            = adapter.revision_id;
+	memcpy(priv->board_id, adapter.board_id, sizeof priv->board_id);
+
+	return 0;
+
+err_close:
+	mlx4_close_hca(dev);
+
+err_free_icm:
+	mlx4_free_icms(dev);
+
+err_stop_fw:
+	mlx4_UNMAP_FA(dev);
+	mlx4_free_icm(dev, priv->fw.fw_icm);
+
+	return err;
+}
+
+static int __devinit mlx4_setup_hca(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+
+	MLX4_INIT_DOORBELL_LOCK(&priv->doorbell_lock);
+
+	err = mlx4_init_uar_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "user access region table, aborting.\n");
+		return err;
+	}
+
+	err = mlx4_uar_alloc(dev, &priv->driver_uar);
+	if (err) {
+		mlx4_err(dev, "Failed to allocate driver access region, "
+			 "aborting.\n");
+		goto err_uar_table_free;
+	}
+
+	priv->kar = ioremap(priv->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!priv->kar) {
+		mlx4_err(dev, "Couldn't map kernel access region, "
+			 "aborting.\n");
+		err = -ENOMEM;
+		goto err_uar_free;
+	}
+
+	err = mlx4_init_pd_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "protection domain table, aborting.\n");
+		goto err_kar_unmap;
+	}
+
+	err = mlx4_init_mr_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "memory region table, aborting.\n");
+		goto err_pd_table_free;
+	}
+
+	err = mlx4_pd_alloc(dev, &priv->driver_pd);
+	if (err) {
+		mlx4_err(dev, "Failed to create driver PD, "
+			 "aborting.\n");
+		goto err_mr_table_free;
+	}
+
+	err = mlx4_init_eq_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "event queue table, aborting.\n");
+		goto err_pd_free;
+	}
+
+	err = mlx4_cmd_use_events(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to switch to event-driven "
+			 "firmware commands, aborting.\n");
+		goto err_eq_table_free;
+	}
+
+	err = mlx4_NOP(dev);
+	if (err) {
+		mlx4_err(dev, "NOP command failed to generate interrupt (IRQ %d), aborting.\n",
+			 priv->eq_table.eq[MLX4_EQ_ASYNC].irq);
+		if (dev->flags & MLX4_FLAG_MSI_X)
+			mlx4_err(dev, "Try again with MSI-X disabled.\n");
+		else
+			mlx4_err(dev, "BIOS or ACPI interrupt routing problem?\n");
+
+		goto err_cmd_poll;
+	}
+
+	mlx4_dbg(dev, "NOP command IRQ test passed\n");
+
+	err = mlx4_init_cq_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "completion queue table, aborting.\n");
+		goto err_cmd_poll;
+	}
+
+	err = mlx4_init_srq_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "shared receive queue table, aborting.\n");
+		goto err_cq_table_free;
+	}
+
+	err = mlx4_init_qp_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "queue pair table, aborting.\n");
+		goto err_srq_table_free;
+	}
+
+	err = mlx4_init_mcg_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "multicast group table, aborting.\n");
+		goto err_qp_table_free;
+	}
+
+	return 0;
+
+err_qp_table_free:
+	mlx4_cleanup_qp_table(dev);
+
+err_srq_table_free:
+	mlx4_cleanup_srq_table(dev);
+
+err_cq_table_free:
+	mlx4_cleanup_cq_table(dev);
+
+err_cmd_poll:
+	mlx4_cmd_use_polling(dev);
+
+err_eq_table_free:
+	mlx4_cleanup_eq_table(dev);
+
+err_pd_free:
+	mlx4_pd_free(dev, priv->driver_pd);
+
+err_mr_table_free:
+	mlx4_cleanup_mr_table(dev);
+
+err_pd_table_free:
+	mlx4_cleanup_pd_table(dev);
+
+err_kar_unmap:
+	iounmap(priv->kar);
+
+err_uar_free:
+	mlx4_uar_free(dev, &priv->driver_uar);
+
+err_uar_table_free:
+	mlx4_cleanup_uar_table(dev);
+	return err;
+}
+
+static void __devinit mlx4_enable_msi_x(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct msix_entry entries[MLX4_NUM_EQ];
+	int err;
+	int i;
+
+	if (msi_x) {
+		for (i = 0; i < MLX4_NUM_EQ; ++i)
+			entries[i].entry = i;
+
+		err = pci_enable_msix(dev->pdev, entries, ARRAY_SIZE(entries));
+		if (err) {
+			if (err > 0)
+				mlx4_info(dev, "Only %d MSI-X vectors available, "
+					  "not using MSI-X\n", err);
+			goto no_msi;
+		}
+
+		for (i = 0; i < MLX4_NUM_EQ; ++i)
+			priv->eq_table.eq[i].irq = entries[i].vector;
+
+		dev->flags |= MLX4_FLAG_MSI_X;
+		return;
+	}
+
+no_msi:
+	for (i = 0; i < MLX4_NUM_EQ; ++i)
+		priv->eq_table.eq[i].irq = dev->pdev->irq;
+}
+
+static int __devinit mlx4_init_one(struct pci_dev *pdev,
+				   const struct pci_device_id *id)
+{
+	static int mlx4_version_printed = 0;
+	struct mlx4_priv *priv;
+	struct mlx4_dev *dev;
+	int err;
+
+	if (!mlx4_version_printed) {
+		printk(KERN_INFO "%s", mlx4_version);
+		++mlx4_version_printed;
+	}
+
+	printk(KERN_INFO PFX "Initializing %s\n",
+	       pci_name(pdev));
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot enable PCI device, "
+			"aborting.\n");
+		return err;
+	}
+
+	/*
+	 * Check for BARs.  We expect 0: 1MB, 2: 8MB, 4: DDR (may not
+	 * be present)
+	 */
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
+	    pci_resource_len(pdev, 0) != 1 << 20) {
+		dev_err(&pdev->dev, "Missing DCS, aborting.\n");
+		err = -ENODEV;
+		goto err_disable_pdev;
+	}
+	if (!(pci_resource_flags(pdev, 2) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "Missing UAR, aborting.\n");
+		err = -ENODEV;
+		goto err_disable_pdev;
+	}
+
+	err = pci_request_region(pdev, 0, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot request control region, aborting.\n");
+		goto err_disable_pdev;
+	}
+
+	err = pci_request_region(pdev, 2, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot request UAR region, aborting.\n");
+		goto err_release_bar0;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
+		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (err) {
+			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting.\n");
+			goto err_release_bar2;
+		}
+	}
+	err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
+			 "consistent PCI DMA mask.\n");
+		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (err) {
+			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, "
+				"aborting.\n");
+			goto err_release_bar2;
+		}
+	}
+
+	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "Device struct alloc failed, "
+			"aborting.\n");
+		err = -ENOMEM;
+		goto err_release_bar2;
+	}
+
+	dev       = &priv->dev;
+	dev->pdev = pdev;
+
+	/*
+	 * Now reset the HCA before we touch the PCI capabilities or
+	 * attempt a firmware command, since a boot ROM may have left
+	 * the HCA in an undefined state.
+	 */
+	err = mlx4_reset(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to reset HCA, aborting.\n");
+		goto err_free_dev;
+	}
+
+	mlx4_enable_msi_x(dev);
+
+	if (mlx4_cmd_init(dev)) {
+		mlx4_err(dev, "Failed to init command interface, aborting.\n");
+		goto err_free_dev;
+	}
+
+	err = mlx4_init_hca(dev);
+	if (err)
+		goto err_cmd;
+
+	err = mlx4_setup_hca(dev);
+	if (err)
+		goto err_close;
+
+	err = mlx4_register_device(priv);
+	if (err)
+		goto err_cleanup;
+
+	pci_set_drvdata(pdev, dev);
+
+	return 0;
+
+err_cleanup:
+	mlx4_cleanup_mcg_table(dev);
+	mlx4_cleanup_qp_table(dev);
+	mlx4_cleanup_srq_table(dev);
+	mlx4_cleanup_cq_table(dev);
+	mlx4_cmd_use_polling(dev);
+	mlx4_cleanup_eq_table(dev);
+
+	mlx4_pd_free(dev, priv->driver_pd);
+
+	mlx4_cleanup_mr_table(dev);
+	mlx4_cleanup_pd_table(dev);
+	mlx4_cleanup_uar_table(dev);
+
+err_close:
+	mlx4_close_hca(dev);
+
+err_cmd:
+	mlx4_cmd_cleanup(dev);
+
+err_free_dev:
+	if (dev->flags & MLX4_FLAG_MSI_X)
+		pci_disable_msix(pdev);
+
+	kfree(priv);
+
+err_release_bar2:
+	pci_release_region(pdev, 2);
+
+err_release_bar0:
+	pci_release_region(pdev, 0);
+
+err_disable_pdev:
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	return err;
+}
+
+static void __devexit mlx4_remove_one(struct pci_dev *pdev)
+{
+	struct mlx4_dev  *dev  = pci_get_drvdata(pdev);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int p;
+
+	if (dev) {
+		mlx4_unregister_device(priv);
+
+		for (p = 1; p <= dev->caps.num_ports; ++p)
+			mlx4_CLOSE_PORT(dev, p);
+
+		mlx4_cleanup_mcg_table(dev);
+		mlx4_cleanup_qp_table(dev);
+		mlx4_cleanup_srq_table(dev);
+		mlx4_cleanup_cq_table(dev);
+		mlx4_cmd_use_polling(dev);
+		mlx4_cleanup_eq_table(dev);
+
+		mlx4_pd_free(dev, priv->driver_pd);
+
+		mlx4_cleanup_mr_table(dev);
+		mlx4_cleanup_pd_table(dev);
+
+		iounmap(priv->kar);
+		mlx4_uar_free(dev, &priv->driver_uar);
+		mlx4_cleanup_uar_table(dev);
+		mlx4_close_hca(dev);
+		mlx4_cmd_cleanup(dev);
+
+		if (dev->flags & MLX4_FLAG_MSI_X)
+			pci_disable_msix(pdev);
+
+		kfree(priv);
+		pci_release_region(pdev, 2);
+		pci_release_region(pdev, 0);
+		pci_disable_device(pdev);
+		pci_set_drvdata(pdev, NULL);
+	}
+}
+
+static struct pci_device_id mlx4_pci_table[] = {
+	{ PCI_VDEVICE(MELLANOX, 0x6340) }, /* MT25408 "Hermon" SDR */
+	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25408 "Hermon" DDR */
+	{ PCI_VDEVICE(MELLANOX, 0x6354) }, /* MT25408 "Hermon" QDR */
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mlx4_pci_table);
+
+static struct pci_driver mlx4_driver = {
+	.name		= DRV_NAME,
+	.id_table	= mlx4_pci_table,
+	.probe		= mlx4_init_one,
+	.remove		= __devexit_p(mlx4_remove_one)
+};
+
+static int __init mlx4_init(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&mlx4_driver);
+	return ret < 0 ? ret : 0;
+}
+
+static void __exit mlx4_cleanup(void)
+{
+	pci_unregister_driver(&mlx4_driver);
+}
+
+module_init(mlx4_init);
+module_exit(mlx4_cleanup);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
new file mode 100644
index 0000000..5f4d9c6
--- /dev/null
+++ b/drivers/net/mlx4/mlx4.h
@@ -0,0 +1,334 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005, 2006, 2007 Cisco Systems.  All rights reserved.
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
+#ifndef MLX4_H
+#define MLX4_H
+
+#include <linux/radix-tree.h>
+
+#include <linux/mlx4/device.h>
+#include <linux/mlx4/doorbell.h>
+
+#define DRV_NAME	"mlx4_core"
+#define PFX		DRV_NAME ": "
+#define DRV_VERSION	"0.01"
+#define DRV_RELDATE	"May 1, 2006"
+
+enum {
+	MLX4_HCR_BASE		= 0x80680,
+	MLX4_HCR_SIZE		= 0x0001c,
+	MLX4_CLR_INT_SIZE	= 0x00008
+};
+
+enum {
+	MLX4_BOARD_ID_LEN	= 64
+};
+
+enum {
+	MLX4_MGM_ENTRY_SIZE	=  0x40,
+	MLX4_QP_PER_MGM		= 4 * (MLX4_MGM_ENTRY_SIZE / 16 - 2),
+	MLX4_MTT_ENTRY_PER_SEG	= 8
+};
+
+enum {
+	MLX4_EQ_ASYNC,
+	MLX4_EQ_COMP,
+	MLX4_EQ_CATAS,
+	MLX4_NUM_EQ
+};
+
+enum {
+	MLX4_NUM_PDS		= 1 << 15
+};
+
+enum {
+	MLX4_CMPT_TYPE_QP	= 0,
+	MLX4_CMPT_TYPE_SRQ	= 1,
+	MLX4_CMPT_TYPE_CQ	= 2,
+	MLX4_CMPT_TYPE_EQ	= 3,
+	MLX4_CMPT_NUM_TYPE
+};
+
+enum {
+	MLX4_CMPT_SHIFT		= 24,
+	MLX4_NUM_CMPTS		= MLX4_CMPT_NUM_TYPE << MLX4_CMPT_SHIFT
+};
+
+#ifdef CONFIG_MLX4_DEBUG
+extern int mlx4_debug_level;
+
+#define mlx4_dbg(mdev, format, arg...)					\
+	do {								\
+		if (mlx4_debug_level)					\
+			dev_printk(KERN_DEBUG, &mdev->pdev->dev, format, ## arg); \
+	} while (0)
+
+#else /* CONFIG_MLX4_DEBUG */
+
+#define mlx4_dbg(mdev, format, arg...) do { (void) mdev; } while (0)
+
+#endif /* CONFIG_MLX4_DEBUG */
+
+#define mlx4_err(mdev, format, arg...) \
+	dev_err(&mdev->pdev->dev, format, ## arg)
+#define mlx4_info(mdev, format, arg...) \
+	dev_info(&mdev->pdev->dev, format, ## arg)
+#define mlx4_warn(mdev, format, arg...) \
+	dev_warn(&mdev->pdev->dev, format, ## arg)
+
+struct mlx4_bitmap {
+	u32			last;
+	u32			top;
+	u32			max;
+	u32			mask;
+	spinlock_t		lock;
+	unsigned long	       *table;
+};
+
+struct mlx4_buddy {
+	unsigned long	      **bits;
+	int			max_order;
+	spinlock_t		lock;
+};
+
+struct mlx4_icm;
+
+struct mlx4_icm_table {
+	u64			virt;
+	int			num_icm;
+	int			num_obj;
+	int			obj_size;
+	int			lowmem;
+	struct mutex		mutex;
+	struct mlx4_icm	      **icm;
+};
+
+struct mlx4_eq {
+	struct mlx4_dev	       *dev;
+	void __iomem	       *doorbell;
+	int			eqn;
+	u32			cons_index;
+	u16			irq;
+	u16			have_irq;
+	int			nent;
+	struct mlx4_buf_list   *page_list;
+	struct mlx4_mtt		mtt;
+};
+
+struct mlx4_profile {
+	int			num_qp;
+	int			rdmarc_per_qp;
+	int			num_srq;
+	int			num_cq;
+	int			num_mcg;
+	int			num_mpt;
+	int			num_mtt;
+};
+
+struct mlx4_fw {
+	u64			clr_int_base;
+	u64			catas_addr;
+	struct mlx4_icm	       *fw_icm;
+	struct mlx4_icm	       *aux_icm;
+	u32			catas_size;
+	u16			fw_pages;
+	u8			clr_int_bar;
+	u8			catas_bar;
+};
+
+struct mlx4_cmd {
+	struct pci_pool	       *pool;
+	void __iomem	       *hcr;
+	struct mutex		hcr_mutex;
+	struct semaphore	poll_sem;
+	struct semaphore	event_sem;
+	int			max_cmds;
+	spinlock_t		context_lock;
+	int			free_head;
+	struct mlx4_cmd_context *context;
+	u16			token_mask;
+	u8			use_events;
+	u8			toggle;
+};
+
+struct mlx4_uar_table {
+	struct mlx4_bitmap	bitmap;
+};
+
+struct mlx4_mr_table {
+	struct mlx4_bitmap	mpt_bitmap;
+	struct mlx4_buddy	mtt_buddy;
+	u64			mtt_base;
+	u64			mpt_base;
+	struct mlx4_icm_table	mtt_table;
+	struct mlx4_icm_table	dmpt_table;
+};
+
+struct mlx4_cq_table {
+	struct mlx4_bitmap	bitmap;
+	spinlock_t		lock;
+	struct radix_tree_root	tree;
+	struct mlx4_icm_table	table;
+	struct mlx4_icm_table	cmpt_table;
+};
+
+struct mlx4_eq_table {
+	struct mlx4_bitmap	bitmap;
+	void __iomem	       *clr_int;
+	void __iomem	       *uar_map[(MLX4_NUM_EQ + 6) / 4];
+	u32			clr_mask;
+	struct mlx4_eq		eq[MLX4_NUM_EQ];
+	u64			icm_virt;
+	struct page	       *icm_page;
+	dma_addr_t		icm_dma;
+	struct mlx4_icm_table	cmpt_table;
+	int			have_irq;
+	u8			inta_pin;
+};
+
+struct mlx4_srq_table {
+	struct mlx4_bitmap	bitmap;
+	spinlock_t		lock;
+	struct radix_tree_root	tree;
+	struct mlx4_icm_table	table;
+	struct mlx4_icm_table	cmpt_table;
+};
+
+struct mlx4_qp_table {
+	struct mlx4_bitmap	bitmap;
+	u32			rdmarc_base;
+	int			rdmarc_shift;
+	spinlock_t		lock;
+	struct mlx4_icm_table	qp_table;
+	struct mlx4_icm_table	auxc_table;
+	struct mlx4_icm_table	altc_table;
+	struct mlx4_icm_table	rdmarc_table;
+	struct mlx4_icm_table	cmpt_table;
+};
+
+struct mlx4_mcg_table {
+	struct mutex		mutex;
+	struct mlx4_bitmap	bitmap;
+	struct mlx4_icm_table	table;
+};
+
+struct mlx4_priv {
+	struct mlx4_dev		dev;
+
+	struct list_head	dev_list;
+	struct list_head	ctx_list;
+
+	struct mlx4_fw		fw;
+	struct mlx4_cmd		cmd;
+
+	struct mlx4_bitmap	pd_bitmap;
+	struct mlx4_uar_table	uar_table;
+	struct mlx4_mr_table	mr_table;
+	struct mlx4_cq_table	cq_table;
+	struct mlx4_eq_table	eq_table;
+	struct mlx4_srq_table	srq_table;
+	struct mlx4_qp_table	qp_table;
+	struct mlx4_mcg_table	mcg_table;
+
+	void __iomem	       *clr_base;
+
+	struct mlx4_uar		driver_uar;
+	void __iomem	       *kar;
+	MLX4_DECLARE_DOORBELL_LOCK(doorbell_lock)
+	u32			driver_pd;
+
+	u32			rev_id;
+	char			board_id[MLX4_BOARD_ID_LEN];
+};
+
+static inline struct mlx4_priv *mlx4_priv(struct mlx4_dev *dev)
+{
+	return container_of(dev, struct mlx4_priv, dev);
+}
+
+u32 mlx4_bitmap_alloc(struct mlx4_bitmap *bitmap);
+void mlx4_bitmap_free(struct mlx4_bitmap *bitmap, u32 obj);
+int mlx4_bitmap_init(struct mlx4_bitmap *bitmap, u32 num, u32 mask, u32 reserved);
+void mlx4_bitmap_cleanup(struct mlx4_bitmap *bitmap);
+
+int mlx4_reset(struct mlx4_dev *dev);
+
+int mlx4_init_pd_table(struct mlx4_dev *dev);
+int mlx4_init_uar_table(struct mlx4_dev *dev);
+int mlx4_init_mr_table(struct mlx4_dev *dev);
+int mlx4_init_eq_table(struct mlx4_dev *dev);
+int mlx4_init_cq_table(struct mlx4_dev *dev);
+int mlx4_init_qp_table(struct mlx4_dev *dev);
+int mlx4_init_srq_table(struct mlx4_dev *dev);
+int mlx4_init_mcg_table(struct mlx4_dev *dev);
+
+void mlx4_cleanup_pd_table(struct mlx4_dev *dev);
+void mlx4_cleanup_uar_table(struct mlx4_dev *dev);
+void mlx4_cleanup_mr_table(struct mlx4_dev *dev);
+void mlx4_cleanup_eq_table(struct mlx4_dev *dev);
+void mlx4_cleanup_cq_table(struct mlx4_dev *dev);
+void mlx4_cleanup_qp_table(struct mlx4_dev *dev);
+void mlx4_cleanup_srq_table(struct mlx4_dev *dev);
+void mlx4_cleanup_mcg_table(struct mlx4_dev *dev);
+
+int mlx4_register_device(struct mlx4_priv *priv);
+void mlx4_unregister_device(struct mlx4_priv *priv);
+
+struct mlx4_dev_cap;
+struct mlx4_init_hca_param;
+
+u64 mlx4_make_profile(struct mlx4_dev *dev,
+		      struct mlx4_profile *request,
+		      struct mlx4_dev_cap *dev_cap,
+		      struct mlx4_init_hca_param *init_hca);
+
+int mlx4_map_eq_icm(struct mlx4_dev *dev, u64 icm_virt);
+void mlx4_unmap_eq_icm(struct mlx4_dev *dev);
+
+int mlx4_cmd_init(struct mlx4_dev *dev);
+void mlx4_cmd_cleanup(struct mlx4_dev *dev);
+void mlx4_cmd_event(struct mlx4_dev *dev, u16 token, u8 status, u64 out_param);
+int mlx4_cmd_use_events(struct mlx4_dev *dev);
+void mlx4_cmd_use_polling(struct mlx4_dev *dev);
+
+void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn);
+void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type);
+
+void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type);
+
+void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type);
+
+#endif /* MLX4_H */
diff --git a/drivers/net/mlx4/profile.c b/drivers/net/mlx4/profile.c
new file mode 100644
index 0000000..3a5446f
--- /dev/null
+++ b/drivers/net/mlx4/profile.c
@@ -0,0 +1,238 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
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
+#include "mlx4.h"
+#include "fw.h"
+
+enum {
+	MLX4_RES_QP,
+	MLX4_RES_RDMARC,
+	MLX4_RES_ALTC,
+	MLX4_RES_AUXC,
+	MLX4_RES_SRQ,
+	MLX4_RES_CQ,
+	MLX4_RES_EQ,
+	MLX4_RES_DMPT,
+	MLX4_RES_CMPT,
+	MLX4_RES_MTT,
+	MLX4_RES_MCG,
+	MLX4_RES_NUM
+};
+
+static const char *res_name[] = {
+	[MLX4_RES_QP]		= "QP",
+	[MLX4_RES_RDMARC]	= "RDMARC",
+	[MLX4_RES_ALTC]		= "ALTC",
+	[MLX4_RES_AUXC]		= "AUXC",
+	[MLX4_RES_SRQ]		= "SRQ",
+	[MLX4_RES_CQ]		= "CQ",
+	[MLX4_RES_EQ]		= "EQ",
+	[MLX4_RES_DMPT]		= "DMPT",
+	[MLX4_RES_CMPT]		= "CMPT",
+	[MLX4_RES_MTT]		= "MTT",
+	[MLX4_RES_MCG]		= "MCG",
+};
+
+u64 mlx4_make_profile(struct mlx4_dev *dev,
+		      struct mlx4_profile *request,
+		      struct mlx4_dev_cap *dev_cap,
+		      struct mlx4_init_hca_param *init_hca)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_resource {
+		u64 size;
+		u64 start;
+		int type;
+		int num;
+		int log_num;
+	};
+
+	u64 total_size = 0;
+	struct mlx4_resource *profile;
+	struct mlx4_resource tmp;
+	int i, j;
+
+	profile = kzalloc(MLX4_RES_NUM * sizeof *profile, GFP_KERNEL);
+	if (!profile)
+		return -ENOMEM;
+
+	profile[MLX4_RES_QP].size     = dev_cap->qpc_entry_sz;
+	profile[MLX4_RES_RDMARC].size = dev_cap->rdmarc_entry_sz;
+	profile[MLX4_RES_ALTC].size   = dev_cap->altc_entry_sz;
+	profile[MLX4_RES_AUXC].size   = dev_cap->aux_entry_sz;
+	profile[MLX4_RES_SRQ].size    = dev_cap->srq_entry_sz;
+	profile[MLX4_RES_CQ].size     = dev_cap->cqc_entry_sz;
+	profile[MLX4_RES_EQ].size     = dev_cap->eqc_entry_sz;
+	profile[MLX4_RES_DMPT].size   = dev_cap->dmpt_entry_sz;
+	profile[MLX4_RES_CMPT].size   = dev_cap->cmpt_entry_sz;
+	profile[MLX4_RES_MTT].size    = MLX4_MTT_ENTRY_PER_SEG * dev_cap->mtt_entry_sz;
+	profile[MLX4_RES_MCG].size    = MLX4_MGM_ENTRY_SIZE;
+
+	profile[MLX4_RES_QP].num      = request->num_qp;
+	profile[MLX4_RES_RDMARC].num  = request->num_qp * request->rdmarc_per_qp;
+	profile[MLX4_RES_ALTC].num    = request->num_qp;
+	profile[MLX4_RES_AUXC].num    = request->num_qp;
+	profile[MLX4_RES_SRQ].num     = request->num_srq;
+	profile[MLX4_RES_CQ].num      = request->num_cq;
+	profile[MLX4_RES_EQ].num      = MLX4_NUM_EQ + dev_cap->reserved_eqs;
+	profile[MLX4_RES_DMPT].num    = request->num_mpt;
+	profile[MLX4_RES_CMPT].num    = MLX4_NUM_CMPTS;
+	profile[MLX4_RES_MTT].num     = request->num_mtt;
+	profile[MLX4_RES_MCG].num     = request->num_mcg;
+
+	for (i = 0; i < MLX4_RES_NUM; ++i) {
+		profile[i].type     = i;
+		profile[i].num      = roundup_pow_of_two(profile[i].num);
+		profile[i].log_num  = ilog2(profile[i].num);
+		profile[i].size    *= profile[i].num;
+		profile[i].size     = max(profile[i].size, (u64) PAGE_SIZE);
+	}
+
+	/*
+	 * Sort the resources in decreasing order of size.  Since they
+	 * all have sizes that are powers of 2, we'll be able to keep
+	 * resources aligned to their size and pack them without gaps
+	 * using the sorted order.
+	 */
+	for (i = MLX4_RES_NUM; i > 0; --i)
+		for (j = 1; j < i; ++j) {
+			if (profile[j].size > profile[j - 1].size) {
+				tmp	       = profile[j];
+				profile[j]     = profile[j - 1];
+				profile[j - 1] = tmp;
+			}
+		}
+
+	for (i = 0; i < MLX4_RES_NUM; ++i) {
+		if (profile[i].size) {
+			profile[i].start = total_size;
+			total_size	+= profile[i].size;
+		}
+
+		if (total_size > dev_cap->max_icm_sz) {
+			mlx4_err(dev, "Profile requires 0x%llx bytes; "
+				  "won't fit in 0x%llx bytes of context memory.\n",
+				  (unsigned long long) total_size,
+				  (unsigned long long) dev_cap->max_icm_sz);
+			kfree(profile);
+			return -ENOMEM;
+		}
+
+		if (profile[i].size)
+			mlx4_dbg(dev, "  profile[%2d] (%6s): 2^%02d entries @ 0x%10llx, "
+				  "size 0x%10llx\n",
+				 i, res_name[profile[i].type], profile[i].log_num,
+				 (unsigned long long) profile[i].start,
+				 (unsigned long long) profile[i].size);
+	}
+
+	mlx4_dbg(dev, "HCA context memory: reserving %d KB\n",
+		 (int) (total_size >> 10));
+
+	for (i = 0; i < MLX4_RES_NUM; ++i) {
+		switch (profile[i].type) {
+		case MLX4_RES_QP:
+			dev->caps.num_qps     = profile[i].num;
+			init_hca->qpc_base    = profile[i].start;
+			init_hca->log_num_qps = profile[i].log_num;
+			break;
+		case MLX4_RES_RDMARC:
+			for (priv->qp_table.rdmarc_shift = 0;
+			     request->num_qp << priv->qp_table.rdmarc_shift < profile[i].num;
+			     ++priv->qp_table.rdmarc_shift)
+				; /* nothing */
+			dev->caps.max_qp_dest_rdma = 1 << priv->qp_table.rdmarc_shift;
+			priv->qp_table.rdmarc_base   = (u32) profile[i].start;
+			init_hca->rdmarc_base	     = profile[i].start;
+			init_hca->log_rd_per_qp	     = priv->qp_table.rdmarc_shift;
+			break;
+		case MLX4_RES_ALTC:
+			init_hca->altc_base = profile[i].start;
+			break;
+		case MLX4_RES_AUXC:
+			init_hca->auxc_base = profile[i].start;
+			break;
+		case MLX4_RES_SRQ:
+			dev->caps.num_srqs     = profile[i].num;
+			init_hca->srqc_base    = profile[i].start;
+			init_hca->log_num_srqs = profile[i].log_num;
+			break;
+		case MLX4_RES_CQ:
+			dev->caps.num_cqs     = profile[i].num;
+			init_hca->cqc_base    = profile[i].start;
+			init_hca->log_num_cqs = profile[i].log_num;
+			break;
+		case MLX4_RES_EQ:
+			dev->caps.num_eqs     = profile[i].num;
+			init_hca->eqc_base    = profile[i].start;
+			init_hca->log_num_eqs = profile[i].log_num;
+			break;
+		case MLX4_RES_DMPT:
+			dev->caps.num_mpts	= profile[i].num;
+			priv->mr_table.mpt_base = profile[i].start;
+			init_hca->dmpt_base	= profile[i].start;
+			init_hca->log_mpt_sz	= profile[i].log_num;
+			break;
+		case MLX4_RES_CMPT:
+			init_hca->cmpt_base	 = profile[i].start;
+			break;
+		case MLX4_RES_MTT:
+			dev->caps.num_mtt_segs	 = profile[i].num;
+			priv->mr_table.mtt_base	 = profile[i].start;
+			init_hca->mtt_base	 = profile[i].start;
+			break;
+		case MLX4_RES_MCG:
+			dev->caps.num_mgms	  = profile[i].num >> 1;
+			dev->caps.num_amgms	  = profile[i].num >> 1;
+			init_hca->mc_base	  = profile[i].start;
+			init_hca->log_mc_entry_sz = ilog2(MLX4_MGM_ENTRY_SIZE);
+			init_hca->log_mc_table_sz = profile[i].log_num;
+			init_hca->log_mc_hash_sz  = profile[i].log_num - 1;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/*
+	 * PDs don't take any HCA memory, but we assign them as part
+	 * of the HCA profile anyway.
+	 */
+	dev->caps.num_pds = MLX4_NUM_PDS;
+
+	kfree(profile);
+	return total_size;
+}
diff --git a/drivers/net/mlx4/reset.c b/drivers/net/mlx4/reset.c
new file mode 100644
index 0000000..ba16228
--- /dev/null
+++ b/drivers/net/mlx4/reset.c
@@ -0,0 +1,172 @@
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
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "mlx4.h"
+
+int mlx4_reset(struct mlx4_dev *dev)
+{
+	int i;
+	int err = 0;
+	u32 *hca_header = NULL;
+	int pcie_cap;
+
+	u16 devctl;
+	u16 linkctl;
+
+#define MLX4_RESET_OFFSET 0xf0010
+#define MLX4_RESET_VALUE  swab32(1)
+
+	/*
+	 * Reset the chip.  This is somewhat ugly because we have to
+	 * save off the PCI header before reset and then restore it
+	 * after the chip reboots.  We skip config space offsets 22
+	 * and 23 since those have a special meaning.
+	 */
+
+	/* Do we need to save off the full 4K PCI Express header?? */
+	hca_header = kmalloc(256, GFP_KERNEL);
+	if (!hca_header) {
+		err = -ENOMEM;
+		mlx4_err(dev, "Couldn't allocate memory to save HCA "
+			  "PCI header, aborting.\n");
+		goto out;
+	}
+
+	pcie_cap = pci_find_capability(dev->pdev, PCI_CAP_ID_EXP);
+
+	for (i = 0; i < 64; ++i) {
+		if (i == 22 || i == 23)
+			continue;
+		if (pci_read_config_dword(dev->pdev, i * 4, hca_header + i)) {
+			err = -ENODEV;
+			mlx4_err(dev, "Couldn't save HCA "
+				  "PCI header, aborting.\n");
+			goto out;
+		}
+	}
+
+	/* actually hit reset */
+	{
+		void __iomem *reset = ioremap(pci_resource_start(dev->pdev, 0) +
+					      MLX4_RESET_OFFSET, 4);
+
+		if (!reset) {
+			err = -ENOMEM;
+			mlx4_err(dev, "Couldn't map HCA reset register, "
+				  "aborting.\n");
+			goto out;
+		}
+
+		writel(MLX4_RESET_VALUE, reset);
+		iounmap(reset);
+	}
+
+	/* Docs say to wait one second before accessing device */
+	msleep(1000);
+
+	/* Now wait for PCI device to start responding again */
+	{
+		u32 v;
+		int c = 0;
+
+		for (c = 0; c < 100; ++c) {
+			if (pci_read_config_dword(dev->pdev, 0, &v)) {
+				err = -ENODEV;
+				mlx4_err(dev, "Couldn't access HCA after reset, "
+					  "aborting.\n");
+				goto out;
+			}
+
+			if (v != 0xffffffff)
+				goto good;
+
+			msleep(100);
+		}
+
+		err = -ENODEV;
+		mlx4_err(dev, "PCI device did not come back after reset, "
+			  "aborting.\n");
+		goto out;
+	}
+
+good:
+	/* Now restore the PCI headers */
+	if (pcie_cap) {
+		devctl = hca_header[(pcie_cap + PCI_EXP_DEVCTL) / 4];
+		if (pci_write_config_word(dev->pdev, pcie_cap + PCI_EXP_DEVCTL,
+					   devctl)) {
+			err = -ENODEV;
+			mlx4_err(dev, "Couldn't restore HCA PCI Express "
+				 "Device Control register, aborting.\n");
+			goto out;
+		}
+		linkctl = hca_header[(pcie_cap + PCI_EXP_LNKCTL) / 4];
+		if (pci_write_config_word(dev->pdev, pcie_cap + PCI_EXP_LNKCTL,
+					   linkctl)) {
+			err = -ENODEV;
+			mlx4_err(dev, "Couldn't restore HCA PCI Express "
+				 "Link control register, aborting.\n");
+			goto out;
+		}
+	}
+
+	for (i = 0; i < 16; ++i) {
+		if (i * 4 == PCI_COMMAND)
+			continue;
+
+		if (pci_write_config_dword(dev->pdev, i * 4, hca_header[i])) {
+			err = -ENODEV;
+			mlx4_err(dev, "Couldn't restore HCA reg %x, "
+				  "aborting.\n", i);
+			goto out;
+		}
+	}
+
+	if (pci_write_config_dword(dev->pdev, PCI_COMMAND,
+				   hca_header[PCI_COMMAND / 4])) {
+		err = -ENODEV;
+		mlx4_err(dev, "Couldn't restore HCA COMMAND, "
+			  "aborting.\n");
+		goto out;
+	}
+
+out:
+	kfree(hca_header);
+
+	return err;
+}
