Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717Ab0AVE4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0AVE4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087Ab0AVE4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1346 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/24] drivers/block/floppy.c: Add debug_dcl(...) macro
Date: Thu, 21 Jan 2010 20:52:44 -0800
Message-Id: <2334164fc86e25839f15e6d6492d557ecac6585e.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted #ifdef DCL_DEBUG if (test) DPRINTK(...); #endif
to debug_dcl(test, ...);

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   83 ++++++++++++++++++------------------------------
 1 files changed, 31 insertions(+), 52 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index de7b222..f90bc22 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -152,6 +152,15 @@
 #define DEBUGT 2
 #define DCL_DEBUG		/* debug disk change line */
 
+#ifdef DCL_DEBUG
+#define debug_dcl(test, fmt, args...) \
+	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
+#else
+#define debug_dcl(test, fmt, args...) \
+	do { if (0) DPRINT(fmt, ##args); } while (0)
+#endif
+
+
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
 #include <linux/module.h>
@@ -748,14 +757,12 @@ static int disk_change(int drive)
 	}
 #endif
 
-#ifdef DCL_DEBUG
-	if (UDP->flags & FD_DEBUG) {
-		DPRINT("checking disk change line for drive %d\n", drive);
-		DPRINT("jiffies=%lu\n", jiffies);
-		DPRINT("disk change line=%x\n", fd_inb(FD_DIR) & 0x80);
-		DPRINT("flags=%lx\n", UDRS->flags);
-	}
-#endif
+	debug_dcl(UDP->flags,
+		  "checking disk change line for drive %d\n", drive);
+	debug_dcl(UDP->flags, "jiffies=%lu\n", jiffies);
+	debug_dcl(UDP->flags, "disk change line=%x\n", fd_inb(FD_DIR) & 0x80);
+	debug_dcl(UDP->flags, "flags=%lx\n", UDRS->flags);
+
 	if (UDP->flags & FD_BROKEN_DCL)
 		return UTESTF(FD_DISK_CHANGED);
 	if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
@@ -804,10 +811,8 @@ static int set_dor(int fdc, char mask, char data)
 		unit = olddor & 0x3;
 		if (is_selected(olddor, unit) && !is_selected(newdor, unit)) {
 			drive = REVDRIVE(fdc, unit);
-#ifdef DCL_DEBUG
-			if (UDP->flags & FD_DEBUG)
-				DPRINT("calling disk change from set_dor\n");
-#endif
+			debug_dcl(UDP->flags,
+				  "calling disk change from set_dor\n");
 			disk_change(drive);
 		}
 		FDCS->dor = newdor;
@@ -1020,10 +1025,7 @@ static void cancel_activity(void)
  * transfer */
 static void fd_watchdog(void)
 {
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from watchdog\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from watchdog\n");
 
 	if (disk_change(current_drive)) {
 		DPRINT("disk removed during i/o\n");
@@ -1582,12 +1584,9 @@ static void seek_interrupt(void)
 		return;
 	}
 	if (DRS->track >= 0 && DRS->track != ST1 && !blind_seek) {
-#ifdef DCL_DEBUG
-		if (DP->flags & FD_DEBUG) {
-			DPRINT("clearing NEWCHANGE flag because of effective seek\n");
-			DPRINT("jiffies=%lu\n", jiffies);
-		}
-#endif
+		debug_dcl(DP->flags,
+			  "clearing NEWCHANGE flag because of effective seek\n");
+		debug_dcl(DP->flags, "jiffies=%lu\n", jiffies);
 		CLEARF(FD_DISK_NEWCHANGE);	/* effective seek */
 		DRS->select_date = jiffies;
 	}
@@ -1607,12 +1606,9 @@ static void check_wp(void)
 		}
 		CLEARF(FD_VERIFY);
 		CLEARF(FD_NEED_TWADDLE);
-#ifdef DCL_DEBUG
-		if (DP->flags & FD_DEBUG) {
-			DPRINT("checking whether disk is write protected\n");
-			DPRINT("wp=%x\n", ST3 & 0x40);
-		}
-#endif
+		debug_dcl(DP->flags,
+			  "checking whether disk is write protected\n");
+		debug_dcl(DP->flags, "wp=%x\n", ST3 & 0x40);
 		if (!(ST3 & 0x40))
 			SETF(FD_DISK_WRITABLE);
 		else
@@ -1626,10 +1622,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from seek\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from seek\n");
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -1705,10 +1698,8 @@ static void recal_interrupt(void)
 			 * not to move at recalibration is to
 			 * be already at track 0.) Clear the
 			 * new change flag */
-#ifdef DCL_DEBUG
-			if (DP->flags & FD_DEBUG)
-				DPRINT("clearing NEWCHANGE flag because of second recalibrate\n");
-#endif
+			debug_dcl(DP->flags,
+				  "clearing NEWCHANGE flag because of second recalibrate\n");
 
 			CLEARF(FD_DISK_NEWCHANGE);
 			DRS->select_date = jiffies;
@@ -1968,10 +1959,7 @@ static void floppy_ready(void)
 	if (fdc_dtr())
 		return;
 
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from floppy_ready\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from floppy_ready\n");
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
 		twaddle();	/* this clears the dcl on certain
@@ -2002,10 +1990,7 @@ static void floppy_start(void)
 	reschedule_timeout(current_reqD, "floppy start", 0);
 
 	scandrives();
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("setting NEWCHANGE in floppy_start\n");
-#endif
+	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
 	SETF(FD_DISK_NEWCHANGE);
 	floppy_ready();
 }
@@ -3024,10 +3009,7 @@ static int poll_drive(int interruptible, int flag)
 	raw_cmd->track = 0;
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("setting NEWCHANGE in poll_drive\n");
-#endif
+	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	SETF(FD_DISK_NEWCHANGE);
 	WAIT(floppy_ready);
 	return ret;
@@ -3290,10 +3272,7 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
 	raw_cmd = my_raw_cmd;
 	cont = &raw_cmd_cont;
 	ret = wait_til_done(floppy_start, 1);
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from raw_cmd ioctl\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from raw_cmd ioctl\n");
 
 	if (ret != -EINTR && FDCS->reset)
 		ret = -EIO;
-- 
1.6.6.rc0.57.gad7a

