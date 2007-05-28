Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbXE1HIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbXE1HIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXE1HIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:08:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:39516 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXE1HIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:08:18 -0400
Date: Mon, 28 May 2007 11:07:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satoru Takeuchi <takeuchi_satoru.jp@fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] signal: multithread program returns with wrong errno on receiving SIGSTOP
Message-ID: <20070528070753.GA989@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi wrote:
>
> I found a bug on signal subsystem. If there is some multithread program
> and one of the thread is blocking on the system call, it returns with
> wrong errno on receiving SIGSTOP and following SIGCONT.

It doesn't matter in this particular case, but in general it is good to
report the kernel version as well.

> 1. issue the test program (attached on this mail) from term A.
>
>    $ ./mt-wrong-errno
>
> 2. send SIGSTOP to test program from term B.
>
>    $ ps a
>    ...
>     9685 pts/3    Sl+    0:00 ./mt-wrong-errno
>     9688 pts/4    R+     0:00 ps a
>    $ kill -STOP 9685
>
> 3. send SIGCONT to test program from term B.
>
>    $ kill -CONT 9685
>
> Expected Result
> ===============
>
> `./mt-wrong-errno' restarts read syscall (and stop again by receiving
> SIGTTIN).
>
> Actual Result
> =============
>
> `./mt-wrong-errno' returns with wrong errno 512 means ERESTARTSYS.
> The comment on include/linux/errno.h says "this errno should never be
> seen by user program." So it's definitely a bug.

Wild guess,

	drivers/char/n_tty.c:job_control()

		kill_pgrp(task_pgrp(current), SIGTTIN, 1);
		return -ERESTARTSYS;

This is wrong. kill_pgrp()->__group_send_sig_info() sends SIGTTIN
to the thread group, but can choose any sub-thread as a target for
signal_wake_up().

This means we return ERESTARTSYS, but signal_pending() != true, bug.

Satoru, could you re-test with the untested patch below?

Oleg.

--- t/drivers/char/n_tty.c~	2007-04-05 12:18:26.000000000 +0400
+++ t/drivers/char/n_tty.c	2007-05-28 10:57:58.000000000 +0400
@@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
 			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
+			set_thread_flag(TIF_SIGPENDING);
 			return -ERESTARTSYS;
 		}
 	}

