Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXGQILO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXGQILO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763517AbXGQIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:10:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:38656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757701AbXGQIKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:10:41 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19kb4Mx9ZVkz64YER76gVtzTxja4zO0aOK/4fz2p5
	P712MBpcH7AbZs
Message-ID: <469C6C9B.4070801@gmx.net>
Date: Tue, 17 Jul 2007 09:15:39 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: timerfd(2) draft man page plus questions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Below is my current draft of the timerfd.2 man page.  There are a number of
 points that I'm not sure of, and a few questions, all marked "FIXME
Davide" -- could you take a look at those please.

Aside from that there are a couple of questions I have on details of the
call (one of which I already started to cover off list).

1. timer_settime() and setitimer() both permit the caller to obtain the old
value of the timer when modifying an existing timer.  Why doesn't timerfd()
provide this functionality?

2. What if there are more expirations than can fit in a uint32_t?  (Why
wasn't this value uint64_t, as with eventfd()?)  (Actually, there seems to
be a bug which means that at the moment only a single byte of info is being
returned, but I'll cover that in a separate mail.)

Cheers,

Michael


.\" FIXME . Check later what header file glibc uses for timerfd
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
#include <sys/timerfd.h>        /* May yet change for glibc */
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>     /* Definition of uint32_t */

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

static void
print_elapsed_time(void)
{
    static struct timespec start;
    struct timespec curr;
    static int first_call = 1;
    int secs, nsecs;

    if (first_call) {
        first_call = 0;
        if (clock_gettime(CLOCK_MONOTONIC, &start) == \-1)
            die("clock_gettime");
    }

    if (clock_gettime(CLOCK_MONOTONIC, &curr) == \-1)
        die("clock_gettime");

    secs = curr.tv_sec \- start.tv_sec;
    nsecs = curr.tv_nsec \- start.tv_nsec;
    if (nsecs < 0) {
        secs\-\-;
        nsecs += 1000000000;
    }
    printf("%d.%03d: ", secs, (nsecs + 500000) / 1000000);
}

int
main(int argc, char *argv[])
{
    struct itimerspec utmr;
    int max_expirations, tot_exp, tfd;
    struct timespec now;
    uint32_t exp;
    ssize_t s;

    if ((argc != 2) && (argc != 4)) {
        fprintf(stderr, "%s init\-secs [interval\-secs max\-exp]\\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }

    if (clock_gettime(CLOCK_REALTIME, &now) == \-1)
        die("clock_gettime");

    /* Create a CLOCK_REALTIME absolute timer with initial
       expiration and interval as specified in command line */

    utmr.it_value.tv_sec = now.tv_sec + atoi(argv[1]);
    utmr.it_value.tv_nsec = now.tv_nsec;
    if (argc == 2) {
        utmr.it_interval.tv_sec = 0;
        max_expirations = 1;
    } else {
        utmr.it_interval.tv_sec = atoi(argv[2]);
        max_expirations = atoi(argv[3]);
    }
    utmr.it_interval.tv_nsec = 0;

    tfd = timerfd(\-1, CLOCK_REALTIME, TFD_TIMER_ABSTIME, &utmr);
    if (tfd == \-1)
        die("timerfd");

    print_elapsed_time();
    printf("timer started\\n");

.\"    exp = 0; // ????? Without this initialization, the results from
.\"             // read() are strange; it appears that read() is only
.\"             // returning one byte of tick information, not four.
    for (tot_exp = 0; tot_exp < max_expirations;) {
        s = read(tfd, &exp, sizeof(uint32_t));
        if (s != sizeof(uint32_t))
            die("read");

        tot_exp += exp;
        print_elapsed_time();
        printf("read: %u; total=%d\\n", exp, tot_exp);
    }

    exit(EXIT_SUCCESS);
}
.fi
.SH "SEE ALSO"
.BR eventfd (2),
.BR poll (2),
.BR read (2),
.BR select (2),
.BR signalfd (2),
.BR epoll (7),
.BR time (7)
.\" FIXME See: setitimer(2), timer_create(3), clock_settime(3)
.\" FIXME other timer syscalls, and have them refer to this page
.\" FIXME have SEE ALSO in time.7 refer to this page.




.\" Copyright (C) 2007 Michael Kerrisk <mtk-manpages@gmx.net>
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
.TH TIMERFD 2 2007-07-17 Linux "Linux Programmer's Manual"
.SH NAME
timerfd \- create a timer that delivers notifications on a file descriptor
.SH SYNOPSIS
.\" FIXME . This header file may well change
.\" FIXME . Probably _GNU_SOURCE will be required
.\" FIXME . May require: Link with \-lrt
.nf
.B #include <sys/timerfd.h>
.sp
.BR "int timerfd(int " ufd ", int " clockid ", int " flags ,
.BR "            const struct itimerspec *" utmr );
.fi
.SH DESCRIPTION
.BR timerfd ()
creates and starts a new timer (or modifies the settings of an
existing timer) that delivers timer expiration
information via a file descriptor.
This provides an alternative to the use of
.BR setitimer (2)
or
.BR timer_create (3),
and has the advantage that the file descriptor may be monitored by
.BR poll (2)
and
.BR select (2).
.\" FIXME Davide, a question: timer_settime() and setitimer()
.\" both permit the caller to obtain the old value of the
.\" timer when modifying an existing timer.  Why doesn't
.\" timerfd() provide this functionality?

The
.I ufd
argument is either \-1 to create a new timer,
or a file descriptor referring to an existing timerfd timer.
The remaining arguments specify the settings for the new timer,
or the modified settings for an existing timer.

The
.I clockid
argument specifies the clock that is used to mark the progress
of the timer, and must be either
.BR CLOCK_REALTIME
or
.BR CLOCK_MONOTONIC .
.B CLOCK_REALTIME
is a settable system-wide clock.
.B CLOCK_MONOTONIC
is a non-settable clock that is not affected
by discontinuous changes in the system clock
(e.g., manual changes to system time).
See also
.BR clock_getres (3).

The
.I flags
argument is either 0, to create a relative timer
.RI ( utmr.it_interval
specifies a relative time for the clock specified by
.IR clockid ),
or
.BR TFD_TIMER_ABSTIME ,
to create an absolute timer
.RI ( utmr.it_interval
specifies an absolute time for the clock specified by
.IR clockid ).

The
.I utmr
argument specifies the initial expiration and interval for the timer.
The
.I itimer
structure used for this argument contains two fields,
each of which is in turn a structure of type
.IR timespec :
.in +0.5i
.nf

struct timespec {
    time_t tv_sec;               /* Seconds */
    long   tv_nsec;              /* Nanoseconds */
};

struct itimerspec {
    struct timespec it_interval; /* Interval for periodic
                                    timer */
    struct timespec it_value;    /* Initial expiration */
};
.fi
.in
.PP
.IR utmr.it_value
specifies the initial expiration of the timer,
in seconds and nanoseconds.
Setting both fields of
.IR utmr.it_value
to zero will disable an existing timer
.RI ( ufd
!= \-1),
or create a new timer that is not armed
.RI ( ufd
== \-1).

Setting one or both fields of
.I utmr.it_interval
to non-zero values specifies the period, in seconds and nanoseconds,
for repeated timer expirations after the initial expiration.
If both fields of
.I utmr.it_interval
are zero, the the timer expires just once, at the time specified by
.IR utmr.it_value .
.PP
.BR timerfd (2)
returns a file descriptor that supports the following operations:
.TP
.BR read (2)
.\" FIXME Davide, What I have written below is what
.\" I've determined from looking at the source code
.\" and from experimenting.  But is it correct?
If the timer has already expired one or more times since it was created,
or since the last
.BR read (2),
then the buffer given to
.BR read (2)
returns an unsigned 4-byte integer
.RI ( uint32_t )
containing the number of expirations that have occurred.
.\" FIXME Davide, what if there are more expirations than can fit
.\" in a uint32_t?  (Why wasn't this value uint64_t, as with
.\" eventfd()?)
.IP
If no timer expirations have occurred at the time of the
.BR read (2),
then the call either blocks until the next timer expiration,
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
if the size of the supplied buffer is less than 4 bytes.
.TP
.BR poll "(2), " select "(2) (and similar)"
The file descriptor is readable
(the
.BR select (2)
.I readfds
argument; the
.BR poll (2)
.B POLLIN
flag)
if one or more timer expirations have occurred.
.IP
The timerfd file descriptor also supports the other file-descriptor
multiplexing APIs:
.BR pselect (2),
.BR ppoll (2),
and
.BR epoll (7).
.SS fork(2) semantics
.\" FIXME Davide, is the following correct?
After a
.BR fork (2),
the child inherits a copy of the timerfd file descriptor.
The file descriptor refers to the same underlying
file object as the corresponding descriptor in the parent,
and
.BR read (2)s
in the child will return information about
expirations of the timer.
.SS execve(2) semantics
.\" FIXME Davide, is the following correct?
A timerfd file descriptor is preserved across
.BR execve (2),
and continues to generate file expirations.
.SH "RETURN VALUE"
On success,
.BR timerfd ()
returns a timerfd file descriptor;
this is either a new file descriptor (if
.I ufd
was \-1), or
.I ufd
if
.I ufd
was a valid timerfd file descriptor.
On error, \-1 is returned and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EBADF
The
.I ufd
file descriptor is not a valid file descriptor.
.TP
.B EINVAL
The
.I ufd
file descriptor is not a valid timerfd file descriptor.
The
.I clockid
argument is neither
.B CLOCK_MONOTONIC
nor
.BR CLOCK_REALTIME .
The
.I utmr
is not properly initialized (one of the
.I tv_nsec
falls outside the range zero to 999,999,999).
.TP
.B EMFILE
The per-process limit of open file descriptors has been reached.
.TP
.B ENFILE
The system limit on the total number of open files has been
reached.
.TP
.B ENODEV
Could not mount (internal) anonymous i-node device.
.TP
.B ENOMEM
There was insufficient memory to handle the requested
.I op
control operation.
.SH VERSIONS
.BR timerfd (2)
is available on Linux since kernel 2.6.22.
.\" FIXME . check later to see when glibc support is provided
As at July 2007 (glibc 2.6), the details of the glibc interface
have not been finalized, so that, for example,
the eventual header file may be different from that shown above.
.SH CONFORMING TO
.BR timerfd (2)
is Linux specific.
.SH EXAMPLE
.nf

.\" FIXME . Check later what header file glibc uses for timerfd
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
#include <sys/timerfd.h>        /* May yet change for glibc */
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>     /* Definition of uint32_t */

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

static void
print_elapsed_time(void)
{
    static struct timespec start;
    struct timespec curr;
    static int first_call = 1;
    int secs, nsecs;

    if (first_call) {
        first_call = 0;
        if (clock_gettime(CLOCK_MONOTONIC, &start) == \-1)
            die("clock_gettime");
    }

    if (clock_gettime(CLOCK_MONOTONIC, &curr) == \-1)
        die("clock_gettime");

    secs = curr.tv_sec \- start.tv_sec;
    nsecs = curr.tv_nsec \- start.tv_nsec;
    if (nsecs < 0) {
        secs\-\-;
        nsecs += 1000000000;
    }
    printf("%d.%03d: ", secs, (nsecs + 500000) / 1000000);
}

int
main(int argc, char *argv[])
{
    struct itimerspec utmr;
    int max_expirations, tot_exp, tfd;
    struct timespec now;
    uint32_t exp;
    ssize_t s;

    if ((argc != 2) && (argc != 4)) {
        fprintf(stderr, "%s init\-secs [interval\-secs max\-exp]\\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }

    if (clock_gettime(CLOCK_REALTIME, &now) == \-1)
        die("clock_gettime");

    /* Create a CLOCK_REALTIME absolute timer with initial
       expiration and interval as specified in command line */

    utmr.it_value.tv_sec = now.tv_sec + atoi(argv[1]);
    utmr.it_value.tv_nsec = now.tv_nsec;
    if (argc == 2) {
        utmr.it_interval.tv_sec = 0;
        max_expirations = 1;
    } else {
        utmr.it_interval.tv_sec = atoi(argv[2]);
        max_expirations = atoi(argv[3]);
    }
    utmr.it_interval.tv_nsec = 0;

    tfd = timerfd(\-1, CLOCK_REALTIME, TFD_TIMER_ABSTIME, &utmr);
    if (tfd == \-1)
        die("timerfd");

    print_elapsed_time();
    printf("timer started\\n");

.\"    exp = 0; // ????? Without this initialization, the results from
.\"             // read() are strange; it appears that read() is only
.\"             // returning one byte of tick information, not four.
    for (tot_exp = 0; tot_exp < max_expirations;) {
        s = read(tfd, &exp, sizeof(uint32_t));
        if (s != sizeof(uint32_t))
            die("read");

        tot_exp += exp;
        print_elapsed_time();
        printf("read: %u; total=%d\\n", exp, tot_exp);
    }

    exit(EXIT_SUCCESS);
}
.fi
.SH "SEE ALSO"
.BR eventfd (2),
.BR poll (2),
.BR read (2),
.BR select (2),
.BR signalfd (2),
.BR epoll (7),
.BR time (7)
.\" FIXME See: setitimer(2), timer_create(3), clock_settime(3)
.\" FIXME other timer syscalls, and have them refer to this page
.\" FIXME have SEE ALSO in time.7 refer to this page.


