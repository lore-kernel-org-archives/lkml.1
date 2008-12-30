Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYL3XNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYL3XNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYL3XMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:12:37 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:47152 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbYL3XMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:12:36 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 2/2] Add /proc controls for pdflush threads
To: linux-kernel@vger.kernel.org
Date: Tue, 30 Dec 2008 16:12:33 -0700
Message-ID: <20081230231233.10427.11443.stgit@hermosa.site>
In-Reply-To: <20081230231152.10427.50620.stgit@hermosa.site>
References: <20081230231152.10427.50620.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: \"Peter W. Morreale\" <pmorreale@novell.com>

This patch adds /proc entries to give the admin the ability to
control the minimum and maximum number of pdflush threads.  This allows
finer control of pdflush on both large and small machines.

The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
'/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.
---

Signed-off-by: Peter W Morreale <pmorreale@novell.com>

 include/linux/sysctl.h    |    2 ++
 include/linux/writeback.h |    2 ++
 kernel/sysctl.c           |   16 ++++++++++++++++
 mm/pdflush.c              |   19 ++++++++++++++-----
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index d0437f3..9921e62 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -205,6 +205,8 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_NR_PDFLUSH_THREADS_MAX=36, /* nr_pdflush_threads_max */
+	VM_NR_PDFLUSH_THREADS_MIN=37, /* nr_pdflush_threads_min */
 };
 
 
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
index 50ec088..6dae777 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -948,6 +948,22 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= VM_NR_PDFLUSH_THREADS_MIN,
+		.procname	= "nr_pdflush_threads_min",
+		.data		= &nr_pdflush_threads_min,
+		.maxlen		= sizeof nr_pdflush_threads_min,
+		.mode		= 0644 /* read-only*/,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_NR_PDFLUSH_THREADS_MAX,
+		.procname	= "nr_pdflush_threads_max",
+		.data		= &nr_pdflush_threads_max,
+		.maxlen		= sizeof nr_pdflush_threads_max,
+		.mode		= 0644 /* read-only*/,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_SWAPPINESS,
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 481680f..9a6f835 100644
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
@@ -133,7 +141,8 @@ static int __pdflush(struct pdflush_work *my_work)
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
 			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+				if (nr_pdflush_threads <
+						nr_pdflush_threads_max) {
 					nr_pdflush_threads++;
 					spin_unlock_irq(&pdflush_lock);
 					start_one_pdflush_thread();
@@ -150,7 +159,7 @@ static int __pdflush(struct pdflush_work *my_work)
 		 */
 		if (list_empty(&pdflush_list))
 			continue;
-		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
+		if (nr_pdflush_threads <= nr_pdflush_threads_min)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
 		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
@@ -246,9 +255,9 @@ static int __init pdflush_init(void)
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

