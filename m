Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXLDWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXLDWBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXLDWBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:01:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14432 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603AbXLDWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:01:22 -0500
Message-Id: <20071204215007.410427623@mvista.com>
References: <20071204215003.291002606@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Dec 2007 00:00:03 -0800
Subject: [PATCH 3/3] unix98 allocated_ptys_lock semaphore to mutex
References: <20071204214954.656363725@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=unix98-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the unix98 allocated_ptys_lock to a mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/tty_io.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.23/drivers/char/tty_io.c
===================================================================
--- linux-2.6.23.orig/drivers/char/tty_io.c
+++ linux-2.6.23/drivers/char/tty_io.c
@@ -138,7 +138,7 @@ EXPORT_SYMBOL(tty_mutex);
 extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
 extern int pty_limit;		/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_MUTEX(allocated_ptys_lock);
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
@@ -2571,9 +2571,9 @@ static void release_dev(struct file * fi
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */
 	if (devpts) {
-		down(&allocated_ptys_lock);
+		mutex_lock(&allocated_ptys_lock);
 		idr_remove(&allocated_ptys, idx);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 	}
 #endif
 
@@ -2737,24 +2737,24 @@ static int ptmx_open(struct inode * inod
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -ENOMEM;
 	}
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			return -ENOMEM;
 		return -EIO;
 	}
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 
 	mutex_lock(&tty_mutex);
 	retval = init_dev(ptm_driver, index, &tty);
@@ -2781,9 +2781,9 @@ out1:
 	release_dev(filp);
 	return retval;
 out:
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, index);
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 	return retval;
 }
 #endif

-- 
