Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbXI0MLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbXI0MLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbXI0MLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:11:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:57928 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752051AbXI0MLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:11:14 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX187IcdnP0c7tQlEVCyvQYJ1HKxT0SOmAhPbyFD5c4
	E+Snm9zW+OHkH0
Message-ID: <46FB9D4B.4090909@gmx.net>
Date: Thu, 27 Sep 2007 14:08:43 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk
Subject: eventfd.2 man page
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

I've slightly tweaked the eventfd.2 man page in preparation for adding it
to the man-pages set.  Could you please review the text below, and confirm
that it correctly describes intended behavior.

Thanks,

Michael


.\" Copyright (C) 2007 Michael Kerrisk <mtk.manpages@gmail.com>
.\" starting from a version by Davide Libenzi <davidel@xmailserver.org>
.\"
.\" This program is free software; you can redistribute it and/or modify
.\" it under the terms of the GNU General Public License as published by
.\" the Free Software Foundation; either version 2 of the License, or
.\" (at your option) any later version.
.\"
.\" This program is distributed in the hope that it will be useful,
.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
.\" GNU General Public License for more details.
.\"
.\" You should have received a copy of the GNU General Public License
.\" along with this program; if not, write to the Free Software
.\" Foundation, Inc., 59 Temple Place, Suite 330, Boston,
.\" MA  02111-1307  USA
.\"
.TH EVENTFD 2 2007-09-27 Linux "Linux Programmer's Manual"
.SH NAME
eventfd \- create a file descriptor for event notification
.SH SYNOPSIS
.\" FIXME . This header file may well change
.\" FIXME . Probably _GNU_SOURCE will be required
.\" FIXME . May require: Link with \fI\-lrt\fP
.B #include <sys/eventfd.h>
.sp
.BI "int eventfd(unsigned int " initval );
.SH DESCRIPTION
.BR eventfd ()
creates an "eventfd object"
that can be used as
an event wait/notify mechanism by userspace applications,
and by the kernel to notify userspace applications of events.
The object contains an unsigned 64-bit integer
.RI ( uint64_t )
counter that is maintained by the kernel.
This counter is initialized with the value specified in the argument
.IR initval .

As its return value,
.BR eventfd ()
returns a new file descriptor that can be used to refer to the
eventfd object.
The following operations can be performed on the file descriptor:
.TP
.BR read (2)
If the eventfd counter has a non-zero value, then a
.BR read (2)
returns 8 bytes containing that value,
and the counter's value is reset to zero.
.IP
If the counter is zero at the time of the
.BR read (2),
then the call either blocks until the counter becomes non-zero,
or fails with the error
.B EAGAIN
if the file descriptor has been made non-blocking
(via the use of the
.BR fcntl (2)
.B F_SETFL
operation to set the
.B O_NONBLOCK
flag).
.IP
A
.BR read (2)
will fail with the error
.B EINVAL
if the size of the supplied buffer is less than 8 bytes.
.TP
.BR write (2)
A
.BR write (2)
call adds the 8-byte integer value supplied in its
buffer to the counter.
The maximum value that may be stored in the counter is the largest
unsigned 64-bit value minus 1 (i.e., 0xfffffffffffffffe).
If the addition would cause the counter's value to exceed
the maximum, then the
.BR write (2)
either blocks until a
.BR read (2)
is performed on the file descriptor,
or fails with the error
.B EAGAIN
if the file descriptor has been made non-blocking.
.IP
A
.BR write (2)
will fail with the error
.B EINVAL
if the size of the supplied buffer is less than 8 bytes,
or if an attempt is made to write the value 0xffffffffffffffff.
.TP
.BR poll "(2), " select "(2) (and similar)"
The returned file descriptor supports
.BR poll (2)
(and anaologously
.BR epoll (7))
and
.BR select (2),
as follows:
.RS
.IP * 3
The file descriptor is readable
(the
.BR select (2)
.I readfds
argument; the
.BR poll (2)
.B POLLIN
flag)
if the counter has a value greater than 0.
.IP *
The file descriptor is writable
(the
.BR select (2)
.I writefds
argument; the
.BR poll (2)
.B POLLOUT
flag)
if it is possible to write a value of at least "1" without blocking.
.IP *
The file descriptor indicates an exceptional condition
(the
.BR select (2)
.I exceptfds
argument; the
.BR poll (2)
.B POLLERR
flag)
if an overflow of the counter value was detected.
As noted above,
.BR write (2)
can never overflow the counter.
However an overflow can occur if 2^64
eventfd "signal posts" were performed by the KAIO
subsystem (theoretically possible, but practically unlikely).
If an overflow has occurred, then
.BR read (2)
will return that maximum
.I uint64_t
value (i.e., 0xffffffffffffffff).
.RE
.IP
The eventfd file descriptor also supports the other file-descriptor
multiplexing APIs:
.BR pselect (2),
.BR ppoll (2),
and
.BR epoll (7).
.TP
.BR close (2)
When the file descriptor is no longer required it should be closed.
When all file descriptors associated with the same eventfd object
have been closed, the resources for object are freed by the kernel.
.PP
A copy of the file descriptor created by
.BR eventfd ()
is inherited by the child produced by
.BR fork (2).
The duplicate file descriptor is associated with the same
eventfd object.
File descriptors created by
.BR eventfd (2)
are preserved across
.BR execve (2).
.SH "RETURN VALUE"
On success,
.BR eventfd ()
returns a new eventfd file descriptor.
On error, \-1 is returned and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EMFILE
The per-process limit on open file descriptors has been reached.
.TP
.B ENFILE
The system-wide limit on the total number of open files has been
reached.
.TP
.B ENODEV
.\" Note from Davide:
.\" The ENODEV error is basically never going to happen if
.\" the kernel boots correctly. That error happen only if during
.\" the kernel initialization, some error occur in the anonymous
.\" inode source initialization.
Could not mount (internal) anonymous i-node device.
.TP
.B ENOMEM
There was insufficient memory to create a new
eventfd file descriptor.
.SH VERSIONS
.BR eventfd (2)
is available on Linux since kernel 2.6.22.
.\" FIXME . check later to see when glibc support is provided
As at September 2007 (glibc 2.6), the details of the glibc interface
have not been finalized, so that, for example,
the eventual header file may be different from that shown above.
.SH CONFORMING TO
.BR eventfd (2)
is Linux specific.
.SH NOTES
Applications can use an eventfd file descriptor instead of a pipe (see
.BR pipe (2))
in all cases where a pipe is used simply to signal events.
The kernel overhead of an eventfd file descriptor
is much lower than that of a pipe,
and only one file descriptor is
required (versus the two required for a pipe).

When used in the kernel, an eventfd
file descriptor can provide a kernel-userspace bridge allowing,
for example, functionalities like KAIO (kernel AIO)
.\" or eventually syslets/threadlets
to signal to a file descriptor that some operation is complete.

A key point about an eventfd file descriptor is that it can be
monitored just like any other file descriptor using
.BR select (2),
.BR poll (2),
or
.BR epoll (7).
This means that an application can simultaneously monitor the
readiness of "traditional" files and the readiness of other
kernel mechanisms that support the eventfd interface.
(Without the
.BR eventfd ()
interface, these mechanisms could not be multiplexed via
.BR select (2),
.BR poll (2),
or
.BR epoll (7).)
.SH EXAMPLE
.PP
The following program creates an eventfd file descriptor
and then forks to create a child process.
While the parent briefly sleeps,
the child writes each of the integers supplied in the program's
command-line arguments to the eventfd file descriptor.
When the parent has finished sleeping,
it reads from the eventfd file descriptor.

The following shell session shows a sample run of the program:
.in +0.5i
.nf

$ ./a.out 1 2 4 7 14
Child writing 1 to efd
Child writing 2 to efd
Child writing 4 to efd
Child writing 7 to efd
Child writing 14 to efd
Child completed write loop
Parent about to read
Parent read 28 (0x1c) from efd
.fi
.in
.nf

.\" FIXME . Check later what header file glibc uses for eventfd
.\" FIXME . Probably glibc will require _GNU_SOURCE to be set
.\"
.\" The commented out code here is what we currently need until
.\" the required stuff is in glibc
.\"
.\" #define _GNU_SOURCE
.\" #include <sys/syscall.h>
.\" #include <unistd.h>
.\" #include <time.h>
.\" #if defined(__i386__)
.\" #define __NR_timerfd 322
.\" #endif
.\"
.\" static int
.\" timerfd(int ufd, int clockid, int flags, struct itimerspec *utmr) {
.\"     return syscall(__NR_timerfd, ufd, clockid, flags, utmr);
.\" }
.\"
.\" #define TFD_TIMER_ABSTIME (1 << 0)
.\"
#include <sys/eventfd.h>        /* May yet change for glibc */
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>             /* Definition of uint64_t */

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

int
main(int argc, char *argv[])
{
    int efd, j;
    uint64_t u;
    ssize_t s;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <num>...\\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    efd = eventfd(0);
    if (efd == \-1)
        die("eventfd");

    switch (fork()) {
    case 0:
        for (j = 1; j < argc; j++) {
            printf("Child writing %s to efd\\n", argv[j]);
            u = strtoull(argv[j], NULL, 0);
                    /* strtoull() allows various bases */
            s = write(efd, &u, sizeof(uint64_t));
            if (s != sizeof(uint64_t))
                die("write");
        }
        printf("Child completed write loop\\n");

        exit(EXIT_SUCCESS);

    default:
        sleep(2);

        printf("Parent about to read\\n");
        s = read(efd, &u, sizeof(uint64_t));
        if (s != sizeof(uint64_t))
            die("read");
        printf("Parent read %llu (0x%llx) from efd\\n", u, u);
        exit(EXIT_SUCCESS);

    case \-1:
        die("fork");
    }
}
.fi
.SH "SEE ALSO"
.BR poll (2),
.BR read (2),
.BR select (2),
.BR signalfd (2),
.BR timerfd (2),
.BR write (2),
.BR epoll (7)


