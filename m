Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZG2CvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZG2CvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZG2CvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:51:06 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:55845 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG2CvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:51:05 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Date: Tue, 28 Jul 2009 22:50:45 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <20090729004639.71f0eabc@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907282250.46018.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Linus Torvalds wrote:
>On Wed, 29 Jul 2009, Alan Cox wrote:
>> BTW: The tty->low_latency fix doesn't work, because the ->write method
>> can be called from an IRQ and that means we can't use ->low_latency=1 as
>> we take mutexes.
>
>Ok. So the end result is that Ogawa-san's fix is the right one. Then we
>can revert the low_latency=1 thing for pty's entirely. No?
>
>And this is also the one that _looks_ the sanest - ie we do it on the read
>side, where it matters, rather than on the write side or the flush side
>(where the proper flushing can _also_ fix the problem, but where it's much
>more problematic, and where it's a lot less direct about what we care
>about).
>
>This is just Ogawa's patch, redone against current -git, and with commit
>3a54297478e6578f96fd54bf4daa1751130aca86 reverted (Ogawa's patch already
>undid the non-low_latency part of it).
>
>Now, I wonder if some _other_ line discipline might want to do that same
>tty_flush_to_ldisc thing in their "do I have data" logic, but I didn't
>look any closer.
>
>So does this work for everyone? I haven't tested it yet myself, but this
>is the patch that "looks" right.
>
>		Linus

It doesn't seem to do anything for bz 13841 here.  Sorry, I wish it did.

Thanks Linus.
>
>---
> drivers/char/n_tty.c      |    1 +
> drivers/char/pty.c        |    2 --
> drivers/char/tty_buffer.c |   13 +++++++++++++
> include/linux/tty.h       |    1 +
> 4 files changed, 15 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
>index ff47907..973be2f 100644
>--- a/drivers/char/n_tty.c
>+++ b/drivers/char/n_tty.c
>@@ -1583,6 +1583,7 @@ static int n_tty_open(struct tty_struct *tty)
>
> static inline int input_available_p(struct tty_struct *tty, int amt)
> {
>+	tty_flush_to_ldisc(tty);
> 	if (tty->icanon) {
> 		if (tty->canon_data)
> 			return 1;
>diff --git a/drivers/char/pty.c b/drivers/char/pty.c
>index 3850a68..6e6942c 100644
>--- a/drivers/char/pty.c
>+++ b/drivers/char/pty.c
>@@ -52,7 +52,6 @@ static void pty_close(struct tty_struct *tty, struct file
> *filp) return;
> 	tty->link->packet = 0;
> 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
>-	tty_flip_buffer_push(tty->link);
> 	wake_up_interruptible(&tty->link->read_wait);
> 	wake_up_interruptible(&tty->link->write_wait);
> 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
>@@ -208,7 +207,6 @@ static int pty_open(struct tty_struct *tty, struct file
> *filp) clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
> 	set_bit(TTY_THROTTLED, &tty->flags);
> 	retval = 0;
>-	tty->low_latency = 1;
> out:
> 	return retval;
> }
>diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
>index 810ee25..3108991 100644
>--- a/drivers/char/tty_buffer.c
>+++ b/drivers/char/tty_buffer.c
>@@ -462,6 +462,19 @@ static void flush_to_ldisc(struct work_struct *work)
> }
>
> /**
>+ *	tty_flush_to_ldisc
>+ *	@tty: tty to push
>+ *
>+ *	Push the terminal flip buffers to the line discipline.
>+ *
>+ *	Must not be called from IRQ context.
>+ */
>+void tty_flush_to_ldisc(struct tty_struct *tty)
>+{
>+	flush_to_ldisc(&tty->buf.work.work);
>+}
>+
>+/**
>  *	tty_flip_buffer_push	-	terminal
>  *	@tty: tty to push
>  *
>diff --git a/include/linux/tty.h b/include/linux/tty.h
>index 1488d8c..e8c6c91 100644
>--- a/include/linux/tty.h
>+++ b/include/linux/tty.h
>@@ -394,6 +394,7 @@ extern void __do_SAK(struct tty_struct *tty);
> extern void disassociate_ctty(int priv);
> extern void no_tty(void);
> extern void tty_flip_buffer_push(struct tty_struct *tty);
>+extern void tty_flush_to_ldisc(struct tty_struct *tty);
> extern void tty_buffer_free_all(struct tty_struct *tty);
> extern void tty_buffer_flush(struct tty_struct *tty);
> extern void tty_buffer_init(struct tty_struct *tty);
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Small animal kamikaze attack on power supplies

