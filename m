Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZKKRBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZKKRBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZKKRBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:01:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbZKKRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:01:11 -0500
Date: Wed, 11 Nov 2009 15:01:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] potential ancient bug (since 1.99.14) at char/pty
Message-ID: <20091111150103.06cc3489@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan/Ts'o,

There's an open bugzilla at Red Hat for the pty driver that I'm not sure
what would be the better fix. It tracks to kernel 1.99.14:
	http://www.linuxhq.com/kernel/v1.99/13/drivers/char/ChangeLog
	http://www.linuxhq.com/kernel/v1.99/13/drivers/char/pty.c

The code is still present upstream.

The pty changes added two lines to pty_close(): tty->packet = 0 and
tty->link->packet = 0.

The bug is at:
	https://bugzilla.redhat.com/show_bug.cgi?id=504703

The result of the bug is a race condition where telnetd may not properly
recognize the logout message (as it assumes that the device is in packet mode,
where the driver already changed its state to non-packet mode).

By removing tty->link->packet = 0, it fixes the issue, with a patch like:

--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -51,7 +51,6 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	tty->packet = 0;
 	if (!tty->link)
 		return;
-	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);

However, I'm not sure if this is the better fix, since it means that, after
closing both devices and opening again, link->packet will be 1, and this seems
wrong.

So, maybe the better way would be to add an open counter to pty and changing
link->packet to zero only if the open usage count is zero.

Another point to be considered is that a change like that on a very old code can
cause regressions on other parts.

Comments?

Cheers,
Mauro
