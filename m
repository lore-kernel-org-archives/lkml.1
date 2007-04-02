Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXDBFpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXDBFpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXDBFpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:45:23 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:39241 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXDBFpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:45:22 -0400
Date: Mon, 2 Apr 2007 11:12:53 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 8/8] Make kernel threads freezeable for cpu-hotplug
Message-ID: <20070402054253.GH12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes all the kernel_threads (except the migration thread)
freezeable for cpu hotplug.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

-- 
 arch/i386/kernel/apm.c              |    2 +-
 drivers/block/loop.c                |    2 +-
 drivers/char/apm-emulation.c        |    6 +++---
 drivers/ieee1394/ieee1394_core.c    |    2 +-
 drivers/md/md.c                     |    2 +-
 drivers/mmc/card/queue.c            |    2 +-
 drivers/mtd/mtd_blkdevs.c           |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 drivers/scsi/scsi_error.c           |    2 +-
 drivers/usb/storage/usb.c           |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6.21-rc5/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/apm.c
+++ linux-2.6.21-rc5/arch/i386/kernel/apm.c
@@ -1395,7 +1395,7 @@ static void apm_mainloop(void)
 
 	add_wait_queue(&apm_waitqueue, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 	for (;;) {
 		try_to_freeze();
 		schedule_timeout(APM_CHECK_TIMEOUT);
Index: linux-2.6.21-rc5/drivers/block/loop.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/block/loop.c
+++ linux-2.6.21-rc5/drivers/block/loop.c
@@ -587,7 +587,7 @@ static int loop_thread(void *data)
 	 * hence, it mustn't be stopped at all
 	 * because it could be indirectly used during suspension
 	 */
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	set_user_nice(current, -20);
 
Index: linux-2.6.21-rc5/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/apm-emulation.c
+++ linux-2.6.21-rc5/drivers/char/apm-emulation.c
@@ -336,7 +336,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			freezer_exempt(FE_ALL);
+			freezer_exempt(FE_SUSPEND_KPROBES);
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
@@ -372,7 +372,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			freezer_exempt(FE_ALL);
+			freezer_exempt(FE_SUSPEND_KPROBES);
 
 			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
@@ -536,7 +536,7 @@ static int apm_get_info(char *buf, char 
 
 static int kapmd(void *arg)
 {
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 	do {
 		apm_event_t event;
 		int ret;
Index: linux-2.6.21-rc5/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/ieee1394/ieee1394_core.c
+++ linux-2.6.21-rc5/drivers/ieee1394/ieee1394_core.c
@@ -1134,7 +1134,7 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.21-rc5/drivers/md/md.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/md/md.c
+++ linux-2.6.21-rc5/drivers/md/md.c
@@ -4527,7 +4527,7 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
Index: linux-2.6.21-rc5/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/mtd/mtd_blkdevs.c
+++ linux-2.6.21-rc5/drivers/mtd/mtd_blkdevs.c
@@ -83,7 +83,7 @@ static int mtd_blktrans_thread(void *arg
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
 	current->flags |= PF_MEMALLOC;
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	daemonize("%sd", tr->name);
 
Index: linux-2.6.21-rc5/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/libsas/sas_scsi_host.c
+++ linux-2.6.21-rc5/drivers/scsi/libsas/sas_scsi_host.c
@@ -871,7 +871,7 @@ static int sas_queue_thread(void *_sas_h
 	struct scsi_core *core = &sas_ha->core;
 
 	daemonize("sas_queue_%d", core->shost->host_no);
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	complete(&queue_th_comp);
 
Index: linux-2.6.21-rc5/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.21-rc5/drivers/scsi/scsi_error.c
@@ -1536,7 +1536,7 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
Index: linux-2.6.21-rc5/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/usb/storage/usb.c
+++ linux-2.6.21-rc5/drivers/usb/storage/usb.c
@@ -301,7 +301,7 @@ static int usb_stor_control_thread(void 
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	for(;;) {
 		try_to_freeze();
Index: linux-2.6.21-rc5/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/mmc/card/queue.c
+++ linux-2.6.21-rc5/drivers/mmc/card/queue.c
@@ -67,7 +67,7 @@ static int mmc_queue_thread(void *d)
 	 * the process freezing.  We handle suspension ourselves.
 	 */
 	current->flags |= PF_MEMALLOC;
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	down(&mq->thread_sem);
 	do {
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
