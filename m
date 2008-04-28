Return-Path: <linux-kernel-owner+w=401wt.eu-S935705AbYD1PP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705AbYD1PP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935541AbYD1POT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:14:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935532AbYD1POR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:14:17 -0400
Message-ID: <4815E99B.2010903@redhat.com>
Date: Mon, 28 Apr 2008 08:13:31 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] paccept, socket, socketpair w/flags
References: <200804262224.m3QMOP3a006296@devserv.devel.redhat.com>	 <517f3f820804280252h753c8cacv7fe9580f96dcf1ce@mail.gmail.com>	 <4815DB8B.7060606@redhat.com> <cfd18e0f0804280751x21833b51y4b1f6f7ce3201d0d@mail.gmail.com>
In-Reply-To: <cfd18e0f0804280751x21833b51y4b1f6f7ce3201d0d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Kerrisk wrote:
> You have said it would be cleaner to have new syscalls for socket()
> and socketpair().  I understand your reasoning for that to be that
> doing so is cleaner than overloading the type argument of the existing
> versions of these syscalls.  I agree.  So, since you are adding new
> syscalls for all of the other interfaces, why not do it for these two
> syscalls also?

If the range of the existing parameter can indeed be restricted as
needed for the flags it is the better approach for programmers since all
that is needed for a programmer to do is to write


   fd = socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, 0);
   if (fd == -1 && errno == EINVAL)
     {
       fd = socket(PF_INET, SOCK_STREAM, 0);
       if (fd != -1)
         fcntl(fd, F_SETFD, FD_CLOEXEC);
     }

No autoconf code needed to detect the presence of a new function.  You
can even imagine that convenience libraries will do the above
automatically (not libc, though, where you want to recognize this
situation).


> Okay -- I see your point (and I didn't read your patches closely
> enough).  However, the rationale for the implementations proposed to
> date isn't very clear.  So far we have the following new flags:
> 
> timerfd_create() -- TFD_CLOEXEC
> signalfd4() -- SFD_CLOEXEC
> eventfd2() -- EFD_CLOEXEC
> epoll_create2() -- EPOLL_CLOEXEC
> open() (and openat()), dup3() -- all use O_CLOEXEC
> socketpair(), socket(), paccept -- all use SOCK_CLOEXEC
> pipe2() -- to be determined

Use O_CLOEXEC, normal filesystem operation.

> inotify_init2() -- to be determined

New flag.


> It would help if you laid out your reasoning for creating distinct
> flags for some syscalls but not others.  For example, is the
> assumption here that socketpair(), socket(), and paccept() will always
> use the same set of flags?

Yes, they are all related interfaces.  Using the same name indicates
similarity.


And just to complicate things even more:

if we'd go with sys_indirect we can have single way to specify
close-on-exec for all syscalls.  That would be at the syscall level.  At
the API level we'd still need separate names and possibly values.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFemb2ijCOnn/RHQRAjNCAJ0QCvEJoynwbPveUZQqsyVnEAHtmgCZAe0R
jNlcvQFI06n2ckFhEqUcEbE=
=sJhN
-----END PGP SIGNATURE-----
