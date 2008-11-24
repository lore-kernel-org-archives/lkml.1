Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKXNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKXNk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYKXNkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:40:18 -0500
Received: from mail.pcs.de ([145.253.69.50]:36006 "EHLO mail.pcs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYKXNkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:40:17 -0500
Date: Mon, 24 Nov 2008 14:40:15 +0100 (CET)
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: linux-kernel@vger.kernel.org
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix async io write notifications
Message-ID: <Pine.LNX.4.64.0811241401280.8443@lxtpfaff.pcs.ditec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Nov 2008 13:40:15.0768 (UTC) FILETIME=[2ED6F980:01C94E3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Pfaff <tpfaff@pcs.com>

The N_TTY ldisc layer does not send SIGIO POLL_OUTs correctly when output is 
possible due to flawed handling of the TTY_DO_WRITE_WAKEUP bit. It will either 
send no SIGIOs at all or on every tty wakeup.

The fix is to set the bit when the tty driver write would block and test and 
clear it on write wakeup.

Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/n_tty.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index efbfe96..4e0f4be 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -923,10 +923,8 @@ handle_newline:
 
 static void n_tty_write_wakeup(struct tty_struct *tty)
 {
-	if (tty->fasync) {
-		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	if (test_and_clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
-	}
 }
 
 /**
@@ -1556,6 +1554,8 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 		}
 		if (!nr)
 			break;
+		if (tty->fasync)
+			set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		if (file->f_flags & O_NONBLOCK) {
 			retval = -EAGAIN;
 			break;
@@ -1565,6 +1565,8 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 break_out:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
+	if (tty->fasync && (b - buf) != nr)
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	return (b - buf) ? b - buf : retval;
 }
 
