Return-Path: <linux-kernel-owner+w=401wt.eu-S1762434AbXE1NbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434AbXE1NbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbXE1NbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:31:14 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35830 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755930AbXE1NbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:31:13 -0400
Message-id: <3026996181117418@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 8/8] Char: vt_ioctl, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 28 May 2007 15:31:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vt_ioctl, use wait_event_interruptible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fbe1931e02f11b2fef771ff1698f1598b3567520
tree fcfcd72a5619f6e26598ac2ee3132aed4b070987
parent c025c4b3eca99f50b05bc24c445b861e91226539
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:58:17 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:58:17 +0200

 drivers/char/vt_ioctl.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c6f6f42..2056367 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1035,12 +1035,8 @@ static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
 int vt_waitactive(int vt)
 {
 	int retval;
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&vt_activate_queue, &wait);
-	for (;;) {
-		retval = 0;
 
+	return wait_event_interruptible(vt_activate_queue, ({
 		/*
 		 * Synchronize with redraw_screen(). By acquiring the console
 		 * semaphore we make sure that the console switch is completed
@@ -1049,20 +1045,10 @@ int vt_waitactive(int vt)
 		 * updated, but the console switch hasn't been completed.
 		 */
 		acquire_console_sem();
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (vt == fg_console) {
-			release_console_sem();
-			break;
-		}
+		retval = vt == fg_console;
 		release_console_sem();
-		retval = -EINTR;
-		if (signal_pending(current))
-			break;
-		schedule();
-	}
-	remove_wait_queue(&vt_activate_queue, &wait);
-	__set_current_state(TASK_RUNNING);
-	return retval;
+		retval;
+	}));
 }
 
 #define vt_wake_waitactive() wake_up(&vt_activate_queue)
