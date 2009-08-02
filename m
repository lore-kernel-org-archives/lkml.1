Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZHBVSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZHBVSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZHBVSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:18:02 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36253 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZHBVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:18:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
Date: Mon, 03 Aug 2009 06:17:55 +0900
In-Reply-To: <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> (Linus
	Torvalds's message of "Sun, 2 Aug 2009 13:20:18 -0700 (PDT)")
Message-ID: <87k51l9apo.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> So, it seems refcount is wrong before
>> 	tty_ldisc_halt(tty);
>> 	tty_ldisc_wait_idle(tty);
>
> Agreed. Or something is just holding the refcount for too long, possibly 
> due to some deadlockish scenario (ie we migth be in "tty_ldisc_flush()", 
> and blocked forever on ld->ops->flush_buffer() while holding the ldisc 
> refcount. And we hold that whole &tty->ldisc_mutex _while_ waiting, so I 
> can easily see things being blocked on each other.

In this case, what is happening seems to be simple.

2735 tty1	Ss	0:0 init [S]          <- session leader
2736 tty1	S	0:0  \_ bash

Sequence is,

    bash        tty_read()
                    tty_ldisc_ref_wait()               <- take refcount
                    n_tty_read()
                        schedule_timeout()

    init [S]    do_exit()
                    [...]
                        do_tty_hangup()
                            tty_ldisc_hangup()
                                wake_up_interruptible_poll(read_wait)

    bash                /* n_tty_read() can't see the hangup state of tty,
                         * because anybody don't teach it to tty or ldisc */
                        schedule_timeout()             <- wait again

    init [S]                    tty_ldisc_halt()
                                tty_ldisc_wait_idle()  <- wait refcount
                                tty_ldisc_reinit()
                                    WARN_ON()
             
    bash            tty_ldisc_deref()                  <- drop refcount


or like the above. But I don't know what to do in the tty spec. And yes,
probably, I guess another races/deadlocks sequences are possible.

Maybe, it might be sane to return -EIO, because, tty_read() is already
returning -EIO if tty can't grab ldisc. But I'm not sure, and need to
check after some sleep...

And another related point which I'm don't know is why we don't change
console_fops to hung_up_tty_fops in do_tty_hangup() in the below.

Well, even if it changed to hung_up_tty_fops, like comment says, I guess
we would need to check what happen if someone is passing file descriptor
via AF_UNIX though.

do_tty_hangup()
	[....]
	/* This breaks for file handles being sent over AF_UNIX sockets ? */
	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
		[....]
		if (filp->f_op->write != tty_write)
			continue;
		[....]
		filp->f_op = &hung_up_tty_fops;

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
