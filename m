Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZKRO0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZKRO0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZKRO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:26:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46399 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757211AbZKRO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:26:39 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/7] n_tty: fix throttling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:10:15 +0000
Message-ID: <20091118141014.2798.52157.stgit@localhost.localdomain>
In-Reply-To: <20091118140935.2798.32517.stgit@localhost.localdomain>
References: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

