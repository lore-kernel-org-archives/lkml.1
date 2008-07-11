Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYGKUzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYGKUzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYGKUzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:55:00 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:61013 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGKUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:54:59 -0400
X-IronPort-AV: E=Sophos;i="4.30,347,1212364800"; 
   d="scan'208";a="52050109"
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [PATCH for bkl-removal v2] IB/umad: BKL is not needed for ib_umad_open()
References: <aday748mad3.fsf@cisco.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 11 Jul 2008 13:54:40 -0700
In-Reply-To: <aday748mad3.fsf@cisco.com> (Roland Dreier's message of "Fri, 11
	Jul 2008 13:31:04 -0700")
Message-ID: <adaod54m99r.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jul 2008 20:54:41.0360 (UTC) FILETIME=[56F6AD00:01C8E398]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove explicit lock_kernel() calls and document why the code is safe.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Resending with s/proble/problem/

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 260b3df..d31e5bb 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -47,7 +47,6 @@
 #include <linux/kref.h>
 #include <linux/compat.h>
 #include <linux/semaphore.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -778,23 +777,33 @@ static long ib_umad_compat_ioctl(struct file *filp, unsigned int cmd,
 }
 #endif
 
+/*
+ * ib_umad_open() does not need the BKL:
+ *
+ *  - umad_port[] accesses are protected by port_lock, the
+ *    ib_umad_port structures are properly reference counted, and
+ *    everything else is purely local to the file being created, so
+ *    races against other open calls are not a problem;
+ *  - the ioctl method does not affect any global state outside of the
+ *    file structure being operated on;
+ *  - the port is added to umad_port[] as the last part of module
+ *    initialization so the open method will either immediately run
+ *    -ENXIO, or all required initialization will be done.
+ */
 static int ib_umad_open(struct inode *inode, struct file *filp)
 {
 	struct ib_umad_port *port;
 	struct ib_umad_file *file;
 	int ret = 0;
 
-	lock_kernel();
 	spin_lock(&port_lock);
 	port = umad_port[iminor(inode) - IB_UMAD_MINOR_BASE];
 	if (port)
 		kref_get(&port->umad_dev->ref);
 	spin_unlock(&port_lock);
 
-	if (!port) {
-		unlock_kernel();
+	if (!port)
 		return -ENXIO;
-	}
 
 	mutex_lock(&port->file_mutex);
 
@@ -823,7 +832,6 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 
 out:
 	mutex_unlock(&port->file_mutex);
-	unlock_kernel();
 	return ret;
 }
 
