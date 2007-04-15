Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXDORo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXDORo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXDORo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:44:57 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48878 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753247AbXDORo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:44:57 -0400
Message-id: <28015270222408028683@wsc.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com>
	 <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz>
	 <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
	 <20070414195543.GE20376@fi.muni.cz> <20070414195543.GE20376@fi.muni.cz>
In-reply-to: <4af2d03a0704141536s36a4a0e7uc353eec6f8d340f6@mail.gmail.com>
Subject: [RFC 1/1] Char: mxser_new, fix TIOCMIWAIT
From: Jiri Slaby <jirislaby@gmail.com>
To: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: <linux-kernel@vger.kernel.org>
Cc: <osv@javad.com>
Date: Sun, 15 Apr 2007 19:45:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
> > Jiri Slaby wrote:
> > :  ioctl(fd, TIOCMIWAIT, TIOCM_CD);
> [...]
> >         Hmm, I have tried to run this, and got a machine lockup, and after
> > a minute or so the following has been printed to the console:
> 
> Hmm, the driver got shot full of holes, there's missing schedule() in
> ioctl of both drivers. I'll post a patch in the morning or during the
> day.

The attached patch should fix TIOCMIWAIT issue. Could you test it?

--

mxser_new, fix TIOCMIWAIT

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e5ef19f01ffa9b6105f10fc939a07ceb3c652ed9
tree 1567fc37283da0c8436ee43a323f91140add7e73
parent a00e6d6d5f44defe9c01be2c6a3fdf1c890917c8
author Jiri Slaby <jirislaby@gmail.com> Sun, 15 Apr 2007 19:38:46 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 15 Apr 2007 19:38:46 +0200

 drivers/char/mxser_new.c |   38 +++++++++-----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 0086b73..02b6141 100644
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
 		mx_lock(info, flags);
-		cprev = info->icount;	/* note the counters on entry */
+		cnow = info->icount;	/* note the counters on entry */
 		mx_unlock(info, flags);
 
-		add_wait_queue(&info->delta_msr_wait, &wait);
-		while (1) {
+		wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			mx_lock(info, flags);
 			cnow = info->icount;	/* atomic copy */
 			mx_unlock(info, flags);
 
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
