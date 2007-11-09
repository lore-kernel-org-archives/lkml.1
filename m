Return-Path: <linux-kernel-owner+w=401wt.eu-S1763948AbXKIXlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763948AbXKIXlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXKIXlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:41:31 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57179 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763955AbXKIXla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:41:30 -0500
Message-id: <125803142268083366.slaby@pripojeni.net>
In-reply-to: <987255352099662.slaby@pripojeni.net>
Subject: [PATCH 4/6] Char: stallion, remove bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:41:30 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stallion, remove bottomhalf

- tty_hangup schedules a bottomhalf itself, tty_wakeup doesn't need it
- call the CD code (part of work handler previously) directly from the code
  (it wakes somebody up or calls tty_hangup at worse)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 695ec3fa93346e03d33392504ca99aaaeb4cb5f7
tree 70fd73f9647f302e08082555cb45b1bdbdcfc3da
parent fb6091801dc98a44bd22f04acd4e66524eb0be9c
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 16:27:41 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:42:56 +0100

 drivers/char/stallion.c  |   68 ++++++++++++++++------------------------------
 include/linux/stallion.h |    1 -
 2 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 5050aa5..feac54e 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -145,8 +145,7 @@ static struct stlbrd		*stl_brds[STL_MAXBRDS];
  */
 #define	ASYI_TXBUSY	1
 #define	ASYI_TXLOW	2
-#define	ASYI_DCDCHANGE	3
-#define	ASYI_TXFLOWED	4
+#define	ASYI_TXFLOWED	3
 
 /*
  *	Define an array of board names as printable strings. Handy for
@@ -610,6 +609,23 @@ static const struct file_operations	stl_fsiomem = {
 
 static struct class *stallion_class;
 
+static void stl_cd_change(struct stlport *portp)
+{
+	unsigned int oldsigs = portp->sigs;
+
+	if (!portp->tty)
+		return;
+
+	portp->sigs = stl_getsignals(portp);
+
+	if ((portp->sigs & TIOCM_CD) && ((oldsigs & TIOCM_CD) == 0))
+		wake_up_interruptible(&portp->open_wait);
+
+	if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
+		if (portp->flags & ASYNC_CHECK_CD)
+			tty_hangup(portp->tty);
+}
+
 /*
  *	Check for any arguments passed in on the module load command line.
  */
@@ -1771,41 +1787,6 @@ static int stl_echpci64intr(struct stlbrd *brdp)
 /*****************************************************************************/
 
 /*
- *	Service an off-level request for some channel.
- */
-static void stl_offintr(struct work_struct *work)
-{
-	struct stlport		*portp = container_of(work, struct stlport, tqueue);
-	struct tty_struct	*tty;
-	unsigned int		oldsigs;
-
-	pr_debug("stl_offintr(portp=%p)\n", portp);
-
-	if (portp == NULL)
-		return;
-
-	tty = portp->tty;
-	if (tty == NULL)
-		return;
-
-	if (test_bit(ASYI_TXLOW, &portp->istate))
-		tty_wakeup(tty);
-
-	if (test_bit(ASYI_DCDCHANGE, &portp->istate)) {
-		clear_bit(ASYI_DCDCHANGE, &portp->istate);
-		oldsigs = portp->sigs;
-		portp->sigs = stl_getsignals(portp);
-		if ((portp->sigs & TIOCM_CD) && ((oldsigs & TIOCM_CD) == 0))
-			wake_up_interruptible(&portp->open_wait);
-		if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
-			if (portp->flags & ASYNC_CHECK_CD)
-				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
-	}
-}
-
-/*****************************************************************************/
-
-/*
  *	Initialize all the ports on a panel.
  */
 
@@ -1840,7 +1821,6 @@ static int __devinit stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		INIT_WORK(&portp->tqueue, stl_offintr);
 		init_waitqueue_head(&portp->open_wait);
 		init_waitqueue_head(&portp->close_wait);
 		portp->stats.brd = portp->brdnr;
@@ -3530,7 +3510,8 @@ static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		schedule_work(&portp->tqueue);
+		if (portp->tty)
+			tty_wakeup(portp->tty);
 	}
 
 	if (len == 0) {
@@ -3693,8 +3674,7 @@ static void stl_cd1400mdmisr(struct stlpanel *panelp, int ioaddr)
 	outb((MISR + portp->uartaddr), ioaddr);
 	misr = inb(ioaddr + EREG_DATA);
 	if (misr & MISR_DCD) {
-		set_bit(ASYI_DCDCHANGE, &portp->istate);
-		schedule_work(&portp->tqueue);
+		stl_cd_change(portp);
 		portp->stats.modem++;
 	}
 
@@ -4448,7 +4428,8 @@ static void stl_sc26198txisr(struct stlport *portp)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		schedule_work(&portp->tqueue); 
+		if (portp->tty)
+			tty_wakeup(portp->tty);
 	}
 
 	if (len == 0) {
@@ -4649,8 +4630,7 @@ static void stl_sc26198otherisr(struct stlport *portp, unsigned int iack)
 	case CIR_SUBCOS:
 		ipr = stl_sc26198getreg(portp, IPR);
 		if (ipr & IPR_DCDCHANGE) {
-			set_bit(ASYI_DCDCHANGE, &portp->istate);
-			schedule_work(&portp->tqueue); 
+			stl_cd_change(portp);
 			portp->stats.modem++;
 		}
 		break;
diff --git a/include/linux/stallion.h b/include/linux/stallion.h
index 94b4a10..0424d75 100644
--- a/include/linux/stallion.h
+++ b/include/linux/stallion.h
@@ -95,7 +95,6 @@ struct stlport {
 	struct tty_struct	*tty;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	struct work_struct	tqueue;
 	comstats_t		stats;
 	struct stlrq		tx;
 };
