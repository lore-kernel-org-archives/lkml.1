Return-Path: <linux-kernel-owner+w=401wt.eu-S1767291AbXDTWcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767291AbXDTWcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767288AbXDTWcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:32:54 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:16841 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbXDTWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:32:50 -0400
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="414003417:sNHT101173040"
Subject: [PATCH 4/6] [RFC]mlx4_ib main files
In-Reply-To: <20074201532.7wkxUOPwHNFg96ue@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.mohEXyoz7s98VaHz@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:37.0262 (UTC) FILETIME=[CC362AE0:01C7839B]
Authentication-Results: sj-dkim-5; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Main include file and .c file for mlx4_ib.

Signed-off-by: Roland Dreier <rolandd@cisco.com>

---

 main.c    |  612 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mlx4_ib.h |  285 ++++++++++++++++++++++++++++
 2 files changed, 897 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
new file mode 100644
index 0000000..6f7165f
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -0,0 +1,612 @@
+/*
+ * Copyright (c) 2006, 2007 Cisco Systems, Inc. All rights reserved.
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
+
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include <linux/mlx4/driver.h>
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4_ib.h"
+#include "user.h"
+
+#define DRV_NAME	"mlx4_ib"
+#define DRV_VERSION	"0.01"
+#define DRV_RELDATE	"May 1, 2006"
+
+MODULE_AUTHOR("Roland Dreier");
+MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+
+static const char mlx4_ib_version[] __devinitdata =
+	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
+	DRV_VERSION " (" DRV_RELDATE ")\n";
+
+static void init_query_mad(struct ib_smp *mad)
+{
+	mad->base_version  = 1;
+	mad->mgmt_class    = IB_MGMT_CLASS_SUBN_LID_ROUTED;
+	mad->class_version = 1;
+	mad->method	   = IB_MGMT_METHOD_GET;
+}
+
+static int mlx4_ib_query_device(struct ib_device *ibdev,
+				struct ib_device_attr *props)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memset(props, 0, sizeof *props);
+
+	props->fw_ver = dev->dev->caps.fw_ver;
+	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
+		IB_DEVICE_PORT_ACTIVE_EVENT		|
+		IB_DEVICE_SYS_IMAGE_GUID		|
+		IB_DEVICE_RC_RNR_NAK_GEN;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR)
+		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
+		props->device_cap_flags |= IB_DEVICE_BAD_QKEY_CNTR;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_APM)
+		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_UD_AV_PORT)
+		props->device_cap_flags |= IB_DEVICE_UD_AV_PORT_ENFORCE;
+
+	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
+		0xffffff;
+	props->vendor_part_id	   = be16_to_cpup((__be16 *) (out_mad->data + 30));
+	props->hw_ver		   = be32_to_cpup((__be32 *) (out_mad->data + 32));
+	memcpy(&props->sys_image_guid, out_mad->data +	4, 8);
+
+	props->max_mr_size	   = ~0ull;
+	props->page_size_cap	   = dev->dev->caps.page_size_cap;
+	props->max_qp		   = dev->dev->caps.num_qps - dev->dev->caps.reserved_qps;
+	props->max_qp_wr	   = dev->dev->caps.max_wqes;
+	props->max_sge		   = min(dev->dev->caps.max_sq_sg,
+					 dev->dev->caps.max_rq_sg);
+	props->max_cq		   = dev->dev->caps.num_cqs - dev->dev->caps.reserved_cqs;
+	props->max_cqe		   = dev->dev->caps.max_cqes;
+	props->max_mr		   = dev->dev->caps.num_mpts - dev->dev->caps.reserved_mrws;
+	props->max_pd		   = dev->dev->caps.num_pds - dev->dev->caps.reserved_pds;
+	props->max_qp_rd_atom	   = dev->dev->caps.max_qp_dest_rdma;
+	props->max_qp_init_rd_atom = dev->dev->caps.max_qp_init_rdma;
+	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
+	props->max_srq		   = dev->dev->caps.num_srqs - dev->dev->caps.reserved_srqs;
+	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes;
+	props->max_srq_sge	   = dev->dev->caps.max_srq_sge;
+	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
+	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
+		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
+	props->max_pkeys	   = dev->dev->caps.pkey_table_len;
+	props->max_mcast_grp	   = dev->dev->caps.num_mgms + dev->dev->caps.num_amgms;
+	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
+					   props->max_mcast_grp;
+	props->max_map_per_fmr = (1 << (32 - ilog2(dev->dev->caps.num_mpts))) - 1;
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+
+	return err;
+}
+
+static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+			      struct ib_port_attr *props)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	memset(props, 0, sizeof *props);
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
+	in_mad->attr_mod = cpu_to_be32(port);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
+	props->lmc		= out_mad->data[34] & 0x7;
+	props->sm_lid		= be16_to_cpup((__be16 *) (out_mad->data + 18));
+	props->sm_sl		= out_mad->data[36] & 0xf;
+	props->state		= out_mad->data[32] & 0xf;
+	props->phys_state	= out_mad->data[33] >> 4;
+	props->port_cap_flags	= be32_to_cpup((__be32 *) (out_mad->data + 20));
+	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len;
+	props->max_msg_sz	= 0x80000000;
+	props->pkey_tbl_len	= to_mdev(ibdev)->dev->caps.pkey_table_len;
+	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
+	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
+	props->active_width	= out_mad->data[31] & 0xf;
+	props->active_speed	= out_mad->data[35] >> 4;
+	props->max_mtu		= out_mad->data[41] & 0xf;
+	props->active_mtu	= out_mad->data[36] >> 4;
+	props->subnet_timeout	= out_mad->data[51] & 0x1f;
+	props->max_vl_num	= out_mad->data[37] >> 4;
+	props->init_type_reply	= out_mad->data[41] >> 4;
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+
+	return err;
+}
+
+static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+			     union ib_gid *gid)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
+	in_mad->attr_mod = cpu_to_be32(port);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memcpy(gid->raw, out_mad->data + 8, 8);
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_GUID_INFO;
+	in_mad->attr_mod = cpu_to_be32(index / 8);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+	return err;
+}
+
+static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			      u16 *pkey)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PKEY_TABLE;
+	in_mad->attr_mod = cpu_to_be32(index / 32);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	*pkey = be16_to_cpu(((__be16 *) out_mad->data)[index % 32]);
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+	return err;
+}
+
+static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
+				 struct ib_device_modify *props)
+{
+	if (mask & ~IB_DEVICE_MODIFY_NODE_DESC)
+		return -EOPNOTSUPP;
+
+	if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
+		spin_lock(&to_mdev(ibdev)->sm_lock);
+		memcpy(ibdev->node_desc, props->node_desc, 64);
+		spin_unlock(&to_mdev(ibdev)->sm_lock);
+	}
+
+	return 0;
+}
+
+static int mlx4_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_viols,
+			 u32 cap_mask)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev->dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	memset(mailbox->buf, 0, 256);
+	*(u8 *) mailbox->buf	     = cpu_to_be32(!!reset_qkey_viols << 6);
+	((__be32 *) mailbox->buf)[2] = cpu_to_be32(cap_mask);
+
+	err = mlx4_cmd(dev->dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+		       MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev->dev, mailbox);
+	return err;
+}
+
+static int mlx4_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
+			       struct ib_port_modify *props)
+{
+	struct ib_port_attr attr;
+	u32 cap_mask;
+	int err;
+
+	mutex_lock(&to_mdev(ibdev)->cap_mask_mutex);
+
+	err = mlx4_ib_query_port(ibdev, port, &attr);
+	if (err)
+		goto out;
+
+	cap_mask = (attr.port_cap_flags | props->set_port_cap_mask) &
+		~props->clr_port_cap_mask;
+
+	err = mlx4_SET_PORT(to_mdev(ibdev), port,
+			    !!(mask & IB_PORT_RESET_QKEY_CNTR),
+			    cap_mask);
+
+out:
+	mutex_unlock(&to_mdev(ibdev)->cap_mask_mutex);
+	return err;
+}
+
+static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
+						  struct ib_udata *udata)
+{
+	struct mlx4_ib_ucontext *context;
+	struct mlx4_ib_alloc_ucontext_resp resp;
+	int err;
+
+	resp.qp_tab_size = to_mdev(ibdev)->dev->caps.num_qps;
+	/* FIXME blueflame info */
+	resp.bf_reg_size = 0;
+
+	context = kmalloc(sizeof *context, GFP_KERNEL);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_uar_alloc(to_mdev(ibdev)->dev, &context->uar);
+	if (err) {
+		kfree(context);
+		return ERR_PTR(err);
+	}
+
+	INIT_LIST_HEAD(&context->db_page_list);
+	mutex_init(&context->db_page_mutex);
+
+	err = ib_copy_to_udata(udata, &resp, sizeof resp);
+	if (err) {
+		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
+		kfree(context);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return &context->ibucontext;
+}
+
+static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);
+
+	mlx4_uar_free(to_mdev(ibcontext->device)->dev, &context->uar);
+	kfree(context);
+
+	return 0;
+}
+
+static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	/* FIXME handle mapping blueflame regs if offset !=0 */
+	if (vma->vm_pgoff > 0)
+		return -EINVAL;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start,
+			       to_mucontext(context)->uar.pfn,
+			       PAGE_SIZE, vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static struct ib_pd *mlx4_ib_alloc_pd(struct ib_device *ibdev,
+				      struct ib_ucontext *context,
+				      struct ib_udata *udata)
+{
+	struct mlx4_ib_pd *pd;
+	int err;
+
+	pd = kmalloc(sizeof *pd, GFP_KERNEL);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_pd_alloc(to_mdev(ibdev)->dev, &pd->pdn);
+	if (err) {
+		kfree(pd);
+		return ERR_PTR(err);
+	}
+
+	if (context)
+		if (ib_copy_to_udata(udata, &pd->pdn, sizeof (__u32))) {
+			mlx4_pd_free(to_mdev(ibdev)->dev, pd->pdn);
+			kfree(pd);
+			return ERR_PTR(-EFAULT);
+		}
+
+	return &pd->ibpd;
+}
+
+static int mlx4_ib_dealloc_pd(struct ib_pd *pd)
+{
+	mlx4_pd_free(to_mdev(pd->device)->dev, to_mpd(pd)->pdn);
+	kfree(pd);
+
+	return 0;
+}
+
+static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
+{
+	return mlx4_multicast_attach(to_mdev(ibqp->device)->dev,
+				     &to_mqp(ibqp)->mqp, gid->raw);
+}
+
+static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
+{
+	return mlx4_multicast_detach(to_mdev(ibqp->device)->dev,
+				     &to_mqp(ibqp)->mqp, gid->raw);
+}
+
+static int init_node_data(struct mlx4_ib_dev *dev)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
+
+	err = mlx4_MAD_IFC(dev, 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+
+	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
+
+	err = mlx4_MAD_IFC(dev, 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+	return err;
+}
+
+static void *mlx4_ib_add(struct mlx4_dev *dev)
+{
+	struct mlx4_ib_dev *ibdev;
+
+	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof *ibdev);
+	if (!ibdev) {
+		dev_err(&dev->pdev->dev, "Device struct alloc failed\n");
+		return NULL;
+	}
+
+	if (mlx4_pd_alloc(dev, &ibdev->priv_pdn))
+		goto err_dealloc;
+
+	if (mlx4_uar_alloc(dev, &ibdev->priv_uar))
+		goto err_pd;
+
+	ibdev->uar_map = ioremap(ibdev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!ibdev->uar_map)
+		goto err_uar;
+
+	INIT_LIST_HEAD(&ibdev->pgdir_list);
+	spin_lock_init(&ibdev->pgdir_lock);
+
+	ibdev->dev = dev;
+
+	strlcpy(ibdev->ib_dev.name, "mlx4_%d", IB_DEVICE_NAME_MAX);
+	ibdev->ib_dev.owner		= THIS_MODULE;
+	ibdev->ib_dev.node_type		= RDMA_NODE_IB_CA;
+	ibdev->ib_dev.phys_port_cnt	= dev->caps.num_ports;
+	ibdev->ib_dev.dma_device	= &dev->pdev->dev;
+	ibdev->ib_dev.class_dev.dev	= &dev->pdev->dev;
+
+	ibdev->ib_dev.uverbs_abi_ver	= MLX4_IB_UVERBS_ABI_VERSION;
+	ibdev->ib_dev.uverbs_cmd_mask	=
+		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
+		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
+		(1ull << IB_USER_VERBS_CMD_QUERY_PORT)		|
+		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
+		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
+		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_CQ)		|
+		(1ull << IB_USER_VERBS_CMD_CREATE_QP)		|
+		(1ull << IB_USER_VERBS_CMD_MODIFY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_QP)		|
+		(1ull << IB_USER_VERBS_CMD_ATTACH_MCAST)	|
+		(1ull << IB_USER_VERBS_CMD_DETACH_MCAST)	|
+		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ);
+
+	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
+	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
+	ibdev->ib_dev.query_gid		= mlx4_ib_query_gid;
+	ibdev->ib_dev.query_pkey	= mlx4_ib_query_pkey;
+	ibdev->ib_dev.modify_device	= mlx4_ib_modify_device;
+	ibdev->ib_dev.modify_port	= mlx4_ib_modify_port;
+	ibdev->ib_dev.alloc_ucontext	= mlx4_ib_alloc_ucontext;
+	ibdev->ib_dev.dealloc_ucontext	= mlx4_ib_dealloc_ucontext;
+	ibdev->ib_dev.mmap		= mlx4_ib_mmap;
+	ibdev->ib_dev.alloc_pd		= mlx4_ib_alloc_pd;
+	ibdev->ib_dev.dealloc_pd	= mlx4_ib_dealloc_pd;
+	ibdev->ib_dev.create_ah		= mlx4_ib_create_ah;
+	ibdev->ib_dev.query_ah		= mlx4_ib_query_ah;
+	ibdev->ib_dev.destroy_ah	= mlx4_ib_destroy_ah;
+	ibdev->ib_dev.create_srq	= mlx4_ib_create_srq;
+	ibdev->ib_dev.modify_srq	= mlx4_ib_modify_srq;
+	ibdev->ib_dev.destroy_srq	= mlx4_ib_destroy_srq;
+	ibdev->ib_dev.post_srq_recv	= mlx4_ib_post_srq_recv;
+	ibdev->ib_dev.create_qp		= mlx4_ib_create_qp;
+	ibdev->ib_dev.modify_qp		= mlx4_ib_modify_qp;
+	ibdev->ib_dev.destroy_qp	= mlx4_ib_destroy_qp;
+	ibdev->ib_dev.post_send		= mlx4_ib_post_send;
+	ibdev->ib_dev.post_recv		= mlx4_ib_post_recv;
+	ibdev->ib_dev.create_cq		= mlx4_ib_create_cq;
+	ibdev->ib_dev.destroy_cq	= mlx4_ib_destroy_cq;
+	ibdev->ib_dev.poll_cq		= mlx4_ib_poll_cq;
+	ibdev->ib_dev.req_notify_cq	= mlx4_ib_arm_cq;
+	ibdev->ib_dev.get_dma_mr	= mlx4_ib_get_dma_mr;
+	ibdev->ib_dev.reg_user_mr	= mlx4_ib_reg_user_mr;
+	ibdev->ib_dev.dereg_mr		= mlx4_ib_dereg_mr;
+	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
+	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
+	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
+
+	if (init_node_data(ibdev))
+		goto err_map;
+
+	spin_lock_init(&ibdev->sm_lock);
+	mutex_init(&ibdev->cap_mask_mutex);
+
+	if (ib_register_device(&ibdev->ib_dev))
+		goto err_map;
+
+	if (mlx4_ib_mad_init(ibdev))
+		goto err_reg;
+
+	return ibdev;
+
+err_reg:
+	ib_unregister_device(&ibdev->ib_dev);
+
+err_map:
+	iounmap(ibdev->uar_map);
+
+err_uar:
+	mlx4_uar_free(dev, &ibdev->priv_uar);
+
+err_pd:
+	mlx4_pd_free(dev, ibdev->priv_pdn);
+
+err_dealloc:
+	ib_dealloc_device(&ibdev->ib_dev);
+
+	return NULL;
+}
+
+static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
+{
+	struct mlx4_ib_dev *ibdev = ibdev_ptr;
+	int p;
+
+	for (p = 1; p <= dev->caps.num_ports; ++p)
+		mlx4_CLOSE_PORT(dev, p);
+
+	mlx4_ib_mad_cleanup(ibdev);
+	ib_unregister_device(&ibdev->ib_dev);
+	iounmap(ibdev->uar_map);
+	mlx4_uar_free(dev, &ibdev->priv_uar);
+	mlx4_pd_free(dev, ibdev->priv_pdn);
+	ib_dealloc_device(&ibdev->ib_dev);
+}
+
+static struct mlx4_interface mlx4_ib_interface = {
+	.add	= mlx4_ib_add,
+	.remove	= mlx4_ib_remove
+};
+
+static int __init mlx4_ib_init(void)
+{
+	return mlx4_register_interface(&mlx4_ib_interface);
+}
+
+static void __exit mlx4_ib_cleanup(void)
+{
+	mlx4_unregister_interface(&mlx4_ib_interface);
+}
+
+module_init(mlx4_ib_init);
+module_exit(mlx4_ib_cleanup);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
new file mode 100644
index 0000000..df3a11a
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -0,0 +1,285 @@
+/*
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
+#ifndef MLX4_IB_H
+#define MLX4_IB_H
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
+
+#include <linux/mlx4/device.h>
+#include <linux/mlx4/doorbell.h>
+
+enum {
+	MLX4_IB_DB_PER_PAGE	= PAGE_SIZE / 4
+};
+
+struct mlx4_ib_db_pgdir;
+struct mlx4_ib_user_db_page;
+
+struct mlx4_ib_db {
+	__be32		       *db;
+	union {
+		struct mlx4_ib_db_pgdir	       *pgdir;
+		struct mlx4_ib_user_db_page    *user_page;
+	}			u;
+	dma_addr_t		dma;
+	int			index;
+	int			order;
+};
+
+struct mlx4_ib_ucontext {
+	struct ib_ucontext	ibucontext;
+	struct mlx4_uar		uar;
+	struct list_head	db_page_list;
+	struct mutex		db_page_mutex;
+};
+
+struct mlx4_ib_pd {
+	struct ib_pd		ibpd;
+	u32			pdn;
+};
+
+struct mlx4_ib_cq_buf {
+	struct mlx4_buf		buf;
+	struct mlx4_mtt		mtt;
+};
+
+struct mlx4_ib_cq {
+	struct ib_cq		ibcq;
+	struct mlx4_cq		mcq;
+	struct mlx4_ib_cq_buf	buf;
+	struct mlx4_ib_db	db;
+	spinlock_t		lock;
+	struct ib_umem	       *umem;
+};
+
+struct mlx4_ib_mr {
+	struct ib_mr		ibmr;
+	struct mlx4_mr		mmr;
+	struct ib_umem	       *umem;
+};
+
+struct mlx4_ib_wq {
+	u64		       *wrid;
+	spinlock_t		lock;
+	int			max;
+	int			max_gs;
+	int			offset;
+	int			wqe_shift;
+	unsigned		head;
+	unsigned		tail;
+};
+
+struct mlx4_ib_qp {
+	struct ib_qp		ibqp;
+	struct mlx4_qp		mqp;
+	struct mlx4_buf		buf;
+
+	struct mlx4_ib_db	db;
+	struct mlx4_ib_wq	rq;
+
+	u32			doorbell_qpn;
+	__be32			sq_signal_bits;
+	struct mlx4_ib_wq	sq;
+
+	struct ib_umem	       *umem;
+	struct mlx4_mtt		mtt;
+	int			buf_size;
+	struct mutex		mutex;
+	u8			port;
+	u8			alt_port;
+	u8			atomic_rd_en;
+	u8			resp_depth;
+	u8			state;
+};
+
+struct mlx4_ib_srq {
+	struct ib_srq		ibsrq;
+	struct mlx4_srq		msrq;
+	struct mlx4_buf		buf;
+	struct mlx4_ib_db	db;
+	u64		       *wrid;
+	spinlock_t		lock;
+	int			head;
+	int			tail;
+	u16			wqe_ctr;
+	struct ib_umem	       *umem;
+	struct mlx4_mtt		mtt;
+	struct mutex		mutex;
+};
+
+struct mlx4_ib_ah {
+	struct ib_ah		ibah;
+	struct mlx4_av		av;
+};
+
+struct mlx4_ib_dev {
+	struct ib_device	ib_dev;
+	struct mlx4_dev	       *dev;
+	void __iomem	       *uar_map;
+
+	struct list_head	pgdir_list;
+	spinlock_t		pgdir_lock;
+
+	struct mlx4_uar		priv_uar;
+	u32			priv_pdn;
+	MLX4_DECLARE_DOORBELL_LOCK(uar_lock);
+
+	struct ib_mad_agent    *send_agent[MLX4_MAX_PORTS][2];
+	struct ib_ah	       *sm_ah[MLX4_MAX_PORTS];
+	spinlock_t		sm_lock;
+
+	struct mutex		cap_mask_mutex;
+};
+
+static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
+}
+
+static inline struct mlx4_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct mlx4_ib_ucontext, ibucontext);
+}
+
+static inline struct mlx4_ib_pd *to_mpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct mlx4_ib_pd, ibpd);
+}
+
+static inline struct mlx4_ib_cq *to_mcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct mlx4_ib_cq, ibcq);
+}
+
+static inline struct mlx4_ib_cq *to_mibcq(struct mlx4_cq *mcq)
+{
+	return container_of(mcq, struct mlx4_ib_cq, mcq);
+}
+
+static inline struct mlx4_ib_mr *to_mmr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct mlx4_ib_mr, ibmr);
+}
+
+static inline struct mlx4_ib_qp *to_mqp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct mlx4_ib_qp, ibqp);
+}
+
+static inline struct mlx4_ib_qp *to_mibqp(struct mlx4_qp *mqp)
+{
+	return container_of(mqp, struct mlx4_ib_qp, mqp);
+}
+
+static inline struct mlx4_ib_srq *to_msrq(struct ib_srq *ibsrq)
+{
+	return container_of(ibsrq, struct mlx4_ib_srq, ibsrq);
+}
+
+static inline struct mlx4_ib_srq *to_mibsrq(struct mlx4_srq *msrq)
+{
+	return container_of(msrq, struct mlx4_ib_srq, msrq);
+}
+
+static inline struct mlx4_ib_ah *to_mah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct mlx4_ib_ah, ibah);
+}
+
+int mlx4_ib_db_alloc(struct mlx4_ib_dev *dev, struct mlx4_ib_db *db, int order);
+void mlx4_ib_db_free(struct mlx4_ib_dev *dev, struct mlx4_ib_db *db);
+int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
+			struct mlx4_ib_db *db);
+void mlx4_ib_db_unmap_user(struct mlx4_ib_ucontext *context, struct mlx4_ib_db *db);
+
+struct ib_mr *mlx4_ib_get_dma_mr(struct ib_pd *pd, int acc);
+int mlx4_ib_umem_write_mtt(struct mlx4_ib_dev *dev, struct mlx4_mtt *mtt,
+			   struct ib_umem *umem);
+struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				  u64 virt_addr, int access_flags,
+				  struct ib_udata *udata);
+int mlx4_ib_dereg_mr(struct ib_mr *mr);
+
+struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries,
+				struct ib_ucontext *context,
+				struct ib_udata *udata);
+int mlx4_ib_destroy_cq(struct ib_cq *cq);
+int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify notify);
+void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
+void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
+
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int mlx4_ib_destroy_ah(struct ib_ah *ah);
+
+struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
+				  struct ib_srq_init_attr *init_attr,
+				  struct ib_udata *udata);
+int mlx4_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata);
+int mlx4_ib_destroy_srq(struct ib_srq *srq);
+void mlx4_ib_free_srq_wqe(struct mlx4_ib_srq *srq, int wqe_index);
+int mlx4_ib_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+			  struct ib_recv_wr **bad_wr);
+
+struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
+				struct ib_qp_init_attr *init_attr,
+				struct ib_udata *udata);
+int mlx4_ib_destroy_qp(struct ib_qp *qp);
+int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata);
+int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		      struct ib_send_wr **bad_wr);
+int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr);
+
+int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
+		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
+		 void *in_mad, void *response_mad);
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
+			struct ib_wc *in_wc, struct ib_grh *in_grh,
+			struct ib_mad *in_mad, struct ib_mad *out_mad);
+int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
+void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
+
+static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
+{
+	return !!(ah->av.g_slid & 0x80);
+}
+
+#endif /* MLX4_IB_H */
