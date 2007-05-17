Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXEQBzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXEQBzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXEQBzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:55:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48502 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbXEQBzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:55:41 -0400
Message-Id: <200705170154.l4H1sO07018316@sous-sol.org>
Subject: patch jfs-fix-race-waking-up-jfsio-kernel-thread.patch queued to 2.6.21-stable tree
To: shaggy@linux.vnet.ibm.com, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Cc: stable@kernel.org
From: chrisw@sous-sol.org
Date: Wed, 16 May 2007 18:54:23 -0700
In-Reply-To: <1179287616.8339.8.camel@kleikamp.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: JFS: Fix race waking up jfsIO kernel thread

to the 2.6.21-stable tree.  Its filename is

     jfs-fix-race-waking-up-jfsio-kernel-thread.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Tue May 15 20:55:43 2007
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: stable@kernel.org
Date: Tue, 15 May 2007 22:53:36 -0500
Message-Id: <1179287616.8339.8.camel@kleikamp.austin.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: JFS: Fix race waking up jfsIO kernel thread

It's possible for a journal I/O request to be added to the log_redrive
queue and the jfsIO thread to be awakened after the thread releases
log_redrive_lock but before it sets its state to TASK_INTERRUPTIBLE.

The jfsIO thread should set the state before giving up the spinlock, so
the waking thread will really wake it.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/jfs/jfs_logmgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21.1.orig/fs/jfs/jfs_logmgr.c
+++ linux-2.6.21.1/fs/jfs/jfs_logmgr.c
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


Patches currently in stable-queue which might be from shaggy@linux.vnet.ibm.com are

queue-2.6.21/jfs-fix-race-waking-up-jfsio-kernel-thread.patch
