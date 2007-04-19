Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXDSG7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXDSG7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161179AbXDSG7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:59:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46256 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXDSG7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:59:07 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] ibmphp: Convert to use the kthreads API
Date: Thu, 19 Apr 2007 00:55:30 -0600
Message-Id: <11769657722297-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

kthread_run replaces kernel_thread and dameonize.

allow_signal is unnecessary and has been removed.
tid_poll was unused and has been removed.

Cc: Jyoti Shah <jshah@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/hotplug/ibmphp_hpc.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_hpc.c b/drivers/pci/hotplug/ibmphp_hpc.c
index 46abaa8..27e12f1 100644
--- a/drivers/pci/hotplug/ibmphp_hpc.c
+++ b/drivers/pci/hotplug/ibmphp_hpc.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #include "ibmphp.h"
 
@@ -101,7 +102,6 @@ static int to_debug = 0;
 // global variables
 //----------------------------------------------------------------------------
 static int ibmphp_shutdown;
-static int tid_poll;
 static struct mutex sem_hpcaccess;	// lock access to HPC
 static struct semaphore semOperations;	// lock all operations and
 					// access to data structures
@@ -137,7 +137,6 @@ void __init ibmphp_hpc_initvars (void)
 	init_MUTEX_LOCKED (&sem_exit);
 	to_debug = 0;
 	ibmphp_shutdown = 0;
-	tid_poll = 0;
 
 	debug ("%s - Exit\n", __FUNCTION__);
 }
@@ -1060,12 +1059,8 @@ static int hpc_poll_thread (void *data)
 {
 	debug ("%s - Entry\n", __FUNCTION__);
 
-	daemonize("hpc_poll");
-	allow_signal(SIGKILL);
-
 	poll_hpc ();
 
-	tid_poll = 0;
 	debug ("%s - Exit\n", __FUNCTION__);
 	return 0;
 }
@@ -1078,17 +1073,18 @@ static int hpc_poll_thread (void *data)
 *---------------------------------------------------------------------*/
 int __init ibmphp_hpc_start_poll_thread (void)
 {
+	struct task_struct *task;
 	int rc = 0;
 
 	debug ("%s - Entry\n", __FUNCTION__);
 
-	tid_poll = kernel_thread (hpc_poll_thread, NULL, 0);
-	if (tid_poll < 0) {
+	task = kthread_run(hpc_poll_thread, NULL, "hpc_poll");
+	if (IS_ERR(task)) {
 		err ("%s - Error, thread not started\n", __FUNCTION__);
 		rc = -1;
 	}
 
-	debug ("%s - Exit tid_poll[%d] rc[%d]\n", __FUNCTION__, tid_poll, rc);
+	debug ("%s - Exit rc[%d]\n", __FUNCTION__, rc);
 	return rc;
 }
 
-- 
1.5.0.g53756

