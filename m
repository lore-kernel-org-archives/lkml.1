Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXD2VBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXD2VBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161292AbXD2VBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:01:15 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48241 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161311AbXD2VBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:01:12 -0400
Message-id: <9252677022273619@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 12/21] Char: cyclades, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:01:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove sleep_on

convert to wait_* and completion

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 300e8efee2151f3bd26ed824f932fba53a7313f4
tree 02665558209c35460450f9ac28159d8aa5c8ea2e
parent fcc653d03162d0c14053a2fca345ae8aa1eff924
author Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 00:15:42 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:15 +0200

 drivers/char/cyclades.c  |   45 ++++++++++++++++-----------------------------
 include/linux/cyclades.h |    2 +-
 2 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9bec4ef..c236e9f 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -947,7 +947,7 @@ do_softint(struct work_struct *work)
 	tty_wakeup(tty);
 #ifdef Z_WAKE
 	if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event))
-		wake_up_interruptible(&info->shutdown_wait);
+		complete(&info->shutdown_wait);
 #endif
 } /* do_softint */
 
@@ -2324,9 +2324,8 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING) {
-			interruptible_sleep_on(&info->close_wait);
-		}
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2597,8 +2596,8 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2805,7 +2804,7 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 					"ttyC%d was %x\n", info->line, retval);
 			}
 			CY_UNLOCK(info, flags);
-			interruptible_sleep_on(&info->shutdown_wait);
+			wait_for_completion_interruptible(&info->shutdown_wait);
 			CY_LOCK(info, flags);
 		}
 #endif
@@ -4091,32 +4090,20 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCMIWAIT:
 		CY_LOCK(info, flags);
 		/* note the counters on entry */
-		cprev = info->icount;
+		cnow = info->icount;
 		CY_UNLOCK(info, flags);
-		while (1) {
-			interruptible_sleep_on(&info->delta_msr_wait);
-			/* see if a signal did it */
-			if (signal_pending(current)) {
-				return -ERESTARTSYS;
-			}
-
+		ret_val = wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			CY_LOCK(info, flags);
 			cnow = info->icount;	/* atomic copy */
 			CY_UNLOCK(info, flags);
 
-			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-				return -EIO;	/* no change => error */
-			}
-			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			    ((arg & TIOCM_CD) && (cnow.dcd != cprev.dcd)) ||
-			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-				return 0;
-			}
-			cprev = cnow;
-		}
-		/* NOTREACHED */
+			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
+		}));
+		break;
 
 		/*
 		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
@@ -4534,7 +4521,7 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo)
 		INIT_WORK(&info->tqueue, do_softint);
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->close_wait);
-		init_waitqueue_head(&info->shutdown_wait);
+		init_completion(&info->shutdown_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
 
 		if (IS_CYC_Z(*cinfo)) {
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 121d64c..cdd7739 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -588,7 +588,7 @@ struct cyclades_port {
 	struct work_struct	tqueue;
 	wait_queue_head_t       open_wait;
 	wait_queue_head_t       close_wait;
-	wait_queue_head_t       shutdown_wait;
+	struct completion       shutdown_wait;
 	wait_queue_head_t       delta_msr_wait;
 	int throttle;
 };
