Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYJETLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYJETLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbYJETKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:10:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:33002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbYJETKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:10:34 -0400
Date: Sun, 5 Oct 2008 12:09:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: corruption check: run the corruption checks from a
 work queue
Message-ID: <20081005120903.2dc262f4@infradead.org>
In-Reply-To: <20081005120705.02492d44@infradead.org>
References: <20081005120705.02492d44@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 22 Sep 2008 13:42:15 -0700
Subject: [PATCH] x86: corruption check: run the corruption checks from a work queue

the periodic corruption checks are better off run from a work queue; there's
nothing time critical about them and this way the amount of
interrupt-context work is reduced.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/check.c |   27 +++++++++++++++++----------
 arch/x86/mm/init_32.c   |    2 --
 arch/x86/mm/init_64.c   |    2 --
 include/linux/kernel.h  |    5 -----
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 5056703..55eed17 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -1,6 +1,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
-
+#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <asm/e820.h>
 #include <asm/proto.h>
 
@@ -108,13 +109,14 @@ void __init setup_bios_corruption_check(void)
 	update_e820();
 }
 
-static struct timer_list periodic_check_timer;
 
 void check_for_bios_corruption(void)
 {
 	int i;
 	int corruption = 0;
 
+	printk("dot\n");
+
 	if (!memory_corruption_check)
 		return;
 
@@ -135,24 +137,29 @@ void check_for_bios_corruption(void)
 	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
 }
 
-static void periodic_check_for_corruption(unsigned long data)
+static void check_corruption(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(bios_check_work, check_corruption);
+
+static void check_corruption(struct work_struct *dummy)
 {
 	check_for_bios_corruption();
-	mod_timer(&periodic_check_timer,
-		round_jiffies(jiffies + corruption_check_period*HZ));
+	schedule_delayed_work(&bios_check_work,
+		round_jiffies_relative(corruption_check_period*HZ)); 
 }
 
-void start_periodic_check_for_corruption(void)
+static int start_periodic_check_for_corruption(void)
 {
 	if (!memory_corruption_check || corruption_check_period == 0)
-		return;
+		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
 	       corruption_check_period);
 
-	init_timer(&periodic_check_timer);
-	periodic_check_timer.function = &periodic_check_for_corruption;
-	periodic_check_for_corruption(0);
+	/* First time we run the checks right away */
+	schedule_delayed_work(&bios_check_work, 0);
+	return 0;
 }
+
+module_init(start_periodic_check_for_corruption);
 #endif
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index b646e5b..63b71d3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -970,8 +970,6 @@ void __init mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
-	start_periodic_check_for_corruption();
-
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a624017..747f6c9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -905,8 +905,6 @@ void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
 
-	start_periodic_check_for_corruption();
-
 	pci_iommu_alloc();
 
 	/* clear_bss() already clear the empty_zero_page */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a5afee2..b39c7ef 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -260,15 +260,10 @@ extern int root_mountflags;
  * able to scatter it around anywhere in the kernel.
  */
 void check_for_bios_corruption(void);
-void start_periodic_check_for_corruption(void);
 #else
 static inline void check_for_bios_corruption(void)
 {
 }
-
-static inline void start_periodic_check_for_corruption(void)
-{
-}
 #endif
 
 /* Values used for system_state */
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
