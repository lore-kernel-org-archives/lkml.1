Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYDICJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYDICJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 22:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDICIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 22:08:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYDICIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 22:08:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH] Cell OProfile: SPU mutex lock fix
Date: Wed, 9 Apr 2008 04:08:32 +0200
User-Agent: KMail/1.9.9
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <1206460727.7132.232.camel@carll-linux-desktop> <200804040838.40179.arnd@arndb.de> <1207686116.4734.9.camel@carll-linux-desktop>
In-Reply-To: <1207686116.4734.9.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090408.33427.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ERigQAyVQjEOQMBpwRk1dffJ+sX/0xwx8IQ4
 v74nculMVCK2d/qe6nVROaHzcUuGLC+yK963TVDRpCogHi+yf5
 oPSy4TlYn7PY09bwcjrCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008, Carl Love wrote:
> On Fri, 2008-04-04 at 08:38 +0200, Arnd Bergmann wrote: 
> Our first thought to fix the bug was to just grab the mutex lock when
> adding the switch notification data to the queue.  The kernel gives us
> an oops message saying something along the line of "could not call mutex
> lock in interrupt context".  Hence we had to go to work queues so we
> could access the lock outside of the SPU switch notification context.

By the time the notifier is called, the kernel is certainly not
in an atomic context. Maybe you were nesting the mutex lock inside
of your own spinlock?

> Secondly, it is my understanding that if the schedule_work() call tries
> to queue the same work function multiple times the subsequent requests
> are dropped.  Thus we were not able to pass the context switch data as
> part of the schedule work requests.  This forced us to have an array to
> store the data for each SPU.   

The way that work queues are designed, you embed the struct work in the
data you pass down, so that you are guaranteed to execute the work struct
exactly once per data element and you don't need any global pointers.

> > I would guess that the change from hrtimer to delayed_workqueue is
> > smaller than the current patch changing from hrtimer to hrtimer plus
> > workqueue, so I would prefer to have only one changeset.
> > 
> > Since the timer only causes statistical data collection anyway, delaying
> > it a bit should not have any negative effect on the accuracy of the
> > measurement, unlike delaying the context switch notification.
> 
> The goal is to be able to support very high sampling rates (small
> periods).  The schedule_delayed_work() is based on jiffies which I
> believe is 1/250 for this machine.  This only gives millisecond
> resolution.  The goal is for the users to be able to specify a time
> period of 60,000 cycles or less then 20 micro second sampling periods
> when the real high resolution timers are available.  We can't achieve
> the desired sampling rates with the schedule_dealyed_work() function.

You actually can't get anywhere close to that resolution if you do your
data collection in a work queue, because under high load (which is what
the only time when measuring really gets interesting) the work queue
is likely to be delayed by a few jiffies!

If you rely on high resolution timer precision, you need to look
at the performance counters from inside the timer function, and deal
with the problem of the work queue not being called for a number of
timer events.

> 
> Oprofile provides nice clean interfaces for recording kernel/user
> switches and CPU data recording.  This is all that was needed by any
> architecture until CELL came along. With CELL, we now have need to add
> processor data plus SPU data to the queue.  The buffer_mutex variable
> and the add_event_entry() were not visible outside of the OProfile
> driver code.  The original SPU support added add_event_entry() to the
> include/linux/oprofile.h file.  We can add the buffer_mutex as well
> since there is now a need to access both of these.  
> 
> I have been looking to see how I could create a generic oprofile routine
> which could take the data.  The routine would still have to work from an
> interrupt context, so it will need to store the data and call a work
> queue function.  The function would need to know how much data will be
> needed, thus you would probably need to statically allocate data or use
> a list and malloc the data as needed.  I don't really want to have to
> malloc data from an interrupt context.  List management adds additional
> overhead.  It would be possible to have an init function that you could
> call at startup time telling it how much memory you need, in this case
> we could allocate a buffer the size of spu_info (defined below) at
> startup time.  The call could pass an array to the OProfile routine that
> would put the data into the buffer and call the work function.  We still
> have to allocate the storage, it does clean up the arch specific code.
> Not sure if this really buys us much.  There is more copying of data
> i.e. more overhead.  Not convinced the OProfile maintainers would accept
> anything I have thought of so far.
> 
> Any suggestions?

My first attempt to do this would be to add this to the oprofile/cpu_buffer.c
infrastructure. Basically extend the add_sample() function to have
helpers you can call from the spu code to put entries into the per-cpu
buffer of the CPU that happens to execute the code at the time.

add_sample() can already be called from an atomic context since it uses
its own buffer, and it uses a clever ring buffer to get around the
need for locking against the event_buffer functions.
Only event_buffer needs the mutex, so it's best to leave that out
of the architecture code running at interrupt time altogether.

> > An ideal driver should not have *any* global variables at all, but store
> > all data in the (reference counted) objects it is dealing with, or
> > just on the stack while it's processing the data.
> > 
> > Storing the context switch information in a global breaks down as soon
> > as there are multiple context switches taking place for a single
> > SPU without the workqueue running in between, which is a very likely
> > scenario if you have high-priority tasks on the SPU.
> 
> Yes, it was recognized that we could overwrite data.  The expectation is
> that the workqueue function will run fairly quickly.  If the SPU context
> was only loaded for a very short period of time at most a few samples
> would be captured for that frame so the error would be down in the
> noise.  OProfile is a statistical tool.  If we don't get enough samples
> for the spu context, then the data is not statistically valid.  Losing
> the context switch is not an issue.  The context must be loaded long
> enough that we collect a reasonable number of samples for the output to
> be meaningful.  
 
Hmm, I wonder if you have a problem here when the context switch time
is not independent of the program you are analysing. Usually, context
switches happen when a program does a callback or syscall to the ppu
and the spu becomes idle. If you often lose events just after a context
switch, that means that the code that gets called after the context
is restored shows up in the profile as being called less often than
it actually is, right?

> > The patch is already far bigger than a simple bug fix, but you're right
> > in that this part should be separate. Upon reading through the code
> > again, I noticed that the cached_info is thrown away on each context
> > switch and rebuilt, which I guess makes it impossible to really profile
> > the context switch code. In the initial design phase for spu oprofile, we
> > decided that the information should be cached in the spu_context, which
> > would not only be much cleaner but also avoid the performance problem.
> > 
> > Do you have any idea why this idea was dropped? Is it still work in
> > progress to get that functionality right?
> 
> It was not dropped.  It was implemented.  The issue that I have is the
> dcookie spu_cookie, app_dcookie, offset, objectId is not included in the
> local cahced spu context data.  Previously, there was no need to save it
> since it was being immediatly written to oprofile buffer (without
> holding the mutex lock).  Now we need to store the data until the
> workqueue function runs.  We can store it in the array as I have done or
> you could put it in the spu context.  Functionally, it doesn't change
> anything.  The data in the SPU context would get overwritten, just as it
> does in the array, if there was an SPU context switch before the
> workqueue function runs so that doesn't solve that issue.

That's not what I meant. My point was that the information about the
location of overlays in the context remains constant over the contexts
life time. If you store it in the context, all the data will still
be there by the time you restore the context when it was switched
out and comes back.

	Arnd <><
