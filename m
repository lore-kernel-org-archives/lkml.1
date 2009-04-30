Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbZD3Rni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbZD3Rni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764728AbZD3RIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:43 -0400
Received: from kroah.org ([198.145.64.141]:56931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764688AbZD3RIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:50 2009
Message-Id: <20090430165749.877345784@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [patch 78/88] md: fix deadlock when stopping arrays
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=md-fix-deadlock-when-stopping-arrays.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[backport of 5fd3a17ed456637a224cf4ca82b9ad9d005bc8d4]

Resolve a deadlock when stopping redundant arrays, i.e. ones that
require a call to sysfs_remove_group when shutdown.  The deadlock is
summarized below:

Thread1                Thread2
-------                -------
read sysfs attribute   stop array
                       take mddev lock
                       sysfs_remove_group
sysfs_get_active
wait for mddev lock
                       wait for active

Sysrq-w:
  --------
mdmon         S 00000017  2212  4163      1
  f1982ea8 00000046 2dcf6b85 00000017 c0b23100 f2f83ed0 c0b23100 f2f8413c
  c0b23100 c0b23100 c0b1fb98 f2f8413c 00000000 f2f8413c c0b23100 f2291ecc
  00000002 c0b23100 00000000 00000017 f2f83ed0 f1982eac 00000046 c044d9dd
Call Trace:
  [<c044d9dd>] ? debug_mutex_add_waiter+0x1d/0x58
  [<c06ef451>] __mutex_lock_common+0x1d9/0x338
  [<c06ef451>] ? __mutex_lock_common+0x1d9/0x338
  [<c06ef5e3>] mutex_lock_interruptible_nested+0x33/0x3a
  [<c0634553>] ? mddev_lock+0x14/0x16
  [<c0634553>] mddev_lock+0x14/0x16
  [<c0634eda>] md_attr_show+0x2a/0x49
  [<c04e9997>] sysfs_read_file+0x93/0xf9
mdadm         D 00000017  2812  4177      1
  f0401d78 00000046 430456f8 00000017 f0401d58 f0401d20 c0b23100 f2da2c4c
  c0b23100 c0b23100 c0b1fb98 f2da2c4c 0a10fc36 00000000 c0b23100 f0401d70
  00000003 c0b23100 00000000 00000017 f2da29e0 00000001 00000002 00000000
Call Trace:
  [<c06eed1b>] schedule_timeout+0x1b/0x95
  [<c06eed1b>] ? schedule_timeout+0x1b/0x95
  [<c06eeb97>] ? wait_for_common+0x34/0xdc
  [<c044fa8a>] ? trace_hardirqs_on_caller+0x18/0x145
  [<c044fbc2>] ? trace_hardirqs_on+0xb/0xd
  [<c06eec03>] wait_for_common+0xa0/0xdc
  [<c0428c7c>] ? default_wake_function+0x0/0x12
  [<c06eeccc>] wait_for_completion+0x17/0x19
  [<c04ea620>] sysfs_addrm_finish+0x19f/0x1d1
  [<c04e920e>] sysfs_hash_and_remove+0x42/0x55
  [<c04eb4db>] sysfs_remove_group+0x57/0x86
  [<c0638086>] do_md_stop+0x13a/0x499

This has been there for a while, but is easier to trigger now that mdmon
is closely watching sysfs.

Cc: Neil Brown <neilb@suse.de>
Reported-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/md.c           |   27 ++++++++++++++++++++++++---
 include/linux/raid/md_k.h |    2 ++
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3694,6 +3694,10 @@ static int do_md_run(mddev_t * mddev)
 		return err;
 	}
 	if (mddev->pers->sync_request) {
+		/* wait for any previously scheduled redundancy groups
+		 * to be removed
+		 */
+		flush_scheduled_work();
 		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
 			printk(KERN_WARNING
 			       "md: cannot register extra attributes for %s\n",
@@ -3824,6 +3828,14 @@ static void restore_bitmap_write_access(
 	spin_unlock(&inode->i_lock);
 }
 
+
+static void sysfs_delayed_rm(struct work_struct *ws)
+{
+	mddev_t *mddev = container_of(ws, mddev_t, del_work);
+
+	sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+}
+
 /* mode:
  *   0 - completely stop and dis-assemble array
  *   1 - switch to readonly
@@ -3833,6 +3845,7 @@ static int do_md_stop(mddev_t * mddev, i
 {
 	int err = 0;
 	struct gendisk *disk = mddev->gendisk;
+	int remove_group = 0;
 
 	if (atomic_read(&mddev->openers) > is_open) {
 		printk("md: %s still in use.\n",mdname(mddev));
@@ -3868,10 +3881,9 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;
-			if (mddev->pers->sync_request)
-				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-
 			module_put(mddev->pers->owner);
+			if (mddev->pers->sync_request)
+				remove_group = 1;
 			mddev->pers = NULL;
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);
@@ -3919,6 +3931,15 @@ static int do_md_stop(mddev_t * mddev, i
 		/* make sure all md_delayed_delete calls have finished */
 		flush_scheduled_work();
 
+		/* we can't wait for group removal under mddev_lock as
+		 * threads holding the group 'active' need to acquire
+		 * mddev_lock before going inactive
+		 */
+		if (remove_group) {
+			INIT_WORK(&mddev->del_work, sysfs_delayed_rm);
+			schedule_work(&mddev->del_work);
+		}
+
 		export_array(mddev);
 
 		mddev->array_sectors = 0;
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -245,6 +245,8 @@ struct mddev_s
 							 * file in sysfs.
 							 */
 
+	struct work_struct del_work;	/* used for delayed sysfs removal */
+
 	spinlock_t			write_lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
 	atomic_t			pending_writes;	/* number of active superblock writes */


