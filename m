Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbXLNLYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbXLNLYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbXLNLYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:24:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:38885 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbXLNLYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=fGXBXJwLqfbuSsf79sCNDnykYV9luNVvXsEhWE1US1JjcqJDcBgSMBE5UFoazogrudCp/APv4iRDHJn6/0wXANJqo57ucw9LEAqk+jCcWmSOvm7cY929GSqhlg6u9n2OsmqoSBIhf1B/2mCKHlmrpEC4m0tx9QPdJDVnzQxw63A=
Message-ID: <4762683D.8050007@gmail.com>
Date: Fri, 14 Dec 2007 12:25:49 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux Torvalds <torvalds@linux-foundation.org>
Subject: Re: Tesing of / bugs in new timerfd API
References: <47614369.3060906@gmail.com>  <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com> <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com> <Pine.LNX.4.64.0712131603010.10881@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0712131603010.10881@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Davide Libenzi wrote:
> On Thu, 13 Dec 2007, Michael Kerrisk wrote:
> 
>>>> BUG 2:
>>>> The last sentence does not match the implementation.
>>>> (Nor is it consistent with the behavior of POSIX timers.
>>>> And I *think* things did work correctly in the original
>>>> timerfd() implementation, but I have not gone back to check.)
>>>>
>>>> Suppose that we set an absolute timer to expire 100 seconds
>>>> in the future.  Then according to this sentence of the man
>>>> page then each subsequent call to timerfd_gettime() should
>>>> retrun an itimerspec structure whose it_value steadily
>>>> decreases from 100 to 0 (when the timer expires).  (This
>>>> is the behavior in the analogous situation with POSIX timers
>>>> and with setitimer()/getitimer().)
>>>>
>>>> However, the implementation of timerfd_gettime() always
>>>> returns the "time when the timer would next expire", and
>>>> this value depends on whether TFD_TIMER_ABSTIME was specified
>>>> when setting the timer.
>>> This is been like that from the beginning of the new API. So no, the
>>> previous was behaving exactly the same WRT this feature.
>>> Is this something really needed?
>> Three reasons that I think of off the top of my head (and there might
>> well be more reasosn) why this should change:
>>
>> a) consistency with the other two timer APIs (POSIX timers
>> (timer_create(), etc.), and setitimer()/getitimer()).

You made no comment on this, which is perhaps the most important of the
reasons to make the change.

>> b) Returning the amount of time until the next expiration  is more
>> useful to userland: I'd say the most common case is for userland to
>> want to know how long until the next expiration occurs, or to adjust
>> that time by adding/subtracting some value to the existing setting.
>> That is difficult to with the current implementation: the userland app
>> must use timer_gettime(), call clock_gettime(), and calculate the
>> difference between the two, in order to know how much time remains
>> until the next timer expiration.
> 
> Bah, I don't want to argue with that because otherwise it starts going 
> towards the "typical" use cases listing, that can be found the same exact 
> reasons to have one or the other way. And we end up wasting lots of time.
> We'd just have to move another thing that userspace could do, inside the 
> kernel (subtract the current value returned by hrtimer_forward() in 
> ->expires with "now").

Okay -- I still think this reason matters, but let's leave it for the
moment.  I think the other reasons are strong enough anyway...

>> c) Currently, the information returned differs depending on whether
>> TFD_TIMER_ABSTIME is specified -- this is not the case for the
>> analogous situation for POSIX timers.  For POSIX timers, the returned
>> setting is always the amount of time until the timer next expires.
>> This inconsistency is messy for applications -- the application may
>> not (be able to) know whether or not the timer it is examining was set
>> using TFD_TIMER_ABSTIME (the timerfd might have been created by a
>> library, for example).
> 
> Hmm... the time returned is always the next absolute time when the next 
> timer tick will go off. It does not depend on TFD_TIMER_ABSTIME. I return 
> the ->expires field of the timer, and hrtimer_forward() sets it to the 
> next absolute time.

You snipped my example that demonstrated the problem.  Both of the
following runs create a timer that expires 10 seconds from "now", but
observe the difference in the value returned by timerfd_gettime():

$ ./timerfd_test 10         # does not use TFD_TIMER_ABSTIME
Initial setting for settime:   value=10.000, interval=0.000
./timerfd_test> g
(elapsed time=  1)
Current value:                 value=346.448, interval=0.000

$ ./timerfd_test -a 10      # uses TFD_TIMER_ABSTIME
Initial setting for settime:   value=1197630855.254, interval=0.000
./timerfd_test> g
(elapsed time=  1)
Current value:                 value=1197630855.254, interval=0.000

Either there's an inconsistency here depending on the use of
TFD_TIMER_ABSTIME, or there is a bug in my understanding or my test program
(but so far I haven't spotted that bug ;-).).

Cheers,

Michael

PS There was a little bug in my test program, do do with the treatment of
nanosecond command-line arguments.  It didn't affect any of the tests, but
for completeness, the revised version of the program is below.

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
                atol(argv[optind + 1]) + now.tv_nsec : now.tv_nsec;
        if (new_value.it_value.tv_nsec > 1000000000) {
            new_value.it_value.tv_sec +=
                    new_value.it_value.tv_nsec / 1000000000;
            new_value.it_value.tv_nsec %= 1000000000;
        } /* if */
    } else {
        new_value.it_value.tv_sec = atoi(argv[optind]);
        new_value.it_value.tv_nsec = (argc > optind + 1) ?
                       atol(argv[optind + 1]) : 0;
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

