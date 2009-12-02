Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZLBGKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZLBGKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZLBGKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:10:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1222 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZLBGHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:48 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 02/13] drivers/block/floppy.c: Add debug_dcl(...) macro
Date: Tue,  1 Dec 2009 22:07:42 -0800
Message-Id: <6893b9273b0df193cb5fab0965213fda797dd6a2.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
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
index 3e3e5fe..cacb0dd 100644
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
@@ -1274,14 +1283,12 @@ static int disk_change(int drive)
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
@@ -1330,10 +1337,8 @@ static int set_dor(int fdc, char mask, char data)
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
@@ -1546,10 +1551,7 @@ static void cancel_activity(void)
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
@@ -2110,12 +2112,9 @@ static void seek_interrupt(void)
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
@@ -2135,12 +2134,9 @@ static void check_wp(void)
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
@@ -2154,10 +2150,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from seek\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from seek\n");
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -2233,10 +2226,8 @@ static void recal_interrupt(void)
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
@@ -2496,10 +2487,7 @@ static void floppy_ready(void)
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
@@ -2530,10 +2518,7 @@ static void floppy_start(void)
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
@@ -3552,10 +3537,7 @@ static int poll_drive(int interruptible, int flag)
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
@@ -3817,10 +3799,7 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
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

