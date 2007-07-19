Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXGST6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXGST6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXGST6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:58:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:16350 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXGST6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=jprqZpfVgdysXXOCNK9KoVbL1rzmB7jjsSG7PuIM5BRTbGPu9j0noiUcJGXG0VwMuhkRgXKQUVpGukDNi6P5Oxni4Hc88Z/rXN6qBBjdALmQb1bs7DgUPLUMMZDXFCNvhZHzPQDFXR25M8nAgc+MeChyewVpNIWFQWMyi5X9T/o=
Message-ID: <469FC251.5020109@gmail.com>
Date: Thu, 19 Jul 2007 15:58:09 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: rolandd@cisco.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] infiniband mlx4: potential leaks in __mlx4_ib_modify_qp
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Temporarily allocated struct mlx4_qp_context *context is leaked by 
several error paths. The patch takes advantage of the return value 'err' 
being preinitialized to -EINVAL.

Spotted by Coverity (1768).

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/infiniband/hw/mlx4/qp.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b5a24fb..5456bc4 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -742,7 +742,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		if (attr->path_mtu < IB_MTU_256 || attr->path_mtu > IB_MTU_4096) {
 			printk(KERN_ERR "path MTU (%u) is invalid\n",
 			       attr->path_mtu);
-			return -EINVAL;
+			goto out;
 		}
 		context->mtu_msgmax = (attr->path_mtu << 5) | 31;
 	}
@@ -781,10 +781,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 
 	if (attr_mask & IB_QP_AV) {
 		if (mlx4_set_path(dev, &attr->ah_attr, &context->pri_path,
-				  attr_mask & IB_QP_PORT ? attr->port_num : qp->port)) {
-			err = -EINVAL;
+				  attr_mask & IB_QP_PORT ? attr->port_num : qp->port))
 			goto out;
-		}
 
 		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
 			   MLX4_QP_OPTPAR_SCHED_QUEUE);
@@ -798,15 +796,15 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_ALT_PATH) {
 		if (attr->alt_port_num == 0 ||
 		    attr->alt_port_num > dev->dev->caps.num_ports)
-			return -EINVAL;
+			goto out;
 
 		if (attr->alt_pkey_index >=
 		    dev->dev->caps.pkey_table_len[attr->alt_port_num])
-			return -EINVAL;
+			goto out;
 
 		if (mlx4_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
 				  attr->alt_port_num))
-			return -EINVAL;
+			goto out;
 
 		context->alt_path.pkey_index = attr->alt_pkey_index;
 		context->alt_path.ackto = attr->alt_timeout << 3;

