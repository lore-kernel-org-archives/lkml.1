Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYCYQAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYCYQAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYCYQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:00:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49819 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYCYQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:00:10 -0400
Subject: [Cbe-oss-dev] [PATCH] Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cel <cel@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 08:58:47 -0700
Message-Id: <1206460727.7132.232.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the code that records the SPU data and
context switches.  The buffer_mutex lock must be held when the
kernel is adding data to the buffer between the kernel and the
OProfile daemon.  The lock is not being held in the current code
base.  This patch fixes the bug using work queues.  The data to 
be passed to the daemon is caputured by the interrupt handler.  
The workqueue function is invoked to grab the buffer_mutex lock
and add the data to the buffer.  

Signed-off-by: Carl Love <cel@us.ibm.com>


Index: linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- linux-2.6.25-rc4.orig/arch/powerpc/oprofile/cell/spu_profiler.c
+++ linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -16,6 +16,7 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <asm/cell-pmu.h>
+#include <linux/workqueue.h>
 #include "pr_util.h"
 
 #define TRACE_ARRAY_SIZE 1024
@@ -32,9 +33,19 @@ static unsigned int profiling_interval;
 
 #define SPU_PC_MASK	     0xFFFF
 
+/* The generic OProfile code uses the buffer_mutex to protect the buffer
+ * between the kernel and the daemon.  The SPU code needs to use the buffer
+ * to ensure that the kernel SPU writes complete as a single block before
+ * being consumed by the daemon.
+ */
+extern struct mutex buffer_mutex;
+
 static DEFINE_SPINLOCK(sample_array_lock);
 unsigned long sample_array_lock_flags;
 
+struct work_struct spu_record_wq;
+extern struct workqueue_struct *oprofile_spu_wq;
+
 void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
 {
 	unsigned long ns_per_cyc;
@@ -123,14 +134,14 @@ static int cell_spu_pc_collection(int cp
 	return entry;
 }
 
-
-static enum hrtimer_restart profile_spus(struct hrtimer *timer)
-{
-	ktime_t kt;
+static void profile_spus_record_samples (struct work_struct *ws) {
+	/* This routine is called via schedule_work() to record the
+	 * spu data.  It must be run in a normal kernel mode to
+	 * grab the OProfile mutex lock.
+	 */
 	int cpu, node, k, num_samples, spu_num;
 
-	if (!spu_prof_running)
-		goto stop;
+	mutex_lock(&buffer_mutex);
 
 	for_each_online_cpu(cpu) {
 		if (cbe_get_hw_thread_id(cpu))
@@ -170,6 +181,20 @@ static enum hrtimer_restart profile_spus
 	smp_wmb();	/* insure spu event buffer updates are written */
 			/* don't want events intermingled... */
 
+	mutex_unlock(&buffer_mutex);
+}
+
+static enum hrtimer_restart profile_spus(struct hrtimer *timer)
+{
+	ktime_t kt;
+
+
+	if (!spu_prof_running)
+		goto stop;
+
+	/* schedule the funtion to record the data */
+	schedule_work(&spu_record_wq);
+
 	kt = ktime_set(0, profiling_interval);
 	if (!spu_prof_running)
 		goto stop;
@@ -209,6 +234,10 @@ int start_spu_profiling(unsigned int cyc
 	spu_prof_running = 1;
 	hrtimer_start(&timer, kt, HRTIMER_MODE_REL);
 
+	/* setup the workqueue for recording the SPU data */
+	INIT_WORK(&spu_record_wq,
+		  profile_spus_record_samples);
+
 	return 0;
 }
 
Index: linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
--- linux-2.6.25-rc4.orig/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -27,15 +27,44 @@
 #include <linux/numa.h>
 #include <linux/oprofile.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include "pr_util.h"
 
 #define RELEASE_ALL 9999
 
-static DEFINE_SPINLOCK(buffer_lock);
+extern struct mutex buffer_mutex;
+extern struct workqueue_struct *oprofile_spu_wq;
+extern int calls_to_record_switch;
+
 static DEFINE_SPINLOCK(cache_lock);
 static int num_spu_nodes;
+
 int spu_prof_num_nodes;
 int last_guard_val[MAX_NUMNODES * 8];
+int cnt_swtch_processed_flag[MAX_NUMNODES * 8];
+
+struct spus_profiling_code_data_s {
+	int num_spu_nodes;
+	struct work_struct spu_prof_code_wq;
+} spus_profiling_code_data;
+
+struct spu_context_switch_data_s {
+	struct spu *spu;
+	unsigned long spu_cookie;
+	unsigned long app_dcookie;
+	unsigned int offset;
+	unsigned long objectId;
+	int valid_entry;
+} spu_context_switch_data;
+
+int calls_to_record_switch = 0;
+int record_spu_start_flag = 0;
+
+struct spus_cntxt_sw_data_s {
+	int num_spu_nodes;
+	struct spu_context_switch_data_s spu_data[MAX_NUMNODES * 8];
+	struct work_struct spu_cntxt_work;
+} spus_cntxt_sw_data;
 
 /* Container for caching information about an active SPU task. */
 struct cached_info {
@@ -44,6 +73,8 @@ struct cached_info {
 	struct kref cache_ref;
 };
 
+struct workqueue_struct *oprofile_spu_wq;
+
 static struct cached_info *spu_info[MAX_NUMNODES * 8];
 
 static void destroy_cached_info(struct kref *kref)
@@ -283,39 +314,90 @@ fail_no_image_cookie:
  * passed SPU and records SPU context information into the OProfile
  * event buffer.
  */
+static void record_spu_process_switch(struct work_struct *ws) {
+	int spu;
+	int req_processed=0;
+	struct spus_cntxt_sw_data_s *data
+		= container_of(ws, struct spus_cntxt_sw_data_s,
+			       spu_cntxt_work);
+
+	mutex_lock(&buffer_mutex);
+
+	if (record_spu_start_flag) {
+		add_event_entry(ESCAPE_CODE);
+		add_event_entry(SPU_PROFILING_CODE);
+		add_event_entry(data->num_spu_nodes);
+		record_spu_start_flag = 0;
+	}
+
+	for (spu = 0; spu < data->num_spu_nodes; spu ++) {
+		/* If the cached info can be created, put the info
+		 * into the oprofile buffer for the daemon. Otherwise
+		 * toss the entry.
+		 */
+		if (data->spu_data[spu].valid_entry == 1) {
+			/* Record context info in event buffer */
+			req_processed++;
+			add_event_entry(ESCAPE_CODE);
+			add_event_entry(SPU_CTX_SWITCH_CODE);
+			add_event_entry(spu);
+			add_event_entry(data->spu_data[spu].spu->pid);
+			add_event_entry(data->spu_data[spu].spu->tgid);
+			add_event_entry(data->spu_data[spu].app_dcookie);
+			add_event_entry(data->spu_data[spu].spu_cookie);
+			add_event_entry(data->spu_data[spu].offset);
+
+			/* Context switch has been processed, can now
+			 * begin recording samples.
+			 */
+			cnt_swtch_processed_flag[spu] = 1;
+
+			 /* insure spu event buffer updates are written
+			  * don't want entries intermingled...
+			  */
+			smp_wmb();
+		}
+		data->spu_data[spu].valid_entry = 0;
+	}
+
+	mutex_unlock(&buffer_mutex);
+}
+
 static int process_context_switch(struct spu *spu, unsigned long objectId)
 {
-	unsigned long flags;
-	int retval;
+	int retval = 0;
 	unsigned int offset = 0;
 	unsigned long spu_cookie = 0, app_dcookie;
 
 	retval = prepare_cached_spu_info(spu, objectId);
-	if (retval)
+	if (retval) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: prepare_cached_spu_info call "
+		       "failed, returned %d\n",
+		       __FUNCTION__, __LINE__, retval);
 		goto out;
+	}
+
 
-	/* Get dcookie first because a mutex_lock is taken in that
-	 * code path, so interrupts must not be disabled.
-	 */
 	app_dcookie = get_exec_dcookie_and_offset(spu, &offset, &spu_cookie, objectId);
 	if (!app_dcookie || !spu_cookie) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: get_exec_dcookie_and_offset call "
+		       "failed, returned %lu\n",
+		       __FUNCTION__, __LINE__, app_dcookie);
 		retval  = -ENOENT;
 		goto out;
 	}
 
-	/* Record context info in event buffer */
-	spin_lock_irqsave(&buffer_lock, flags);
-	add_event_entry(ESCAPE_CODE);
-	add_event_entry(SPU_CTX_SWITCH_CODE);
-	add_event_entry(spu->number);
-	add_event_entry(spu->pid);
-	add_event_entry(spu->tgid);
-	add_event_entry(app_dcookie);
-	add_event_entry(spu_cookie);
-	add_event_entry(offset);
-	spin_unlock_irqrestore(&buffer_lock, flags);
-	smp_wmb();	/* insure spu event buffer updates are written */
-			/* don't want entries intermingled... */
+	/* save the spu contect info */
+	spus_cntxt_sw_data.spu_data[spu->number].spu = spu;
+	spus_cntxt_sw_data.spu_data[spu->number].app_dcookie = app_dcookie;
+	spus_cntxt_sw_data.spu_data[spu->number].spu_cookie = spu_cookie;
+	spus_cntxt_sw_data.spu_data[spu->number].offset = offset;
+	spus_cntxt_sw_data.spu_data[spu->number].objectId = objectId;
+	spus_cntxt_sw_data.spu_data[spu->number].valid_entry = 1;
+
+	queue_work(oprofile_spu_wq, &spus_cntxt_sw_data.spu_cntxt_work);
 out:
 	return retval;
 }
@@ -375,16 +457,30 @@ int spu_sync_start(void)
 	int k;
 	int ret = SKIP_GENERIC_SYNC;
 	int register_ret;
-	unsigned long flags = 0;
 
 	spu_prof_num_nodes = number_of_online_nodes();
 	num_spu_nodes = spu_prof_num_nodes * 8;
 
-	spin_lock_irqsave(&buffer_lock, flags);
-	add_event_entry(ESCAPE_CODE);
-	add_event_entry(SPU_PROFILING_CODE);
-	add_event_entry(num_spu_nodes);
-	spin_unlock_irqrestore(&buffer_lock, flags);
+	/* create private work queue, execution of work is time critical */
+	oprofile_spu_wq = create_workqueue("spu_oprofile");
+
+	/* due to a race when the spu is already running stuff, need to
+	 * set a flag to tell the spu context switch to record the start
+	 * before recording the context switches.
+	 */
+	record_spu_start_flag = 1;
+
+	spus_profiling_code_data.num_spu_nodes = num_spu_nodes;
+
+	/* setup work queue functiion for recording context switch info */
+	spus_cntxt_sw_data.num_spu_nodes = num_spu_nodes;
+	for (k = 0; k<(MAX_NUMNODES * 8); k++) {
+		spus_cntxt_sw_data.spu_data[k].valid_entry = 0;
+		cnt_swtch_processed_flag[k] = 0;
+	}
+
+	INIT_WORK(&spus_cntxt_sw_data.spu_cntxt_work,
+		  record_spu_process_switch);
 
 	/* Register for SPU events  */
 	register_ret = spu_switch_event_register(&spu_active);
@@ -413,6 +509,17 @@ void spu_sync_buffer(int spu_num, unsign
 	unsigned long long spu_num_shifted = spu_num_ll << 32;
 	struct cached_info *c_info;
 
+	/* Do not record any samples until after the context switch
+	 * for this SPU has been recorded.  The daemon gets really
+	 * confused.
+	 */
+	if (!(cnt_swtch_processed_flag[spu_num]))
+		return;
+
+	/* note, the mutex lock on buffer_mutex has already been
+	 * grabbed by the caller to this function.
+	 */
+
 	/* We need to obtain the cache_lock here because it's
 	 * possible that after getting the cached_info, the SPU job
 	 * corresponding to this cached_info may end, thus resulting
@@ -432,7 +539,7 @@ void spu_sync_buffer(int spu_num, unsign
 
 	map = c_info->map;
 	the_spu = c_info->the_spu;
-	spin_lock(&buffer_lock);
+
 	for (i = 0; i < num_samples; i++) {
 		unsigned int sample = *(samples+i);
 		int grd_val = 0;
@@ -452,9 +559,11 @@ void spu_sync_buffer(int spu_num, unsign
 			break;
 		}
 
+		/* add_event() protected by the mutex_lock(buffer_mutex) taken
+		 * in routine profile_spus_record_samples()
+		 */
 		add_event_entry(file_offset | spu_num_shifted);
 	}
-	spin_unlock(&buffer_lock);
 out:
 	spin_unlock_irqrestore(&cache_lock, flags);
 }
@@ -463,7 +572,9 @@ out:
 int spu_sync_stop(void)
 {
 	unsigned long flags = 0;
+	int k;
 	int ret = spu_switch_event_unregister(&spu_active);
+
 	if (ret) {
 		printk(KERN_ERR "SPU_PROF: "
 			"%s, line %d: spu_switch_event_unregister returned %d\n",
@@ -475,6 +586,15 @@ int spu_sync_stop(void)
 	ret = release_cached_info(RELEASE_ALL);
 	spin_unlock_irqrestore(&cache_lock, flags);
 out:
+	/* clear any pending spu cntx switch request */
+
+	for (k = 0; k<(MAX_NUMNODES * 8); k++)
+	        if (spus_cntxt_sw_data.spu_data[k].valid_entry == 1)
+			pr_debug ("spu_sync_stop -- removed "\
+				  "pending SPU sw req\n");
+
+		spus_cntxt_sw_data.spu_data[k].valid_entry = 0;
+
 	pr_debug("spu_sync_stop -- done.\n");
 	return ret;
 }


