Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZLBGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZLBGHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZLBGHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1222 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 10/13] drivers/block/floppy.c: Convert int initialising to bool initialized
Date: Tue,  1 Dec 2009 22:07:50 -0800
Message-Id: <bef8ad74f2bd5b3c6703f10f26801a45bad9fcc2.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't initialize initialized either.  Default is false

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cc76f3d..4a9cb15 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -290,13 +290,13 @@ static inline void fallback_on_nodma_alloc(char **addr, size_t l)
 /* End dma memory related stuff */
 
 static unsigned long fake_change;
-static int initialising = 1;
+static bool initialized;
 
 #define ITYPE(x) (((x) >> 2) & 0x1f)
 #define TOMINOR(x) ((x & 3) | ((x & 4) << 5))
-#define UNIT(x) ((x) & 0x03)	/* drive on fdc */
+#define UNIT(x) ((x) & 0x03)		/* drive on fdc */
 #define FDC(x) (((x) & 0x04) >> 2)	/* fdc of drive */
-	/* reverse mapping from unit and fdc to drive */
+				/* reverse mapping from unit and fdc to drive */
 #define REVDRIVE(fdc, unit) ((unit) + ((fdc) << 2))
 
 #define DP	(&drive_params[current_drive])
@@ -1672,7 +1672,7 @@ static int wait_til_ready(void)
 		if (status & STATUS_READY)
 			return status;
 	}
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Getstatus times out (%x) on fdc %d\n", status, fdc);
 		show_floppy();
 	}
@@ -1699,7 +1699,7 @@ static int output_byte(char byte)
 		return 0;
 	}
 	FDCS->reset = 1;
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Unable to send byte %x to FDC. Fdc=%x Status=%x\n",
 		       byte, fdc, status);
 		show_floppy();
@@ -1730,10 +1730,9 @@ static int result(void)
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
@@ -2281,7 +2280,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	 * activity.
 	 */
 
-	do_print = !handler && print_unex && !initialising;
+	do_print = !handler && print_unex && initialized;
 
 	inr = result();
 	if (do_print)
@@ -2409,7 +2408,7 @@ static void floppy_shutdown(unsigned long data)
 {
 	unsigned long flags;
 
-	if (!initialising)
+	if (initialized)
 		show_floppy();
 	cancel_activity();
 
@@ -2421,7 +2420,7 @@ static void floppy_shutdown(unsigned long data)
 
 	/* avoid dma going to a random drive after shutdown */
 
-	if (!initialising)
+	if (initialized)
 		DPRINT("floppy timeout called\n");
 	FDCS->reset = 1;
 	if (cont) {
@@ -5024,7 +5023,7 @@ static int __init floppy_init(void)
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

