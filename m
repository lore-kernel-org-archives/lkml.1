Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbZJNPte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbZJNPte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934575AbZJNPtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:49:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:34115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934648AbZJNPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:49:31 -0400
Date: Wed, 14 Oct 2009 15:48:34 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
References: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] mem_class: Drop the bkl from memory_open()
Message-ID: <tip-205153aa40b7fb36dc7fe76c1798584ace55b288@git.kernel.org>
Git-Commit-ID: 205153aa40b7fb36dc7fe76c1798584ace55b288
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:48:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  205153aa40b7fb36dc7fe76c1798584ace55b288
Gitweb:     http://git.kernel.org/tip/205153aa40b7fb36dc7fe76c1798584ace55b288
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 9 Oct 2009 20:31:02 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:49 +0200

mem_class: Drop the bkl from memory_open()

The generic open callback for the mem class devices is "protected" by
the bkl.

Let's look at the datas manipulated inside memory_open:

- inode and file: safe
- the devlist: safe because it is constant
- the memdev classes inside this array are safe too (constant)

After we find out which memdev file operation we need to use, we call
its open callback. Depending on the targeted memdev, we call either
open_port() that doesn't manipulate any racy data (just a capable()
check), or we call nothing.

So it's safe to remove the big kernel lock there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/mem.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..ad82ec9 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -26,7 +26,6 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -892,29 +891,23 @@ static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
 	const struct memdev *dev;
-	int ret = -ENXIO;
-
-	lock_kernel();
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
-		goto out;
+		return -ENXIO;
 
 	dev = &devlist[minor];
 	if (!dev->fops)
-		goto out;
+		return -ENXIO;
 
 	filp->f_op = dev->fops;
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
 	if (dev->fops->open)
-		ret = dev->fops->open(inode, filp);
-	else
-		ret = 0;
-out:
-	unlock_kernel();
-	return ret;
+		return dev->fops->open(inode, filp);
+
+	return 0;
 }
 
 static const struct file_operations memory_fops = {
