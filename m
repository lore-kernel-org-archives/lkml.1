Return-Path: <linux-kernel-owner+w=401wt.eu-S2993133AbXDSHFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993133AbXDSHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993144AbXDSHFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:05:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34609 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993141AbXDSHFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:05:06 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] s390/scsi/zfcp_erp: Convert to use the kthread API
Date: Thu, 19 Apr 2007 00:55:37 -0600
Message-Id: <11769657811624-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

Modify zfcperp%s to be started with kthread_run not
a combination of kernel_thread, daemonize and siginitsetinv
making the code slightly simpler and more maintainable.

Cc: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/s390/scsi/zfcp_erp.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 66c0b09..f26536d 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -21,6 +21,7 @@
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
 
+#include <linux/kthread.h>
 #include "zfcp_ext.h"
 
 static int zfcp_erp_adisc(struct zfcp_port *);
@@ -985,12 +986,13 @@ static void zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
 int
 zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
+	struct task_struct *task;
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 
-	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
-	if (retval < 0) {
+	task = kthread_run(zfcp_erp_thread, adapter,
+			   "zfcperp%s", zfcp_get_busid_by_adapter(adapter));
+	if (IS_ERR(task)) {
 		ZFCP_LOG_NORMAL("error: creation of erp thread failed for "
 				"adapter %s\n",
 				zfcp_get_busid_by_adapter(adapter));
@@ -1002,7 +1004,7 @@ zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
 		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
 	}
 
-	return (retval < 0);
+	return IS_ERR(task);
 }
 
 /*
@@ -1054,9 +1056,6 @@ zfcp_erp_thread(void *data)
 	struct zfcp_erp_action *erp_action;
 	unsigned long flags;
 
-	daemonize("zfcperp%s", zfcp_get_busid_by_adapter(adapter));
-	/* Block all signals */
-	siginitsetinv(&current->blocked, 0);
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 	debug_text_event(adapter->erp_dbf, 5, "a_th_run");
 	wake_up(&adapter->erp_thread_wqh);
-- 
1.5.0.g53756

