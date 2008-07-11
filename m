Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYGKQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYGKQBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYGKQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:01:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51683 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671AbYGKQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:01:25 -0400
Date: Fri, 11 Jul 2008 16:42:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "alan@redhat.com" <alan@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Message-ID: <20080711164221.163ab1df@lxorguk.ukuu.org.uk>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 13:46:49 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> This driver is "hidden" in arch/ia64 ... so it didn't get updated
> by the Ldisc revamp.

How does this look instead

simserial: Fix up for ldisc changes

From: Alan Cox <alan@redhat.com>

Noted by Tony Luck although I've done the patches differently and also
removed some other bogus oddments.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 arch/ia64/hp/sim/simserial.c |   44 +++---------------------------------------
 1 files changed, 3 insertions(+), 41 deletions(-)


diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 23cafc8..84879f6 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -193,18 +193,6 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
  * -------------------------------------------------------------------
  */
 
-#if 0
-/*
- * not really used in our situation so keep them commented out for now
- */
-static DECLARE_TASK_QUEUE(tq_serial); /* used to be at the top of the file */
-static void do_serial_bh(void)
-{
-	run_task_queue(&tq_serial);
-	printk(KERN_ERR "do_serial_bh: called\n");
-}
-#endif
-
 static void do_softint(struct work_struct *private_)
 {
 	printk(KERN_ERR "simserial: do_softint called\n");
@@ -351,11 +339,7 @@ static void rs_flush_buffer(struct tty_struct *tty)
 	info->xmit.head = info->xmit.tail = 0;
 	local_irq_restore(flags);
 
-	wake_up_interruptible(&tty->write_wait);
-
-	if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-	    tty->ldisc.write_wakeup)
-		(tty->ldisc.write_wakeup)(tty);
+	tty_wakeup(tty);
 }
 
 /*
@@ -404,12 +388,6 @@ static void rs_unthrottle(struct tty_struct * tty)
 	printk(KERN_INFO "simrs_unthrottle called\n");
 }
 
-/*
- * rs_break() --- routine which turns the break handling on or off
- */
-static void rs_break(struct tty_struct *tty, int break_state)
-{
-}
 
 static int rs_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg)
@@ -422,14 +400,6 @@ static int rs_ioctl(struct tty_struct *tty, struct file * file,
 	}
 
 	switch (cmd) {
-		case TIOCMGET:
-			printk(KERN_INFO "rs_ioctl: TIOCMGET called\n");
-			return -EINVAL;
-		case TIOCMBIS:
-		case TIOCMBIC:
-		case TIOCMSET:
-			printk(KERN_INFO "rs_ioctl: TIOCMBIS/BIC/SET called\n");
-			return -EINVAL;
 		case TIOCGSERIAL:
 			printk(KERN_INFO "simrs_ioctl TIOCGSERIAL called\n");
 			return 0;
@@ -490,12 +460,6 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	unsigned int cflag = tty->termios->c_cflag;
 
-	if (   (cflag == old_termios->c_cflag)
-	    && (   RELEVANT_IFLAG(tty->termios->c_iflag)
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
-
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -623,9 +587,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	shutdown(info);
-	if (tty->ops->flush_buffer)
-		tty->ops->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
+	rs_flush_buffer(tty);
+	tty_ldisc_flush(tty)
 	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
@@ -955,7 +918,6 @@ static const struct tty_operations hp_ops = {
 	.stop = rs_stop,
 	.start = rs_start,
 	.hangup = rs_hangup,
-	.break_ctl = rs_break,
 	.wait_until_sent = rs_wait_until_sent,
 	.read_proc = rs_read_proc,
 };
