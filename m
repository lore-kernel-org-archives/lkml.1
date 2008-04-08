Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYDHUX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYDHUX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYDHUXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:23:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34602 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbYDHUXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:23:38 -0400
Subject: Re: [Cbe-oss-dev] [PATCH] Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200804040838.40179.arnd@arndb.de>
References: <1206460727.7132.232.camel@carll-linux-desktop>
	 <1207154567.7132.396.camel@carll-linux-desktop>
	 <1207155775.7132.414.camel@carll-linux-desktop>
	 <200804040838.40179.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 13:21:56 -0700
Message-Id: <1207686116.4734.9.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 08:38 +0200, Arnd Bergmann wrote: 
> On Wednesday 02 April 2008, Carl Love wrote:
> > On Wed, 2008-04-02 at 07:21 +0200, Arnd Bergmann wrote:
> > > On Tuesday 25 March 2008, Carl Love wrote:
> > > > This patch fixes a bug in the code that records the SPU data and
> > > > context switches.  The buffer_mutex lock must be held when the
> > > > kernel is adding data to the buffer between the kernel and the
> > > > OProfile daemon.  The lock is not being held in the current code
> > > > base.  This patch fixes the bug using work queues.  The data to 
> > > > be passed to the daemon is caputured by the interrupt handler.  
> > > > The workqueue function is invoked to grab the buffer_mutex lock
> > > > and add the data to the buffer.  
> > > 
> > > So what was the exact bug you're fixing with this? There was no
> > > buffer_mutex before, so why do you need it now? Can't this be a
> > > spinlock so you can get it from interrupt context instead of
> > > using a workqueue?
> > 
> > The generic OProfile code defines a mutex lock, called buffer_mutex, to
> > protect the kernel/daemon data buffer from being writen by the kernal
> > and simultaneously read by the Daemon.  When adding a PPU sample the
> > oprofile routine  oprofile_add_ext_sample(pc, regs, i, is_kernel) is
> > called from the interrupt context to request the sample be stored.  The
> > generic oprofile code takes care of passing the data to a non interrupt
> > context where the mutex lock is held and the necessary sequence of data
> > is written into the kernel/daemon data buffer.  However, OProfile does
> > not have any built in functions for handling the SPU.  Hence, we have to
> > implement the code to capture the data in the interrupt context, pass it
> > to a non interrupt context and put it into the buffer.  This was not
> > done correctly in the original implementation.  Specifically, the mutex
> > lock was not being held.  
> 
> Ok, I see.
> 
> However, I'm pretty sure that the switch notification does not get
> called from an atomic context, so you don't need a workqueue for
> bringing that into a process context. Doing the context switch
> notification directly from the scheduler sounds much better regarding
> the impact on the measurement.

Our first thought to fix the bug was to just grab the mutex lock when
adding the switch notification data to the queue.  The kernel gives us
an oops message saying something along the line of "could not call mutex
lock in interrupt context".  Hence we had to go to work queues so we
could access the lock outside of the SPU switch notification context.

Secondly, it is my understanding that if the schedule_work() call tries
to queue the same work function multiple times the subsequent requests
are dropped.  Thus we were not able to pass the context switch data as
part of the schedule work requests.  This forced us to have an array to
store the data for each SPU.   
> 
> > > Never put extern statements in the implementation, they describe the
> > > interface between two parts of the code and should be inside of a
> > > common header.
> > > 
> > > Why do you want to have your own workqueue instead of using the
> > > global one?
> > 
> > It is important that the data get context switch data get recorded as
> > quickly as possible to avoid dropping data unnecessarily.  The PC
> > counter data for each SPU is ignored until the context switch record is
> > put into the kernel/daemon buffer.  The API documentation says that
> > using a private workqueue has better performance then using the global
> > workqueue.  There is a comment in the code about this, perhaps it is not
> > clear enough.
> 
> This sounds like an unrelated bug in the implementation. The PC
> data should *not* be ignored in any case. As long as the records
> get stored in the right order, everything should be fine here.

Until the OProfile sees the context switch record, it does not know what
to do with the PC samples and just drops them.  The thought was using a
private work queue might help get the context switch records processed a
little earlier.  It probably doesn't make that much difference.  I can
just use the generic work queue.  
> 
> 
> > > This looks like you want to use a delayed_work rather than building your
> > > own out of hrtimer and work. Is there any point why you want to use
> > > an hrtimer?
> > 
> > The current implementation uses the hrtimer to schedule when to read the
> > trace buffer the next time.  This patch does not change how the
> > scheduling of the buffer reads is done.  Yes, you could change the
> > implementation to use workqueues instead.  If you feel that it is better
> > to use the workqueue then we could make that change.  Not sure that
> > making that change in this bug fix patch is appropriate.  I would need
> > to create a second patch for that change.
> 
> I would guess that the change from hrtimer to delayed_workqueue is
> smaller than the current patch changing from hrtimer to hrtimer plus
> workqueue, so I would prefer to have only one changeset.
> 
> Since the timer only causes statistical data collection anyway, delaying
> it a bit should not have any negative effect on the accuracy of the
> measurement, unlike delaying the context switch notification.

The goal is to be able to support very high sampling rates (small
periods).  The schedule_delayed_work() is based on jiffies which I
believe is 1/250 for this machine.  This only gives millisecond
resolution.  The goal is for the users to be able to specify a time
period of 60,000 cycles or less then 20 micro second sampling periods
when the real high resolution timers are available.  We can't achieve
the desired sampling rates with the schedule_dealyed_work() function.

> 
> > > > -static DEFINE_SPINLOCK(buffer_lock);
> > > > +extern struct mutex buffer_mutex;
> > > > +extern struct workqueue_struct *oprofile_spu_wq;
> > > > +extern int calls_to_record_switch;
> > > > +
> > > 
> > > Again, public interfaces need to go to a header file, and should
> > > have a name that identifies the interface. "buffer_mutex" is
> > > certainly not a suitable name for a kernel-wide global variable!
> > 
> > As stated earlier, the generic OProfile code defines the variable
> > "buffer_mutex".  Changing the name in the generic OProfile code is
> > beyond the scope of this patch.
> 
> Ok, didn't see that the name was already part of the main oprofile
> driver. However, this makes it even worse: you are accessing data
> structures that are clearly not meant to be shared with architecture
> code. The fact that it was not declared in a global header file should
> have told you that.
> 
> I think you should instead add a function to drivers/oprofile/buffer_sync.c
> that takes care of moving the data to the common buffer under the right
> mutex_lock.


Oprofile provides nice clean interfaces for recording kernel/user
switches and CPU data recording.  This is all that was needed by any
architecture until CELL came along. With CELL, we now have need to add
processor data plus SPU data to the queue.  The buffer_mutex variable
and the add_event_entry() were not visible outside of the OProfile
driver code.  The original SPU support added add_event_entry() to the
include/linux/oprofile.h file.  We can add the buffer_mutex as well
since there is now a need to access both of these.  

I have been looking to see how I could create a generic oprofile routine
which could take the data.  The routine would still have to work from an
interrupt context, so it will need to store the data and call a work
queue function.  The function would need to know how much data will be
needed, thus you would probably need to statically allocate data or use
a list and malloc the data as needed.  I don't really want to have to
malloc data from an interrupt context.  List management adds additional
overhead.  It would be possible to have an init function that you could
call at startup time telling it how much memory you need, in this case
we could allocate a buffer the size of spu_info (defined below) at
startup time.  The call could pass an array to the OProfile routine that
would put the data into the buffer and call the work function.  We still
have to allocate the storage, it does clean up the arch specific code.
Not sure if this really buys us much.  There is more copying of data
i.e. more overhead.  Not convinced the OProfile maintainers would accept
anything I have thought of so far.

Any suggestions?

> 
> > > 
> > > >  static DEFINE_SPINLOCK(cache_lock);
> > > >  static int num_spu_nodes;
> > > > +
> > > >  int spu_prof_num_nodes;
> > > >  int last_guard_val[MAX_NUMNODES * 8];
> > > > +int cnt_swtch_processed_flag[MAX_NUMNODES * 8];
> > > > +
> > > > +struct spus_profiling_code_data_s {
> > > > +	int num_spu_nodes;
> > > > +	struct work_struct spu_prof_code_wq;
> > > > +} spus_profiling_code_data;
> > > > +
> > > > +struct spu_context_switch_data_s {
> > > > +	struct spu *spu;
> > > > +	unsigned long spu_cookie;
> > > > +	unsigned long app_dcookie;
> > > > +	unsigned int offset;
> > > > +	unsigned long objectId;
> > > > +	int valid_entry;
> > > > +} spu_context_switch_data;
> > > 
> > > I don't understand what these variables are really doing, but
> > > having e.g. just one spu_context_switch_data for all the SPUs
> > > doesn't seem to make much sense. What happens when two SPUs do
> > > a context switch at the same time?
> > 
> > This is the data same data that was being put into the event buffer
> > directly from the interrupt context.  We need to store the data that is
> > only available in the interrupt context so the same data can be put into
> > the buffer by the work queue function in the non interrupt context.
> > This is the declaration of the data needed per SPU.  Below in the
> > spu_cntx_sw_data structure, we declare an array of entries so we can
> > store the switch data on a per SPU basis as you alluded to.  
> 
> The spu_context_switch_data and spus_profiling_code_data variables
> are also unused, or just write-only. They look like they were left
> over after a conversion from a typedef.

The spu_context_switch_data structure is the type of the array used in
struct spus_cntxt_sw_data_s which is the data used by the work queue.

Yes, spus_profiling_code_data seems to be unused.

> 
> > The calls_to_record_switch variable is not used, my mistake for not
> > getting it out of the patch.  The record_spu_stat_flag is used. It is
> > set in the spu_sync_start when SPU profiling is started.  The first time
> > the work function is called to record SPU context switches it sees the
> > flag is set and writes the initial record to the daemon/kernel buffer
> > stating that this is an SPU profile run not a PPU profile run.  The
> > daemon needs to know this as it effects how the postprocessing is done.
> > The initial record is only written once.  
> > 
> > The spus_context_sw_data structure has the array per SPU for all of the
> > interrupt context data that was recorded and needs to be written to the
> > kernel/daemon buffer.  
> 
> An ideal driver should not have *any* global variables at all, but store
> all data in the (reference counted) objects it is dealing with, or
> just on the stack while it's processing the data.
> 
> Storing the context switch information in a global breaks down as soon
> as there are multiple context switches taking place for a single
> SPU without the workqueue running in between, which is a very likely
> scenario if you have high-priority tasks on the SPU.

Yes, it was recognized that we could overwrite data.  The expectation is
that the workqueue function will run fairly quickly.  If the SPU context
was only loaded for a very short period of time at most a few samples
would be captured for that frame so the error would be down in the
noise.  OProfile is a statistical tool.  If we don't get enough samples
for the spu context, then the data is not statistically valid.  Losing
the context switch is not an issue.  The context must be loaded long
enough that we collect a reasonable number of samples for the output to
be meaningful.  

> 
> > > >  /* Container for caching information about an active SPU task. */
> > > >  struct cached_info {
> > > > @@ -44,6 +73,8 @@ struct cached_info {
> > > >  	struct kref cache_ref;
> > > >  };
> > > >  
> > > > +struct workqueue_struct *oprofile_spu_wq;
> > > > +
> > > >  static struct cached_info *spu_info[MAX_NUMNODES * 8];
> > > 
> > > While you're cleaning this up, I guess the cached_info should
> > > be moved into a pointer from struct spu as well, instead of
> > > having this global variable here.
> >
> > This would be a functional change and it belongs in a functional change
> > patch not in a bug fix patch.
> 
> The patch is already far bigger than a simple bug fix, but you're right
> in that this part should be separate. Upon reading through the code
> again, I noticed that the cached_info is thrown away on each context
> switch and rebuilt, which I guess makes it impossible to really profile
> the context switch code. In the initial design phase for spu oprofile, we
> decided that the information should be cached in the spu_context, which
> would not only be much cleaner but also avoid the performance problem.
> 
> Do you have any idea why this idea was dropped? Is it still work in
> progress to get that functionality right?

It was not dropped.  It was implemented.  The issue that I have is the
dcookie spu_cookie, app_dcookie, offset, objectId is not included in the
local cahced spu context data.  Previously, there was no need to save it
since it was being immediatly written to oprofile buffer (without
holding the mutex lock).  Now we need to store the data until the
workqueue function runs.  We can store it in the array as I have done or
you could put it in the spu context.  Functionally, it doesn't change
anything.  The data in the SPU context would get overwritten, just as it
does in the array, if there was an SPU context switch before the
workqueue function runs so that doesn't solve that issue.

> 
> > > I would guess that you need one work struct per SPU instead of a global
> > > one, if you want to pass the SPU pointer as an argument.
> > 
> > We only need one work struct because we have an array that contains the
> > data for each SPU that has done a context switch.  
> 
> right, but as I explained, the global array is the real problem that should
> be fixed.
> 
> 	Arnd <><

