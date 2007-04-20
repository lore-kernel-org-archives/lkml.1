Return-Path: <linux-kernel-owner+w=401wt.eu-S1767042AbXDTKgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767042AbXDTKgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767050AbXDTKgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:36:14 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:38572 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767042AbXDTKgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:36:13 -0400
Message-id: <28921299193042021193@wsc.cz>
In-reply-to: <20225157853131727049@wsc.cz>
Subject: [PATCH 3/3] Char: mxser, fix TIOCMIWAIT
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2007 12:36:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser, fix TIOCMIWAIT

There was schedule() missing in the TIOCMIWAIT ioctl. Solve it by moving
the code to the wait_event_interruptible.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 88c99e7bd7356c4b5a960f4a2b631d980bddc337
tree 4d713ce58282145839d6223a849c32a791e25a93
parent bd99756ce7fb8f3e9105b076a71046b0d8ad1f8f
author Jiri Slaby <jirislaby@gmail.com> Fri, 20 Apr 2007 12:26:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 20 Apr 2007 12:26:08 +0200

 drivers/char/mxser.c |   48 ++++++++++++++----------------------------------
 1 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 573b271..5953a45 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1337,43 +1337,23 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file, unsigned int c
 		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
 		 * Caller should use TIOCGICOUNT to see which one it was
 		 */
-	case TIOCMIWAIT: {
-			DECLARE_WAITQUEUE(wait, current);
-			int ret;
+	case TIOCMIWAIT:
+		spin_lock_irqsave(&info->slock, flags);
+		cnow = info->icount;	/* note the counters on entry */
+		spin_unlock_irqrestore(&info->slock, flags);
+
+		wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			spin_lock_irqsave(&info->slock, flags);
-			cprev = info->icount;	/* note the counters on entry */
+			cnow = info->icount;	/* atomic copy */
 			spin_unlock_irqrestore(&info->slock, flags);
 
-			add_wait_queue(&info->delta_msr_wait, &wait);
-			while (1) {
-				spin_lock_irqsave(&info->slock, flags);
-				cnow = info->icount;	/* atomic copy */
-				spin_unlock_irqrestore(&info->slock, flags);
-
-				set_current_state(TASK_INTERRUPTIBLE);
-				if (((arg & TIOCM_RNG) &&
-						(cnow.rng != cprev.rng)) ||
-						((arg & TIOCM_DSR) &&
-						(cnow.dsr != cprev.dsr)) ||
-						((arg & TIOCM_CD) &&
-						(cnow.dcd != cprev.dcd)) ||
-						((arg & TIOCM_CTS) &&
-						(cnow.cts != cprev.cts))) {
-					ret = 0;
-					break;
-				}
-				/* see if a signal did it */
-				if (signal_pending(current)) {
-					ret = -ERESTARTSYS;
-					break;
-				}
-				cprev = cnow;
-			}
-			current->state = TASK_RUNNING;
-			remove_wait_queue(&info->delta_msr_wait, &wait);
-			break;
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
 		 * Return: write counters to the user passed counter struct
