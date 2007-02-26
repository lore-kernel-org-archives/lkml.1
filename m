Return-Path: <linux-kernel-owner+w=401wt.eu-S1161424AbXBZXvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161424AbXBZXvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161428AbXBZXvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:51:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:59714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161427AbXBZXvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:51:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Tue, 27 Feb 2007 00:50:59 +0100
User-Agent: KMail/1.9.6
Cc: Carl Love <cel@us.ibm.com>, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
References: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com>
In-Reply-To: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702270051.00393.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/oN9RCzQTBTnJp63YXb83VcL1hCAidIAUyquN
 Og+fkNss/r2f5ACBeT+70bA64vnk72w7X21hAo35AIX/i2d3O1
 cUSU2gEpZDqkOWBd89N+A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007, Carl Love wrote:
> This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
> to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
> was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
> code.

There was a significant amount of whitespace breakage in this patch,
which I cleaned up. The patch below consists of the other things
I changed as a further cleanup. Note that I changed the format
of the context switch record, which I found too complicated, as
I described on IRC last week.

	Arnd <><

--
Subject: cleanup spu oprofile code

From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
This cleans up some of the new oprofile code. It's mostly
cosmetic changes, like way multi-line comments are formatted.
The most significant change is a simplification of the
context-switch record format.

It does mean the oprofile report tool needs to be adapted,
but I'm sure that it pays off in the end.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Index: linux-2.6/arch/powerpc/oprofile/cell/spu_task_sync.c
===================================================================
--- linux-2.6.orig/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ linux-2.6/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -61,11 +61,12 @@ static void destroy_cached_info(struct k
 static struct cached_info * get_cached_info(struct spu * the_spu, int spu_num)
 {
 	struct kref * ref;
-	struct cached_info * ret_info = NULL;
+	struct cached_info * ret_info;
 	if (spu_num >= num_spu_nodes) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Invalid index %d into spu info cache\n",
 		       __FUNCTION__, __LINE__, spu_num);
+		ret_info = NULL;
 		goto out;
 	}
 	if (!spu_info[spu_num] && the_spu) {
@@ -89,9 +90,9 @@ static struct cached_info * get_cached_i
 static int
 prepare_cached_spu_info(struct spu * spu, unsigned int objectId)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct vma_to_fileoffset_map * new_map;
-	int retval = 0;
+	int retval;
 	struct cached_info * info;
 
 	/* We won't bother getting cache_lock here since
@@ -112,6 +113,7 @@ prepare_cached_spu_info(struct spu * spu
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
 		       __FUNCTION__, __LINE__);
+		retval = -ENOMEM;
 		goto err_alloc;
 	}
 	new_map = create_vma_map(spu, objectId);
@@ -119,6 +121,7 @@ prepare_cached_spu_info(struct spu * spu
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
 		       __FUNCTION__, __LINE__);
+		retval = -ENOMEM;
 		goto err_alloc;
 	}
 
@@ -144,7 +147,7 @@ prepare_cached_spu_info(struct spu * spu
 	goto out;
 
 err_alloc:
-	retval = -1;
+	kfree(info);
 out:
 	return retval;
 }
@@ -215,11 +218,9 @@ static inline unsigned long fast_get_dco
 static unsigned long
 get_exec_dcookie_and_offset(struct spu * spu, unsigned int * offsetp,
 			    unsigned long * spu_bin_dcookie,
-			    unsigned long * shlib_dcookie,
 			    unsigned int spu_ref)
 {
 	unsigned long app_cookie = 0;
-	unsigned long * image_cookie = NULL;
 	unsigned int my_offset = 0;
 	struct file * app = NULL;
 	struct vm_area_struct * vma;
@@ -252,24 +253,17 @@ get_exec_dcookie_and_offset(struct spu *
 			 my_offset, spu_ref,
 			 vma->vm_file->f_dentry->d_name.name);
 		*offsetp = my_offset;
-		if (my_offset == 0)
-			image_cookie = spu_bin_dcookie;
-		else if (vma->vm_file != app)
-			image_cookie = shlib_dcookie;
 		break;
 	}
 
-	if (image_cookie) {
-		*image_cookie = fast_get_dcookie(vma->vm_file->f_dentry,
+	*spu_bin_dcookie = fast_get_dcookie(vma->vm_file->f_dentry,
 						 vma->vm_file->f_vfsmnt);
-		pr_debug("got dcookie for %s\n",
-			 vma->vm_file->f_dentry->d_name.name);
-	}
+	pr_debug("got dcookie for %s\n", vma->vm_file->f_dentry->d_name.name);
 
- out:
+out:
 	return app_cookie;
 
- fail_no_image_cookie:
+fail_no_image_cookie:
 	printk(KERN_ERR "SPU_PROF: "
 		"%s, line %d: Cannot find dcookie for SPU binary\n",
 		__FUNCTION__, __LINE__);
@@ -285,18 +279,18 @@ get_exec_dcookie_and_offset(struct spu *
 static int process_context_switch(struct spu * spu, unsigned int objectId)
 {
 	unsigned long flags;
-	int retval = 0;
-	unsigned int offset = 0;
-	unsigned long spu_cookie = 0, app_dcookie = 0, shlib_cookie = 0;
+	int retval;
+	unsigned int offset;
+	unsigned long spu_cookie, app_dcookie;
+
 	retval = prepare_cached_spu_info(spu, objectId);
-	if (retval == -1) {
+	if (retval)
 		goto out;
-	}
+
 	/* Get dcookie first because a mutex_lock is taken in that
 	 * code path, so interrupts must not be disabled.
 	 */
-	app_dcookie = get_exec_dcookie_and_offset(spu, &offset, &spu_cookie,
-						  &shlib_cookie, objectId);
+	app_dcookie = get_exec_dcookie_and_offset(spu, &offset, &spu_cookie, objectId);
 
 	/* Record context info in event buffer */
 	spin_lock_irqsave(&buffer_lock, flags);
@@ -306,27 +300,8 @@ static int process_context_switch(struct
 	add_event_entry(spu->pid);
 	add_event_entry(spu->tgid);
 	add_event_entry(app_dcookie);
-
-	if (offset) {
-		/* When offset is non-zero, the SPU ELF was embedded;
-		 * otherwise, it was loaded from a separate binary file. For
-		 * embedded case, we record the offset into the embedding file
-		 * where the SPU ELF was placed.  The embedding file may be
-		 * either the executable application binary or shared library.
-		 * For the non-embedded case, we record a dcookie that
-		 * points to the location of the separate SPU binary that was
-		 * loaded.
-		 */
-		if (shlib_cookie) {
-			add_event_entry(SPU_SHLIB_COOKIE_CODE);
-			add_event_entry(shlib_cookie);
-		}
-		add_event_entry(SPU_OFFSET_CODE);
-		add_event_entry(offset);
-	} else {
-		add_event_entry(SPU_COOKIE_CODE);
-		add_event_entry(spu_cookie);
-	}
+	add_event_entry(spu_cookie);
+	add_event_entry(offset);
 	spin_unlock_irqrestore(&buffer_lock, flags);
 	smp_wmb();
 out:
@@ -343,8 +318,8 @@ static int spu_active_notify(struct noti
 				void * data)
 {
 	int retval;
-	unsigned long flags = 0;
-	struct spu * the_spu = data;
+	unsigned long flags;
+	struct spu *the_spu = data;
 	pr_debug("SPU event notification arrived\n");
 	if (!val){
 		spin_lock_irqsave(&cache_lock, flags);
@@ -403,8 +378,7 @@ void spu_sync_buffer(int spu_num, unsign
 		     int num_samples)
 {
 	unsigned long long file_offset;
-	unsigned long cache_lock_flags = 0;
-	unsigned long buffer_lock_flags = 0;
+	unsigned long flags;
 	int i;
 	struct vma_to_fileoffset_map * map;
 	struct spu * the_spu;
@@ -417,29 +391,27 @@ void spu_sync_buffer(int spu_num, unsign
 	 * corresponding to this cached_info may end, thus resulting
 	 * in the destruction of the cached_info.
 	 */
-	spin_lock_irqsave(&cache_lock, cache_lock_flags);
+	spin_lock_irqsave(&cache_lock, flags);
 	c_info = get_cached_info(NULL, spu_num);
-	if (c_info == NULL) {
+	if (!c_info) {
 	/* This legitimately happens when the SPU task ends before all
 	 * samples are recorded.  No big deal -- so we just drop a few samples.
 	 */
 		pr_debug("SPU_PROF: No cached SPU contex "
 			  "for SPU #%d. Dropping samples.\n", spu_num);
-		spin_unlock_irqrestore(&cache_lock, cache_lock_flags);
-		return ;
+		goto out;
 	}
 
 	map = c_info->map;
 	the_spu = c_info->the_spu;
-	spin_lock_irqsave(&buffer_lock, buffer_lock_flags);
+	spin_lock(&buffer_lock);
 	for (i = 0; i < num_samples; i++) {
 		unsigned int sample = *(samples+i);
 		int grd_val = 0;
 		file_offset = 0;
 		if (sample == 0)
 			continue;
-		file_offset = vma_map_lookup(
-			map, sample, the_spu, &grd_val);
+		file_offset = vma_map_lookup( map, sample, the_spu, &grd_val);
 
 		/* If overlays are used by this SPU application, the guard
 		 * value is non-zero, indicating which overlay section is in
@@ -460,8 +432,9 @@ void spu_sync_buffer(int spu_num, unsign
 			continue;
 		add_event_entry(file_offset | spu_num_shifted);
 	}
-	spin_unlock_irqrestore(&buffer_lock, buffer_lock_flags);
-	spin_unlock_irqrestore(&cache_lock, cache_lock_flags);
+	spin_unlock(&buffer_lock);
+out:
+	spin_unlock_irqrestore(&cache_lock, flags);
 }
 
 
Index: linux-2.6/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- linux-2.6.orig/arch/powerpc/oprofile/op_model_cell.c
+++ linux-2.6/arch/powerpc/oprofile/op_model_cell.c
@@ -40,7 +40,8 @@
 #include "../platforms/cell/cbe_regs.h"
 #include "cell/pr_util.h"
 
-/* spu_cycle_reset is the number of cycles between samples.
+/*
+ * spu_cycle_reset is the number of cycles between samples.
  * This variable is used for SPU profiling and should ONLY be set
  * at the beginning of cell_reg_setup; otherwise, it's read-only.
  */
@@ -73,7 +74,6 @@ struct pmc_cntrl_data {
 /*
  * ibm,cbe-perftools rtas parameters
  */
-
 struct pm_signal {
 	u16 cpu;		/* Processor to modify */
 	u16 sub_unit;		/* hw subunit this applies to (if applicable)*/
@@ -123,7 +123,8 @@ static DEFINE_PER_CPU(unsigned long[NR_P
 
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
-/* The CELL profiling code makes rtas calls to setup the debug bus to
+/*
+ * The CELL profiling code makes rtas calls to setup the debug bus to
  * route the performance signals.  Additionally, SPU profiling requires
  * a second rtas call to setup the hardware to capture the SPU PCs.
  * The EIO error value is returned if the token lookups or the rtas
@@ -137,16 +138,21 @@ static struct pmc_cntrl_data pmc_cntrl[N
  * either.
  */
 
-/* Interpetation of hdw_thread:
+/*
+ * Interpetation of hdw_thread:
  * 0 - even virtual cpus 0, 2, 4,...
  * 1 - odd virtual cpus 1, 3, 5, ...
+ *
+ * FIXME: this is strictly wrong, we need to clean this up in a number
+ * of places. It works for now. -arnd
  */
 static u32 hdw_thread;
 
 static u32 virt_cntr_inter_mask;
 static struct timer_list timer_virt_cntr;
 
-/* pm_signal needs to be global since it is initialized in
+/*
+ * pm_signal needs to be global since it is initialized in
  * cell_reg_setup at the time when the necessary information
  * is available.
  */
@@ -167,7 +173,6 @@ static unsigned char input_bus[NUM_INPUT
 /*
  * Firmware interface functions
  */
-
 static int
 rtas_ibm_cbe_perftools(int subfunc, int passthru,
 		       void *address, unsigned long length)
@@ -183,12 +188,13 @@ static void pm_rtas_reset_signals(u32 no
 	int ret;
 	struct pm_signal pm_signal_local;
 
-	/*  The debug bus is being set to the passthru disable state.
-	 *  However, the FW still expects atleast one legal signal routing
-	 *  entry or it will return an error on the arguments.	If we don't
-	 *  supply a valid entry, we must ignore all return values.  Ignoring
-	 *  all return values means we might miss an error we should be
-	 *  concerned about.
+	/*
+	 * The debug bus is being set to the passthru disable state.
+	 * However, the FW still expects atleast one legal signal routing
+	 * entry or it will return an error on the arguments.	If we don't
+	 * supply a valid entry, we must ignore all return values.  Ignoring
+	 * all return values means we might miss an error we should be
+	 * concerned about.
 	 */
 
 	/*  fw expects physical cpu #. */
@@ -203,7 +209,8 @@ static void pm_rtas_reset_signals(u32 no
 				     sizeof(struct pm_signal));
 
 	if (unlikely(ret))
-		/* Not a fatal error. For Oprofile stop, the oprofile
+		/*
+		 * Not a fatal error. For Oprofile stop, the oprofile
 		 * functions do not support returning an error for
 		 * failure to stop OProfile.
 		 */
@@ -217,7 +224,8 @@ static int pm_rtas_activate_signals(u32 
 	int i, j;
 	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
 
-	/* There is no debug setup required for the cycles event.
+	/*
+	 * There is no debug setup required for the cycles event.
 	 * Note that only events in the same group can be used.
 	 * Otherwise, there will be conflicts in correctly routing
 	 * the signals on the debug bus.  It is the responsiblity
@@ -295,7 +303,8 @@ static void set_pm_event(u32 ctr, int ev
 	pm_regs.pm07_cntrl[ctr] |= PM07_CTR_POLARITY(polarity);
 	pm_regs.pm07_cntrl[ctr] |= PM07_CTR_INPUT_CONTROL(input_control);
 
-	/* Some of the islands signal selection is based on 64 bit words.
+	/*
+	 * Some of the islands signal selection is based on 64 bit words.
 	 * The debug bus words are 32 bits, the input words to the performance
 	 * counters are defined as 32 bits.  Need to convert the 64 bit island
 	 * specification to the appropriate 32 input bit and bus word for the
@@ -345,7 +354,8 @@ out:
 
 static void write_pm_cntrl(int cpu)
 {
-	/* Oprofile will use 32 bit counters, set bits 7:10 to 0
+	/*
+	 * Oprofile will use 32 bit counters, set bits 7:10 to 0
 	 * pmregs.pm_cntrl is a global
 	 */
 
@@ -362,7 +372,8 @@ static void write_pm_cntrl(int cpu)
 	if (pm_regs.pm_cntrl.freeze == 1)
 		val |= CBE_PM_FREEZE_ALL_CTRS;
 
-	/* Routine set_count_mode must be called previously to set
+	/*
+	 * Routine set_count_mode must be called previously to set
 	 * the count mode based on the user selection of user and kernel.
 	 */
 	val |= CBE_PM_COUNT_MODE_SET(pm_regs.pm_cntrl.count_mode);
@@ -372,7 +383,8 @@ static void write_pm_cntrl(int cpu)
 static inline void
 set_count_mode(u32 kernel, u32 user)
 {
-	/* The user must specify user and kernel if they want them. If
+	/*
+	 * The user must specify user and kernel if they want them. If
 	 *  neither is specified, OProfile will count in hypervisor mode.
 	 *  pm_regs.pm_cntrl is a global
 	 */
@@ -413,17 +425,18 @@ static inline void enable_ctr(u32 cpu, u
  * pair of per-cpu arrays is used for storing the previous and next
  * pmc values for a given node.
  * NOTE: We use the per-cpu variable to improve cache performance.
+ *
+ * This routine will alternate loading the virtual counters for
+ * virtual CPUs
  */
 static void cell_virtual_cntr(unsigned long data)
 {
-	/* This routine will alternate loading the virtual counters for
-	 * virtual CPUs
-	 */
 	int i, prev_hdw_thread, next_hdw_thread;
 	u32 cpu;
 	unsigned long flags;
 
-	/* Make sure that the interrupt_hander and the virt counter are
+	/*
+	 * Make sure that the interrupt_hander and the virt counter are
 	 * not both playing with the counters on the same node.
 	 */
 
@@ -435,22 +448,25 @@ static void cell_virtual_cntr(unsigned l
 	hdw_thread = 1 ^ hdw_thread;
 	next_hdw_thread = hdw_thread;
 
-	for (i = 0; i < num_counters; i++)
-	/* There are some per thread events.  Must do the
+	/*
+	 * There are some per thread events.  Must do the
 	 * set event, for the thread that is being started
 	 */
+	for (i = 0; i < num_counters; i++)
 		set_pm_event(i,
 			pmc_cntrl[next_hdw_thread][i].evnts,
 			pmc_cntrl[next_hdw_thread][i].masks);
 
-	/* The following is done only once per each node, but
+	/*
+	 * The following is done only once per each node, but
 	 * we need cpu #, not node #, to pass to the cbe_xxx functions.
 	 */
 	for_each_online_cpu(cpu) {
 		if (cbe_get_hw_thread_id(cpu))
 			continue;
 
-		/* stop counters, save counter values, restore counts
+		/*
+		 * stop counters, save counter values, restore counts
 		 * for previous thread
 		 */
 		cbe_disable_pm(cpu);
@@ -479,13 +495,15 @@ static void cell_virtual_cntr(unsigned l
 						      next_hdw_thread)[i]);
 		}
 
-		/* Switch to the other thread. Change the interrupt
+		/*
+		 * Switch to the other thread. Change the interrupt
 		 * and control regs to be scheduled on the CPU
 		 * corresponding to the thread to execute.
 		 */
 		for (i = 0; i < num_counters; i++) {
 			if (pmc_cntrl[next_hdw_thread][i].enabled) {
-				/* There are some per thread events.
+				/*
+				 * There are some per thread events.
 				 * Must do the set event, enable_cntr
 				 * for each cpu.
 				 */
@@ -517,9 +535,8 @@ static void start_virt_cntrs(void)
 }
 
 /* This function is called once for all cpus combined */
-static int
-cell_reg_setup(struct op_counter_config *ctr,
-	       struct op_system_config *sys, int num_ctrs)
+static int cell_reg_setup(struct op_counter_config *ctr,
+			struct op_system_config *sys, int num_ctrs)
 {
 	int i, j, cpu;
 	spu_cycle_reset = 0;
@@ -527,7 +544,8 @@ cell_reg_setup(struct op_counter_config 
 	if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
 		spu_cycle_reset = ctr[0].count;
 
-		/* Each node will need to make the rtas call to start
+		/*
+		 * Each node will need to make the rtas call to start
 		 * and stop SPU profiling.  Get the token once and store it.
 		 */
 		spu_rtas_token = rtas_token("ibm,cbe-spu-perftools");
@@ -542,7 +560,8 @@ cell_reg_setup(struct op_counter_config 
 
 	pm_rtas_token = rtas_token("ibm,cbe-perftools");
 
-	/* For all events excetp PPU CYCLEs, each node will need to make
+	/*
+	 * For all events excetp PPU CYCLEs, each node will need to make
 	 * the rtas cbe-perftools call to setup and reset the debug bus.
 	 * Make the token lookup call once and store it in the global
 	 * variable pm_rtas_token.
@@ -579,7 +598,8 @@ cell_reg_setup(struct op_counter_config 
 			per_cpu(pmc_values, j)[i] = 0;
 	}
 
-	/* Setup the thread 1 events, map the thread 0 event to the
+	/*
+	 * Setup the thread 1 events, map the thread 0 event to the
 	 * equivalent thread 1 event.
 	 */
 	for (i = 0; i < num_ctrs; ++i) {
@@ -603,7 +623,8 @@ cell_reg_setup(struct op_counter_config 
 	for (i = 0; i < NUM_INPUT_BUS_WORDS; i++)
 		input_bus[i] = 0xff;
 
-	/* Our counters count up, and "count" refers to
+	/*
+	 * Our counters count up, and "count" refers to
 	 * how much before the next interrupt, and we interrupt
 	 * on overflow.	 So we calculate the starting value
 	 * which will give us "count" until overflow.
@@ -667,19 +688,19 @@ static int cell_cpu_setup(struct op_coun
 		}
 	}
 
-	/* the pm_rtas_activate_signals will return -EIO if the FW
+	/*
+	 * The pm_rtas_activate_signals will return -EIO if the FW
 	 * call failed.
 	 */
-	return (pm_rtas_activate_signals(cbe_cpu_to_node(cpu), num_enabled));
-
+	return pm_rtas_activate_signals(cbe_cpu_to_node(cpu), num_enabled);
 }
 
 #define ENTRIES	 303
 #define MAXLFSR	 0xFFFFFF
 
 /* precomputed table of 24 bit LFSR values */
-int initial_lfsr[] =
-{8221349, 12579195, 5379618, 10097839, 7512963, 7519310, 3955098, 10753424,
+static int initial_lfsr[] = {
+ 8221349, 12579195, 5379618, 10097839, 7512963, 7519310, 3955098, 10753424,
  15507573, 7458917, 285419, 2641121, 9780088, 3915503, 6668768, 1548716,
  4885000, 8774424, 9650099, 2044357, 2304411, 9326253, 10332526, 4421547,
  3440748, 10179459, 13332843, 10375561, 1313462, 8375100, 5198480, 6071392,
@@ -716,7 +737,8 @@ int initial_lfsr[] =
  3258216, 12505185, 6007317, 9218111, 14661019, 10537428, 11731949, 9027003,
  6641507, 9490160, 200241, 9720425, 16277895, 10816638, 1554761, 10431375,
  7467528, 6790302, 3429078, 14633753, 14428997, 11463204, 3576212, 2003426,
- 6123687, 820520, 9992513, 15784513, 5778891, 6428165, 8388607};
+ 6123687, 820520, 9992513, 15784513, 5778891, 6428165, 8388607
+};
 
 /*
  * The hardware uses an LFSR counting sequence to determine when to capture
@@ -777,28 +799,25 @@ int initial_lfsr[] =
 
 static int calculate_lfsr(int n)
 {
-	/* The ranges and steps are in powers of 2 so the calculations
+	/*
+	 * The ranges and steps are in powers of 2 so the calculations
 	 * can be done using shifts rather then divide.
 	 */
 	int index;
 
-	if ((n >> 16) == 0) {
+	if ((n >> 16) == 0)
 		index = 0;
-
-	} else if (((n - V2_16) >> 19) == 0) {
+	else if (((n - V2_16) >> 19) == 0)
 		index = ((n - V2_16) >> 12) + 1;
-
-	} else if (((n - V2_16 - V2_19) >> 22) == 0) {
+	else if (((n - V2_16 - V2_19) >> 22) == 0)
 		index = ((n - V2_16 - V2_19) >> 15 ) + 1 + 128;
+	else if (((n - V2_16 - V2_19 - V2_22) >> 24) == 0)
+		index = ((n - V2_16 - V2_19 - V2_22) >> 18 ) + 1 + 256;
+	else
+		index = ENTRIES-1;
 
-	} else if (((n - V2_16 - V2_19 - V2_22) >> 24) == 0) {
-		index = ((n - V2_16 - V2_19 - V2_22) >> 18 )
-			+ 1 + 256;
-	}
-
-	if ((index > ENTRIES) || (index < 0))	/* make sure index is
-						 * valid
-						 */
+	/* make sure index is valid */
+	if ((index > ENTRIES) || (index < 0))
 		index = ENTRIES-1;
 
 	return initial_lfsr[index];
@@ -809,15 +828,17 @@ static int pm_rtas_activate_spu_profilin
 	int ret, i;
 	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
 
-	/* Set up the rtas call to configure the debug bus to
-	 * route the SPU PCs.  Setup the pm_signal for each SPU */
+	/*
+	 * Set up the rtas call to configure the debug bus to
+	 * route the SPU PCs.  Setup the pm_signal for each SPU
+	 */
 	for (i = 0; i < NUM_SPUS_PER_NODE; i++) {
 		pm_signal_local[i].cpu = node;
 		pm_signal_local[i].signal_group = 41;
-		pm_signal_local[i].bus_word = 1 << i / 2; /* spu i on
-							   * word (i/2)
-							   */
-		pm_signal_local[i].sub_unit = i;	/* spu i */
+		/* spu i on word (i/2) */
+		pm_signal_local[i].bus_word = 1 << i / 2;
+		/* spu i */
+		pm_signal_local[i].sub_unit = i;
 		pm_signal_local[i].bit = 63;
 	}
 
@@ -858,8 +879,8 @@ static int cell_global_start_spu(struct 
 	int subfunc, rtn_value;
 	unsigned int lfsr_value;
 	int cpu;
-	int ret = 0;
-	int rtas_error = 0;
+	int ret;
+	int rtas_error;
 	unsigned int cpu_khzfreq = 0;
 
 	/* The SPU profiling uses time-based profiling based on
@@ -884,24 +905,23 @@ static int cell_global_start_spu(struct 
 	for_each_online_cpu(cpu) {
 		if (cbe_get_hw_thread_id(cpu))
 			continue;
-		/* Setup SPU cycle-based profiling.
+
+		/*
+		 * Setup SPU cycle-based profiling.
 		 * Set perf_mon_control bit 0 to a zero before
 		 * enabling spu collection hardware.
 		 */
 		cbe_write_pm(cpu, pm_control, 0);
 
 		if (spu_cycle_reset > MAX_SPU_COUNT)
-			/* use largest possible value
-			 */
+			/* use largest possible value */
 			lfsr_value = calculate_lfsr(MAX_SPU_COUNT-1);
 		else
-		    lfsr_value = calculate_lfsr(spu_cycle_reset);
+			lfsr_value = calculate_lfsr(spu_cycle_reset);
 
-		if (lfsr_value == 0) {	/* must use a non zero value.  Zero
-					 * disables data collection.
-					 */
-				lfsr_value = calculate_lfsr(1);
-		}
+		/* must use a non zero value. Zero disables data collection. */
+		if (lfsr_value == 0)
+			lfsr_value = calculate_lfsr(1);
 
 		lfsr_value = lfsr_value << 8; /* shift lfsr to correct
 						* register location
@@ -916,7 +936,7 @@ static int cell_global_start_spu(struct 
 		}
 
 
-		subfunc = 2;	// 2 - activate SPU tracing, 3 - deactivate
+		subfunc = 2;	/* 2 - activate SPU tracing, 3 - deactivate */
 
 		/* start profiling */
 		rtn_value = rtas_call(spu_rtas_token, 3, 1, NULL, subfunc,
@@ -976,7 +996,8 @@ static int cell_global_start_ppu(struct 
 	oprofile_running = 1;
 	smp_wmb();
 
-	/* NOTE: start_virt_cntrs will result in cell_virtual_cntr() being
+	/*
+	 * NOTE: start_virt_cntrs will result in cell_virtual_cntr() being
 	 * executed which manipulates the PMU.	We start the "virtual counter"
 	 * here so that we do not need to synchronize access to the PMU in
 	 * the above for-loop.
@@ -986,7 +1007,6 @@ static int cell_global_start_ppu(struct 
 	return 0;
 }
 
-
 static int cell_global_start(struct op_counter_config *ctr)
 {
 	if (spu_cycle_reset) {
@@ -996,14 +1016,15 @@ static int cell_global_start(struct op_c
 	}
 }
 
-static void cell_global_stop_spu(void)
-/* Note the generic OProfile stop calls do not support returning
+/*
+ * Note the generic OProfile stop calls do not support returning
  * an error on stop.  Hence, will not return an error if the FW
  * calls fail on stop.	Failure to reset the debug bus is not an issue.
  * Failure to disable the SPU profiling is not an issue.  The FW calls
  * to enable the performance counters and debug bus will work even if
  * the hardware was not cleanly reset.
  */
+static void cell_global_stop_spu(void)
 {
 	int subfunc, rtn_value;
 	unsigned int lfsr_value;
@@ -1020,7 +1041,8 @@ static void cell_global_stop_spu(void)
 		if (cbe_get_hw_thread_id(cpu))
 			continue;
 
-		subfunc = 3;	/* 2 - activate SPU tracing,
+		subfunc = 3;	/*
+				 * 2 - activate SPU tracing,
 				 * 3 - deactivate
 				 */
 		lfsr_value = 0x8f100000;
@@ -1046,7 +1068,8 @@ static void cell_global_stop_ppu(void)
 {
 	int cpu;
 
-	/* This routine will be called once for the system.
+	/*
+	 * This routine will be called once for the system.
 	 * There is one performance monitor per node, so we
 	 * only need to perform this function once per node.
 	 */
@@ -1079,8 +1102,8 @@ static void cell_global_stop(void)
 	}
 }
 
-static void
-cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config *ctr)
+static void cell_handle_interrupt(struct pt_regs *regs,
+				struct op_counter_config *ctr)
 {
 	u32 cpu;
 	u64 pc;
@@ -1091,13 +1114,15 @@ cell_handle_interrupt(struct pt_regs *re
 
 	cpu = smp_processor_id();
 
-	/* Need to make sure the interrupt handler and the virt counter
+	/*
+	 * Need to make sure the interrupt handler and the virt counter
 	 * routine are not running at the same time. See the
 	 * cell_virtual_cntr() routine for additional comments.
 	 */
 	spin_lock_irqsave(&virt_cntr_lock, flags);
 
-	/* Need to disable and reenable the performance counters
+	/*
+	 * Need to disable and reenable the performance counters
 	 * to get the desired behavior from the hardware.  This
 	 * is hardware specific.
 	 */
@@ -1106,7 +1131,8 @@ cell_handle_interrupt(struct pt_regs *re
 
 	interrupt_mask = cbe_get_and_clear_pm_interrupts(cpu);
 
-	/* If the interrupt mask has been cleared, then the virt cntr
+	/*
+	 * If the interrupt mask has been cleared, then the virt cntr
 	 * has cleared the interrupt.  When the thread that generated
 	 * the interrupt is restored, the data count will be restored to
 	 * 0xffffff0 to cause the interrupt to be regenerated.
@@ -1124,7 +1150,8 @@ cell_handle_interrupt(struct pt_regs *re
 			}
 		}
 
-		/* The counters were frozen by the interrupt.
+		/*
+		 * The counters were frozen by the interrupt.
 		 * Reenable the interrupt and restart the counters.
 		 * If there was a race between the interrupt handler and
 		 * the virtual counter routine.	 The virutal counter
@@ -1134,7 +1161,8 @@ cell_handle_interrupt(struct pt_regs *re
 		cbe_enable_pm_interrupts(cpu, hdw_thread,
 					 virt_cntr_inter_mask);
 
-		/* The writes to the various performance counters only writes
+		/*
+		 * The writes to the various performance counters only writes
 		 * to a latch.	The new values (interrupt setting bits, reset
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
@@ -1147,7 +1175,8 @@ cell_handle_interrupt(struct pt_regs *re
 	spin_unlock_irqrestore(&virt_cntr_lock, flags);
 }
 
-/* This function is called from the generic OProfile
+/*
+ * This function is called from the generic OProfile
  * driver.  When profiling PPUs, we need to do the
  * generic sync start; otherwise, do spu_sync_start.
  */
@@ -1167,7 +1196,6 @@ static int cell_sync_stop(void)
 		return 1;
 }
 
-
 struct op_powerpc_model op_model_cell = {
 	.reg_setup = cell_reg_setup,
 	.cpu_setup = cell_cpu_setup,
