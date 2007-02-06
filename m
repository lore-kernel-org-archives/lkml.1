Return-Path: <linux-kernel-owner+w=401wt.eu-S933111AbXBFA2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbXBFA2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933167AbXBFA2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:28:39 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50221 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbXBFA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:28:33 -0500
Subject: [RFC,PATCH] CELL PPU Oprofile SPU profiling updated patch
From: Carl Love <cel@us.ibm.com>
To: linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain
Date: Mon, 05 Feb 2007 16:28:30 -0800
Message-Id: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first update to the patch previously posted by Maynard
Johnson as "PATCH 4/4. Add support to OProfile for profiling CELL".  

There are still a few items from the comments being discussed
specifically how to profile the dynamic code for the SPFS context switch
code and how to deal with dynamic code stubs for library support.  Our
proposal is to assign the samples from the SPFS and dynamic library code
to an anonymous sample bucket.  The support for properly handling the
symbol extraction in these cases would be deferred to a later SDK.    

There is also a bug in profiling overlay code that we are investigating.

Subject: Add support to OProfile for profiling Cell BE SPUs

From: Maynard Johnson <maynardj@us.ibm.com>

This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
to add in the SPU profiling capabilities.  In addition, a 'cell'
subdirectory
was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
code.

Signed-off-by: Carl Love <carll@us.ibm.com>
Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>

Index: linux-2.6.20-rc1/arch/powerpc/configs/cell_defconfig
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/configs/cell_defconfig	2007-01-18
16:43:14.230540320 -0600
+++ linux-2.6.20-rc1/arch/powerpc/configs/cell_defconfig	2007-02-01
17:21:46.928875304 -0600
@@ -1403,7 +1403,7 @@
 # Instrumentation Support
 #
 CONFIG_PROFILING=y
-CONFIG_OPROFILE=y
+CONFIG_OPROFILE=m
 # CONFIG_KPROBES is not set
 
 #
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/cell/pr_util.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/cell/pr_util.h	2007-02-03
15:56:01.094856152 -0600
@@ -0,0 +1,78 @@
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
u64 objectid);
+unsigned int vma_map_lookup(struct vma_to_fileoffset_map *map, unsigned
int vma,
+			    const struct spu * aSpu);
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
+void set_profiling_frequency(unsigned int freq_khz, unsigned int
cycles_reset);
+
+#endif    // PR_UTIL_H 
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/cell/spu_profiler.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/cell/spu_profiler.c
2007-02-05 09:32:25.708937424 -0600
@@ -0,0 +1,203 @@
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
+void set_profiling_frequency(unsigned int freq_khz, unsigned int
cycles_reset)
+{
+	unsigned long nsPerCyc;
+	if (!freq_khz)
+		freq_khz = ppc_proc_freq/1000;
+
+        /* To calculate a timeout in nanoseconds, the basic
+	 * formula is ns = cycles_reset * (NSEC_PER_SEC / cpu frequency).
+	 * To avoid floating point math, we use the scale math
+	 * technique as described in linux/jiffies.h.  We use
+	 * a scale factor of SCALE_SHIFT,which provides 4 decimal places
+	 * of precision, which is close enough for the purpose at hand.
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
+        /* the trace buffer is 128 bits */
+	u64 trace_buffer[2];
+	u64 spu_pc_lower;  
+	u64 spu_pc_upper;
+	u64 spu_mask;
+	int spu;
+	int node_factor;
+	
+	spu_mask = 0xFFFF;
+	node_factor = cbe_cpu_to_node(cpu) * SPUS_PER_NODE;
+	
+	/* Each SPU PC is 16 bits; hence, four spus in each of 
+	 * the two 64-bit buffer entries that make up the
+	 * 128-bit trace_buffer entry.  Process the upper and
+	 * lower 64-bit values simultaneously.
+	 * trace[0] SPU PC contents are: 0 1 2 3
+	 * trace[1] SPU PC contents are: 4 5 6 7
+	 */
+
+	cbe_read_trace_buffer(cpu, trace_buffer);  
+
+	for (spu = SPUS_PER_TB_ENTRY-1; spu >= 0; spu--) {
+		spu_pc_lower = spu_mask & trace_buffer[0];
+		trace_buffer[0] = trace_buffer[0] >> NUM_SPU_BITS_TRBUF;
+
+		spu_pc_upper = spu_mask & trace_buffer[1];
+		trace_buffer[1] = trace_buffer[1] >> NUM_SPU_BITS_TRBUF;
+		
+		/* spu PC trace entry is upper 16 bits of the
+		 * 18 bit SPU program counter 
+		 */
+		spu_pc_lower = spu_pc_lower << 2;
+		spu_pc_upper = spu_pc_upper << 2;
+		
+		samples[((node_factor + spu) * TRACE_ARRAY_SIZE) + entry]
+			= (u32) spu_pc_lower;
+		samples[((node_factor + spu + SPUS_PER_TB_ENTRY) 
+			 * TRACE_ARRAY_SIZE) + entry] = (u32) spu_pc_upper;
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
+	while ((trace_addr & CBE_PM_TRACE_BUF_EMPTY) != 0x400)
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
+		num_samples = cell_spu_pc_collection(cpu);
+
+		if (num_samples == 0)
+			continue;
+
+		for (k = 0; k < SPUS_PER_NODE; k++) {
+			spu_num = k + (node * SPUS_PER_NODE);
+			spu_sync_buffer(spu_num, 
+					samples + (spu_num * TRACE_ARRAY_SIZE),
+					num_samples);
+		}
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
+        /* Allocate arrays for collecting SPU PC samples */
+	samples = (u32 *) kzalloc(spu_prof_num_nodes * SPUS_PER_NODE * 
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
+
+
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/cell/spu_task_sync.c
2007-02-05 18:07:02.896962904 -0600
@@ -0,0 +1,436 @@
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
+
+#include <linux/notifier.h>
+#include <linux/list.h>
+#include <linux/numa.h>
+#include <linux/mm.h>
+#include <linux/dcookies.h>
+#include <linux/spinlock.h>
+#include <linux/kref.h>
+#include <linux/oprofile.h>
+#include "pr_util.h"
+
+#define RELEASE_ALL 9999
+
+static spinlock_t buffer_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t cache_lock = SPIN_LOCK_UNLOCKED;
+static int num_spu_nodes;
+int spu_prof_num_nodes;
+
+/* Container for caching information about an active SPU task.
+ * 
+ */
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
+}
+
+/* Return the cached_info for the passed SPU number.
+ * 
+ * NOTE: Clients of this function MUST call kref_put()
+ *       when finished using the returned cached_info (if the
+ *       returned value is non-null).
+ */
+static struct cached_info * get_cached_info(struct spu * the_spu, int
spu_num)
+{
+	struct cached_info * ret_info = NULL;
+	unsigned long flags = 0;
+	if (spu_num >= num_spu_nodes) {
+		printk(KERN_ERR "SPU_PROF: " 
+		       "%s, line %d: Invalid index %d into spu info cache\n",
+		       __FUNCTION__, __LINE__, spu_num); 
+		goto out;
+	}
+	spin_lock_irqsave(&cache_lock, flags);
+	if (spu_info[spu_num])
+		kref_get(&spu_info[spu_num]->cache_ref);
+	else if (the_spu)
+		spu_info[spu_num] = (struct cached_info *)
+			spu_get_profile_private(the_spu->ctx);
+
+	ret_info = spu_info[spu_num];
+	spin_unlock_irqrestore(&cache_lock, flags);
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
+	struct cached_info * info = get_cached_info(spu, spu->number);
+
+	if (info) {
+        /* Immedidately put back reference to cached_info since we
don't
+	 * really need it -- just checking whether we have it.
+	 */
+		kref_put(&spu_info[spu->number]->cache_ref,
+			 destroy_cached_info);
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
+	spin_unlock_irqrestore(&cache_lock, flags);
+	/* Increment count before passing off ref to SPUFS. */
+	kref_get(&info->cache_ref);
+	spu_set_profile_private(spu->ctx, info, &info->cache_ref,
+				destroy_cached_info);
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
+			       "%s, line %d: Invalid index %d into spu info cache\n",
+               	               __FUNCTION__, __LINE__, spu_index);
+	                goto out;
+	        }
+		end = spu_index +1;
+		index = spu_index;
+	}
+	for (; index < end; index++) {
+		if (spu_info[index]) {
+			kref_put(&spu_info[index]->cache_ref, destroy_cached_info);
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
+ */
+static unsigned long 
+get_exec_dcookie_and_offset(
+	struct spu * spu, unsigned int * offsetp,
+	unsigned long * spu_bin_dcookie,
+	unsigned int spu_ref)
+{
+	unsigned long cookie = 0;
+	unsigned int my_offset = 0;
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
+		cookie = fast_get_dcookie(vma->vm_file->f_dentry,
+					  vma->vm_file->f_vfsmnt);
+		pr_debug("got dcookie for %s\n",
+			 vma->vm_file->f_dentry->d_name.name);
+		break;
+	}
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma->vm_start > spu_ref || vma->vm_end < spu_ref)
+			continue;
+		my_offset = spu_ref - vma->vm_start;
+		pr_debug("Found spu ELF at "
+			 " %X for file %s\n", my_offset,
+			 vma->vm_file->f_dentry->d_name.name);
+		*offsetp = my_offset;
+		if (my_offset == 0) {
+			if (!vma->vm_file) {
+				goto fail_no_spu_cookie;
+			}
+			*spu_bin_dcookie = fast_get_dcookie(
+				vma->vm_file->f_dentry,
+				vma->vm_file->f_vfsmnt);
+			pr_debug("got dcookie for %s\n",
+				 vma->vm_file->f_dentry->d_name.name);
+		}
+		break;			
+	}
+	
+ out:
+	return cookie;
+
+ fail_no_spu_cookie:
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
+static int process_context_switch(struct spu * spu, unsigned int
objectId)
+{
+	unsigned long flags;
+	int retval = 0;
+	unsigned int offset = 0;
+	unsigned long spu_cookie = 0, app_dcookie = 0;
+	retval = prepare_cached_spu_info(spu, objectId);
+	if (retval == -1) {
+		goto out;
+	}
+        /* Get dcookie first because a mutex_lock is taken in that
+	 * code path, so interrupts must not be disabled.
+	 */
+	app_dcookie = get_exec_dcookie_and_offset(spu, &offset,
+						  &spu_cookie, objectId);
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
+	add_event_entry(ESCAPE_CODE);
+	if (offset) {
+	  /* When offset is non-zero,  this means the SPU ELF was embedded;
+	   * otherwise, it was loaded from a separate binary file.  For the
+	   * embedded case, we record the offset of the SPU ELF into the PPU
+	   * executable; for the non-embedded case, we record a dcookie that
+	   * points to the location of the SPU binary that was loaded.
+	   */
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
+ * This function is invoked on either a bind_context or
unbind_context.  
+ * If called for an unbind_context, the val arg is 0; otherwise, 
+ * it is the object-id value for the spu context.
+ * The data arg is of type 'struct spu *'.
+ */
+static int spu_active_notify(struct notifier_block * self, unsigned
long val,
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
+	pr_debug("spu_sync_start -- running.\n");
+out:
+	return ret;	
+}
+
+/* Record SPU program counter samples to the oprofile event buffer. */
+void spu_sync_buffer(int spu_num, unsigned int * samples, 
+		     int num_samples)
+{
+	unsigned long flags = 0;
+	int i;
+	struct vma_to_fileoffset_map * map;
+	struct spu * the_spu;
+	unsigned long long spu_num_ll = spu_num;
+	unsigned long long spu_num_shifted = spu_num_ll << 32;
+	struct cached_info * c_info = get_cached_info(NULL, spu_num);
+	if (c_info == NULL) {
+        /* This legitimately happens when the SPU task ends before all 
+	 * samples are recorded.  No big deal -- so we just drop a few
samples.
+	 */
+		pr_debug("SPU_PROF: No cached SPU contex "
+			  "for SPU #%d. Dropping samples.\n", spu_num);
+		return ;
+	}
+
+	map = c_info->map;
+	the_spu = c_info->the_spu;
+	spin_lock_irqsave(&buffer_lock, flags);
+	for (i = 0; i < num_samples; i++) {
+		unsigned long long file_offset;
+		unsigned int sample = *(samples+i);
+		if (sample == 0)
+			continue;
+		file_offset = vma_map_lookup(
+			map, sample, the_spu);
+		/* For now, we'll drop samples that can't be mapped.
+		 * This can happen for generated stubs executed from
+		 * the SPU stack.  Do we need to record these somehow?
+		 */
+		if (unlikely(file_offset == -1))
+			continue;
+		add_event_entry(file_offset | spu_num_shifted);
+	}
+	spin_unlock_irqrestore(&buffer_lock, flags);
+	kref_put(&spu_info[spu_num]->cache_ref, destroy_cached_info);
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
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/cell/vma_map.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/cell/vma_map.c	2007-02-01
17:21:46.944872872 -0600
@@ -0,0 +1,229 @@
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
+	       const struct spu * aSpu)
+{
+	u32 offset = -1;
+	u32 ovly_grd;
+	for (; map; map = map->next) {
+		if (vma < map->vma || vma >= map->vma + map->size)
+			continue;
+
+		if (map->guard_ptr) {
+			ovly_grd = *(u32 *)(aSpu->local_store + map->guard_ptr);
+			if (ovly_grd != map->guard_val)
+				continue;
+		}
+		break;
+	}
+
+	if (likely(map != NULL)) {
+		offset = vma - map->vma + map->offset;
+	}
+	return offset;
+}
+
+static struct vma_to_fileoffset_map *
+vma_map_add(struct vma_to_fileoffset_map *map, unsigned int vma,
+	    unsigned int size, unsigned int offset, unsigned int guard_ptr,
+	    unsigned int guard_val)
+{
+	struct vma_to_fileoffset_map *new = kzalloc(sizeof(struct
vma_to_fileoffset_map), GFP_KERNEL);
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
+	struct vma_to_fileoffset_map *map = NULL;
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
+	struct {
+		unsigned int vma;
+		unsigned int size;
+		unsigned int offset;
+		unsigned int buf;
+	} ovly;
+
+	/* Get and validate ELF header.  */
+
+	copy_from_user(&ehdr, (void *) spu_elf_start, sizeof (ehdr));
+	if (memcmp(ehdr.e_ident, expected, EI_PAD) != 0) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected value parsing SPU ELF\n",
+		       __FUNCTION__, __LINE__);
+		return NULL;
+	}
+	if (ehdr.e_machine != 23) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected value parsing SPU ELF\n",
+		       __FUNCTION__,  __LINE__);
+
+		return NULL;
+	}
+	if (ehdr.e_type != ET_EXEC) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Unexpected value parsing SPU ELF\n",
+		       __FUNCTION__, __LINE__);
+		return NULL;
+	}
+	phdr_start = spu_elf_start + ehdr.e_phoff;
+	shdr_start = spu_elf_start + ehdr.e_shoff;
+
+	/* Traverse program headers.  */
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		copy_from_user(&phdr, (void *) (phdr_start + i * sizeof(phdr)), 
+			       sizeof(phdr));
+		if (phdr.p_type != PT_LOAD)
+			continue;
+		if (phdr.p_flags & (1 << 27))
+			continue;
+
+		map = vma_map_add(map, phdr.p_vaddr, phdr.p_memsz, 
+				  phdr.p_offset, 0, 0);
+		if (!map)
+			return NULL;
+	}
+
+	pr_debug("SPU_PROF: Created non-overlay maps\n");	
+	/* Traverse section table and search for overlay-related symbols.  */
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		copy_from_user(&shdr, (void *) (shdr_start + i * sizeof(shdr)), 
+			       sizeof(shdr));
+		if (shdr.sh_type != SHT_SYMTAB)
+			continue;
+		if (shdr.sh_entsize != sizeof (sym))
+			continue;
+
+		copy_from_user(&shdr_str, 
+			       (void *) (shdr_start + shdr.sh_link * sizeof(shdr)),
+			       sizeof(shdr));
+		if (shdr_str.sh_type != SHT_STRTAB)
+			return NULL;
+
+		for (j = 0; j < shdr.sh_size / sizeof (sym); j++) {
+			copy_from_user(&sym, (void *) (spu_elf_start +
+						       shdr.sh_offset + j * sizeof (sym)),
+				       sizeof (sym));
+			copy_from_user(name, (void *) (spu_elf_start + shdr_str.sh_offset + 
+						       sym.st_name),
+				       20);
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
+		return map;
+	}
+	else {
+		pr_debug("SPU_PROF: Overlay table found\n");
+	}
+
+	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym, aSpu);
+	if (overlay_tbl_offset < 0) {
+		printk(KERN_ERR "SPU_PROF: "
+		       "%s, line %d: Error finding SPU overlay table\n",
+		       __FUNCTION__, __LINE__);
+		return NULL;
+	}
+	ovly_table = spu_elf_start + overlay_tbl_offset;
+	n_ovlys = (ovly_table_end_sym - ovly_table_sym) / sizeof (ovly);
+
+	/* Traverse overlay table.  */
+	for (i = 0; i < n_ovlys; i++) {
+		copy_from_user(&ovly, (void *) (ovly_table + i * sizeof (ovly)),
+			       sizeof (ovly));
+		map = vma_map_add(map, ovly.vma, ovly.size, ovly.offset,
+				   ovly_buf_table_sym + (ovly.buf - 1) * 4, i + 1);
+		if (!map)
+			return NULL;
+	}
+	
+	return map;
+}
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/common.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/common.c	2007-01-18
16:43:14.429510072 -0600
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/common.c	2007-02-01
17:21:46.946872568 -0600
@@ -150,6 +150,8 @@
 #ifdef CONFIG_PPC_CELL_NATIVE
 		case PPC_OPROFILE_CELL:
 			model = &op_model_cell;
+			ops->sync_start = model->sync_start;
+			ops->sync_stop = model->sync_stop;
 			break;
 #endif
 		case PPC_OPROFILE_RS64:
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/Kconfig
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/Kconfig	2007-01-18
16:43:14.426510528 -0600
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/Kconfig	2007-02-03
17:05:51.967892936 -0600
@@ -7,7 +7,8 @@
 
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
+	default m
+	depends on SPU_FS && PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/Makefile
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/Makefile	2007-01-18
16:43:14.429510072 -0600
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/Makefile	2007-02-01
17:21:46.948872264 -0600
@@ -11,7 +11,8 @@
 		timer_int.o )
 
 oprofile-y := $(DRIVER_OBJS) common.o backtrace.o
-oprofile-$(CONFIG_PPC_CELL_NATIVE) += op_model_cell.o
+oprofile-$(CONFIG_PPC_CELL_NATIVE) += op_model_cell.o \
+					cell/spu_profiler.o cell/vma_map.o cell/spu_task_sync.o
 oprofile-$(CONFIG_PPC64) += op_model_rs64.o op_model_power4.o
 oprofile-$(CONFIG_FSL_BOOKE) += op_model_fsl_booke.o
 oprofile-$(CONFIG_6xx) += op_model_7450.o
Index: linux-2.6.20-rc1/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/op_model_cell.c
2007-02-01 17:21:38.388840624 -0600
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/op_model_cell.c	2007-02-03
15:59:38.555810464 -0600
@@ -37,6 +37,16 @@
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
+#define SPU_CYCLES_EVENT_NUM 2        /*  event number for SPU_CYCLES
*/
 
 #define PPU_CYCLES_EVENT_NUM 1	/*  event number for CYCLES */
 #define PPU_CYCLES_GRP_NUM   1  /* special group number for identifying
@@ -50,7 +60,6 @@
 #define NUM_TRACE_BUS_WORDS 4
 #define NUM_INPUT_BUS_WORDS 2
 
-
 struct pmc_cntrl_data {
 	unsigned long vcntr;
 	unsigned long evnts;
@@ -140,12 +149,21 @@
 /*
  * Firmware interface functions
  */
+
 static int
 rtas_ibm_cbe_perftools(int subfunc, int passthru,
 		       void *address, unsigned long length)
 {
 	u64 paddr = __pa(address);
 
+	pm_rtas_token = rtas_token("ibm,cbe-perftools");  
+
+	if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
+	  printk(KERN_ERR
+		 "%s: rtas token ibm,cbe-perftools unknown\n",
+		 __FUNCTION__);
+	}
+
 	return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, passthru,
 			 paddr >> 32, paddr & 0xffffffff, length);
 }
@@ -486,7 +504,12 @@
 	       struct op_system_config *sys, int num_ctrs)
 {
 	int i, j, cpu;
+	spu_cycle_reset = 0;
 
+	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
+		spu_cycle_reset = ctr[0].count;
+		return;
+	}
 	pm_rtas_token = rtas_token("ibm,cbe-perftools");
 	if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
 		printk(KERN_WARNING "%s: RTAS_UNKNOWN_SERVICE\n",
@@ -572,6 +595,8 @@
 	;
 }
 
+
+
 /* This function is called once for each cpu */
 static void cell_cpu_setup(struct op_counter_config *cntr)
 {
@@ -579,6 +604,9 @@
 	u32 num_enabled = 0;
 	int i;
 
+	if (spu_cycle_reset)
+		return;
+
 	/* There is one performance monitor per processor chip (i.e. node),
 	 * so we only need to perform this function once per node.
 	 */
@@ -613,11 +641,216 @@
 	;
 }
 
-static void cell_global_start(struct op_counter_config *ctr)
+#define size 24
+#define ENTRIES  (0x1<<8) /* 256 */
+#define MAXLFSR  0xFFFFFF
+
+int initial_lfsr[] =
+{16777215, 3797240, 13519805, 11602690, 6497030, 7614675, 2328937,
2889445,
+ 12364575, 8723156, 2450594, 16280864, 14742496, 10904589, 6434212,
4996256,
+ 5814270, 13014041, 9825245, 410260, 904096, 15151047, 15487695,
3061843,
+ 16482682, 7938572, 4893279, 9390321, 4320879, 5686402, 1711063,
10176714,
+ 4512270, 1057359, 16700434, 5731602, 2070114, 16030890, 1208230,
15603106,
+ 11857845, 6470172, 1362790, 7316876, 8534496, 1629197, 10003072,
1714539,
+ 1814669, 7106700, 5427154, 3395151, 3683327, 12950450, 16620273,
12122372,
+ 7194999, 9952750, 3608260, 13604295, 2266835, 14943567, 7079230,
777380,
+ 4516801, 1737661, 8730333, 13796927, 3247181, 9950017, 3481896,
16527555,
+ 13116123, 14505033, 9781119, 4860212, 7403253, 13264219, 12269980,
100120,
+ 664506, 607795, 8274553, 13133688, 6215305, 13208866, 16439693,
3320753,
+ 8773582, 13874619, 1784784, 4513501, 11002978, 9318515, 3038856,
14254582,
+ 15484958, 15967857, 13504461, 13657322, 14724513, 13955736, 5695315,
7330509,
+ 12630101, 6826854, 439712, 4609055, 13288878, 1309632, 4996398,
11392266,
+ 793740, 7653789, 2472670, 14641200, 5164364, 5482529, 10415855,
1629108,
+ 2012376, 13661123, 14655718, 9534083, 16637925, 2537745, 9787923,
12750103,
+ 4660370, 3283461, 14862772, 7034955, 6679872, 8918232, 6506913,
103649,
+ 6085577, 13324033, 14251613, 11058220, 11998181, 3100233, 468898,
7104918,
+ 12498413, 14408165, 1208514, 15712321, 3088687, 14778333, 3632503,
11151952,
+ 98896, 9159367, 8866146, 4780737, 4925758, 12362320, 4122783, 8543358,
+ 7056879, 10876914, 6282881, 1686625, 5100373, 4573666, 9265515,
13593840,
+ 5853060, 1188880, 4237111, 15765555, 14344137, 4608332, 6590210,
13745050,
+ 10916568, 12340402, 7145275, 4417153, 2300360, 12079643, 7608534,
15238251,
+ 4947424, 7014722, 3984546, 7168073, 10759589, 16293080, 3757181,
4577717,
+ 5163790, 2488841, 4650617, 3650022, 5440654, 1814617, 6939232,
15540909,
+ 501788, 1060986, 5058235, 5078222, 3734500, 10762065, 390862, 5172712,
+ 1070780, 7904429, 1669757, 3439997, 2956788, 14944927, 12496638,
994152,
+ 8901173, 11827497, 4268056, 15725859, 1694506, 5451950, 2892428,
1434298,
+ 9048323, 13558747, 15083840, 8154495, 15830901, 391127, 14970070,
2451434,
+ 2080347, 10775644, 14599429, 12540753, 4813943, 16140655, 2421772,
12724304,
+ 12935733, 7206473, 5697333, 10328104, 2418008, 13547986, 284246,
1732363,
+ 16375319, 8109554, 16372365, 14346072, 1835890, 13059499, 2442500,
4110674};
+
+/*
+ * The hardware uses an LFSR counting sequence to determine when to
capture
+ * the SPU PCs.  The SPU PC capture is done when the LFSR sequence
reaches the
+ * last value in the sequence.  An LFSR sequence is like a puesdo
random 
+ * number sequence where each number occurs once in the sequence but
the 
+ * sequence is not in numerical order.  To reduce the calculation time,
a 
+ * sequence of 256 precomputed values in the LFSR sequence are stored
in a
+ * table.  The nearest precomputed value is used as the initial point
from
+ * which to caculate the desired LFSR value that is n from the end of
the 
+ * sequence.  The lookup table reduces the maximum number of iterations
in 
+ * the loop from 2^24 to 2^16.
+ */
+static int calculate_lfsr(int n)
 {
-	u32 cpu;
+  int i;
+
+  int start_lfsr_index;
+  unsigned int newlfsr0;
+  unsigned int lfsr = MAXLFSR;
+  unsigned int binsize = (MAXLFSR+1)/ENTRIES;
+  unsigned int howmany; 
+
+  start_lfsr_index = (MAXLFSR - n) / binsize;
+  lfsr = initial_lfsr[start_lfsr_index];
+  howmany = (MAXLFSR - n) - (start_lfsr_index * (binsize));
+
+  for (i = 2; i < howmany+2; i++) {
+    newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
+		((lfsr >> (size - 1 - 1)) & 1) ^
+		(((lfsr >> (size - 1 - 6)) & 1) ^
+		 ((lfsr >> (size - 1 - 23)) & 1)));
+
+    lfsr >>= 1;
+    lfsr = lfsr | (newlfsr0 << (size - 1)); 
+  }
+  return lfsr;
+}
+
+static void pm_rtas_activate_spu_profiling(u32 node)
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
+	pm_rtas_token = rtas_token("ibm,cbe-perftools");
+	if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
+		printk(KERN_WARNING "%s: RTAS_UNKNOWN_SERVICE \n",
+		       __FUNCTION__);
+	}
+
+	ret = rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE, PASSTHRU_ENABLE,
+				     pm_signal_local,
+				     8 * sizeof(struct pm_signal)); //FIXME 8 to #define
+
+	if (ret)
+		printk(KERN_WARNING "%s: rtas returned: %d\n",
+		       __FUNCTION__, ret);
+
+}
+
+#ifdef CONFIG_CPU_FREQ
+static int
+oprof_cpufreq_notify(struct notifier_block *nb, unsigned long val, void
*data)
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
+static void cell_global_start_spu(struct op_counter_config *ctr)
+{
+	int subfunc, rtn_value;
+	unsigned int lfsr_value;
+	int cpu;
+	int ret = 0;
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
+		printk(KERN_ERR "CPU freq change registration failed: %d\n",
+		       ret);
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
+		pm_rtas_activate_spu_profiling(cbe_cpu_to_node(cpu));
+
+		if (spu_cycle_reset > 0xFFFFFE) 
+				lfsr_value = calculate_lfsr(1);  /* use largest possible 
+								  *  value 
+								  */
+		else 
+		    lfsr_value = calculate_lfsr(spu_cycle_reset);
+
+		if (lfsr_value == 0) {  /* must use a non zero value.  Zero
+					 * disables data collection.
+					 */
+				lfsr_value = calculate_lfsr(1);  /* use largest possible 
+								  * value 
+								 */
+		}
+
+		lfsr_value = lfsr_value << 8; /* shift lfsr to correct 
+					       * register location
+					       */
+		
+		pm_rtas_token = rtas_token("ibm,cbe-spu-perftools");  
+
+		if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
+			printk(KERN_ERR
+			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
+			       __FUNCTION__);
+		}
+
+		subfunc = 2;	// 2 - activate SPU tracing, 3 - deactivate
+
+		rtn_value = rtas_call(pm_rtas_token, 3, 1, NULL, subfunc,
+			  cbe_cpu_to_node(cpu), lfsr_value);
+
+		if (rtn_value != 0)
+			printk(KERN_ERR
+			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
+			       __FUNCTION__, rtn_value);
+	}
+
+	start_spu_profiling(spu_cycle_reset);
+
+	oprofile_running = 1;
+}
+
+static void cell_global_start_ppu(struct op_counter_config *ctr)
+{
+	u32 cpu, i;
 	u32 interrupt_mask = 0;
-	u32 i;
 
 	/* This routine gets called once for the system.
 	 * There is one performance monitor per node, so we
@@ -658,7 +891,61 @@
 	start_virt_cntrs();
 }
 
-static void cell_global_stop(void)
+
+static void cell_global_start(struct op_counter_config *ctr)
+{
+	if (spu_cycle_reset) {
+		cell_global_start_spu(ctr);
+	} else {
+		cell_global_start_ppu(ctr);
+	}
+}
+
+static void cell_global_stop_spu(void)
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
+		pm_rtas_token = rtas_token("ibm,cbe-spu-perftools");  
+
+		if (pm_rtas_token == RTAS_UNKNOWN_SERVICE) {
+			printk(KERN_ERR
+			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
+			       __FUNCTION__);
+		}
+
+		subfunc = 3;	// 2 - activate SPU tracing, 3 - deactivate
+		lfsr_value = 0x8f100000;
+
+		rtn_value =
+		    rtas_call(pm_rtas_token, 3, 1, NULL, subfunc,
+			      cbe_cpu_to_node(cpu), lfsr_value);
+
+		if (rtn_value != 0)
+			printk
+			    ("ERROR, rtas call ibm,cbe-spu-perftools failed, return = %d\n",
+			     rtn_value);
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
 
@@ -686,6 +973,16 @@
 	}
 }
 
+static void cell_global_stop(void)
+{
+	if (spu_cycle_reset) {
+		cell_global_stop_spu();
+	} else {
+		cell_global_stop_ppu();
+	}
+
+}
+
 static void
 cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config
*ctr)
 {
@@ -754,10 +1051,35 @@
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
+
+
Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/sched.c
2007-02-01 17:21:41.943834416 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/sched.c
2007-02-01 17:21:46.957870896 -0600
@@ -129,6 +129,7 @@
 	ctx->spu = spu;
 	ctx->ops = &spu_hw_ops;
 	spu->pid = current->pid;
+	spu->tgid = current->tgid;
 	spu->prio = current->prio;
 	spu->mm = ctx->owner;
 	mm_needs_global_tlbie(spu->mm);
@@ -161,6 +162,7 @@
 	spu->dma_callback = NULL;
 	spu->mm = NULL;
 	spu->pid = 0;
+	spu->tgid = 0;
 	spu->prio = MAX_PRIO;
 	ctx->ops = &spu_backing_ops;
 	ctx->spu = NULL;
Index: linux-2.6.20-rc1/drivers/oprofile/buffer_sync.c
===================================================================
--- linux-2.6.20-rc1.orig/drivers/oprofile/buffer_sync.c	2007-01-18
16:43:11.675529376 -0600
+++ linux-2.6.20-rc1/drivers/oprofile/buffer_sync.c	2007-02-01
17:21:46.960870440 -0600
@@ -26,6 +26,7 @@
 #include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/oprofile.h>
  
 #include "oprofile_stats.h"
 #include "event_buffer.h"
Index: linux-2.6.20-rc1/drivers/oprofile/event_buffer.h
===================================================================
--- linux-2.6.20-rc1.orig/drivers/oprofile/event_buffer.h	2007-01-18
16:43:11.673529680 -0600
+++ linux-2.6.20-rc1/drivers/oprofile/event_buffer.h	2007-02-01
17:21:46.962870136 -0600
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
Index: linux-2.6.20-rc1/drivers/oprofile/oprof.c
===================================================================
--- linux-2.6.20-rc1.orig/drivers/oprofile/oprof.c	2007-01-18
16:43:11.675529376 -0600
+++ linux-2.6.20-rc1/drivers/oprofile/oprof.c	2007-02-01
17:21:46.964869832 -0600
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
Index: linux-2.6.20-rc1/include/asm-powerpc/oprofile_impl.h
===================================================================
--- linux-2.6.20-rc1.orig/include/asm-powerpc/oprofile_impl.h	2007-01-18
16:43:19.315566704 -0600
+++ linux-2.6.20-rc1/include/asm-powerpc/oprofile_impl.h	2007-02-01
17:21:46.966869528 -0600
@@ -47,6 +47,8 @@
         void (*global_start) (struct op_counter_config *);
 	void (*stop) (void);
 	void (*global_stop) (void);
+	int (*sync_start)(void);
+	int (*sync_stop)(void);
 	void (*handle_interrupt) (struct pt_regs *,
 				  struct op_counter_config *);
 	int num_counters;
Index: linux-2.6.20-rc1/include/asm-powerpc/spu.h
===================================================================
--- linux-2.6.20-rc1.orig/include/asm-powerpc/spu.h	2007-02-01
17:21:41.950833352 -0600
+++ linux-2.6.20-rc1/include/asm-powerpc/spu.h	2007-02-05
08:34:38.498856800 -0600
@@ -128,6 +128,7 @@
 	struct spu_runqueue *rq;
 	unsigned long long timestamp;
 	pid_t pid;
+	pid_t tgid;
 	int prio;
 	int class_0_pending;
 	spinlock_t register_lock;
@@ -153,6 +154,11 @@
 int spu_irq_class_0_bottom(struct spu *spu);
 int spu_irq_class_1_bottom(struct spu *spu);
 void spu_irq_setaffinity(struct spu *spu, int cpu);
+void * spu_get_profile_private(struct spu_context * ctx);
+void spu_set_profile_private(struct spu_context * ctx, void *
profile_info,
+			     struct kref * prof_info_kref, 
+			     void (* prof_info_release) (struct kref * kref));
+
 
 /* system callbacks from the SPU */
 struct spu_syscall_block {
Index: linux-2.6.20-rc1/include/linux/oprofile.h
===================================================================
--- linux-2.6.20-rc1.orig/include/linux/oprofile.h	2007-01-18
16:43:18.379575976 -0600
+++ linux-2.6.20-rc1/include/linux/oprofile.h	2007-02-01
17:21:46.970868920 -0600
@@ -17,6 +17,28 @@
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
+
 struct super_block;
 struct dentry;
 struct file_operations;
@@ -35,6 +57,14 @@
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
@@ -56,6 +86,13 @@
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
Index: linux-2.6.20-rc1/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc1.orig/kernel/hrtimer.c	2007-01-18 16:43:05.808489704
-0600
+++ linux-2.6.20-rc1/kernel/hrtimer.c	2007-02-01 17:21:46.973868464
-0600
@@ -335,6 +335,7 @@
 
 	return orun;
 }
+EXPORT_SYMBOL_GPL(hrtimer_forward);
 
 /*
  * enqueue_hrtimer - internal function to (re)start a timer
Index: linux-2.6.20-rc1/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/kernel/time.c	2007-02-02
15:47:08.624906680 -0600
+++ linux-2.6.20-rc1/arch/powerpc/kernel/time.c	2007-02-02
17:06:28.183894912 -0600
@@ -122,6 +122,7 @@
 static long timezone_offset;
 
 unsigned long ppc_proc_freq;
+EXPORT_SYMBOL(ppc_proc_freq);
 unsigned long ppc_tb_freq;
 
 static u64 tb_last_jiffy __cacheline_aligned_in_smp;
Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/spufs.h
2007-02-01 17:21:41.945834112 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/spufs.h
2007-02-05 08:06:01.793907392 -0600
@@ -75,6 +75,9 @@
 
 	struct list_head gang_list;
 	struct spu_gang *gang;
+	void * profile_private;		/* To be used only by profiler */
+	struct kref * prof_priv_kref;
+	void (* prof_priv_release) (struct kref *kref);
 };
 
 struct spu_gang {
Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/context.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/context.c
2007-02-05 14:42:04.359859432 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/context.c
2007-02-05 15:17:02.939929352 -0600
@@ -22,6 +22,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
@@ -71,6 +72,7 @@
 	spu_fini_csa(&ctx->csa);
 	if (ctx->gang)
 		spu_gang_remove_ctx(ctx->gang, ctx);
+	kref_put(ctx->prof_priv_kref, ctx->prof_priv_release);
 	kfree(ctx);
 }
 
@@ -200,3 +202,31 @@
 
 	downgrade_write(&ctx->state_sema);
 }
+
+/* This interface allows a profiler (e.g., OProfile) to store
+ * spu_context information needed for profiling, allowing it to
+ * be saved across context save/restore operation.
+ *
+ * Assumes the caller has already incremented the ref count to
+ * profile_info; then spu_context_destroy must call kref_put
+ * on prof_info_kref.
+ */
+void spu_set_profile_private(struct spu_context * ctx, void *
profile_info,
+			     struct kref * prof_info_kref,
+			     void (* prof_info_release) (struct kref * kref))
+{
+	ctx->profile_private = profile_info;
+	ctx->prof_priv_kref = prof_info_kref;
+	ctx->prof_priv_release = prof_info_release;
+}
+EXPORT_SYMBOL_GPL(spu_set_profile_private);
+
+void * spu_get_profile_private(struct spu_context * ctx)
+{
+	if (ctx->profile_private)
+		kref_get(ctx->prof_priv_kref);
+	return ctx->profile_private;
+}
+EXPORT_SYMBOL_GPL(spu_get_profile_private);
+
+


