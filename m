Return-Path: <linux-kernel-owner+w=401wt.eu-S2993119AbXDSHEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993119AbXDSHEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993138AbXDSHDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:03:17 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34584 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993119AbXDSHDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:03:02 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] cpqphp: Convert to use the kthread API
Date: Thu, 19 Apr 2007 00:55:31 -0600
Message-Id: <1176965773676-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch changes cpqphp to use kthread_run and not
kernel_thread and daemonize to startup and setup
the cpqphp thread.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/hotplug/cpqphp_ctrl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index 79ff6b4..c2c06c4 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -37,6 +37,7 @@
 #include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/kthread.h>
 #include "cpqphp.h"
 
 static u32 configure_new_device(struct controller* ctrl, struct pci_func *func,
@@ -1746,10 +1747,6 @@ static void pushbutton_helper_thread(unsigned long data)
 static int event_thread(void* data)
 {
 	struct controller *ctrl;
-	lock_kernel();
-	daemonize("phpd_event");
-	
-	unlock_kernel();
 
 	while (1) {
 		dbg("!!!!event_thread sleeping\n");
@@ -1771,7 +1768,7 @@ static int event_thread(void* data)
 
 int cpqhp_event_start_thread(void)
 {
-	int pid;
+	struct task_struct *task;
 
 	/* initialize our semaphores */
 	init_MUTEX(&delay_sem);
@@ -1779,12 +1776,11 @@ int cpqhp_event_start_thread(void)
 	init_MUTEX_LOCKED(&event_exit);
 	event_finished=0;
 
-	pid = kernel_thread(event_thread, NULL, 0);
-	if (pid < 0) {
+	task = kthread_run(event_thread, NULL, "phpd_event");
+	if (IS_ERR(task)) {
 		err ("Can't start up our event thread\n");
 		return -1;
 	}
-	dbg("Our event thread pid = %d\n", pid);
 	return 0;
 }
 
-- 
1.5.0.g53756

