Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZFHRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZFHRVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZFHRUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:11 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753705AbZFHRUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:09 -0400
Message-Id: <20090608172006.855485000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:55 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 07/12] GRU - generic infrastructure for context options
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_context_options
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Change the user GRU request for specifying the "task_slice"
option to use a generic infrastructure that can be expanded in the
future to include additional context options. No new capabilities
are added with this patch.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c  |   24 ++++++++++++++++++------
 drivers/misc/sgi-gru/grufile.c   |    4 ++--
 drivers/misc/sgi-gru/grulib.h    |   14 ++++++++++++--
 drivers/misc/sgi-gru/gruprocfs.c |    2 +-
 drivers/misc/sgi-gru/grutables.h |    4 ++--
 5 files changed, 35 insertions(+), 13 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-05-12 16:43:36.000000000 -0500
@@ -753,18 +753,30 @@ long gru_get_gseg_statistics(unsigned lo
  * Register the current task as the user of the GSEG slice.
  * Needed for TLB fault interrupt targeting.
  */
-int gru_set_task_slice(long address)
+int gru_set_context_option(unsigned long arg)
 {
 	struct gru_thread_state *gts;
+	struct gru_set_context_option_req req;
+	int ret = 0;
 
-	STAT(set_task_slice);
-	gru_dbg(grudev, "address 0x%lx\n", address);
-	gts = gru_alloc_locked_gts(address);
+	STAT(set_context_option);
+	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
+		return -EFAULT;
+	gru_dbg(grudev, "op %d, gseg 0x%lx, value1 0x%lx\n", req.op, req.gseg, req.val1);
+
+	gts = gru_alloc_locked_gts(req.gseg);
 	if (!gts)
 		return -EINVAL;
 
-	gts->ts_tgid_owner = current->tgid;
+	switch (req.op) {
+	case sco_gseg_owner:
+ 		/* Register the current task as the GSEG owner */
+		gts->ts_tgid_owner = current->tgid;
+		break;
+	default:
+		ret = -EINVAL;
+	}
 	gru_unlock_gts(gts);
 
-	return 0;
+	return ret;
 }
Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-05-12 16:43:36.000000000 -0500
@@ -198,8 +198,8 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_CREATE_CONTEXT:
 		err = gru_create_new_context(arg);
 		break;
-	case GRU_SET_TASK_SLICE:
-		err = gru_set_task_slice(arg);
+	case GRU_SET_CONTEXT_OPTION:
+		err = gru_set_context_option(arg);
 		break;
 	case GRU_USER_GET_EXCEPTION_DETAIL:
 		err = gru_get_exception_detail(arg);
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-05-12 16:43:36.000000000 -0500
@@ -32,8 +32,8 @@
 /* Set Number of Request Blocks */
 #define GRU_CREATE_CONTEXT		_IOWR(GRU_IOCTL_NUM, 1, void *)
 
-/* Register task as using the slice */
-#define GRU_SET_TASK_SLICE		_IOWR(GRU_IOCTL_NUM, 5, void *)
+/*  Set Context Options */
+#define GRU_SET_CONTEXT_OPTION		_IOWR(GRU_IOCTL_NUM, 4, void *)
 
 /* Fetch exception detail */
 #define GRU_USER_GET_EXCEPTION_DETAIL	_IOWR(GRU_IOCTL_NUM, 6, void *)
@@ -96,6 +96,16 @@ struct gru_unload_context_req {
 };
 
 /*
+ * Structure used to set context options
+ */
+enum {sco_gseg_owner};
+struct gru_set_context_option_req {
+	unsigned long	gseg;
+	int		op;
+	unsigned long	val1;
+};
+
+/*
  * Structure used to pass TLB flush parameters to the driver
  */
 struct gru_flush_tlb_req {
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-05-12 16:43:36.000000000 -0500
@@ -73,7 +73,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, user_flush_tlb);
 	printstat(s, user_unload_context);
 	printstat(s, user_exception);
-	printstat(s, set_task_slice);
+	printstat(s, set_context_option);
 	printstat(s, migrate_check);
 	printstat(s, migrated_retarget);
 	printstat(s, migrated_unload);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-05-12 16:43:36.000000000 -0500
@@ -198,7 +198,7 @@ struct gru_stats_s {
 	atomic_long_t user_flush_tlb;
 	atomic_long_t user_unload_context;
 	atomic_long_t user_exception;
-	atomic_long_t set_task_slice;
+	atomic_long_t set_context_option;
 	atomic_long_t migrate_check;
 	atomic_long_t migrated_retarget;
 	atomic_long_t migrated_unload;
@@ -649,7 +649,7 @@ extern int gru_handle_user_call_os(unsig
 extern int gru_user_flush_tlb(unsigned long arg);
 extern int gru_user_unload_context(unsigned long arg);
 extern int gru_get_exception_detail(unsigned long arg);
-extern int gru_set_task_slice(long address);
+extern int gru_set_context_option(unsigned long address);
 extern int gru_cpu_fault_map_id(void);
 extern struct vm_area_struct *gru_find_vma(unsigned long vaddr);
 extern void gru_flush_all_tlb(struct gru_state *gru);

