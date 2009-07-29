Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZG2CUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZG2CUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZG2CUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:20:34 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:22480 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZG2CUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:20:34 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Regression] kdesu broken
Date: Tue, 28 Jul 2009 22:20:20 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200907240145.31935.rjw@sisk.pl>
 <87ws5xjo2x.fsf@devron.myhome.or.jp>
 <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
In-reply-to: <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907282220.20205.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Alan Cox wrote:
>Actually try this:
>
>
>commit b0e6bdde87725a5d46273ecc4bd00c54bd675848
>Author: Alan Cox <alan@linux.intel.com>
>Date:   Sat Jul 25 15:00:04 2009 +0100
>
>    pty: ensure writes hit the reader before close
>
>    This is elegant in all the wrong ways. Put the pty into low latency mode
> (which we can do as we always post bytes from user context). The
> tty_flip_buffer_push then always calls into the ldisc which means we clear
> the ldisc buffer before we set the TTY_OTHER_CLOSED flag.
>
>    Means pty has subtle knowledge of tty internals we really don't want it
> to, but it fixes the problem for the moment.
>
>    Signed-off-by: Alan Cox <alan@linux.intel.com>
>
>diff --git a/drivers/char/pty.c b/drivers/char/pty.c
>index 6e6942c..87d729b 100644
>--- a/drivers/char/pty.c
>+++ b/drivers/char/pty.c
>@@ -47,10 +47,12 @@ static void pty_close(struct tty_struct *tty, struct
> file *filp) }
> 	wake_up_interruptible(&tty->read_wait);
> 	wake_up_interruptible(&tty->write_wait);
>+
> 	tty->packet = 0;
> 	if (!tty->link)
> 		return;
> 	tty->link->packet = 0;
>+	tty_flip_buffer_push(tty->link);
> 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
> 	wake_up_interruptible(&tty->link->read_wait);
> 	wake_up_interruptible(&tty->link->write_wait);
>@@ -207,6 +209,7 @@ static int pty_open(struct tty_struct *tty, struct file
> *filp) clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
> 	set_bit(TTY_THROTTLED, &tty->flags);
> 	retval = 0;
>+	tty->low_latency = 1;
> out:
> 	return retval;
> }

Tracing this kdesu thread down per advice from Rafael W.  This patch doesn't 
seem to do anything about bz 13841. There are more patches in this thread, 
I'll give them some testing too.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

"Microsoft is the epitome of innovation and product quality."

   -- This testimonial paid for by Microsoft. 

