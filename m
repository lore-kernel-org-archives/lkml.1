Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZDQTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZDQTHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZDQTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:23 -0400
Received: from kroah.org ([198.145.64.141]:51190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751966AbZDQTHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/10] sysfs: don't use global workqueue in sysfs_schedule_callback()
Date: Fri, 17 Apr 2009 12:04:25 -0700
Message-Id: <1239995074-4065-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

A sysfs attribute using sysfs_schedule_callback() to commit suicide
may end up calling device_unregister(), which will eventually call
a driver's ->remove function.

Drivers may call flush_scheduled_work() in their shutdown routines,
in which case lockdep will complain with something like the following:

  =============================================
  [ INFO: possible recursive locking detected ]
  2.6.29-rc8-kk #1
  ---------------------------------------------
  events/4/56 is trying to acquire lock:
  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0

  but task is already holding lock:
  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230

  other info that might help us debug this:
  3 locks held by events/4/56:
  #0:  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
  #1:  (&ss->work){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
  #2:  (pci_remove_rescan_mutex){--..}, at: [<ffffffff803c10d1>] remove_callback+0x21/0x40

  stack backtrace:
  Pid: 56, comm: events/4 Not tainted 2.6.29-rc8-kk #1
  Call Trace:
  [<ffffffff8026dfcd>] validate_chain+0xb7d/0x1260
  [<ffffffff8026eade>] __lock_acquire+0x42e/0xa40
  [<ffffffff8026f148>] lock_acquire+0x58/0x80
  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
  [<ffffffff8025800d>] flush_workqueue+0x4d/0xa0
  [<ffffffff80257fc0>] ? flush_workqueue+0x0/0xa0
  [<ffffffff80258070>] flush_scheduled_work+0x10/0x20
  [<ffffffffa0144065>] e1000_remove+0x55/0xfe [e1000e]
  [<ffffffff8033ee30>] ? sysfs_schedule_callback_work+0x0/0x50
  [<ffffffff803bfeb2>] pci_device_remove+0x32/0x70
  [<ffffffff80441da9>] __device_release_driver+0x59/0x90
  [<ffffffff80441edb>] device_release_driver+0x2b/0x40
  [<ffffffff804419d6>] bus_remove_device+0xa6/0x120
  [<ffffffff8043e46b>] device_del+0x12b/0x190
  [<ffffffff8043e4f6>] device_unregister+0x26/0x70
  [<ffffffff803ba969>] pci_stop_dev+0x49/0x60
  [<ffffffff803baab0>] pci_remove_bus_device+0x40/0xc0
  [<ffffffff803c10d9>] remove_callback+0x29/0x40
  [<ffffffff8033ee4f>] sysfs_schedule_callback_work+0x1f/0x50
  [<ffffffff8025769a>] run_workqueue+0x15a/0x230
  [<ffffffff80257648>] ? run_workqueue+0x108/0x230
  [<ffffffff8025846f>] worker_thread+0x9f/0x100
  [<ffffffff8025bce0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff802583d0>] ? worker_thread+0x0/0x100
  [<ffffffff8025b89d>] kthread+0x4d/0x80
  [<ffffffff8020d4ba>] child_rip+0xa/0x20
  [<ffffffff8020cebc>] ? restore_args+0x0/0x30
  [<ffffffff8025b850>] ? kthread+0x0/0x80
  [<ffffffff8020d4b0>] ? child_rip+0x0/0x20

Although we know that the device_unregister path will never acquire
a lock that a driver might try to acquire in its ->remove, in general
we should never attempt to flush a workqueue from within the same
workqueue, and lockdep rightly complains.

So as long as sysfs attributes cannot commit suicide directly and we
are stuck with this callback mechanism, put the sysfs callbacks on
their own workqueue instead of the global one.

This has the side benefit that if a suicidal sysfs attribute kicks
off a long chain of ->remove callbacks, we no longer induce a long
delay on the global queue.

This also fixes a missing module_put in the error path introduced
by sysfs-only-allow-one-scheduled-removal-callback-per-kobj.patch.

We never destroy the workqueue, but I'm not sure that's a
problem.

Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 289c43a..979e937 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -667,6 +667,7 @@ struct sysfs_schedule_callback_struct {
 	struct work_struct	work;
 };
 
+static struct workqueue_struct *sysfs_workqueue;
 static DEFINE_MUTEX(sysfs_workq_mutex);
 static LIST_HEAD(sysfs_workq);
 static void sysfs_schedule_callback_work(struct work_struct *work)
@@ -715,11 +716,20 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 	mutex_lock(&sysfs_workq_mutex);
 	list_for_each_entry_safe(ss, tmp, &sysfs_workq, workq_list)
 		if (ss->kobj == kobj) {
+			module_put(owner);
 			mutex_unlock(&sysfs_workq_mutex);
 			return -EAGAIN;
 		}
 	mutex_unlock(&sysfs_workq_mutex);
 
+	if (sysfs_workqueue == NULL) {
+		sysfs_workqueue = create_workqueue("sysfsd");
+		if (sysfs_workqueue == NULL) {
+			module_put(owner);
+			return -ENOMEM;
+		}
+	}
+
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
 	if (!ss) {
 		module_put(owner);
@@ -735,7 +745,7 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 	mutex_lock(&sysfs_workq_mutex);
 	list_add_tail(&ss->workq_list, &sysfs_workq);
 	mutex_unlock(&sysfs_workq_mutex);
-	schedule_work(&ss->work);
+	queue_work(sysfs_workqueue, &ss->work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
-- 
1.6.2

