Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYDBREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYDBREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbYDBREh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:04:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49865 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbYDBREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:04:36 -0400
Subject: Re: [Cbe-oss-dev]  [PATCH] Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cel <cel@linux.vnet.ibm.com>
In-Reply-To: <1207154567.7132.396.camel@carll-linux-desktop>
References: <1206460727.7132.232.camel@carll-linux-desktop>
	 <200804020721.15861.arnd@arndb.de>
	 <1207154567.7132.396.camel@carll-linux-desktop>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 10:02:55 -0700
Message-Id: <1207155775.7132.414.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 09:42 -0700, Carl Love wrote:
> On Wed, 2008-04-02 at 07:21 +0200, Arnd Bergmann wrote:
> > On Tuesday 25 March 2008, Carl Love wrote:
> > > This patch fixes a bug in the code that records the SPU data and
> > > context switches.  The buffer_mutex lock must be held when the
> > > kernel is adding data to the buffer between the kernel and the
> > > OProfile daemon.  The lock is not being held in the current code
> > > base.  This patch fixes the bug using work queues.  The data to 
> > > be passed to the daemon is caputured by the interrupt handler.  
> > > The workqueue function is invoked to grab the buffer_mutex lock
> > > and add the data to the buffer.  
> > 
> > So what was the exact bug you're fixing with this? There was no
> > buffer_mutex before, so why do you need it now? Can't this be a
> > spinlock so you can get it from interrupt context instead of
> > using a workqueue?
> 
> The generic OProfile code defines a mutex lock, called buffer_mutex, to
> protect the kernel/daemon data buffer from being writen by the kernal
> and simultaneously read by the Daemon.  When adding a PPU sample the
> oprofile routine  oprofile_add_ext_sample(pc, regs, i, is_kernel) is
> called from the interrupt context to request the sample be stored.  The
> generic oprofile code takes care of passing the data to a non interrupt
> context where the mutex lock is held and the necessary sequence of data
> is written into the kernel/daemon data buffer.  However, OProfile does
> not have any built in functions for handling the SPU.  Hence, we have to
> implement the code to capture the data in the interrupt context, pass it
> to a non interrupt context and put it into the buffer.  This was not
> done correctly in the original implementation.  Specifically, the mutex
> lock was not being held.  
> 
> Writing data to the OProfile buffer consists of a sequence of items.
> For example when writing an SPU entry, first comes the escape code so
> the daemon knows this is a new entry.  The next item is the SPU context
> switch code which says the data which will follow is the information
> about a new context.  There is a different code to identify the data as
> an address sample.  Finally the data about the SPU context switch is
> entered into the buffer.  The issue is the OProfile daemon is read all
> of the entire sequence of items then process the data.  Without the
> mutex lock, the daemon may read part of the sequence try to process it
> before everything is written into the buffer.  When the daemon reads
> again, it doesn't see the escape code as the first item and isn't smart
> enough to realize it is part of a previous sequence.  The generic
> OProfile code defines the mutex lock and calls it buffer_mutex.  The
> OProfile kernel/daemon API uses the mutex lock. The mutex lock can only
> be held in a non interrupt context.  The current implementation uses a
> spin lock to make sure the kernel writes each sequence if items into the
> buffer but since the API does not use a spin lock we have no way to
> prevent the daemon from reading the buffer until the entire sequence of
> items has been written to the buffer.  Hence the need to hold the
> buffer_mutex lock which prevents the daemon from accessing the buffer.
> 
> > 
> > > Index: linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
> > > ===================================================================
> > > --- linux-2.6.25-rc4.orig/arch/powerpc/oprofile/cell/spu_profiler.c
> > > +++ linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
> > > @@ -16,6 +16,7 @@
> > >  #include <linux/smp.h>
> > >  #include <linux/slab.h>
> > >  #include <asm/cell-pmu.h>
> > > +#include <linux/workqueue.h>
> > >  #include "pr_util.h"
> > >  
> > 
> > Please keep #include statements in alphabetical order, with all linux/ files
> > before the asm/ files.
> > 
> > >  #define TRACE_ARRAY_SIZE 1024
> > > @@ -32,9 +33,19 @@ static unsigned int profiling_interval;
> > >  
> > >  #define SPU_PC_MASK	     0xFFFF
> > >  
> > > +/* The generic OProfile code uses the buffer_mutex to protect the buffer
> > > + * between the kernel and the daemon.  The SPU code needs to use the buffer
> > > + * to ensure that the kernel SPU writes complete as a single block before
> > > + * being consumed by the daemon.
> > > + */
> > > +extern struct mutex buffer_mutex;
> > > +
> > >  static DEFINE_SPINLOCK(sample_array_lock);
> > >  unsigned long sample_array_lock_flags;
> > >  
> > > +struct work_struct spu_record_wq;
> > > +extern struct workqueue_struct *oprofile_spu_wq;
> > > +
> > >  void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
> > >  {
> > >  	unsigned long ns_per_cyc;
> > 
> > Never put extern statements in the implementation, they describe the
> > interface between two parts of the code and should be inside of a
> > common header.
> > 
> > Why do you want to have your own workqueue instead of using the
> > global one?

It is important that the data get context switch data get recorded as
quickly as possible to avoid dropping data unnecessarily.  The PC
counter data for each SPU is ignored until the context switch record is
put into the kernel/daemon buffer.  The API documentation says that
using a private workqueue has better performance then using the global
workqueue.  There is a comment in the code about this, perhaps it is not
clear enough.

> > 
> > > @@ -123,14 +134,14 @@ static int cell_spu_pc_collection(int cp
> > >  	return entry;
> > >  }
> > >  
> > > -
> > > -static enum hrtimer_restart profile_spus(struct hrtimer *timer)
> > > -{
> > > -	ktime_t kt;
> > > +static void profile_spus_record_samples (struct work_struct *ws) {
> > > +	/* This routine is called via schedule_work() to record the
> > > +	 * spu data.  It must be run in a normal kernel mode to
> > > +	 * grab the OProfile mutex lock.
> > > +	 */
> > >  	int cpu, node, k, num_samples, spu_num;
> > >  
> > > -	if (!spu_prof_running)
> > > -		goto stop;
> > > +	mutex_lock(&buffer_mutex);
> > >  
> > >  	for_each_online_cpu(cpu) {
> > >  		if (cbe_get_hw_thread_id(cpu))
> > > @@ -170,6 +181,20 @@ static enum hrtimer_restart profile_spus
> > >  	smp_wmb();	/* insure spu event buffer updates are written */
> > >  			/* don't want events intermingled... */
> > >  
> > > +	mutex_unlock(&buffer_mutex);
> > > +}
> > > +
> > > +static enum hrtimer_restart profile_spus(struct hrtimer *timer)
> > > +{
> > > +	ktime_t kt;
> > > +
> > > +
> > > +	if (!spu_prof_running)
> > > +		goto stop;
> > > +
> > > +	/* schedule the funtion to record the data */
> > > +	schedule_work(&spu_record_wq);
> > > +
> > >  	kt = ktime_set(0, profiling_interval);
> > >  	if (!spu_prof_running)
> > >  		goto stop;
> > 
> > This looks like you want to use a delayed_work rather than building your
> > own out of hrtimer and work. Is there any point why you want to use
> > an hrtimer?
> 
> The current implementation uses the hrtimer to schedule when to read the
> trace buffer the next time.  This patch does not change how the
> scheduling of the buffer reads is done.  Yes, you could change the
> implementation to use workqueues instead.  If you feel that it is better
> to use the workqueue then we could make that change.  Not sure that
> making that change in this bug fix patch is appropriate.  I would need
> to create a second patch for that change.
> > 
> > > -static DEFINE_SPINLOCK(buffer_lock);
> > > +extern struct mutex buffer_mutex;
> > > +extern struct workqueue_struct *oprofile_spu_wq;
> > > +extern int calls_to_record_switch;
> > > +
> > 
> > Again, public interfaces need to go to a header file, and should
> > have a name that identifies the interface. "buffer_mutex" is
> > certainly not a suitable name for a kernel-wide global variable!
> 
> As stated earlier, the generic OProfile code defines the variable
> "buffer_mutex".  Changing the name in the generic OProfile code is
> beyond the scope of this patch.
> 
> > 
> > >  static DEFINE_SPINLOCK(cache_lock);
> > >  static int num_spu_nodes;
> > > +
> > >  int spu_prof_num_nodes;
> > >  int last_guard_val[MAX_NUMNODES * 8];
> > > +int cnt_swtch_processed_flag[MAX_NUMNODES * 8];
> > > +
> > > +struct spus_profiling_code_data_s {
> > > +	int num_spu_nodes;
> > > +	struct work_struct spu_prof_code_wq;
> > > +} spus_profiling_code_data;
> > > +
> > > +struct spu_context_switch_data_s {
> > > +	struct spu *spu;
> > > +	unsigned long spu_cookie;
> > > +	unsigned long app_dcookie;
> > > +	unsigned int offset;
> > > +	unsigned long objectId;
> > > +	int valid_entry;
> > > +} spu_context_switch_data;
> > 
> > I don't understand what these variables are really doing, but
> > having e.g. just one spu_context_switch_data for all the SPUs
> > doesn't seem to make much sense. What happens when two SPUs do
> > a context switch at the same time?
> 
> This is the data same data that was being put into the event buffer
> directly from the interrupt context.  We need to store the data that is
> only available in the interrupt context so the same data can be put into
> the buffer by the work queue function in the non interrupt context.
> This is the declaration of the data needed per SPU.  Below in the
> spu_cntx_sw_data structure, we declare an array of entries so we can
> store the switch

oops, accidentally hit save when I tried to move the window. Sorry.

data on a per SPU basis as you alluded to.  


> > 
> > > +int calls_to_record_switch = 0;
> > > +int record_spu_start_flag = 0;
> > > +
> > > +struct spus_cntxt_sw_data_s {
> > > +	int num_spu_nodes;
> > > +	struct spu_context_switch_data_s spu_data[MAX_NUMNODES * 8];
> > > +	struct work_struct spu_cntxt_work;
> > > +} spus_cntxt_sw_data;
> > 
> > Something is very wrong if you need so many global variables!

The calls_to_record_switch variable is not used, my mistake for not
getting it out of the patch.  The record_spu_stat_flag is used. It is
set in the spu_sync_start when SPU profiling is started.  The first time
the work function is called to record SPU context switches it sees the
flag is set and writes the initial record to the daemon/kernel buffer
stating that this is an SPU profile run not a PPU profile run.  The
daemon needs to know this as it effects how the postprocessing is done.
The initial record is only written once.  

The spus_context_sw_data structure has the array per SPU for all off the
interrupt context data that was recorded and needs to be written to the
kernel/daemon buffer.  
> > 
> > >  /* Container for caching information about an active SPU task. */
> > >  struct cached_info {
> > > @@ -44,6 +73,8 @@ struct cached_info {
> > >  	struct kref cache_ref;
> > >  };
> > >  
> > > +struct workqueue_struct *oprofile_spu_wq;
> > > +
> > >  static struct cached_info *spu_info[MAX_NUMNODES * 8];
> > 
> > While you're cleaning this up, I guess the cached_info should
> > be moved into a pointer from struct spu as well, instead of
> > having this global variable here.

This would be a functional change and it belongs in a functional change
patch not in a bug fix patch.

> > 
> > > @@ -375,16 +457,30 @@ int spu_sync_start(void)
> > >  	int k;
> > >  	int ret = SKIP_GENERIC_SYNC;
> > >  	int register_ret;
> > > -	unsigned long flags = 0;
> > >  
> > >  	spu_prof_num_nodes = number_of_online_nodes();
> > >  	num_spu_nodes = spu_prof_num_nodes * 8;
> > >  
> > > -	spin_lock_irqsave(&buffer_lock, flags);
> > > -	add_event_entry(ESCAPE_CODE);
> > > -	add_event_entry(SPU_PROFILING_CODE);
> > > -	add_event_entry(num_spu_nodes);
> > > -	spin_unlock_irqrestore(&buffer_lock, flags);
> > > +	/* create private work queue, execution of work is time critical */
> > > +	oprofile_spu_wq = create_workqueue("spu_oprofile");
> > > +
> > > +	/* due to a race when the spu is already running stuff, need to
> > > +	 * set a flag to tell the spu context switch to record the start
> > > +	 * before recording the context switches.
> > > +	 */
> > > +	record_spu_start_flag = 1;
> > > +
> > > +	spus_profiling_code_data.num_spu_nodes = num_spu_nodes;
> > > +
> > > +	/* setup work queue functiion for recording context switch info */
> > > +	spus_cntxt_sw_data.num_spu_nodes = num_spu_nodes;
> > > +	for (k = 0; k<(MAX_NUMNODES * 8); k++) {
> > > +		spus_cntxt_sw_data.spu_data[k].valid_entry = 0;
> > > +		cnt_swtch_processed_flag[k] = 0;
> > > +	}
> > > +
> > > +	INIT_WORK(&spus_cntxt_sw_data.spu_cntxt_work,
> > > +		  record_spu_process_switch);
> > 
> > I would guess that you need one work struct per SPU instead of a global
> > one, if you want to pass the SPU pointer as an argument.
> > 
> > 	Arnd <><

We only need one work struct because we have an array that contains the
data for each SPU that has done a context switch.  



