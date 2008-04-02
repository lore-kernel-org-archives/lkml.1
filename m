Return-Path: <linux-kernel-owner+w=401wt.eu-S1750903AbYDBFVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbYDBFVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 01:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYDBFVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 01:21:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYDBFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 01:21:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev]  [PATCH] Cell OProfile: SPU mutex lock fix
Date: Wed, 2 Apr 2008 07:21:15 +0200
User-Agent: KMail/1.9.9
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cel <cel@linux.vnet.ibm.com>
References: <1206460727.7132.232.camel@carll-linux-desktop>
In-Reply-To: <1206460727.7132.232.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020721.15861.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nvqQOBiu+scSAoJmUSH9IMKEohj93taKF6dj
 bp8pvCnDzymf85Z1HjsRCwdt3nScgrC2RLJ81C4F5Kw6McGsJg
 f3nMnUMH4QTx9QtvsqsTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008, Carl Love wrote:
> This patch fixes a bug in the code that records the SPU data and
> context switches.  The buffer_mutex lock must be held when the
> kernel is adding data to the buffer between the kernel and the
> OProfile daemon.  The lock is not being held in the current code
> base.  This patch fixes the bug using work queues.  The data to 
> be passed to the daemon is caputured by the interrupt handler.  
> The workqueue function is invoked to grab the buffer_mutex lock
> and add the data to the buffer.  

So what was the exact bug you're fixing with this? There was no
buffer_mutex before, so why do you need it now? Can't this be a
spinlock so you can get it from interrupt context instead of
using a workqueue?

> Index: linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
> ===================================================================
> --- linux-2.6.25-rc4.orig/arch/powerpc/oprofile/cell/spu_profiler.c
> +++ linux-2.6.25-rc4/arch/powerpc/oprofile/cell/spu_profiler.c
> @@ -16,6 +16,7 @@
>  #include <linux/smp.h>
>  #include <linux/slab.h>
>  #include <asm/cell-pmu.h>
> +#include <linux/workqueue.h>
>  #include "pr_util.h"
>  

Please keep #include statements in alphabetical order, with all linux/ files
before the asm/ files.

>  #define TRACE_ARRAY_SIZE 1024
> @@ -32,9 +33,19 @@ static unsigned int profiling_interval;
>  
>  #define SPU_PC_MASK	     0xFFFF
>  
> +/* The generic OProfile code uses the buffer_mutex to protect the buffer
> + * between the kernel and the daemon.  The SPU code needs to use the buffer
> + * to ensure that the kernel SPU writes complete as a single block before
> + * being consumed by the daemon.
> + */
> +extern struct mutex buffer_mutex;
> +
>  static DEFINE_SPINLOCK(sample_array_lock);
>  unsigned long sample_array_lock_flags;
>  
> +struct work_struct spu_record_wq;
> +extern struct workqueue_struct *oprofile_spu_wq;
> +
>  void set_spu_profiling_frequency(unsigned int freq_khz, unsigned int cycles_reset)
>  {
>  	unsigned long ns_per_cyc;

Never put extern statements in the implementation, they describe the
interface between two parts of the code and should be inside of a
common header.

Why do you want to have your own workqueue instead of using the
global one?

> @@ -123,14 +134,14 @@ static int cell_spu_pc_collection(int cp
>  	return entry;
>  }
>  
> -
> -static enum hrtimer_restart profile_spus(struct hrtimer *timer)
> -{
> -	ktime_t kt;
> +static void profile_spus_record_samples (struct work_struct *ws) {
> +	/* This routine is called via schedule_work() to record the
> +	 * spu data.  It must be run in a normal kernel mode to
> +	 * grab the OProfile mutex lock.
> +	 */
>  	int cpu, node, k, num_samples, spu_num;
>  
> -	if (!spu_prof_running)
> -		goto stop;
> +	mutex_lock(&buffer_mutex);
>  
>  	for_each_online_cpu(cpu) {
>  		if (cbe_get_hw_thread_id(cpu))
> @@ -170,6 +181,20 @@ static enum hrtimer_restart profile_spus
>  	smp_wmb();	/* insure spu event buffer updates are written */
>  			/* don't want events intermingled... */
>  
> +	mutex_unlock(&buffer_mutex);
> +}
> +
> +static enum hrtimer_restart profile_spus(struct hrtimer *timer)
> +{
> +	ktime_t kt;
> +
> +
> +	if (!spu_prof_running)
> +		goto stop;
> +
> +	/* schedule the funtion to record the data */
> +	schedule_work(&spu_record_wq);
> +
>  	kt = ktime_set(0, profiling_interval);
>  	if (!spu_prof_running)
>  		goto stop;

This looks like you want to use a delayed_work rather than building your
own out of hrtimer and work. Is there any point why you want to use
an hrtimer?

> -static DEFINE_SPINLOCK(buffer_lock);
> +extern struct mutex buffer_mutex;
> +extern struct workqueue_struct *oprofile_spu_wq;
> +extern int calls_to_record_switch;
> +

Again, public interfaces need to go to a header file, and should
have a name that identifies the interface. "buffer_mutex" is
certainly not a suitable name for a kernel-wide global variable!

>  static DEFINE_SPINLOCK(cache_lock);
>  static int num_spu_nodes;
> +
>  int spu_prof_num_nodes;
>  int last_guard_val[MAX_NUMNODES * 8];
> +int cnt_swtch_processed_flag[MAX_NUMNODES * 8];
> +
> +struct spus_profiling_code_data_s {
> +	int num_spu_nodes;
> +	struct work_struct spu_prof_code_wq;
> +} spus_profiling_code_data;
> +
> +struct spu_context_switch_data_s {
> +	struct spu *spu;
> +	unsigned long spu_cookie;
> +	unsigned long app_dcookie;
> +	unsigned int offset;
> +	unsigned long objectId;
> +	int valid_entry;
> +} spu_context_switch_data;

I don't understand what these variables are really doing, but
having e.g. just one spu_context_switch_data for all the SPUs
doesn't seem to make much sense. What happens when two SPUs do
a context switch at the same time?

> +int calls_to_record_switch = 0;
> +int record_spu_start_flag = 0;
> +
> +struct spus_cntxt_sw_data_s {
> +	int num_spu_nodes;
> +	struct spu_context_switch_data_s spu_data[MAX_NUMNODES * 8];
> +	struct work_struct spu_cntxt_work;
> +} spus_cntxt_sw_data;

Something is very wrong if you need so many global variables!

>  /* Container for caching information about an active SPU task. */
>  struct cached_info {
> @@ -44,6 +73,8 @@ struct cached_info {
>  	struct kref cache_ref;
>  };
>  
> +struct workqueue_struct *oprofile_spu_wq;
> +
>  static struct cached_info *spu_info[MAX_NUMNODES * 8];

While you're cleaning this up, I guess the cached_info should
be moved into a pointer from struct spu as well, instead of
having this global variable here.

> @@ -375,16 +457,30 @@ int spu_sync_start(void)
>  	int k;
>  	int ret = SKIP_GENERIC_SYNC;
>  	int register_ret;
> -	unsigned long flags = 0;
>  
>  	spu_prof_num_nodes = number_of_online_nodes();
>  	num_spu_nodes = spu_prof_num_nodes * 8;
>  
> -	spin_lock_irqsave(&buffer_lock, flags);
> -	add_event_entry(ESCAPE_CODE);
> -	add_event_entry(SPU_PROFILING_CODE);
> -	add_event_entry(num_spu_nodes);
> -	spin_unlock_irqrestore(&buffer_lock, flags);
> +	/* create private work queue, execution of work is time critical */
> +	oprofile_spu_wq = create_workqueue("spu_oprofile");
> +
> +	/* due to a race when the spu is already running stuff, need to
> +	 * set a flag to tell the spu context switch to record the start
> +	 * before recording the context switches.
> +	 */
> +	record_spu_start_flag = 1;
> +
> +	spus_profiling_code_data.num_spu_nodes = num_spu_nodes;
> +
> +	/* setup work queue functiion for recording context switch info */
> +	spus_cntxt_sw_data.num_spu_nodes = num_spu_nodes;
> +	for (k = 0; k<(MAX_NUMNODES * 8); k++) {
> +		spus_cntxt_sw_data.spu_data[k].valid_entry = 0;
> +		cnt_swtch_processed_flag[k] = 0;
> +	}
> +
> +	INIT_WORK(&spus_cntxt_sw_data.spu_cntxt_work,
> +		  record_spu_process_switch);

I would guess that you need one work struct per SPU instead of a global
one, if you want to pass the SPU pointer as an argument.

	Arnd <><
