Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZHXMWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZHXMWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZHXMV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:21:59 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:58610 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZHXMV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:21:59 -0400
Message-ID: <4A9285FC.8000606@byu.net>
Date: Mon, 24 Aug 2009 06:22:20 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bug-coreutils <bug-coreutils@gnu.org>
Subject: [RFC] new open flag O_NOSTD
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposal
========
Add a new flag, O_NOSTD, to at least open and pipe2 (and an alternate
spelling SOCK_NOSTD for socket, socketpair, accept4), with the following
semantics:

If the flag is specified and the function is successful, the returned fd
(both fds for the pipe2 case) will be at least 3, regardless of whether
the standard file descriptors 0, 1, or 2 are currently closed.

Rationale
=========
GNU Coreutils tries hard to protect itself from whatever weird environment
may be thrown at it.  One example is if the user runs:

cp a b 2>&-

If cp encounters an error, it prints a message to stderr, then regardless
of whether the message was successfully printed, cp guarantees a non-zero
exit status.  In the case where fd 2 starts life closed, however, a naive
implementation could end up opening a destination file for writing as fd
2, then encounter an error, such that the first use of stderr to print an
error message will incorrectly modify the contents of a completely
unrelated file.  Therefore, the best approach for cp to take is to ensure
that command-line arguments never occupy fd 0, 1, or 2, no matter what the
cp process inherited from its parent.

Of course, if cp were installed set-user-ID Or set-group-ID, then the OS
could guarantee that cp would never start life with fd 0, 1, or 2 closed;
but cp should not normally be installed with these permissions, and POSIX
does not permit the OS to arbitrarily open these fds if these permissions
are not present.

One option is for cp to manually guarantee that fd 0, 1, and 2 are opened
prior to parsing command line options.  At one point, coreutils even used
this approach, via a function stdopen:
http://git.savannah.gnu.org/cgit/coreutils.git/diff/lib/stdopen.c?id=875cae47
However, this has a couple of drawbacks.  It costs several syscalls at
startup, even in the common case of all three std descriptors being
provided by the parent process.  It also ties up otherwise unused open
file descriptors (perhaps the user intentionally closed some of the std
fds in order to provide room for allowing more simultaneously open files
without hitting EMFILE limits).

Another option is what cp currently uses, which guarantees that any
function call that creates a new fd is wrapped by a *_safer variant, which
guarantees that the result will never collide with the standard
descriptors.  In the common case, the original open() returns 3 or larger,
so the wrapper has no additional work to perform.  But if the user started
cp with fd 0, 1, or 2 closed, then the current implementation of the
open_safer wrapper notices that the underlying open() call is in the wrong
range, and provides a followup call to fcntl(fd,F_DUPFD,3) and close(fd),
such that the overall result is again safely out of the std fd range:
http://git.savannah.gnu.org/cgit/gnulib.git/tree/lib/open-safer.c
http://git.savannah.gnu.org/cgit/gnulib.git/tree/lib/fd-safer.c
http://git.savannah.gnu.org/cgit/gnulib.git/tree/lib/dup-safer.c

Notice that with coreutils' current approach, the common case (all std
descriptors provided by the parent) uses the minimal number of syscalls.
However, in the corner case of starting life with a standard descriptor
closed, the number of additional fcntl(F_DUPFD)/close() calls cause
noticeable slowdown when copying large hierarchies (especially when
compared with the stdopen approach of only suffering an up-front syscall
penalty).  And while coreutils does not keep fd 0, 1, or 2 tied open on a
useless file all the time, it is still putting pressure on these
descriptors during the window of the open_safer wrapper, so it has not
completely eliminated the EMFILE avoidance.  Also, the coreutils' approach
works well for a single-threaded application, but it needs modifications
to use the recently added POSIX 2008 open(O_CLOEXEC) and
fcntl(F_DUPFD_CLOEXEC) flags if it is to avoid leaking a temporary fd 0,
1, or 2 into child process created by a fork/exec in another thread during
the time that the first thread is calling open_safer.

Therefore it makes sense to move this functionality into the kernel, via
the addition of a new open() flag that informs the kernel that a
successful fd-creation syscall must behave as if fd 0, 1, and 2 were
already open.  The idea is not new, since fcntl(fd, F_DUPFD, 3) already
does just this.  Then, on kernels where this is available, coreutils can
alter its open_safer function to pass the new flag to the underlying
open() syscall, and avoid having to use fcntl/close to sanitize any
returned fd, with the result of no difference in the number of syscalls
regardless of whether the parent process started cp with stderr open or
closed.  It also solves the EMFILE and multithreading fd leak issue, since
a temporary fd 0, 1, or 2 is never opened in the first place.

The name proposed in this mail is O_NOSTD (implying that a successful
result will not be any of the standard file descriptors); other ideas
mentioned on the bug-gnulib list were O_SAFER, O_NONSTD, O_NOSTDFD.
http://lists.gnu.org/archive/html/bug-gnulib/2009-08/msg00358.html

Thoughts?

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
