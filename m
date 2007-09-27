Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXI0MVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXI0MVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXI0MVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:21:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:54504 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750869AbXI0MVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:21:39 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+3g7gdb0C35wz5ewJJuE3v0ac6yKjN99j1qiNnje
	DW59Dmo+soJO9B
Message-ID: <46FB9FB9.8080201@gmx.net>
Date: Thu, 27 Sep 2007 14:19:05 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk,
       Christoph Hellwig <hch@lst.de>
Subject: Revised signalfd man-page
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

Below is the current signalfd man-page.  Could you please review to see
whether the man page describes the intended implementation, and especially
look at a few questions embedded in the page (look for "Davide").

Cheers,

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
.TH SIGNALFD 2 2007-09-27 Linux "Linux Programmer's Manual"
.SH NAME
signalfd \- create a file descriptor for accepting signals
.SH SYNOPSIS
.\" FIXME . This header file may well change
.\" FIXME . Probably _GNU_SOURCE will be required
.\" FIXME . May require: Link with \fI\-lrt\f
.B #include <sys/signalfd.h>
.sp
.BI "int signalfd(int " fd ", const sigset_t *" mask );
.\" Almost certainly the glibc wrapper will hide this argument:
.\" ", size_t " sizemask
.SH DESCRIPTION
.BR signalfd (2)
creates a file descriptor that can be used to accept signals
targeted at the caller.
This provides an alternative to the use of a signal handler or
.BR sigwaitinfo (2),
and has the advantage that the file descriptor may be monitored by
.BR select (2),
.BR poll (2),
and
.BR epoll (7).
The
.I mask
argument specifies the set of signals that the caller
wishes to accept via the file descriptor.
This argument is a signal set whose contents can be initialized
using the macros described in
.BR sigsetops (3).
Normally, the set of signals to be received via the
file descriptor should be blocked using
.BR sigprocmask (2),
to prevent the signals being handled according to their default
dispositions.
It is not possible to receive
.B SIGKILL
or
.B SIGSTOP
signals via a signalfd file descriptor;
these signals are silently ignored if specified in
.IR mask .

If the
.I fd
argument is \-1,
then the call creates a new file descriptor and associates the
signal set specified in
.I mask
with that descriptor.
If
.I fd
is not \-1,
then it must specify a valid existing signalfd file descriptor, and
.I mask
is used to replace the signal set associated with that descriptor.

.BR signalfd (2)
returns a file descriptor that supports the following operations:
.TP
.BR read (2)
If one or more of the signals specified in
.I mask
is pending for the process, then the buffer supplied to
.BR read (2)
is used to return one or more
.I signalfd_siginfo
structures (see below) that describe the signals.
The
.BR read (2)
returns information for as many signals as are pending and will
fit in the supplied buffer.
The buffer must be at least
.I "sizeof(struct signalfd_siginfo)"
bytes.
The return value of the
.BR read (2)
is the total number of bytes read.
.IP
As a consequence of the
.BR read (2),
the signals are consumed,
so that they are no longer pending for the process
(i.e., will not be caught by signal handlers,
and cannot be accepted using
.BR sigwaitinfo (2)).
.IP
If none of the signals in
.I mask
is pending for the process, then the
.BR read (2)
either blocks until one of the signals in
.I mask
is generated for the process,
or fails with the error
.B EAGAIN
if the file descriptor has been made non-blocking
(via the use of the
.BR fcntl (2)
.B F_SETFL
operation to set the
.B O_NONBLOCK
flag).

.\" FIXME Davide, what does the following mean?  How (in userspace
.\" terms) does a sighand structure become orphaned?
The
.BR read (2)
call can also return 0,
in case the sighand structure to which the signalfd was attached,
has been orphaned.
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
if one or more of the signals in
.I mask
is pending for the process.
.IP
The signalfd file descriptor also supports the other file-descriptor
multiplexing APIs:
.BR pselect (2),
.BR ppoll (2),
and
.BR epoll (7).
.TP
.BR close (2)
When the file descriptor is no longer required it should be closed.
When all file descriptors associated with the same signalfd object
have been closed, the resources for object are freed by the kernel.
.SS The signalfd_siginfo structure
The format of the
.I signalfd_siginfo
structure(s) returned by
.BR read (2)s
from a signalfd file descriptor is as follows:
.in +0.5i
.nf

.\" FIXME Davide, a question: why rename these fields to be
.\" different from their siginfo_t counterparts?  At the very least,
.\" it would have been nicer to use the same names with prefixes
.\" such as (say) "fdsi_" (thus, e.g., fdsi_signo); that would have
.\" made grepping both kernel and userland source code easier
.\" (e.g, to find instances of "si_signo" in a siginfo_t or a
.\" signalfd_siginfo structure), and also would have avoided
.\" weirdnesses like trimming "errno" down to err.
.\"
struct signalfd_siginfo {  /* Analog in siginfo_t */
    uint32_t  signo;       /* si_signo */
    int32_t   err;         /* si_errno */
    int32_t   code;        /* si_code */
    uint32_t  pid;         /* si_pid */
    uint32_t  uid;         /* si_uid */
    int32_t   fd;          /* si_fd */
    uint32_t  tid;         /* si_tid */
    uint32_t  band;        /* si_band */
    uint32_t  overrun;     /* si_overrun */
    uint32_t  trapno;      /* si_trapno */
.\" trapno is unused on most (all?) arches?
    int32_t   status;      /* si_status */
    int32_t   svint;       /* si_int */
    uint64_t  svptr;       /* si_ptr */
    uint64_t  utime;       /* si_utime */
    uint64_t  stime;       /* si_stime */
    uint64_t  addr;        /* si_addr */
    uint28_t  pad[\fIX\fP];  /* Pad size to 128 bytes (allow space
                          additional fields in the future) */
};

.fi
.in
As indicated in the comments, each of the fields in this structure
is analogous to a similarly named field in the
.I siginfo_t
structure.
The
.I siginfo_t
structure is described in
.BR sigaction (2).
Not all fields in the returned
.I signalfd_siginfo
structure will be valid for a specific signal;
the set of valid fields can be determined from the value returned in the
.I code
field.
This field is the analog of the
.I siginfo_t
.I si_code
field; see
.BR sigaction (2)
for details.
.SS fork(2) semantics
After a
.BR fork (2),
the child inherits a copy of the signalfd file descriptor.
The file descriptor refers to the same underlying
file object as the corresponding descriptor in the parent,
and
.BR read (2)s
in the child will return information about signals generated
for the parent
(the process that created the object using
.BR signalfd (2)).
.SS execve(2) semantics
[TO BE COMPLETED]
.\" FIXME
.\" Davide, what are the intended semantics after an execve()?
.\" As far as I can work out, after an execve() the file descriptor
.\" is still available, but reads from it always return 0, even if:
.\"
.\" a) there were signals pending before the execve().
.\"    However, sigpending() shows the signal as pending,
.\"    and the signal can be accepted using sigwaitinfo().
.\"
.\" b) we generate the signal after the exec.
.\"
.\" Is this intended behavior (the "orphaned sighand" condition
.\" described above?)?  Is it a bug?
.\"
.SS Thread semantics
[TO BE COMPLETED]
.\" FIXME Davide, a signal can be directed to the process as
.\" a whole, or to a particular thread.  What are the intended
.\" semantics for signalfd()?  If a thread calls signalfd(),
.\" does the resulting file descriptor return just those
.\" signals directed to [the thread and the process as a whole],
.\" or will it also receive signals that are targeted at
.\" other threads in the process?
.SH "RETURN VALUE"
On success,
.BR signalfd ()
returns a signalfd file descriptor;
this is either a new file descriptor (if
.I fd
was \-1), or
.I fd
if
.I fd
was a valid signalfd file descriptor.
On error, \-1 is returned and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EBADF
The
.I fd
file descriptor is not a valid file descriptor.
.TP
.B EINVAL
.I fd
is not a valid signalfd file descriptor.
.\" or the
.\" .I sizemask
.\" argument is not equal to
.\" .IR sizeof(sigset_t) ;
.TP
.B EMFILE
The per-process limit of open file descriptors has been reached.
.TP
.B ENFILE
The system-wide limit on the total number of open files has been
reached.
.TP
.B ENODEV
Could not mount (internal) anonymous i-node device.
.TP
.B ENOMEM
There was insufficient memory to create a new signalfd file descriptor.
.SH VERSIONS
.BR signalfd (2)
is available on Linux since kernel 2.6.22.
.\" FIXME . check later to see when glibc support is provided
As at September 2007 (glibc 2.6), the details of the glibc interface
have not been finalized, so that, for example,
the eventual header file may be different from that shown above.
.\" FIXME The wrapper will almost certainly hide the sizemask
.\" argument, just as with pselect() and ppoll().
.SH CONFORMING TO
.BR signalfd (2)
is Linux specific.
.SH NOTES
The underlying Linux system call requires a third argument,
.IR "size_t sizemask" ,
which specifies the size of the
.I mask
argument.
The glibc
.BR signalfd ()
wrapper function provides the required value for this argument.

.\" FIXME Davide, are all of the details in the following
.\" paragraph correct?
A process can create multiple signalfd file descriptors.
This makes it possible to accept different signals
on different file descriptors.
(This may be useful if monitoring the file descriptors using
.BR select (2),
.BR poll (2),
or
.BR epoll (7):
the arrival of different signals will make different descriptors ready.)
If a signal appears in the
.I mask
of more than one of the file descriptors, then occurrences
of that signal can be read (once) from any one of the descriptors.
.SH EXAMPLE
The program below accepts the signals
.B SIGINT
and
.B SIGQUIT
via a signalfd file descriptor.
The program terminates after accepting a
.B SIGQUIT
signal.
The following shell session demonstrates the use of the program:
.in +0.5i
.nf

$ ./signalfd_demo
^C                    # Control\-C generates SIGINT
Got SIGINT
^C
Got SIGINT
^\\                    # Control\-\\ generates SIGQUIT
Got SIGQUIT
$
.fi
.in
.nf

.\" FIXME . Check later what header file glibc uses for signalfd
.\" FIXME . Probably glibc will require _GNU_SOURCE to be set
.\"
.\" The commented out code here is what we currently need until
.\" the required stuff is in glibc
.\"
.\" #define _GNU_SOURCE
.\" #include <sys/syscall.h>
.\" #include <unistd.h>
.\" #include <stdint.h>
.\" #include <signal.h>
.\" #if defined(__i386__)
.\" #define __NR_eventfd 323
.\" #endif
.\"
.\" struct signalfd_siginfo {
.\"    uint32_t signo;     /* si_signo */
.\"    int32_t  err;       /* si_errno */
.\"    int32_t  code;      /* si_code */
.\"    uint32_t pid;       /* si_pid */
.\"    uint32_t uid;       /* si_uid */
.\"    int32_t  fd;        /* si_fd */
.\"    uint32_t tid;       /* si_fd */
.\"    uint32_t band;      /* si_band */
.\"    uint32_t overrun;   /* si_overrun */
.\"    uint32_t trapno;    /* si_trapno */
.\"    int32_t  status;    /* si_status */
.\"    int32_t  svint;     /* si_int */
.\"    uint64_t svptr;     /* si_ptr */
.\"    uint64_t utime;     /* si_utime */
.\"    uint64_t stime;     /* si_stime */
.\"    uint64_t addr;      /* si_addr */
.\"    uint8_t  __pad[48];
.\"};
.\"
.\"static int
.\"signalfd(int fd, sigset_t const *mask)
.\"{
.\"#define SIZEOF_SIG (_NSIG / 8)
.\"#define SIZEOF_SIGSET (SIZEOF_SIG > sizeof(sigset_t) ? \
.\"                       sizeof(sigset_t): SIZEOF_SIG)
.\"    return syscall(__NR_signalfd, fd, mask, SIZEOF_SIGSET);
.\"}
.\"
#include <sys/signalfd.h>       /* May yet change for glibc */
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

int
main(int argc, char *argv[])
{
    sigset_t mask;
    int sfd;
    struct signalfd_siginfo fdsi;
    ssize_t s;

    sigemptyset(&mask);
    sigaddset(&mask, SIGINT);
    sigaddset(&mask, SIGQUIT);

    /* Block signals so that they aren't handled
       according to their default dispositions */

    if (sigprocmask(SIG_BLOCK, &mask, NULL) == \-1)
        die("sigprocmask");

    sfd = signalfd(\-1, &mask);
    if (sfd == \-1)
        die("signalfd");

    for (;;) {
        s = read(sfd, &fdsi, sizeof(struct signalfd_siginfo));
        if (s != sizeof(struct signalfd_siginfo))
            die("read");

        if (fdsi.signo == SIGINT) {
            printf("Got SIGINT\\n");
        } else if (fdsi.signo == SIGQUIT) {
            printf("Got SIGQUIT\\n");
            exit(EXIT_SUCCESS);
        } else {
            printf("Read unexpected signal\\n");
        }
    }
}
.fi
.SH "SEE ALSO"
.BR eventfd (2),
.BR poll (2),
.BR read (2),
.BR select (2),
.BR signalfd (2),
.BR sigaction (2),
.BR sigprocmask (2),
.BR sigwaitinfo (2),
.BR timerfd (2),
.BR sigsetops (3),
.BR epoll (7),
.BR signal (7)
.\" FIXME add SEE ALSO from signal.7, signal.2, sigwaitinfo.2,
.\" sigaction.2 to this page
