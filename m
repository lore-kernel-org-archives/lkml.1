Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYFIUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYFIUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYFIUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:10:18 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:39300 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYFIUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:10:16 -0400
X-IronPort-AV: E=Sophos;i="4.27,614,1204531200"; 
   d="scan'208";a="39802937"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 13:10:15 -0700
Message-ID: <adak5gy8j4o.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 20:10:15.0952 (UTC) FILETIME=[D509B100:01C8CA6C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fix for a crash/lockup triggerable by buggy userspace
(that I already sent you as a patch via email), and remove one API
that only appeared in 2.6.26-rc kernels and that we decided should be
exposed in a different way (already queued for 2.6.27 in linux-next).

Roland Dreier (2):
      IB/umem: Avoid sign problems when demoting npages to integer
      IB/core: Remove IB_DEVICE_SEND_W_INV capability flag

 drivers/infiniband/core/umem.c           |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c |    3 +--
 include/rdma/ib_verbs.h                  |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index fe78f7d..a1768db 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -150,7 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	ret = 0;
 	while (npages) {
 		ret = get_user_pages(current, current->mm, cur_base,
-				     min_t(int, npages,
+				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     1, !umem->writable, page_list, vma_list);
 
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index 9a054c6..b1441ae 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -455,8 +455,7 @@ int __devinit c2_rnic_init(struct c2_dev *c2dev)
 	     IB_DEVICE_CURR_QP_STATE_MOD |
 	     IB_DEVICE_SYS_IMAGE_GUID |
 	     IB_DEVICE_ZERO_STAG |
-	     IB_DEVICE_MEM_WINDOW |
-	     IB_DEVICE_SEND_W_INV);
+	     IB_DEVICE_MEM_WINDOW);
 
 	/* Allocate the qptr_array */
 	c2dev->qptr_array = vmalloc(C2_MAX_CQS * sizeof(void *));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 911a661..31d30b1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -105,7 +105,6 @@ enum ib_device_cap_flags {
 	 */
 	IB_DEVICE_UD_IP_CSUM		= (1<<18),
 	IB_DEVICE_UD_TSO		= (1<<19),
-	IB_DEVICE_SEND_W_INV		= (1<<21),
 };
 
 enum ib_atomic_cap {
