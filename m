Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZH1Ma6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZH1Ma6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZH1Ma4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:30:56 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:46398
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbZH1M2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:28:38 -0400
Message-ID: <4A97CD78.7080705@byu.net>
Date: Fri, 28 Aug 2009 06:28:40 -0600
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net> <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com> <4A968FF8.8050109@byu.net> <4A96969B.2090004@redhat.com>
In-Reply-To: <4A96969B.2090004@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to Ulrich Drepper on 8/27/2009 8:22 AM:
>> I hope that my example shows why doing it in the kernel is desirable -
>> there is no safe way to keep the pre-O_CLOEXEC efficiency using just the
>> library, but there IS a way to do it with kernel support:
> 
> You're describing a very special case where the performance implications
> are really minimal and try to argue that is a good enough reason?  I
> don't think so.
> 
> If a program really has to do thousands of these safe open calls then it
> can invest time into opening /dev/null for any of the unallocated
> descriptors < 3.  You can even embed this logic in the safer_open function.

But that's what I've been trying to explain.  There are cases where
opening a dummy /dev/null descriptor interferes with behavior, and where
you NEED to leave the std descriptors closed.

Again, let's look at coreutils, which already is using a version of
open_safer in many of its utilities.  Consider 'cp -i a b <&-'.  If b does
not exist, then there is no reason for cp to prompt, so it never reads
from stdin, and the fact that stdin was closed must not interfere with
execution.  Which means cp cannot just blindly warn if it detects that
stdin was closed when it started; it has to wait until conditions warrant
reading from stdin.  On the other hand, if b exists, coreutils' cp
correctly warns the user about the inability to read from stdin:

$ cp -i a b <&-
cp: overwrite `b'? cp: error closing file: Bad file descriptor
$ echo $?
1

If coreutils were to tie fd 0 to /dev/null, then it can no longer
distinguish a read failure when reading the prompt from stdin, and would
no longer be able to alert the user to the failed interactive copy.

Next, consider 'cp -uv a b >&-'.  Coreutils uses printf() to print status
messages, but only if an update warranted a message.  Again, that means
coreutils wants to know whether stdout is a valid file, and tying fd 1 to
/dev/null can get in the way:

$ cp -uv a b >&-
$ rm b
$ cp -uv a b >&-
cp: write error: Bad file descriptor

Now, couple this with the fact that 'cp -r' can visit thousands of files
during its course of operation.  There is no sane way to tie dummy fds to
the standard descriptors, and still be able to distinguish failure to use
a standard descriptor but only on the execution paths that actually used
that standard descriptor.  Hence, there is a definite use case for keeping
the std fds closed, rather than putting dummies in their place; but to
preserve this setup without kernel support, every single open() (and
dup(), pipe(), socket(), ...) must be wrapped to use fcntl/close to move
new fds back out of this range.  And cp is an example of an existing
program that really DOES end up paying a penalty of thousands of
fcntl/close calls if started with a standard fd closed, in order to
preserve its semantics.

Furthermore, while the coreutils' implementation of open_safer operates
correctly in a single-threaded environment, it cannot close the race in a
multi-threaded context if the application started life with fd 2 closed,
since there is a window of time during open_safer where another thread can
attempt to use stderr and see thread 1's newly opened file before it can
be moved safely out of the way:

thread 1              thread 2
open_safer...
 open -> 2
 fcntl(2,F_DUPFD,3)
                      fputc(stderr)
                      fflush(stderr) -> clobbers thread 1's file
 close(2)
open_safer -> 3

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqXzXgACgkQ84KuGfSFAYA+ZwCgvuQ3PpDDLhLozqCUm3qyhIVj
aqQAnR+MgdLg5apNEdHdIn9nlr4yRISI
=0tcQ
-----END PGP SIGNATURE-----
