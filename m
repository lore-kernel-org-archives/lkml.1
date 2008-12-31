Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYLaTK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYLaTK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYLaTKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:10:19 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:38237 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbYLaTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:10:17 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 2/2] Add /proc controls for pdflush threads
To: pmorreale@novell.com, akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, spamtrap@knobisoft.de
Date: Wed, 31 Dec 2008 12:10:13 -0700
Message-ID: <20081231191013.30792.64706.stgit@hermosa.site>
In-Reply-To: <20081231190755.30792.24205.stgit@hermosa.site>
References: <20081231190755.30792.24205.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds /proc entries to give the admin the ability to
control the minimum and maximum number of pdflush threads.  This allows
finer control of pdflush on both large and small machines.

The rational is simply one size does not fit all.  Admins on large
and/or small systems may want to tune the min/max pdflush thread count
to best suit their needs.  Right now the min/max is hardcoded to 2/8.
While probably a fair estimate for smaller machines, large machines with
large numbers of CPUs and large numbers of filesystems/block devices may
benefit from larger numbers of threads working on different block
devices.

Even if the background flushing algorithm is radically changed, it is
still likely that multiple threads will be involved and admins would
still desire finer control on the min/max other than to have to
recompile the kernel.

The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
'/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.

The minimum value for nr_pdflush_threads_min is 1 and the maximum value is the
current value of nr_pdflush_threads_max.  This minimum is required since
additional thread creation is performed in a pdflush thread itself.

The minimum value for nr_pdflush_threads_max is the current value of
nr_pdflush_threads_min and the maximum value can be 1000.

Documentation/sysctl/vm.txt is also updated.
---

Signed-off-by: Peter W Morreale <pmorreale@novell.com>

 Documentation/sysctl/vm.txt |   28 ++++++++++++++++++++++++++++
 include/linux/writeback.h   |    2 ++
 kernel/sysctl.c             |   25 +++++++++++++++++++++++--
 mm/pdflush.c                |   19 ++++++++++++++-----
 4 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index d79eeda..c2a257a 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -22,6 +22,8 @@ Currently, these files are in /proc/sys/vm:
 - dirty_background_ratio
 - dirty_expire_centisecs
 - dirty_writeback_centisecs
+- nr_pdflush_threads_min
+- nr_pdflush_threads_max
 - highmem_is_dirtyable   (only if CONFIG_HIGHMEM set)
 - max_map_count
 - min_free_kbytes
@@ -50,6 +52,32 @@ See Documentation/filesystems/proc.txt
 
 ==============================================================
 
+nr_pdflush_threads_min
+
+This value controls the minimum number of pdflush threads. 
+
+At boot time, the kernel will create and maintain 'nr_pdflush_threads_min'
+threads for the kernel's lifetime.  
+
+The default value is 2.  The minimum value you can specify is 1, and 
+the maximum value is the current setting of 'nr_pdflush_threads_max'.
+
+See 'nr_pdflush_threads_max' below for more information.
+
+==============================================================
+
+nr_pdflush_threads_max
+
+This value controls the maximum number of pdflush threads that can be
+created.  The pdflush algorithm will create a new pdflush thread (up to
+this maximum) if no pdflush threads have been available for >= 1 second.  
+
+The default value is 8.  The minimum value you can specify is the
+current value of 'nr_pdflush_threads_min' and the
+maximum is 1000. 
+
+==============================================================
+
 overcommit_memory:
 
 This value contains a flag that enables memory overcommitment.
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 12b15c5..ee566a0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -150,6 +150,8 @@ void writeback_set_ratelimit(void);
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
+extern int nr_pdflush_threads_max; /* Global so it can be exported to sysctl */
+extern int nr_pdflush_threads_min; /* Global so it can be exported to sysctl */
 
 
 #endif		/* WRITEBACK_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 50ec088..96ba6b3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -88,9 +88,8 @@ extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_DETECT_SOFTLOCKUP)
 static int one = 1;
-#endif
+static int one_thousand = 1000;
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
@@ -948,6 +947,28 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_pdflush_threads_min",
+		.data		= &nr_pdflush_threads_min,
+		.maxlen		= sizeof nr_pdflush_threads_min,
+		.mode		= 0644 /* read-write */,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &nr_pdflush_threads_max,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_pdflush_threads_max",
+		.data		= &nr_pdflush_threads_max,
+		.maxlen		= sizeof nr_pdflush_threads_max,
+		.mode		= 0644 /* read-write */,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &nr_pdflush_threads_min,
+		.extra2		= &one_thousand,
+	},
+	{
 		.ctl_name	= VM_SWAPPINESS,
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 80745c7..1409649 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -58,6 +58,14 @@ static DEFINE_SPINLOCK(pdflush_lock);
 int nr_pdflush_threads = 0;
 
 /*
+ * The max/min number of pdflush threads. R/W by sysctl at 
+ * /proc/sys/vm/nr_pdflush_threads_max 
+ */
+int nr_pdflush_threads_max = MAX_PDFLUSH_THREADS;
+int nr_pdflush_threads_min = MIN_PDFLUSH_THREADS;
+
+
+/*
  * The time at which the pdflush thread pool last went empty
  */
 static unsigned long last_empty_jifs;
@@ -68,7 +76,7 @@ static unsigned long last_empty_jifs;
  * Thread pool management algorithm:
  * 
  * - The minimum and maximum number of pdflush instances are bound
- *   by MIN_PDFLUSH_THREADS and MAX_PDFLUSH_THREADS.
+ *   by nr_pdflush_threads_min and nr_pdflush_threads_max.
  * 
  * - If there have been no idle pdflush instances for 1 second, create
  *   a new one.
@@ -135,7 +143,8 @@ static int __pdflush(struct pdflush_work *my_work)
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
 			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+				if (nr_pdflush_threads <
+						nr_pdflush_threads_max) {
 					last_empty_jifs = jiffies;
 					nr_pdflush_threads++;
 					spin_unlock_irq(&pdflush_lock);
@@ -153,7 +162,7 @@ static int __pdflush(struct pdflush_work *my_work)
 		 */
 		if (list_empty(&pdflush_list))
 			continue;
-		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
+		if (nr_pdflush_threads <= nr_pdflush_threads_min)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
 		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
@@ -249,9 +258,9 @@ static int __init pdflush_init(void)
 	 * Pre-set nr_pdflush_threads...  If we fail to create, 
 	 * the count will be decremented.
 	 */
-	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
+	nr_pdflush_threads = nr_pdflush_threads_min;
 
-	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
+	for (i = 0; i < nr_pdflush_threads_min; i++)
 		start_one_pdflush_thread();
 	return 0;
 }

