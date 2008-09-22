Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYIVVFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYIVVFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYIVVE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:04:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:33562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYIVVE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:04:56 -0400
Date: Mon, 22 Sep 2008 14:05:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/2] corruption check: run the corruption checks from a work
 queue
Message-ID: <20080922140503.5f3a3db3@infradead.org>
In-Reply-To: <20080922140402.166de1ba@infradead.org>
References: <20080920203544.53a5148e@infradead.org>
	<20080922140402.166de1ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
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
Subject: [PATCH] corruption check: run the corruption checks from a work queue

the corruption checks are better off run from a work queue; there's nothing
time critical about them and this way the amount of interrupt-context work
is reduced (including interrupt latency)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/corruptioncheck.c |   21 +++++++++++++++++----
 arch/x86/mm/init_32.c             |    2 --
 arch/x86/mm/init_64.c             |    2 --
 include/linux/kernel.h            |    2 +-
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/corruptioncheck.c b/arch/x86/kernel/corruptioncheck.c
index a7e80ed..cd89219 100644
--- a/arch/x86/kernel/corruptioncheck.c
+++ b/arch/x86/kernel/corruptioncheck.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -135,22 +136,34 @@ void check_for_bios_corruption(void)
 	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
 }
 
-static void periodic_check_for_corruption(unsigned long data)
+static void check_corruption(struct work_struct *dummy)
 {
 	check_for_bios_corruption();
+}
+
+static void periodic_check_for_corruption(unsigned long data)
+{
+	static DECLARE_WORK(corruptioncheck_work, check_corruption);
+	schedule_work(&corruptioncheck_work);
 	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
 }
 
-void start_periodic_check_for_corruption(void)
+
+
+int start_periodic_check_for_corruption(void)
 {
 	if (!memory_corruption_check || corruption_check_period == 0)
-		return;
+		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
 	       corruption_check_period);
 
 	init_timer(&periodic_check_timer);
 	periodic_check_timer.function = &periodic_check_for_corruption;
-	periodic_check_for_corruption(0);
+	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
+//	periodic_check_for_corruption(0);
+	return 0;
 }
+
+module_init(start_periodic_check_for_corruption);
 #endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index b4c3a92..16ea9d0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -905,8 +905,6 @@ void __init mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
-	start_periodic_check_for_corruption();
-
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b565721..b65492e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -822,8 +822,6 @@ void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
 
-	start_periodic_check_for_corruption();
-
 	pci_iommu_alloc();
 
 	/* clear_bss() already clear the empty_zero_page */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a5afee2..01085d2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -260,7 +260,7 @@ extern int root_mountflags;
  * able to scatter it around anywhere in the kernel.
  */
 void check_for_bios_corruption(void);
-void start_periodic_check_for_corruption(void);
+int start_periodic_check_for_corruption(void);
 #else
 static inline void check_for_bios_corruption(void)
 {
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
