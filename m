Return-Path: <linux-kernel-owner+w=401wt.eu-S1423432AbXD3Pvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423432AbXD3Pvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423485AbXD3PuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423432AbXD3PuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:05 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: ebiederm@xmission.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [31/34] i386: convert to the kthread API
Message-Id: <20070430155004.B340D151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Eric W. Biederman" <ebiederm@xmission.com>

This patch just trivial converts from calling kernel_thread and daemonize
to just calling kthread_run.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -35,6 +35,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -661,8 +662,6 @@ static int balanced_irq(void *unused)
 	unsigned long prev_balance_time = jiffies;
 	long time_remaining = balanced_irq_interval;
 
-	daemonize("kirqd");
-	
 	/* push everything to CPU 0 to give us a starting point.  */
 	for (i = 0 ; i < NR_IRQS ; i++) {
 		irq_desc[i].pending_mask = cpumask_of_cpu(0);
@@ -722,10 +721,9 @@ static int __init balanced_irq_init(void
 	}
 	
 	printk(KERN_INFO "Starting balanced_irq\n");
-	if (kernel_thread(balanced_irq, NULL, CLONE_KERNEL) >= 0) 
+	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
 		return 0;
-	else 
-		printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
+	printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
 failed:
 	for_each_possible_cpu(i) {
 		kfree(irq_cpu_data[i].irq_delta);
