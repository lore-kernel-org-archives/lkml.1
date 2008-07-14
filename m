Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYGNQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYGNQNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYGNQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:13:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54974 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYGNQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:13:37 -0400
Date: Tue, 15 Jul 2008 01:12:19 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] adapt ia64/hp/sim/simserial.c to new tty framework
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080715010813.F6E9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch title: adapt-ia64-hp-simserial-to-new-tty-ldisc.patch
Against: mmotm Jul 14
Applies after: linux-next.patch

Recently, Alan Cox made cleanup tty widely.
But unfortunately it cause simserial build error.
This patch fixes it.

  arch/ia64/hp/sim/simserial.c: In function 'rs_flush_buffer':
  arch/ia64/hp/sim/simserial.c:357: error: 'struct tty_ldisc' has no member named 'write_wakeup'
  arch/ia64/hp/sim/simserial.c:358: error: 'struct tty_ldisc' has no member named 'write_wakeup'
  arch/ia64/hp/sim/simserial.c: In function 'rs_close':
  arch/ia64/hp/sim/simserial.c:628: error: 'struct tty_ldisc' has no member named 'flush_buffer'
  arch/ia64/hp/sim/simserial.c:628: error: 'struct tty_ldisc' has no member named 'flush_buffer'
  arch/ia64/hp/sim/simserial.c: At top level:
  arch/ia64/hp/sim/simserial.c:958: warning: initialization from incompatible pointer type


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Alan Cox <alan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/hp/sim/simserial.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: b/arch/ia64/hp/sim/simserial.c
===================================================================
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -354,8 +354,8 @@ static void rs_flush_buffer(struct tty_s
 	wake_up_interruptible(&tty->write_wait);
 
 	if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-	    tty->ldisc.write_wakeup)
-		(tty->ldisc.write_wakeup)(tty);
+	    tty->ldisc.ops->write_wakeup)
+		(tty->ldisc.ops->write_wakeup)(tty);
 }
 
 /*
@@ -407,8 +407,9 @@ static void rs_unthrottle(struct tty_str
 /*
  * rs_break() --- routine which turns the break handling on or off
  */
-static void rs_break(struct tty_struct *tty, int break_state)
+static int rs_break(struct tty_struct *tty, int break_state)
 {
+	return 0;
 }
 
 static int rs_ioctl(struct tty_struct *tty, struct file * file,
@@ -625,7 +626,8 @@ static void rs_close(struct tty_struct *
 	shutdown(info);
 	if (tty->ops->flush_buffer)
 		tty->ops->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
+	if (tty->ldisc.ops->flush_buffer)
+		tty->ldisc.ops->flush_buffer(tty);
 	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {


