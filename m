Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZG0Nui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZG0Nui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZG0Nuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:50:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60474 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZG0Nuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:50:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
Date: Mon, 27 Jul 2009 22:50:32 +0900
In-Reply-To: <20090727142303.41096bf5@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 27 Jul 2009 14:23:03 +0100")
Message-ID: <877hxujkuv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> commit 70325fd1d4341896c17b6f1f1965370b5258d0b1
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Mon Jul 27 14:18:52 2009 +0100
>
>     pty: ensure writes hit the reader before close
>     
>     Implement TTY_EOF/EOFPENDING flags so that we can propogate the close of the
>     pty through the buffering correctly. The new flag state is locked but the
>     tty buffer lock as it relates to buffers, and also because the buffer
>     lock is already held in the hot path.
>     
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

I also tested this patch, and it seems to work in some case. However, in
some case, n_tty_read() didn't return -EIO for read() of master.

> +	spin_lock_irqsave(&pair->buf.lock, flags);
> +	pair->packet = 0;
> +	/* Indicate that the other end is now closed, set the
> +	   ENDPENDING marker so that the true end can be processed by

This seems typo s/ENDPENDING/EOFPENDING/


> @@ -47,13 +50,22 @@ static void pty_close(struct tty_struct *tty, struct file *filp)

[...]

> +	set_bit(TTY_EOFPENDING, &pair->flags);
> +	set_bit(TTY_OTHER_CLOSED, &pair->flags);
> +	spin_unlock_irqrestore(&pair->buf.lock, flags);

	tty_flip_buffer_push() or something?

> +	wake_up_interruptible(&pair->read_wait);
> +	wake_up_interruptible(&pair->write_wait);

It seems, this sets TTY_EOFPENDING, but if flush_to_ldisc() was done
already here, anybody doesn't set TTY_EOF for master.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
