Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZG0QOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZG0QOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZG0QOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:14:37 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53869 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZG0QOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:14:37 -0400
Date: Mon, 27 Jul 2009 21:44:24 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727161424.GA4233@skywalker>
References: <20090725150510.35e8854d@lxorguk.ukuu.org.uk> <87ab2sx15g.fsf@devron.myhome.or.jp> <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp> <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxci6ub9.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 12:04:42AM +0900, OGAWA Hirofumi wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> > +	set_bit(TTY_EOFPENDING, &pair->flags);
> >> > +	set_bit(TTY_OTHER_CLOSED, &pair->flags);
> >> > +	spin_unlock_irqrestore(&pair->buf.lock, flags);
> >> 
> >> 	tty_flip_buffer_push() or something?
> >> 
> >> > +	wake_up_interruptible(&pair->read_wait);
> >> > +	wake_up_interruptible(&pair->write_wait);
> >> 
> >> It seems, this sets TTY_EOFPENDING, but if flush_to_ldisc() was done
> >> already here, anybody doesn't set TTY_EOF for master.
> >
> > Does putting a tty_flip_buffer_push() at that point fix it. I had thought
> > I could remove it but you are right that creates a situation where EOF
> > may never get set.
> 
> With this patch, test program seems to work.
> 
> It seems "done = 0" hunk was needed for correct "done".
> 
> Thanks.
> 
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  drivers/char/pty.c        |    1 +
>  drivers/char/tty_buffer.c |    4 +---
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/char/pty.c~pty-fixes4-fix drivers/char/pty.c
> --- linux-2.6/drivers/char/pty.c~pty-fixes4-fix	2009-07-27 23:56:27.000000000 +0900
> +++ linux-2.6-hirofumi/drivers/char/pty.c	2009-07-27 23:56:40.000000000 +0900
> @@ -64,6 +64,7 @@ static void pty_close(struct tty_struct 
>  	set_bit(TTY_EOFPENDING, &pair->flags);
>  	set_bit(TTY_OTHER_CLOSED, &pair->flags);
>  	spin_unlock_irqrestore(&pair->buf.lock, flags);
> +	tty_flip_buffer_push(pair);
>  	wake_up_interruptible(&pair->read_wait);
>  	wake_up_interruptible(&pair->write_wait);
>  	if (tty->driver->subtype == PTY_TYPE_MASTER) {
> diff -puN drivers/char/tty_buffer.c~pty-fixes4-fix drivers/char/tty_buffer.c
> --- linux-2.6/drivers/char/tty_buffer.c~pty-fixes4-fix	2009-07-27 23:57:27.000000000 +0900
> +++ linux-2.6-hirofumi/drivers/char/tty_buffer.c	2009-07-27 23:57:30.000000000 +0900
> @@ -443,10 +443,8 @@ static void flush_to_ldisc(struct work_s
>  				done = 0;
>  				break;
>  			}
> -			if (count > tty->receive_room) {
> +			if (count > tty->receive_room)
>  				count = tty->receive_room;
> -				done = 0;
> -			}
>  			char_buf = head->char_buf_ptr + head->read;
>  			flag_buf = head->flag_buf_ptr + head->read;
>  			head->read += count;
> _


I still have the "compile in emacs" bug. So this patch along with
http://article.gmane.org/gmane.linux.kernel/869824 doesn't fix the
bug for me.

-aneesh
