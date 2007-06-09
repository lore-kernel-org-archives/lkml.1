Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbXFIUXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbXFIUXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbXFIUWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:22:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759094AbXFIUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:22:50 -0400
Date: Sat, 9 Jun 2007 13:21:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070609200645.GG4095@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
References: <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com>
 <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com>
 <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com>
 <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com>
 <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com>
 <20070609200645.GG4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jun 2007, Al Viro wrote:
> 
> How the hell can it be racy wrt normal open()?  F_DUPFD is not dup2(),
> it's non-overriding.

Al, you probably didn't read this thread from the beginning (not in this 
particular email thread - an earlier one on the whole feature).

The problem is that a thread wants to open a FD_CLOEXEC file descriptor, 
because it is doing something that is thread-local. So it does

	fd = some.op.that.returns.an.fd.like.socket();
	fcntl(fd, F_SETFD, &FD_CLOEXEC);

but *another* thread does an execve() at the same time, and the fcntl() 
never gets to happen!

Which is why you'd like to do the *initial* operation with a flag that 
says "please set the FD_CLOEXEC flag on the file descriptor", so that you 
*atomically* install the file file descriptor and set the FD_CLOEXEC bit.

It's trivial to do for open(), but there are about a million ways to get a 
file descriptor, and open() is just about the *only* one of those that 
actually takes a "flags" field that can be used to tell the kernel.

So ignore the fdmapping for now: that's just an extended thing. The 
problem is _independent_ of the fdmapping, but it turns out that a lot of 
these problems are intertwined, in that you actually want *other* flags 
than just "FD_CLOEXEC". For example, one of the flags would be "private fd 
space" (which is where fdmap comes in), so that a library can allocate its 
own internal file descriptors *without* impacting the caller that depends 
on its own file descriptor allocation.

(And dammit, that _is_ a *real*issue*. No races necessary, no NR_OPEN 
iterations, no even *halfway* suspect code. It's perfectly fine to do

	close(0);
	close(1);
	close(2);
	.. generate filenames, whatever ..
	if (open(..) < 0 || open(..) < 0 || open(..) < 0)
		die("Couldn't redirect stdin/stdout/stderr");

and there's absolutely nothing wrong with this kind of setup, even if you 
could obviously have done it other ways too (ie by using "dup2()" instead 
of "close + open"),

And that means that libraries currently MUST NOT open their own file 
descriptors, exactly because they mess with the "application file 
descriptor namespace", namely the linear POSIX-defined fd allocation 
rules!

And no, "dup2(fd, SOME_BIG_FD)" is *not* the answer, exactly because we 
end up sucking like mad if you actually were to do it!

So I think both the FD_CLOEXEC _and_ the "private fd space" are real 
issues. I don't agree with the "random fd" approach. I'd much rather have 
a non-random setup for the nonlinear ones (it just shouldn't be linear).

		Linus
