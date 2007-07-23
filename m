Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXGWG1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXGWG1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbXGWG1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:27:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:48549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757587AbXGWG1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:27:40 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX187KQFHzBQ7DW4qzIOR+B+QXZz3vk5FadOHHfrsGM
	tOXdRHNdXboICX
Message-ID: <46A44B7D.3030700@gmx.net>
Date: Mon, 23 Jul 2007 08:32:29 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: lkml <linux-kernel@vger.kernel.org>, Linux Torvalds <torvalds@osdl.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com
Subject: Problems with timerfd()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The timerfd() syscall went into 2.6.22.  While writing the man page for
this syscall I've found some notable limitations of the interface, and I am
wondering whether you and Linus would consider having this interface fixed
for 2.6.23.

On the one hand, these fixes would be an ABI change, which is of course
bad.  (However, as noted below, you have already accepted one of the ABI
changes that I suggested into -mm, after Davide submitted a patch.)

On the other hand, the interface has not yet made its way into a glibc
release, and the change will not break applications.  (The 2.6.22 version
of the interface would just be "broken".)

Details of my suggested changes are below.  A complication in all of this
is that on Friday, while I was part way though discussing this with Davide,
he went on vacation for a month and is likely to have only limited email
access during that time.  (See my further thoughts about what to do while
Davide is away at the end of this mail message.)  Our last communication,
after Davide had expressed reluctance about making some of the interface
changes, was a more extensive note from me describing the problems of the
interface.

The problems of the 2.6.22 timerfd() interface are as follows:

Problem 1
---------

The value returned by read(2)ing from a timerfd file descriptor is the
number of timer overruns.  In 2.6.22, this value is 4 bytes, limiting the
overrun count  to 2^32.  Consider an application where the timer frequency
was 100 kHz (feasible in the not-too-distant future, I would guess), then
the overrun counter would cycle after ~40000 seconds (~11 hours).
Furthermore returning 4 bytes from the read() is inconsistent with eventfd
file descriptors, which return 8 byte integers from a read().

Davide has already submitted a patch to you to make read() from a timerfd
file descriptor return an 8 byte integer, and I understand it to have been
accepted into -mm.

Problem 2
---------
Existing timer APIs (Unix interval timers -- setitimer(2); POSIX timers --
timer_settime()) allow the caller to retrieve the previous setting of a
timer at the same time as a new timer setting is established.  This permits
functionality such as the following for userland programs:

1. set a timer to go of at time X
2. modify the timer to go off at earlier time Z; return previous
   timer settings (X)
3. When the timer Z expires, restore timer to expire at time X

timerfd() does not provide this functionality.

Problem 3
---------

Existing timer APIs (Unix interval timers -- getitimer(2); POSIX timers --
timer_gettime()) allow the caller to retrieve the time remaining until the
next expiration of the timer.

timerfd() does not provide this functionality.

Solution (proposed interface changes)
-------------------------------------

In response to my "Problem 2", Davide noted in the last message I got from
him before he went on vacation:

> But the old status of the timer is the union of clickid, flags and utmr.
> So, in theory, the whole set should be returned back, forcing a pretty
> drastic API change.

However, I think there is a reasonable solution to this problem, which I
outlined to Davide, but did not yet hear back from him about.

a) Make the 'clockid' immutable: say that it can only be set
   if 'ufd' is -1 -- that is, on the timerfd() call that
   first creates the timer.  This would eliminate the need to
   return the previous clockid value.  (This is effectively
   the limitation that is imposed by POSIX timers: the
   clockid is specified when the timer is created with
   timer_create(), and can't be changed.)

   [In the 2.6.22 interface, the clockid of an existing
   timer can be changed with a further call to timerfd()
   that specifies the file descriptor of an existing timer.]

b) There is no need to return the previous 'flags' setting.
   The POSIX timer functions (i.e., timer_settime()) do not
   do this. Instead, timer_settime() always returns the
   time until the next expiration would have occurred,
   even if the TIMER_ABSTIME flag was specified when
   the timer was set.

   [The only 'flags' value currently implemented in
   timerfd() is TFD_TIMER_ABSTIME, which is the
   equivalent of TIMER_ABSTIME.]

With these design assumptions, the only thing that would need
to be added to timerfd() would be an argument used to return the time
until the previous timer would have expired + its interval.

The use cases would be as follows:

ufd = timerfd(-1, clockid, flags, utmr, NULL);
to create a new timer with given clockid, flags, and utmr (intial
expiration + interval).

ufd = timerfd(ufd, 0, flags, utmr, NULL);
to change the flags and timer settings of an existing timer.

ufd = timerfd(ufd, 0, flags, utmr, &old);
to change the flags and timer settings of an existing timer, and retrieve
the time until the next expiration of the timer (and the associated interval).

ufd = timerfd(ufd, 0, 0, NULL, &old);
Return the time until the next expiration of the timer (and the associated
interval), without changing the existing timer settings

Practical details
-----------------

Since Davide is away, my proposal is this: if you are prepared to consider
entertaining this ABI change, then I would try to write the patch.  If when
we next hear from Davide (he may have intermittent email access over the
next month), he agrees that it is worth making the change, then I would
submit the change to -mm with the hope that time frames would allow for it
to make it into 2.6.23.  (I would guess that delaying things for a month
means the fix might not make it into 2.6.23, and would thus simply make the
fix more painful and less feasible.)

What do you think?

Cheers,

Michael

PS For reference, the timerfd.2 man page describing the 2.6.22 interface is
below.

.TH TIMERFD 2 2007-07-17 Linux "Linux Programmer's Manual"
.SH NAME
timerfd \- create a timer that delivers notifications on a file descriptor
.SH SYNOPSIS
.\" FIXME . This header file may well change
.\" FIXME . Probably _GNU_SOURCE will be required
.\" FIXME . May require: Link with \fI\-lrt\f
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
/* Link with -lrt */
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


