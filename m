Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXE3IH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXE3IH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXE3IHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:07:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXE3IHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:07:12 -0400
Date: Wed, 30 May 2007 04:05:18 -0400
From: Bill Nottingham <notting@redhat.com>
To: openib-general@openib.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/infiniband: fix comparsion between unsigned and
	negative
Message-ID: <20070530080518.GA29195@nostromo.devel.redhat.com>
Mail-Followup-To: openib-general@openib.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.

Signed-off-by: Bill Nottingham <notting@redhat.com>

---
 core/sysfs.c       |    2 +-
 core/ucm.c         |    2 +-
 core/ucma.c        |    2 +-
 core/user_mad.c    |    5 ++---
 core/uverbs_main.c |    3 +--
 core/verbs.c       |    3 +--
 hw/mlx4/qp.c       |    2 +-
 7 files changed, 8 insertions(+), 11 deletions(-)

diff -ru linux-2.6.21-old/drivers/infiniband/core/sysfs.c linux-2.6.21/drivers/infiniband/core/sysfs.c
--- linux-2.6.21-old/drivers/infiniband/core/sysfs.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/sysfs.c	2007-05-30 02:07:31.000000000 -0400
@@ -112,7 +112,7 @@
 		return ret;
 
 	return sprintf(buf, "%d: %s\n", attr.state,
-		       attr.state >= 0 && attr.state < ARRAY_SIZE(state_name) ?
+		       attr.state < ARRAY_SIZE(state_name) ?
 		       state_name[attr.state] : "UNKNOWN");
 }
 
diff -ru linux-2.6.21-old/drivers/infiniband/core/ucma.c linux-2.6.21/drivers/infiniband/core/ucma.c
--- linux-2.6.21-old/drivers/infiniband/core/ucma.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/ucma.c	2007-05-30 02:09:34.000000000 -0400
@@ -955,7 +955,7 @@
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
+	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 		return -EINVAL;
 
 	if (hdr.in + sizeof(hdr) > len)
diff -ru linux-2.6.21-old/drivers/infiniband/core/ucm.c linux-2.6.21/drivers/infiniband/core/ucm.c
--- linux-2.6.21-old/drivers/infiniband/core/ucm.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/ucm.c	2007-05-30 02:08:01.000000000 -0400
@@ -1125,7 +1125,7 @@
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
+	if (hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
 		return -EINVAL;
 
 	if (hdr.in + sizeof(hdr) > len)
diff -ru linux-2.6.21-old/drivers/infiniband/core/user_mad.c linux-2.6.21/drivers/infiniband/core/user_mad.c
--- linux-2.6.21-old/drivers/infiniband/core/user_mad.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/user_mad.c	2007-05-30 02:08:32.000000000 -0400
@@ -455,8 +455,7 @@
 		goto err;
 	}
 
-	if (packet->mad.hdr.id < 0 ||
-	    packet->mad.hdr.id >= IB_UMAD_MAX_AGENTS) {
+	if (packet->mad.hdr.id >= IB_UMAD_MAX_AGENTS) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -665,7 +664,7 @@
 
 	down_write(&file->port->mutex);
 
-	if (id < 0 || id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
+	if (id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff -ru linux-2.6.21-old/drivers/infiniband/core/uverbs_main.c linux-2.6.21/drivers/infiniband/core/uverbs_main.c
--- linux-2.6.21-old/drivers/infiniband/core/uverbs_main.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/uverbs_main.c	2007-05-30 02:09:07.000000000 -0400
@@ -592,8 +592,7 @@
 	if (hdr.in_words * 4 != count)
 		return -EINVAL;
 
-	if (hdr.command < 0				||
-	    hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
+	if (hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
 	    !uverbs_cmd_table[hdr.command]		||
 	    !(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
 		return -EINVAL;
diff -ru linux-2.6.21-old/drivers/infiniband/core/verbs.c linux-2.6.21/drivers/infiniband/core/verbs.c
--- linux-2.6.21-old/drivers/infiniband/core/verbs.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/core/verbs.c	2007-05-30 02:07:06.000000000 -0400
@@ -535,8 +535,7 @@
 {
 	enum ib_qp_attr_mask req_param, opt_param;
 
-	if (cur_state  < 0 || cur_state  > IB_QPS_ERR ||
-	    next_state < 0 || next_state > IB_QPS_ERR)
+	if (cur_state  > IB_QPS_ERR || next_state > IB_QPS_ERR)
 		return 0;
 
 	if (mask & IB_QP_CUR_STATE  &&
diff -ru linux-2.6.21-old/drivers/infiniband/hw/mlx4/qp.c linux-2.6.21/drivers/infiniband/hw/mlx4/qp.c
--- linux-2.6.21-old/drivers/infiniband/hw/mlx4/qp.c	2007-05-30 02:52:52.000000000 -0400
+++ linux-2.6.21/drivers/infiniband/hw/mlx4/qp.c	2007-05-30 02:10:18.000000000 -0400
@@ -1284,7 +1284,7 @@
 		 */
 		wmb();
 
-		if (wr->opcode < 0 || wr->opcode >= ARRAY_SIZE(mlx4_ib_opcode)) {
+		if (wr->opcode >= ARRAY_SIZE(mlx4_ib_opcode)) {
 			err = -EINVAL;
 			goto out;
 		}
