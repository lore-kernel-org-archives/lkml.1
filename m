Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYFJQ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYFJQ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYFJQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:25:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFJQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:25:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
Date: Tue, 10 Jun 2008 18:24:17 +0200
User-Agent: KMail/1.9.9
Cc: cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
References: <1213047646.6763.150.camel@carll-linux-desktop>
In-Reply-To: <1213047646.6763.150.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101824.18178.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/38C+ECrrJ5UFjhO4e3Zt9Bn/2pUSihOv6B2D
 Lld6Es2zcJF0rgyMJKzYzJjzcoq2t9aviuVAg13EkMtjjuP/Ll
 PoDs0TSClyrHtOxjdeagg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Carl Love wrote:
> 
> This is a reworked patch, version 3, to fix the SPU profile 
> sample data collection.
> 
> Currently, the SPU escape sequences and program counter data is being 
> added directly into the kernel buffer without holding the buffer_mutex 
> lock.  This patch changes how the data is stored.  A new function,
> oprofile_add_value, is added into the oprofile driver to allow adding
> generic data to the per cpu buffers.  This enables adding series of data
> to a specified cpu_buffer.  The function is used to add SPU data 
> into a cpu buffer.  The patch also adds the needed code to move the
> special sequence to the kernel buffer.  There are restrictions on
> the use of the oprofile_add_value() function to ensure data is 
> properly inserted to the specified CPU buffer.  
> 
> Finally, this patch backs out the changes previously added to the 
> oprofile generic code for handling the architecture specific 
> ops.sync_start and ops.sync_stop that allowed the architecture
> to skip the per CPU buffer creation.
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>

Thanks for your new post, addressing my previous complaints.
Unfortunately, I'm still uncomfortable with a number of details
about how the data is passed around, and there are a few style
issues that should be easier to address.
  
> -		if (num_samples == 0) {
> +		if (unlikely(!spu_prof_running)) {
> +			spin_unlock_irqrestore(&sample_array_lock,
> +					       sample_array_lock_flags);
> +			goto stop;
> +		}
> +
> +		if (unlikely(num_samples == 0)) {
>  			spin_unlock_irqrestore(&sample_array_lock,
>  					       sample_array_lock_flags);
>  			continue;

I think you should not use 'unlikely' here, because that optimizes only
very specific cases, and often at the expense of code size and readability.
If you really want to optimize the spu_prof_running, how about doing
it outside of the loop?

Similarly, it probably makes sense to hold the lock around the loop.

Note that you must never have a global variable for 'flags' used
in a spinlock, as that will get clobbered if you have lock contention,
leading to a CPU running with interrupts disabled accidentally.

It's better to never use spin_lock_irq or spin_lock, respectively,
since you usually know whether interrupts are enabled or not
anyway!

> @@ -214,8 +218,26 @@ int start_spu_profiling(unsigned int cyc
>  
>  void stop_spu_profiling(void)
>  {
> +	int cpu;
> +
>  	spu_prof_running = 0;
>  	hrtimer_cancel(&timer);
> +
> +	/* insure everyone sees spu_prof_running
> +	 * changed to 0.
> +	 */
> +	smp_wmb();

I think you'd also need have a 'smp_rb' on the reader side to
make this visible, but it's easier to just use an atomic_t
variable instead, or to hold sample_array_lock when changing
it, since you already hold that on the reader side.

> -static DEFINE_SPINLOCK(buffer_lock);
> +static DEFINE_SPINLOCK(add_value_lock);
>  static DEFINE_SPINLOCK(cache_lock);
>  static int num_spu_nodes;
>  int spu_prof_num_nodes;
> -int last_guard_val[MAX_NUMNODES * 8];
> +int last_guard_val[MAX_NUMNODES * SPUS_PER_NODE];
> +static int spu_ctx_sw_seen[MAX_NUMNODES * SPUS_PER_NODE];
> +
> +/* an array for mapping spu numbers to an index in an array */
> +static int spu_num_to_index[MAX_NUMNODES * SPUS_PER_NODE];
> +static int max_spu_num_to_index=0;
> +static DEFINE_SPINLOCK(spu_index_map_lock);

Your three locks are rather confusing. Please try to consolidate them
into fewer spinlocks and/or document for each lock exactly what
data structures it protects, and how it nests with the other locks
(e.g. "lock order: spu_index_map_lock can not be held around other locks")
and whether you need to disable interrupts and bottom half processing
while holding them.

>  
> -static struct cached_info *spu_info[MAX_NUMNODES * 8];
> +static struct cached_info *spu_info[MAX_NUMNODES * SPUS_PER_NODE];
> +
> +struct list_cpu_nums {
> +	struct list_cpu_nums *next;
> +	int cpu_num;
> +};
> +
> +struct spu_cpu_map_struct {
> +	int cpu_num;
> +	int spu_num;
> +};
> +
> +struct spu_cpu_map_struct spu_cpu_map[MAX_NUMNODES * SPUS_PER_NODE];
> +
> +struct list_cpu_nums *active_cpu_nums_list;
> +struct list_cpu_nums *next_cpu;

Here, you are putting more symbols into the global namespace, which is
not acceptable. E.g. 'next_cpu' should either be static, or be called
something like spu_task_sync_next_cpu.

Ideally, put them into a function context, or get rid of the globals
altogether.

> +static int max_entries_spu_cpu_map=0;

By convention, we do not preinitialize global variables to zero.

> +
> +/* In general, don't know what the SPU number range will be.
> + * Create an array to define what SPU number is mapped to each
> + * index in an array.  Want to be able to have multiple calls
> + * lookup an index simultaneously.  Only hold a lock when adding
> + * a new entry.
> + */
> +static int add_spu_index(int spu_num) {
> +	int i, tmp;
> +	int flags;
> +
> +	spin_lock_irqsave(&spu_index_map_lock, flags);
> +
> +	/* Need to double check that entry didn't get added
> +	 * since the call to get_spu_index() didn't find it.
> +	 */
> +	for (i=0; i<max_spu_num_to_index; i++)
> +		if (spu_num_to_index[i] == spu_num) {
> +			tmp = i;
> +			goto out;
> +		}
> +
> +	/* create map for spu num */
> +
> +	tmp = max_spu_num_to_index;
> +	spu_num_to_index[max_spu_num_to_index] = spu_num;
> +	max_spu_num_to_index++;
> +
> +out:	spin_unlock_irqrestore(&spu_index_map_lock, flags);
> +
> +	return tmp;
> +}
> +
> +static int get_spu_index(int spu_num) {
> +	int i, tmp;
> +
> +	/* check if spu map has been created */
> +	for (i=0; i<max_spu_num_to_index; i++)
> +		if (spu_num_to_index[i] == spu_num) {
> +			tmp = i;
> +			goto out;
> +		}
> +
> +	tmp = add_spu_index(spu_num);
> +
> +out:	return tmp;
> +}
> +
> +static int valid_spu_num(int spu_num) {
> +	int i;
> +
> +	/* check if spu map has been created */
> +	for (i=0; i<max_spu_num_to_index; i++)
> +		if (spu_num_to_index[i] == spu_num)
> +			return 1;
> +
> +	/* The spu number has not been seen*/
> +	return 0;
> +}
> +
> +static int initialize_active_cpu_nums(void) {
> +	int cpu;
> +	struct list_cpu_nums *tmp;
> +
> +	/* initialize the circular list */
> +
> +	active_cpu_nums_list = NULL;
> +
> +        for_each_online_cpu(cpu) {
> +		if (!(tmp = kzalloc(sizeof(struct list_cpu_nums),
> +				    GFP_KERNEL)))
> +			return -ENOMEM;
> +
> +		tmp->cpu_num = cpu;
> +
> +		if (!active_cpu_nums_list) {
> +			active_cpu_nums_list = tmp;
> +			tmp->next = tmp;
> +
> +		} else {
> +			tmp->next = active_cpu_nums_list->next;
> +			active_cpu_nums_list->next = tmp;
> +		}
> +	}
> +	next_cpu = active_cpu_nums_list;
> +	return 0;
> +}

This function does not clean up after itself when getting an ENOMEM.

> +
> +static int get_cpu_buf(int spu_num) {
> +	int i;
> +
> +
> +	for (i=0; i< max_entries_spu_cpu_map; i++)
> +	  if (spu_cpu_map[i].spu_num == spu_num)
> +			return spu_cpu_map[i].cpu_num;
> +
> +	/* no mapping found, create mapping using the next
> +	 * cpu in the circular list of cpu numbers.
> +	 */
> +	spu_cpu_map[max_entries_spu_cpu_map].spu_num = spu_num;
> +	spu_cpu_map[max_entries_spu_cpu_map].cpu_num = next_cpu->cpu_num;
> +
> +	next_cpu = next_cpu->next;
> +
> +	return spu_cpu_map[max_entries_spu_cpu_map++].cpu_num;
> +}
>  
The whole logic you are adding here (and the functions above)
looks overly complicated. I realize now that this may be my
fault because I told you not to rely on the relation between
SPU numbers and CPU numbers, but I'm still not sure if this
is even a correct approach.

Your code guarantees that all samples from a physical SPU always
end up in the same CPUs buffer. However, when an SPU context
gets moved by the scheduler from one SPU to another, how do you
maintain the consistency between the old and the new samples?

Also, this approach fundamentally does not handle CPU hotplug,
though that is probably something that was broken in this code
before.

Having to do so much work just to be able to use the per-cpu
buffers indicates that it may not be such a good idea after all.

> @@ -161,27 +293,28 @@ out:
>   */
>  static int release_cached_info(int spu_index)
>  {
> -	int index, end;
> +	int index, end, spu_num;
>  
>  	if (spu_index == RELEASE_ALL) {
> -		end = num_spu_nodes;
> +		end = max_spu_num_to_index;
>  		index = 0;
>  	} else {
> -		if (spu_index >= num_spu_nodes) {
> +		if (!valid_spu_num(spu_index)) {
>  			printk(KERN_ERR "SPU_PROF: "
>  				"%s, line %d: "
>  				"Invalid index %d into spu info cache\n",
>  				__FUNCTION__, __LINE__, spu_index);
>  			goto out;
>  		}
> -		end = spu_index + 1;
> -		index = spu_index;
> +		index = get_spu_index(spu_index);
> +		end = index + 1;
>  	}
>  	for (; index < end; index++) {
> -		if (spu_info[index]) {
> -			kref_put(&spu_info[index]->cache_ref,
> +		spu_num = spu_num_to_index[index];
> +		if (spu_info[spu_num]) {
> +			kref_put(&spu_info[spu_num]->cache_ref,
>  				 destroy_cached_info);
> -			spu_info[index] = NULL;
> +			spu_info[spu_num] = NULL;
>  		}
>  	}
>  
> @@ -289,6 +422,8 @@ static int process_context_switch(struct
>  	int retval;
>  	unsigned int offset = 0;
>  	unsigned long spu_cookie = 0, app_dcookie;
> +	unsigned long values[NUM_SPU_CNTXT_SW];
> +	int cpu_buf;
>  
>  	retval = prepare_cached_spu_info(spu, objectId);
>  	if (retval)
> @@ -303,17 +438,31 @@ static int process_context_switch(struct
>  		goto out;
>  	}
>  
> -	/* Record context info in event buffer */
> -	spin_lock_irqsave(&buffer_lock, flags);
> -	add_event_entry(ESCAPE_CODE);
> -	add_event_entry(SPU_CTX_SWITCH_CODE);
> -	add_event_entry(spu->number);
> -	add_event_entry(spu->pid);
> -	add_event_entry(spu->tgid);
> -	add_event_entry(app_dcookie);
> -	add_event_entry(spu_cookie);
> -	add_event_entry(offset);
> -	spin_unlock_irqrestore(&buffer_lock, flags);
> +	/* Record context info in event buffer.  Note, there are more
> +	 * SPUs then CPUs.  Map the SPU events/data for a given SPU to
> +	 * the same CPU buffer.  Need to ensure the cntxt switch data and
> +	 * samples stay in order.
> +	 */
> +
> +	spin_lock_irqsave(&add_value_lock, flags);
> +	cpu_buf = get_cpu_buf(spu->number);
> +
> +	values[0] = ESCAPE_CODE;
> +	values[1] = SPU_CTX_SWITCH_CODE;
> +	values[2] = spu->number;
> +	values[3] = spu->pid;
> +	values[4] = spu->tgid;
> +	values[5] = app_dcookie;
> +	values[6] = spu_cookie;
> +	values[7] = offset;
> +	oprofile_add_value(values, cpu_buf, NUM_SPU_CNTXT_SW);
> +
> +	/* Set flag to indicate SPU PC data can now be written out.  If
> +	 * the SPU program counter data is seen before an SPU context
> +	 * record is seen, the postprocessing will fail.
> +	 */
> +	spu_ctx_sw_seen[get_spu_index(spu->number)] = 1;
> +	spin_unlock_irqrestore(&add_value_lock, flags);
>  	smp_wmb();	/* insure spu event buffer updates are written */
>  			/* don't want entries intermingled... */

The spin_unlock obviously contain an implicit barrier, otherwise
it would not be much good as a lock, so you can remove the smp_wmb()
here.

>  out:
> @@ -363,38 +512,51 @@ static int number_of_online_nodes(void)
>  /* The main purpose of this function is to synchronize
>   * OProfile with SPUFS by registering to be notified of
>   * SPU task switches.
> - *
> - * NOTE: When profiling SPUs, we must ensure that only
> - * spu_sync_start is invoked and not the generic sync_start
> - * in drivers/oprofile/oprof.c.	 A return value of
> - * SKIP_GENERIC_SYNC or SYNC_START_ERROR will
> - * accomplish this.
>   */
>  int spu_sync_start(void)
>  {
>  	int k;
> -	int ret = SKIP_GENERIC_SYNC;
> +	int ret = 0;
>  	int register_ret;
> -	unsigned long flags = 0;
> +	int cpu;
> +	int flags;
> +	int unsigned long values[NUM_SPU_SYNC_START];
>  
>  	spu_prof_num_nodes = number_of_online_nodes();
> -	num_spu_nodes = spu_prof_num_nodes * 8;
> +	num_spu_nodes = spu_prof_num_nodes * SPUS_PER_NODE;
>  
> -	spin_lock_irqsave(&buffer_lock, flags);
> -	add_event_entry(ESCAPE_CODE);
> -	add_event_entry(SPU_PROFILING_CODE);
> -	add_event_entry(num_spu_nodes);
> -	spin_unlock_irqrestore(&buffer_lock, flags);
> +	ret = initialize_active_cpu_nums();
> +	if (ret)
> +		goto out;
> +
> +	/* The SPU_PROFILING_CODE escape sequence must proceed
> +	 * the SPU context switch info.
> +	 *
> +	 * SPU profiling and PPU profiling are not supported
> +	 * at the same time.  SPU Profilining does not support
> +	 * call graphs, hence just need lock to prevent mulitple
> +	 * calls to oprofile_add_value().
> +	 */
> +	values[0] = ESCAPE_CODE;
> +	values[1] = SPU_PROFILING_CODE;
> +	values[2] =(unsigned long int) num_spu_nodes;
> +
> +	spin_lock_irqsave(&add_value_lock, flags);
> +	for_each_online_cpu(cpu)
> +		oprofile_add_value(values, cpu, NUM_SPU_SYNC_START);
> +	spin_unlock_irqrestore(&add_value_lock, flags);
>  
>  	/* Register for SPU events  */
>  	register_ret = spu_switch_event_register(&spu_active);
>  	if (register_ret) {
> -		ret = SYNC_START_ERROR;
> +		ret = -1;
>  		goto out;
>  	}
>  
> -	for (k = 0; k < (MAX_NUMNODES * 8); k++)
> +	for (k = 0; k < (MAX_NUMNODES * SPUS_PER_NODE); k++) {
>  		last_guard_val[k] = 0;
> +		spu_ctx_sw_seen[k] = 0;
> +	}

Why do you need the spu_ctx_sw_seen here? Shouldn't
spu_switch_event_register() cause a switch event in every context
anyway? You call that just a few lines earlier.


> -int spu_sync_stop(void)
> +void spu_sync_stop(void)
>  {
>  	unsigned long flags = 0;
> -	int ret = spu_switch_event_unregister(&spu_active);
> -	if (ret) {
> -		printk(KERN_ERR "SPU_PROF: "
> -			"%s, line %d: spu_switch_event_unregister returned %d\n",
> -			__FUNCTION__, __LINE__, ret);
> -		goto out;
> -	}
> +
> +	/* Ignoring the return value from the unregister
> +	 * call.  A failed return value simply says there
> +	 * was no registered event.  Hence there will not
> +	 * be any calls to process a switch event that
> +	 * could cause a problem.
> +	 */
> +	spu_switch_event_unregister(&spu_active);

Please change the prototype of the unregister function instead
then, you are the only caller anyway.

> @@ -40,6 +40,7 @@ static cpumask_t marked_cpus = CPU_MASK_
>  static DEFINE_SPINLOCK(task_mortuary);
>  static void process_task_mortuary(void);
>  
> +extern int work_enabled;  // carll added for debug

This obviously needs to be removed again.

>  
>  /* Take ownership of the task struct and place it on the
>   * list for processing. Only after two full buffer syncs
> @@ -521,6 +522,46 @@ void sync_buffer(int cpu)
>  			} else if (s->event == CPU_TRACE_BEGIN) {
>  				state = sb_bt_start;
>  				add_trace_begin();
> +			} else if (s->event == VALUE_HEADER_ID) {
> +				/* The next event entry contains the number
> +				 * values in the sequence to add.
> +				 */
> +				int index, j, num;
> +
> +				if ((available - i) < 2)
> +					/* The next entry which contains the
> +					 * number of entries in the sequence
> +					 * has not been written to the
> +					 * buffer yet.
> +					 */
> +					break;
> +
> +				/* Get the number in the sequence without
> +				 * changing the state of the buffer.
> +				 */
> +				index = cpu_buf->tail_pos + 1;
> +				if (!(index < cpu_buf->buffer_size))
> +					index = 0;
> +
> +				num = cpu_buf->buffer[index].eip;
> +
> +				if ((available - i) < (num+1))
> +					/* The entire sequence has not been
> +					 * written to the buffer yet.
> +					 */
> +					break;
> +
> +				if (work_enabled == 0) {
> +					printk("work_enabled is zero\n");
> +				}
> +				for (j = 0; j < num; j++) {
> +					increment_tail(cpu_buf);
> +					i++;
> +
> +					s = &cpu_buf->buffer[cpu_buf->tail_pos];
> +					add_event_entry(s->event);
> +				}
> +
>  			} else {
>  				struct mm_struct * oldmm = mm;

This is a substantial amount of code that you are adding to the existing
function, please move this out into a separate function, for better
readability.

> @@ -32,7 +32,9 @@ struct oprofile_cpu_buffer cpu_buffer[NR
>  static void wq_sync_buffer(struct work_struct *work);
>  
>  #define DEFAULT_TIMER_EXPIRE (HZ / 10)
> -static int work_enabled;
> +//carll changed static int work_enabled;
> +extern int work_enabled;
> +int work_enabled;

please revert.

> Index: Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.h
> ===================================================================
> --- Cell_kernel_5_15_2008-new.orig/drivers/oprofile/cpu_buffer.h
> +++ Cell_kernel_5_15_2008-new/drivers/oprofile/cpu_buffer.h
> @@ -54,5 +54,6 @@ void cpu_buffer_reset(struct oprofile_cp
>  /* transient events for the CPU buffer -> event buffer */
>  #define CPU_IS_KERNEL 1
>  #define CPU_TRACE_BEGIN 2
> +#define VALUE_HEADER_ID 3

'VALUE_HEADER_ID' does not describe well enough to me what this
is doing. Maybe some other identifier if you can think of one?
  
> @@ -106,6 +97,22 @@ void oprofile_add_sample(struct pt_regs 
>  void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
>  				unsigned long event, int is_kernel);
>  
> +/*
> + * Add a sequence of values to the per CPU buffer.  An array of values is
> + * added to the specified cpu buffer with no additional processing.  The assumption
> + * is any processing of the value will be done in the postprocessor.  This
> + * function should only be used for special architecture specific data.
> + * Currently only used by the CELL processor.
> + *
> + * REQUIREMENT: the user of the function must ensure that only one call at
> + * a time is made to this function.  Additionally, it must ensure that
> + * no calls are made to the following routines: oprofile_begin_trace(),
> + * oprofile_add_ext_sample(), oprofile_add_pc(), oprofile_add_trace().
> + *
> + * This function does not perform a backtrace.
> + */
> +void oprofile_add_value(unsigned long *values, int cpu, int num);
> +
>  /* Use this instead when the PC value is not from the regs. Doesn't
>   * backtrace. */
>  void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event);
> 

These are pretty strict requirements. How do you ensure that these are
all true? What if the user is running timer based profiling on the CPU
at the same time as event profiling on the SPU?

Maybe someone else with an oprofile background can comment on whether the
interface is acceptable as is.

	Arnd <><
