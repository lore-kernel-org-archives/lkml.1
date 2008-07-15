Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbYGOU5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbYGOU5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYGOU4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:56:53 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18365 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYGOU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:56:52 -0400
X-IronPort-AV: E=Sophos;i="4.30,368,1212364800"; 
   d="scan'208";a="53377907"
From: Roland Dreier <rdreier@cisco.com>
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, sean.hefty@intel.com
Subject: [PATCH] RDMA/ucma: BKL is not needed for ucma_open()
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Jul 2008 13:56:50 -0700
Message-ID: <adatzeqdfxp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 20:56:51.0211 (UTC) FILETIME=[4E035DB0:01C8E6BD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove explicit lock_kernel() calls and document why the code is safe.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
I'll merge this through my tree unless someone sees something wrong with it...

 drivers/infiniband/core/ucma.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 195f973..b41dd26 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -38,7 +38,6 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 
 #include <rdma/rdma_user_cm.h>
 #include <rdma/ib_marshall.h>
@@ -1149,6 +1148,14 @@ static unsigned int ucma_poll(struct file *filp, struct poll_table_struct *wait)
 	return mask;
 }
 
+/*
+ * ucma_open() does not need the BKL:
+ *
+ *  - no global state is referred to;
+ *  - there is no ioctl method to race against;
+ *  - no further module initialization is required for open to work
+ *    after the device is registered.
+ */
 static int ucma_open(struct inode *inode, struct file *filp)
 {
 	struct ucma_file *file;
@@ -1157,7 +1164,6 @@ static int ucma_open(struct inode *inode, struct file *filp)
 	if (!file)
 		return -ENOMEM;
 
-	lock_kernel();
 	INIT_LIST_HEAD(&file->event_list);
 	INIT_LIST_HEAD(&file->ctx_list);
 	init_waitqueue_head(&file->poll_wait);
@@ -1165,7 +1171,6 @@ static int ucma_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = file;
 	file->filp = filp;
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.5.6.2

