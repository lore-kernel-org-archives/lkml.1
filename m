Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYDDGjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYDDGjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYDDGix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:38:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:65517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYDDGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:38:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH] Cell OProfile: SPU mutex lock fix
Date: Fri, 4 Apr 2008 08:38:39 +0200
User-Agent: KMail/1.9.9
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <1206460727.7132.232.camel@carll-linux-desktop> <1207154567.7132.396.camel@carll-linux-desktop> <1207155775.7132.414.camel@carll-linux-desktop>
In-Reply-To: <1207155775.7132.414.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804040838.40179.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DJOuOOPQlkQKOAiXRbGHGtTKVZEsOxcnblOd
 nXg1Ms0cBXYoH9EYKeciB7A38/OEIQpGVNQU9/sB0udoV+OMDK
 6w/FeUGpADDf+lVvHc4xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Carl Love wrote:
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

Ok, I see.

However, I'm pretty sure that the switch notification does not get
called from an atomic context, so you don't need a workqueue for
bringing that into a process context. Doing the context switch
notification directly from the scheduler sounds much better regarding
the impact on the measurement.

> > Never put extern statements in the implementation, they describe the
> > interface between two parts of the code and should be inside of a
> > common header.
> > 
> > Why do you want to have your own workqueue instead of using the
> > global one?
> 
> It is important that the data get context switch data get recorded as
> quickly as possible to avoid dropping data unnecessarily.  The PC
> counter data for each SPU is ignored until the context switch record is
> put into the kernel/daemon buffer.  The API documentation says that
> using a private workqueue has better performance then using the global
> workqueue.  There is a comment in the code about this, perhaps it is not
> clear enough.

This sounds like an unrelated bug in the implementation. The PC
data should *not* be ignored in any case. As long as the records
get stored in the right order, everything should be fine here.


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

I would guess that the change from hrtimer to delayed_workqueue is
smaller than the current patch changing from hrtimer to hrtimer plus
workqueue, so I would prefer to have only one changeset.

Since the timer only causes statistical data collection anyway, delaying
it a bit should not have any negative effect on the accuracy of the
measurement, unlike delaying the context switch notification.

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

Ok, didn't see that the name was already part of the main oprofile
driver. However, this makes it even worse: you are accessing data
structures that are clearly not meant to be shared with architecture
code. The fact that it was not declared in a global header file should
have told you that.

I think you should instead add a function to drivers/oprofile/buffer_sync.c
that takes care of moving the data to the common buffer under the right
mutex_lock.

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
> store the switch data on a per SPU basis as you alluded to.  

The spu_context_switch_data and spus_profiling_code_data variables
are also unused, or just write-only. They look like they were left
over after a conversion from a typedef.

> The calls_to_record_switch variable is not used, my mistake for not
> getting it out of the patch.  The record_spu_stat_flag is used. It is
> set in the spu_sync_start when SPU profiling is started.  The first time
> the work function is called to record SPU context switches it sees the
> flag is set and writes the initial record to the daemon/kernel buffer
> stating that this is an SPU profile run not a PPU profile run.  The
> daemon needs to know this as it effects how the postprocessing is done.
> The initial record is only written once.  
> 
> The spus_context_sw_data structure has the array per SPU for all of the
> interrupt context data that was recorded and needs to be written to the
> kernel/daemon buffer.  

An ideal driver should not have *any* global variables at all, but store
all data in the (reference counted) objects it is dealing with, or
just on the stack while it's processing the data.

Storing the context switch information in a global breaks down as soon
as there are multiple context switches taking place for a single
SPU without the workqueue running in between, which is a very likely
scenario if you have high-priority tasks on the SPU.

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
>
> This would be a functional change and it belongs in a functional change
> patch not in a bug fix patch.

The patch is already far bigger than a simple bug fix, but you're right
in that this part should be separate. Upon reading through the code
again, I noticed that the cached_info is thrown away on each context
switch and rebuilt, which I guess makes it impossible to really profile
the context switch code. In the initial design phase for spu oprofile, we
decided that the information should be cached in the spu_context, which
would not only be much cleaner but also avoid the performance problem.

Do you have any idea why this idea was dropped? Is it still work in
progress to get that functionality right?

> > I would guess that you need one work struct per SPU instead of a global
> > one, if you want to pass the SPU pointer as an argument.
> 
> We only need one work struct because we have an array that contains the
> data for each SPU that has done a context switch.  

right, but as I explained, the global array is the real problem that should
be fixed.

	Arnd <><
