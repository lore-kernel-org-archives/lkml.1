Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXKAL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXKAL2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXKAL2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:28:07 -0400
Received: from mx0.karneval.cz ([81.27.192.14]:59890 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbXKAL2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:28:06 -0400
Message-id: <15530290543226725036.slaby@karneval.cz>
In-reply-to: <14457172322573118772.slaby@karneval.cz>
Subject: [PATCH 2/2] Char: tty, add tty_schedule_wakeup
From: Jiri Slaby <jirislaby@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Date: Thu,  1 Nov 2007 11:55:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UNTESTED so far

--
tty, add tty_schedule_wakeup

Because several drivers schedule a workqueue only for tty_wakeup, move this
functionality into tty layer and use newly added centralized work.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 0e9d5add01e8835407bd9f67b9fd82f98e19e122
tree a566aa490d247b5d5b9ff8e6ed437268c495f86b
parent 1ce760b56883d3c99b914266bca939f8d3ade1fd
author Jiri Slaby <jirislaby@gmail.com> Thu, 01 Nov 2007 10:56:24 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 01 Nov 2007 10:56:24 +0100

 drivers/char/tty_io.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 0eb979d..fd4a0e4 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -112,6 +112,7 @@
 
 #define TTY_WORK_HANGUP		1
 #define TTY_WORK_SAK		2
+#define TTY_WORK_WAKEUP		3
 
 struct ktermios tty_std_termios = {	/* for the benefit of tty drivers  */
 	.c_iflag = ICRNL | IXON,
@@ -1296,6 +1297,20 @@ void tty_wakeup(struct tty_struct *tty)
 EXPORT_SYMBOL_GPL(tty_wakeup);
 
 /**
+ *	tty_schedule_wakeup	-	request more data
+ *	@tty: terminal
+ *
+ *	Functionally the same as tty_wakeup, but it can be used in hot
+ *	paths. since the wakeup is scheduled and done in the future.
+ */
+void tty_schedule_wakeup(struct tty_struct *tty)
+{
+	set_bit(TTY_WORK_WAKEUP, tty->work_todo);
+	schedule_work(&tty->work);
+}
+EXPORT_SYMBOL_GPL(tty_schedule_wakeup);
+
+/**
  *	tty_ldisc_flush	-	flush line discipline queue
  *	@tty: tty
  *
@@ -3599,6 +3614,8 @@ static void tty_work(struct work_struct *work)
 		do_tty_hangup(tty);
 	if (test_and_clear_bit(TTY_WORK_SAK, tty->work_todo))
 		__do_SAK(tty);
+	if (test_and_clear_bit(TTY_WORK_WAKEUP, tty->work_todo))
+		tty_wakeup(tty);
 }
 
 /**
