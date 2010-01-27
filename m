Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687Ab0A0Uqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0A0Uqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574Ab0A0Uqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1545 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0A0Uqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 10/13] drivers/block/floppy.c: Add __func__ to debugt
Date: Wed, 27 Jan 2010 12:46:26 -0800
Message-Id: <64791423241155ffbadbf6d7b238e91f9688ff01.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make debugt messages a little neater

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e089b69..6124070 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -616,14 +616,14 @@ static inline void set_debugt(void)
 	debugtimer = jiffies;
 }
 
-static inline void debugt(const char *message)
+static inline void debugt(const char *func, const char *msg)
 {
 	if (DP->flags & DEBUGT)
-		pr_info("%s dtime=%lu\n", message, jiffies - debugtimer);
+		pr_info("%s:%s dtime=%lu\n", func, msg, jiffies - debugtimer);
 }
 #else
 static inline void set_debugt(void) { }
-static inline void debugt(const char *message) { }
+static inline void debugt(const char *func, const char *msg) { }
 #endif /* DEBUGT */
 
 typedef void (*timeout_fn)(unsigned long);
@@ -1533,7 +1533,7 @@ static void setup_rw_floppy(void)
 	for (i = 0; i < raw_cmd->cmd_count; i++)
 		r |= output_byte(raw_cmd->cmd[i]);
 
-	debugt("rw_command: ");
+	debugt(__func__, "rw_command");
 
 	if (r) {
 		cont->error();
@@ -1556,7 +1556,7 @@ static int blind_seek;
  */
 static void seek_interrupt(void)
 {
-	debugt("seek interrupt:");
+	debugt(__func__, "");
 	if (inr != 2 || (ST0 & 0xF8) != 0x20) {
 		DPRINT("seek failed\n");
 		DRS->track = NEED_2_RECAL;
@@ -1604,7 +1604,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-	debug_dcl(DP->flags, "calling disk change from seek\n");
+	debug_dcl(DP->flags, "calling disk change from %s\n", __func__);
 
 	if (!test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -1653,18 +1653,18 @@ static void seek_floppy(void)
 		reset_fdc();
 		return;
 	}
-	debugt("seek command:");
+	debugt(__func__, "");
 }
 
 static void recal_interrupt(void)
 {
-	debugt("recal interrupt:");
+	debugt(__func__, "");
 	if (inr != 2)
 		FDCS->reset = 1;
 	else if (ST0 & ST0_ECE) {
 		switch (DRS->track) {
 		case NEED_1_RECAL:
-			debugt("recal interrupt need 1 recal:");
+			debugt(__func__, "need 1 recal");
 			/* after a second recalibrate, we still haven't
 			 * reached track 0. Probably no drive. Raise an
 			 * error, as failing immediately might upset
@@ -1673,7 +1673,7 @@ static void recal_interrupt(void)
 			cont->redo();
 			return;
 		case NEED_2_RECAL:
-			debugt("recal interrupt need 2 recal:");
+			debugt(__func__, "need 2 recal");
 			/* If we already did a recalibrate,
 			 * and we are not at track 0, this
 			 * means we have moved. (The only way
@@ -1687,7 +1687,7 @@ static void recal_interrupt(void)
 			DRS->select_date = jiffies;
 			/* fall through */
 		default:
-			debugt("recal interrupt default:");
+			debugt(__func__, "default");
 			/* Recalibrate moves the head by at
 			 * most 80 steps. If after one
 			 * recalibrate we don't have reached
@@ -1777,7 +1777,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 
 static void recalibrate_floppy(void)
 {
-	debugt("recalibrate floppy:");
+	debugt(__func__, "");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
 	if (output_byte(UNIT(current_drive)) < 0)
@@ -1789,7 +1789,7 @@ static void recalibrate_floppy(void)
  */
 static void reset_interrupt(void)
 {
-	debugt("reset interrupt:");
+	debugt(__func__, "");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
 		pr_info("reset set in interrupt, calling %pf\n", cont->error);
@@ -2221,7 +2221,7 @@ static void redo_format(void)
 	buffer_track = -1;
 	setup_format_params(format_req.track << STRETCH(_floppy));
 	floppy_start();
-	debugt("queue format request");
+	debugt(__func__, "queue format request");
 }
 
 static struct cont_t format_cont = {
@@ -2918,7 +2918,7 @@ do_request:
 	if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
 		twaddle();
 	schedule_bh(floppy_start);
-	debugt("queue fd request");
+	debugt(__func__, "queue fd request");
 	return;
 }
 
-- 
1.6.6.rc0.57.gad7a

