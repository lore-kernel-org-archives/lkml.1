Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXLXOYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXLXOYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXLXOYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:24:45 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:57573 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbXLXOYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:24:44 -0500
Date: Mon, 24 Dec 2007 15:24:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mingo@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/38] arch/x86/kernel/io_apic_{64,32}.c: Use time_before,
 time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241523510.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
--- a/arch/x86/kernel/io_apic_32.c	2007-12-21 06:57:18.000000000 +0100
+++ b/arch/x86/kernel/io_apic_32.c	2007-12-23 20:30:39.000000000 +0100
@@ -351,7 +351,8 @@ static void set_ioapic_affinity_irq(unsi
 # include <asm/processor.h>	/* kernel_thread() */
 # include <linux/kernel_stat.h>	/* kstat */
 # include <linux/slab.h>		/* kmalloc() */
-# include <linux/timer.h>	/* time_after() */
+# include <linux/timer.h>
+#include <linux/jiffies.h>	/* time_after() */
  
 #define IRQBALANCE_CHECK_ARCH -999
 #define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
@@ -1900,7 +1901,7 @@ static int __init timer_irq_works(void)
 	 * might have cached one ExtINT interrupt.  Finally, at
 	 * least one tick may be lost due to delays.
 	 */
-	if (jiffies - t1 > 4)
+	if (time_after(jiffies, t1 + 4))
 		return 1;
 
 	return 0;
diff -r -u -p a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
--- a/arch/x86/kernel/io_apic_64.c	2007-12-21 06:57:18.000000000 +0100
+++ b/arch/x86/kernel/io_apic_64.c	2007-12-23 20:30:39.000000000 +0100
@@ -32,6 +32,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/dmar.h>
+#include <linux/jiffies.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -1298,7 +1299,7 @@ static int __init timer_irq_works(void)
 	 */
 
 	/* jiffies wrap? */
-	if (jiffies - t1 > 4)
+	if (time_after(jiffies, t1 + 4))
 		return 1;
 	return 0;
 }
