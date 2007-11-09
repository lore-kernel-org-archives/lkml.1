Return-Path: <linux-kernel-owner+w=401wt.eu-S1763738AbXKIXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763738AbXKIXkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXKIXkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:40:10 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57164 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbXKIXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:40:09 -0500
Message-id: <286909174943017943.slaby@pripojeni.net>
In-reply-to: <987255352099662.slaby@pripojeni.net>
Subject: [PATCH 2/6] Char: istallion, remove hangup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:40:09 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

istallion, remove hangup bottomhalf

tty_hangup schedules a work for hangup itself, no need to do it in the driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit d55ce2f15b7233e7a4e5e1880a656c4160b69866
tree bc00e50e40466542762f07c7a87811bad90f2e6d
parent ee7ef7fcd70a75d11d05429e5ac7ac31aca381b1
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 16:14:45 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:42:09 +0100

 drivers/char/istallion.c  |   23 +----------------------
 include/linux/istallion.h |    1 -
 2 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 1f27be1..c645455 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -627,7 +627,6 @@ static int	stli_initopen(struct stlibrd *brdp, struct stliport *portp);
 static int	stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct file *filp);
-static void	stli_dohangup(struct work_struct *);
 static int	stli_setport(struct stliport *portp);
 static int	stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
@@ -1824,25 +1823,6 @@ static void stli_start(struct tty_struct *tty)
 /*****************************************************************************/
 
 /*
- *	Scheduler called hang up routine. This is called from the scheduler,
- *	not direct from the driver "poll" routine. We can't call it there
- *	since the real local hangup code will enable/disable the board and
- *	other things that we can't do while handling the poll. Much easier
- *	to deal with it some time later (don't really care when, hangups
- *	aren't that time critical).
- */
-
-static void stli_dohangup(struct work_struct *ugly_api)
-{
-	struct stliport *portp = container_of(ugly_api, struct stliport, tqhangup);
-	if (portp->tty != NULL) {
-		tty_hangup(portp->tty);
-	}
-}
-
-/*****************************************************************************/
-
-/*
  *	Hangup this port. This is pretty much like closing the port, only
  *	a little more brutal. No waiting for data to drain. Shutdown the
  *	port and maybe drop signals. This is rather tricky really. We want
@@ -2405,7 +2385,7 @@ static int stli_hostcmd(struct stlibrd *brdp, struct stliport *portp)
 			    ((portp->sigs & TIOCM_CD) == 0)) {
 				if (portp->flags & ASYNC_CHECK_CD) {
 					if (tty)
-						schedule_work(&portp->tqhangup);
+						tty_hangup(tty);
 				}
 			}
 		}
@@ -2733,7 +2713,6 @@ static int stli_initports(struct stlibrd *brdp)
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		INIT_WORK(&portp->tqhangup, stli_dohangup);
 		init_waitqueue_head(&portp->open_wait);
 		init_waitqueue_head(&portp->close_wait);
 		init_waitqueue_head(&portp->raw_wait);
diff --git a/include/linux/istallion.h b/include/linux/istallion.h
index 106a5e8..5a84fe9 100644
--- a/include/linux/istallion.h
+++ b/include/linux/istallion.h
@@ -71,7 +71,6 @@ struct stliport {
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	raw_wait;
-	struct work_struct	tqhangup;
 	struct asysigs		asig;
 	unsigned long		addr;
 	unsigned long		rxoffset;
