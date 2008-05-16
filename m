Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYEPQ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYEPQ1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYEPQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:27:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59055 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYEPQ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:27:26 -0400
Subject: Re: [PATCH] Updated: Reworked Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <200805161622.46232.arnd@arndb.de>
References: <1209652994.17842.1.camel@carll-linux-desktop>
	 <200805151739.26392.arnd@arndb.de>
	 <1210878305.20791.109.camel@carll-linux-desktop>
	 <200805161622.46232.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 16 May 2008 09:24:55 -0700
Message-Id: <1210955095.20791.187.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-16 at 16:22 +0200, Arnd Bergmann wrote:
> On Thursday 15 May 2008, Carl Love wrote:
> > On Thu, 2008-05-15 at 17:39 +0200, Arnd Bergmann wrote:
> > > 
> > > I noticed now that you are indexing arrays by SPU number. This is not
> > > a good idea, because you make assumptions about the system that may
> > > not be true. Better pass around 'struct spu' pointers and put those
> > > values in there if you need them. 
> > 
> > Hmm, well, we have arrays for last_guard_val[], spu_info[] as well that
> > are indexed by spu number.  So this would seem to be a more general
> > issue then just spu_ctx_seen[].  Not sure exactly what you are
> > suggesting with passing around 'struct spu' as a solution.  Are you
> > suggesting that a field be added to the structure for the spu context
> > seen flag?  Not sure that is a good idea.  We will need to clarify how
> > you propose to fix this not only for spu_ctx_sw_seen but the other
> > arrays as well that are already being indexed by spu number.
> 
> I'd suggest you add fields to struct spu, either directly to it, if
> it's short, or a pointer to your own struct.
> 
> As I said, let's not do that now.
> 
> >                                                 So, you can either add
> > a context switch sequence to a given CPU buffer or you can add an SPU
> > program counter to the CPU buffer not both at the same time.  The lock
> > is held until the entire SPU context switch entry is added to the CPU
> > queue to make sure entries are not intermingled.
> 
> My point was that oprofile collecting samples for the CPU could possibly
> add entries to the same queue, which would race with this.

Ah, I see what you are getting at.  That we would be collecting
profiling data on a a CPU (i.e. a PPU thread) and SPU cycle profiling
data at the same time.  No, due to hardware constraints on SPU cycle
profiling, the hardware cannot be configured to do both PPU profiling
and SPU CYCLE profiling at a time. 

I am working on SPU event profiling. The hardware will only support
event profiling on one SPU per node at a time. I will have to think
about it more but my initial thought is supporting PPU profiling and SPU
event profiling will again not work due to hardware constraints.  

> 
> > When the trace buffer is read, each 128 bit entry contains the 16 bit
> > SPU PC for each of the eight SPUs on the node.  Secondly, we really want
> > to keep the timing of the context switches and storing the SPU PC values
> > as close as possible.  Clearly there is some noise as the switch will
> > occur while the trace buffer is filling.
> 
> can't you just empty the trace buffer every time you encounter a context
> switch, even in the absence of a timer interrupt? That would prevent
> all of the noise.

That is a good thought.  It should help to keep the timing more accurate
and prevent the issue mentioned below about processing multiple trace
buffers of data before processing the context switch info.
> 
> > Storing the all of the SPU PC 
> > values, into the current CPU buffer causes two issues.  One is that one
> > of the buffers will be much fuller then the rest increasing the
> > probability of overflowing the CPU buffer and dropping data.  As it is,
> > in user land, I have to increase the size of the CPU buffers to
> > accommodate four SPUs worth of data in a given CPU buffer.  Secondly,
> > the SPU context switch info for a given SPU would be going to a
> > different CPU buffer then the data. 
> 
> In practice, the calling CPUs should be well spread around by the way
> that spufs works, so I don't think it's a big problem.
> Did you observe this problem, or just expect it to happen?

I did see the problem initially.  The first version of
oprofile_add_value() did not take the CPU buffer argument.  Rather
internally the oprofile_add_value() stored the data to the current CPU
buffer by calling smp_processor_id().  When processing the trace buffer,
the function would extract the PC value for each of the 8 SPUs on the
node, then store them in the current CPU buffer.  It would do this for
all of the samples in the trace buffer, typically about 250 (Maximum is
1024).  So you would put 8 * 350 samples all into the same CPU buffer
and nothing in the other CPU buffers for that node.  In order to ensure
I don't drop any samples, I had to increase the size of each CPU buffer
more then when I distribute them to the two CPU buffers in each node.  I
changed the oprofile_add_value() to take a CPU buffer to better utilize
the CPU buffers and to avoid the ordering issue with the SPU context
switch data.  I didn't do a detailed study to see exactly how much more
the CPU buffer size needed to be increased as the SPU context switch
ordering was the primary issue I was trying to fix.  The default CPU
buffer size must be increased because four processors (SPUS) worth of
data is being stored in each CPU buffer and each entry takes two
locations to store (the special escape code, then the actual data).  
> 
> > Depending on the timing of the CPU 
> > buffer syncs to the kernel buffer you might get the trace buffer emptied
> > multiple times before an SPU context switch event was sync'd to the
> > kernel buffer. Thus causing undesired additional skew in the data.
> 
> good point. would this also get solved if you flush the trace buffer
> on a context switch? I suppose you need to make sure that the samples
> still end up ordered correctly throughout the CPU buffers. Is that
> possible?

Yes, this would be avoided by processing the trace buffer on a context
switch.  We have the added benefit that it should help minimize the skew
between the data collection and context switch information.
> 
> > Any thoughts about moving oprofile_add_value() to buffer_sync.c and
> > having it grab the buffer_mutex lock while it inserts values directly
> > into the kernel buffer?  At the moment it looks the easiest.  
> 
> That would mean that again you can't call it from interrupt context,
> which is the problem you were trying to solve with the work queue
> in the previous version of your patch.

Yes, forgot about that little detail, again.  Argh!  
> 
> > I can see a few other solutions but they involve creating per SPU arrays
> > for initially storing the switch info and SPU data and then having each
> > CPU flush a subset of the SPU data to its CPU buffer.  A lot more
> > storage and overhead we want.
> 
> It might work if you do a per SPU buffer and generalize the way
> that per-CPU buffers are flushed to the kernel buffer so it works
> with either one.

If we flush on SPU context switches, we are just left with how best to
manage storing the data.  I see two choice, allocating more memory so we
can store data into a per SPU buffer then figure out how to flush the
data to the kernel buffer.  Or just increase the per cpu buffer size so
we can store all of the nodes SPU data into a single CPU buffer.  Either
way we use more memory.  In the first approach, I would need to allocate
SPU arrays large enough to store data for the worst case, the trace
buffer was full.  This would be 8*1024 entries.  Typically only a 1/3
would be needed as the hrtimer is setup to go off at about a 1/3 full.
This gives some buffer in case it takes time to get the timer function
call scheduled.  The second case doubling the size of the per cpu
buffers to handle the typical case of the trace buffer being 1/3 full
would correspond to allocating an additional 2*1024/3 = 682 entries.
This would be less memory then for the first approach and be simpler to
implement.

Given the code, it would be easy to measure what the minimum number of
buffers needed is with the current patch that spreads the entries evenly
across all of the buffers.  Then it is just a one line hack to put the
data all into the current CPU.  Then re-tune to find the minimum number
of CPU buffers.  I will do the experiments as I might be helpful to see
what the memory cost would be.

> 
> > > > +	/* The SPU_PROFILING_CODE escape sequence must proceed
> > > > +	 * the SPU context switch info.
> > > > +	 */
> > > > +	for_each_online_cpu(cpu) {
> > > > +		oprofile_add_value(ESCAPE_CODE, cpu);
> > > > +		oprofile_add_value(SPU_PROFILING_CODE, cpu);
> > > > +		oprofile_add_value((unsigned long int)
> > > > +					    num_spu_nodes, cpu);
> > > > +	}
> > > >  
> > > 
> > > You are no longer holding a lock while adding the events, which
> > > may be correct as long as no switch_events come in, but it's
> > > still inconsistent. Do you mind just adding the spinlock here
> > > as well?
> > > 
> > 
> > The claim is that the lock is not needed because we have not yet
> > registered for notification of the context switches as mentioned above.
> > Hence there is no race to worry about.  Registration for the switch
> > event notification happens right after this loop.  
> 
> Right, that's what I understood as well. My point was that it's more
> consistent if you always call the function with the same locks held,
> in case somebody changes or tries to understand your code.

Yup, not a big deal. I had thought about doing it for completeness sake
but then opted not to figuring I would get dinged for unnecessarily
grabbing a lock and doing extra work.  I will put it in.  That is what I
get for trying to second guess the reviewers.   :-)

>  	
> 	Arnd <><

