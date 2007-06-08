Return-Path: <linux-kernel-owner+w=401wt.eu-S938082AbXFHHSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938082AbXFHHSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937716AbXFHHRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33108 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937142AbXFHHRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:02 -0400
Message-Id: <20070608071538.889815000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/32] JFS: Fix race waking up jfsIO kernel thread
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jfs/jfs_logmgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20.13.orig/fs/jfs/jfs_logmgr.c
+++ linux-2.6.20.13/fs/jfs/jfs_logmgr.c
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
