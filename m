Return-Path: <linux-kernel-owner+w=401wt.eu-S1423043AbXDTKfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423043AbXDTKfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423047AbXDTKfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:35:30 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:38566 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423043AbXDTKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:35:28 -0400
Message-id: <28817262632084312972@wsc.cz>
In-reply-to: <20225157853131727049@wsc.cz>
Subject: [PATCH 2/3] Char: mxser_new, fix TIOCMIWAIT
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Date: Fri, 20 Apr 2007 12:35:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, fix TIOCMIWAIT

There was schedule() missing in the TIOCMIWAIT ioctl. Solve it by moving
the code to the wait_event_interruptible.

Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit bd99756ce7fb8f3e9105b076a71046b0d8ad1f8f
tree b04c7d06790414f91897a8b0ff7c959b2226fe2b
parent a3c71212efb38a67d344f35137136808e64537c6
author Jiri Slaby <jirislaby@gmail.com> Mon, 16 Apr 2007 13:30:31 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 16 Apr 2007 13:30:31 +0200

 drivers/char/mxser_new.c |   38 +++++++++-----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 626f491..ec4a561 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -1767,43 +1767,23 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
 		 * Caller should use TIOCGICOUNT to see which one it was
 		 */
-	case TIOCMIWAIT: {
-		DECLARE_WAITQUEUE(wait, current);
-		int ret;
+	case TIOCMIWAIT:
 		spin_lock_irqsave(&info->slock, flags);
-		cprev = info->icount;	/* note the counters on entry */
+		cnow = info->icount;	/* note the counters on entry */
 		spin_unlock_irqrestore(&info->slock, flags);
 
-		add_wait_queue(&info->delta_msr_wait, &wait);
-		while (1) {
+		wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			spin_lock_irqsave(&info->slock, flags);
 			cnow = info->icount;	/* atomic copy */
 			spin_unlock_irqrestore(&info->slock, flags);
 
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (((arg & TIOCM_RNG) &&
-					(cnow.rng != cprev.rng)) ||
-					((arg & TIOCM_DSR) &&
-					(cnow.dsr != cprev.dsr)) ||
-					((arg & TIOCM_CD) &&
-					(cnow.dcd != cprev.dcd)) ||
-					((arg & TIOCM_CTS) &&
-					(cnow.cts != cprev.cts))) {
-				ret = 0;
-				break;
-			}
-			/* see if a signal did it */
-			if (signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				break;
-			}
-			cprev = cnow;
-		}
-		current->state = TASK_RUNNING;
-		remove_wait_queue(&info->delta_msr_wait, &wait);
+			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
+		}));
 		break;
-	}
-	/* NOTREACHED */
 	/*
 	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
 	 * Return: write counters to the user passed counter struct
