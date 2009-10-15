Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbZJOPEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbZJOPEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbZJOPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:04:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49707 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762779AbZJOPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:04:07 -0400
Date: Thu, 15 Oct 2009 16:05:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at drivers/usb/serial/usb-serial.c:446
 serial_unthrottle
Message-ID: <20091015160501.36a31973@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD71FA3.8080801@wpkg.org>
References: <4AD71FA3.8080801@wpkg.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 15:12:03 +0200
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> I see my minicom segfaulted for some reason (probably as I closed konsole window without exiting minicom first).
> 
> And I see this warning in dmesg - anything useful?

Looks like a very very old bug in the tty code. I have a patch for this I'm
testing for a while and will sort out properly after the kernel summit. In
the mean time have a play with the patch below which ought to do the trick.

n_tty: fix throttling

From: Alan Cox <alan@linux.intel.com>

n_tty inadevertently calls throttle and unthrottle methods during its init.
This happens before the tty device is open and causes problems for the
drivers, in particular they may not have their state and locks even
initialised at this point.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/n_tty.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..b45170c 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -178,26 +178,23 @@ static void reset_buffer_flags(struct tty_struct *tty)
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
 	n_tty_set_room(tty);
-	check_unthrottle(tty);
 }
 
 /**
- *	n_tty_flush_buffer	-	clean input queue
+ *	n_tty_do_flush		-	clean input queue
  *	@tty:	terminal device
  *
  *	Flush the input buffer. Called when the line discipline is
- *	being closed, when the tty layer wants the buffer flushed (eg
- *	at hangup) or when the N_TTY line discipline internally has to
- *	clean the pending queue (for example some signals).
+ *	being closed, or indirectly when the tty layer wants the buffer
+ *	flushed (eg at hangup) or when the N_TTY line discipline internally
+ *	has to clean the pending queue (for example some signals).
  *
  *	Locking: ctrl_lock, read_lock.
  */
 
-static void n_tty_flush_buffer(struct tty_struct *tty)
+static void n_tty_do_flush(struct tty_struct *tty)
 {
 	unsigned long flags;
-	/* clear everything and unthrottle the driver */
-	reset_buffer_flags(tty);
 
 	if (!tty->link)
 		return;
@@ -211,6 +208,25 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
 }
 
 /**
+ *	n_tty_flush_buffer	-	clean input queue
+ *	@tty:	terminal device
+ *
+ *	Flush the input buffer. Called when the tty layer wants the buffer
+ *	flushed (eg at hangup) or when the N_TTY line discipline internally
+ *	has to clean the pending queue (for example some signals).
+ *
+ *	Locking: ctrl_lock, read_lock.
+ */
+
+static void n_tty_flush_buffer(struct tty_struct *tty)
+{
+	/* clear everything and unthrottle the driver */
+	reset_buffer_flags(tty);
+	check_unthrottle(tty);
+	n_tty_do_flush(tty);
+}
+
+/**
  *	n_tty_chars_in_buffer	-	report available bytes
  *	@tty: tty device
  *
@@ -1535,7 +1551,8 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 static void n_tty_close(struct tty_struct *tty)
 {
-	n_tty_flush_buffer(tty);
+	reset_buffer_flags(tty);
+	n_tty_do_flush(tty);
 	if (tty->read_buf) {
 		kfree(tty->read_buf);
 		tty->read_buf = NULL;
