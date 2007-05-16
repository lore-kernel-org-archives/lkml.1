Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbXEPDxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbXEPDxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXEPDxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:53:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47730 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbXEPDxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:53:46 -0400
Subject: [PATCH -stable] JFS: Fix race waking up jfsIO kernel thread
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 May 2007 22:53:36 -0500
Message-Id: <1179287616.8339.8.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a deadlock that has been reported by three different
users on recent kernels.  The problem exists on mainline kernels since
2.6.18.  It is included in linux-2.6.22-rc1.

JFS: Fix race waking up jfsIO kernel thread

It's possible for a journal I/O request to be added to the log_redrive
queue and the jfsIO thread to be awakened after the thread releases
log_redrive_lock but before it sets its state to TASK_INTERRUPTIBLE.

The jfsIO thread should set the state before giving up the spinlock, so
the waking thread will really wake it.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux-2.6.21.1/fs/jfs/jfs_logmgr.c linux/fs/jfs/jfs_logmgr.c
--- linux-2.6.21.1/fs/jfs/jfs_logmgr.c	2007-04-27 16:49:26.000000000 -0500
+++ linux/fs/jfs/jfs_logmgr.c	2007-05-15 22:39:31.000000000 -0500
@@ -2354,12 +2354,13 @@ int jfsIOWait(void *arg)
 			lbmStartIO(bp);
 			spin_lock_irq(&log_redrive_lock);
 		}
-		spin_unlock_irq(&log_redrive_lock);
 
 		if (freezing(current)) {
+			spin_unlock_irq(&log_redrive_lock);
 			refrigerator();
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_irq(&log_redrive_lock);
 			schedule();
 			current->state = TASK_RUNNING;
 		}

-- 
David Kleikamp
IBM Linux Technology Center

