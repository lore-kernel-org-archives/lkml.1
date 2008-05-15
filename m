Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYEOTHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYEOTHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYEOTHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:07:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49961 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYEOTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:07:31 -0400
Subject: Re: [PATCH] Updated: Reworked Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <200805151739.26392.arnd@arndb.de>
References: <1209652994.17842.1.camel@carll-linux-desktop>
	 <200805151739.26392.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 15 May 2008 12:05:05 -0700
Message-Id: <1210878305.20791.109.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-15 at 17:39 +0200, Arnd Bergmann wrote:
> On Thursday 01 May 2008, Carl Love wrote:
> 
> > Finally, this patch backs out the changes previously added to the 
> > oprofile generic code for handling the architecture specific 
> > ops.sync_start and ops.sync_stop that allowed the architecture
> > to skip the per CPU buffer creation.
> 
> Thanks for your patch, it looks a lot better than your previous version.
> It would be good to have an oprofile person look into the changes
> to the common code though.
> 
> Just a few more comments/questions this time:
> 
> > -static DEFINE_SPINLOCK(buffer_lock);
> > +static DEFINE_SPINLOCK(add_value_lock);
> >  static DEFINE_SPINLOCK(cache_lock);
> >  static int num_spu_nodes;
> >  int spu_prof_num_nodes;
> >  int last_guard_val[MAX_NUMNODES * 8];
> > +static int spu_ctx_sw_seen[MAX_NUMNODES * 8];
> >  
> >  /* Container for caching information about an active SPU task. */
> >  struct cached_info {
> 
> I noticed now that you are indexing arrays by SPU number. This is not
> a good idea, because you make assumptions about the system that may
> not be true. Better pass around 'struct spu' pointers and put those
> values in there if you need them. 

Hmm, well, we have arrays for last_guard_val[], spu_info[] as well that
are indexed by spu number.  So this would seem to be a more general
issue then just spu_ctx_seen[].  Not sure exactly what you are
suggesting with passing around 'struct spu' as a solution.  Are you
suggesting that a field be added to the structure for the spu context
seen flag?  Not sure that is a good idea.  We will need to clarify how
you propose to fix this not only for spu_ctx_sw_seen but the other
arrays as well that are already being indexed by spu number.

> Then again, the last_guard_val looks
> like you should really store that information in the context instead
> of the physical SPU, but that is something else to work on.
> 
> Let's leave this one as it is for now and fix the current bug at hand,
> but please remember to fix the assumptions in the code later.
> 
> > @@ -289,6 +290,7 @@ static int process_context_switch(struct
> >  	int retval;
> >  	unsigned int offset = 0;
> >  	unsigned long spu_cookie = 0, app_dcookie;
> > +	int cpu_buf;
> >  
> >  	retval = prepare_cached_spu_info(spu, objectId);
> >  	if (retval)
> > @@ -303,17 +305,28 @@ static int process_context_switch(struct
> >  		goto out;
> >  	}
> >  
> > -	/* Record context info in event buffer */
> > -	spin_lock_irqsave(&buffer_lock, flags);
> > -	add_event_entry(ESCAPE_CODE);
> > -	add_event_entry(SPU_CTX_SWITCH_CODE);
> > -	add_event_entry(spu->number);
> > -	add_event_entry(spu->pid);
> > -	add_event_entry(spu->tgid);
> > -	add_event_entry(app_dcookie);
> > -	add_event_entry(spu_cookie);
> > -	add_event_entry(offset);
> > -	spin_unlock_irqrestore(&buffer_lock, flags);
> > +	/* Record context info in event buffer.  Note, there are 4x more
> > +	 * SPUs then CPUs.  Map the SPU events/data for a given SPU to
> > +	 * the same CPU buffer.  Need to ensure the cntxt switch data and
> > +	 * samples stay in order.
> > +	 */
> > +	cpu_buf = spu->number >> 2;
> 
> The ratio of CPUs versus SPUs is anything but fixed, and the CPU numbers
> may not start at 0. If you have a hypervisor (think PS3), or you are
> running a non-SMP kernel, this is practically always wrong.
> Please use get_cpu()/put_cpu() to read the current CPU number instead.
> This one needs to be fixed now.
> 
> > +	spin_lock_irqsave(&add_value_lock, flags);
> > +	oprofile_add_value(ESCAPE_CODE, cpu_buf);
> > +	oprofile_add_value(SPU_CTX_SWITCH_CODE, cpu_buf);
> > +	oprofile_add_value(spu->number, cpu_buf);
> > +	oprofile_add_value(spu->pid, cpu_buf);
> > +	oprofile_add_value(spu->tgid, cpu_buf);
> > +	oprofile_add_value(app_dcookie, cpu_buf);
> > +	oprofile_add_value(spu_cookie, cpu_buf);
> > +	oprofile_add_value(offset, cpu_buf);
> > +
> > +	/* Set flag to indicate SPU PC data can now be written out.  If
> > +	 * the SPU program counter data is seen before an SPU context
> > +	 * record is seen, the postprocessing will fail.
> > +	 */
> > +	spu_ctx_sw_seen[spu->number] = 1;
> > +	spin_unlock_irqrestore(&add_value_lock, flags);
> >  	smp_wmb();	/* insure spu event buffer updates are written */
> >  			/* don't want entries intermingled... */
> >  out:
> 
> How does the spinlock protect you from racing against other values added
> for the same CPU?

You have lost me with this statement.  There are three sequences of
entries that need to be made, the first is the SPU_PROFILING_CODE, the
second is the SPU_CTX_SWITCH_CODE and the third is an SPU program
counter value.  The SPU_PROFILING_CODE sequence occurs once at the very
beginning when OProfile starts.  It occurs during oprofile setup before
we have registered for the context switch notification and the timer has
been setup to call the routine to read/store the SPU samples.  There is
no race between SPU_PROFILING_CODE and the other two sequences.  The
spin lock is held in the code above before adding the context switch
information to the CPU buffers.  It is held in the routine
spu_sync_buffer() when it is storing the SPU program counter values for
each SPU to its corresponding CPU buffer.  The lock is global in that
you must hold it before adding a context switch sequence to any CPU
buffer.  Similarly you must be holding it before you add an SPU's
program counter value to any of the CPU buffers. So, you can either add
a context switch sequence to a given CPU buffer or you can add an SPU
program counter to the CPU buffer not both at the same time.  The lock
is held until the entire SPU context switch entry is added to the CPU
queue to make sure entries are not intermingled.
> 
> I'm not sure if this patch can still fix the original bug that you
> are trying to solve, although it will certainly be harder to trigger.
> 

> If you are using the get_cpu() number for passing down the samples,
> it is probably safe because you then can't add anything else to the
> same buffer from a different CPU or from an interrupt, but I don't
> understand enough about oprofile to be sure about that.

Thinking about this more and re-examining the code we may have an issue.
In the oprofile code, the routines that add data to a cpu buffer are
such that only the CPU can add a value to its CPU buffer.  Again only
the CPU can move the contents of its buffer to the kernel buffer while
holding the mutex lock.  The mutex lock ensures that the CPU can add
everything in its buffer without conflicts with other CPUs.  Since we
are in an interrupt context, we can be assured that the CPU will execute
the entire sequence of oprofile_add_value() calls in the code above
before it could go off and try to sync the CPU buffer to the kernel
buffer. This ensures the sequences stay intact.  However, the code does
violate the principle that a CPU only manipulates its buffer.  

When the trace buffer is read, each 128 bit entry contains the 16 bit
SPU PC for each of the eight SPUs on the node.  Secondly, we really want
to keep the timing of the context switches and storing the SPU PC values
as close as possible.  Clearly there is some noise as the switch will
occur while the trace buffer is filling.  Storing the all of the SPU PC
values, into the current CPU buffer causes two issues.  One is that one
of the buffers will be much fuller then the rest increasing the
probability of overflowing the CPU buffer and dropping data.  As it is,
in user land, I have to increase the size of the CPU buffers to
accommodate four SPUs worth of data in a given CPU buffer.  Secondly,
the SPU context switch info for a given SPU would be going to a
different CPU buffer then the data.  Depending on the timing of the CPU
buffer syncs to the kernel buffer you might get the trace buffer emptied
multiple times before an SPU context switch event was sync'd to the
kernel buffer. Thus causing undesired additional skew in the data.

The attempt in this patch was to leverage the code for the per cpu
buffers so we would not have to grab the buffer_mutex lock from the
module.  The approach was to follow to the way the CPU values are stored
as much as possible.  It doesn't look like we can make the per cpu
approach work because we have to process all of the SPU data at the same
time.  Also, there is no guarantee which CPU will process the SPU
context switch notification.   Perhaps, the oprofile_add_value needs to
put the values directly into the kernel buffer skipping the CPU buffers
all together. 

Any thoughts about moving oprofile_add_value() to buffer_sync.c and
having it grab the buffer_mutex lock while it inserts values directly
into the kernel buffer?  At the moment it looks the easiest.  

I can see a few other solutions but they involve creating per SPU arrays
for initially storing the switch info and SPU data and then having each
CPU flush a subset of the SPU data to its CPU buffer.  A lot more
storage and overhead we want.


> 
> > -	spin_lock_irqsave(&buffer_lock, flags);
> > -	add_event_entry(ESCAPE_CODE);
> > -	add_event_entry(SPU_PROFILING_CODE);
> > -	add_event_entry(num_spu_nodes);
> > -	spin_unlock_irqrestore(&buffer_lock, flags);
> > +	/* The SPU_PROFILING_CODE escape sequence must proceed
> > +	 * the SPU context switch info.
> > +	 */
> > +	for_each_online_cpu(cpu) {
> > +		oprofile_add_value(ESCAPE_CODE, cpu);
> > +		oprofile_add_value(SPU_PROFILING_CODE, cpu);
> > +		oprofile_add_value((unsigned long int)
> > +					    num_spu_nodes, cpu);
> > +	}
> >  
> 
> You are no longer holding a lock while adding the events, which
> may be correct as long as no switch_events come in, but it's
> still inconsistent. Do you mind just adding the spinlock here
> as well?
> 

The claim is that the lock is not needed because we have not yet
registered for notification of the context switches as mentioned above.
Hence there is no race to worry about.  Registration for the switch
event notification happens right after this loop.  

> > @@ -452,31 +464,38 @@ void spu_sync_buffer(int spu_num, unsign
> >  			break;
> >  		}
> >  
> > -		add_event_entry(file_offset | spu_num_shifted);
> > +		/* We must ensure that the SPU context switch has been written
> > +		 * out before samples for the SPU.  Otherwise, the SPU context
> > +		 * information is not available and the postprocessing of the
> > +		 * SPU PC will fail with no available anonymous map information.
> > +		 */
> > +		if (spu_ctx_sw_seen[spu_num])
> > +			oprofile_add_value((file_offset | spu_num_shifted),
> > +						    (spu_num >> 2));
> 
> Again, I think this should just be added on the local CPU, as 'spu_num >> 2'
> may not be a valid CPU number.
> 
> 	Arnd <><

