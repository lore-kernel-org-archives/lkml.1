Return-Path: <linux-kernel-owner+w=401wt.eu-S2993169AbXDSIHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993169AbXDSIHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993171AbXDSIGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:06:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45843 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993168AbXDSIGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:06:01 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] sparc64/power.c: Convert to use the kthread API
Date: Thu, 19 Apr 2007 01:58:39 -0600
Message-Id: <1176969564948-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This starts the sparc64 powerd using kthread_run
instead of kernel_thread and daemonize.  Making the
code slightly simpler and more maintainable.

In addition the unnecessary flush_signals is removed.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/sparc64/kernel/power.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc64/kernel/power.c b/arch/sparc64/kernel/power.c
index 699b24b..03feb8b 100644
--- a/arch/sparc64/kernel/power.c
+++ b/arch/sparc64/kernel/power.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/pm.h>
 #include <linux/syscalls.h>
+#include <linux/kthread.h>
 
 #include <asm/system.h>
 #include <asm/auxio.h>
@@ -81,15 +82,12 @@ static int powerd(void *__unused)
 	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
 	DECLARE_WAITQUEUE(wait, current);
 
-	daemonize("powerd");
-
 	add_wait_queue(&powerd_wait, &wait);
 again:
 	for (;;) {
 		set_task_state(current, TASK_INTERRUPTIBLE);
 		if (button_pressed)
 			break;
-		flush_signals(current);
 		schedule();
 	}
 	__set_current_state(TASK_RUNNING);
@@ -128,7 +126,9 @@ static int __devinit power_probe(struct of_device *op, const struct of_device_id
 	poweroff_method = machine_halt;  /* able to use the standard halt */
 
 	if (has_button_interrupt(irq, op->node)) {
-		if (kernel_thread(powerd, NULL, CLONE_FS) < 0) {
+		struct task_struct *task;
+		task = kthread_urn(powerd, NULL, "powerd");
+		if (IS_ERR(task)) {
 			printk("Failed to start power daemon.\n");
 			return 0;
 		}
-- 
1.5.0.g53756

