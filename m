Return-Path: <linux-kernel-owner+w=401wt.eu-S1764438AbYF0Vxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764438AbYF0Vxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764707AbYF0VnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:43:24 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:5416 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763926AbYF0VnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:43:21 -0400
X-IronPort-AV: E=Sophos;i="4.27,717,1204531200"; 
   d="scan'208";a="61125754"
From: Roland Dreier <rdreier@cisco.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       general@lists.openfabrics.org
Subject: [PATCH] IB/uverbs: BKL is not needed for ib_uverbs_open()
References: <20080627095418.2353267d@bike.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 27 Jun 2008 14:43:20 -0700
In-Reply-To: <20080627095418.2353267d@bike.lwn.net> (Jonathan Corbet's message
	of "Fri, 27 Jun 2008 09:54:18 -0600")
Message-ID: <adaskuylfk7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jun 2008 21:43:20.0337 (UTC) FILETIME=[D106B810:01C8D89E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove explicit lock_kernel() calls and document why the code is safe.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Hi Jon,

Is this sort of patch the next step in the BKL-removal plan?  Is now an
appropriate time to send such things?

If this looks good to you I will do a careful audit of the rest of
drivers/infiniband/core and send you a few more similar patches.

Thanks,
  Roland

 drivers/infiniband/core/uverbs_main.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f839dde..661b3f8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -45,7 +45,6 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/cdev.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -611,23 +610,32 @@ static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 		return file->device->ib_dev->mmap(file->ucontext, vma);
 }
 
+/*
+ * ib_uverbs_open() does not need the BKL:
+ *
+ *  - dev_table[] accesses are protected by map_lock, the
+ *    ib_uverbs_device structures are properly reference counted, and
+ *    everything else is purely local to the file being created, so
+ *    races against other open calls are not a proble;
+ *  - there is no ioctl method to race against;
+ *  - the device is added to dev_table[] as the last part of module
+ *    initialization, the open method will either immediately run
+ *    -ENXIO, or all required initialization will be done.
+ */
 static int ib_uverbs_open(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_device *dev;
 	struct ib_uverbs_file *file;
 	int ret;
 
-	lock_kernel();
 	spin_lock(&map_lock);
 	dev = dev_table[iminor(inode) - IB_UVERBS_BASE_MINOR];
 	if (dev)
 		kref_get(&dev->ref);
 	spin_unlock(&map_lock);
 
-	if (!dev) {
-		unlock_kernel();
+	if (!dev)
 		return -ENXIO;
-	}
 
 	if (!try_module_get(dev->ib_dev->owner)) {
 		ret = -ENODEV;
@@ -648,7 +656,6 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = file;
 
-	unlock_kernel();
 	return 0;
 
 err_module:
@@ -656,7 +663,6 @@ err_module:
 
 err:
 	kref_put(&dev->ref, ib_uverbs_release_dev);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.5.6

