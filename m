Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYHHWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYHHWaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbYHHWa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:30:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55187 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762815AbYHHWa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:30:27 -0400
Subject: Re: [PATCH 1/2] Cell OProfile: SPU mutex lock fix, version 4
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200808081808.14504.arnd@arndb.de>
References: <1217620877.15667.143.camel@carll-linux-desktop>
	 <200808081808.14504.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 15:29:24 -0700
Message-Id: <1218234564.6637.104.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-08 at 18:08 +0200, Arnd Bergmann wrote:
> On Friday 01 August 2008, Carl Love wrote:
> > The issue is the SPU code is not holding the kernel mutex lock while
> > adding samples to the kernel buffer.
> 
> Thanks for your patch, and sorry for not replying earlier.
> It looks good from a functionality perspective, I just have
> some style comments left that I hope we can address quickly.
> 
> Since this is still a bug fix (though a rather large one), I
> guess we can should get it into 2.6.27-rc3.
> 
> 	Arnd <><
> 
> > Index: Cell_kernel_6_26_2008/arch/powerpc/oprofile/cell/spu_task_sync.c
> > ===================================================================
> > --- Cell_kernel_6_26_2008.orig/arch/powerpc/oprofile/cell/spu_task_sync.c
> > +++ Cell_kernel_6_26_2008/arch/powerpc/oprofile/cell/spu_task_sync.c
> > @@ -35,7 +35,106 @@ static DEFINE_SPINLOCK(buffer_lock);
> >  static DEFINE_SPINLOCK(cache_lock);
> >  static int num_spu_nodes;
> >  int spu_prof_num_nodes;
> > -int last_guard_val[MAX_NUMNODES * 8];
> > +int last_guard_val[MAX_NUMNODES * SPUS_PER_NODE];
> > +static int spu_ctx_sw_seen[MAX_NUMNODES * SPUS_PER_NODE];
> > +static int sync_start_registered;
> > +static int delayed_work_init;
> 
> You don't need the delayed_work_init variable. Just initialize
> the work queue in your init function to be sure it's always
> right.
> 
> I think you should also try to remove sync_start_registered,
> these global state variables can easily get annoying when you
> try to change something.
> AFAICT, spu_sync_stop does not get called unless spu_sync_start
> was successful, so the sync_start_registered variable is
> redundant.
> 


I was able to remove the delayed_work_init variable with a little code
restructuring.  

I worked on the sync_start_registered variable.  I had put it in because
I thought that the call to spu_switch_event_unregister() call for a non
registered event was giving me a kernel error.  I retested this and it
does look like it is OK.  So it looks safe to remove the
sync_start_registered variable.  

The rest of your comments were fairly easy to address.


> > +static int oprofile_spu_buff_create(void)
> > +{
> > +	int spu;
> > +
> > +	max_spu_buff = oprofile_get_cpu_buffer_size();
> > +
> > +	for (spu = 0; spu < num_spu_nodes; spu++) {
> > +		/* create circular buffers to store the data in.
> > +		 * use locks to manage accessing the buffers
> > + 		 */
> > +		spu_buff.index[spu].head = 0;
> > +		spu_buff.index[spu].tail = 0;
> > +
> > +		/*
> > +		 * Create a buffer for each SPU.  Can't reliably
> > +		 * create a single buffer for all spus due to not
> > +		 * enough contiguous kernel memory.
> > +		 */
> > +
> > +		spu_buff.buff[spu] = kzalloc((max_spu_buff
> > +					      * sizeof(unsigned long)),
> > +					     GFP_KERNEL);
> > +
> > +		if (!spu_buff.buff[spu]) {
> > +			printk(KERN_ERR "SPU_PROF: "
> > +			       "%s, line %d:  oprofile_spu_buff_create " \
> > +		       "failed to allocate spu buffer %d.\n",
> > +			       __FUNCTION__, __LINE__, spu);
> 
> The formatting of the printk line is a little unconventional. You certainly
> don't need the '\' at the end of the line.
> Also, please don't use __FUNCTION__ in new code, but instead of the
> standard c99 __func__ symbol. The __LINE__ macro is fine.
> 
> > +
> > +			/* release the spu buffers that have been allocated */
> > +			while (spu >= 0) {
> > +				if (spu_buff.buff[spu]) {
> > +					kfree(spu_buff.buff[spu]);
> > +					spu_buff.buff[spu] = 0;
> > +				}
> > +				spu--;
> > +			}
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> 
> The convention for a function would be to return -ENOMEM here instead
> of 1.
> 
> >  /* The main purpose of this function is to synchronize
> >   * OProfile with SPUFS by registering to be notified of
> >   * SPU task switches.
> > @@ -372,30 +521,50 @@ static int number_of_online_nodes(void)
> >   */
> >  int spu_sync_start(void)
> >  {
> > -	int k;
> > +	int spu;
> >  	int ret = SKIP_GENERIC_SYNC;
> >  	int register_ret;
> >  	unsigned long flags = 0;
> >  
> >  	spu_prof_num_nodes = number_of_online_nodes();
> >  	num_spu_nodes = spu_prof_num_nodes * 8;
> > +	delayed_work_init = 0;
> > +
> > +	/* create buffer for storing the SPU data to put in
> > +	 * the kernel buffer.
> > +	 */
> > +	if (oprofile_spu_buff_create()) {
> > +		ret = -ENOMEM;
> > +		sync_start_registered = 0;
> > +		goto out;
> > +	}
> 
> consequently, this becomes
> 
> 	ret = oprofile_spu_buff_create();
> 	if (ret)
> 		goto out;
>   
> 
> > -out:
> > +
> > +	/* remove scheduled work queue item rather then waiting
> > +	 * for every queued entry to execute.  Then flush pending
> > +	 * system wide buffer to event buffer.  Only try to
> > +	 * remove if it was scheduled.  Get kernel errors otherwise.
> > +	 */
> > +	if (delayed_work_init)
> > +		cancel_delayed_work(&spu_work);
> > +
> > +	for (k = 0; k < num_spu_nodes; k++) {
> > +		spu_ctx_sw_seen[k] = 0;
> > +
> > +		/* spu_sys_buff will be null if there was a problem
> > +		 * allocating the buffer.  Only delete if it exists.
> > +		 */
> > +
> > +		if (spu_buff.buff[k]) {
> > +			kfree(spu_buff.buff[k]);
> > +			spu_buff.buff[k] = 0;
> > +		}
> > +	}
> 
> The if(spu_buff.buff[k]) is redundant, kfree(NULL) is valid, so you
> should simplify this.
>   
> > +/* Put head and tail for the spu buffer into a structure to keep
> > + * them in the same cache line.
> > + */
> > +struct head_tail {
> > +	unsigned int head;
> > +	unsigned int tail;
> > +};
> > +
> > +struct spu_buffers {
> > +	unsigned long *buff[MAX_NUMNODES * SPUS_PER_NODE];
> > +	struct head_tail index[MAX_NUMNODES * SPUS_PER_NODE];
> > +};
> > +
> 
> Did you measure a problem in the cache layout here? A simpler
> array of
> 
> struct spu_buffer {
> 	int last_guard_val;
> 	int spu_ctx_sw_seen;
> 	unsigned long *buff;
> 	unsigned int head, tail;
> };
> 
> would otherwise be more reasonable, mostly for readability.
> 
> > +/* The function can be used to add a buffer worth of data directly to
> > + * the kernel buffer. The buffer is assumed to be a circular buffer.
> > + * Take the entries from index start and end at index end, wrapping
> > + * at max_entries.
> > + */
> > +void oprofile_put_buff(unsigned long *buf, unsigned int start,
> > +		       unsigned int stop, unsigned int max)
> > +{
> > +	int i;
> > +
> > +	/* Check the args */
> > +	if (stop > max) {
> > +		printk(KERN_ERR "oprofile: oprofile_put_buff(), illegal "\
> > +		       "arguments; stop greater then max."\
> > +		       " stop = %u, max = %u.\n",
> > +		       stop, max);
> > +		return;
> > +	}
> 
> hmm, this is not a good interface. Better return -EINVAL in case of
> error, or, even better, don't call this function with invalid
> arguments. Note that in the kernel, the rule is that you expect other
> kernel code to be written correctly, and user space code to call you
> with any combination of invalid arguments.
> 
> 	Arnd <><

