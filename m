Return-Path: <linux-kernel-owner+w=401wt.eu-S1161196AbXDSG72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196AbXDSG72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDSG72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:59:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46261 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161196AbXDSG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:59:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] cpci_hotplug: Convert to use the kthread API
Date: Thu, 19 Apr 2007 00:55:29 -0600
Message-Id: <11769657702107-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

kthread_run replaces the kernel_thread and  daemonize calls
during thread startup.

Calls to signal_pending were also removed as it is currently
impossible for the cpci_hotplug thread to receive signals.

CC: Scott Murray <scottm@somanetworks.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/hotplug/cpci_hotplug_core.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 6845515..c620c7e 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/smp_lock.h>
+#include <linux/kthread.h>
 #include <asm/atomic.h>
 #include <linux/delay.h>
 #include "cpci_hotplug.h"
@@ -521,17 +522,13 @@ event_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_eventd");
-	unlock_kernel();
-
 	dbg("%s - event thread started", __FUNCTION__);
 	while (1) {
 		dbg("event thread sleeping");
 		down_interruptible(&event_semaphore);
 		dbg("event thread woken, thread_finished = %d",
 		    thread_finished);
-		if (thread_finished || signal_pending(current))
+		if (thread_finished)
 			break;
 		do {
 			rc = check_slots();
@@ -562,12 +559,8 @@ poll_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_polld");
-	unlock_kernel();
-
 	while (1) {
-		if (thread_finished || signal_pending(current))
+		if (thread_finished)
 			break;
 		if (controller->ops->query_enum()) {
 			do {
@@ -592,7 +585,7 @@ poll_thread(void *data)
 static int
 cpci_start_thread(void)
 {
-	int pid;
+	struct task_struct *task;
 
 	/* initialize our semaphores */
 	init_MUTEX_LOCKED(&event_semaphore);
@@ -600,14 +593,13 @@ cpci_start_thread(void)
 	thread_finished = 0;
 
 	if (controller->irq)
-		pid = kernel_thread(event_thread, NULL, 0);
+		task = kthread_run(event_thread, NULL, "cpci_hp_eventd");
 	else
-		pid = kernel_thread(poll_thread, NULL, 0);
-	if (pid < 0) {
+		task = kthread_run(poll_thread, NULL, "cpci_hp_polld");
+	if (IS_ERR(task)) {
 		err("Can't start up our thread");
 		return -1;
 	}
-	dbg("Our thread pid = %d", pid);
 	return 0;
 }
 
-- 
1.5.0.g53756

