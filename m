Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbXCJIWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbXCJIWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbXCJIWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:22:13 -0500
Received: from mivlgu.ru ([81.18.140.87]:54616 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541AbXCJIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:22:11 -0500
Date: Sat, 10 Mar 2007 11:22:03 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: "Luong Ngo" <luong.ngo@gmail.com>
Cc: "Parav K Pandit" <parav_pandit@mindtree.com>,
       "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: Sleeping thread not receive signal until it wakes up
Message-Id: <20070310112203.33c638ee.vsu@altlinux.ru>
In-Reply-To: <1b2aacd80703091610h9b5bc0ep1b5b58c53ca58e86@mail.gmail.com>
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no>
	<fa.cyXmbtXvYymKHdI0rEXZCxyk+KE@ifi.uio.no>
	<fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no>
	<fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no>
	<fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no>
	<fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no>
	<45F0B40F.7070301@shaw.ca>
	<1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
	<2C15D00D262B7245B1D8D1799F04D88F04A58C42@mtw01ex01.mindtree.com>
	<1b2aacd80703091610h9b5bc0ep1b5b58c53ca58e86@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__10_Mar_2007_11_22_03_+0300_MBE.MP+qbc0aD=FH"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__10_Mar_2007_11_22_03_+0300_MBE.MP+qbc0aD=FH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 9 Mar 2007 16:10:29 -0800 Luong Ngo wrote:

> Thanks Parav, adding singal_allow(SIGALRM) wakeup the blocking
> interruptible_sleep_on and checking the signal_pending would return
> true now.

This means that there is also a bug in your userspace program -
somehow when it invokes ioctl(), it has SIGALRM blocked.  Use
sigprocmask() (or pthread_sigmask() if your program is multithreaded)
to ensure that SIGALRM is not blocked when you are expecting it to be
processed.  (Even if your program does not block SIGALRM, it may
inherit a blocked SIGALRM from another program which have started it,
so the safest way is to unblock SIGALRM explicitly.)

Using allow_signal() is needed only if you create a kernel thread and
want that thread to handle signals.

> But a quick question is when detecting signal_pending, I
> return -ERESTARTSYS, but the user process receive the return value of
> ioctl call is -1, shouldn't it be -4 for EINTR?

This is handled by syscall wrappers in libc - when the kernel returns
an error code from a syscall, the syscall wrapper function puts the
code into the per-thread errno variable and returns -1 to its caller.
Your userspace code should check errno for the actual error code when
it receives -1 from ioctl().

And the ERESTARTSYS error is really special - it never actually gets
returned to the userspace program; instead, the syscall return code in
the kernel catches it and either restarts the syscall after the signal
handler completes, or converts the error code to EINTR; one of these
actions is selected by the SA_RESTART flag to sigaction().

--Signature=_Sat__10_Mar_2007_11_22_03_+0300_MBE.MP+qbc0aD=FH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQFF8mquW82GfkQfsqIRAlLLAJ9uV4HEGIxcAVX5k8OSXlqnhoYcswCgjQLh
7naajYP6gAOqgOKjkRhOIFw=
=WXwr
-----END PGP SIGNATURE-----

--Signature=_Sat__10_Mar_2007_11_22_03_+0300_MBE.MP+qbc0aD=FH--
