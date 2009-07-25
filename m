Return-Path: <linux-kernel-owner+w=401wt.eu-S1751116AbZGYOEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbZGYOEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGYOEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:04:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36221 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbZGYOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:04:21 -0400
Date: Sat, 25 Jul 2009 15:05:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
In-Reply-To: <87ws5xjo2x.fsf@devron.myhome.or.jp>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually try this:


commit b0e6bdde87725a5d46273ecc4bd00c54bd675848
Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Jul 25 15:00:04 2009 +0100

    pty: ensure writes hit the reader before close
    
    This is elegant in all the wrong ways. Put the pty into low latency mode (which
    we can do as we always post bytes from user context). The tty_flip_buffer_push
    then always calls into the ldisc which means we clear the ldisc buffer before
    we set the TTY_OTHER_CLOSED flag.
    
    Means pty has subtle knowledge of tty internals we really don't want it to, but
    it fixes the problem for the moment.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e6942c..87d729b 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -47,10 +47,12 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	}
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
+	
 	tty->packet = 0;
 	if (!tty->link)
 		return;
 	tty->link->packet = 0;
+	tty_flip_buffer_push(tty->link);
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
@@ -207,6 +209,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
+	tty->low_latency = 1;
 out:
 	return retval;
 }
