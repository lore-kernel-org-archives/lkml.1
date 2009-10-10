Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbZJJPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbZJJPiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761856AbZJJPh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:58 -0400
Received: from www.tglx.de ([62.245.132.106]:55426 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761955AbZJJPh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:57 -0400
Message-Id: <20091010153349.458892757@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/28] mem_class: Drop the bkl from memory_open()
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline;
	filename=mem_class-drop-the-bkl-from-memory_open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <1255113062-5835-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/mem.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/drivers/char/mem.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mem.c
+++ linux-2.6-tip/drivers/char/mem.c
@@ -26,7 +26,6 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -892,29 +891,23 @@ static int memory_open(struct inode *ino
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


