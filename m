Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYGWUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYGWUCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYGWUCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:02:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60821 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYGWUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:02:33 -0400
Subject: Re: [PATCH 10/24] x86/oprofile: Add IBS support for AMD CPUs, IBS
	buffer handling routines
From: Carl Love <cel@us.ibm.com>
To: rrichter@elbe.amd.com
Cc: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <1216753748-11261-11-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
	 <1216753748-11261-11-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 13:01:57 -0700
Message-Id: <1216843317.26829.58.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-22 at 21:08 +0200, Robert Richter wrote:
> From: Barry Kasindorf <barry.kasindorf@amd.com>
> 
> This patchset supports the new profiling hardware available in the
> latest AMD CPUs in the oProfile driver.
> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/buffer_sync.c |   72 +++++++++++++++++++++++++++++++++++++++-
>  drivers/oprofile/cpu_buffer.c  |   68 +++++++++++++++++++++++++++++++++++++-
>  drivers/oprofile/cpu_buffer.h  |    2 +
>  3 files changed, 140 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
> index 615929f..e1782d2 100644
> --- a/drivers/oprofile/buffer_sync.c
> +++ b/drivers/oprofile/buffer_sync.c
> @@ -5,6 +5,7 @@
>   * @remark Read the file COPYING
>   *
>   * @author John Levon <levon@movementarian.org>
> + * @author Barry Kasindorf
>   *
>   * This is the core of the buffer management. Each
>   * CPU buffer is processed and entered into the
> @@ -272,7 +273,7 @@ static void increment_tail(struct oprofile_cpu_buffer *b)
>  {
>  	unsigned long new_tail = b->tail_pos + 1;
> 
> -	rmb();
> +	rmb();	/* be sure fifo pointers are synchromized */
> 
>  	if (new_tail < b->buffer_size)
>  		b->tail_pos = new_tail;
> @@ -327,6 +328,67 @@ static void add_trace_begin(void)
>  	add_event_entry(TRACE_BEGIN_CODE);
>  }
> 
> +#define IBS_FETCH_CODE_SIZE	2
> +#define IBS_OP_CODE_SIZE	5
> +#define IBS_EIP(offset)				\
> +	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
> +#define IBS_EVENT(offset)				\
> +	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
> +
> +/*
> + * Add IBS fetch and op entries to event buffer
> + */
> +static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
> +	int in_kernel, struct mm_struct *mm)
> +{
> +	unsigned long rip;
> +	int i, count;
> +	unsigned long ibs_cookie = 0;
> +	off_t offset;
> +
> +	increment_tail(cpu_buf);	/* move to RIP entry */
> +
> +	rip = IBS_EIP(cpu_buf->tail_pos);
> +
> +#ifdef __LP64__
> +	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
> +#endif
> +
> +	if (mm) {
> +		ibs_cookie = lookup_dcookie(mm, rip, &offset);
> +
> +		if (ibs_cookie == NO_COOKIE)
> +			offset = rip;
> +		if (ibs_cookie == INVALID_COOKIE) {
> +			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
> +			offset = rip;
> +		}
> +		if (ibs_cookie != last_cookie) {
> +			add_cookie_switch(ibs_cookie);
> +			last_cookie = ibs_cookie;
> +		}
> +	} else
> +		offset = rip;
> +
> +	add_event_entry(ESCAPE_CODE);
> +	add_event_entry(code);
> +	add_event_entry(offset);	/* Offset from Dcookie */
> +
> +	/* we send the Dcookie offset, but send the raw Linear Add also*/
> +	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
> +	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
> +
> +	if (code == IBS_FETCH_CODE)
> +		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
> +	else
> +		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
> +
> +	for (i = 0; i < count; i++) {
> +		increment_tail(cpu_buf);
> +		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
> +		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
> +	}
> +}

In general, I think it would be good to make the IBS stuff as arch
independent as possible.  Could you move the above function to the arch
specific code.  Here a generic function pointer could be exported which
would be assigned to the arch specific routine.  This would enable
another architecture to reuse this code.  

> 
>  static void add_sample_entry(unsigned long offset, unsigned long event)
>  {
> @@ -524,6 +586,14 @@ void sync_buffer(int cpu)
>  			} else if (s->event == CPU_TRACE_BEGIN) {
>  				state = sb_bt_start;
>  				add_trace_begin();
> +			} else if (s->event == IBS_FETCH_BEGIN) {
> +				state = sb_bt_start;
> +				add_ibs_begin(cpu_buf,
> +					IBS_FETCH_CODE, in_kernel, mm);
> +			} else if (s->event == IBS_OP_BEGIN) {
> +				state = sb_bt_start;
> +				add_ibs_begin(cpu_buf,
> +					IBS_OP_CODE, in_kernel, mm);
>  			} else {
>  				struct mm_struct *oldmm = mm;
> 

If you made the log_ibs_sample() more generic, as discussed below, then
the #defines could be changed to generic names and thus allow other
architectures to leverage the same code.  


> diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
> index 2450b3a..c9ac4e1 100644
> --- a/drivers/oprofile/cpu_buffer.c
> +++ b/drivers/oprofile/cpu_buffer.c
> @@ -5,6 +5,7 @@
>   * @remark Read the file COPYING
>   *
>   * @author John Levon <levon@movementarian.org>
> + * @author Barry Kasindorf <barry.kasindorf@amd.com>
>   *
>   * Each CPU has a local buffer that stores PC value/event
>   * pairs. We also log context switches when we notice them.
> @@ -207,7 +208,7 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
>  	return 1;
>  }
> 
> -static int oprofile_begin_trace(struct oprofile_cpu_buffer * cpu_buf)
> +static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
>  {
>  	if (nr_available_slots(cpu_buf) < 4) {
>  		cpu_buf->sample_lost_overflow++;
> @@ -252,6 +253,71 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
>  	oprofile_add_ext_sample(pc, regs, event, is_kernel);
>  }
> 
> +#define MAX_IBS_SAMPLE_SIZE	14
> +static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
> +	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
> +{
> +	struct task_struct *task;
> +
> +	cpu_buf->sample_received++;
> +
> +	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
> +		cpu_buf->sample_lost_overflow++;
> +		return 0;
> +	}
> +
> +	is_kernel = !!is_kernel;
> +
> +	/* notice a switch from user->kernel or vice versa */
> +	if (cpu_buf->last_is_kernel != is_kernel) {
> +		cpu_buf->last_is_kernel = is_kernel;
> +		add_code(cpu_buf, is_kernel);
> +	}
> +
> +	/* notice a task switch */
> +	if (!is_kernel) {
> +		task = current;
> +
> +		if (cpu_buf->last_task != task) {
> +			cpu_buf->last_task = task;
> +			add_code(cpu_buf, (unsigned long)task);
> +		}
> +	}
> +
> +	add_code(cpu_buf, ibs_code);
> +	add_sample(cpu_buf, ibs[0], ibs[1]);
> +	add_sample(cpu_buf, ibs[2], ibs[3]);
> +	add_sample(cpu_buf, ibs[4], ibs[5]);
> +
> +	if (ibs_code == IBS_OP_BEGIN) {
> +	add_sample(cpu_buf, ibs[6], ibs[7]);
> +	add_sample(cpu_buf, ibs[8], ibs[9]);
> +	add_sample(cpu_buf, ibs[10], ibs[11]);
> +	}
> +
> +	return 1;
> +}
> +

Can we make this function a bit more general?  Specifically, suppose 

static int log_generic_sample (struct oprofile_cpu_buffer *cpu_buf, 
                                 unsigned int *array, int num_entries) 

If we just passed in an array of data that is ready to just be copied
directly to 
the kernel buffer in a for loop: 

for (i=0; i<num_entries; i=i+2) 

        add_sample(cpu_buf, array[i], array[i+1]); 

The arch specific code would have to do the if(ibs_code == IBS_OP_BEGIN)
code to either add the stuff into the input array or not.  The
appropriate number of entries would be passed.   

The  if (cpu_buf->last_is_kernel != is_kernel) statement might be hard
to do from the architecture code and might have to stay in the
log_generic_sample. It would be good if we could find a way to also move
this line of code to the arch specific code to setup the generic array
of data to pass to log_generic_sample(). Maybe the arch specific code
could have an array of last_is_kernel to refer to when preparing the
data for the log_generic_sample() call.

By making this more generic and flexible in the number of entries and
pushing the logic of what to put into the array into the arch specific
code, it could be used by other architectures.  I had something along
the lines of the above log_generic_sample() in a version of a patch for
the CELL architecture.  On CELL, I have to take samples from the various
SPUs and push them into the kernel buffer.  I had tried to do it using
the per CPU buffers.  I ended up dropping the approach for other
reasons.  The point is I can see where something a little more
generic/flexible could be used by other architectures.

> +void oprofile_add_ibs_sample(struct pt_regs *const regs,
> +				unsigned int * const ibs_sample, u8 code)
> +{
> +	int is_kernel = !user_mode(regs);
> +	unsigned long pc = profile_pc(regs);
> +
> +	struct oprofile_cpu_buffer *cpu_buf =
> +			 &per_cpu(cpu_buffer, smp_processor_id());
> +
> +	if (!backtrace_depth) {
> +		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code);
> +		return;
> +	}
> +
> +	/* if log_sample() fails we can't backtrace since we lost the source
> +	* of this event */
> +	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code))
> +		oprofile_ops.backtrace(regs, backtrace_depth);
> +}
> +
>  void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
>  {
>  	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
> diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
> index c3e366b..9c44d00 100644
> --- a/drivers/oprofile/cpu_buffer.h
> +++ b/drivers/oprofile/cpu_buffer.h
> @@ -55,5 +55,7 @@ void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
>  /* transient events for the CPU buffer -> event buffer */
>  #define CPU_IS_KERNEL 1
>  #define CPU_TRACE_BEGIN 2
> +#define IBS_FETCH_BEGIN 3
> +#define IBS_OP_BEGIN    4
> 
>  #endif /* OPROFILE_CPU_BUFFER_H */

