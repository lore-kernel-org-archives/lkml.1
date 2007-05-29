Return-Path: <linux-kernel-owner+w=401wt.eu-S1750937AbXE2WIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbXE2WIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXE2WIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:08:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXE2WH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:07:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Wed, 30 May 2007 00:13:13 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200705270012.59177.rjw@sisk.pl> <200705291415.31970.rjw@sisk.pl> <1180443572.20718.29.camel@nigel.suspend2.net>
In-Reply-To: <1180443572.20718.29.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300013.14750.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 14:59, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2007-05-29 at 14:15 +0200, Rafael J. Wysocki wrote:
> > Please have a look at the current version of the patch (appended).
> > 
> > I have followed the Nigel's suggestion not to change the current behavior
> > in this patch (I'll add a couple of patches removing the freezability from
> > some kernel threads), with one exception: I couldn't figure out any reason
> > to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .
> 
> Thanks. IIRC, svcsock is related to the NFS server code.
> 
> > I've also added a piece of documentation, freezing-of-tasks.txt .  Please
> > see if it's not missing anything (I'd like it to be quite complete).
> 
> [...]
> 
> Mostly just grammar and the odd typo. On the whole, it's really well
> written and perfectly readable - great job!

Thanks a lot for all of the comments, they are really helpful. :-)

> > Index: linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt
> > @@ -0,0 +1,160 @@
> > +Freezing of tasks
> > +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
> > +
> > +I. What is the freezing of tasks?
> > +
> > +The freezing of tasks is a mechanism by which user space processes and some
> > +kernel threads are controlled during hibernation or system-wide suspend (on some
> > +architectures).
> > +
> > +II. How it works?
> 
> How does it work?

Yup.

[--snip--]
> > +1. The principal reason is to prevent filesystems from being damaged after
> > +hibernation.  Namely, for now we have no simple means of checkpointing
> 
> s/Namely, for now/At the moment/
> 
> No simple means or no means at all? Are you thinking of bdev freezing?

No, of LVM snapshot functionality.

> > +filesystems, so if there are any modifications made to filesystem data and/or
> > +metadata on disks, we usually cannot bring them back to the state from before
> 
> If the above is changed, I'd remove 'usually' here.

Removed.

[-- Skipped some simple comments that have been followed --]
> > +Although Linus Torvalds doesn't like the freezing of tasks, he said this in one
> > +of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
> > +
> > +'> Why we freeze tasks at all or why we freeze kernel threads?
> > +
> > +In many ways, "at all".
> 
> I found these first two lines confusing - I though the "Why we
> freeze..." was Linus, rather than a quotation he was responding to. I'd
> suggest starting the quote at what follows this point... but then as I
> read further, I can see the quote is necessary to make sense of the
> second paragraph below. Perhaps the best way would to put a line before
> the "Why we freeze..." indicating that you're being quoted there.

Well, I've tried to make this a bit cleaner (please see the patch below).

> > +I _do_ realize the IO request queue issues, and that we cannot actually do
> > +s2ram with some devices in the middle of a DMA.  So we want to be able to
> > +avoid *that*, there's no question about that.  And I suspect that stopping
> > +user threads and then waiting for a sync is practically one of the easier
> > +ways to do so.
> > +
> > +So in practice, the "at all" may become a "why freeze kernel threads?" and
> > +freezing user threads I don't find really objectionable.'
> 
> Oh, and double quotes should surround the whole quote, with single
> quotes replacing the double quotes in the quotation. Hope all those
> 'quote's aren't confusing! :)

Fixed.

[-- Skipped some simple comments that have been followed --]
> > +Suppose, however, that the firmware file is located on a filesystem accessible
> > +only through the device that needs the firmware.  In that case, the system won't
> > +be able to work normally after the restore regardless of whether or not the
> > +freezing of tasks is used.  Consequently, the problem is not really related to
> > +the freezing of tasks, since it generally exists regardless.  [The solution to
> > +this particular problem is to keep the firmware in memory after it's loaded for
> > +the first time and upload if from memory to the device whenever necessary.]
> 
> I understand the logic and agree with that you're trying to say in this
> last example, but think the example is faulty. If the firmware is on a
> filesystem accessible only through the device that needs the firmware,
> then you wouldn't be able to bring it up in the first place.

Very true.  I've changed that in the updated patch (appended).

Thanks again,
Rafael


Hi,

On Tuesday, 29 May 2007 13:31, Pavel Machek wrote:
> Hi!
> 
> > > > Index: linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > > > ===================================================================
> > > > --- linux-2.6.22-rc3.orig/Documentation/power/kernel_threads.txt
> > > > +++ linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > > > @@ -1,13 +1,22 @@
> > > > -KERNEL THREADS
> > > > +The Freezer and Kernel Threads
> > > >  
> > > > -
> > > > -Freezer
> > > > -
> > > > -Upon entering a suspended state the system will freeze all
> > > > -tasks. This is done by delivering pseudosignals. This affects
> > > > -kernel threads, too. To successfully freeze a kernel thread
> > > > -the thread has to check for the pseudosignal and enter the
> > > > -refrigerator. Code to do this looks like this:
> > > > +Before entering a system-wide suspend state as well as before creating a
> > > > +hibernation snapshot image the system will freeze all tasks, which is done
> > > > +by delivering fake signals.  This affects kernel threads too, but they won't be
> > > > +frozen unless they declare that they want to.  For this purpose
> > > 
> > > Well... and unless thread that does disk writes or DMA _wants_ to, you
> > > have nice disk corruption... It should be pointed out that it is not
> > > voluntary for those types of threads.
> > 
> > Well, that really depends.
> > 
> > I think the only thing that must not be written to disk is filesystem stuff.
> > The other things (eg. writing directly to block devices etc.) doesn't hurt us.
> 
> Well.. it can write anywhere it wants (filesystem or not) as long as
> the system is not going to be confused after resume by its caches not
> matching on-disk state. I'd prefer it not to write anywhere at all.

OK

Please have a look at the current version of the patch (appended).

I have followed the Nigel's suggestion not to change the current behavior
in this patch (I'll add a couple of patches removing the freezability from
some kernel threads), with one exception: I couldn't figure out any reason
to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .

I've also added a piece of documentation, freezing-of-tasks.txt .  Please
see if it's not missing anything (I'd like it to be quite complete).

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
 Documentation/power/freezing-of-tasks.txt |  160 ++++++++++++++++++++++++++++++
 Documentation/power/kernel_threads.txt    |   40 -------
 Documentation/power/swsusp.txt            |   18 ---
 arch/i386/kernel/apm.c                    |    1 
 arch/i386/kernel/io_apic.c                |    1 
 drivers/block/loop.c                      |    7 -
 drivers/block/pktcdvd.c                   |    1 
 drivers/char/apm-emulation.c              |   11 --
 drivers/char/hvc_console.c                |    1 
 drivers/edac/edac_mc.c                    |    1 
 drivers/ieee1394/ieee1394_core.c          |    2 
 drivers/ieee1394/nodemgr.c                |    1 
 drivers/input/gameport/gameport.c         |    1 
 drivers/input/serio/serio.c               |    1 
 drivers/input/touchscreen/ucb1400_ts.c    |    1 
 drivers/macintosh/therm_adt746x.c         |    1 
 drivers/macintosh/windfarm_core.c         |    1 
 drivers/md/md.c                           |    1 
 drivers/media/dvb/dvb-core/dvb_frontend.c |    1 
 drivers/media/video/cx88/cx88-tvaudio.c   |    1 
 drivers/media/video/msp3400-kthreads.c    |    5 
 drivers/media/video/tvaudio.c             |    2 
 drivers/media/video/video-buf-dvb.c       |    1 
 drivers/media/video/vivi.c                |    1 
 drivers/mfd/ucb1x00-ts.c                  |    1 
 drivers/mmc/card/queue.c                  |    6 -
 drivers/mtd/mtd_blkdevs.c                 |    2 
 drivers/mtd/ubi/wl.c                      |    1 
 drivers/net/wireless/airo.c               |    3 
 drivers/net/wireless/libertas/main.c      |    1 
 drivers/pcmcia/cs.c                       |    1 
 drivers/pnp/pnpbios/core.c                |    1 
 drivers/scsi/libsas/sas_scsi_host.c       |    2 
 drivers/scsi/scsi_error.c                 |    2 
 drivers/usb/atm/ueagle-atm.c              |    1 
 drivers/usb/core/hub.c                    |    1 
 drivers/usb/gadget/file_storage.c         |    2 
 drivers/usb/storage/usb.c                 |    3 
 drivers/video/ps3fb.c                     |    1 
 drivers/w1/w1.c                           |    1 
 fs/cifs/cifsfs.c                          |    1 
 fs/cifs/connect.c                         |    1 
 fs/jffs2/background.c                     |    1 
 fs/lockd/svc.c                            |    2 
 fs/nfs/callback.c                         |    2 
 fs/nfsd/nfssvc.c                          |    2 
 fs/xfs/linux-2.6/xfs_super.c              |    1 
 include/linux/freezer.h                   |    9 +
 init/do_mounts_initrd.c                   |    7 -
 kernel/audit.c                            |    1 
 kernel/exit.c                             |    5 
 kernel/fork.c                             |    2 
 kernel/rcutorture.c                       |    3 
 kernel/rtmutex-tester.c                   |    1 
 kernel/sched.c                            |    2 
 kernel/softirq.c                          |    1 
 kernel/softlockup.c                       |    1 
 kernel/workqueue.c                        |    4 
 mm/pdflush.c                              |    1 
 mm/vmscan.c                               |    1 
 net/bluetooth/bnep/core.c                 |    1 
 net/bluetooth/cmtp/core.c                 |    1 
 net/bluetooth/hidp/core.c                 |    1 
 net/bluetooth/rfcomm/core.c               |    1 
 net/core/pktgen.c                         |    2 
 65 files changed, 234 insertions(+), 110 deletions(-)

Index: linux-2.6.22-rc3/kernel/exit.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/exit.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/exit.c	2007-05-29 21:54:13.000000000 +0200
@@ -389,6 +389,11 @@ void daemonize(const char *name, ...)
 	 * they would be locked into memory.
 	 */
 	exit_mm(current);
+	/*
+	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
+	 * or suspend transition begins right now.
+	 */
+	current->flags |= PF_NOFREEZE;
 
 	set_special_pids(1, 1);
 	proc_clear_tty(current);
Index: linux-2.6.22-rc3/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/freezer.h	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/include/linux/freezer.h	2007-05-29 21:54:13.000000000 +0200
@@ -118,6 +118,14 @@ static inline int freezer_should_skip(st
 	return !!(p->flags & PF_FREEZER_SKIP);
 }
 
+/*
+ * Tell the freezer that the current task should be frozen by it
+ */
+static inline void set_freezable(void)
+{
+	current->flags &= ~PF_NOFREEZE;
+}
+
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
@@ -134,6 +142,7 @@ static inline int try_to_freeze(void) { 
 static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
+static inline void set_freezable(void) {}
 #endif
 
 #endif /* LINUX_FREEZER_H */
Index: linux-2.6.22-rc3/kernel/fork.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/fork.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/fork.c	2007-05-29 21:54:13.000000000 +0200
@@ -920,7 +920,7 @@ static inline void copy_flags(unsigned l
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
+	new_flags &= ~PF_SUPERPRIV;
 	new_flags |= PF_FORKNOEXEC;
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
Index: linux-2.6.22-rc3/arch/i386/kernel/io_apic.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/kernel/io_apic.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/arch/i386/kernel/io_apic.c	2007-05-29 21:54:13.000000000 +0200
@@ -667,6 +667,7 @@ static int balanced_irq(void *unused)
 		set_pending_irq(i, cpumask_of_cpu(0));
 	}
 
+	set_freezable();
 	for ( ; ; ) {
 		time_remaining = schedule_timeout_interruptible(time_remaining);
 		try_to_freeze();
Index: linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/power/kernel_threads.txt	2007-05-29 21:54:01.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,40 +0,0 @@
-KERNEL THREADS
-
-
-Freezer
-
-Upon entering a suspended state the system will freeze all
-tasks. This is done by delivering pseudosignals. This affects
-kernel threads, too. To successfully freeze a kernel thread
-the thread has to check for the pseudosignal and enter the
-refrigerator. Code to do this looks like this:
-
-	do {
-		hub_events();
-		wait_event_interruptible(khubd_wait, !list_empty(&hub_event_list));
-		try_to_freeze();
-	} while (!signal_pending(current));
-
-from drivers/usb/core/hub.c::hub_thread()
-
-
-The Unfreezable
-
-Some kernel threads however, must not be frozen. The kernel must
-be able to finish pending IO operations and later on be able to
-write the memory image to disk. Kernel threads needed to do IO
-must stay awake. Such threads must mark themselves unfreezable
-like this:
-
-	/*
-	 * This thread doesn't need any user-level access,
-	 * so get rid of all our resources.
-	 */
-	daemonize("usb-storage");
-
-	current->flags |= PF_NOFREEZE;
-
-from drivers/usb/storage/usb.c::usb_stor_control_thread()
-
-Such drivers are themselves responsible for staying quiet during
-the actual snapshotting.
Index: linux-2.6.22-rc3/Documentation/power/swsusp.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/power/swsusp.txt	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/Documentation/power/swsusp.txt	2007-05-29 21:54:13.000000000 +0200
@@ -140,21 +140,11 @@ should be sent to the mailing list avail
 website, and not to the Linux Kernel Mailing List. We are working
 toward merging suspend2 into the mainline kernel.
 
-Q: A kernel thread must voluntarily freeze itself (call 'refrigerator').
-I found some kernel threads that don't do it, and they don't freeze
-so the system can't sleep. Is this a known behavior?
-
-A: All such kernel threads need to be fixed, one by one. Select the
-place where the thread is safe to be frozen (no kernel semaphores
-should be held at that point and it must be safe to sleep there), and
-add:
-
-       try_to_freeze();
-
-If the thread is needed for writing the image to storage, you should
-instead set the PF_NOFREEZE process flag when creating the thread (and
-be very careful).
+Q: What is the freezing of tasks and why are we using it?
 
+A: The freezing of tasks is a mechanism by which user space processes and some
+kernel threads are controlled during hibernation or system-wide suspend (on some
+architectures).  See freezing-of-tasks.txt for details.
 
 Q: What is the difference between "platform" and "shutdown"?
 
Index: linux-2.6.22-rc3/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/block/pktcdvd.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/block/pktcdvd.c	2007-05-29 21:54:13.000000000 +0200
@@ -1594,6 +1594,7 @@ static int kcdrwd(void *foobar)
 	long min_sleep_time, residue;
 
 	set_user_nice(current, -20);
+	set_freezable();
 
 	for (;;) {
 		DECLARE_WAITQUEUE(wait, current);
Index: linux-2.6.22-rc3/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/char/hvc_console.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/char/hvc_console.c	2007-05-29 21:54:13.000000000 +0200
@@ -679,6 +679,7 @@ int khvcd(void *unused)
 	int poll_mask;
 	struct hvc_struct *hp;
 
+	set_freezable();
 	__set_current_state(TASK_RUNNING);
 	do {
 		poll_mask = 0;
Index: linux-2.6.22-rc3/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/edac/edac_mc.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/edac/edac_mc.c	2007-05-29 21:54:13.000000000 +0200
@@ -1906,6 +1906,7 @@ static void do_edac_check(void)
 
 static int edac_kernel_thread(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		do_edac_check();
 
Index: linux-2.6.22-rc3/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/ieee1394/nodemgr.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/ieee1394/nodemgr.c	2007-05-29 21:54:13.000000000 +0200
@@ -1664,6 +1664,7 @@ static int nodemgr_host_thread(void *__h
 	unsigned int g, generation = 0;
 	int i, reset_cycles = 0;
 
+	set_freezable();
 	/* Setup our device-model entries */
 	nodemgr_create_host_dev_files(host);
 
Index: linux-2.6.22-rc3/drivers/input/gameport/gameport.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/input/gameport/gameport.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/input/gameport/gameport.c	2007-05-29 21:54:13.000000000 +0200
@@ -445,6 +445,7 @@ static struct gameport *gameport_get_pen
 
 static int gameport_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		gameport_handle_event();
 		wait_event_interruptible(gameport_wait,
Index: linux-2.6.22-rc3/drivers/input/serio/serio.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/input/serio/serio.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/input/serio/serio.c	2007-05-29 21:54:13.000000000 +0200
@@ -384,6 +384,7 @@ static struct serio *serio_get_pending_c
 
 static int serio_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		serio_handle_event();
 		wait_event_interruptible(serio_wait,
Index: linux-2.6.22-rc3/drivers/macintosh/therm_adt746x.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/macintosh/therm_adt746x.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/macintosh/therm_adt746x.c	2007-05-29 21:54:13.000000000 +0200
@@ -335,6 +335,7 @@ static int monitor_task(void *arg)
 {
 	struct thermostat* th = arg;
 
+	set_freezable();
 	while(!kthread_should_stop()) {
 		try_to_freeze();
 		msleep_interruptible(2000);
Index: linux-2.6.22-rc3/drivers/macintosh/windfarm_core.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/macintosh/windfarm_core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/macintosh/windfarm_core.c	2007-05-29 21:54:13.000000000 +0200
@@ -92,6 +92,7 @@ static int wf_thread_func(void *data)
 
 	DBG("wf: thread started\n");
 
+	set_freezable();
 	while(!kthread_should_stop()) {
 		if (time_after_eq(jiffies, next)) {
 			wf_notify(WF_EVENT_TICK, NULL);
Index: linux-2.6.22-rc3/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/dvb/dvb-core/dvb_frontend.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/dvb/dvb-core/dvb_frontend.c	2007-05-29 21:54:13.000000000 +0200
@@ -523,6 +523,7 @@ static int dvb_frontend_thread(void *dat
 
 	dvb_frontend_init(fe);
 
+	set_freezable();
 	while (1) {
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
 restart:
Index: linux-2.6.22-rc3/drivers/media/video/cx88/cx88-tvaudio.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/cx88/cx88-tvaudio.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/video/cx88/cx88-tvaudio.c	2007-05-29 21:54:13.000000000 +0200
@@ -906,6 +906,7 @@ int cx88_audio_thread(void *data)
 	u32 mode = 0;
 
 	dprintk("cx88: tvaudio thread started\n");
+	set_freezable();
 	for (;;) {
 		msleep_interruptible(1000);
 		if (kthread_should_stop())
Index: linux-2.6.22-rc3/drivers/media/video/msp3400-kthreads.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/msp3400-kthreads.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/video/msp3400-kthreads.c	2007-05-29 21:54:13.000000000 +0200
@@ -468,6 +468,7 @@ int msp3400c_thread(void *data)
 
 
 	v4l_dbg(1, msp_debug, client, "msp3400 daemon started\n");
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3400 thread: sleep\n");
 		msp_sleep(state, -1);
@@ -646,7 +647,7 @@ int msp3410d_thread(void *data)
 	int val, i, std, count;
 
 	v4l_dbg(1, msp_debug, client, "msp3410 daemon started\n");
-
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp3410 thread: sleep\n");
 		msp_sleep(state,-1);
@@ -940,7 +941,7 @@ int msp34xxg_thread(void *data)
 	int val, i;
 
 	v4l_dbg(1, msp_debug, client, "msp34xxg daemon started\n");
-
+	set_freezable();
 	for (;;) {
 		v4l_dbg(2, msp_debug, client, "msp34xxg thread: sleep\n");
 		msp_sleep(state, -1);
Index: linux-2.6.22-rc3/drivers/media/video/tvaudio.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/tvaudio.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/video/tvaudio.c	2007-05-29 21:54:13.000000000 +0200
@@ -271,7 +271,7 @@ static int chip_thread(void *data)
 	struct CHIPDESC  *desc = chiplist + chip->type;
 
 	v4l_dbg(1, debug, &chip->c, "%s: thread started\n", chip->c.name);
-
+	set_freezable();
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!kthread_should_stop())
Index: linux-2.6.22-rc3/drivers/media/video/video-buf-dvb.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/video-buf-dvb.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/video/video-buf-dvb.c	2007-05-29 21:54:13.000000000 +0200
@@ -47,6 +47,7 @@ static int videobuf_dvb_thread(void *dat
 	int err;
 
 	dprintk("dvb thread started\n");
+	set_freezable();
 	videobuf_read_start(&dvb->dvbq);
 
 	for (;;) {
Index: linux-2.6.22-rc3/drivers/media/video/vivi.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/vivi.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/media/video/vivi.c	2007-05-29 22:09:18.000000000 +0200
@@ -573,6 +573,7 @@ static int vivi_thread(void *data)
 	dprintk(1,"thread started\n");
 
 	mod_timer(&dma_q->timeout, jiffies+BUFFER_TIMEOUT);
+	set_freezable();
 
 	for (;;) {
 		vivi_sleep(dma_q);
Index: linux-2.6.22-rc3/drivers/mfd/ucb1x00-ts.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mfd/ucb1x00-ts.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/mfd/ucb1x00-ts.c	2007-05-29 21:54:13.000000000 +0200
@@ -209,6 +209,7 @@ static int ucb1x00_thread(void *_ts)
 	DECLARE_WAITQUEUE(wait, tsk);
 	int valid = 0;
 
+	set_freezable();
 	add_wait_queue(&ts->irq_wait, &wait);
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
Index: linux-2.6.22-rc3/drivers/mtd/ubi/wl.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mtd/ubi/wl.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/mtd/ubi/wl.c	2007-05-29 21:54:13.000000000 +0200
@@ -1346,6 +1346,7 @@ static int ubi_thread(void *u)
 	ubi_msg("background thread \"%s\" started, PID %d",
 		ubi->bgt_name, current->pid);
 
+	set_freezable();
 	for (;;) {
 		int err;
 
Index: linux-2.6.22-rc3/drivers/net/wireless/airo.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/net/wireless/airo.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/net/wireless/airo.c	2007-05-29 21:54:13.000000000 +0200
@@ -3078,7 +3078,8 @@ static int airo_thread(void *data) {
 	struct net_device *dev = data;
 	struct airo_info *ai = dev->priv;
 	int locked;
-	
+
+	set_freezable();
 	while(1) {
 		/* make swsusp happy with our thread */
 		try_to_freeze();
Index: linux-2.6.22-rc3/drivers/net/wireless/libertas/main.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/net/wireless/libertas/main.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/net/wireless/libertas/main.c	2007-05-29 21:54:13.000000000 +0200
@@ -718,6 +718,7 @@ static int wlan_service_main_thread(void
 
 	init_waitqueue_entry(&wait, current);
 
+	set_freezable();
 	for (;;) {
 		lbs_pr_debug(1, "main-thread 111: intcounter=%d "
 		       "currenttxskb=%p dnld_sent=%d\n",
Index: linux-2.6.22-rc3/drivers/pcmcia/cs.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pcmcia/cs.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/pcmcia/cs.c	2007-05-29 21:54:13.000000000 +0200
@@ -651,6 +651,7 @@ static int pccardd(void *__skt)
 	add_wait_queue(&skt->thread_wait, &wait);
 	complete(&skt->thread_done);
 
+	set_freezable();
 	for (;;) {
 		unsigned long flags;
 		unsigned int events;
Index: linux-2.6.22-rc3/drivers/pnp/pnpbios/core.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pnp/pnpbios/core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/pnp/pnpbios/core.c	2007-05-29 21:54:13.000000000 +0200
@@ -160,6 +160,7 @@ static int pnp_dock_thread(void * unused
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
+	set_freezable();
 	while (!unloading)
 	{
 		int status;
Index: linux-2.6.22-rc3/drivers/input/touchscreen/ucb1400_ts.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/input/touchscreen/ucb1400_ts.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/input/touchscreen/ucb1400_ts.c	2007-05-29 21:54:13.000000000 +0200
@@ -292,6 +292,7 @@ static int ucb1400_ts_thread(void *_ucb)
 
 	sched_setscheduler(tsk, SCHED_FIFO, &param);
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
 		long timeout;
Index: linux-2.6.22-rc3/drivers/usb/atm/ueagle-atm.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/atm/ueagle-atm.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/atm/ueagle-atm.c	2007-05-29 21:54:13.000000000 +0200
@@ -1168,6 +1168,7 @@ static int uea_kthread(void *data)
 	struct uea_softc *sc = data;
 	int ret = -EAGAIN;
 
+	set_freezable();
 	uea_enters(INS_TO_USBDEV(sc));
 	while (!kthread_should_stop()) {
 		if (ret < 0 || sc->reset)
Index: linux-2.6.22-rc3/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/core/hub.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/core/hub.c	2007-05-29 21:54:13.000000000 +0200
@@ -2799,6 +2799,7 @@ loop:
 
 static int hub_thread(void *__unused)
 {
+	set_freezable();
 	do {
 		hub_events();
 		wait_event_interruptible(khubd_wait,
Index: linux-2.6.22-rc3/drivers/usb/gadget/file_storage.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/gadget/file_storage.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/gadget/file_storage.c	2007-05-29 21:54:13.000000000 +0200
@@ -3435,6 +3435,8 @@ static int fsg_main_thread(void *fsg_)
 			sigmask(SIGTERM) | sigmask(SIGKILL) |
 			sigmask(SIGUSR1));
 	sigprocmask(SIG_SETMASK, &fsg->thread_signal_mask, NULL);
+	/* Allow the thread to be frozen */
+	set_freezable();
 
 	/* Arrange for userspace references to be interpreted as kernel
 	 * pointers.  That way we can pass a kernel pointer to a routine
Index: linux-2.6.22-rc3/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/storage/usb.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/usb/storage/usb.c	2007-05-29 21:54:13.000000000 +0200
@@ -301,8 +301,6 @@ static int usb_stor_control_thread(void 
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	current->flags |= PF_NOFREEZE;
-
 	for(;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
@@ -909,6 +907,7 @@ static int usb_stor_scan_thread(void * _
 	printk(KERN_DEBUG
 		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
 
+	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
Index: linux-2.6.22-rc3/drivers/video/ps3fb.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/video/ps3fb.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/video/ps3fb.c	2007-05-29 21:54:13.000000000 +0200
@@ -812,6 +812,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
Index: linux-2.6.22-rc3/drivers/w1/w1.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/w1/w1.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/w1/w1.c	2007-05-29 21:54:13.000000000 +0200
@@ -801,6 +801,7 @@ static int w1_control(void *data)
 	struct w1_master *dev, *n;
 	int have_to_wait = 0;
 
+	set_freezable();
 	while (!kthread_should_stop() || have_to_wait) {
 		have_to_wait = 0;
 
Index: linux-2.6.22-rc3/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/cifs/cifsfs.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/cifs/cifsfs.c	2007-05-29 21:54:13.000000000 +0200
@@ -849,6 +849,7 @@ static int cifs_oplock_thread(void * dum
 	__u16  netfid;
 	int rc;
 
+	set_freezable();
 	do {
 		if (try_to_freeze()) 
 			continue;
Index: linux-2.6.22-rc3/fs/cifs/connect.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/cifs/connect.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/cifs/connect.c	2007-05-29 21:54:13.000000000 +0200
@@ -363,6 +363,7 @@ cifs_demultiplex_thread(struct TCP_Serve
 			GFP_KERNEL);
 	}
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
 			continue;
Index: linux-2.6.22-rc3/fs/jffs2/background.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/jffs2/background.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/jffs2/background.c	2007-05-29 21:54:13.000000000 +0200
@@ -81,6 +81,7 @@ static int jffs2_garbage_collect_thread(
 
 	set_user_nice(current, 10);
 
+	set_freezable();
 	for (;;) {
 		allow_signal(SIGHUP);
 
Index: linux-2.6.22-rc3/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/xfs/linux-2.6/xfs_super.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/xfs/linux-2.6/xfs_super.c	2007-05-29 21:54:13.000000000 +0200
@@ -561,6 +561,7 @@ xfssyncd(
 	bhv_vfs_sync_work_t	*work, *n;
 	LIST_HEAD		(tmp);
 
+	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
 		timeleft = schedule_timeout_interruptible(timeleft);
Index: linux-2.6.22-rc3/fs/lockd/svc.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/lockd/svc.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/lockd/svc.c	2007-05-29 21:54:13.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/stats.h>
@@ -119,6 +120,7 @@ lockd(struct svc_rqst *rqstp)
 	complete(&lockd_start_done);
 
 	daemonize("lockd");
+	set_freezable();
 
 	/* Process request with signals blocked, but allow SIGKILL.  */
 	allow_signal(SIGKILL);
Index: linux-2.6.22-rc3/fs/nfsd/nfssvc.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/nfsd/nfssvc.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/nfsd/nfssvc.c	2007-05-29 21:54:13.000000000 +0200
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/freezer.h>
 #include <linux/fs_struct.h>
 
 #include <linux/sunrpc/types.h>
@@ -432,6 +433,7 @@ nfsd(struct svc_rqst *rqstp)
 	 * dirty pages.
 	 */
 	current->flags |= PF_LESS_THROTTLE;
+	set_freezable();
 
 	/*
 	 * The main request loop
Index: linux-2.6.22-rc3/fs/nfs/callback.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/nfs/callback.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/fs/nfs/callback.c	2007-05-29 21:54:13.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/sunrpc/svcsock.h>
 #include <linux/nfs_fs.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <net/inet_sock.h>
 
@@ -67,6 +68,7 @@ static void nfs_callback_svc(struct svc_
 	daemonize("nfsv4-svc");
 	/* Process request with signals blocked, but allow SIGKILL.  */
 	allow_signal(SIGKILL);
+	set_freezable();
 
 	complete(&nfs_callback_info.started);
 
Index: linux-2.6.22-rc3/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.22-rc3.orig/init/do_mounts_initrd.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/init/do_mounts_initrd.c	2007-05-29 21:54:13.000000000 +0200
@@ -56,12 +56,9 @@ static void __init handle_initrd(void)
 	sys_chroot(".");
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
-	if (pid > 0) {
-		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
-			try_to_freeze();
+	if (pid > 0)
+		while (pid != sys_wait4(-1, NULL, 0, NULL))
 			yield();
-		}
-	}
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
Index: linux-2.6.22-rc3/kernel/audit.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/audit.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/audit.c	2007-05-29 21:54:13.000000000 +0200
@@ -391,6 +391,7 @@ static int kauditd_thread(void *dummy)
 {
 	struct sk_buff *skb;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
Index: linux-2.6.22-rc3/kernel/rtmutex-tester.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/rtmutex-tester.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/rtmutex-tester.c	2007-05-29 21:54:13.000000000 +0200
@@ -260,6 +260,7 @@ static int test_func(void *data)
 	int ret;
 
 	current->flags |= PF_MUTEX_TESTER;
+	set_freezable();
 	allow_signal(SIGHUP);
 
 	for(;;) {
Index: linux-2.6.22-rc3/kernel/sched.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/sched.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/sched.c	2007-05-29 21:54:13.000000000 +0200
@@ -5157,6 +5157,7 @@ static int migration_thread(void *data)
 	BUG_ON(rq->migration_thread != current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
+	set_freezable();
 	while (!kthread_should_stop()) {
 		struct migration_req *req;
 		struct list_head *head;
@@ -5396,7 +5397,6 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
Index: linux-2.6.22-rc3/kernel/workqueue.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/workqueue.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/workqueue.c	2007-05-29 21:54:13.000000000 +0200
@@ -282,8 +282,8 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
-	if (!cwq->wq->freezeable)
-		current->flags |= PF_NOFREEZE;
+	if (cwq->wq->freezeable)
+		set_freezable();
 
 	set_user_nice(current, -5);
 
Index: linux-2.6.22-rc3/mm/pdflush.c
===================================================================
--- linux-2.6.22-rc3.orig/mm/pdflush.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/mm/pdflush.c	2007-05-29 21:54:13.000000000 +0200
@@ -92,6 +92,7 @@ struct pdflush_work {
 static int __pdflush(struct pdflush_work *my_work)
 {
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	set_freezable();
 	my_work->fn = NULL;
 	my_work->who = current;
 	INIT_LIST_HEAD(&my_work->list);
Index: linux-2.6.22-rc3/mm/vmscan.c
===================================================================
--- linux-2.6.22-rc3.orig/mm/vmscan.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/mm/vmscan.c	2007-05-29 21:54:13.000000000 +0200
@@ -1314,6 +1314,7 @@ static int kswapd(void *p)
 	 * trying to free the first piece of memory in the first place).
 	 */
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+	set_freezable();
 
 	order = 0;
 	for ( ; ; ) {
Index: linux-2.6.22-rc3/net/core/pktgen.c
===================================================================
--- linux-2.6.22-rc3.orig/net/core/pktgen.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/net/core/pktgen.c	2007-05-29 21:54:13.000000000 +0200
@@ -3274,6 +3274,8 @@ static int pktgen_thread_worker(void *ar
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	set_freezable();
+
 	while (!kthread_should_stop()) {
 		pkt_dev = next_to_run(t);
 
Index: linux-2.6.22-rc3/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/kernel/apm.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/arch/i386/kernel/apm.c	2007-05-29 21:54:13.000000000 +0200
@@ -2309,7 +2309,6 @@ static int __init apm_init(void)
 		remove_proc_entry("apm", NULL);
 		return err;
 	}
-	kapmd_task->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_task);
 
 	if (num_online_cpus() > 1 && !smp ) {
Index: linux-2.6.22-rc3/drivers/block/loop.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/block/loop.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/block/loop.c	2007-05-29 21:54:13.000000000 +0200
@@ -576,13 +576,6 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
-	/*
-	 * loop can be used in an encrypted device,
-	 * hence, it mustn't be stopped at all
-	 * because it could be indirectly used during suspension
-	 */
-	current->flags |= PF_NOFREEZE;
-
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
Index: linux-2.6.22-rc3/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/char/apm-emulation.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/char/apm-emulation.c	2007-05-29 21:54:13.000000000 +0200
@@ -329,13 +329,8 @@ apm_ioctl(struct inode * inode, struct f
 			/*
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
@@ -365,13 +360,8 @@ apm_ioctl(struct inode * inode, struct f
 			/*
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
 
 			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
@@ -598,7 +588,6 @@ static int __init apm_init(void)
 		kapmd_tsk = NULL;
 		return ret;
 	}
-	kapmd_tsk->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
Index: linux-2.6.22-rc3/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/ieee1394/ieee1394_core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/ieee1394/ieee1394_core.c	2007-05-29 21:54:13.000000000 +0200
@@ -1133,8 +1133,6 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (!kthread_should_stop()) {
 
 		INIT_LIST_HEAD(&tmp);
Index: linux-2.6.22-rc3/drivers/md/md.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/md/md.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/md/md.c	2007-05-29 21:54:13.000000000 +0200
@@ -4642,7 +4642,6 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	current->flags |= PF_NOFREEZE;
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.22-rc3/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mmc/card/queue.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/mmc/card/queue.c	2007-05-29 21:54:13.000000000 +0200
@@ -42,11 +42,7 @@ static int mmc_queue_thread(void *d)
 	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
 
-	/*
-	 * Set iothread to ensure that we aren't put to sleep by
-	 * the process freezing.  We handle suspension ourselves.
-	 */
-	current->flags |= PF_MEMALLOC|PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
 
 	down(&mq->thread_sem);
 	do {
Index: linux-2.6.22-rc3/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mtd/mtd_blkdevs.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/mtd/mtd_blkdevs.c	2007-05-29 21:54:13.000000000 +0200
@@ -80,7 +80,7 @@ static int mtd_blktrans_thread(void *arg
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
-	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
 	while (!kthread_should_stop()) {
Index: linux-2.6.22-rc3/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/scsi/libsas/sas_scsi_host.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/scsi/libsas/sas_scsi_host.c	2007-05-29 21:54:13.000000000 +0200
@@ -868,8 +868,6 @@ static int sas_queue_thread(void *_sas_h
 {
 	struct sas_ha_struct *sas_ha = _sas_ha;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
Index: linux-2.6.22-rc3/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/scsi/scsi_error.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/scsi/scsi_error.c	2007-05-29 21:54:13.000000000 +0200
@@ -1536,8 +1536,6 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	current->flags |= PF_NOFREEZE;
-
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
 	 * counted against the load average as a running process.
Index: linux-2.6.22-rc3/kernel/rcutorture.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/rcutorture.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/rcutorture.c	2007-05-29 21:54:13.000000000 +0200
@@ -518,7 +518,6 @@ rcu_torture_writer(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -558,7 +557,6 @@ rcu_torture_fakewriter(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -589,7 +587,6 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		idx = cur_ops->readlock();
Index: linux-2.6.22-rc3/kernel/softirq.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/softirq.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/softirq.c	2007-05-29 21:54:13.000000000 +0200
@@ -489,7 +489,6 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
Index: linux-2.6.22-rc3/kernel/softlockup.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/softlockup.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/kernel/softlockup.c	2007-05-29 21:54:13.000000000 +0200
@@ -116,7 +116,6 @@ static int watchdog(void * __bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->flags |= PF_NOFREEZE;
 
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
Index: linux-2.6.22-rc3/net/bluetooth/bnep/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/bnep/core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/net/bluetooth/bnep/core.c	2007-05-29 21:54:13.000000000 +0200
@@ -474,7 +474,6 @@ static int bnep_session(void *arg)
 
 	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
Index: linux-2.6.22-rc3/net/bluetooth/cmtp/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/cmtp/core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/net/bluetooth/cmtp/core.c	2007-05-29 21:54:13.000000000 +0200
@@ -287,7 +287,6 @@ static int cmtp_session(void *arg)
 
 	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
Index: linux-2.6.22-rc3/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/hidp/core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/net/bluetooth/hidp/core.c	2007-05-29 21:54:13.000000000 +0200
@@ -547,7 +547,6 @@ static int hidp_session(void *arg)
 
 	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&ctrl_wait, current);
 	init_waitqueue_entry(&intr_wait, current);
Index: linux-2.6.22-rc3/net/bluetooth/rfcomm/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/rfcomm/core.c	2007-05-29 21:54:01.000000000 +0200
+++ linux-2.6.22-rc3/net/bluetooth/rfcomm/core.c	2007-05-29 21:54:13.000000000 +0200
@@ -1940,7 +1940,6 @@ static int rfcomm_run(void *unused)
 
 	daemonize("krfcommd");
 	set_user_nice(current, -10);
-	current->flags |= PF_NOFREEZE;
 
 	BT_DBG("");
 
Index: linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt	2007-05-29 22:14:16.000000000 +0200
@@ -0,0 +1,160 @@
+Freezing of tasks
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+I. What is the freezing of tasks?
+
+The freezing of tasks is a mechanism by which user space processes and some
+kernel threads are controlled during hibernation or system-wide suspend (on some
+architectures).
+
+II. How does it work?
+
+There are four per-task flags used for that, PF_NOFREEZE, PF_FROZEN, TIF_FREEZE
+and PF_FREEZER_SKIP (the last one is auxiliary).  The tasks that have
+PF_NOFREEZE unset (all user space processes and some kernel threads) are
+regarded as 'freezable' and treated in a special way before the system enters a
+suspend state as well as before a hibernation image is created (in what follows
+we only consider hibernation, but the description also applies to suspend).
+
+Namely, as the first step of the hibernation procedure the function
+freeze_processes() (defined in kernel/power/process.c) is called.  It executes
+try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
+sends a fake signal to each of them.  A task that receives such a signal and has
+TIF_FREEZE set, should react to it by calling the refrigerator() function
+(defined in kernel/power/process.c), which sets the task's PF_FROZEN flag,
+changes its state to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is
+cleared for it.  Then, we say that the task is 'frozen' and therefore the set of
+functions handling this mechanism is called 'the freezer' (these functions are
+defined in kernel/power/process.c and include/linux/freezer.h).  User space
+processes are generally frozen before kernel threads.
+
+It is not recommended to call refrigerator() directly.  Instead, it is
+recommended to use the try_to_freeze() function (defined in
+include/linux/freezer.h), that checks the task's TIF_FREEZE flag and makes the
+task enter refrigerator() if the flag is set.
+
+For user space processes try_to_freeze() is called automatically from the
+signal-handling code, but the freezable kernel threads need to call it
+explicitly in suitable places.  The code to do this may look like the following:
+
+	do {
+		hub_events();
+		wait_event_interruptible(khubd_wait,
+					!list_empty(&hub_event_list));
+		try_to_freeze();
+	} while (!signal_pending(current));
+
+(from drivers/usb/core/hub.c::hub_thread()).
+
+If a freezable kernel thread fails to call try_to_freeze() after the freezer has
+set TIF_FREEZE for it, the freezing of tasks will fail and the entire
+hibernation operation will be cancelled.  For this reason, freezable kernel
+threads must call try_to_freeze() somewhere.
+
+After the system memory state has been restored from a hibernation image and
+devices have been reinitialized, the function thaw_processes() is called in
+order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
+have been frozen leave refrigerator() and continue running.
+
+III. Which kernel threads are freezable?
+
+Kernel threads are not freezable by default.  However, a kernel thread may clear
+PF_NOFREEZE for itself by calling set_freezable() (the resetting of PF_NOFREEZE
+directly is strongly discouraged).  From this point it is regarded as freezable
+and must call try_to_freeze() in a suitable place.
+
+IV. Why do we do that?
+
+Generally speaking, there is a couple of reasons to use the freezing of tasks:
+
+1. The principal reason is to prevent filesystems from being damaged after
+hibernation.  At the moment we have no simple means of checkpointing
+filesystems, so if there are any modifications made to filesystem data and/or
+metadata on disks, we cannot bring them back to the state from before the
+modifications.  At the same time each hibernation image contains some
+filesystem-related information that must be consistent with the state of the
+on-disk data and metadata after the system memory state has been restored from
+the image (otherwise the filesystems will be damaged in a nasty way, usually
+making them almost impossible to repair).  We therefore freeze tasks that might
+cause the on-disk filesystems' data and metadata to be modified after the
+hibernation image has been created and before the system is finally powered off.
+The majority of these are user space processes, but if any of the kernel threads
+may cause something like this to happen, they have to be freezable.
+
+2. The second reason is to prevent user space processes and some kernel threads
+from interfering with the suspending and resuming of devices.  A user space
+process running on a second CPU while we are suspending devices may, for
+example, be troublesome and without the freezing of tasks we would need some
+safeguards against race conditions that might occur in such a case.
+
+Although Linus Torvalds doesn't like the freezing of tasks, he said this in one
+of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
+
+"RJW:> Why we freeze tasks at all or why we freeze kernel threads?
+
+Linus: In many ways, 'at all'.
+
+I _do_ realize the IO request queue issues, and that we cannot actually do
+s2ram with some devices in the middle of a DMA.  So we want to be able to
+avoid *that*, there's no question about that.  And I suspect that stopping
+user threads and then waiting for a sync is practically one of the easier
+ways to do so.
+
+So in practice, the 'at all' may become a 'why freeze kernel threads?' and
+freezing user threads I don't find really objectionable."
+
+Still, there are kernel threads that may want to be freezable.  For example, if
+a kernel that belongs to a device driver accesses the device directly, it in
+principle needs to know when the device is suspended, so that it doesn't try to
+access it at that time.  However, if the kernel thread is freezable, it will be
+frozen before the driver's .suspend() callback is executed and it will be
+thawed after the driver's .resume() callback has run, so it won't be accessing
+the device while it's suspended.
+
+3. Another reason for freezing tasks is to prevent user space processes from
+realizing that hibernation (or suspend) operation takes place.  Ideally, user
+space processes should not notice that such a system-wide operation has occurred
+and should continue running without any problems after the restore (or resume
+from suspend).  Unfortunately, in the most general case this is quite difficult
+to achieve without the freezing of tasks.  Consider, for example, a process
+that depends on all CPUs being online while it's running.  Since we need to
+disable nonboot CPUs during the hibernation, if this process is not frozen, it
+may notice that the number of CPUs has changed and may start to work incorrectly
+because of that.
+
+V. Are there any problems related to the freezing of tasks?
+
+Yes, there are.
+
+First of all, the freezing of kernel threads may be tricky if they depend one
+on another.  For example, if kernel thread A waits for a completion (in the
+TASK_UNINTERRUPTIBLE state) that needs to be done by freezable kernel thread B
+and B is frozen in the meantime, then A will be blocked until B is thawed, which
+may be undesirable.  That's why kernel threads are not freezable by default.
+
+Second, there are the following two problems related to the freezing of user
+space processes:
+1. Putting processes into an uninterruptible sleep distorts the load average.
+2. Now that we have FUSE, plus the framework for doing device drivers in
+userspace, it gets even more complicated because some userspace processes are
+now doing the sorts of things that kernel threads do
+(https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012309.html).
+
+The problem 1. seems to be fixable, although it hasn't been fixed so far.  The
+other one is more serious, but it seems that we can work around it by using
+hibernation (and suspend) notifiers (in that case, though, we won't be able to
+avoid the realization by the user space processes that the hibernation is taking
+place).
+
+There are also problems that the freezing of tasks tends to expose, although
+they are not directly related to it.  For example, if request_firmware() is
+called from a device driver's .resume() routine, it will timeout and eventually
+fail, because the user land process that should respond to the request is frozen
+at this point.  So, seemingly, the failure is due to the freezing of tasks.
+Suppose, however, that the firmware file is located on a filesystem accessible
+only through another device that hasn't been resumed yet.  In that case,
+request_firmware() will fail regardless of whether or not the freezing of tasks
+is used.  Consequently, the problem is not really related to the freezing of
+tasks, since it generally exists anyway.  [The solution to this particular
+problem is to keep the firmware in memory after it's loaded for the first time
+and upload if from memory to the device whenever necessary.]
