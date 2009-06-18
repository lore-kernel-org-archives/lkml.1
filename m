Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZFRHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZFRHnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZFRHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:14 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47391 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbZFRHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 10/13] Char: cyclades, ioctls cleanup
Date: Thu, 18 Jun 2009 09:41:45 +0200
Message-Id: <1245310908-27691-10-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add a cy_ prefix to functions with changed prototypes
- cy_get_serial_info: initialize serial_struct by initializer,
  save a memset
- inline simple functions (get_mon_info, {s,g}et_default_threshold,
  {s,g}et_default_timeout) directly in the ioctl handler
- add a cy_cflags_changed helper to not copy its code by
  wait_event_interruptible
- remove some ret_val = 0 assignments, it's preset to 0
- TIOCGICOUNT: don't do many put_user's, do one copy_to_user

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |  179 ++++++++++++++++++-----------------------------
 1 files changed, 67 insertions(+), 112 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 5dd176d..934eebe 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2410,29 +2410,25 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	}
 }				/* set_line_char */
 
-static int
-get_serial_info(struct cyclades_port *info,
+static int cy_get_serial_info(struct cyclades_port *info,
 		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
 	struct cyclades_card *cinfo = info->card;
-
-	if (!retinfo)
-		return -EFAULT;
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->line;
-	tmp.port = (info->card - cy_card) * 0x100 + info->line -
-		cinfo->first_line;
-	tmp.irq = cinfo->irq;
-	tmp.flags = info->port.flags;
-	tmp.close_delay = info->port.close_delay;
-	tmp.closing_wait = info->port.closing_wait;
-	tmp.baud_base = info->baud;
-	tmp.custom_divisor = info->custom_divisor;
-	tmp.hub6 = 0;		/*!!! */
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->line,
+		.port = (info->card - cy_card) * 0x100 + info->line -
+			cinfo->first_line,
+		.irq = cinfo->irq,
+		.flags = info->port.flags,
+		.close_delay = info->port.close_delay,
+		.closing_wait = info->port.closing_wait,
+		.baud_base = info->baud,
+		.custom_divisor = info->custom_divisor,
+		.hub6 = 0,		/*!!! */
+	};
 	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
-}				/* get_serial_info */
+}
 
 static int
 cy_set_serial_info(struct cyclades_port *info, struct tty_struct *tty,
@@ -2711,18 +2707,6 @@ static int cy_break(struct tty_struct *tty, int break_state)
 	return retval;
 }				/* cy_break */
 
-static int get_mon_info(struct cyclades_port *info,
-				struct cyclades_monitor __user *mon)
-{
-	if (copy_to_user(mon, &info->mon, sizeof(struct cyclades_monitor)))
-		return -EFAULT;
-	info->mon.int_count = 0;
-	info->mon.char_count = 0;
-	info->mon.char_max = 0;
-	info->mon.char_last = 0;
-	return 0;
-}				/* get_mon_info */
-
 static int set_threshold(struct cyclades_port *info, unsigned long value)
 {
 	struct cyclades_card *card;
@@ -2772,19 +2756,6 @@ static int get_threshold(struct cyclades_port *info,
 	return 0;
 }				/* get_threshold */
 
-static int set_default_threshold(struct cyclades_port *info,
-							unsigned long value)
-{
-	info->default_threshold = value & 0x0f;
-	return 0;
-}				/* set_default_threshold */
-
-static int get_default_threshold(struct cyclades_port *info,
-						unsigned long __user *value)
-{
-	return put_user(info->default_threshold, value);
-}				/* get_default_threshold */
-
 static int set_timeout(struct cyclades_port *info, unsigned long value)
 {
 	struct cyclades_card *card;
@@ -2829,17 +2800,26 @@ static int get_timeout(struct cyclades_port *info,
 	return 0;
 }				/* get_timeout */
 
-static int set_default_timeout(struct cyclades_port *info, unsigned long value)
+static int cy_cflags_changed(struct cyclades_port *info, unsigned long arg,
+		struct cyclades_icount *cprev)
 {
-	info->default_timeout = value & 0xff;
-	return 0;
-}				/* set_default_timeout */
+	struct cyclades_icount cnow;
+	unsigned long flags;
+	int ret;
 
-static int get_default_timeout(struct cyclades_port *info,
-					unsigned long __user *value)
-{
-	return put_user(info->default_timeout, value);
-}				/* get_default_timeout */
+	spin_lock_irqsave(&info->card->card_lock, flags);
+	cnow = info->icount;	/* atomic copy */
+	spin_unlock_irqrestore(&info->card->card_lock, flags);
+
+	ret =	((arg & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
+		((arg & TIOCM_DSR) && (cnow.dsr != cprev->dsr)) ||
+		((arg & TIOCM_CD)  && (cnow.dcd != cprev->dcd)) ||
+		((arg & TIOCM_CTS) && (cnow.cts != cprev->cts));
+
+	*cprev = cnow;
+
+	return ret;
+}
 
 /*
  * This routine allows the tty driver to implement device-
@@ -2851,8 +2831,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	 unsigned int cmd, unsigned long arg)
 {
 	struct cyclades_port *info = tty->driver_data;
-	struct cyclades_icount cprev, cnow;	/* kernel counter temps */
-	struct serial_icounter_struct __user *p_cuser;	/* user space */
+	struct cyclades_icount cnow;	/* kernel counter temps */
 	int ret_val = 0;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
@@ -2868,7 +2847,11 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 
 	switch (cmd) {
 	case CYGETMON:
-		ret_val = get_mon_info(info, argp);
+		if (copy_to_user(argp, &info->mon, sizeof(info->mon))) {
+			ret_val = -EFAULT;
+			break;
+		}
+		memset(&info->mon, 0, sizeof(info->mon));
 		break;
 	case CYGETTHRESH:
 		ret_val = get_threshold(info, argp);
@@ -2877,10 +2860,11 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		ret_val = set_threshold(info, arg);
 		break;
 	case CYGETDEFTHRESH:
-		ret_val = get_default_threshold(info, argp);
+		ret_val = put_user(info->default_threshold,
+				(unsigned long __user *)argp);
 		break;
 	case CYSETDEFTHRESH:
-		ret_val = set_default_threshold(info, arg);
+		info->default_threshold = arg & 0x0f;
 		break;
 	case CYGETTIMEOUT:
 		ret_val = get_timeout(info, argp);
@@ -2889,21 +2873,20 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		ret_val = set_timeout(info, arg);
 		break;
 	case CYGETDEFTIMEOUT:
-		ret_val = get_default_timeout(info, argp);
+		ret_val = put_user(info->default_timeout,
+				(unsigned long __user *)argp);
 		break;
 	case CYSETDEFTIMEOUT:
-		ret_val = set_default_timeout(info, arg);
+		info->default_timeout = arg & 0xff;
 		break;
 	case CYSETRFLOW:
 		info->rflow = (int)arg;
-		ret_val = 0;
 		break;
 	case CYGETRFLOW:
 		ret_val = info->rflow;
 		break;
 	case CYSETRTSDTR_INV:
 		info->rtsdtr_inv = (int)arg;
-		ret_val = 0;
 		break;
 	case CYGETRTSDTR_INV:
 		ret_val = info->rtsdtr_inv;
@@ -2914,7 +2897,6 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 #ifndef CONFIG_CYZ_INTR
 	case CYZSETPOLLCYCLE:
 		cyz_polling_cycle = (arg * HZ) / 1000;
-		ret_val = 0;
 		break;
 	case CYZGETPOLLCYCLE:
 		ret_val = (cyz_polling_cycle * 1000) / HZ;
@@ -2922,13 +2904,12 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 #endif				/* CONFIG_CYZ_INTR */
 	case CYSETWAIT:
 		info->port.closing_wait = (unsigned short)arg * HZ / 100;
-		ret_val = 0;
 		break;
 	case CYGETWAIT:
 		ret_val = info->port.closing_wait / (HZ / 100);
 		break;
 	case TIOCGSERIAL:
-		ret_val = get_serial_info(info, argp);
+		ret_val = cy_get_serial_info(info, argp);
 		break;
 	case TIOCSSERIAL:
 		ret_val = cy_set_serial_info(info, tty, argp);
@@ -2947,17 +2928,8 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		/* note the counters on entry */
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		ret_val = wait_event_interruptible(info->delta_msr_wait, ({
-			cprev = cnow;
-			spin_lock_irqsave(&info->card->card_lock, flags);
-			cnow = info->icount;	/* atomic copy */
-			spin_unlock_irqrestore(&info->card->card_lock, flags);
-
-			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
-		}));
+		ret_val = wait_event_interruptible(info->delta_msr_wait,
+				cy_cflags_changed(info, arg, &cnow));
 		break;
 
 		/*
@@ -2966,46 +2938,29 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		 * NB: both 1->0 and 0->1 transitions are counted except for
 		 *     RI where only 0->1 is counted.
 		 */
-	case TIOCGICOUNT:
+	case TIOCGICOUNT: {
+		struct serial_icounter_struct sic = { };
+
 		spin_lock_irqsave(&info->card->card_lock, flags);
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		p_cuser = argp;
-		ret_val = put_user(cnow.cts, &p_cuser->cts);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.rng, &p_cuser->rng);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.rx, &p_cuser->rx);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.tx, &p_cuser->tx);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.frame, &p_cuser->frame);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.parity, &p_cuser->parity);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.brk, &p_cuser->brk);
-		if (ret_val)
-			break;
-		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
-		if (ret_val)
-			break;
-		ret_val = 0;
+
+		sic.cts = cnow.cts;
+		sic.dsr = cnow.dsr;
+		sic.rng = cnow.rng;
+		sic.dcd = cnow.dcd;
+		sic.rx = cnow.rx;
+		sic.tx = cnow.tx;
+		sic.frame = cnow.frame;
+		sic.overrun = cnow.overrun;
+		sic.parity = cnow.parity;
+		sic.brk = cnow.brk;
+		sic.buf_overrun = cnow.buf_overrun;
+
+		if (copy_to_user(argp, &sic, sizeof(sic)))
+			ret_val = -EFAULT;
 		break;
+	}
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
-- 
1.6.3.2

