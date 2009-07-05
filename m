Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZGEJY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZGEJY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZGEJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:24:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53824 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZGEJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:24:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 3/5] Show kernel stack usage to /proc/meminfo and OOM log
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090705181400.08F1.A69D9226@jp.fujitsu.com>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com>
Message-Id: <20090705182409.08FC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 18:24:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log

if the system have a lot of thread, kernel stack consume unignorable large size
memory. IOW, it make a lot of unaccountable memory.
Tons unaccountable memory bring to harder analyse memory related trouble.

Then, kernel stack account is useful.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/base/node.c    |    3 +++
 fs/proc/meminfo.c      |    2 ++
 include/linux/mmzone.h |    3 ++-
 kernel/fork.c          |   11 +++++++++++
 mm/page_alloc.c        |    3 +++
 mm/vmstat.c            |    1 +
 6 files changed, 22 insertions(+), 1 deletion(-)

Index: b/fs/proc/meminfo.c
===================================================================
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -84,6 +84,7 @@ static int meminfo_proc_show(struct seq_
 		"Slab:           %8lu kB\n"
 		"SReclaimable:   %8lu kB\n"
 		"SUnreclaim:     %8lu kB\n"
+		"KernelStack:    %8lu kB\n"
 		"PageTables:     %8lu kB\n"
 #ifdef CONFIG_QUICKLIST
 		"Quicklists:     %8lu kB\n"
@@ -128,6 +129,7 @@ static int meminfo_proc_show(struct seq_
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
+		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
 		K(global_page_state(NR_PAGETABLE)),
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
Index: b/include/linux/mmzone.h
===================================================================
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -94,10 +94,11 @@ enum zone_stat_item {
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_KERNEL_STACK,
+	/* Second 128 byte cacheline */
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
-	/* Second 128 byte cacheline */
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
Index: b/kernel/fork.c
===================================================================
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -137,9 +137,17 @@ struct kmem_cache *vm_area_cachep;
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
+static void account_kernel_stack(struct thread_info *ti, int account)
+{
+	struct zone *zone = page_zone(virt_to_page(ti));
+
+	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
+}
+
 void free_task(struct task_struct *tsk)
 {
 	prop_local_destroy_single(&tsk->dirties);
+	account_kernel_stack(tsk->stack, -1);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
@@ -255,6 +263,9 @@ static struct task_struct *dup_task_stru
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+
+	account_kernel_stack(ti, 1);
+
 	return tsk;
 
 out:
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2158,6 +2158,7 @@ void show_free_areas(void)
 			" mapped:%lukB"
 			" slab_reclaimable:%lukB"
 			" slab_unreclaimable:%lukB"
+			" kernel_stack:%lukB"
 			" pagetables:%lukB"
 			" unstable:%lukB"
 			" bounce:%lukB"
@@ -2182,6 +2183,8 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_FILE_MAPPED)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
+			zone_page_state(zone, NR_KERNEL_STACK) *
+				THREAD_SIZE / 1024,
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
 			K(zone_page_state(zone, NR_BOUNCE)),
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -639,6 +639,7 @@ static const char * const vmstat_text[] 
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
+	"nr_kernel_stack",
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
Index: b/drivers/base/node.c
===================================================================
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -85,6 +85,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:      %8lu kB\n"
 		       "Node %d Mapped:         %8lu kB\n"
 		       "Node %d AnonPages:      %8lu kB\n"
+		       "Node %d KernelStack:    %8lu kB\n"
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
 		       "Node %d Bounce:         %8lu kB\n"
@@ -116,6 +117,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, node_page_state(nid, NR_KERNEL_STACK) *
+				THREAD_SIZE / 1024,
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),


