Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXDSG7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXDSG7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161162AbXDSG7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:59:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46250 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161151AbXDSG67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:58:59 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] i386 balance_irq: Convert to the kthread api.
Date: Thu, 19 Apr 2007 00:55:26 -0600
Message-Id: <11769657621531-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just trivial converts from calling kernel_thread and daemonize
to just calling kthread_run.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/io_apic.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 24ac67c..84b412a 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -34,6 +34,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -660,8 +661,6 @@ static int balanced_irq(void *unused)
 	unsigned long prev_balance_time = jiffies;
 	long time_remaining = balanced_irq_interval;
 
-	daemonize("kirqd");
-	
 	/* push everything to CPU 0 to give us a starting point.  */
 	for (i = 0 ; i < NR_IRQS ; i++) {
 		irq_desc[i].pending_mask = cpumask_of_cpu(0);
@@ -721,7 +720,7 @@ static int __init balanced_irq_init(void)
 	}
 	
 	printk(KERN_INFO "Starting balanced_irq\n");
-	if (kernel_thread(balanced_irq, NULL, CLONE_KERNEL) >= 0) 
+	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
 		return 0;
 	else 
 		printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
-- 
1.5.0.g53756

