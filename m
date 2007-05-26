Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbXEZWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbXEZWH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXEZWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:07:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXEZWHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:07:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Sun, 27 May 2007 00:12:58 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705270012.59177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the "Freezing of kernel threads" discussion
(http://lkml.org/lkml/2007/5/12/162) I have created a patch that changes the
freezer's behavior with respect to kernel threads.  Namely, with the patch
applied all kernel threads are nonfreezable by default (have PF_NOFREEZE set)
and the ones that want to be frozen need to call set_freezable() (which clears
PF_NOFREEZE for them) and try_to_freeze().  The other (nonfreezable) kernel
threads don't need to call try_to_freeze() any more.

I have removed try_to_freeze() from a handful of kernel threads that I think
need not be freezable, but in many cases I wasn't quite sure whether or not
it was a good idea to change the current behavior.  For this reason I've added
set_freezable() to the majority of (currently freezable) kernel threads that
belong to device drivers and filesystems.

Of course, I have removed the setting of PF_NOFREEZE from the kernel threads
that are currently nonfreezable, since with the other changes in the patch it
isn't necessary any more.

This patch is on top of the "Freezer: Avoid freezing kernel threads prematurely"
patch that I posted yestarday, available at http://lkml.org/lkml/2007/5/25/199
(updated version that applies cleanly on top of 2.6.22-rc3, is available at
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/07-freezer-avoid-freezing-kernel-threads-prematurely.patch).
It has been tested on a couple of machines and doesn't seem to break anything.

[As you can see there are quite a lot of files affected, so I didn't add all
maintainers of them to the CC list.  In fact, I'm not sure how to handle
notifying them of the change, so please advise.]

Greetings,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/kernel_threads.txt    |   54 ++++++++++++------------------
 Documentation/power/swsusp.txt            |   16 --------
 arch/i386/kernel/apm.c                    |    1 
 arch/i386/kernel/io_apic.c                |    1 
 drivers/block/loop.c                      |    7 ---
 drivers/block/pktcdvd.c                   |    3 -
 drivers/char/apm-emulation.c              |   11 ------
 drivers/char/hvc_console.c                |    1 
 drivers/edac/edac_mc.c                    |    1 
 drivers/ieee1394/ieee1394_core.c          |    2 -
 drivers/ieee1394/nodemgr.c                |    1 
 drivers/input/gameport/gameport.c         |    1 
 drivers/input/serio/serio.c               |    1 
 drivers/input/touchscreen/ucb1400_ts.c    |    1 
 drivers/macintosh/therm_adt746x.c         |    1 
 drivers/macintosh/windfarm_core.c         |    4 +-
 drivers/md/md.c                           |    1 
 drivers/media/dvb/dvb-core/dvb_frontend.c |    1 
 drivers/media/video/cx88/cx88-tvaudio.c   |    1 
 drivers/media/video/msp3400-kthreads.c    |    5 +-
 drivers/media/video/tvaudio.c             |    2 -
 drivers/media/video/video-buf-dvb.c       |    1 
 drivers/media/video/vivi.c                |    1 
 drivers/mfd/ucb1x00-ts.c                  |    1 
 drivers/mmc/card/queue.c                  |    6 ---
 drivers/mtd/mtd_blkdevs.c                 |    2 -
 drivers/mtd/ubi/wl.c                      |    1 
 drivers/net/wireless/airo.c               |    3 +
 drivers/net/wireless/libertas/main.c      |    1 
 drivers/pcmcia/cs.c                       |    1 
 drivers/pnp/pnpbios/core.c                |    1 
 drivers/scsi/libsas/sas_scsi_host.c       |    2 -
 drivers/scsi/scsi_error.c                 |    2 -
 drivers/usb/atm/ueagle-atm.c              |    1 
 drivers/usb/core/hub.c                    |    1 
 drivers/usb/gadget/file_storage.c         |    2 +
 drivers/usb/storage/usb.c                 |    5 --
 drivers/video/ps3fb.c                     |    1 
 drivers/w1/w1.c                           |    1 
 fs/cifs/cifsfs.c                          |    1 
 fs/cifs/connect.c                         |    1 
 fs/jffs2/background.c                     |    1 
 fs/lockd/clntproc.c                       |    1 
 fs/xfs/linux-2.6/xfs_super.c              |    1 
 include/linux/freezer.h                   |    9 +++++
 init/do_mounts_initrd.c                   |    7 +--
 kernel/audit.c                            |    4 --
 kernel/exit.c                             |    5 ++
 kernel/fork.c                             |    2 -
 kernel/rcutorture.c                       |    3 -
 kernel/rtmutex-tester.c                   |    1 
 kernel/sched.c                            |    3 -
 kernel/softirq.c                          |    1 
 kernel/softlockup.c                       |    1 
 kernel/workqueue.c                        |    4 +-
 mm/pdflush.c                              |    4 --
 mm/vmscan.c                               |    9 -----
 net/bluetooth/bnep/core.c                 |    1 
 net/bluetooth/cmtp/core.c                 |    1 
 net/bluetooth/hidp/core.c                 |    1 
 net/bluetooth/rfcomm/core.c               |    1 
 net/core/pktgen.c                         |    2 -
 net/sunrpc/svcsock.c                      |    3 -
 63 files changed, 78 insertions(+), 138 deletions(-)

Index: linux-2.6.22-rc3/kernel/exit.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/exit.c
+++ linux-2.6.22-rc3/kernel/exit.c
@@ -389,6 +389,11 @@ void daemonize(const char *name, ...)
 	 * they would be locked into memory.
 	 */
 	exit_mm(current);
+	/*
+	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
+	 * or suspend transision begins right now.
+	 */
+	current->flags |= PF_NOFREEZE;
 
 	set_special_pids(1, 1);
 	proc_clear_tty(current);
Index: linux-2.6.22-rc3/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/freezer.h
+++ linux-2.6.22-rc3/include/linux/freezer.h
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
+static inline void set_freezable_current(void) {}
 #endif
 
 #endif /* LINUX_FREEZER_H */
Index: linux-2.6.22-rc3/kernel/fork.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/fork.c
+++ linux-2.6.22-rc3/kernel/fork.c
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
--- linux-2.6.22-rc3.orig/arch/i386/kernel/io_apic.c
+++ linux-2.6.22-rc3/arch/i386/kernel/io_apic.c
@@ -669,7 +669,6 @@ static int balanced_irq(void *unused)
 
 	for ( ; ; ) {
 		time_remaining = schedule_timeout_interruptible(time_remaining);
-		try_to_freeze();
 		if (time_after(jiffies,
 				prev_balance_time+balanced_irq_interval)) {
 			preempt_disable();
Index: linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/power/kernel_threads.txt
+++ linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
@@ -1,13 +1,22 @@
-KERNEL THREADS
+The Freezer and Kernel Threads
 
-
-Freezer
-
-Upon entering a suspended state the system will freeze all
-tasks. This is done by delivering pseudosignals. This affects
-kernel threads, too. To successfully freeze a kernel thread
-the thread has to check for the pseudosignal and enter the
-refrigerator. Code to do this looks like this:
+Before entering a system-wide suspend state as well as before creating a
+hibernation snapshot image the system will freeze all tasks, which is done
+by delivering fake signals.  This affects kernel threads too, but they won't be
+frozen unless they declare that they want to.  For this purpose they should call
+set_freezable() that will unset the per-task flag PF_NOFREEZE for them (this
+flag is set by default for all kernel threads).
+
+For each task with PF_NOFREEZE unset the freezer sets the TIF_FREEZE flag
+whenever appropriate and sends a fake signal to it.  The task should react by
+calling refrigerator(), where it will stay until the freezer allows it to
+continue.  The try_to_freeze() function checks the TIF_FREEZE flag and makes
+the task enter refrigerator() if it's set, so using it is the preferred way of
+"freezing" the task.
+
+For user space processes try_to_freeze() is called from the signal-handling
+code, but the kernel threads that want to be frozen need to call it explicitly
+in suitable places.  Code to do this may look like the following:
 
 	do {
 		hub_events();
@@ -15,26 +24,9 @@ refrigerator. Code to do this looks like
 		try_to_freeze();
 	} while (!signal_pending(current));
 
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
+(from drivers/usb/core/hub.c::hub_thread()).
 
-Such drivers are themselves responsible for staying quiet during
-the actual snapshotting.
+If a kernel thread declares that it wants to be frozen and fails to call
+try_to_freeze() after the freezer has set TIF_FREEZE for it, the freezing of
+tasks will fail and the entire hibernation or suspend operation will be
+cancelled.
Index: linux-2.6.22-rc3/Documentation/power/swsusp.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/power/swsusp.txt
+++ linux-2.6.22-rc3/Documentation/power/swsusp.txt
@@ -140,22 +140,6 @@ should be sent to the mailing list avail
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
-
-
 Q: What is the difference between "platform" and "shutdown"?
 
 A:
Index: linux-2.6.22-rc3/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/block/pktcdvd.c
+++ linux-2.6.22-rc3/drivers/block/pktcdvd.c
@@ -1640,9 +1640,6 @@ static int kcdrwd(void *foobar)
 			residue = schedule_timeout(min_sleep_time);
 			VPRINTK("kcdrwd: wake up\n");
 
-			/* make swsusp happy with our thread */
-			try_to_freeze();
-
 			list_for_each_entry(pkt, &pd->cdrw.pkt_active_list, list) {
 				if (!pkt->sleep_time)
 					continue;
Index: linux-2.6.22-rc3/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/char/hvc_console.c
+++ linux-2.6.22-rc3/drivers/char/hvc_console.c
@@ -679,6 +679,7 @@ int khvcd(void *unused)
 	int poll_mask;
 	struct hvc_struct *hp;
 
+	set_freezable();
 	__set_current_state(TASK_RUNNING);
 	do {
 		poll_mask = 0;
Index: linux-2.6.22-rc3/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/edac/edac_mc.c
+++ linux-2.6.22-rc3/drivers/edac/edac_mc.c
@@ -1906,6 +1906,7 @@ static void do_edac_check(void)
 
 static int edac_kernel_thread(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		do_edac_check();
 
Index: linux-2.6.22-rc3/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.22-rc3/drivers/ieee1394/nodemgr.c
@@ -1664,6 +1664,7 @@ static int nodemgr_host_thread(void *__h
 	unsigned int g, generation = 0;
 	int i, reset_cycles = 0;
 
+	set_freezable();
 	/* Setup our device-model entries */
 	nodemgr_create_host_dev_files(host);
 
Index: linux-2.6.22-rc3/drivers/input/gameport/gameport.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/input/gameport/gameport.c
+++ linux-2.6.22-rc3/drivers/input/gameport/gameport.c
@@ -445,6 +445,7 @@ static struct gameport *gameport_get_pen
 
 static int gameport_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		gameport_handle_event();
 		wait_event_interruptible(gameport_wait,
Index: linux-2.6.22-rc3/drivers/input/serio/serio.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/input/serio/serio.c
+++ linux-2.6.22-rc3/drivers/input/serio/serio.c
@@ -384,6 +384,7 @@ static struct serio *serio_get_pending_c
 
 static int serio_thread(void *nothing)
 {
+	set_freezable();
 	do {
 		serio_handle_event();
 		wait_event_interruptible(serio_wait,
Index: linux-2.6.22-rc3/drivers/macintosh/therm_adt746x.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/macintosh/therm_adt746x.c
+++ linux-2.6.22-rc3/drivers/macintosh/therm_adt746x.c
@@ -336,7 +336,6 @@ static int monitor_task(void *arg)
 	struct thermostat* th = arg;
 
 	while(!kthread_should_stop()) {
-		try_to_freeze();
 		msleep_interruptible(2000);
 
 #ifndef DEBUG
Index: linux-2.6.22-rc3/drivers/macintosh/windfarm_core.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/macintosh/windfarm_core.c
+++ linux-2.6.22-rc3/drivers/macintosh/windfarm_core.c
@@ -115,8 +115,8 @@ static int wf_thread_func(void *data)
 		if (delay <= HZ)
 			schedule_timeout_interruptible(delay);
 
-		/* there should be no non-suspend signal, but oh well */
-		if (signal_pending(current) && !try_to_freeze()) {
+		/* there should be no signal, but oh well */
+		if (signal_pending(current)) {
 			printk(KERN_WARNING "windfarm: thread got sigl !\n");
 			break;
 		}
Index: linux-2.6.22-rc3/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ linux-2.6.22-rc3/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -523,6 +523,7 @@ static int dvb_frontend_thread(void *dat
 
 	dvb_frontend_init(fe);
 
+	set_freezable();
 	while (1) {
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
 restart:
Index: linux-2.6.22-rc3/drivers/media/video/cx88/cx88-tvaudio.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/cx88/cx88-tvaudio.c
+++ linux-2.6.22-rc3/drivers/media/video/cx88/cx88-tvaudio.c
@@ -906,6 +906,7 @@ int cx88_audio_thread(void *data)
 	u32 mode = 0;
 
 	dprintk("cx88: tvaudio thread started\n");
+	set_freezable();
 	for (;;) {
 		msleep_interruptible(1000);
 		if (kthread_should_stop())
Index: linux-2.6.22-rc3/drivers/media/video/msp3400-kthreads.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/msp3400-kthreads.c
+++ linux-2.6.22-rc3/drivers/media/video/msp3400-kthreads.c
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
--- linux-2.6.22-rc3.orig/drivers/media/video/tvaudio.c
+++ linux-2.6.22-rc3/drivers/media/video/tvaudio.c
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
--- linux-2.6.22-rc3.orig/drivers/media/video/video-buf-dvb.c
+++ linux-2.6.22-rc3/drivers/media/video/video-buf-dvb.c
@@ -47,6 +47,7 @@ static int videobuf_dvb_thread(void *dat
 	int err;
 
 	dprintk("dvb thread started\n");
+	set_freezable();
 	videobuf_read_start(&dvb->dvbq);
 
 	for (;;) {
Index: linux-2.6.22-rc3/drivers/media/video/vivi.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/media/video/vivi.c
+++ linux-2.6.22-rc3/drivers/media/video/vivi.c
@@ -563,7 +563,6 @@ static void vivi_sleep(struct vivi_dmaqu
 	}
 
 	remove_wait_queue(&dma_q->wq, &wait);
-	try_to_freeze();
 }
 
 static int vivi_thread(void *data)
Index: linux-2.6.22-rc3/drivers/mfd/ucb1x00-ts.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mfd/ucb1x00-ts.c
+++ linux-2.6.22-rc3/drivers/mfd/ucb1x00-ts.c
@@ -209,6 +209,7 @@ static int ucb1x00_thread(void *_ts)
 	DECLARE_WAITQUEUE(wait, tsk);
 	int valid = 0;
 
+	set_freezable();
 	add_wait_queue(&ts->irq_wait, &wait);
 	while (!kthread_should_stop()) {
 		unsigned int x, y, p;
Index: linux-2.6.22-rc3/drivers/mtd/ubi/wl.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mtd/ubi/wl.c
+++ linux-2.6.22-rc3/drivers/mtd/ubi/wl.c
@@ -1346,6 +1346,7 @@ static int ubi_thread(void *u)
 	ubi_msg("background thread \"%s\" started, PID %d",
 		ubi->bgt_name, current->pid);
 
+	set_freezable();
 	for (;;) {
 		int err;
 
Index: linux-2.6.22-rc3/drivers/net/wireless/airo.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/net/wireless/airo.c
+++ linux-2.6.22-rc3/drivers/net/wireless/airo.c
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
--- linux-2.6.22-rc3.orig/drivers/net/wireless/libertas/main.c
+++ linux-2.6.22-rc3/drivers/net/wireless/libertas/main.c
@@ -718,6 +718,7 @@ static int wlan_service_main_thread(void
 
 	init_waitqueue_entry(&wait, current);
 
+	set_freezable();
 	for (;;) {
 		lbs_pr_debug(1, "main-thread 111: intcounter=%d "
 		       "currenttxskb=%p dnld_sent=%d\n",
Index: linux-2.6.22-rc3/drivers/pcmcia/cs.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pcmcia/cs.c
+++ linux-2.6.22-rc3/drivers/pcmcia/cs.c
@@ -651,6 +651,7 @@ static int pccardd(void *__skt)
 	add_wait_queue(&skt->thread_wait, &wait);
 	complete(&skt->thread_done);
 
+	set_freezable();
 	for (;;) {
 		unsigned long flags;
 		unsigned int events;
Index: linux-2.6.22-rc3/drivers/pnp/pnpbios/core.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pnp/pnpbios/core.c
+++ linux-2.6.22-rc3/drivers/pnp/pnpbios/core.c
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
--- linux-2.6.22-rc3.orig/drivers/input/touchscreen/ucb1400_ts.c
+++ linux-2.6.22-rc3/drivers/input/touchscreen/ucb1400_ts.c
@@ -336,7 +336,6 @@ static int ucb1400_ts_thread(void *_ucb)
 		wait_event_interruptible_timeout(ucb->ts_wait,
 			ucb->irq_pending || ucb->ts_restart || kthread_should_stop(),
 			timeout);
-		try_to_freeze();
 	}
 
 	/* Send the "pen off" if we are stopping with the pen still active */
Index: linux-2.6.22-rc3/drivers/usb/atm/ueagle-atm.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/atm/ueagle-atm.c
+++ linux-2.6.22-rc3/drivers/usb/atm/ueagle-atm.c
@@ -1168,6 +1168,7 @@ static int uea_kthread(void *data)
 	struct uea_softc *sc = data;
 	int ret = -EAGAIN;
 
+	set_freezable();
 	uea_enters(INS_TO_USBDEV(sc));
 	while (!kthread_should_stop()) {
 		if (ret < 0 || sc->reset)
Index: linux-2.6.22-rc3/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/core/hub.c
+++ linux-2.6.22-rc3/drivers/usb/core/hub.c
@@ -2799,6 +2799,7 @@ loop:
 
 static int hub_thread(void *__unused)
 {
+	set_freezable();
 	do {
 		hub_events();
 		wait_event_interruptible(khubd_wait,
Index: linux-2.6.22-rc3/drivers/usb/gadget/file_storage.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/usb/gadget/file_storage.c
+++ linux-2.6.22-rc3/drivers/usb/gadget/file_storage.c
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
--- linux-2.6.22-rc3.orig/drivers/usb/storage/usb.c
+++ linux-2.6.22-rc3/drivers/usb/storage/usb.c
@@ -301,8 +301,6 @@ static int usb_stor_control_thread(void 
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	current->flags |= PF_NOFREEZE;
-
 	for(;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
@@ -913,12 +911,9 @@ static int usb_stor_scan_thread(void * _
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
 				"to settle before scanning\n");
-retry:
 		wait_event_interruptible_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DISCONNECTING, &us->flags),
 				delay_use * HZ);
-		if (try_to_freeze())
-			goto retry;
 	}
 
 	/* If the device is still connected, perform the scanning */
Index: linux-2.6.22-rc3/drivers/video/ps3fb.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/video/ps3fb.c
+++ linux-2.6.22-rc3/drivers/video/ps3fb.c
@@ -812,6 +812,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
+	set_freezable();
 	while (!kthread_should_stop()) {
 		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
Index: linux-2.6.22-rc3/drivers/w1/w1.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/w1/w1.c
+++ linux-2.6.22-rc3/drivers/w1/w1.c
@@ -801,6 +801,7 @@ static int w1_control(void *data)
 	struct w1_master *dev, *n;
 	int have_to_wait = 0;
 
+	set_freezable();
 	while (!kthread_should_stop() || have_to_wait) {
 		have_to_wait = 0;
 
Index: linux-2.6.22-rc3/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/cifs/cifsfs.c
+++ linux-2.6.22-rc3/fs/cifs/cifsfs.c
@@ -849,6 +849,7 @@ static int cifs_oplock_thread(void * dum
 	__u16  netfid;
 	int rc;
 
+	set_freezable();
 	do {
 		if (try_to_freeze()) 
 			continue;
Index: linux-2.6.22-rc3/fs/cifs/connect.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/cifs/connect.c
+++ linux-2.6.22-rc3/fs/cifs/connect.c
@@ -363,6 +363,7 @@ cifs_demultiplex_thread(struct TCP_Serve
 			GFP_KERNEL);
 	}
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
 			continue;
Index: linux-2.6.22-rc3/fs/jffs2/background.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/jffs2/background.c
+++ linux-2.6.22-rc3/fs/jffs2/background.c
@@ -81,6 +81,7 @@ static int jffs2_garbage_collect_thread(
 
 	set_user_nice(current, 10);
 
+	set_freezable();
 	for (;;) {
 		allow_signal(SIGHUP);
 
Index: linux-2.6.22-rc3/fs/lockd/clntproc.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/lockd/clntproc.c
+++ linux-2.6.22-rc3/fs/lockd/clntproc.c
@@ -268,7 +268,6 @@ static int nlm_wait_on_grace(wait_queue_
 	prepare_to_wait(queue, &wait, TASK_INTERRUPTIBLE);
 	if (!signalled ()) {
 		schedule_timeout(NLMCLNT_GRACE_WAIT);
-		try_to_freeze();
 		if (!signalled ())
 			status = 0;
 	}
Index: linux-2.6.22-rc3/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.22-rc3/fs/xfs/linux-2.6/xfs_super.c
@@ -561,6 +561,7 @@ xfssyncd(
 	bhv_vfs_sync_work_t	*work, *n;
 	LIST_HEAD		(tmp);
 
+	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
 		timeleft = schedule_timeout_interruptible(timeleft);
Index: linux-2.6.22-rc3/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.22-rc3.orig/init/do_mounts_initrd.c
+++ linux-2.6.22-rc3/init/do_mounts_initrd.c
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
--- linux-2.6.22-rc3.orig/kernel/audit.c
+++ linux-2.6.22-rc3/kernel/audit.c
@@ -411,10 +411,8 @@ static int kauditd_thread(void *dummy)
 			set_current_state(TASK_INTERRUPTIBLE);
 			add_wait_queue(&kauditd_wait, &wait);
 
-			if (!skb_queue_len(&audit_skb_queue)) {
-				try_to_freeze();
+			if (!skb_queue_len(&audit_skb_queue))
 				schedule();
-			}
 
 			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&kauditd_wait, &wait);
Index: linux-2.6.22-rc3/kernel/rtmutex-tester.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/rtmutex-tester.c
+++ linux-2.6.22-rc3/kernel/rtmutex-tester.c
@@ -275,7 +275,6 @@ static int test_func(void *data)
 
 		/* Wait for the next command to be executed */
 		schedule();
-		try_to_freeze();
 
 		if (signal_pending(current))
 			flush_signals(current);
Index: linux-2.6.22-rc3/kernel/sched.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/sched.c
+++ linux-2.6.22-rc3/kernel/sched.c
@@ -5161,8 +5161,6 @@ static int migration_thread(void *data)
 		struct migration_req *req;
 		struct list_head *head;
 
-		try_to_freeze();
-
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
@@ -5396,7 +5394,6 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
Index: linux-2.6.22-rc3/kernel/workqueue.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/workqueue.c
+++ linux-2.6.22-rc3/kernel/workqueue.c
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
--- linux-2.6.22-rc3.orig/mm/pdflush.c
+++ linux-2.6.22-rc3/mm/pdflush.c
@@ -106,13 +106,11 @@ static int __pdflush(struct pdflush_work
 		my_work->when_i_went_to_sleep = jiffies;
 		spin_unlock_irq(&pdflush_lock);
 		schedule();
-		try_to_freeze();
 		spin_lock_irq(&pdflush_lock);
 		if (!list_empty(&my_work->list)) {
 			/*
 			 * Someone woke us up, but without removing our control
-			 * structure from the global list.  swsusp will do this
-			 * in try_to_freeze()->refrigerator().  Handle it.
+			 * structure from the global list.  Handle it.
 			 */
 			my_work->fn = NULL;
 			continue;
Index: linux-2.6.22-rc3/mm/vmscan.c
===================================================================
--- linux-2.6.22-rc3.orig/mm/vmscan.c
+++ linux-2.6.22-rc3/mm/vmscan.c
@@ -1264,8 +1264,6 @@ out:
 	if (!all_zones_ok) {
 		cond_resched();
 
-		try_to_freeze();
-
 		goto loop_again;
 	}
 
@@ -1336,12 +1334,7 @@ static int kswapd(void *p)
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
-		if (!try_to_freeze()) {
-			/* We can speed up thawing tasks if we don't call
-			 * balance_pgdat after returning from the refrigerator
-			 */
-			balance_pgdat(pgdat, order);
-		}
+		balance_pgdat(pgdat, order);
 	}
 	return 0;
 }
Index: linux-2.6.22-rc3/net/core/pktgen.c
===================================================================
--- linux-2.6.22-rc3.orig/net/core/pktgen.c
+++ linux-2.6.22-rc3/net/core/pktgen.c
@@ -3326,8 +3326,6 @@ static int pktgen_thread_worker(void *ar
 			t->control &= ~(T_REMDEV);
 		}
 
-		try_to_freeze();
-
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 
Index: linux-2.6.22-rc3/net/sunrpc/svcsock.c
===================================================================
--- linux-2.6.22-rc3.orig/net/sunrpc/svcsock.c
+++ linux-2.6.22-rc3/net/sunrpc/svcsock.c
@@ -1436,7 +1436,6 @@ svc_recv(struct svc_rqst *rqstp, long ti
 	arg->len = (pages-1)*PAGE_SIZE;
 	arg->tail[0].iov_len = 0;
 
-	try_to_freeze();
 	cond_resched();
 	if (signalled())
 		return -EINTR;
@@ -1461,8 +1460,6 @@ svc_recv(struct svc_rqst *rqstp, long ti
 
 		schedule_timeout(timeout);
 
-		try_to_freeze();
-
 		spin_lock_bh(&pool->sp_lock);
 		remove_wait_queue(&rqstp->rq_wait, &wait);
 
Index: linux-2.6.22-rc3/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/kernel/apm.c
+++ linux-2.6.22-rc3/arch/i386/kernel/apm.c
@@ -2309,7 +2309,6 @@ static int __init apm_init(void)
 		remove_proc_entry("apm", NULL);
 		return err;
 	}
-	kapmd_task->flags |= PF_NOFREEZE;
 	wake_up_process(kapmd_task);
 
 	if (num_online_cpus() > 1 && !smp ) {
Index: linux-2.6.22-rc3/drivers/block/loop.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/block/loop.c
+++ linux-2.6.22-rc3/drivers/block/loop.c
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
--- linux-2.6.22-rc3.orig/drivers/char/apm-emulation.c
+++ linux-2.6.22-rc3/drivers/char/apm-emulation.c
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
--- linux-2.6.22-rc3.orig/drivers/ieee1394/ieee1394_core.c
+++ linux-2.6.22-rc3/drivers/ieee1394/ieee1394_core.c
@@ -1133,8 +1133,6 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (!kthread_should_stop()) {
 
 		INIT_LIST_HEAD(&tmp);
Index: linux-2.6.22-rc3/drivers/md/md.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/md/md.c
+++ linux-2.6.22-rc3/drivers/md/md.c
@@ -4642,7 +4642,6 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	current->flags |= PF_NOFREEZE;
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.22-rc3/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/mmc/card/queue.c
+++ linux-2.6.22-rc3/drivers/mmc/card/queue.c
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
--- linux-2.6.22-rc3.orig/drivers/mtd/mtd_blkdevs.c
+++ linux-2.6.22-rc3/drivers/mtd/mtd_blkdevs.c
@@ -80,7 +80,7 @@ static int mtd_blktrans_thread(void *arg
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
-	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
 	while (!kthread_should_stop()) {
Index: linux-2.6.22-rc3/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/scsi/libsas/sas_scsi_host.c
+++ linux-2.6.22-rc3/drivers/scsi/libsas/sas_scsi_host.c
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
--- linux-2.6.22-rc3.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.22-rc3/drivers/scsi/scsi_error.c
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
--- linux-2.6.22-rc3.orig/kernel/rcutorture.c
+++ linux-2.6.22-rc3/kernel/rcutorture.c
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
--- linux-2.6.22-rc3.orig/kernel/softirq.c
+++ linux-2.6.22-rc3/kernel/softirq.c
@@ -489,7 +489,6 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
Index: linux-2.6.22-rc3/kernel/softlockup.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/softlockup.c
+++ linux-2.6.22-rc3/kernel/softlockup.c
@@ -116,7 +116,6 @@ static int watchdog(void * __bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->flags |= PF_NOFREEZE;
 
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
Index: linux-2.6.22-rc3/net/bluetooth/bnep/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/bnep/core.c
+++ linux-2.6.22-rc3/net/bluetooth/bnep/core.c
@@ -474,7 +474,6 @@ static int bnep_session(void *arg)
 
 	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
Index: linux-2.6.22-rc3/net/bluetooth/cmtp/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/cmtp/core.c
+++ linux-2.6.22-rc3/net/bluetooth/cmtp/core.c
@@ -287,7 +287,6 @@ static int cmtp_session(void *arg)
 
 	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
Index: linux-2.6.22-rc3/net/bluetooth/hidp/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/hidp/core.c
+++ linux-2.6.22-rc3/net/bluetooth/hidp/core.c
@@ -547,7 +547,6 @@ static int hidp_session(void *arg)
 
 	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&ctrl_wait, current);
 	init_waitqueue_entry(&intr_wait, current);
Index: linux-2.6.22-rc3/net/bluetooth/rfcomm/core.c
===================================================================
--- linux-2.6.22-rc3.orig/net/bluetooth/rfcomm/core.c
+++ linux-2.6.22-rc3/net/bluetooth/rfcomm/core.c
@@ -1940,7 +1940,6 @@ static int rfcomm_run(void *unused)
 
 	daemonize("krfcommd");
 	set_user_nice(current, -10);
-	current->flags |= PF_NOFREEZE;
 
 	BT_DBG("");
 
