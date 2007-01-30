Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbXA3VlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbXA3VlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXA3VlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:41:20 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54895 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXA3VlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:41:16 -0500
Message-ID: <45BFBB78.7060907@us.ibm.com>
Date: Tue, 30 Jan 2007 15:41:12 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       Anton Blanchard <anton@samba.org>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de>
In-Reply-To: <200701300839.05144.arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> On Monday 29 January 2007 20:48, Maynard Johnson wrote:
> 
>>Subject: Add support to OProfile for profiling Cell BE SPUs
>>
>>From: Maynard Johnson <maynardj@us.ibm.com>
>>
>>This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
>>to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
>>was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
>>code.
>>
>>Signed-off-by: Carl Love <carll@us.ibm.com>
>>Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
> 
> 
> I can't really say much about the common oprofile files that you are
> touching, maybe someone from oprofile-list (Philippe?) to look over them
> and ack/nack them.
Anton (added to cc list) may be another good reviewer of 
drivers/oprofile changes.
> 
> 
>>+#define number_of_online_nodes(nodes) {        \
>>+        u32 cpu; u32 tmp;                      \
>>+        nodes = 0;                             \
>>+        for_each_online_cpu(cpu) {             \
>>+                tmp = cbe_cpu_to_node(cpu) + 1;\
>>+                if (tmp > nodes)               \
>>+                        nodes++;               \
>>+       }                                      \
>>+}
> 
> 
> I've been discussing with benh about a better way to do this. We should
> change all the references to nodes and cpu numbers to something more
> correct in the future, so we get rid of the assumption that each
> numa node is a cell chip. It's probably best to leave your code as
> is for now, but we need to remember this one when cleaning it up.
> 
> You should however convert this into an inline function
> of prototype 
> 
> static inline int number_of_online_nodes(void)
> 
> instead of a macro.
OK.
> 
> 
>>+/* Defines used for sync_start */
>>+#define SKIP_GENERIC_SYNC 0
>>+#define SYNC_START_ERROR -1
>>+#define DO_GENERIC_SYNC 1
>>+
>>+typedef struct vma_map
>>+{
>>+       struct vma_map *next;
>>+       unsigned int vma;
>>+       unsigned int size;
>>+       unsigned int offset;
>>+       unsigned int guard_ptr;
>>+       unsigned int guard_val;
>>+} vma_map_t;
> 
> 
> please don't typedef structures.
Sure.
> 
> 
[snip]
>>+
>>+static int spu_prof_running = 0;
>>+static unsigned int profiling_interval = 0;
>>+
>>+extern int num_nodes;
>>+extern unsigned int khzfreq;
> 
> 
> You really can't have global variable with such generic names. For
> static variables, it's less of a problem, since they are not in the
> same name space, but for easier debugging, it's good to always have
> the name of your module (e.g. spu_prof_) as a prefix to the identifier.
OK, we'll add 'spu_prof' prefix to them.
> 
> Of course, the best way would be to avoid global and static variables
> entirely, but that's not always possible.
> 
> 
[snip]
>>+       // process the collected SPU PC for each node
>>+       for_each_online_cpu(cpu) {
>>+               if (cbe_get_hw_thread_id(cpu))
>>+                       continue;
>>+
>>+               node = cbe_cpu_to_node(cpu);
>>+               node_factor = node * SPUS_PER_NODE;
>>+                /* number of valid entries for this node */
>>+               entry = 0;
>>+
>>+               trace_addr = cbe_read_pm(cpu, trace_address);
>>+               while ((trace_addr & CBE_PM_TRACE_BUF_EMPTY) != 0x400)
>>+               {
>>+                       /* there is data in the trace buffer to process */
>>+                       cbe_read_trace_buffer(cpu, trace_buffer);  
>>+                       spu_mask = 0xFFFF000000000000;
>>+
>>+                       /* Each SPU PC is 16 bits; hence, four spus in each of 
>>+                        * the two 64-bit buffer entries that make up the
>>+                        * 128-bit trace_buffer entry.  Process the upper and
>>+                        * lower 64-bit values simultaneously.
>>+                        */
>>+                       for (spu = 0; spu < SPUS_PER_TB_ENTRY; spu++) {
>>+                               spu_pc_lower = spu_mask & trace_buffer[0];
>>+                               spu_pc_lower = spu_pc_lower >> (NUM_SPU_BITS_TRBUF
>>+                                                               * (SPUS_PER_TB_ENTRY-spu-1));
>>+
>>+                               spu_pc_upper = spu_mask & trace_buffer[1];
>>+                               spu_pc_upper = spu_pc_upper >> (NUM_SPU_BITS_TRBUF
>>+                                                               * (SPUS_PER_TB_ENTRY-spu-1));
>>+
>>+                               spu_mask = spu_mask >> NUM_SPU_BITS_TRBUF;
>>+
>>+                               /* spu PC trace entry is upper 16 bits of the
>>+                                * 18 bit SPU program counter 
>>+                                */
>>+                               spu_pc_lower = spu_pc_lower << 2;
>>+                               spu_pc_upper = spu_pc_upper << 2;
>>+
>>+                               samples[((node_factor + spu) * TRACE_ARRAY_SIZE) + entry]
>>+                                       = (u32) spu_pc_lower;
>>+                               samples[((node_factor + spu + SPUS_PER_TB_ENTRY) * TRACE_ARRAY_SIZE) + entry]
>>+                                       = (u32) spu_pc_upper;
>>+                       }
>>+
>>+                       entry++;
>>+
>>+                       if (entry >= TRACE_ARRAY_SIZE) 
>>+                               /* spu_samples is full */
>>+                               break;
>>+
>>+                       trace_addr = cbe_read_pm(cpu, trace_address);
>>+               }
>>+               samples_per_node[node] = entry;
>>+       }
>>+}
> 
> 
> While I can't see anything technically wrong with this function, it would be
> good to split it into smaller functions. Since you are nesting three
> loops, it should be possible to make a separate function from one of the
> inner loops without changing the actual logic behind it.
Will do.
> 
> 
>>+
>>+static int profile_spus(struct hrtimer * timer)
>>+{
>>+       ktime_t kt;
>>+        int cpu, node, k, num_samples, spu_num;
> 
> 
> whitespace damage
fixed
> 
> 
>>+       
>>+       if (!spu_prof_running)
>>+               goto STOP;
>>+
>>+       cell_spu_pc_collection();
>>+       for_each_online_cpu(cpu) {
>>+               if (cbe_get_hw_thread_id(cpu))
>>+                       continue;
> 
> 
> Here, you enter the same top-level loop again, why not make it
> 	for_each_online_cpu(cpu) {
> 		if (cbe_get_hw_thread_id(cpu))
>                          continue;
> 		num_samples = cell_spu_pc_collection(cpu);
> 		...
Yes, good suggestion.
> 
> 
>>+       kt = ktime_set(0, profiling_interval);
>>+       if (!spu_prof_running)
>>+               goto STOP;
>>+       hrtimer_forward(timer, timer->base->get_time(), kt);
>>+       return HRTIMER_RESTART;
> 
> 
> is hrtimer_forward really the right interface here? You are ignoring
> the number of overruns anyway, so hrtimer_start(,,) sounds more
> correct to me.
According to Tom Gleixner, "hrtimer_forward is a convenience function to 
move the expiry time of a timer forward in multiples of the interval, so 
it is in the future.  After setting the expiry time you restart the 
timer either with [sic] a return HRTIMER_RESTART (if you are in the 
timer callback function)."
> 
> 
>>+
>>+ STOP:
> 
> 
> labels should be in small letters.
OK
> 
> 
>>+       printk(KERN_INFO "SPU_PROF: spu-prof timer ending\n");
>>+       return HRTIMER_NORESTART;
>>+}
> 
> 
>>+void start_spu_profiling(unsigned int cycles_reset) {
>>+
>>+       ktime_t kt;
>>+
>>+        /* To calculate a timeout in nanoseconds, the basic
>>+        * formula is ns = cycles_reset * (NSEC_PER_SEC / cpu frequency).
>>+        * To avoid floating point math, we use the scale math
>>+        * technique as described in linux/jiffies.h.  We use
>>+        * a scale factor of SCALE_SHIFT,which provides 4 decimal places
>>+        * of precision, which is close enough for the purpose at hand.
>>+        */
>>+
>>+       /* Since cpufreq_quick_get returns frequency in kHz, we use
>>+        * USEC_PER_SEC here vs NSEC_PER_SEC.
>>+        */
>>+       unsigned long nsPerCyc = (USEC_PER_SEC << SCALE_SHIFT)/khzfreq;
>>+       profiling_interval = (nsPerCyc * cycles_reset) >> SCALE_SHIFT;
>>+       
>>+       pr_debug("timer resolution: %lu\n", 
>>+                TICK_NSEC);
> 
> 
> Don't you need to adapt the profiling_interval at run time, when cpufreq
> changes the core frequency? You should probably use
> cpufreq_register_notifier() to update this.
Since OProfile is a statistical profiler, the exact frequency is not 
critical.  The user is going to be looking for hot spots in their code, 
so it's all relative.  With that said,  I don't imagine using the 
cpufreq notiication would be a big deal.  We'll look at it.
> 
> 
>>+       kt = ktime_set(0, profiling_interval);
>>+       hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_REL);
>>+       timer.expires = kt;
>>+       timer.function = profile_spus;
>>+
>>+        /* Allocate arrays for collecting SPU PC samples */
>>+       samples = (u32 *) kzalloc(num_nodes * SPUS_PER_NODE * TRACE_ARRAY_SIZE * sizeof(u32), GFP_ATOMIC);
> 
> 
> Try to avoid atomic allocations. I don't think you are in an atomic
> context here at all, so you can just use GFP_KERNEL.
OK, I'll check it out.
> 
> 
>>+       samples_per_node = (u32 *) kzalloc(num_nodes * sizeof(u32), GFP_ATOMIC);
> 
> 
> Since MAX_NUMNODES is small, it's probably more efficient to just allocate this
> statically.
OK.
> 
> 
>>+
>>+       spu_prof_running = 1;
>>+       hrtimer_start(&timer, kt, HRTIMER_REL);
>>+}
>>
>>+
>>+void stop_spu_profiling(void) 
>>+{
>>+
>>+       hrtimer_cancel(&timer);
>>+       kfree(samples);
>>+       kfree(samples_per_node);
>>+       pr_debug("SPU_PROF: stop_spu_profiling issued\n");
>>+       spu_prof_running = 0;
>>+}
> 
> 
> shouldn't you set spu_prof_running = 0 before doing any of the other things?
> It looks to me like you could otherwise get into a use-after-free
> situation. If I'm wrong with that, you probably don't need spu_prof_running
> at all ;-)
No, you're right.  :-)
> 
> 
>>+/* Conainer for caching information about an active SPU task.
>>+ *   :map -- pointer to a list of vma_maps
>>+ *   :spu -- the spu for this active SPU task
>>+ *   :list -- potentially could be used to contain the cached_infos
>>+ *            for inactive SPU tasks.
> 
> 
> Documenting structures is good, but please use the common kerneldoc format
> for it. There are a number of examples for this in include/linux/
OK
> 
> 
>>+ * 
>>+ * Ideally, we would like to be able to create the cached_info for
>>+ * an SPU task just one time -- when libspe first loads the SPU 
>>+ * binary file.  We would store the cached_info in a list.  Then, as
>>+ * SPU tasks are switched out and new ones switched in, the cached_info
>>+ * for inactive tasks would be kept, and the active one would be placed
>>+ * at the head of the list.  But this technique may not with
>>+ * current spufs functionality since the spu used in bind_context may
>>+ * be a different spu than was used in a previous bind_context for a
>>+ * reactivated SPU task.  Additionally, a reactivated SPU task may be
>>+ * assigned to run on a different physical SPE.  We will investigate
>>+ * further if this can be done.
>>+ *
>>+ */
> 
> 
> You should stuff a pointer to cached_info into struct spu_context,
> e.g. 'void *profile_private'.
> 
> 
>>+struct cached_info {
>>+       vma_map_t * map;
>>+       struct spu * the_spu;
>>+       struct kref cache_ref;
>>+       struct list_head list;
>>+};
> 
> 
> And replace the 'the_spu' member with a back pointer to the
> spu_context if you need it.
> 
> 
>>+
>>+/* A data structure for cached information about active SPU tasks.
>>+ * Storage is dynamically allocated, sized as
>>+ * "number of active nodes multplied by 8". 
>>+ * The info_list[n] member holds 0 or more 
>>+ * 'struct cached_info' objects for SPU#=n. 
>>+ *
>>+ * As currently implemented, there will only ever be one cached_info 
>>+ * in the list for a given SPU.  If we can devise a way to maintain
>>+ * multiple cached_infos in our list, then it would make sense
>>+ * to also cache the dcookie representing the PPU task application.
>>+ * See above description of struct cached_info for more details.
>>+ */
>>+struct spu_info_stacks {
>>+       struct list_head * info_list;
>>+};
> 
> 
> Why do you store pointers to list_head structures? If you want to store
> lists, you should have a lists_head itself in here.
info_list is an array of n lists, where n is the number of SPUs.
> 
> Why do you store them per spu in the first place? The physical spu
> doesn't have any relevance to this at all, the only data that is
> per spu is the sample data collected on a profiling interrupt,
> which you can then copy in the per-context data on a context switch.
The sample data is written out to the event buffer on every profiling 
interrupt.  But we don't write out the SPU program counter samples 
directly to the event buffer.  First, we have to find the cached_info 
for the appropriate SPU context to retrieve the cached vma-to-fileoffset 
map.  Then we do the vma_map_lookup to find the fileoffset corresponding 
to the SPU PC sample, which we then write out to the event buffer.  This 
is one of the most time-critical pieces of the SPU profiling code, so I 
used an array to hold the cached_info for fast random access.  But as I 
stated in a code comment above, the negative implication of this current 
implementation is that the array can only hold the cached_info for 
currently running SPU tasks.  I need to give this some more thought.
> 
> 
> 
>>+/* Looks for cached info for the passed spu.  If not found, the
>>+ * cached info is created for the passed spu.
>>+ * Returns 0 for success; otherwise, -1 for error.  
>>+ */ 
>>+static int
>>+prepare_cached_spu_info(struct spu * spu, unsigned int objectId)
>>+{
> 
> 
> see above, this should get the spu_context pointer as its argument,
> not the spu.
> 
> 
>>+       vma_map_t * new_map;
>>+       unsigned long flags = 0;
>>+       int retval = 0;
>>+       /* spu->number is a system-wide value, not a per-node value. */
>>+       struct cached_info * info = get_cached_info(spu->number);
>>+       if (info == NULL) {
> 
> 
> if you revert the logic to
> 
> 	if (info)
> 		goto out;
> 
> then the bulk of your function doesn't need to get indented,
> which helps readability.
OK
> 
> 
>>+               /* create cached_info and add it to the list for SPU #<n>.*/
>>+               info = kzalloc(sizeof(struct cached_info), GFP_ATOMIC);
> 
> 
> GFP_KERNEL
OK
> 
> 
>>+               if (!info) {
>>+                       printk(KERN_ERR "SPU_PROF: "
>>+                              "%s, line %d: create vma_map failed\n",
>>+                              __FUNCTION__, __LINE__);
>>+                       goto ERR_ALLOC;
>>+               }
>>+               new_map = create_vma_map(spu, objectId);
>>+               if (!new_map) {
>>+                       printk(KERN_ERR "SPU_PROF: "
>>+                              "%s, line %d: create vma_map failed\n",
>>+                              __FUNCTION__, __LINE__);
>>+                       goto ERR_ALLOC;
>>+               }
>>+
>>+               pr_debug("Created vma_map\n");
>>+               info->map = new_map;
>>+               info->the_spu = spu;
>>+               kref_init(&info->cache_ref);
>>+               spin_lock_irqsave(&cache_lock, flags);
>>+               list_add(&info->list, &spu_info->info_list[spu->number]);
>>+               spin_unlock_irqrestore(&cache_lock, flags);
>>+               goto OUT;
>>+       } else {
>>+        /* Immedidately put back reference to cached_info since we don't
>>+        * really need it -- just checking whether we have it.
>>+        */
>>+               put_cached_info(info);
>>+               pr_debug("Found cached SPU info.\n");
>>+       }
>>+       
>>+ERR_ALLOC:
>>+       retval = -1;
>>+OUT:
>>+       return retval;
>>+}
> 
> 
>>+/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
>>+ * which corresponds loosely to "application name". Also, determine
>>+ * the offset for the SPU ELF object.  If computed offset is 
>>+ * non-zero, it implies an embedded SPU object; otherwise, it's a
>>+ * separate SPU binary, in which case we retrieve it's dcookie.
>>+ */
>>+static unsigned long 
>>+get_exec_dcookie_and_offset(
>>+       struct spu * spu, unsigned int * offsetp,
>>+       unsigned long * spu_bin_dcookie,
>>+       unsigned int spu_ref)
>>+{
>>+        unsigned long cookie = 0;
>>+       unsigned int my_offset = 0;
>>+        struct vm_area_struct * vma;
>>+       struct mm_struct * mm = spu->mm;
> 
> 
> indenting
uh-huh
> 
> 
>>+        if (!mm)
>>+                goto OUT;
>>+
>>+        for (vma = mm->mmap; vma; vma = vma->vm_next) {
>>+                if (!vma->vm_file)
>>+                        continue;
>>+                if (!(vma->vm_flags & VM_EXECUTABLE))
>>+                        continue;
>>+                cookie = fast_get_dcookie(vma->vm_file->f_dentry,
>>+                        vma->vm_file->f_vfsmnt);
>>+               pr_debug("got dcookie for %s\n",
>>+                         vma->vm_file->f_dentry->d_name.name);
>>+                break;
>>+        }
>>+
>>+       for (vma = mm->mmap; vma; vma = vma->vm_next) {
>>+               if (vma->vm_start > spu_ref || vma->vm_end < spu_ref)
>>+                       continue;
>>+               my_offset = spu_ref - vma->vm_start;
>>+               pr_debug("Found spu ELF at "
>>+                         " %X for file %s\n", my_offset,
>>+                         vma->vm_file->f_dentry->d_name.name);
>>+               *offsetp = my_offset;
>>+               if (my_offset == 0) {
>>+                       if (!vma->vm_file) {
>>+                               goto FAIL_NO_SPU_COOKIE;
>>+                       }
>>+                       *spu_bin_dcookie = fast_get_dcookie(
>>+                               vma->vm_file->f_dentry,
>>+                               vma->vm_file->f_vfsmnt);
>>+                       pr_debug("got dcookie for %s\n",
>>+                                 vma->vm_file->f_dentry->d_name.name);
>>+               }
>>+               break;
>>+       }
>>+       
>>+OUT:
>>+        return cookie;
>>+
>>+FAIL_NO_SPU_COOKIE:
>>+       printk(KERN_ERR "SPU_PROF: "
>>+              "%s, line %d: Cannot find dcookie for SPU binary\n",
>>+              __FUNCTION__, __LINE__);
>>+       goto OUT;
>>+}
>>+
>>+
>>+
>>+/* This function finds or creates cached context information for the
>>+ * passed SPU and records SPU context information into the OProfile
>>+ * event buffer.
>>+ */
>>+static int process_context_switch(struct spu * spu, unsigned int objectId)
>>+{
>>+       unsigned long flags = 0;
>>+       int retval = 0;
>>+       unsigned int offset = 0;
>>+       unsigned long spu_cookie = 0, app_dcookie = 0;
>>+       retval = prepare_cached_spu_info(spu, objectId);
>>+       if (retval == -1) {
>>+               goto OUT;
>>+       }
>>+        /* Get dcookie first because a mutex_lock is taken in that
>>+        * code path, so interrupts must not be disabled.
>>+        */
>>+       app_dcookie = get_exec_dcookie_and_offset(spu, &offset, 
>>+                                                 &spu_cookie, objectId);
>>+
>>+        /* Record context info in event buffer */
>>+       spin_lock_irqsave(&buffer_lock, flags);
>>+       add_event_entry(ESCAPE_CODE);
>>+       add_event_entry(SPU_CTX_SWITCH_CODE);
>>+       add_event_entry(spu->number);
>>+       add_event_entry(spu->pid);
>>+       add_event_entry(spu->tgid);
>>+       add_event_entry(app_dcookie);
>>+
>>+       add_event_entry(ESCAPE_CODE);
>>+       if (offset) {
>>+         /* When offset is non-zero,  this means the SPU ELF was embedded;
>>+          * otherwise, it was loaded from a separate binary file.  For the
>>+          * embedded case, we record the offset of the SPU ELF into the PPU
>>+          * executable; for the non-embedded case, we record a dcookie that
>>+          * points to the location of the SPU binary that was loaded.
>>+          */
>>+               add_event_entry(SPU_OFFSET_CODE);
>>+               add_event_entry(offset);
>>+       } else {
>>+               add_event_entry(SPU_COOKIE_CODE);
>>+               add_event_entry(spu_cookie);
>>+       }
> 
> 
> I don't get it. What is the app_dcookie used for? If the spu binary is
> embedded into a library, you are still missing the dcookie to that .so file,
> because you return only an offset.
For embedded SPU app, the post-processing tool opens the PPE binary app 
file and obtains the SPU ELF embedded thereine, and from that, we obtain 
the name of the SPU binary.  Also, the app name is included in the 
report, along with the SPU binary filename, if the report contains 
samples from more than one application.
> 
> <nitpicking>
> 
>>+       unsigned long flags = 0;
> 
> 
> no need to initialize
> 
> 
>>+       struct spu * the_spu = (struct spu *) data;
> 
> 
> no need for the cast
> 
> 
>>+       pr_debug("SPU event notification arrived\n");
>>+       if (val == 0){
> 
> 
> if (!val)
> 
> 
>>+       pr_debug("spu_sync_start -- running.\n");
>>+OUT:
> 
> 
> out:
> 
> 
>>+       return ret;     
>>+}
> 
> 
> </nitpicking>
OK, we'll fix up.
> 
> 
> 
>>@@ -480,7 +491,22 @@
>>               struct op_system_config *sys, int num_ctrs)
>> {
>>        int i, j, cpu;
>>+       spu_cycle_reset = 0;
>> 
>>+       /* The cpufreq_quick_get function requires that cbe_cpufreq module
>>+        * be loaded.  This function is not actually provided and exported
>>+        * by cbe_cpufreq, but it relies on cbe_cpufreq initialize kernel
>>+        * data structures.  Since there's no way for depmod to realize
>>+        * that our OProfile module depends on cbe_cpufreq, we currently
>>+        * are letting the userspace tool, opcontrol, ensure that the
>>+        * cbe_cpufreq module is loaded.
>>+        */
>>+       khzfreq = cpufreq_quick_get(smp_processor_id());
> 
> 
> You should probably have a fallback in here in case the cpufreq module
> is not loaded. There is a global variable ppc_proc_freq (in Hz) that
> you can access.
Our userspace tool ensures the cpufreq module is loaded.
> 
>>        ;
>> }
>> 
>>-static void cell_global_start(struct op_counter_config *ctr)
>>+static int calculate_lfsr(int n)
>>+{
>>+#define size 24
>>+       int i;
>>+       unsigned int newlfsr0;
>>+       unsigned int lfsr = 0xFFFFFF;
>>+       unsigned int howmany = lfsr - n;
>>+
>>+       for (i = 2; i < howmany + 2; i++) {
>>+               newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
>>+                           ((lfsr >> (size - 1 - 1)) & 1) ^
>>+                           (((lfsr >> (size - 1 - 6)) & 1) ^
>>+                            ((lfsr >> (size - 1 - 23)) & 1)));
>>+
>>+               lfsr >>= 1;
>>+               lfsr = lfsr | (newlfsr0 << (size - 1));
>>+       }
>>+       return lfsr;
>>+
>>+}
> 
> 
> I don't have the slightest idea what this code is about, but
Me neither.  Carl, can you comment?
> it certainly looks inefficient to loop 16 million times to
> compute a constant. Could you use a faster algorithm instead,
> or at least add a comment about why you do it this way?
> 
> 
>>+static void cell_global_stop(void)
>>+{
>>+       if (spu_cycle_reset) {
>>+               cell_global_stop_spu();
>>+       } else {
>>+               cell_global_stop_ppu();
>>+       }
>>+
>>+}
> 
> 
> This looks weird as well. I suppose it's a limitation of the hardware
> that you can only do either ppu or spu profiling. However, making that
> dependent of whether the 'spu_cycle_reset' variable is set sounds
> rather bogus.
It is the only file-scoped variable relating to SPU profiling, and will 
always be non-zero when the user selects to perform SPU profiling. 
Seemed like a logical-enough choice to me.
> 
> I don't know what the best interface for choosing the target from
> user space would be, but you probably also want to be able to
> switch between them at run time.
The hardware setup is so completely different, I don't think there's a 
viable way of switching between PPU profiling and SPU profiling without 
a "stop" in between.
> 
> 	Arnd <><


