Return-Path: <linux-kernel-owner+w=401wt.eu-S933341AbXAaXKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbXAaXKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbXAaXKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:10:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51114 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbXAaXK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:10:27 -0500
Date: Wed, 31 Jan 2007 15:10:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070131231017.GA2995@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070126112837.059502fc.akpm@osdl.org> <20070130073340.GC30160@elte.hu> <20070130160244.GB2092@linux.vnet.ibm.com> <200701301744.48601.rjw@sisk.pl> <20070130102718.f03f37d8.akpm@osdl.org> <20070130194940.GI2092@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130194940.GI2092@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 11:49:40AM -0800, Paul E. McKenney wrote:
> On Tue, Jan 30, 2007 at 10:27:18AM -0800, Andrew Morton wrote:
> > On Tue, 30 Jan 2007 17:44:47 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > > > code, processes marked PF_NOFREEZE will continue running, potentially
> > > > interfering with the hotplug operation.  :-(
> > > > 
> > > > I will pass my findings on to this list.
> > > 
> > > Well, I did it some time ago, although not very thoroughly.
> > > 
> > > AFAICS there are not so many, but one that stands out is the worker threads.
> > > We needed two of them to actually go to sleep, so now it's possible to create
> > > a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> > > but currently this is only used by XFS.
> > 
> > Or we can create a variant of freeze_processes which ignores PF_NOFREEZE.
> > 
> > As I said eariler, we might need to change the freezer code for this
> > application.  In fact we should do so: that sys_sync() call in there is
> > quite inappropriate, as is, I suppose, the two-pass freeze attempt.  As are
> > the nice printks, come to that.
> > 
> > Pretty simple stuff though.
> 
> And we might need to change some of the processes that currently set
> PF_NOFREEZE so that they periodically go somewhere that the freezer can
> find them -- if I remember correctly, at least some of the PF_NOFREEZE
> tasks were so marked in order to prevent suspend hangs.
> 
> Part of what I need to look at.  ;-)

OK.  This just might be feasible.  That said, there is a lot of code
containing PF_NOFREEZE that I am not familiar with.  That said, here
are my thoughts -- this is in addition to the changes to freeze_processes()
and thaw_processes() called out earlier.

Thoughts?

							Thanx, Paul

Proposal:

o	Add a new task_struct field pf_exempt or some such.
	This would be a bitfield:

	#define PFE_SUSPEND 0x0001
	#define PFE_KPROBES 0x0002
	#define PFE_HOTPLUG 0x0004

	There would be no tasks specifying PFE_HOTPLUG, since everything
	needs to be frozen in that case.  But see below for use of this
	definition.

o	freeze_processes() takes an argument that says what kind of
	freezing is going on.  For example, freeze_processes(PFE_SUSPEND)
	would be appropriate for suspend.

o	freezeable() would take an additional PFE_* argument.
	Only processes matching the specified PFE_* would be exempt
	from freezing -- so CPU hotplug would do freeze_processes(0).
	Or better yet, use a PFE_THIS_MEANS_YOU that is defined to 0.
	(OK, OK, PFE_ALL!!!)

	Presumably we only allow one freeze_processes() to run at a
	time (though I don't see anything preventing concurrent
	freezing!), so that thaw_processes() just uses whatever was
	passed to the matching freeze_processes().

o	Introduce a mutex to prevent overlapping freezes -- or find
	out what the heck prevents them at present!!!  (I don't see
	anything.)  Keep in mind that CPU hotplug might be script
	driven ("this CPU is getting ECC errors in its cache, time to
	shut it down!").

	Acquire the mutex in freeze_processes(), release in thaw_processes().

o	Replace all the "current->flags |= PF_NOFREEZE" statements with
	"exempt_from_freeze(current, int pfe)" or some such.  This would
	set the flags bit and also store the pfe argument into the pf_exempt
	field.


Results of inspection -- skepticism advised, but here it is:

o	arch/arm/kernel/apm.c line 308 apm_ioctl().
	Specific to suspend.  Restores flags after suspend-wait
	complete.

	Perhaps have different types of NOFREEZE in a separate bitmask.

o	arch/arm/kernel/apm.c line 526 apm_init()
	Manages the kapmd thread -- seems specific to suspend.
	Module-init function.

o	arch/i386/kernel/apm.c line 2352 apm_init()
	Manages the kapmd thread for i386, also seems specific to suspend.
	Module-init function.

o	arch/mips/kernel/apm.c line 308 apm_ioctl().  Similar to
	arch/arm/kernel/apm.c above.

o	arch/mips/kernel/apm.c line 472 kapmd().  Seems specific to
	suspend.

o	arch/sh/kernel/apm.c line 314 apm_ioctl().  Similar to
	arch/arm/kernel/apm.c above.

o	arch/sh/kernel/apm.c line 455 kapmd().  Similar to mips version.

o	drivers/block/loop.c line 589 loop_thread().  Prevent loop
	driver from being stalled on suspension (might be needed for 
	encryption, they say...).  There is a wait_event_interruptible()
	on each request, so should be OK.

o	drivers/ieee1394/ieee1394_core.c line 1028 hpsbpkt_thread().
	Firewire packet processing.  Drains the queue, then hits
	schedule().  Could avoid schedule forever if there is a flood
	of firewire packets.  So probably need to add some sort of
	cond_resched() to the packet-processing loop.
 
o	drivers/md/md.c line 4489 md_thread().  Waits on each pass through the
	loop.  Wakes up other threads, so should be OK.

	Main concern would be if some other thread is waiting on
	a disk access, but in such a way that this other thread
	blocks freeze_processes().

o	drivers/mmc/mmc_queue.c line 68 mmc_queue_thread().  Seems
	specific to suspend.  It says that it handles suspension
	itself, but not clear to me how this happens.  MMC_QUEUE_EXIT?
	Doesn't seem likely.  Maybe it just is sufficiently untrusting
	of the device state that it can tolerate random suspends?

o	drivers/mtd/mtd_blkdevs.c line 83 mtd_blktrans_thread().
	Again seems suspend-specific.

o	drivers/scsi/libsas/sas_scsi_host.c line 718 sas_queue_thread().
	This one is a bit bizarre.  One motivation seems to be to allow
	SAS processing to continue to happen during suspend processing,
	but this one seems to run only when a queue is shut down.

	So at first glance appears to be specific to suspend, but not
	sure if it would avoid blocking freeze_processes() if not
	exempted from freeze.

o	drivers/scsi/scsi_error.c line 1500 scsi_error_handler().
	Again seems to be specific to suspend.  Looks like there
	are no indefinite code paths that avoid sleeping.

o	drivers/usb/storage/usb.c line 304 usb_stor_control_thread().
	Whoa!  This one doesn't seem to pay attention to
	kthread_should_stop()!  Or maybe it is doing so in some
	non-obvious way.

	Also appears to be for suspend (to USB memory stick).

o	init/do_mounts_initrd.c line 57 handle_initrd().
	This looks to be short term anyway, so OK to leave.
	But does kernel_execve() clear PF_NOFREEZE?

	But it should be OK to freeze the init process when doing CPU
	hotplug ops, right?

o	kernel/fork.c line 917 copy_flags().  This is -clearing-
	PF_NOFREEZE, so OK.

o	kernel/power/process.c line 26 freezeable().  This is just
	checking the flag.

	This will need to be augmented to check flags in some other
	task_struct field -- a bitfield that indicates what sort of
	freezing that this task is exempt from.  No task will be
	exempt from hotplug freezing.

o	kernel/softirq.c line 473 ksoftirqd().  Main concern here is
	that it might be necessary for ksoftirqd() to run in order
	for some unrelated process to find its way to the next
	try_to_freeze() or refrigerator() call.  Might be able to
	take care of such situations by adding try_to_freeze() or
	refrigerator() calls.  If they occur, of course.

o	kernel/softlockup.c line 88 watchdog().  Well, we wouldn't
	want false alarms when freezing for hotplug.  Perhaps
	temporarily disabling timestamp checking while doing hotplug
	would do the trick.  But if hotplug takes the time required
	to trigger softlockup (seconds!), we are broken anyway.
	The fix would be to speed up the freezing process.

o	kernel/workqueue.c line 240 worker_thread().  Same situation
	as for ksoftirqd().

o	net/bluetooth/bnep/core.c line 476 bnep_session().  Suspending
	to a bluetooth device???  These guys got -hair-!!!  I bet this
	one can tolerate being frozen for hotplugging CPUs -- though
	I could imagine the bluetooth protocol needing some TLC after
	such an event.  But I don't know enough about bluetooth to do
	more than raise the possibility.

o	net/bluetooth/cmtp/core.c line 290 cmtp_session().  Same as
	for bnep_session(), at least as far as I can tell.

o	net/bluetooth/hidp/core.c line 476 hidp_session().  Same as
	for bnep_session(), AFAICT.

o	net/bluetooth/rfcomm/core.c line 1940 rfcomm_run(). Same as
	for bnep_session(), AFAICT.

o	kernel/rcutorture.c -- no problem freezing, just need to make
	sure that these processes do try_to_freeze() occasionally.

Again, may need additional try_to_freeze() calls in various places.
