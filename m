Return-Path: <linux-kernel-owner+w=401wt.eu-S1764921AbXEUTkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764921AbXEUTkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXEUT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:26:52 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35764 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbXEUT0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:26:50 -0400
Message-Id: <20070521191755.153293000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [patch 64/69] JFS: Fix race waking up jfsIO kernel thread
Content-Disposition: inline; filename=jfs-fix-race-waking-up-jfsio-kernel-thread.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

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

-- 
