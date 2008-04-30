Return-Path: <linux-kernel-owner+w=401wt.eu-S1765766AbYD3UiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765766AbYD3UiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761983AbYD3Uh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:37:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37988 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465AbYD3Uh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:37:56 -0400
Subject: [Cbe-oss-dev]  [PATCH] Updated: Reworked Cell OProfile: SPU mutex
	lock fix
From: Carl Love <cel@us.ibm.com>
To: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 13:35:12 -0700
Message-Id: <1209587712.7531.42.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reworked patch to fix the SPU data storage.  Currently, the 
SPU escape sequences and program counter data is being added directly 
into the kernel buffer without holding the buffer_mutex lock.  This 
patch changes how the data is stored.  A new function,
oprofile_add_value, is added into the oprofile driver to allow adding
generic data to the per cpu buffers.  This enables a series of calls
to the oprofile_add_value to enter the needed SPU escape sequences 
and SPU program data into the kernel buffer via the per cpu buffers
without any additional processing. The oprofile_add_value function is
generic so it could be used by other architecures as well provided
the needed postprocessing was added to opreport.

Finally, this patch backs out the changes previously added to the 
oprofile generic code for handling the architecture specific 
ops.sync_start and ops.sync_stop that allowed the architecture
to skip the per CPU buffer creation.

Signed-off-by: Carl Love <carll@us.ibm.com>

Index: Cell_kernel_4_15_2008/arch/powerpc/oprofile/cell/pr_util.h
===================================================================
--- Cell_kernel_4_15_2008.orig/arch/powerpc/oprofile/cell/pr_util.h
+++ Cell_kernel_4_15_2008/arch/powerpc/oprofile/cell/pr_util.h
@@ -20,11 +20,6 @@
 #include <asm/cell-regs.h>
 #include <asm/spu.h>
 
-/* Defines used for sync_start */
-#define SKIP_GENERIC_SYNC 0
-#define SYNC_START_ERROR -1
-#define DO_GENERIC_SYNC 1
-
 struct spu_overlay_info {	/* map of sections within an SPU overlay */
 	unsigned int vma;	/* SPU virtual memory address from elf */
 	unsigned int size;	/* size of section from elf */
@@ -85,7 +80,7 @@ void stop_spu_profiling(void);
 int spu_sync_start(void);
 
 /* remove the hooks */
-int spu_sync_stop(void);
+void spu_sync_stop(void);
 
 /* Record SPU program counter samples to the oprofile event buffer. */
 void spu_sync_buffer(int spu_num, unsigned int *samples,
Index: Cell_kernel_4_15_2008/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
---
Cell_kernel_4_15_2008.orig/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ Cell_kernel_4_15_2008/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -31,11 +31,12 @@
 
 #define RELEASE_ALL 9999
 
-static DEFINE_SPINLOCK(buffer_lock);
+static DEFINE_SPINLOCK(add_value_lock);
 static DEFINE_SPINLOCK(cache_lock);
 static int num_spu_nodes;
 int spu_prof_num_nodes;
 int last_guard_val[MAX_NUMNODES * 8];
+static int spu_ctx_sw_seen[MAX_NUMNODES * 8];
 
 /* Container for caching information about an active SPU task. */
 struct cached_info {
@@ -289,6 +290,7 @@ static int process_context_switch(struct
 	int retval;
 	unsigned int offset = 0;
 	unsigned long spu_cookie = 0, app_dcookie;
+	int cpu_buf;
 
 	retval = prepare_cached_spu_info(spu, objectId);
 	if (retval)
@@ -303,17 +305,28 @@ static int process_context_switch(struct
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
+	/* Record context info in event buffer.  Note, there are 4x more
+	 * SPUs then CPUs.  Map the SPU events/data for a given SPU to
+	 * the same CPU buffer.  Need to ensure the cntxt switch data and
+	 * samples stay in order.
+	 */
+	cpu_buf = spu->number >> 2;
+	spin_lock_irqsave(&add_value_lock, flags);
+	oprofile_add_value(ESCAPE_CODE, cpu_buf);
+	oprofile_add_value(SPU_CTX_SWITCH_CODE, cpu_buf);
+	oprofile_add_value(spu->number, cpu_buf);
+	oprofile_add_value(spu->pid, cpu_buf);
+	oprofile_add_value(spu->tgid, cpu_buf);
+	oprofile_add_value(app_dcookie, cpu_buf);
+	oprofile_add_value(spu_cookie, cpu_buf);
+	oprofile_add_value(offset, cpu_buf);
+
+	/* Set flag to indicate SPU PC data can now be written out.  If
+	 * the SPU program counter data is seen before an SPU context
+	 * record is seen, the postprocessing will fail.
+	 */
+	spu_ctx_sw_seen[spu->number] = 1;
+	spin_unlock_irqrestore(&add_value_lock, flags);
 	smp_wmb();	/* insure spu event buffer updates are written */
 			/* don't want entries intermingled... */
 out:
@@ -333,7 +346,6 @@ static int spu_active_notify(struct noti
 	unsigned long flags;
 	struct spu *the_spu = data;
 
-	pr_debug("SPU event notification arrived\n");
 	if (!val) {
 		spin_lock_irqsave(&cache_lock, flags);
 		retval = release_cached_info(the_spu->number);
@@ -363,38 +375,38 @@ static int number_of_online_nodes(void)
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
 
 	spu_prof_num_nodes = number_of_online_nodes();
 	num_spu_nodes = spu_prof_num_nodes * 8;
 
-	spin_lock_irqsave(&buffer_lock, flags);
-	add_event_entry(ESCAPE_CODE);
-	add_event_entry(SPU_PROFILING_CODE);
-	add_event_entry(num_spu_nodes);
-	spin_unlock_irqrestore(&buffer_lock, flags);
+	/* The SPU_PROFILING_CODE escape sequence must proceed
+	 * the SPU context switch info.
+	 */
+	for_each_online_cpu(cpu) {
+		oprofile_add_value(ESCAPE_CODE, cpu);
+		oprofile_add_value(SPU_PROFILING_CODE, cpu);
+		oprofile_add_value((unsigned long int)
+					    num_spu_nodes, cpu);
+	}
 
 	/* Register for SPU events  */
 	register_ret = spu_switch_event_register(&spu_active);
 	if (register_ret) {
-		ret = SYNC_START_ERROR;
+		ret = -1;
 		goto out;
 	}
 
-	for (k = 0; k < (MAX_NUMNODES * 8); k++)
+	for (k = 0; k < (MAX_NUMNODES * 8); k++) {
 		last_guard_val[k] = 0;
+		spu_ctx_sw_seen[k] = 0;
+	}
 	pr_debug("spu_sync_start -- running.\n");
 out:
 	return ret;
@@ -432,7 +444,7 @@ void spu_sync_buffer(int spu_num, unsign
 
 	map = c_info->map;
 	the_spu = c_info->the_spu;
-	spin_lock(&buffer_lock);
+	spin_lock(&add_value_lock);
 	for (i = 0; i < num_samples; i++) {
 		unsigned int sample = *(samples+i);
 		int grd_val = 0;
@@ -452,31 +464,38 @@ void spu_sync_buffer(int spu_num, unsign
 			break;
 		}
 
-		add_event_entry(file_offset | spu_num_shifted);
+		/* We must ensure that the SPU context switch has been written
+		 * out before samples for the SPU.  Otherwise, the SPU context
+		 * information is not available and the postprocessing of the
+		 * SPU PC will fail with no available anonymous map information.
+		 */
+		if (spu_ctx_sw_seen[spu_num])
+			oprofile_add_value((file_offset | spu_num_shifted),
+						    (spu_num >> 2));
 	}
-	spin_unlock(&buffer_lock);
+	spin_unlock(&add_value_lock);
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
 
 
Index: Cell_kernel_4_15_2008/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_4_15_2008.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_4_15_2008/arch/powerpc/oprofile/op_model_cell.c
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
Index: Cell_kernel_4_15_2008/drivers/oprofile/buffer_sync.c
===================================================================
--- Cell_kernel_4_15_2008.orig/drivers/oprofile/buffer_sync.c
+++ Cell_kernel_4_15_2008/drivers/oprofile/buffer_sync.c
@@ -521,6 +521,20 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+			} else if (s->event == VALUE_HEADER_ID) {
+				/* The next event contains a value
+				 * to enter directly into the event buffer.
+				 */
+				increment_tail(cpu_buf);
+				i++;  /* one less entry in buffer to process */
+
+				s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
+				if (unlikely(is_code(s->eip)))
+					add_event_entry(s->event);
+				else
+					printk("KERN_ERR Oprofile per CPU" \
+					       "buffer sequence error.\n");
 			} else {
 				struct mm_struct * oldmm = mm;
 
Index: Cell_kernel_4_15_2008/drivers/oprofile/cpu_buffer.c
===================================================================
--- Cell_kernel_4_15_2008.orig/drivers/oprofile/cpu_buffer.c
+++ Cell_kernel_4_15_2008/drivers/oprofile/cpu_buffer.c
@@ -224,6 +224,29 @@ static void oprofile_end_trace(struct op
 	cpu_buf->tracing = 0;
 }
 
+/*
+ * The first entry in the per cpu buffer consists of the escape code
and
+ * the VALUE_HEADER_ID value.  The next entry consists of an escape
code
+ * with the value to store.  The syn_buffer routine takes the value
from
+ * the second entry and put it into the kernel buffer.
+ */
+void oprofile_add_value(unsigned long value, int cpu) {
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
+
+	/* Enter a sequence of two events.  The first event says the
+	 * next event contains a value that is to be put directly into the
+	 * event buffer.
+	 */
+
+	if (nr_available_slots(cpu_buf) < 3) {
+		cpu_buf->sample_lost_overflow++;
+		return;
+	}
+
+	add_sample(cpu_buf, ESCAPE_CODE, VALUE_HEADER_ID);
+	add_sample(cpu_buf, ESCAPE_CODE, value);
+}
+
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const
regs,
 				unsigned long event, int is_kernel)
 {
Index: Cell_kernel_4_15_2008/drivers/oprofile/cpu_buffer.h
===================================================================
--- Cell_kernel_4_15_2008.orig/drivers/oprofile/cpu_buffer.h
+++ Cell_kernel_4_15_2008/drivers/oprofile/cpu_buffer.h
@@ -54,5 +54,6 @@ void cpu_buffer_reset(struct oprofile_cp
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define VALUE_HEADER_ID 3
 
 #endif /* OPROFILE_CPU_BUFFER_H */
Index: Cell_kernel_4_15_2008/drivers/oprofile/oprof.c
===================================================================
--- Cell_kernel_4_15_2008.orig/drivers/oprofile/oprof.c
+++ Cell_kernel_4_15_2008/drivers/oprofile/oprof.c
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
Index: Cell_kernel_4_15_2008/include/linux/oprofile.h
===================================================================
--- Cell_kernel_4_15_2008.orig/include/linux/oprofile.h
+++ Cell_kernel_4_15_2008/include/linux/oprofile.h
@@ -56,12 +56,10 @@ struct oprofile_operations {
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
@@ -106,6 +97,17 @@ void oprofile_add_sample(struct pt_regs 
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const
regs,
 				unsigned long event, int is_kernel);
 
+/*
+ * Add a value to the per CPU buffer.  The value is passed from the per
CPU
+ * buffer to the kernel buffer with no additional processing.  The
assumption
+ * is any processing of the value will be done in the postprocessor.
This
+ * function should only be used for special architecture specific data.
+ * Currently only used by the CELL processor.
+ *
+ * This function does not perform a backtrace.
+ */
+void oprofile_add_value(unsigned long value, int cpu);
+
 /* Use this instead when the PC value is not from the regs. Doesn't
  * backtrace. */
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long
event);
Index: Cell_kernel_4_15_2008/include/asm-powerpc/oprofile_impl.h
===================================================================
--- Cell_kernel_4_15_2008.orig/include/asm-powerpc/oprofile_impl.h
+++ Cell_kernel_4_15_2008/include/asm-powerpc/oprofile_impl.h
@@ -48,7 +48,7 @@ struct op_powerpc_model {
 	void (*stop) (void);
 	void (*global_stop) (void);
 	int (*sync_start)(void);
-	int (*sync_stop)(void);
+	void (*sync_stop)(void);
 	void (*handle_interrupt) (struct pt_regs *,
 				  struct op_counter_config *);
 	int num_counters;
Index: Cell_kernel_4_15_2008/drivers/oprofile/event_buffer.h
===================================================================
--- Cell_kernel_4_15_2008.orig/drivers/oprofile/event_buffer.h
+++ Cell_kernel_4_15_2008/drivers/oprofile/event_buffer.h
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
 


