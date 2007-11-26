Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXKZXac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXKZXac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXKZXaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:30:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbXKZXaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:30:24 -0500
Message-ID: <474B55F5.1050706@redhat.com>
Date: Mon, 26 Nov 2007 15:25:41 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <474B1C6D.6080405@zytor.com>
In-Reply-To: <474B1C6D.6080405@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> The 6-word limit is a red herring.  There is at least two ways to deal
> with it (and this doesn't mean wiping the legacy stuff we already have):
> 
> - Let each architecture pick a calling convention and redefine the
> architecture-independent bits to take an arbitrary number of arguments.
>  This is a one-time panarchitectural change.
> [...]

Just think beyond wishful thinking for a moment.  What does it take to
come up with something completely new and grand?

Let's start at the basic: you need to signal that the new syscall
calling convention is used.  Since the syscall entry code is limited (at
least the likes of syscall/sysenter, it would be easy enough to use int
$0x81 in addition to int $0x80) you would have to extend the use of the
syscall number while keeping binary compatibility.  This means
additional costs for every single syscall.

Once you're past that, how do you implement the expandable syscall
parameter count?  There are two ways:

- - pass to the real sys_* implementations the number of provided syscall
parameters and have each function figure out what this means

- - dynamically construct a call to the sys_* functions where the syscall
magic adds an appropriate number of parameters filled with zeros.  This
is quite complicated and, more importantly, it requires that you have
code/data somewhere which specifies how many parameters each of the
sys_* function actually requires.  The actual sys_* code and the data
has to be kept in sync at all times.  A maintenance nightmare.


The handling of syscalls with many parameters should not at all be a
driver of this design at all.  Syscalls shouldn't be that complicated, I
completely agree with ingo.


I'm perfectly willing to give you the benefit of doubt, show us a design
for what you're proposing which is not slower than the current code,
doesn't impact existing code, and solves the problem in a nice and clean
way.  I cannot really see it now but I might miss something.  The
sys_indirect approach ain't pretty but it does it jobs, doesn't impact
performance, and is expandable in direction we *know* we will want to go
very soon.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHS1X12ijCOnn/RHQRAihRAJwLNJ9fT8GTv6MAoO6RZGOub07sGgCdGBLR
frXyQVB8Oh5VgWY5YJhpitg=
=FuBx
-----END PGP SIGNATURE-----
