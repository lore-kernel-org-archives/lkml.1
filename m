Return-Path: <linux-kernel-owner+w=401wt.eu-S1945918AbXBVACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918AbXBVACM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945914AbXBVACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:02:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45856 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbXBVACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:02:05 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Carl Love <cel@us.ibm.com>
To: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.ne
Content-Type: text/plain
Date: Wed, 21 Feb 2007 16:02:02 -0800
Message-Id: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third update to the patch previously posted by Maynard
Johnson as "PATCH 4/4. Add support to OProfile for profiling CELL".  

This posting has the following changes:
- Added lib support but it is untested. Waiting on a test case.
- LFSR calculation is completely table driven
- Detecting overlay switches and discarding samples collected when the 
  overlay occured.
- Fixed the Kconfig file.
- RTAS token call and returning error value reworked
- Added lock around the samples array access.
- SPU overlay support validated (there wasn't a bug)
- Misc changes per other minor review commnets

The following are still outstanding issues:
- Samples from dynamic code on the stack (stubs) are still being 
  silently dropped.  Still plan on putting them into anonymous bucket.
- Working on draining samples when context switch occurs.
- File renaming and refactoring suggestions have not been done.  There 
  is still ongoing discussions about this.
- Moving file offset code from kernel to user space has not been done.  
  This is still being discussed.

Would really like to have Anton Blanchard or similar person look over
the non CELL specific OProfile code changes.  

Subject: Add support to OProfile for profiling Cell BE SPUs

From: Maynard Johnson <maynardj@us.ibm.com>

This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
code.

Signed-off-by: Carl Love <carll@us.ibm.com>
Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>

Index: linux-2.6.20/arch/powerpc/configs/cell_defconfig
===================================================================
--- linux-2.6.20.orig/arch/powerpc/configs/cell_defconfig	2007-02-20 13:49:02.021236368 -0600
+++ linux-2.6.20/arch/powerpc/configs/cell_defconfig	2007-02-20 13:49:52.760242968 -0600
@@ -1415,7 +1415,7 @@
 # Instrumentation Support
 #
 CONFIG_PROFILING=y
-CONFIG_OPROFILE=y
+CONFIG_OPROFILE=m
 # CONFIG_KPROBES is not set
 
 #
Index: linux-2.6.20/arch/powerpc/oprofile/cell/pr_util.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20/arch/powerpc/oprofile/cell/pr_util.h	2007-02-21 17:28:54.609263688 -0600
@@ -0,0 +1,88 @@
+ /*
+ * Cell Broadband Engine OProfile Support
+ *
+ * (C) Copyright IBM Corporation 2006
+ *
+ * Author: Maynard Johnson <maynardj@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef PR_UTIL_H
+#define PR_UTIL_H
+
+#include <linux/cpumask.h>
+#include <linux/oprofile.h>
+#include <asm/cell-pmu.h>
+#include <asm/spu.h>
+
+static inline int number_of_online_nodes(void)
+{
+	u32 cpu; u32 tmp;
+	int nodes = 0;
+	for_each_online_cpu(cpu) {
+		tmp = cbe_cpu_to_node(cpu) + 1;
+		if (tmp > nodes)
+			nodes++;
+	}
+	return nodes;
+}
+
+/* Defines used for sync_start */
+#define SKIP_GENERIC_SYNC 0
+#define SYNC_START_ERROR -1
+#define DO_GENERIC_SYNC 1
+
+struct  spu_overlay_info
+{
+	unsigned int vma;
+	unsigned int size;
+	unsigned int offset;
+	unsigned int buf;
+};
+
+struct vma_to_fileoffset_map
+{
+	struct vma_to_fileoffset_map *next;
+	unsigned int vma;
+	unsigned int size;
+	unsigned int offset;
+	unsigned int guard_ptr;
+	unsigned int guard_val;
+};
+
+/* The three functions below are for maintaining and accessing
+ * the vma-to-fileoffset map.
+ */
+struct vma_to_fileoffset_map * create_vma_map(const struct spu * spu,
+					      u64 objectid);
+unsigned int vma_map_lookup(struct vma_to_fileoffset_map *map,
+			    unsigned int vma, const struct spu * aSpu,
+			    int * grd_val);
+void vma_map_free(struct vma_to_fileoffset_map *map);
+
+/*
+ * Entry point for SPU profiling.
+ * cycles_reset is the SPU_CYCLES count value specified by the user.
+ */
+void start_spu_profiling(unsigned int cycles_reset);
+
+void stop_spu_profiling(void);
+
+
+/* add the necessary profiling hooks */
+int spu_sync_start(void);
+
+/* remove the hooks */
+int spu_sync_stop(void);
+
+/* Record SPU program counter samples to the oprofile event buffer. */
+void spu_sync_buffer(int spu_num, unsigned int * samples,
+		     int num_samples);
+
+void set_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset);
+
+#endif    // PR_UTIL_H
Index: linux-2.6.20/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20/arch/powerpc/oprofile/cell/spu_profiler.c	2007-02-21 17:28:54.610263536 -0600
@@ -0,0 +1,220 @@
+/*
+ * Cell Broadband Engine OProfile Support
+ *
+ * (C) Copyright IBM Corporation 2006
+ *
+ * Authors: Maynard Johnson <maynardj@us.ibm.com>
+ *          Carl Love <carll@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/hrtimer.h>
+#include <linux/smp.h>
+#include <linux/slab.h>
+#include <asm/cell-pmu.h>
+#include <asm/time.h>
+#include "pr_util.h"
+
+#define TRACE_ARRAY_SIZE 1024
+#define SCALE_SHIFT 14
+
+static u32 * samples;
+
+static int spu_prof_running = 0;
+static unsigned int profiling_interval = 0;
+
+extern int spu_prof_num_nodes;
+
+
+#define NUM_SPU_BITS_TRBUF 16
+#define SPUS_PER_TB_ENTRY   4
+#define SPUS_PER_NODE       8
+
+#define SPU_PC_MASK         0xFFFF
+
+static spinlock_t sample_array_lock=SPIN_LOCK_UNLOCKED;
+unsigned long sample_array_lock_flags;
+
+void set_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
+{
+	unsigned long nsPerCyc;
+	if (!freq_khz)
+		freq_khz = ppc_proc_freq/1000;
+
+	/* To calculate a timeout in nanoseconds, the basic
+	 * formula is ns = cycles_reset * (NSEC_PER_SEC / cpu frequency).
+	 * To avoid floating point math, we use the scale math
+	 * technique as described in linux/jiffies.h.  We use
+	 * a scale factor of SCALE_SHIFT,which provides 4 decimal places
+	 * of precision, which is close enough for the purpose at hand.
+	 *
+	 * The value of the timeout should be small enough that the hw
+	 * trace buffer will not get more then a bout 1/3 full for the
+	 * maximum user specified (the LFSR value) hw sampling frequency.
+	 * This is to ensure the trace buffer will never fill even if the
+	 * kernel thread scheduling varies under a heavey system load.
+	 */
+
+	nsPerCyc = (USEC_PER_SEC << SCALE_SHIFT)/freq_khz;
+	profiling_interval = (nsPerCyc * cycles_reset) >> SCALE_SHIFT;
+
+}
+
+/*
+ * Extract SPU PC from trace buffer entry
+ */
+static void spu_pc_extract(int cpu, int entry)
+{
+	/* the trace buffer is 128 bits */
+	u64 trace_buffer[2];
+	u64 spu_mask;
+	int spu;
+
+	spu_mask = SPU_PC_MASK;
+
+	/* Each SPU PC is 16 bits; hence, four spus in each of
+	 * the two 64-bit buffer entries that make up the
+	 * 128-bit trace_buffer entry.  Process two 64-bit values
+	 * simultaneously.
+	 * trace[0] SPU PC contents are: 0 1 2 3
+	 * trace[1] SPU PC contents are: 4 5 6 7
+	 */
+
+	cbe_read_trace_buffer(cpu, trace_buffer);
+
+	for (spu = SPUS_PER_TB_ENTRY-1; spu >= 0; spu--) {
+		/* spu PC trace entry is upper 16 bits of the
+		 * 18 bit SPU program counter
+		 */
+		samples[spu * TRACE_ARRAY_SIZE + entry]
+			= (spu_mask & trace_buffer[0]) << 2;
+		samples[(spu + SPUS_PER_TB_ENTRY) * TRACE_ARRAY_SIZE + entry]
+			= (spu_mask & trace_buffer[1]) << 2;
+
+		trace_buffer[0] = trace_buffer[0] >> NUM_SPU_BITS_TRBUF;
+		trace_buffer[1] = trace_buffer[1] >> NUM_SPU_BITS_TRBUF;
+	}
+}
+
+static int cell_spu_pc_collection(int cpu)
+{
+	u32 trace_addr;
+	int entry;
+
+	/* process the collected SPU PC for the node */
+
+	entry = 0;
+
+	trace_addr = cbe_read_pm(cpu, trace_address);
+	while (!(trace_addr & CBE_PM_TRACE_BUF_EMPTY))
+	{
+		/* there is data in the trace buffer to process */
+		spu_pc_extract(cpu, entry);
+
+		entry++;
+
+		if (entry >= TRACE_ARRAY_SIZE)
+			/* spu_samples is full */
+			break;
+
+		trace_addr = cbe_read_pm(cpu, trace_address);
+	}
+
+	return(entry);
+}
+
+
+static int profile_spus(struct hrtimer * timer)
+{
+	ktime_t kt;
+	int cpu, node, k, num_samples, spu_num;
+
+	if (!spu_prof_running)
+		goto stop;
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		node = cbe_cpu_to_node(cpu);
+
+		/* There should only be on kernel thread at a time processing
+		 * the samples.  In the very unlikely case that the processing
+		 * is taking a very long time and multiple kernel threads are
+		 * started to process the samples.  Make sure only one kernel
+		 * thread is working on the samples array at a time.  The
+		 * sample array must be loaded and then processed for a given
+		 * cpu.  The sample array is not per cpu.
+		 */
+		spin_lock_irqsave(&sample_array_lock,
+				  sample_array_lock_flags);
+		num_samples = cell_spu_pc_collection(cpu);
+
+		if (num_samples == 0) {
+			spin_unlock_irqrestore(&sample_array_lock,
+					       sample_array_lock_flags);
+			continue;
+		}
+
+		for (k = 0; k < SPUS_PER_NODE; k++) {
+			spu_num = k + (node * SPUS_PER_NODE);
+			spu_sync_buffer(spu_num,
+					samples + (k * TRACE_ARRAY_SIZE),
+					num_samples);
+		}
+
+		spin_unlock_irqrestore(&sample_array_lock,
+				       sample_array_lock_flags);
+
+	}
+	smp_wmb();
+
+	kt = ktime_set(0, profiling_interval);
+	if (!spu_prof_running)
+		goto stop;
+	hrtimer_forward(timer, timer->base->get_time(), kt);
+	return HRTIMER_RESTART;
+
+ stop:
+	printk(KERN_INFO "SPU_PROF: spu-prof timer ending\n");
+	return HRTIMER_NORESTART;
+}
+
+static struct hrtimer timer;
+/*
+ * Entry point for SPU profiling.
+ * NOTE:  SPU profiling is done system-wide, not per-CPU.
+ *
+ * cycles_reset is the count value specified by the user when
+ * setting up OProfile to count SPU_CYCLES.
+ */
+void start_spu_profiling(unsigned int cycles_reset) {
+
+	ktime_t kt;
+
+	pr_debug("timer resolution: %lu\n",
+		 TICK_NSEC);
+	kt = ktime_set(0, profiling_interval);
+	hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_REL);
+	timer.expires = kt;
+	timer.function = profile_spus;
+
+	/* Allocate arrays for collecting SPU PC samples */
+	samples = (u32 *) kzalloc(SPUS_PER_NODE *
+				  TRACE_ARRAY_SIZE * sizeof(u32), GFP_KERNEL);
+
+	spu_prof_running = 1;
+	hrtimer_start(&timer, kt, HRTIMER_REL);
+}
+
+void stop_spu_profiling(void)
+{
+	spu_prof_running = 0;
+	hrtimer_cancel(&timer);
+	kfree(samples);
+	pr_debug("SPU_PROF: stop_spu_profiling issued\n");
+}
Index: linux-2.6.20/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20/arch/powerpc/oprofile/cell/spu_task_sync.c	2007-02-21 17:28:54.610263536 -0600
@@ -0,0 +1,487 @@
+/*
+ * Cell Broadband Engine OProfile Support
+ *
+ * (C) Copyright IBM Corporation 2006
+ *
+ * Author: Maynard Johnson <maynardj@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/* The purpose of this file is to handle SPU event task switching
+ * and to record SPU context information into the OProfile
+ * event buffer.
+ *
+ * Additionally, the spu_sync_buffer function is provided as a helper
+ * for recoding actual SPU program counter samples to the event buffer.
+ */
+#include <linux/dcookies.h>
+#include <linux/kref.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/numa.h>
+#include <linux/oprofile.h>
+#include <linux/spinlock.h>
+#include "pr_util.h"
+
+#define RELEASE_ALL 9999
+
+static spinlock_t buffer_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t cache_lock = SPIN_LOCK_UNLOCKED;
+static int num_spu_nodes;
+int spu_prof_num_nodes;
+int last_guard_val[MAX_NUMNODES * 8];
+
+/* Container for caching information about an active SPU task. */
+struct cached_info {
+	struct vma_to_fileoffset_map * map;
+	struct spu * the_spu;   /* needed to access pointer to local_store */
+	struct kref cache_ref;
+};
+
+static struct cached_info * spu_info[MAX_NUMNODES * 8];
+
+static void destroy_cached_info(struct kref * kref)
+{
+	struct cached_info * info;
+	info = container_of(kref, struct cached_info, cache_ref);
+	vma_map_free(info->map);
+	kfree(info);
+	module_put(THIS_MODULE);
+}
+
+/* Return the cached_info for the passed SPU number.
+ * ATTENTION:  Callers are responsible for obtaining the
+ *             cache_lock if needed prior to invoking this function.
+ */
+static struct cached_info * get_cached_info(struct spu * the_spu, int spu_num)
+{
+	struct kref * ref;
+	struct cached_info * ret_info = NULL;
+	if (spu_num >= num_spu_nodes) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Invalid index %d into spu info cache\n",
+		       __FUNCTION__, __LINE__, spu_num);
+		goto out;
+	}
+	if (!spu_info[spu_num] && the_spu) {
+		ref = spu_get_profile_private_kref(the_spu->ctx);
+		if (ref) {
+			spu_info[spu_num] = container_of(ref, struct cached_info, cache_ref);
+			kref_get(&spu_info[spu_num]->cache_ref);
+		}
+	}
+
+	ret_info = spu_info[spu_num];
+ out:
+	return ret_info;
+}
+
+
+/* Looks for cached info for the passed spu.  If not found, the
+ * cached info is created for the passed spu.
+ * Returns 0 for success; otherwise, -1 for error.
+ */
+static int
+prepare_cached_spu_info(struct spu * spu, unsigned int objectId)
+{
+	unsigned long flags = 0;
+	struct vma_to_fileoffset_map * new_map;
+	int retval = 0;
+	struct cached_info * info;
+
+        /* We won't bother getting cache_lock here since
+	 * don't do anything with the cached_info that's returned.
+	 */
+	info = get_cached_info(spu, spu->number);
+
+	if (info) {
+		pr_debug("Found cached SPU info.\n");
+		goto out;
+	}
+
+	/* Create cached_info and set spu_info[spu->number] to point to it.
+	 * spu->number is a system-wide value, not a per-node value.
+	 */
+	info = kzalloc(sizeof(struct cached_info), GFP_KERNEL);
+	if (!info) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: create vma_map failed\n",
+		       __FUNCTION__, __LINE__);
+		goto err_alloc;
+	}
+	new_map = create_vma_map(spu, objectId);
+	if (!new_map) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: create vma_map failed\n",
+		       __FUNCTION__, __LINE__);
+		goto err_alloc;
+	}
+
+	pr_debug("Created vma_map\n");
+	info->map = new_map;
+	info->the_spu = spu;
+	kref_init(&info->cache_ref);
+	spin_lock_irqsave(&cache_lock, flags);
+	spu_info[spu->number] = info;
+	/* Increment count before passing off ref to SPUFS. */
+	kref_get(&info->cache_ref);
+
+        /* We increment the module refcount here since SPUFS is
+	 * responsible for the final destruction of the cached_info,
+	 * and it must be able to access the destroy_cached_info()
+	 * function defined in the OProfile module.  We decrement
+	 * the module refcount in destroy_cached_info.
+	 */
+	try_module_get(THIS_MODULE);
+	spu_set_profile_private_kref(spu->ctx, &info->cache_ref,
+				destroy_cached_info);
+	spin_unlock_irqrestore(&cache_lock, flags);
+	goto out;
+
+err_alloc:
+	retval = -1;
+out:
+	return retval;
+}
+
+/*
+ * NOTE:  The caller is responsible for locking the
+ *	  cache_lock prior to calling this function.
+ */
+static int release_cached_info(int spu_index)
+{
+	int index, end;
+	if (spu_index == RELEASE_ALL) {
+		end = num_spu_nodes;
+		index = 0;
+	} else {
+	        if (spu_index >= num_spu_nodes) {
+        	        printk(KERN_ERR "SPU_PROF: "
+			       "%s, line %d: "
+			       "Invalid index %d into spu info cache\n",
+               	               __FUNCTION__, __LINE__, spu_index);
+	                goto out;
+	        }
+		end = spu_index +1;
+		index = spu_index;
+	}
+	for (; index < end; index++) {
+		if (spu_info[index]) {
+			kref_put(&spu_info[index]->cache_ref,
+				 destroy_cached_info);
+			spu_info[index] = NULL;
+		}
+	}
+
+out:
+	return 0;
+}
+
+/* The source code for fast_get_dcookie was "borrowed"
+ * from drivers/oprofile/buffer_sync.c.
+ */
+
+/* Optimisation. We can manage without taking the dcookie sem
+ * because we cannot reach this code without at least one
+ * dcookie user still being registered (namely, the reader
+ * of the event buffer).
+ */
+static inline unsigned long fast_get_dcookie(struct dentry * dentry,
+					     struct vfsmount * vfsmnt)
+{
+	unsigned long cookie;
+
+	if (dentry->d_cookie)
+		return (unsigned long)dentry;
+	get_dcookie(dentry, vfsmnt, &cookie);
+	return cookie;
+}
+
+/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
+ * which corresponds loosely to "application name". Also, determine
+ * the offset for the SPU ELF object.  If computed offset is
+ * non-zero, it implies an embedded SPU object; otherwise, it's a
+ * separate SPU binary, in which case we retrieve it's dcookie.
+ * For the embedded case, we must determine if SPU ELF is embedded
+ * in the executable application or another file (i.e., shared lib).
+ * If embedded in a shared lib, we must get the dcookie and return
+ * that to the caller.
+ */
+static unsigned long
+get_exec_dcookie_and_offset(struct spu * spu, unsigned int * offsetp,
+			    unsigned long * spu_bin_dcookie,
+			    unsigned long * shlib_dcookie, 
+			    unsigned int spu_ref)
+{
+	unsigned long app_cookie = 0;
+	unsigned long * image_cookie = NULL;
+	unsigned int my_offset = 0;
+	struct file * app = NULL;
+	struct vm_area_struct * vma;
+	struct mm_struct * mm = spu->mm;
+
+	if (!mm)
+		goto out;
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (!vma->vm_file)
+			continue;
+		if (!(vma->vm_flags & VM_EXECUTABLE))
+			continue;
+		app_cookie = fast_get_dcookie(vma->vm_file->f_dentry,
+					  vma->vm_file->f_vfsmnt);
+		pr_debug("got dcookie for %s\n",
+			 vma->vm_file->f_dentry->d_name.name);
+		app = vma->vm_file;
+		break;
+	}
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma->vm_start > spu_ref || vma->vm_end <= spu_ref)
+			continue;
+		my_offset = spu_ref - vma->vm_start;
+		if (!vma->vm_file)
+			goto fail_no_image_cookie;
+
+		pr_debug("Found spu ELF at %X(object-id:%X) for file %s\n",
+			 my_offset, spu_ref,
+			 vma->vm_file->f_dentry->d_name.name);
+		*offsetp = my_offset;
+		if (my_offset == 0)
+			image_cookie = spu_bin_dcookie;
+		else if (vma->vm_file != app)
+			image_cookie = shlib_dcookie;
+		break;
+	}
+
+	if (image_cookie) {
+		*image_cookie = fast_get_dcookie(vma->vm_file->f_dentry,
+						 vma->vm_file->f_vfsmnt);
+		pr_debug("got dcookie for %s\n",
+			 vma->vm_file->f_dentry->d_name.name);
+	}
+
+ out:
+	return app_cookie;
+
+ fail_no_image_cookie:
+	printk(KERN_ERR "SPU_PROF: "
+	       "%s, line %d: Cannot find dcookie for SPU binary\n",
+	       __FUNCTION__, __LINE__);
+	goto out;
+}
+
+
+
+/* This function finds or creates cached context information for the
+ * passed SPU and records SPU context information into the OProfile
+ * event buffer.
+ */
+static int process_context_switch(struct spu * spu, unsigned int objectId)
+{
+	unsigned long flags;
+	int retval = 0;
+	unsigned int offset = 0;
+	unsigned long spu_cookie = 0, app_dcookie = 0, shlib_cookie = 0;
+	retval = prepare_cached_spu_info(spu, objectId);
+	if (retval == -1) {
+		goto out;
+	}
+        /* Get dcookie first because a mutex_lock is taken in that
+	 * code path, so interrupts must not be disabled.
+	 */
+	app_dcookie = get_exec_dcookie_and_offset(spu, &offset, &spu_cookie,
+						  &shlib_cookie, objectId);
+
+        /* Record context info in event buffer */
+	spin_lock_irqsave(&buffer_lock, flags);
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(SPU_CTX_SWITCH_CODE);
+	add_event_entry(spu->number);
+	add_event_entry(spu->pid);
+	add_event_entry(spu->tgid);
+	add_event_entry(app_dcookie);
+
+	if (offset) {
+		/* When offset is non-zero, the SPU ELF was embedded;
+		 * otherwise, it was loaded from a separate binary file. For
+		 * embedded case, we record the offset into the embedding file
+		 * where the SPU ELF was placed.  The embedding file may be
+		 * either the executable application binary or shared library.
+		 * For the non-embedded case, we record a dcookie that
+		 * points to the location of the separate SPU binary that was
+		 * loaded.
+		 */
+		if (shlib_cookie) {
+			add_event_entry(SPU_SHLIB_COOKIE_CODE);
+			add_event_entry(shlib_cookie);
+		}
+		add_event_entry(SPU_OFFSET_CODE);
+		add_event_entry(offset);
+	} else {
+		add_event_entry(SPU_COOKIE_CODE);
+		add_event_entry(spu_cookie);
+	}
+	spin_unlock_irqrestore(&buffer_lock, flags);
+	smp_wmb();
+out:
+	return retval;
+}
+
+/*
+ * This function is invoked on either a bind_context or unbind_context.
+ * If called for an unbind_context, the val arg is 0; otherwise,
+ * it is the object-id value for the spu context.
+ * The data arg is of type 'struct spu *'.
+ */
+static int spu_active_notify(struct notifier_block * self, unsigned long val,
+			     void * data)
+{
+	int retval;
+	unsigned long flags = 0;
+	struct spu * the_spu = data;
+	pr_debug("SPU event notification arrived\n");
+	if (!val){
+		spin_lock_irqsave(&cache_lock, flags);
+		retval = release_cached_info(the_spu->number);
+		spin_unlock_irqrestore(&cache_lock, flags);
+	} else {
+		retval = process_context_switch(the_spu, val);
+	}
+	return retval;
+}
+
+static struct notifier_block spu_active = {
+	.notifier_call = spu_active_notify,
+};
+
+/* The main purpose of this function is to synchronize
+ * OProfile with SPUFS by registering to be notified of
+ * SPU task switches.
+ *
+ * NOTE: When profiling SPUs, we must ensure that only
+ * spu_sync_start is invoked and not the generic sync_start
+ * in drivers/oprofile/oprof.c.  A return value of
+ * SKIP_GENERIC_SYNC or SYNC_START_ERROR will
+ * accomplish this.
+ */
+int spu_sync_start(void) {
+	int k;
+	int ret = SKIP_GENERIC_SYNC;
+	int register_ret;
+	unsigned long flags = 0;
+	spu_prof_num_nodes = number_of_online_nodes();
+	num_spu_nodes = spu_prof_num_nodes * 8;
+
+	spin_lock_irqsave(&buffer_lock, flags);
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(SPU_PROFILING_CODE);
+	add_event_entry(num_spu_nodes);
+	spin_unlock_irqrestore(&buffer_lock, flags);
+
+        /* Register for SPU events  */
+	register_ret = spu_switch_event_register(&spu_active);
+	if (register_ret) {
+		ret = SYNC_START_ERROR;
+		goto out;
+	}
+
+	for (k = 0; k < (MAX_NUMNODES * 8); k++)
+		last_guard_val[k] = 0;
+	pr_debug("spu_sync_start -- running.\n");
+out:
+	return ret;
+}
+
+/* Record SPU program counter samples to the oprofile event buffer. */
+void spu_sync_buffer(int spu_num, unsigned int * samples,
+		     int num_samples)
+{
+	unsigned long long file_offset;
+	unsigned long cache_lock_flags = 0;
+	unsigned long buffer_lock_flags = 0;
+	int i;
+	struct vma_to_fileoffset_map * map;
+	struct spu * the_spu;
+	unsigned long long spu_num_ll = spu_num;
+	unsigned long long spu_num_shifted = spu_num_ll << 32;
+	struct cached_info * c_info;
+
+        /* We need to obtain the cache_lock here because it's
+	 * possible that after getting the cached_info, the SPU job
+	 * corresponding to this cached_info may end, thus resulting
+	 * in the destruction of the cached_info.
+	 */
+	spin_lock_irqsave(&cache_lock, cache_lock_flags);
+	c_info = get_cached_info(NULL, spu_num);
+	if (c_info == NULL) {
+        /* This legitimately happens when the SPU task ends before all
+	 * samples are recorded.  No big deal -- so we just drop a few samples.
+	 */
+		pr_debug("SPU_PROF: No cached SPU contex "
+			  "for SPU #%d. Dropping samples.\n", spu_num);
+		spin_unlock_irqrestore(&cache_lock, cache_lock_flags);
+		return ;
+	}
+
+	map = c_info->map;
+	the_spu = c_info->the_spu;
+	spin_lock_irqsave(&buffer_lock, buffer_lock_flags);
+	for (i = 0; i < num_samples; i++) {
+		unsigned int sample = *(samples+i);
+		int grd_val = 0;
+		file_offset = 0;
+		if (sample == 0)
+			continue;
+                file_offset = vma_map_lookup(
+                        map, sample, the_spu, &grd_val);
+
+                /* If overlays are used by this SPU application, the guard
+		 * value is non-zero, indicating which overlay section is in
+		 * use.  We need to discard samples taken during the time
+		 * period which an overlay occurs (i.e., guard value changes).
+		 */
+		if (grd_val && grd_val != last_guard_val[spu_num]) {
+			last_guard_val[spu_num] = grd_val;
+			/* Drop the rest of the samples. */
+			break;
+		}
+			
+		/* For now, we'll drop samples that can't be mapped.
+		 * This can happen for generated stubs executed from
+		 * the SPU stack.  Do we need to record these somehow?
+		 */
+		if (unlikely(file_offset == 0xffffffff))
+			continue;
+		add_event_entry(file_offset | spu_num_shifted);
+	}
+	spin_unlock_irqrestore(&buffer_lock, buffer_lock_flags);
+	spin_unlock_irqrestore(&cache_lock, cache_lock_flags);
+}
+
+
+int spu_sync_stop(void)
+{
+	unsigned long flags = 0;
+	int ret = spu_switch_event_unregister(&spu_active);
+	if (ret) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: spu_switch_event_unregister returned %d\n",
+		       __FUNCTION__, __LINE__, ret);
+		goto out;
+	}
+
+	spin_lock_irqsave(&cache_lock, flags);
+	ret = release_cached_info(RELEASE_ALL);
+	spin_unlock_irqrestore(&cache_lock, flags);
+out:
+	pr_debug("spu_sync_stop -- done.\n");
+	return ret;
+}
+
+
Index: linux-2.6.20/arch/powerpc/oprofile/cell/vma_map.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20/arch/powerpc/oprofile/cell/vma_map.c	2007-02-20 13:49:52.776240536 -0600
@@ -0,0 +1,279 @@
+ /*
+ * Cell Broadband Engine OProfile Support
+ *
+ * (C) Copyright IBM Corporation 2006
+ *
+ * Author: Maynard Johnson <maynardj@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/* The code in this source file is responsible for generating
+ * vma-to-fileOffset maps for both overlay and non-overlay SPU
+ * applications.
+ */
+
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/elf.h>
+#include "pr_util.h"
+
+
+void vma_map_free(struct vma_to_fileoffset_map *map)
+{
+	while (map) {
+		struct vma_to_fileoffset_map *next = map->next;
+		kfree(map);
+		map = next;
+	}
+}
+
+unsigned int
+vma_map_lookup(struct vma_to_fileoffset_map *map, unsigned int vma,
+	       const struct spu * aSpu, int * grd_val)
+{
+	u32 offset = 0xffffffff;
+	u32 ovly_grd;
+	for (; map; map = map->next) {
+		if (vma < map->vma || vma >= map->vma + map->size)
+			continue;
+
+		if (map->guard_ptr) {
+			ovly_grd = *(u32 *)(aSpu->local_store + map->guard_ptr);
+			if (ovly_grd != map->guard_val)
+				continue;
+			*grd_val = ovly_grd;
+		}
+		offset = vma - map->vma + map->offset;
+		break;
+	}
+
+	return offset;
+}
+
+static struct vma_to_fileoffset_map *
+vma_map_add(struct vma_to_fileoffset_map * map, unsigned int vma,
+	    unsigned int size, unsigned int offset, unsigned int guard_ptr,
+	    unsigned int guard_val)
+{
+	struct vma_to_fileoffset_map * new =
+		kzalloc(sizeof(struct vma_to_fileoffset_map), GFP_KERNEL);
+	if (!new) {
+		printk(KERN_ERR "SPU_PROF: %s, line %d: malloc failed\n",
+		       __FUNCTION__, __LINE__);
+		vma_map_free(map);
+		return NULL;
+	}
+
+	new->next = map;
+	new->vma = vma;
+	new->size = size;
+	new->offset = offset;
+	new->guard_ptr = guard_ptr;
+	new->guard_val = guard_val;
+
+	return new;
+}
+
+
+/* Parse SPE ELF header and generate a list of vma_maps.
+ * A pointer to the first vma_map in the generated list
+ * of vma_maps is returned.  */
+struct vma_to_fileoffset_map * create_vma_map(const struct spu * aSpu,
+					      unsigned long spu_elf_start)
+{
+	static const unsigned char expected[EI_PAD] = {
+		[EI_MAG0] = ELFMAG0,
+		[EI_MAG1] = ELFMAG1,
+		[EI_MAG2] = ELFMAG2,
+		[EI_MAG3] = ELFMAG3,
+		[EI_CLASS] = ELFCLASS32,
+		[EI_DATA] = ELFDATA2MSB,
+		[EI_VERSION] = EV_CURRENT,
+		[EI_OSABI] = ELFOSABI_NONE
+	};
+
+	int grd_val;
+	struct vma_to_fileoffset_map * map = NULL;
+	struct spu_overlay_info ovly;
+	unsigned int overlay_tbl_offset = -1;
+	unsigned long phdr_start, shdr_start;
+	Elf32_Ehdr ehdr;
+	Elf32_Phdr phdr;
+	Elf32_Shdr shdr, shdr_str;
+	Elf32_Sym sym;
+	int i, j;
+	char name[32];
+
+	unsigned int ovly_table_sym = 0;
+	unsigned int ovly_buf_table_sym = 0;
+	unsigned int ovly_table_end_sym = 0;
+	unsigned int ovly_buf_table_end_sym = 0;
+	unsigned long ovly_table;
+	unsigned int n_ovlys;
+
+	/* Get and validate ELF header.  */
+
+	if (copy_from_user(&ehdr, (void *) spu_elf_start, sizeof (ehdr)))
+		goto fail;
+
+	if (memcmp(ehdr.e_ident, expected, EI_PAD) != 0) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected e_ident parsing SPU ELF\n",
+		       __FUNCTION__, __LINE__);
+		goto fail;
+	}
+	if (ehdr.e_machine != EM_SPU) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected e_machine parsing SPU ELF\n",
+		       __FUNCTION__,  __LINE__);
+		goto fail;
+	}
+	if (ehdr.e_type != ET_EXEC) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected e_type parsing SPU ELF\n",
+		       __FUNCTION__, __LINE__);
+		goto fail;
+	}
+	phdr_start = spu_elf_start + ehdr.e_phoff;
+	shdr_start = spu_elf_start + ehdr.e_shoff;
+
+	/* Traverse program headers.  */
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		if (copy_from_user(&phdr,
+				   (void *) (phdr_start + i * sizeof(phdr)),
+				   sizeof(phdr)))
+			goto fail;
+
+		if (phdr.p_type != PT_LOAD)
+			continue;
+		if (phdr.p_flags & (1 << 27))
+			continue;
+
+		map = vma_map_add(map, phdr.p_vaddr, phdr.p_memsz,
+				  phdr.p_offset, 0, 0);
+		if (!map)
+			goto fail;
+	}
+
+	pr_debug("SPU_PROF: Created non-overlay maps\n");
+	/* Traverse section table and search for overlay-related symbols.  */
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		if (copy_from_user(&shdr,
+				   (void *) (shdr_start + i * sizeof(shdr)),
+				   sizeof(shdr)))
+			goto fail;
+
+		if (shdr.sh_type != SHT_SYMTAB)
+			continue;
+		if (shdr.sh_entsize != sizeof (sym))
+			continue;
+
+		if (copy_from_user(&shdr_str,
+				   (void *) (shdr_start + shdr.sh_link *
+					     sizeof(shdr)),
+				   sizeof(shdr)))
+			goto fail;
+
+		if (shdr_str.sh_type != SHT_STRTAB)
+			goto fail;;
+
+		for (j = 0; j < shdr.sh_size / sizeof (sym); j++) {
+			if (copy_from_user(&sym, (void *) (spu_elf_start +
+						       shdr.sh_offset + j *
+							   sizeof (sym)),
+					   sizeof (sym)))
+				goto fail;
+
+			if (copy_from_user(name, (void *)
+					   (spu_elf_start + shdr_str.sh_offset +
+					    sym.st_name),
+					   20))
+				goto fail;
+
+			if (memcmp(name, "_ovly_table", 12) == 0)
+				ovly_table_sym = sym.st_value;
+			if (memcmp(name, "_ovly_buf_table", 16) == 0)
+				ovly_buf_table_sym = sym.st_value;
+			if (memcmp(name, "_ovly_table_end", 16) == 0)
+				ovly_table_end_sym = sym.st_value;
+			if (memcmp(name, "_ovly_buf_table_end", 20) == 0)
+				ovly_buf_table_end_sym = sym.st_value;
+		}
+	}
+
+	/* If we don't have overlays, we're done.  */
+	if (ovly_table_sym == 0 || ovly_buf_table_sym == 0
+	    || ovly_table_end_sym == 0 || ovly_buf_table_end_sym == 0) {
+		pr_debug("SPU_PROF: No overlay table found\n");
+		goto out;
+	}
+	else {
+		pr_debug("SPU_PROF: Overlay table found\n");
+	}
+
+        /* The _ovly_table symbol represents a table with one entry
+	 * per overlay section.  The _ovly_buf_table symbol represents
+	 * a table with one entry per overlay region.
+         * The struct spu_overlay_info gives the structure of the _ovly_table
+	 * entries.  The structure of _ovly_table_buf is simply one
+	 * u32 word per entry.
+	 */
+	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym, aSpu, &grd_val);
+	if (overlay_tbl_offset < 0) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Error finding SPU overlay table\n",
+		       __FUNCTION__, __LINE__);
+		goto fail;
+	}
+	ovly_table = spu_elf_start + overlay_tbl_offset;
+
+	n_ovlys = (ovly_table_end_sym -
+		   ovly_table_sym) / sizeof (ovly);
+
+	/* Traverse overlay table.  */
+	for (i = 0; i < n_ovlys; i++) {
+		if (copy_from_user(&ovly, (void *)
+				   (ovly_table + i * sizeof (ovly)),
+				   sizeof (ovly)))
+			goto fail;
+
+		/* The ovly.vma/size/offset arguments are analogous to the same
+		 * arguments used above for non-overlay maps.  The final two
+		 * args are referred to as the guard pointer and the guard
+		 * value.
+		 * The guard pointer is an entry in the _ovly_buf_table,
+		 * computed using ovly.buf as the index into the table.  Since
+		 * ovly.buf values begin at '1' to reference the first (or 0th)
+		 * entry in the _ovly_buf_table, the computation subtracts 1
+		 * from ovly.buf.
+		 * The guard value is stored in the _ovly_buf_table entry and
+		 * is an index (starting at 1) back to the _ovly_table entry
+		 * that is pointing at this _ovly_buf_table entry.  So, for
+		 * example, for an overlay scenario with one overlay segment
+		 * and two overlay sections:
+		 *      - Section 1 points to the first entry of the
+		 *        _ovly_buf_table, which contains a guard value
+		 *        of '1', referencing the first (index=0) entry of
+		 *        _ovly_table.
+		 *      - Section 2 points to the second entry of the
+		 *        _ovly_buf_table, which contains a guard value
+		 *        of '2', referencing the second (index=1) entry of
+		 *        _ovly_table.
+		 */
+		map = vma_map_add(map, ovly.vma, ovly.size, ovly.offset,
+				   ovly_buf_table_sym + (ovly.buf - 1) * 4, i + 1);
+		if (!map)
+			goto fail;
+	}
+	goto out;
+
+ fail:
+	map = NULL;
+ out:
+	return map;
+}
Index: linux-2.6.20/arch/powerpc/oprofile/common.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/common.c	2007-02-20 13:49:02.029235152 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/common.c	2007-02-20 16:42:26.626176048 -0600
@@ -29,6 +29,8 @@
 static struct op_counter_config ctr[OP_MAX_COUNTER];
 static struct op_system_config sys;
 
+static int op_powerpc_flag;
+
 static void op_handle_interrupt(struct pt_regs *regs)
 {
 	model->handle_interrupt(regs, ctr);
@@ -36,25 +38,41 @@
 
 static void op_powerpc_cpu_setup(void *dummy)
 {
-	model->cpu_setup(ctr);
+	int ret;
+
+	ret = model->cpu_setup(ctr);
+
+	if (ret != 0)
+		op_powerpc_flag = ret;
 }
 
 static int op_powerpc_setup(void)
 {
 	int err;
 
+	op_powerpc_flag = 0;
+
 	/* Grab the hardware */
 	err = reserve_pmc_hardware(op_handle_interrupt);
 	if (err)
 		return err;
 
 	/* Pre-compute the values to stuff in the hardware registers.  */
-	model->reg_setup(ctr, &sys, model->num_counters);
+	op_powerpc_flag = model->reg_setup(ctr, &sys, model->num_counters);
 
-	/* Configure the registers on all cpus.  */
+	if (op_powerpc_flag)
+		goto out;
+
+	/* Configure the registers on all cpus.  If an error occurs on one 
+	 * of the cpus, op_powerpc_flag will be set to the error */
 	on_each_cpu(op_powerpc_cpu_setup, NULL, 0, 1);
 
-	return 0;
+out:    if (op_powerpc_flag) {
+		/* error on setup release the performance counter hardware */
+		release_pmc_hardware();
+	}
+
+	return op_powerpc_flag;
 }
 
 static void op_powerpc_shutdown(void)
@@ -64,16 +82,29 @@
 
 static void op_powerpc_cpu_start(void *dummy)
 {
-	model->start(ctr);
+	/* If any of the cpus have return an error, set the
+	 * global flag to the error so it can be returned
+	 * to the generic OProfile caller.
+	 */
+	int ret;
+
+	ret = model->start(ctr);
+	if (ret != 0)
+		op_powerpc_flag = ret;
 }
 
 static int op_powerpc_start(void)
 {
+	op_powerpc_flag = 0;
+
 	if (model->global_start)
-		model->global_start(ctr);
-	if (model->start)
+		return model->global_start(ctr);
+	if (model->start) {
 		on_each_cpu(op_powerpc_cpu_start, NULL, 0, 1);
-	return 0;
+		return op_powerpc_flag;
+	}
+	return -EIO; /* No start function is defined for this
+			power architecture */
 }
 
 static inline void op_powerpc_cpu_stop(void *dummy)
@@ -150,6 +181,8 @@
 #ifdef CONFIG_PPC_CELL_NATIVE
 		case PPC_OPROFILE_CELL:
 			model = &op_model_cell;
+			ops->sync_start = model->sync_start;
+			ops->sync_stop = model->sync_stop;
 			break;
 #endif
 		case PPC_OPROFILE_RS64:
Index: linux-2.6.20/arch/powerpc/oprofile/Kconfig
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/Kconfig	2007-02-20 13:49:02.028235304 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/Kconfig	2007-02-20 13:49:52.779240080 -0600
@@ -7,7 +7,7 @@
 
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
+        depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
@@ -15,3 +15,10 @@
 
 	  If unsure, say N.
 
+config OPROFILE_CELL
+	bool "OProfile for Cell Broadband Engine"
+	depends on (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y) || (SPU_FS = m && OPROFILE = m)
+	default y
+	help
+	  Profiling of Cell BE SPUs requires special support enabled
+	  by this option.
Index: linux-2.6.20/arch/powerpc/oprofile/Makefile
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/Makefile	2007-02-20 13:49:02.027235456 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/Makefile	2007-02-20 13:49:52.781239776 -0600
@@ -11,7 +11,8 @@
 		timer_int.o )
 
 oprofile-y := $(DRIVER_OBJS) common.o backtrace.o
-oprofile-$(CONFIG_PPC_CELL_NATIVE) += op_model_cell.o
+oprofile-$(CONFIG_OPROFILE_CELL) += op_model_cell.o \
+					cell/spu_profiler.o cell/vma_map.o cell/spu_task_sync.o
 oprofile-$(CONFIG_PPC64) += op_model_rs64.o op_model_power4.o
 oprofile-$(CONFIG_FSL_BOOKE) += op_model_fsl_booke.o
 oprofile-$(CONFIG_6xx) += op_model_7450.o
Index: linux-2.6.20/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/op_model_cell.c	2007-02-20 13:49:02.030235000 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/op_model_cell.c	2007-02-20 16:49:48.719198544 -0600
@@ -37,11 +37,21 @@
 #include <asm/system.h>
 
 #include "../platforms/cell/interrupt.h"
+#include "cell/pr_util.h"
+
+/* spu_cycle_reset is the number of cycles between samples.
+ * This variable is used for SPU profiling and should ONLY be set
+ * at the beginning of cell_reg_setup; otherwise, it's read-only.
+ */
+static unsigned int spu_cycle_reset = 0;
+
+#define NUM_SPUS_PER_NODE    8
+#define SPU_CYCLES_EVENT_NUM 2  /*  event number for SPU_CYCLES */
 
 #define PPU_CYCLES_EVENT_NUM 1	/*  event number for CYCLES */
 #define PPU_CYCLES_GRP_NUM   1  /* special group number for identifying
-                                 * PPU_CYCLES event
-                                 */
+				 * PPU_CYCLES event
+				 */
 #define CBE_COUNT_ALL_CYCLES 0x42800000	/* PPU cycle event specifier */
 
 #define NUM_THREADS 2         /* number of physical threads in
@@ -50,6 +60,7 @@
 #define NUM_TRACE_BUS_WORDS 4
 #define NUM_INPUT_BUS_WORDS 2
 
+#define MAX_SPU_COUNT 0xFFFFFF  /* maximum 24 bit LFSR value */
 
 struct pmc_cntrl_data {
 	unsigned long vcntr;
@@ -64,7 +75,7 @@
 
 struct pm_signal {
 	u16 cpu;		/* Processor to modify */
-	u16 sub_unit;		/* hw subunit this applies to (if applicable) */
+	u16 sub_unit;		/* hw subunit this applies to (if applicable)*/
 	short int signal_group;	/* Signal Group to Enable/Disable */
 	u8 bus_word;		/* Enable/Disable on this Trace/Trigger/Event
 				 * Bus Word(s) (bitmask)
@@ -111,6 +122,20 @@
 
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
+/* The CELL profiling code makes rtas calls to setup the debug bus to
+ * route the performance signals.  Additionally, SPU profiling requires
+ * a second rtas call to setup the hardware to capture the SPU PCs.
+ * The EIO error value is returned if the token lookups or the rtas
+ * call fail.  The EIO error number is the best choice of the existing
+ * error numbers.  The probability of rtas related error is very low.  But
+ * by returning EIO and printing additional information to dmsg the user
+ * will know that OProfile did not start and dmesg will tell them why.
+ * OProfile does not support returning errors on Stop.  Not a huge issue
+ * since failure to reset the debug bus or stop the SPU PC collection is
+ * not a fatel issue.  Chances are if the Stop failed, Start doesn't work
+ * either.
+ */
+
 /* Interpetation of hdw_thread:
  * 0 - even virtual cpus 0, 2, 4,...
  * 1 - odd virtual cpus 1, 3, 5, ...
@@ -125,7 +150,8 @@
  * is available.
  */
 static struct pm_signal pm_signal[NR_PHYS_CTRS];
-static int pm_rtas_token;
+static int pm_rtas_token;    /* token for debug bus setup call */
+static int spu_rtas_token;   /* token for SPU cycle profiling */
 
 static u32 reset_value[NR_PHYS_CTRS];
 static int num_counters;
@@ -140,14 +166,15 @@
 /*
  * Firmware interface functions
  */
+
 static int
 rtas_ibm_cbe_perftools(int subfunc, int passthru,
 		       void *address, unsigned long length)
 {
 	u64 paddr = __pa(address);
 
-	return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, passthru,
-			 paddr >> 32, paddr & 0xffffffff, length);
+	return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc,
+			 passthru, paddr >> 32, paddr & 0xffffffff, length);
 }
 
 static void pm_rtas_reset_signals(u32 node)
@@ -174,24 +201,28 @@
 				     &pm_signal_local,
 				     sizeof(struct pm_signal));
 
-	if (ret)
+	if (unlikely(ret))
+		/* Not a fatal error. For Oprofile stop, the oprofile
+		 * functions do not support returning an error for
+		 * failure to stop OProfile.
+		 */
 		printk(KERN_WARNING "%s: rtas returned: %d\n",
 		       __FUNCTION__, ret);
 }
 
-static void pm_rtas_activate_signals(u32 node, u32 count)
+static int pm_rtas_activate_signals(u32 node, u32 count)
 {
 	int ret;
 	int i, j;
 	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
 
 	/* There is no debug setup required for the cycles event.
-	* Note that only events in the same group can be used.
-        * Otherwise, there will be conflicts in correctly routing
-        * the signals on the debug bus.  It is the responsiblity
-        * of the OProfile user tool to check the events are in
-        * the same group.
-        */
+	 * Note that only events in the same group can be used.
+	 * Otherwise, there will be conflicts in correctly routing
+	 * the signals on the debug bus.  It is the responsiblity
+	 * of the OProfile user tool to check the events are in
+	 * the same group.
+	 */
 
 	i = 0;
 	for (j = 0; j < count; j++) {
@@ -212,10 +243,14 @@
 					     pm_signal_local,
 					     i * sizeof(struct pm_signal));
 
-		if (ret)
+		if (unlikely(ret)) {
 			printk(KERN_WARNING "%s: rtas returned: %d\n",
 			       __FUNCTION__, ret);
+			return -EIO;
+		}
 	}
+
+	return 0;
 }
 
 /*
@@ -297,6 +332,7 @@
 					input_bus[j] = i;
 					pm_regs.group_control |=
 					    (i << (31 - i));
+
 					break;
 				}
 			}
@@ -386,9 +422,8 @@
 	u32 cpu;
 	unsigned long flags;
 
-	/* Make sure that the interrupt_hander and
-	 * the virt counter are not both playing with
-	 * the counters on the same node.
+	/* Make sure that the interrupt_hander and the virt counter are
+	 * not both playing with the counters on the same node.
 	 */
 
 	spin_lock_irqsave(&virt_cntr_lock, flags);
@@ -481,17 +516,41 @@
 }
 
 /* This function is called once for all cpus combined */
-static void
+static int
 cell_reg_setup(struct op_counter_config *ctr,
 	       struct op_system_config *sys, int num_ctrs)
 {
 	int i, j, cpu;
+	spu_cycle_reset = 0;
+
+	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
+		spu_cycle_reset = ctr[0].count;
+
+		/* Each node will need to make the rtas call to start
+		 * and stop SPU profiling.  Get the token once and store it.
+		 */
+		spu_rtas_token = rtas_token("ibm,cbe-spu-perftools");
+
+		if (unlikely(spu_rtas_token == RTAS_UNKNOWN_SERVICE)) {
+			printk(KERN_ERR
+			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
+			       __FUNCTION__);
+			return -EIO;
+		}
+	}
 
 	pm_rtas_token = rtas_token("ibm,cbe-perftools");
-	if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "%s: RTAS_UNKNOWN_SERVICE\n",
+
+	/* For all events excetp PPU CYCLEs, each node will need to make
+	 * the rtas cbe-perftools call to setup and reset the debug bus.
+	 * Make the token lookup call once and store it in the global
+	 * variable pm_rtas_token.
+	 */
+	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
+		printk(KERN_ERR
+		       "%s: rtas token ibm,cbe-perftools unknown\n",
 		       __FUNCTION__);
-		goto out;
+		return -EIO;
 	}
 
 	num_counters = num_ctrs;
@@ -568,28 +627,27 @@
 		for (i = 0; i < num_counters; ++i) {
 			per_cpu(pmc_values, cpu)[i] = reset_value[i];
 		}
-out:
-	;
+
+	return 0;
 }
 
+
+
 /* This function is called once for each cpu */
-static void cell_cpu_setup(struct op_counter_config *cntr)
+static int cell_cpu_setup(struct op_counter_config *cntr)
 {
 	u32 cpu = smp_processor_id();
 	u32 num_enabled = 0;
 	int i;
 
+	if (spu_cycle_reset)
+		return 0;
+
 	/* There is one performance monitor per processor chip (i.e. node),
 	 * so we only need to perform this function once per node.
 	 */
 	if (cbe_get_hw_thread_id(cpu))
-		goto out;
-
-	if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "%s: RTAS_UNKNOWN_SERVICE\n",
-		       __FUNCTION__);
-		goto out;
-	}
+		return 0;
 
 	/* Stop all counters */
 	cbe_disable_pm(cpu);
@@ -608,16 +666,283 @@
 		}
 	}
 
-	pm_rtas_activate_signals(cbe_cpu_to_node(cpu), num_enabled);
+	/* the pm_rtas_activate_signals will return -EIO if the FW
+	 * call failed. 
+	 */
+	return (pm_rtas_activate_signals(cbe_cpu_to_node(cpu), num_enabled));
+	
+}
+
+#define ENTRIES  303
+#define MAXLFSR  0xFFFFFF
+
+/* precomputed table of 24 bit LFSR values */
+int initial_lfsr[] =
+{8221349, 12579195, 5379618, 10097839, 7512963, 7519310, 3955098, 10753424,
+ 15507573, 7458917, 285419, 2641121, 9780088, 3915503, 6668768, 1548716,
+ 4885000, 8774424, 9650099, 2044357, 2304411, 9326253, 10332526, 4421547,
+ 3440748, 10179459, 13332843, 10375561, 1313462, 8375100, 5198480, 6071392,
+ 9341783, 1526887, 3985002, 1439429, 13923762, 7010104, 11969769, 4547026,
+ 2040072, 4025602, 3437678, 7939992, 11444177, 4496094, 9803157, 10745556,
+ 3671780, 4257846, 5662259, 13196905, 3237343, 12077182, 16222879, 7587769,
+ 14706824, 2184640, 12591135, 10420257, 7406075, 3648978, 11042541, 15906893,
+ 11914928, 4732944, 10695697, 12928164, 11980531, 4430912, 11939291, 2917017,
+ 6119256, 4172004, 9373765, 8410071, 14788383, 5047459, 5474428, 1737756,
+ 15967514, 13351758, 6691285, 8034329, 2856544, 14394753, 11310160, 12149558,
+ 7487528, 7542781, 15668898, 12525138, 12790975, 3707933, 9106617, 1965401,
+ 16219109, 12801644, 2443203, 4909502, 8762329, 3120803, 6360315, 9309720,
+ 15164599, 10844842, 4456529, 6667610, 14924259, 884312, 6234963, 3326042,
+ 15973422, 13919464, 5272099, 6414643, 3909029, 2764324, 5237926, 4774955,
+ 10445906, 4955302, 5203726, 10798229, 11443419, 2303395, 333836, 9646934,
+ 3464726, 4159182, 568492, 995747, 10318756, 13299332, 4836017, 8237783,
+ 3878992, 2581665, 11394667, 5672745, 14412947, 3159169, 9094251, 16467278,
+ 8671392, 15230076, 4843545, 7009238, 15504095, 1494895, 9627886, 14485051,
+ 8304291, 252817, 12421642, 16085736, 4774072, 2456177, 4160695, 15409741,
+ 4902868, 5793091, 13162925, 16039714, 782255, 11347835, 14884586, 366972,
+ 16308990, 11913488, 13390465, 2958444, 10340278, 1177858, 1319431, 10426302,
+ 2868597, 126119, 5784857, 5245324, 10903900, 16436004, 3389013, 1742384,
+ 14674502, 10279218, 8536112, 10364279, 6877778, 14051163, 1025130, 6072469,
+ 1988305, 8354440, 8216060, 16342977, 13112639, 3976679, 5913576, 8816697,
+ 6879995, 14043764, 3339515, 9364420, 15808858, 12261651, 2141560, 5636398,
+ 10345425, 10414756, 781725, 6155650, 4746914, 5078683, 7469001, 6799140,
+ 10156444, 9667150, 10116470, 4133858, 2121972, 1124204, 1003577, 1611214,
+ 14304602, 16221850, 13878465, 13577744, 3629235, 8772583, 10881308, 2410386,
+ 7300044, 5378855, 9301235, 12755149, 4977682, 8083074, 10327581, 6395087,
+ 9155434, 15501696, 7514362, 14520507, 15808945, 3244584, 4741962, 9658130,
+ 14336147, 8654727, 7969093, 15759799, 14029445, 5038459, 9894848, 8659300,
+ 13699287, 8834306, 10712885, 14753895, 10410465, 3373251, 309501, 9561475,
+ 5526688, 14647426, 14209836, 5339224, 207299, 14069911, 8722990, 2290950,
+ 3258216, 12505185, 6007317, 9218111, 14661019, 10537428, 11731949, 9027003,
+ 6641507, 9490160, 200241, 9720425, 16277895, 10816638, 1554761, 10431375,
+ 7467528, 6790302, 3429078, 14633753, 14428997, 11463204, 3576212, 2003426,
+ 6123687, 820520, 9992513, 15784513, 5778891, 6428165, 8388607};
+
+/*
+ * The hardware uses an LFSR counting sequence to determine when to capture
+ * the SPU PCs.  An LFSR sequence is like a puesdo random number sequence
+ * where each number occurs once in the sequence but the sequence is not in
+ * numerical order. The SPU PC capture is done when the LFSR sequence reaches
+ * the last value in the sequence.  Hence the user specified value N
+ * corresponds to the LFSR number that is N from the end of the sequence.
+ * 
+ * To avoid the time to compute the LFSR, a lookup table is used.  The 24 bit
+ * LFSR sequence is broken into four ranges.  The spacing of the precomputed
+ * values is adjusted in each range so the error between the user specifed
+ * number (N) of events between samples and the actual number of events based
+ * on the precomputed value will be les then about 6.2%.  Note, if the user
+ * specifies N < 2^16, the LFSR value that is 2^16 from the end will be used.
+ * This is to prevent the loss of samples because the trace buffer is full.
+ *
+ *        User specified N                  Step between          Index in
+ *                                      precomputed values      precomputed
+ *                                                                 table
+ * 0               to  2^16-1                  ----                  0
+ * 2^16            to  2^16+2^19-1             2^12                1 to 128
+ * 2^16+2^19       to  2^16+2^19+2^22-1        2^15              129 to 256
+ * 2^16+2^19+2^22  to  2^24-1                  2^18              257 to 302
+ *
+ *
+ * For example, the LFSR values in the second range are computed for 2^16,
+ * 2^16+2^12, ... , 2^19-2^16, 2^19 and stored in the table at indicies
+ * 1, 2,..., 127, 128.
+ * 
+ * The 24 bit LFSR value for the nth number in the sequence can be
+ * calculated using the following code:
+ *
+ * #define size 24
+ * int calculate_lfsr(int n)
+ * {
+ *   int i;
+ *   unsigned int newlfsr0;
+ *   unsigned int lfsr = 0xFFFFFF;
+ *   unsigned int howmany = n;
+ * 
+ *   for (i = 2; i < howmany + 2; i++) {
+ *     newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
+ *     ((lfsr >> (size - 1 - 1)) & 1) ^
+ *     (((lfsr >> (size - 1 - 6)) & 1) ^
+ *     ((lfsr >> (size - 1 - 23)) & 1)));
+ *
+ *     lfsr >>= 1;
+ *     lfsr = lfsr | (newlfsr0 << (size - 1));
+ *   }
+ *   return lfsr;
+ * }
+ */
+
+#define V2_16  (0x1 <<16)
+#define V2_19  (0x1 <<19)
+#define V2_22  (0x1 <<22)
+
+static int calculate_lfsr(int n)
+{
+	/* The ranges and steps are in powers of 2 so the calculations
+	 * can be done using shifts rather then divide.
+	 */
+	int index;
+
+	if ((n >> 16) == 0) {
+		index = 0;
+
+	} else if (((n - V2_16) >> 19) == 0) {
+		index = ((n - V2_16) >> 12) + 1;
+
+	} else if (((n - V2_16 - V2_19) >> 22) == 0) {
+		index = ((n - V2_16 - V2_19) >> 15 ) + 1 + 128;
+
+	} else if (((n - V2_16 - V2_19 - V2_22) >> 24) == 0) {
+		index = ((n - V2_16 - V2_19 - V2_22) >> 18 ) 
+			+ 1 + 256;
+	} 
+
+	if ((index > ENTRIES) || (index < 0))   /* make sure index is 
+						 * valid
+						 */
+		index = ENTRIES-1;
+
+	return initial_lfsr[index];
+}
+
+static int pm_rtas_activate_spu_profiling(u32 node)
+{
+	int ret, i;
+	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
+
+	/* Set up the rtas call to configure the debug bus to
+	 * route the SPU PCs.  Setup the pm_signal for each SPU */
+	for (i = 0; i < NUM_SPUS_PER_NODE; i++) {
+		pm_signal_local[i].cpu = node;
+		pm_signal_local[i].signal_group = 41;
+		pm_signal_local[i].bus_word = 1 << i / 2; /* spu i on
+							   * word (i/2)
+							   */
+		pm_signal_local[i].sub_unit = i;	/* spu i */
+		pm_signal_local[i].bit = 63;
+	}
+
+	ret = rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE,
+				     PASSTHRU_ENABLE, pm_signal_local,
+				     (NUM_SPUS_PER_NODE
+				      * sizeof(struct pm_signal)));
+
+	if (unlikely(ret)) {
+		printk(KERN_WARNING "%s: rtas returned: %d\n",
+		       __FUNCTION__, ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_CPU_FREQ
+static int
+oprof_cpufreq_notify(struct notifier_block *nb, unsigned long val, void *data)
+{
+	int ret = 0;
+	struct cpufreq_freqs * frq = data;
+	if ((val == CPUFREQ_PRECHANGE && frq->old < frq->new) ||
+	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new) ||
+	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE))
+		set_profiling_frequency(frq->new, spu_cycle_reset);
+	return ret;
+}
+
+static struct notifier_block cpu_freq_notifier_block = {
+	.notifier_call	= oprof_cpufreq_notify
+};
+#endif
+
+static int cell_global_start_spu(struct op_counter_config *ctr)
+{
+	int subfunc, rtn_value;
+	unsigned int lfsr_value;
+	int cpu;
+	int ret = 0;
+	int rtas_error = 0;
+	unsigned int cpu_khzfreq = 0;
+
+	/* The SPU profiling uses time-based profiling based on
+	 * cpu frequency, so if configured with the CPU_FREQ
+	 * option, we should detect frequency changes and react
+	 * accordingly.
+	 */
+#ifdef CONFIG_CPU_FREQ
+	ret = cpufreq_register_notifier(&cpu_freq_notifier_block,
+					CPUFREQ_TRANSITION_NOTIFIER);
+	if (ret < 0) 
+		/* this is not a fatal error */
+		printk(KERN_ERR "CPU freq change registration failed: %d\n",
+		       ret);
+
+	else
+		cpu_khzfreq = cpufreq_quick_get(smp_processor_id());
+#endif
+
+	set_profiling_frequency(cpu_khzfreq, spu_cycle_reset);
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+		/* Setup SPU cycle-based profiling.
+		 * Set perf_mon_control bit 0 to a zero before
+		 * enabling spu collection hardware.
+		 */
+		cbe_write_pm(cpu, pm_control, 0);
+
+		if (spu_cycle_reset > MAX_SPU_COUNT)
+			/* use largest possible value
+			 */
+			lfsr_value = calculate_lfsr(MAX_SPU_COUNT-1);
+		else
+		    lfsr_value = calculate_lfsr(spu_cycle_reset);
+
+		if (lfsr_value == 0) {  /* must use a non zero value.  Zero
+					 * disables data collection.
+					 */
+				lfsr_value = calculate_lfsr(1);  
+		}
+
+		lfsr_value = lfsr_value << 8; /* shift lfsr to correct
+					       * register location
+					       */
+
+		/* debug bus setup */
+		ret = pm_rtas_activate_spu_profiling(cbe_cpu_to_node(cpu));
+
+		if (unlikely(ret)) {
+			rtas_error = ret;
+			goto out;
+		}
+
+
+		subfunc = 2;	// 2 - activate SPU tracing, 3 - deactivate
+
+		/* start profiling */
+		rtn_value = rtas_call(spu_rtas_token, 3, 1, NULL, subfunc,
+		  cbe_cpu_to_node(cpu), lfsr_value); 
+
+		if (unlikely(rtn_value != 0)) {
+			printk(KERN_ERR
+			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
+			       __FUNCTION__, rtn_value);
+			rtas_error = -EIO;
+			goto out;
+		}
+	}
+
+	start_spu_profiling(spu_cycle_reset);
+
+	oprofile_running = 1;
+	return 0;
+
 out:
-	;
+	return rtas_error;
 }
 
-static void cell_global_start(struct op_counter_config *ctr)
+static int cell_global_start_ppu(struct op_counter_config *ctr)
 {
-	u32 cpu;
+	u32 cpu, i;
 	u32 interrupt_mask = 0;
-	u32 i;
 
 	/* This routine gets called once for the system.
 	 * There is one performance monitor per node, so we
@@ -656,9 +981,67 @@
 	 * the above for-loop.
 	 */
 	start_virt_cntrs();
+
+	return 0;
 }
 
-static void cell_global_stop(void)
+
+static int cell_global_start(struct op_counter_config *ctr)
+{
+	if (spu_cycle_reset) {
+		return cell_global_start_spu(ctr);
+	} else {
+		return cell_global_start_ppu(ctr);
+	}
+}
+
+static void cell_global_stop_spu(void)
+/* Note the generic OProfile stop calls do not support returning
+ * an error on stop.  Hence, will not return an error if the FW
+ * calls fail on stop.  Failure to reset the debug bus is not an issue.
+ * Failure to disable the SPU profiling is not an issue.  The FW calls
+ * to enable the performance counters and debug bus will work even if
+ * the hardware was not cleanly reset.
+ */
+{
+	int subfunc, rtn_value;
+	unsigned int lfsr_value;
+	int cpu;
+
+	oprofile_running = 0;
+
+#ifdef CONFIG_CPU_FREQ
+	cpufreq_unregister_notifier(&cpu_freq_notifier_block,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+#endif
+
+	for_each_online_cpu(cpu) {
+		if (cbe_get_hw_thread_id(cpu))
+			continue;
+
+		subfunc = 3;	/* 2 - activate SPU tracing,
+				 * 3 - deactivate
+				 */
+		lfsr_value = 0x8f100000;
+
+		rtn_value = rtas_call(spu_rtas_token, 3, 1, NULL,
+				      subfunc, cbe_cpu_to_node(cpu),
+				      lfsr_value);
+
+		if (unlikely(rtn_value != 0)) {
+			printk(KERN_ERR
+			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
+			       __FUNCTION__, rtn_value);
+		}
+
+		/* Deactivate the signals */
+		pm_rtas_reset_signals(cbe_cpu_to_node(cpu));
+	}
+
+	stop_spu_profiling();
+}
+
+static void cell_global_stop_ppu(void)
 {
 	int cpu;
 
@@ -686,6 +1069,15 @@
 	}
 }
 
+static void cell_global_stop(void)
+{
+	if (spu_cycle_reset) {
+		cell_global_stop_spu();
+	} else {
+		cell_global_stop_ppu();
+	}
+}
+
 static void
 cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config *ctr)
 {
@@ -754,10 +1146,33 @@
 	spin_unlock_irqrestore(&virt_cntr_lock, flags);
 }
 
+/* This function is called from the generic OProfile
+ * driver.  When profiling PPUs, we need to do the
+ * generic sync start; otherwise, do spu_sync_start.
+ */
+static int cell_sync_start(void)
+{
+	if (spu_cycle_reset)
+		return spu_sync_start();
+	else
+		return DO_GENERIC_SYNC;
+}
+
+static int cell_sync_stop(void)
+{
+	if (spu_cycle_reset)
+		return spu_sync_stop();
+	else
+		return 1;
+}
+
+
 struct op_powerpc_model op_model_cell = {
 	.reg_setup = cell_reg_setup,
 	.cpu_setup = cell_cpu_setup,
 	.global_start = cell_global_start,
 	.global_stop = cell_global_stop,
+	.sync_start = cell_sync_start,
+	.sync_stop = cell_sync_stop,
 	.handle_interrupt = cell_handle_interrupt,
 };
Index: linux-2.6.20/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/platforms/cell/spufs/sched.c	2007-02-20 13:49:02.023236064 -0600
+++ linux-2.6.20/arch/powerpc/platforms/cell/spufs/sched.c	2007-02-20 13:49:52.793237952 -0600
@@ -194,6 +194,7 @@
 	ctx->spu = spu;
 	ctx->ops = &spu_hw_ops;
 	spu->pid = current->pid;
+	spu->tgid = current->tgid;
 	spu->mm = ctx->owner;
 	mm_needs_global_tlbie(spu->mm);
 	spu->ibox_callback = spufs_ibox_callback;
@@ -238,6 +239,7 @@
 	spu->dma_callback = NULL;
 	spu->mm = NULL;
 	spu->pid = 0;
+	spu->tgid = 0;
 	ctx->ops = &spu_backing_ops;
 	ctx->spu = NULL;
 	spu->flags = 0;
Index: linux-2.6.20/drivers/oprofile/buffer_sync.c
===================================================================
--- linux-2.6.20.orig/drivers/oprofile/buffer_sync.c	2007-02-20 13:49:02.031234848 -0600
+++ linux-2.6.20/drivers/oprofile/buffer_sync.c	2007-02-20 13:49:52.795237648 -0600
@@ -26,6 +26,7 @@
 #include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/oprofile.h>
  
 #include "oprofile_stats.h"
 #include "event_buffer.h"
Index: linux-2.6.20/drivers/oprofile/event_buffer.h
===================================================================
--- linux-2.6.20.orig/drivers/oprofile/event_buffer.h	2007-02-20 13:49:02.031234848 -0600
+++ linux-2.6.20/drivers/oprofile/event_buffer.h	2007-02-20 13:49:52.797237344 -0600
@@ -19,28 +19,10 @@
  
 /* wake up the process sleeping on the event file */
 void wake_up_buffer_waiter(void);
- 
-/* Each escaped entry is prefixed by ESCAPE_CODE
- * then one of the following codes, then the
- * relevant data.
- */
-#define ESCAPE_CODE			~0UL
-#define CTX_SWITCH_CODE 		1
-#define CPU_SWITCH_CODE 		2
-#define COOKIE_SWITCH_CODE 		3
-#define KERNEL_ENTER_SWITCH_CODE	4
-#define KERNEL_EXIT_SWITCH_CODE		5
-#define MODULE_LOADED_CODE		6
-#define CTX_TGID_CODE			7
-#define TRACE_BEGIN_CODE		8
-#define TRACE_END_CODE			9
- 
+
 #define INVALID_COOKIE ~0UL
 #define NO_COOKIE 0UL
 
-/* add data to the event buffer */
-void add_event_entry(unsigned long data);
- 
 extern struct file_operations event_buffer_fops;
  
 /* mutex between sync_cpu_buffers() and the
Index: linux-2.6.20/drivers/oprofile/oprof.c
===================================================================
--- linux-2.6.20.orig/drivers/oprofile/oprof.c	2007-02-20 13:49:02.032234696 -0600
+++ linux-2.6.20/drivers/oprofile/oprof.c	2007-02-20 13:49:52.798237192 -0600
@@ -53,9 +53,23 @@
 	 * us missing task deaths and eventually oopsing
 	 * when trying to process the event buffer.
 	 */
+	if (oprofile_ops.sync_start) {
+		int sync_ret = oprofile_ops.sync_start();
+		switch (sync_ret) {
+			case 0: goto post_sync;
+				break;
+			case 1: goto do_generic;
+				break;
+			case -1: goto out3;
+				break;
+			default: goto out3;
+		}
+	}
+do_generic:
 	if ((err = sync_start()))
 		goto out3;
 
+post_sync:
 	is_setup = 1;
 	mutex_unlock(&start_mutex);
 	return 0;
@@ -118,7 +132,19 @@
 void oprofile_shutdown(void)
 {
 	mutex_lock(&start_mutex);
+        if (oprofile_ops.sync_stop) {
+                int sync_ret = oprofile_ops.sync_stop();
+                switch (sync_ret) {
+                        case 0: goto post_sync;
+                                break;
+                        case 1: goto do_generic;
+                                break;
+			default: goto post_sync;
+                }
+        }
+do_generic:
 	sync_stop();
+post_sync:
 	if (oprofile_ops.shutdown)
 		oprofile_ops.shutdown();
 	is_setup = 0;
Index: linux-2.6.20/include/asm-powerpc/oprofile_impl.h
===================================================================
--- linux-2.6.20.orig/include/asm-powerpc/oprofile_impl.h	2007-02-20 13:49:02.036234088 -0600
+++ linux-2.6.20/include/asm-powerpc/oprofile_impl.h	2007-02-20 13:49:52.800236888 -0600
@@ -39,14 +39,16 @@
 
 /* Per-arch configuration */
 struct op_powerpc_model {
-	void (*reg_setup) (struct op_counter_config *,
+	int (*reg_setup) (struct op_counter_config *,
 			   struct op_system_config *,
 			   int num_counters);
-	void (*cpu_setup) (struct op_counter_config *);
-	void (*start) (struct op_counter_config *);
-        void (*global_start) (struct op_counter_config *);
+	int  (*cpu_setup) (struct op_counter_config *);
+	int  (*start) (struct op_counter_config *);
+        int  (*global_start) (struct op_counter_config *);
 	void (*stop) (void);
 	void (*global_stop) (void);
+	int (*sync_start)(void);
+	int (*sync_stop)(void);
 	void (*handle_interrupt) (struct pt_regs *,
 				  struct op_counter_config *);
 	int num_counters;
Index: linux-2.6.20/include/asm-powerpc/spu.h
===================================================================
--- linux-2.6.20.orig/include/asm-powerpc/spu.h	2007-02-20 13:49:02.036234088 -0600
+++ linux-2.6.20/include/asm-powerpc/spu.h	2007-02-20 13:49:52.803236432 -0600
@@ -129,6 +129,7 @@
 	struct spu_runqueue *rq;
 	unsigned long long timestamp;
 	pid_t pid;
+	pid_t tgid;
 	int class_0_pending;
 	spinlock_t register_lock;
 
@@ -167,6 +168,20 @@
 int spu_irq_class_1_bottom(struct spu *spu);
 void spu_irq_setaffinity(struct spu *spu, int cpu);
 
+/* This interface allows a profiler (e.g., OProfile) to store a ref
+ * to spu context information that it creates.  This caching technique
+ * avoids the need to recreate this information after a save/restore operation.
+ *
+ * Assumes the caller has already incremented the ref count to
+ * profile_info; then spu_context_destroy must call kref_put
+ * on prof_info_kref.
+ */
+void spu_set_profile_private_kref(struct spu_context * ctx, 
+				  struct kref * prof_info_kref,
+				  void (* prof_info_release) (struct kref * kref));
+
+void * spu_get_profile_private_kref(struct spu_context * ctx);
+
 /* system callbacks from the SPU */
 struct spu_syscall_block {
 	u64 nr_ret;
Index: linux-2.6.20/include/linux/oprofile.h
===================================================================
--- linux-2.6.20.orig/include/linux/oprofile.h	2007-02-20 13:49:02.035234240 -0600
+++ linux-2.6.20/include/linux/oprofile.h	2007-02-20 19:27:06.824221368 -0600
@@ -17,6 +17,29 @@
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
  
+/* Each escaped entry is prefixed by ESCAPE_CODE
+ * then one of the following codes, then the
+ * relevant data.
+ * These #defines live in this file so that arch-specific
+ * buffer sync'ing code can access them.
+ */
+#define ESCAPE_CODE                     ~0UL
+#define CTX_SWITCH_CODE                 1
+#define CPU_SWITCH_CODE                 2
+#define COOKIE_SWITCH_CODE              3
+#define KERNEL_ENTER_SWITCH_CODE        4
+#define KERNEL_EXIT_SWITCH_CODE         5
+#define MODULE_LOADED_CODE              6
+#define CTX_TGID_CODE                   7
+#define TRACE_BEGIN_CODE                8
+#define TRACE_END_CODE                  9
+#define XEN_ENTER_SWITCH_CODE          10
+#define SPU_PROFILING_CODE             11
+#define SPU_CTX_SWITCH_CODE            12
+#define SPU_OFFSET_CODE                13
+#define SPU_COOKIE_CODE                14
+#define SPU_SHLIB_COOKIE_CODE          15
+
 struct super_block;
 struct dentry;
 struct file_operations;
@@ -35,6 +58,14 @@
 	int (*start)(void);
 	/* Stop delivering interrupts. */
 	void (*stop)(void);
+	/* Arch-specific buffer sync functions.
+	 * Return value = 0:  Success
+	 * Return value = -1: Failure
+	 * Return value = 1:  Run generic sync function
+	 */
+	int (*sync_start)(void);
+	int (*sync_stop)(void);
+
 	/* Initiate a stack backtrace. Optional. */
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
 	/* CPU identification string. */
@@ -56,6 +87,13 @@
 void oprofile_arch_exit(void);
 
 /**
+ * Add data to the event buffer.
+ * The data passed is free-form, but typically consists of
+ * file offsets, dcookies, context information, and ESCAPE codes.
+ */
+void add_event_entry(unsigned long data);
+
+/**
  * Add a sample. This may be called from any context. Pass
  * smp_processor_id() as cpu.
  */
Index: linux-2.6.20/kernel/hrtimer.c
===================================================================
--- linux-2.6.20.orig/kernel/hrtimer.c	2007-02-20 13:49:02.033234544 -0600
+++ linux-2.6.20/kernel/hrtimer.c	2007-02-20 13:49:52.807235824 -0600
@@ -335,6 +335,7 @@
 
 	return orun;
 }
+EXPORT_SYMBOL_GPL(hrtimer_forward);
 
 /*
  * enqueue_hrtimer - internal function to (re)start a timer
Index: linux-2.6.20/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/kernel/time.c	2007-02-20 13:49:02.025235760 -0600
+++ linux-2.6.20/arch/powerpc/kernel/time.c	2007-02-20 13:49:52.811235216 -0600
@@ -122,6 +122,7 @@
 static long timezone_offset;
 
 unsigned long ppc_proc_freq;
+EXPORT_SYMBOL(ppc_proc_freq);
 unsigned long ppc_tb_freq;
 
 static u64 tb_last_jiffy __cacheline_aligned_in_smp;
Index: linux-2.6.20/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.20.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2007-02-20 13:49:02.023236064 -0600
+++ linux-2.6.20/arch/powerpc/platforms/cell/spufs/spufs.h	2007-02-20 13:49:52.812235064 -0600
@@ -80,6 +80,8 @@
 
 	struct list_head gang_list;
 	struct spu_gang *gang;
+	struct kref * prof_priv_kref;
+	void (* prof_priv_release) (struct kref *kref);
 
 	/* scheduler fields */
  	struct list_head rq;
Index: linux-2.6.20/arch/powerpc/platforms/cell/spufs/context.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/platforms/cell/spufs/context.c	2007-02-20 13:49:02.024235912 -0600
+++ linux-2.6.20/arch/powerpc/platforms/cell/spufs/context.c	2007-02-20 13:49:52.814234760 -0600
@@ -22,6 +22,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
@@ -76,6 +77,8 @@
 	spu_fini_csa(&ctx->csa);
 	if (ctx->gang)
 		spu_gang_remove_ctx(ctx->gang, ctx);
+	if (ctx->prof_priv_kref)
+		kref_put(ctx->prof_priv_kref, ctx->prof_priv_release);
 	kfree(ctx);
 }
 
@@ -202,3 +205,20 @@
 	if (ctx->state != SPU_STATE_SAVED)
 		spu_deactivate(ctx);
 }
+
+void spu_set_profile_private_kref(struct spu_context * ctx, 
+				  struct kref * prof_info_kref,
+				  void (* prof_info_release) (struct kref * kref))
+{
+	ctx->prof_priv_kref = prof_info_kref;
+	ctx->prof_priv_release = prof_info_release;
+}
+EXPORT_SYMBOL_GPL(spu_set_profile_private_kref);
+
+void * spu_get_profile_private_kref(struct spu_context * ctx)
+{
+	return ctx->prof_priv_kref;
+}
+EXPORT_SYMBOL_GPL(spu_get_profile_private_kref);
+
+
Index: linux-2.6.20/include/linux/dcookies.h
===================================================================
--- linux-2.6.20.orig/include/linux/dcookies.h	2007-02-20 13:49:02.034234392 -0600
+++ linux-2.6.20/include/linux/dcookies.h	2007-02-20 13:49:52.815234608 -0600
@@ -12,6 +12,7 @@
 
 #ifdef CONFIG_PROFILING
  
+#include <linux/dcache.h>
 #include <linux/types.h>
  
 struct dcookie_user;
Index: linux-2.6.20/include/linux/elf-em.h
===================================================================
--- linux-2.6.20.orig/include/linux/elf-em.h	2007-02-20 13:49:02.034234392 -0600
+++ linux-2.6.20/include/linux/elf-em.h	2007-02-20 13:49:52.816234456 -0600
@@ -21,6 +21,7 @@
 #define EM_SPARC32PLUS	18	/* Sun's "v8plus" */
 #define EM_PPC		20	/* PowerPC */
 #define EM_PPC64	21       /* PowerPC64 */
+#define EM_SPU		23	/* Cell BE SPU */
 #define EM_SH		42	/* SuperH */
 #define EM_SPARCV9	43	/* SPARC v9 64-bit */
 #define EM_IA_64	50	/* HP/Intel IA-64 */
Index: linux-2.6.20/arch/powerpc/oprofile/op_model_rs64.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/op_model_rs64.c	2007-02-20 13:49:02.027235456 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/op_model_rs64.c	2007-02-20 13:49:52.818234152 -0600
@@ -88,9 +88,9 @@
 
 static int num_counters;
 
-static void rs64_reg_setup(struct op_counter_config *ctr,
-			   struct op_system_config *sys,
-			   int num_ctrs)
+static int rs64_reg_setup(struct op_counter_config *ctr,
+			  struct op_system_config *sys,
+			  int num_ctrs)
 {
 	int i;
 
@@ -100,9 +100,10 @@
 		reset_value[i] = 0x80000000UL - ctr[i].count;
 
 	/* XXX setup user and kernel profiling */
+	return 0;
 }
 
-static void rs64_cpu_setup(struct op_counter_config *ctr)
+static int rs64_cpu_setup(struct op_counter_config *ctr)
 {
 	unsigned int mmcr0;
 
@@ -125,9 +126,11 @@
 	    mfspr(SPRN_MMCR0));
 	dbg("setup on cpu %d, mmcr1 %lx\n", smp_processor_id(),
 	    mfspr(SPRN_MMCR1));
+
+	return 0;
 }
 
-static void rs64_start(struct op_counter_config *ctr)
+static int rs64_start(struct op_counter_config *ctr)
 {
 	int i;
 	unsigned int mmcr0;
@@ -155,6 +158,7 @@
 	mtspr(SPRN_MMCR0, mmcr0);
 
 	dbg("start on cpu %d, mmcr0 %x\n", smp_processor_id(), mmcr0);
+	return 0;
 }
 
 static void rs64_stop(void)
Index: linux-2.6.20/arch/powerpc/oprofile/op_model_power4.c
===================================================================
--- linux-2.6.20.orig/arch/powerpc/oprofile/op_model_power4.c	2007-02-20 13:49:02.029235152 -0600
+++ linux-2.6.20/arch/powerpc/oprofile/op_model_power4.c	2007-02-20 13:49:52.820233848 -0600
@@ -30,7 +30,7 @@
 static u64 mmcr1_val;
 static u64 mmcra_val;
 
-static void power4_reg_setup(struct op_counter_config *ctr,
+static int power4_reg_setup(struct op_counter_config *ctr,
 			     struct op_system_config *sys,
 			     int num_ctrs)
 {
@@ -58,6 +58,8 @@
 		mmcr0_val &= ~MMCR0_PROBLEM_DISABLE;
 	else
 		mmcr0_val |= MMCR0_PROBLEM_DISABLE;
+	
+	return 0;
 }
 
 extern void ppc64_enable_pmcs(void);
@@ -82,7 +84,7 @@
 	return 0;
 }
 
-static void power4_cpu_setup(struct op_counter_config *ctr)
+static int power4_cpu_setup(struct op_counter_config *ctr)
 {
 	unsigned int mmcr0 = mmcr0_val;
 	unsigned long mmcra = mmcra_val;
@@ -109,9 +111,11 @@
 	    mfspr(SPRN_MMCR1));
 	dbg("setup on cpu %d, mmcra %lx\n", smp_processor_id(),
 	    mfspr(SPRN_MMCRA));
+
+	return 0;
 }
 
-static void power4_start(struct op_counter_config *ctr)
+static int power4_start(struct op_counter_config *ctr)
 {
 	int i;
 	unsigned int mmcr0;
@@ -146,6 +150,7 @@
 	oprofile_running = 1;
 
 	dbg("start on cpu %d, mmcr0 %x\n", smp_processor_id(), mmcr0);
+	return 0;
 }
 
 static void power4_stop(void)


