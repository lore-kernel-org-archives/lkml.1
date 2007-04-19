Return-Path: <linux-kernel-owner+w=401wt.eu-S2993189AbXDSIK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993189AbXDSIK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993198AbXDSIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:10:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33929 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993192AbXDSIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:10:13 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc pseries eeh: Convert to kthread API
Date: Thu, 19 Apr 2007 01:58:45 -0600
Message-Id: <11769695763104-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of eehd to use kthread_run
not a combination of kernel_thread and daemonize.  Making
the code slightly simpler and more maintainable.

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/powerpc/platforms/pseries/eeh_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_event.c b/arch/powerpc/platforms/pseries/eeh_event.c
index 221dec8..fe7c2e0 100644
--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <asm/eeh_event.h>
 #include <asm/ppc-pci.h>
 
@@ -59,7 +60,6 @@ static int eeh_event_handler(void * dummy)
 	struct eeh_event	*event;
 	struct pci_dn *pdn;
 
-	daemonize ("eehd");
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	spin_lock_irqsave(&eeh_eventlist_lock, flags);
@@ -105,7 +105,7 @@ static int eeh_event_handler(void * dummy)
  */
 static void eeh_thread_launcher(struct work_struct *dummy)
 {
-	if (kernel_thread(eeh_event_handler, NULL, CLONE_KERNEL) < 0)
+	if (IS_ERR(kthread_run(eeh_event_handler, NULL, "eehd")))
 		printk(KERN_ERR "Failed to start EEH daemon\n");
 }
 
-- 
1.5.0.g53756

