Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZG1Fdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZG1Fdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZG1Fdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:33:45 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57093 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZG1Fdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:33:44 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
Date: Tue, 28 Jul 2009 14:33:40 +0900
In-Reply-To: <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 27 Jul 2009 22:20:10 +0100")
Message-ID: <87r5w19xsb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> And if it's right, unfortunately, I guess we can't return -EAGAIN in
>> this case to preserve behavior.
>
> To avoid the EAGAIN the close needs to block until all queued I/O has
> been processed by the ldisc the other end. That's not standards
> guaranteed or even what happens with a non pty port, but it is doable
> unless you take signals - we can't block signals or it can all deadlock.

Just a quick hack though. Is this wrong/unpreferable way?

n_tty_read() checks the pending buffer and consume it before
input_available_p().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/char/n_tty.c      |    1 +
 drivers/char/pty.c        |    1 -
 drivers/char/tty_buffer.c |    7 +++++--
 include/linux/tty.h       |    1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/char/pty.c~pty-fixes4-fix2 drivers/char/pty.c
--- linux-2.6/drivers/char/pty.c~pty-fixes4-fix2	2009-07-28 05:00:45.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/pty.c	2009-07-28 05:00:48.000000000 +0900
@@ -64,7 +64,6 @@ static void pty_close(struct tty_struct 
 	set_bit(TTY_EOFPENDING, &pair->flags);
 	set_bit(TTY_OTHER_CLOSED, &pair->flags);
 	spin_unlock_irqrestore(&pair->buf.lock, flags);
-	tty_flip_buffer_push(pair);
 	wake_up_interruptible(&pair->read_wait);
 	wake_up_interruptible(&pair->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
diff -puN drivers/char/n_tty.c~pty-fixes4-fix2 drivers/char/n_tty.c
--- linux-2.6/drivers/char/n_tty.c~pty-fixes4-fix2	2009-07-28 05:01:10.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/n_tty.c	2009-07-28 05:07:49.000000000 +0900
@@ -1776,6 +1776,7 @@ do_it_again:
 		    ((minimum - (b - buf)) >= 1))
 			tty->minimum_to_wake = (minimum - (b - buf));
 
+		tty_flush_to_ldisc(tty);
 		if (!input_available_p(tty, 0)) {
 			if (test_bit(TTY_EOF, &tty->flags)) {
 				/* PTY pair closed and all data consumed */
diff -puN include/linux/tty.h~pty-fixes4-fix2 include/linux/tty.h
--- linux-2.6/include/linux/tty.h~pty-fixes4-fix2	2009-07-28 05:07:07.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/tty.h	2009-07-28 05:07:30.000000000 +0900
@@ -396,6 +396,7 @@ extern void __do_SAK(struct tty_struct *
 extern void disassociate_ctty(int priv);
 extern void no_tty(void);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
+extern void tty_flush_to_ldisc(struct tty_struct *tty);
 extern void tty_buffer_free_all(struct tty_struct *tty);
 extern void tty_buffer_flush(struct tty_struct *tty);
 extern void tty_buffer_init(struct tty_struct *tty);
diff -puN drivers/char/tty_buffer.c~pty-fixes4-fix2 drivers/char/tty_buffer.c
--- linux-2.6/drivers/char/tty_buffer.c~pty-fixes4-fix2	2009-07-28 05:41:12.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/tty_buffer.c	2009-07-28 14:24:48.000000000 +0900
@@ -388,8 +388,6 @@ int tty_prepare_flip_string_flags(struct
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
 
-
-
 /**
  *	flush_to_ldisc
  *	@work: tty structure passed from work queue.
@@ -473,6 +471,11 @@ static void flush_to_ldisc(struct work_s
 	tty_ldisc_deref(disc);
 }
 
+void tty_flush_to_ldisc(struct tty_struct *tty)
+{
+	flush_to_ldisc(&tty->buf.work.work);
+}
+
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@tty: tty to push
_
