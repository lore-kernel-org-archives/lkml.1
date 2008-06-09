Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYFIVnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYFIVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYFIVng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:43:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39909 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYFIVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:43:34 -0400
Subject: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 14:40:46 -0700
Message-Id: <1213047646.6763.150.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a reworked patch, version 3, to fix the SPU profile 
sample data collection.

Currently, the SPU escape sequences and program counter data is being 
added directly into the kernel buffer without holding the buffer_mutex 
lock.  This patch changes how the data is stored.  A new function,
oprofile_add_value, is added into the oprofile driver to allow adding
generic data to the per cpu buffers.  This enables adding series of data
to a specified cpu_buffer.  The function is used to add SPU data 
into a cpu buffer.  The patch also adds the needed code to move the
special sequence to the kernel buffer.  There are restrictions on
the use of the oprofile_add_value() function to ensure data is 
properly inserted to the specified CPU buffer.  

Finally, this patch backs out the changes previously added to the 
oprofile generic code for handling the architecture specific 
ops.sync_start and ops.sync_stop that allowed the architecture
to skip the per CPU buffer creation.

Signed-off-by: Carl Love <carll@us.ibm.com>

Index: Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/pr_util.h
===================================================================
--- Cell_kernel_5_15_2008-new.orig/arch/powerpc/oprofile/cell/pr_util.h
+++ Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/pr_util.h
@@ -20,10 +20,7 @@
 #include <asm/cell-regs.h>
 #include <asm/spu.h>
 
-/* Defines used for sync_start */
-#define SKIP_GENERIC_SYNC 0
-#define SYNC_START_ERROR -1
-#define DO_GENERIC_SYNC 1
+#define SPUS_PER_NODE	     8
 
 struct spu_overlay_info {	/* map of sections within an SPU overlay */
 	unsigned int vma;	/* SPU virtual memory address from elf */
@@ -80,12 +77,18 @@ int start_spu_profiling(unsigned int cyc
 
 void stop_spu_profiling(void);
 
+/*
+ * Entry point for SPU event profiling.
+ */
+int start_spu_event_profiling(unsigned int cycles_reset);
+
+void stop_spu_event_profiling(void);
 
 /* add the necessary profiling hooks */
 int spu_sync_start(void);
 
 /* remove the hooks */
-int spu_sync_stop(void);
+void spu_sync_stop(void);
 
 /* Record SPU program counter samples to the oprofile event buffer. */
 void spu_sync_buffer(int spu_num, unsigned int *samples,
Index: Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/arch/powerpc/oprofile/cell/spu_profiler.c
+++ Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -28,7 +28,6 @@ static unsigned int profiling_interval;
 
 #define NUM_SPU_BITS_TRBUF 16
 #define SPUS_PER_TB_ENTRY   4
-#define SPUS_PER_NODE	     8
 
 #define SPU_PC_MASK	     0xFFFF
 
@@ -123,7 +122,6 @@ static int cell_spu_pc_collection(int cp
 	return entry;
 }
 
-
 static enum hrtimer_restart profile_spus(struct hrtimer *timer)
 {
 	ktime_t kt;
@@ -150,7 +148,13 @@ static enum hrtimer_restart profile_spus
 				  sample_array_lock_flags);
 		num_samples = cell_spu_pc_collection(cpu);
 
-		if (num_samples == 0) {
+		if (unlikely(!spu_prof_running)) {
+			spin_unlock_irqrestore(&sample_array_lock,
+					       sample_array_lock_flags);
+			goto stop;
+		}
+
+		if (unlikely(num_samples == 0)) {
 			spin_unlock_irqrestore(&sample_array_lock,
 					       sample_array_lock_flags);
 			continue;
@@ -214,8 +218,26 @@ int start_spu_profiling(unsigned int cyc
 
 void stop_spu_profiling(void)
 {
+	int cpu;
+
 	spu_prof_running = 0;
 	hrtimer_cancel(&timer);
+
+	/* insure everyone sees spu_prof_running
+	 * changed to 0.
+	 */
+	smp_wmb();
+
+	/* Ensure writing data to the trace buffer and processing
+	 * data in the trace buffer has stopped.
+	 * Setting the trace buffer to empty will cause
+	 * cell_spu_pc_collection() to exit if it is running.
+	 */
+	for_each_online_cpu(cpu) {
+		cbe_write_pm(cpu, pm_interval, 0);
+		cbe_write_pm(cpu, trace_address, 0);
+	}
+
 	kfree(samples);
 	pr_debug("SPU_PROF: stop_spu_profiling issued\n");
 }
Index: Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -30,12 +30,20 @@
 #include "pr_util.h"
 
 #define RELEASE_ALL 9999
+#define NUM_SPU_CNTXT_SW   8
+#define NUM_SPU_SYNC_START 3
 
-static DEFINE_SPINLOCK(buffer_lock);
+static DEFINE_SPINLOCK(add_value_lock);
 static DEFINE_SPINLOCK(cache_lock);
 static int num_spu_nodes;
 int spu_prof_num_nodes;
-int last_guard_val[MAX_NUMNODES * 8];
+int last_guard_val[MAX_NUMNODES * SPUS_PER_NODE];
+static int spu_ctx_sw_seen[MAX_NUMNODES * SPUS_PER_NODE];
+
+/* an array for mapping spu numbers to an index in an array */
+static int spu_num_to_index[MAX_NUMNODES * SPUS_PER_NODE];
+static int max_spu_num_to_index=0;
+static DEFINE_SPINLOCK(spu_index_map_lock);
 
 /* Container for caching information about an active SPU task. */
 struct cached_info {
@@ -44,7 +52,129 @@ struct cached_info {
 	struct kref cache_ref;
 };
 
-static struct cached_info *spu_info[MAX_NUMNODES * 8];
+static struct cached_info *spu_info[MAX_NUMNODES * SPUS_PER_NODE];
+
+struct list_cpu_nums {
+	struct list_cpu_nums *next;
+	int cpu_num;
+};
+
+struct spu_cpu_map_struct {
+	int cpu_num;
+	int spu_num;
+};
+
+struct spu_cpu_map_struct spu_cpu_map[MAX_NUMNODES * SPUS_PER_NODE];
+
+struct list_cpu_nums *active_cpu_nums_list;
+struct list_cpu_nums *next_cpu;
+static int max_entries_spu_cpu_map=0;
+
+/* In general, don't know what the SPU number range will be.
+ * Create an array to define what SPU number is mapped to each
+ * index in an array.  Want to be able to have multiple calls
+ * lookup an index simultaneously.  Only hold a lock when adding
+ * a new entry.
+ */
+static int add_spu_index(int spu_num) {
+	int i, tmp;
+	int flags;
+
+	spin_lock_irqsave(&spu_index_map_lock, flags);
+
+	/* Need to double check that entry didn't get added
+	 * since the call to get_spu_index() didn't find it.
+	 */
+	for (i=0; i<max_spu_num_to_index; i++)
+		if (spu_num_to_index[i] == spu_num) {
+			tmp = i;
+			goto out;
+		}
+
+	/* create map for spu num */
+
+	tmp = max_spu_num_to_index;
+	spu_num_to_index[max_spu_num_to_index] = spu_num;
+	max_spu_num_to_index++;
+
+out:	spin_unlock_irqrestore(&spu_index_map_lock, flags);
+
+	return tmp;
+}
+
+static int get_spu_index(int spu_num) {
+	int i, tmp;
+
+	/* check if spu map has been created */
+	for (i=0; i<max_spu_num_to_index; i++)
+		if (spu_num_to_index[i] == spu_num) {
+			tmp = i;
+			goto out;
+		}
+
+	tmp = add_spu_index(spu_num);
+
+out:	return tmp;
+}
+
+static int valid_spu_num(int spu_num) {
+	int i;
+
+	/* check if spu map has been created */
+	for (i=0; i<max_spu_num_to_index; i++)
+		if (spu_num_to_index[i] == spu_num)
+			return 1;
+
+	/* The spu number has not been seen*/
+	return 0;
+}
+
+static int initialize_active_cpu_nums(void) {
+	int cpu;
+	struct list_cpu_nums *tmp;
+
+	/* initialize the circular list */
+
+	active_cpu_nums_list = NULL;
+
+        for_each_online_cpu(cpu) {
+		if (!(tmp = kzalloc(sizeof(struct list_cpu_nums),
+				    GFP_KERNEL)))
+			return -ENOMEM;
+
+		tmp->cpu_num = cpu;
+
+		if (!active_cpu_nums_list) {
+			active_cpu_nums_list = tmp;
+			tmp->next = tmp;
+
+		} else {
+			tmp->next = active_cpu_nums_list->next;
+			active_cpu_nums_list->next = tmp;
+		}
+	}
+	next_cpu = active_cpu_nums_list;
+	return 0;
+}
+
+static int get_cpu_buf(int spu_num) {
+	int i;
+
+
+	for (i=0; i< max_entries_spu_cpu_map; i++)
+	  if (spu_cpu_map[i].spu_num == spu_num)
+			return spu_cpu_map[i].cpu_num;
+
+	/* no mapping found, create mapping using the next
+	 * cpu in the circular list of cpu numbers.
+	 */
+	spu_cpu_map[max_entries_spu_cpu_map].spu_num = spu_num;
+	spu_cpu_map[max_entries_spu_cpu_map].cpu_num = next_cpu->cpu_num;
+
+	next_cpu = next_cpu->next;
+
+	return spu_cpu_map[max_entries_spu_cpu_map++].cpu_num;
+}
 
 static void destroy_cached_info(struct kref *kref)
 {
@@ -72,15 +202,17 @@ static struct cached_info *get_cached_in
 		ret_info = NULL;
 		goto out;
 	}
-	if (!spu_info[spu_num] && the_spu) {
+	if (!spu_info[get_spu_index(spu_num)] && the_spu) {
 		ref = spu_get_profile_private_kref(the_spu->ctx);
 		if (ref) {
-			spu_info[spu_num] = container_of(ref, struct cached_info, cache_ref);
-			kref_get(&spu_info[spu_num]->cache_ref);
+			spu_info[get_spu_index(spu_num)] =
+				container_of(ref, struct cached_info,
+					     cache_ref);
+			kref_get(&spu_info[get_spu_index(spu_num)]->cache_ref);
 		}
 	}
 
-	ret_info = spu_info[spu_num];
+	ret_info = spu_info[get_spu_index(spu_num)];
  out:
 	return ret_info;
 }
@@ -133,7 +265,7 @@ prepare_cached_spu_info(struct spu *spu,
 	info->the_spu = spu;
 	kref_init(&info->cache_ref);
 	spin_lock_irqsave(&cache_lock, flags);
-	spu_info[spu->number] = info;
+	spu_info[get_spu_index(spu->number)] = info;
 	/* Increment count before passing off ref to SPUFS. */
 	kref_get(&info->cache_ref);
 
@@ -161,27 +293,28 @@ out:
  */
 static int release_cached_info(int spu_index)
 {
-	int index, end;
+	int index, end, spu_num;
 
 	if (spu_index == RELEASE_ALL) {
-		end = num_spu_nodes;
+		end = max_spu_num_to_index;
 		index = 0;
 	} else {
-		if (spu_index >= num_spu_nodes) {
+		if (!valid_spu_num(spu_index)) {
 			printk(KERN_ERR "SPU_PROF: "
 				"%s, line %d: "
 				"Invalid index %d into spu info cache\n",
 				__FUNCTION__, __LINE__, spu_index);
 			goto out;
 		}
-		end = spu_index + 1;
-		index = spu_index;
+		index = get_spu_index(spu_index);
+		end = index + 1;
 	}
 	for (; index < end; index++) {
-		if (spu_info[index]) {
-			kref_put(&spu_info[index]->cache_ref,
+		spu_num = spu_num_to_index[index];
+		if (spu_info[spu_num]) {
+			kref_put(&spu_info[spu_num]->cache_ref,
 				 destroy_cached_info);
-			spu_info[index] = NULL;
+			spu_info[spu_num] = NULL;
 		}
 	}
 
@@ -289,6 +422,8 @@ static int process_context_switch(struct
 	int retval;
 	unsigned int offset = 0;
 	unsigned long spu_cookie = 0, app_dcookie;
+	unsigned long values[NUM_SPU_CNTXT_SW];
+	int cpu_buf;
 
 	retval = prepare_cached_spu_info(spu, objectId);
 	if (retval)
@@ -303,17 +438,31 @@ static int process_context_switch(struct
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
+	/* Record context info in event buffer.  Note, there are more
+	 * SPUs then CPUs.  Map the SPU events/data for a given SPU to
+	 * the same CPU buffer.  Need to ensure the cntxt switch data and
+	 * samples stay in order.
+	 */
+
+	spin_lock_irqsave(&add_value_lock, flags);
+	cpu_buf = get_cpu_buf(spu->number);
+
+	values[0] = ESCAPE_CODE;
+	values[1] = SPU_CTX_SWITCH_CODE;
+	values[2] = spu->number;
+	values[3] = spu->pid;
+	values[4] = spu->tgid;
+	values[5] = app_dcookie;
+	values[6] = spu_cookie;
+	values[7] = offset;
+	oprofile_add_value(values, cpu_buf, NUM_SPU_CNTXT_SW);
+
+	/* Set flag to indicate SPU PC data can now be written out.  If
+	 * the SPU program counter data is seen before an SPU context
+	 * record is seen, the postprocessing will fail.
+	 */
+	spu_ctx_sw_seen[get_spu_index(spu->number)] = 1;
+	spin_unlock_irqrestore(&add_value_lock, flags);
 	smp_wmb();	/* insure spu event buffer updates are written */
 			/* don't want entries intermingled... */
 out:
@@ -363,38 +512,51 @@ static int number_of_online_nodes(void)
 /* The main purpose of this function is to synchronize
  * OProfile with SPUFS by registering to be notified of
  * SPU task switches.
- *
- * NOTE: When profiling SPUs, we must ensure that only
- * spu_sync_start is invoked and not the generic sync_start
- * in drivers/oprofile/oprof.c.	 A return value of
- * SKIP_GENERIC_SYNC or SYNC_START_ERROR will
- * accomplish this.
  */
 int spu_sync_start(void)
 {
 	int k;
-	int ret = SKIP_GENERIC_SYNC;
+	int ret = 0;
 	int register_ret;
-	unsigned long flags = 0;
+	int cpu;
+	int flags;
+	int unsigned long values[NUM_SPU_SYNC_START];
 
 	spu_prof_num_nodes = number_of_online_nodes();
-	num_spu_nodes = spu_prof_num_nodes * 8;
+	num_spu_nodes = spu_prof_num_nodes * SPUS_PER_NODE;
 
-	spin_lock_irqsave(&buffer_lock, flags);
-	add_event_entry(ESCAPE_CODE);
-	add_event_entry(SPU_PROFILING_CODE);
-	add_event_entry(num_spu_nodes);
-	spin_unlock_irqrestore(&buffer_lock, flags);
+	ret = initialize_active_cpu_nums();
+	if (ret)
+		goto out;
+
+	/* The SPU_PROFILING_CODE escape sequence must proceed
+	 * the SPU context switch info.
+	 *
+	 * SPU profiling and PPU profiling are not supported
+	 * at the same time.  SPU Profilining does not support
+	 * call graphs, hence just need lock to prevent mulitple
+	 * calls to oprofile_add_value().
+	 */
+	values[0] = ESCAPE_CODE;
+	values[1] = SPU_PROFILING_CODE;
+	values[2] =(unsigned long int) num_spu_nodes;
+
+	spin_lock_irqsave(&add_value_lock, flags);
+	for_each_online_cpu(cpu)
+		oprofile_add_value(values, cpu, NUM_SPU_SYNC_START);
+	spin_unlock_irqrestore(&add_value_lock, flags);
 
 	/* Register for SPU events  */
 	register_ret = spu_switch_event_register(&spu_active);
 	if (register_ret) {
-		ret = SYNC_START_ERROR;
+		ret = -1;
 		goto out;
 	}
 
-	for (k = 0; k < (MAX_NUMNODES * 8); k++)
+	for (k = 0; k < (MAX_NUMNODES * SPUS_PER_NODE); k++) {
 		last_guard_val[k] = 0;
+		spu_ctx_sw_seen[k] = 0;
+	}
 	pr_debug("spu_sync_start -- running.\n");
 out:
 	return ret;
@@ -405,13 +567,15 @@ void spu_sync_buffer(int spu_num, unsign
 		     int num_samples)
 {
 	unsigned long long file_offset;
-	unsigned long flags;
+	unsigned long flags, flags_add_value;
 	int i;
 	struct vma_to_fileoffset_map *map;
 	struct spu *the_spu;
 	unsigned long long spu_num_ll = spu_num;
 	unsigned long long spu_num_shifted = spu_num_ll << 32;
 	struct cached_info *c_info;
+	unsigned long value;
+	int cpu_buf;
 
 	/* We need to obtain the cache_lock here because it's
 	 * possible that after getting the cached_info, the SPU job
@@ -432,7 +596,9 @@ void spu_sync_buffer(int spu_num, unsign
 
 	map = c_info->map;
 	the_spu = c_info->the_spu;
-	spin_lock(&buffer_lock);
+	spin_lock_irqsave(&add_value_lock, flags_add_value);
+	cpu_buf = get_cpu_buf(the_spu->number);
+
 	for (i = 0; i < num_samples; i++) {
 		unsigned int sample = *(samples+i);
 		int grd_val = 0;
@@ -446,37 +612,43 @@ void spu_sync_buffer(int spu_num, unsign
 		 * use.	 We need to discard samples taken during the time
 		 * period which an overlay occurs (i.e., guard value changes).
 		 */
-		if (grd_val && grd_val != last_guard_val[spu_num]) {
-			last_guard_val[spu_num] = grd_val;
+		if (grd_val && grd_val != last_guard_val[get_spu_index(spu_num)]) {
+			last_guard_val[get_spu_index(spu_num)] = grd_val;
 			/* Drop the rest of the samples. */
 			break;
 		}
 
-		add_event_entry(file_offset | spu_num_shifted);
+		/* We must ensure that the SPU context switch has been written
+		 * out before samples for the SPU.  Otherwise, the SPU context
+		 * information is not available and the postprocessing of the
+		 * SPU PC will fail with no available anonymous map information.
+		 */
+		if (likely(spu_ctx_sw_seen[get_spu_index(spu_num)])) {
+			value = file_offset | spu_num_shifted;
+			oprofile_add_value(&value, cpu_buf, 1);
+		}
 	}
-	spin_unlock(&buffer_lock);
+	spin_unlock_irqrestore(&add_value_lock, flags_add_value);
 out:
 	spin_unlock_irqrestore(&cache_lock, flags);
 }
 
 
-int spu_sync_stop(void)
+void spu_sync_stop(void)
 {
 	unsigned long flags = 0;
-	int ret = spu_switch_event_unregister(&spu_active);
-	if (ret) {
-		printk(KERN_ERR "SPU_PROF: "
-			"%s, line %d: spu_switch_event_unregister returned %d\n",
-			__FUNCTION__, __LINE__, ret);
-		goto out;
-	}
+
+	/* Ignoring the return value from the unregister
+	 * call.  A failed return value simply says there
+	 * was no registered event.  Hence there will not
+	 * be any calls to process a switch event that
+	 * could cause a problem.
+	 */
+	spu_switch_event_unregister(&spu_active);
 
 	spin_lock_irqsave(&cache_lock, flags);
-	ret = release_cached_info(RELEASE_ALL);
+	release_cached_info(RELEASE_ALL);
 	spin_unlock_irqrestore(&cache_lock, flags);
-out:
 	pr_debug("spu_sync_stop -- done.\n");
-	return ret;
+	return;
 }
-
-
Index: Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_5_15_2008-new/arch/powerpc/oprofile/op_model_cell.c
@@ -1191,15 +1191,15 @@ static int cell_sync_start(void)
 	if (spu_cycle_reset)
 		return spu_sync_start();
 	else
-		return DO_GENERIC_SYNC;
+		return 0;
 }
 
-static int cell_sync_stop(void)
+static void cell_sync_stop(void)
 {
 	if (spu_cycle_reset)
-		return spu_sync_stop();
-	else
-		return 1;
+		spu_sync_stop();
+
+	return;
 }
 
 struct op_powerpc_model op_model_cell = {
Index: Cell_kernel_5_15_2008-new/drivers/oprofile/buffer_sync.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/buffer_sync.c
+++ Cell_kernel_5_15_2008-new/drivers/oprofile/buffer_sync.c
@@ -40,6 +40,7 @@ static cpumask_t marked_cpus = CPU_MASK_
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
 
+extern int work_enabled;  // carll added for debug
 
 /* Take ownership of the task struct and place it on the
  * list for processing. Only after two full buffer syncs
@@ -521,6 +522,46 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+			} else if (s->event == VALUE_HEADER_ID) {
+				/* The next event entry contains the number
+				 * values in the sequence to add.
+				 */
+				int index, j, num;
+
+				if ((available - i) < 2)
+					/* The next entry which contains the
+					 * number of entries in the sequence
+					 * has not been written to the
+					 * buffer yet.
+					 */
+					break;
+
+				/* Get the number in the sequence without
+				 * changing the state of the buffer.
+				 */
+				index = cpu_buf->tail_pos + 1;
+				if (!(index < cpu_buf->buffer_size))
+					index = 0;
+
+				num = cpu_buf->buffer[index].eip;
+
+				if ((available - i) < (num+1))
+					/* The entire sequence has not been
+					 * written to the buffer yet.
+					 */
+					break;
+
+				if (work_enabled == 0) {
+					printk("work_enabled is zero\n");
+				}
+				for (j = 0; j < num; j++) {
+					increment_tail(cpu_buf);
+					i++;
+
+					s = &cpu_buf->buffer[cpu_buf->tail_pos];
+					add_event_entry(s->event);
+				}
+
 			} else {
 				struct mm_struct * oldmm = mm;
 
Index: Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/cpu_buffer.c
+++ Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.c
@@ -32,7 +32,9 @@ struct oprofile_cpu_buffer cpu_buffer[NR
 static void wq_sync_buffer(struct work_struct *work);
 
 #define DEFAULT_TIMER_EXPIRE (HZ / 10)
-static int work_enabled;
+//carll changed static int work_enabled;
+extern int work_enabled;
+int work_enabled;
 
 void free_cpu_buffers(void)
 {
@@ -224,6 +226,27 @@ static void oprofile_end_trace(struct op
 	cpu_buf->tracing = 0;
 }
 
+/*
+ * The first entry in the per cpu buffer consists of the escape code and
+ * the VALUE_HEADER_ID value.  The next entry consists of the number of
+ * values in the sequence and the first value, followed by the entries
+ * for the next N-1 values.
+ */
+void oprofile_add_value(unsigned long *values, int cpu, int num) {
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
+	int i;
+
+	if (nr_available_slots(cpu_buf) < num+1) {
+		cpu_buf->sample_lost_overflow++;
+		return;
+	}
+
+	add_sample(cpu_buf, ESCAPE_CODE, VALUE_HEADER_ID);
+	add_sample(cpu_buf, num, values[0]);
+	for (i=1; i<num; i++)
+		add_sample(cpu_buf, 0, values[i]);
+}
+
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
Index: Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.h
===================================================================
--- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/cpu_buffer.h
+++ Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.h
@@ -54,5 +54,6 @@ void cpu_buffer_reset(struct oprofile_cp
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define VALUE_HEADER_ID 3
 
 #endif /* OPROFILE_CPU_BUFFER_H */
Index: Cell_kernel_5_15_2008-new/drivers/oprofile/event_buffer.h
===================================================================
--- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/event_buffer.h
+++ Cell_kernel_5_15_2008-new/drivers/oprofile/event_buffer.h
@@ -17,6 +17,14 @@ int alloc_event_buffer(void);
 
 void free_event_buffer(void);
  
+
+/**
+ * Add data to the event buffer.
+ * The data passed is free-form, but typically consists of
+ * file offsets, dcookies, context information, and ESCAPE codes.
+ */
+void add_event_entry(unsigned long data);
+
 /* wake up the process sleeping on the event file */
 void wake_up_buffer_waiter(void);
 
Index: Cell_kernel_5_15_2008-new/drivers/oprofile/oprof.c
===================================================================
--- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/oprof.c
+++ Cell_kernel_5_15_2008-new/drivers/oprofile/oprof.c
@@ -53,24 +53,13 @@ int oprofile_setup(void)
 	 * us missing task deaths and eventually oopsing
 	 * when trying to process the event buffer.
 	 */
-	if (oprofile_ops.sync_start) {
-		int sync_ret = oprofile_ops.sync_start();
-		switch (sync_ret) {
-		case 0:
-			goto post_sync;
-		case 1:
-			goto do_generic;
-		case -1:
-			goto out3;
-		default:
-			goto out3;
-		}
-	}
-do_generic:
+	if (oprofile_ops.sync_start
+	    && ((err = oprofile_ops.sync_start())))
+		goto out2;
+
 	if ((err = sync_start()))
 		goto out3;
 
-post_sync:
 	is_setup = 1;
 	mutex_unlock(&start_mutex);
 	return 0;
@@ -133,20 +122,9 @@ out:
 void oprofile_shutdown(void)
 {
 	mutex_lock(&start_mutex);
-	if (oprofile_ops.sync_stop) {
-		int sync_ret = oprofile_ops.sync_stop();
-		switch (sync_ret) {
-		case 0:
-			goto post_sync;
-		case 1:
-			goto do_generic;
-		default:
-			goto post_sync;
-		}
-	}
-do_generic:
+	if (oprofile_ops.sync_stop)
+		oprofile_ops.sync_stop();
 	sync_stop();
-post_sync:
 	if (oprofile_ops.shutdown)
 		oprofile_ops.shutdown();
 	is_setup = 0;
Index: Cell_kernel_5_15_2008-new/include/asm-powerpc/oprofile_impl.h
===================================================================
--- Cell_kernel_5_15_2008-new.orig/include/asm-powerpc/oprofile_impl.h
+++ Cell_kernel_5_15_2008-new/include/asm-powerpc/oprofile_impl.h
@@ -48,7 +48,7 @@ struct op_powerpc_model {
 	void (*stop) (void);
 	void (*global_stop) (void);
 	int (*sync_start)(void);
-	int (*sync_stop)(void);
+	void (*sync_stop)(void);
 	void (*handle_interrupt) (struct pt_regs *,
 				  struct op_counter_config *);
 	int num_counters;
Index: Cell_kernel_5_15_2008-new/include/linux/oprofile.h
===================================================================
--- Cell_kernel_5_15_2008-new.orig/include/linux/oprofile.h
+++ Cell_kernel_5_15_2008-new/include/linux/oprofile.h
@@ -51,17 +51,15 @@ struct oprofile_operations {
 	int (*setup)(void);
 	/* Do any necessary interrupt shutdown. Optional. */
 	void (*shutdown)(void);
-	/* Start delivering interrupts. */
+  	/* Start delivering interrupts. */
 	int (*start)(void);
 	/* Stop delivering interrupts. */
 	void (*stop)(void);
 	/* Arch-specific buffer sync functions.
-	 * Return value = 0:  Success
-	 * Return value = -1: Failure
-	 * Return value = 1:  Run generic sync function
+	 * Sync start: Return 0 for Success,  -1 for Failure
 	 */
 	int (*sync_start)(void);
-	int (*sync_stop)(void);
+	void (*sync_stop)(void);
 
 	/* Initiate a stack backtrace. Optional. */
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
@@ -84,13 +82,6 @@ int oprofile_arch_init(struct oprofile_o
 void oprofile_arch_exit(void);
 
 /**
- * Add data to the event buffer.
- * The data passed is free-form, but typically consists of
- * file offsets, dcookies, context information, and ESCAPE codes.
- */
-void add_event_entry(unsigned long data);
-
-/**
  * Add a sample. This may be called from any context. Pass
  * smp_processor_id() as cpu.
  */
@@ -106,6 +97,22 @@ void oprofile_add_sample(struct pt_regs 
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel);
 
+/*
+ * Add a sequence of values to the per CPU buffer.  An array of values is
+ * added to the specified cpu buffer with no additional processing.  The assumption
+ * is any processing of the value will be done in the postprocessor.  This
+ * function should only be used for special architecture specific data.
+ * Currently only used by the CELL processor.
+ *
+ * REQUIREMENT: the user of the function must ensure that only one call at
+ * a time is made to this function.  Additionally, it must ensure that
+ * no calls are made to the following routines: oprofile_begin_trace(),
+ * oprofile_add_ext_sample(), oprofile_add_pc(), oprofile_add_trace().
+ *
+ * This function does not perform a backtrace.
+ */
+void oprofile_add_value(unsigned long *values, int cpu, int num);
+
 /* Use this instead when the PC value is not from the regs. Doesn't
  * backtrace. */
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event);


