Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017Ab0AVEzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0AVEzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0AVEzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:55:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1368 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0AVExB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 22/24] drivers/block/floppy.c: Convert int initialising to bool initialized
Date: Thu, 21 Jan 2010 20:52:52 -0800
Message-Id: <2a9d8263bc783d5cfcaac5250a228d1653a8e0b4.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't initialize initialized either.  Default is false

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 7132ee4..2f6ed78 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -290,7 +290,7 @@ static inline void fallback_on_nodma_alloc(char **addr, size_t l)
 /* End dma memory related stuff */
 
 static unsigned long fake_change;
-static int initialising = 1;
+static bool initialized;
 
 #define ITYPE(x)	(((x) >> 2) & 0x1f)
 #define TOMINOR(x)	((x & 3) | ((x & 4) << 5))
@@ -1147,7 +1147,7 @@ static int wait_til_ready(void)
 		if (status & STATUS_READY)
 			return status;
 	}
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Getstatus times out (%x) on fdc %d\n", status, fdc);
 		show_floppy();
 	}
@@ -1173,7 +1173,7 @@ static int output_byte(char byte)
 		return 0;
 	}
 	FDCS->reset = 1;
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Unable to send byte %x to FDC. Fdc=%x Status=%x\n",
 		       byte, fdc, status);
 		show_floppy();
@@ -1204,10 +1204,9 @@ static int result(void)
 		else
 			break;
 	}
-	if (!initialising) {
-		DPRINT
-		    ("get result error. Fdc=%d Last status=%x Read bytes=%d\n",
-		     fdc, status, i);
+	if (initialized) {
+		DPRINT("get result error. Fdc=%d Last status=%x Read bytes=%d\n",
+		       fdc, status, i);
 		show_floppy();
 	}
 	FDCS->reset = 1;
@@ -1754,7 +1753,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	 * activity.
 	 */
 
-	do_print = !handler && print_unex && !initialising;
+	do_print = !handler && print_unex && initialized;
 
 	inr = result();
 	if (do_print)
@@ -1882,7 +1881,7 @@ static void floppy_shutdown(unsigned long data)
 {
 	unsigned long flags;
 
-	if (!initialising)
+	if (initialized)
 		show_floppy();
 	cancel_activity();
 
@@ -1894,7 +1893,7 @@ static void floppy_shutdown(unsigned long data)
 
 	/* avoid dma going to a random drive after shutdown */
 
-	if (!initialising)
+	if (initialized)
 		DPRINT("floppy timeout called\n");
 	FDCS->reset = 1;
 	if (cont) {
@@ -4337,7 +4336,7 @@ static int __init floppy_init(void)
 	fdc = 0;
 	del_timer(&fd_timeout);
 	current_drive = 0;
-	initialising = 0;
+	initialized = true;
 	if (have_no_fdc) {
 		DPRINT("no floppy controllers found\n");
 		err = have_no_fdc;
-- 
1.6.6.rc0.57.gad7a

