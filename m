Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbYGOU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbYGOU5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYGOU51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:57:27 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18542 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYGOU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:57:26 -0400
X-IronPort-AV: E=Sophos;i="4.30,368,1212364800"; 
   d="scan'208";a="53378326"
From: Roland Dreier <rdreier@cisco.com>
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, sean.hefty@intel.com
Subject: [PATCH] RDMA/ucm: BKL is not needed for ib_ucm_open()
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Jul 2008 13:57:25 -0700
Message-ID: <adaprpedfwq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 20:57:25.0586 (UTC) FILETIME=[62809320:01C8E6BD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove explicit cycle_kernel_lock() call and document why the code is safe.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
And merge this too...

 drivers/infiniband/core/ucm.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 9494005..e603736 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -43,7 +43,6 @@
 #include <linux/cdev.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -1154,11 +1153,18 @@ static unsigned int ib_ucm_poll(struct file *filp,
 	return mask;
 }
 
+/*
+ * ib_ucm_open() does not need the BKL:
+ *
+ *  - no global state is referred to;
+ *  - there is no ioctl method to race against;
+ *  - no further module initialization is required for open to work
+ *    after the device is registered.
+ */
 static int ib_ucm_open(struct inode *inode, struct file *filp)
 {
 	struct ib_ucm_file *file;
 
-	cycle_kernel_lock();
 	file = kmalloc(sizeof(*file), GFP_KERNEL);
 	if (!file)
 		return -ENOMEM;
-- 
1.5.6.2

