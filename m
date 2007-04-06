Return-Path: <linux-kernel-owner+w=401wt.eu-S2993022AbXDFR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993022AbXDFR7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992988AbXDFR7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:59:21 -0400
Received: from mx2.freebsd.org ([69.147.83.53]:60663 "EHLO mx2.freebsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992916AbXDFR7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:59:20 -0400
X-Greylist: delayed 1395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 13:59:20 EDT
Date: Fri, 6 Apr 2007 17:36:03 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Correctly prevent IDE timer expiry function to run if request was already handled
Message-ID: <20070406173603.GA82722@freefall.freebsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for the timer expiry function to run even though the
request has already been handled: ide_timer_expiry() only checks that
the handler is not NULL, but it is possible that we have handled a
request (thus clearing the handler) and then started a new request
(thus starting the timer again, and setting a handler). 

A simple way to exhibit this is to set the DMA timeout to 1 jiffy and
run dd: The kernel will panic after a few minutes because
ide_timer_expiry() tries to add a timer when it's already active.

To fix this, we simply add a request generation count that gets
incremented at every interrupt, and check in ide_timer_expiry() that
we have not already handled a new interrupt before running the expiry
function.

Signed-off-by:	Suleiman Souhlal <suleiman@google.com>

---
 drivers/ide/ide-io.c   |    6 +++++-
 drivers/ide/ide-iops.c |    2 ++
 include/linux/ide.h    |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0e02800..8670112 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1226,6 +1226,7 @@ #if 1
 #endif
 				/* so that ide_timer_expiry knows what to do */
 				hwgroup->sleeping = 1;
+				hwgroup->req_gen_timer = hwgroup->req_gen;
 				mod_timer(&hwgroup->timer, sleep);
 				/* we purposely leave hwgroup->busy==1
 				 * while sleeping */
@@ -1411,7 +1412,8 @@ void ide_timer_expiry (unsigned long dat
 
 	spin_lock_irqsave(&ide_lock, flags);
 
-	if ((handler = hwgroup->handler) == NULL) {
+	if (((handler = hwgroup->handler) == NULL) ||
+	    (hwgroup->req_gen != hwgroup->req_gen_timer)) {
 		/*
 		 * Either a marginal timeout occurred
 		 * (got the interrupt just as timer expired),
@@ -1439,6 +1441,7 @@ void ide_timer_expiry (unsigned long dat
 				if ((wait = expiry(drive)) > 0) {
 					/* reset timer */
 					hwgroup->timer.expires  = jiffies + wait;
+					hwgroup->req_gen_timer = hwgroup->req_gen;
 					add_timer(&hwgroup->timer);
 					spin_unlock_irqrestore(&ide_lock, flags);
 					return;
@@ -1653,6 +1656,7 @@ #endif /* CONFIG_BLK_DEV_IDEPCI */
 		printk(KERN_ERR "%s: ide_intr: hwgroup->busy was 0 ??\n", drive->name);
 	}
 	hwgroup->handler = NULL;
+	hwgroup->req_gen++;
 	del_timer(&hwgroup->timer);
 	spin_unlock(&ide_lock);
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 1ee53a5..3caa176 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -889,6 +889,7 @@ static void __ide_set_handler (ide_drive
 	hwgroup->handler	= handler;
 	hwgroup->expiry		= expiry;
 	hwgroup->timer.expires	= jiffies + timeout;
+	hwgroup->req_gen_timer = hwgroup->req_gen;
 	add_timer(&hwgroup->timer);
 }
 
@@ -929,6 +930,7 @@ void ide_execute_command(ide_drive_t *dr
 	hwgroup->handler	= handler;
 	hwgroup->expiry		= expiry;
 	hwgroup->timer.expires	= jiffies + timeout;
+	hwgroup->req_gen_timer = hwgroup->req_gen;
 	add_timer(&hwgroup->timer);
 	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
 	/* Drive takes 400nS to respond, we must avoid the IRQ being
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 58564a1..d3bbc71 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -861,6 +861,8 @@ typedef struct hwgroup_s {
 	int (*expiry)(ide_drive_t *);
 		/* ide_system_bus_speed */
 	int pio_clock;
+	int req_gen;
+	int req_gen_timer;
 
 	unsigned char cmd_buf[4];
 } ide_hwgroup_t;
