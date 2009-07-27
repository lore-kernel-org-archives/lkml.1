Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZG0Vlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZG0Vlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZG0Vlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:41:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36616 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753719AbZG0Vlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:41:31 -0400
Date: Mon, 27 Jul 2009 22:42:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727224220.0e80b926@lxorguk.ukuu.org.uk>
In-Reply-To: <87ocr5dfpb.fsf@devron.myhome.or.jp>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
	<87ocr5dfpb.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd favour we go with this which passes t1, expect, emacs and a corrected
t3

(test t3 is buggy as it has no \n and leaves the tty in line by line mode
so its typing a long line at the pty but never hits return to finish the
input)


It's theoretically imperfect in the case where you write a vast amount of
output in one go, the tty is blocked the other end and then you close.
However in practice that doesn't happen because with tty->low_latency = 1
we run the pty received n_tty ldisc code in our context so each write
fires through the entire n_tty ldisc and does flow control synchronously.

It needs re-addressing but its simple which at this point wins over
everything else and its one people tested before we tried to fix the hard
corner cases

commit aaf9da79c95a32fc5286fb851632baf09dc6134b
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jul 27 22:17:51 2009 +0100

    pty: quickfix for the pty ENXIO timing problems
    
    This also makes close stall in the normal case which is apparently needed
    to fix emacs
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e6942c..3850a68 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -52,6 +52,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		return;
 	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
+	tty_flip_buffer_push(tty->link);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
@@ -207,6 +208,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
+	tty->low_latency = 1;
 out:
 	return retval;
 }
