Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbXLMOfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbXLMOfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXLMOfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:35:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:40783 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXLMOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=uvOTPxVHP+AAXMfL6O/ZtLuKvO9JCzHOzCiNgcpwD/M3855i99Ffoaz2FuJKlfKaECOQjHZRaezitkIVaEOXxUsHmQBNZpf7j8DDOvgKeYaN13M6ag8FiPKZhwy/O/wtDYUQbiZGr7V5enF670nZxqdiRE5UKqi0v50PNJEVz0A=
Message-ID: <47614369.3060906@gmail.com>
Date: Thu, 13 Dec 2007 15:36:25 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux Torvalds <torvalds@linux-foundation.org>
Subject: Tesing of / bugs in new timerfd API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide, Andrew,

I applied Davide's v3 patchset (sent into LKML on 25 Nov) against
2.4.24-rc3, and did various tests (all on x86).  Several tests
were done using the program at the foot of this mail.  Various others
were done by cobbling together bits of code that I haven't included
here.

In covering the tests I ran, and as a kind of proof of concept,
I'll treat the draft man page as the test spec.

I think I've found two bugs (look for the string "BUG" below), one
of which is a significant deviation from expected behavior.  See
the comments below.

Cheers,

Michael


> SYNOPSIS
>     #include <sys/timerfd.h>
>
>     int timerfd_create(int clockid, int flags);
>
>     int timerfd_settime(int fd, int flags,
>                         const struct itimerspec *new_value,
>                         struct itimerspec *curr_value);
>
>     int timerfd_gettime(int fd,
>                          struct itimerspec *curr_value);
>
> DESCRIPTION
>     These system calls create and operate on  a  timer  that
>     delivers  timer  expiration  notifications  via  a  file
>     descriptor.  They provide an alternative to the  use  of
>     setitimer(2) or timer_create(3), with the advantage that
>     the file  descriptor  may  be  monitored  by  select(2),
>     poll(2), and epoll(7).
>
>     The  use of these three system calls is analogous to the
>     use of timer_create(3), timer_settime(3), and timer_get-
>     time(3).   (There  is no analog of timer_gettoverrun(3),
>     since that functionality  is  provided  by  read(2),  as
>     described below.)
>
>   timerfd_create()
>     timerfd_create() creates a new timer object, and returns
>     a file  descriptor  that  refers  to  that  timer.   The
>     clockid  argument  specifies  the  clock that is used to
>     mark the progress of  the  timer,  and  must  be  either
>     CLOCK_REALTIME  or CLOCK_MONOTONIC.

Verified.  I've tried creating various combinations of
CLOCK_REALTIME and CLOCK_MONOTONIC timers, both one shot
(it_interval is zero) and repeating (it_interval is non-zero),
and everything works as I would expect.

>     CLOCK_REALTIME is a
>     settable system-wide clock.  CLOCK_MONOTONIC is  a  non-
>     settable  clock  that  is  not affected by discontinuous
>     changes in the system clock  (e.g.,  manual  changes  to
>     system time).  The current value of each of these clocks
>     can be retrieved using clock_gettime(3).
>
>     The flags argument is reserved for future  use.   As  at
>     Linux 2.6.25, this argument must be specified as zero.

(Verified: see the ERRORS section of the man page, below.)

>   timerfd_settime()
>     timerfd_settime()  arms  (starts) or disarms (stops) the
>     timer referred to by the file descriptor fd.

Disarming a timer works fine in my tests.

>     The new_value argument specifies the initial  expiration
>     and  interval  for the timer.  The itimer structure used
>     for this argument contains two fields, each of which  is
>     in turn a structure of type timespec:
>
>       struct timespec {
>           time_t tv_sec;                /* Seconds */
>           long   tv_nsec;               /* Nanoseconds */
>       };
>
>       struct itimerspec {
>           struct timespec it_interval;  /* Interval for
>                                            periodic timer */
>           struct timespec it_value;     /* Initial
>                                            expiration */
>       };
>
>     new_value.it_value  specifies  the initial expiration of
>     the timer, in seconds and nanoseconds.   Setting  either
>     field of new_value.it_value to a non-zero value arms the
>     timer.  Setting both  fields  of  new_value.it_value  to
>     zero disarms the timer.

Verified: setting both  fields  of  new_value.it_value  to
zero disarms the timer.

>     Setting  one  or both fields of new_value.it_interval to
>     non-zero values specifies the  period,  in  seconds  and
>     nanoseconds,  for  repeated  timer expirations after the
>     initial    expiration.

I've tested intervals down to 1 nanosec, which seem to seems to
work as I would expect.  (But see the BUG reported below.)

>     If     both     fields     of
>     new_value.it_interval  are  zero, the timer expires just
>     once, at the time specified by new_value.it_value.

Verified.

>     The flags argument is either  0,  to  start  a  relative
>     timer  (new_value.it_interval  specifies a time relative
>     to the current value of the clock specified by clockid),
>     or   TFD_TIMER_ABSTIME,   to  start  an  absolute  timer
>     (new_value.it_interval specifies an  absolute  time  for
>     the  clock specified by clockid; that is, the timer will
>     expire when the value of that clock  reaches  the  value
>     specified in new_value.it_interval).

Tested: after setting a CLOCK_REALTIME timer with the
TFD_TIMER_ABSTIME flag to expire at some time in the past with
a non-zero interval (e.g., setting 100 seconds in the past, with
a 5 second interval), read() from the file descriptor returns
the correct number of expirations (e.g., 20).

This seems a reasonable thing to do, I suppose.  However, while
playing around to test this, I found what looks like a bug (see
below).

BUG 1:
However, this test exposed what looks like a bug: if I set a
CLOCK_REALTIME clock to expire in the past, with a very small
interval, then the maximum number of expirations that can be
returned via read seems to be limited to 32 bits, even though
we have a 64-bit value for returning this information.
I haven't checked the kernel source to determine where this
bug is.

To demonstrate the bug use the program appended to this mail,
as follows:

# The following starts a CLOCK_REALTIME repeating timer with
# an interval of 1 microsecs (1000 nanosecs), with an initial
# expiration of just under 2^32 nanoseconds in the past.
# The '-a' flags says use TFD_TIMER_ABSTIME for timer_settime() calls.
# The 'r' command reads from the timerfd file descriptor.

$ ./timerfd_test -a -- -4290 0 0 1000
Initial setting for settime:   value=1197543860.000, interval=0.000
./timerfd_test> r           <-- type this immediately
Read: 4292190752            <-- nearly 2^32 expirations, as expected

$ ./timerfd_test -a -- -4290 0 0 1000
Initial setting for settime:   value=1197543900.000, interval=0.000
./timerfd_test> r           <-- type this after 5 secs
Read: 2992244               <-- Looks like the counter rolled over


>     The  curr_value  argument returns a structure containing
>     the setting of the timer that was current at the time of
>     the  call; see the description of timerfd_gettime() fol-
>     lowing.

See the bug described under timerfd_gettime().

>   timerfd_gettime()
>     timerfd_gettime() returns, in curr_value, an  itimerspec
>     that  contains the current setting of the timer referred
>     to by the file descriptor fd.
>
>     The it_value field returns the amount of time until  the
>     timer  will  next expire.  If both fields of this struc-
>     ture are zero, then the  timer  is  currently  disarmed.
>     This  field always contains a relative value, regardless
>     of whether the TFD_TIMER_ABSTIME flag was specified when
>     setting the timer.

BUG 2:
The last sentence does not match the implementation.
(Nor is it consistent with the behavior of POSIX timers.
And I *think* things did work correctly in the original
timerfd() implementation, but I have not gone back to check.)

Suppose that we set an absolute timer to expire 100 seconds
in the future.  Then according to this sentence of the man
page then each subsequent call to timerfd_gettime() should
retrun an itimerspec structure whose it_value steadily
decreases from 100 to 0 (when the timer expires).  (This
is the behavior in the analogous situation with POSIX timers
and with setitimer()/getitimer().)

However, the implementation of timerfd_gettime() always
returns the "time when the timer would next expire", and
this value depends on whether TFD_TIMER_ABSTIME was specified
when setting the timer.

Examples:
$ ./timerfd_test -a -- 100       # -a means TFD_TIMER_ABSTIME
Initial setting for settime:   value=1197550329.140, interval=0.000
./timerfd_test> g                <-- Calls timerfd_gettime()
(elapsed time=  1)
Current value:                 value=1197550329.140, interval=0.000

$ ./timerfd_test -- 100
Initial setting for settime:   value=100.295, interval=0.000
./timerfd_test> g
(elapsed time=  2)
Current value:                 value=18208.440, interval=0.000

In both of the above examples, the "value" retrieved by timer_gettime()
should be a number <= 100.


BUG 2a:
The bug described for timerfd_gettime() also applies for the
'curr_value' returned by a call to timerfd_settime().


>     The it_interval field returns the interval of the timer.

Verified: the above was true in all my tests.

>     If both fields of this  structure  are  zero,  then  the
>     timer  is set to expire just once, at the time specified
>     by curr_value.it_value.

Verified.

>   Operating on a timer file descriptor
>     The file descriptor returned  by  timerfd_create()  sup-
>     ports the following operations:
>
>     read(2)
>            If  the  timer  has  already  expired one or more
>            times since its settings were last modified using
>            timerfd_settime(),  or  since the last successful
>            read(2), then the buffer given to read(2) returns
>            an  unsigned 8-byte integer (uint64_t) containing
>            the number of  expirations  that  have  occurred.

Verified: each call to timerfd_settime() resets the "expiration
count" to 0, even if a previous setting of the timer had already
expired.

>            (The  returned value is in host byte order, i.e.,
>            the native byte order for integers  on  the  host
>            machine.)
>
>            If no timer expirations have occurred at the time
>            of the read(2), then the call either blocks until
>            the  next  timer  expiration,

Verified.

>            or  fails with the
>            error EAGAIN if the file descriptor has been made
>            non-blocking (via the use of the fcntl(2) F_SETFL
>            operation to set the O_NONBLOCK flag).

Verified.

>            A read(2) will fail with the error EINVAL if  the
>            size of the supplied buffer is less than 8 bytes.

Verified.

>     poll(2), select(2) (and similar)
>            The file descriptor is  readable  (the  select(2)
>            readfds argument; the poll(2) POLLIN flag) if one
>            or more timer expirations have occurred.

Verified for both poll() and select().

>            The file descriptor also supports the other file-
>            descriptor    multiplexing    APIs:   pselect(2),
>            ppoll(2), and epoll(7).
>
>     close(2)
>            When the file descriptor is no longer required it
>            should  be  closed.   When  all  file descriptors
>            associated with the same timer object  have  been
>            closed,  the  timer is disarmed and its resources
>            are freed by the kernel.

Not verified.  (No easy way to do that from userspace.)

>   fork(2) semantics
>     After a fork(2), the child inherits a copy of  the  file
>     descriptor   created   by  timerfd_create().   The  file
>     descriptor refers to the same underlying timer object as
>     the  corresponding  file  descriptor  in the parent, and
>     read(2)s in the  child  will  return  information  about
>     expirations of the timer.

Verified.  Reads from a dup(2)ed file descriptor, or a file
descriptor duplicated via a fork(2) can be used to read
expiration information.

>   execve(2) semantics
>     A  file  descriptor  created by timerfd_create() is pre-
>     served across execve(2), and continues to generate timer
>     expirations if the timer was armed.

Verified.  A timerfd file descriptor is preserved across an
exceve(), and continues to generate timer expirations that
can be read(2).

> RETURN VALUE
>     On success, timerfd_create() returns a new file descrip-
>     tor.  On error, -1 is returned and errno is set to indi-
>     cate the error.

Verified.  (And obvious.)

>     timerfd_settime() and timerfd_gettime() return 0 on suc-
>     cess; on error they return -1, and set errno to indicate
>     the error.

Verified.  (And obvious.)

> ERRORS
>     timerfd_create() can fail with the following errors:
>
>     EINVAL The  clockid  argument is neither CLOCK_MONOTONIC
>            nor CLOCK_REALTIME;

(CLOCK_MONOTONIC is 1, CLOCK_REALTIME is 0)
Tested: clockid == 2, clockid == -1;
        timerfd_create() fails with EINVAL, as expected.

>            or flags is invalid.

Currently, 'flags' must be zero.
Tested: flags == 1;
        timerfd_create() fails with EINVAL, as expected.

>     EMFILE The per-process limit of  open  file  descriptors
>            has been reached.

Not tested.

>     ENFILE The system-wide limit on the total number of open
>            files has been reached.

Not tested.

>     ENODEV Could  not  mount  (internal)  anonymous   i-node
>            device.

Not tested.

>     ENOMEM There  was  insufficient  kernel memory to create
>            the timer.

Not tested.

>     timerfd_settime() and timerfd_gettime()  can  fail  with
>     the following errors:
>
>     EBADF  fd is not a valid file descriptor.

Tested for timerfd_gettime() and timerfd_settime().
      An invalid file descriptor (i.e., a file descriptor that
      is not open) yields the error EBADF, as expected.

>     EINVAL fd  is  not  a  valid  timerfd  file  descriptor.

Tested for timerfd_gettime() and timerfd_settime().
      Passing a file descriptor that refers to an object other
      than a timerfd fails with the error EINVAL, as expected.

>            new_value is not properly initialized (one of the
>            tv_nsec   falls   outside   the   range  zero  to
>            999,999,999).

Tested for timerfd_settime().
     Specifying it_value.tv_nsec == 1000000000 or
     it_interval.tv_nsec == 1000000000 yields the error EINVAL,
     as expected.

--- END MAN PAGE TEXT ---

/* timerfd_test.c */

/* Link with -lrt */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>
#if defined(__i386__)
#define __NR_timerfd_create 322
#define __NR_timerfd_settime 325
#define __NR_timerfd_gettime 326
#endif

static int
timerfd_create(int clockid, int flags)
{
    return syscall(__NR_timerfd_create, clockid, flags);
}

static int
timerfd_settime(int fd, int flags, struct itimerspec *new_value,
        struct itimerspec *curr_value)
{
    return syscall(__NR_timerfd_settime, fd, flags,
            new_value, curr_value);
}

static int
timerfd_gettime(int fd, struct itimerspec *curr_value)
{
    return syscall(__NR_timerfd_gettime, fd, curr_value);
}

#define TFD_TIMER_ABSTIME (1 << 0)


#define handle_error(msg) \
        do { perror(msg); exit(EXIT_FAILURE); } while (0)

// #include <sys/timerfd.h>
#include <time.h>
#include <sys/times.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>     /* Definition of uint64_t */

static void
usage(const char *pname, const char *msg)
{
    if (msg != NULL)
        printf("%s", msg);
    fprintf(stderr, "Usage: %s [options] value-sec [value-nsec "
            "[intvl-sec [intvl-nsec]]]\n", pname);
    fprintf(stderr, "Options are:\n");
    fprintf(stderr, "\t-a    Use absolute timer\n");
    fprintf(stderr, "\t-m    Use CLOCK_MONOTONIC "
            "(instead of CLOCK_REALTIME)\n");

    exit(EXIT_FAILURE);
} /* usage  */

static void
display_help(void)
{
    printf("n val-sec val-nsec intvl-sec intvl-nsec\n"
           "                  Reset timer value & interval\n");
    printf("g                 Get timer value\n");
    printf("r                 Read from file descriptor\n");
    printf("t                 Print elapsed time\n");
} /* display_help */


#define MAX_LINE 1024

static void
print_itimerspec(struct itimerspec *its)
{
    printf("value=%ld.%03ld, interval=%ld.%03ld",
            (long) its->it_value.tv_sec,
            (long) its->it_value.tv_nsec / 1000000,
            (long) its->it_interval.tv_sec,
            (long) its->it_interval.tv_nsec / 1000000);
} /* print_itimerspec */


int
main(int argc, char *argv[])
{
    struct itimerspec new_value, curr_value;
    int fd, flags;
    struct timespec now;
    int s, opt, use_abs_timer, use_monotonic;
    long arg1, arg2, arg3, arg4;
    uint64_t exp;
    time_t start;
    char line[MAX_LINE];
    int num_read, clockid;
    char cmd;

    use_abs_timer = 0;
    use_monotonic = 0;

    while ((opt = getopt(argc, argv, "am")) != -1) {
        switch (opt) {
        case 'a':
            use_abs_timer = 1;
            break;

        case 'm':
            use_monotonic = 1;
            break;

        default:
            usage(argv[1], NULL);
            break;
        } /* switch */
    } /* while */

    clockid = (use_monotonic ? CLOCK_MONOTONIC : CLOCK_REALTIME);

    if (optind + 1 > argc)
        usage(argv[0], NULL);

    if (clock_gettime(clockid, &now) == -1)
        handle_error("clock_gettime");

    flags = use_abs_timer ? TFD_TIMER_ABSTIME : 0;

    /* Create a timer with initial expiration and interval
       as specified in command line */

    if (use_abs_timer) {
        new_value.it_value.tv_sec = now.tv_sec + atoi(argv[optind]);
        new_value.it_value.tv_nsec = (argc > optind + 1) ?
                        atol(argv[optind + 1]) : now.tv_nsec;
    } else {
        new_value.it_value.tv_sec = atoi(argv[optind]);
        new_value.it_value.tv_nsec = (argc > optind + 1) ?
                       atol(argv[optind + 1]) : now.tv_nsec;
    }

    new_value.it_interval.tv_sec = (argc > optind + 2) ?
                        atol(argv[optind + 2]) : 0;
    new_value.it_interval.tv_nsec = (argc > optind + 3) ?
                        atol(argv[optind + 3]) : 0;

    fd = timerfd_create(clockid, 0);
    if (fd == -1)
        handle_error("timerfd_create");

    printf("Initial setting for settime:   ");
    print_itimerspec(&new_value);
    printf("\n");

    s = timerfd_settime(fd, flags, &new_value, &curr_value);
    if (s == -1)
        handle_error("timerfd_settime");

    start = time(NULL);

    for ( ; ; ) {
        printf("%s> ", argv[0]);
        fflush(stdout);

        if (fgets(line, MAX_LINE, stdin) == NULL)       /* EOF */
            exit(EXIT_SUCCESS);
        line[strlen(line) - 1] = '\0';      /* Remove trailing '\n' */

        if (*line == '\0')
            continue;                       /* Skip blank lines */

        if (line[0] == '?')
            display_help();

        num_read = sscanf(line, " %c %ld %ld %ld %ld",
                          &cmd, &arg1, &arg2, &arg3, &arg4);

        switch (cmd) {
        case 'n':
            if (num_read != 5) {
                printf("Wrong number of arguments\n");
                continue;
            }

            if (use_abs_timer) {
                printf("This is an absolute timer\n");
                if (clock_gettime(clockid, &now) == -1)
                    handle_error("clock_gettime");
                printf("Now:                           ");
                printf("value=%ld.%03ld", (long) now.tv_sec,
                        (long) now.tv_nsec / 1000000);
                printf("\n");

                new_value.it_value.tv_sec = now.tv_sec + arg1;
                new_value.it_value.tv_nsec = now.tv_nsec + arg2;

            } else {
                printf("This is a relative timer\n");
                new_value.it_value.tv_sec = arg1;
                new_value.it_value.tv_nsec = arg2;
            }

            new_value.it_interval.tv_sec = arg3;
            new_value.it_interval.tv_nsec = arg4;

            printf("New setting for settime:       ");
            print_itimerspec(&new_value);
            printf("\n");

            s = timerfd_settime(fd, flags, &new_value, &curr_value);
            if (s == -1) {
                perror("timerfd_settime");
                break;
            }
            printf("Previous setting from settime: ");
            print_itimerspec(&curr_value);
            printf("\n");

            break;

        case 't':
            printf("%ld\n", (long) (time(NULL) - start));
            break;

        case 'g':
            s = timerfd_gettime(fd, &curr_value);
            if (s == -1)
                handle_error("timerfd_gettime");
            printf("(elapsed time=%3ld)\n", (long) (time(NULL) - start));
            printf("Current value:                 ");
            print_itimerspec(&curr_value);
            printf("\n");
            break;

        case 'r':
            s = read(fd, &exp, sizeof(uint64_t));
            if (s != sizeof(uint64_t))
                handle_error("read");
            printf("Read: %lld\n", exp);
            break;
        } /* switch */
    } /* for */

    exit(EXIT_SUCCESS);
}


