Return-Path: <linux-kernel-owner+w=401wt.eu-S966653AbXEGUcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653AbXEGUcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966647AbXEGUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:32:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:11369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966613AbXEGUck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:32:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="84696299"
Date: Mon, 7 May 2007 13:30:16 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 3/8] kernel irqbalance fixes to handle IRQs with balancing disabled
Message-ID: <20070507203015.GC3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



kernel irq balance code moves IRQs around without checking whether
they are movable or not. Add those checks.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-tolkml/arch/i386/kernel/io_apic.c
===================================================================
--- linux-2.6.21-tolkml.orig/arch/i386/kernel/io_apic.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-tolkml/arch/i386/kernel/io_apic.c	2007-05-07 09:54:50.000000000 -0700
@@ -446,7 +446,7 @@
 	Dprintk("Rotating IRQs among CPUs.\n");
 	for_each_online_cpu(i) {
 		for (j = 0; j < NR_IRQS; j++) {
-			if (!irq_desc[j].action)
+			if (!irq_desc[j].action || irq_balancing_disabled(j))
 				continue;
 			/* Is it a significant load ?  */
 			if (IRQ_DELTA(CPU_TO_PACKAGEINDEX(i),j) <
@@ -582,7 +582,7 @@
 	selected_irq = -1;
 	for (j = 0; j < NR_IRQS; j++) {
 		/* Is this an active IRQ? */
-		if (!irq_desc[j].action)
+		if (!irq_desc[j].action || irq_balancing_disabled(j))
 			continue;
 		if (imbalance <= IRQ_DELTA(max_loaded,j))
 			continue;
@@ -665,6 +665,9 @@
 	
 	/* push everything to CPU 0 to give us a starting point.  */
 	for (i = 0 ; i < NR_IRQS ; i++) {
+		if (irq_balancing_disabled(i))
+			continue;
+
 		irq_desc[i].pending_mask = cpumask_of_cpu(0);
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
