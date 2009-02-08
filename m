Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZBHVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZBHVSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZBHVSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:18:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:1285 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZBHVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=YBiRAfbyJ3REWiLdo20Sr0x2FllznoE0j/EErlq+C3jaDHJ+TNE86bJ8WGIS3yXmdm
         7r/7ThVmlujJP7Kss3wmQ6vBgtCm6rRwMRsuY1MnToEaZgqvy5xXri4/erxrqe+aB3xa
         LvesjWMTtYDQ0VE2310dccaz3UmpPP79ZifMs=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>
	 <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
	 <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
Date: Mon, 9 Feb 2009 10:18:21 +1300
Message-ID: <cfd18e0f0902081318p3b7efde5u3977a9fdadf3f542@mail.gmail.com>
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and 
	CLOCK_MONOTONIC?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 9:46 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 8 Feb 2009, Davide Libenzi wrote:
>
>> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
>>
>> > Hi Davide,
>> >
>> > At the moment I'm looking into writing man pages for timer_create(2)
>> > and friends.  (Somewhat bizarrely, these pages do not yet exist.)  As
>> > I looked into the source code of timer_create(), etc., and did some
>> > tests, I saw that timer_create() supports the following clocks:
>> >
>> > TIMER_REALTIME
>> > TIMER_MONOTONIC
>> > TIMER_PROCESS_CPUTIME_ID
>> > TIMER_THREAD_CPUTIME_ID
>> > clockid obtained from clock_getcpuclockid(3)
>> > clockid obtained from pthread_getcpuclockid(3)
>> >
>> > On the other hand, timerfd() only permits the first two of these.
>> > What's the reason for that limitation of timerfd()?  (It may be worth
>> > adding something to the man page on this point.)
>>
>> No particular reason I can think of. If Thomas makes invalid_clockid()
>> available, we could allow timerfd() to support all time timers
>> timer_create() supports.
>> Do you see any reason why this won't work Thomas?
>
> Patch, not tested, below.

(Has it been compiled?)

A further comment below.

> ---
>  fs/timerfd.c                 |   10 ++++------
>  include/linux/posix-timers.h |    1 +
>  include/linux/timerfd.h      |   13 ++++++++++---
>  kernel/posix-timers.c        |    2 +-
>  4 files changed, 16 insertions(+), 10 deletions(-)
>
> Index: linux-2.6.mod/fs/timerfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/timerfd.c     2009-02-08 12:32:25.000000000 -0800
> +++ linux-2.6.mod/fs/timerfd.c  2009-02-08 12:43:57.000000000 -0800
> @@ -18,6 +18,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/time.h>
>  #include <linux/hrtimer.h>
> +#include <linux/posix-timers.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/timerfd.h>
>  #include <linux/syscalls.h>
> @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
>        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
>
> -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
> +       if ((flags & ~TFD_FLAGS_SET) ||
> +           invalid_clockid(clockid))
>                return -EINVAL;
> -       if (clockid != CLOCK_MONOTONIC &&
> -           clockid != CLOCK_REALTIME)
> -               return -EINVAL;
> -
>        ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>        if (!ctx)
>                return -ENOMEM;
> @@ -201,7 +199,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>        hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
>
>        ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
> -                              flags & (O_CLOEXEC | O_NONBLOCK));
> +                              flags & TFD_SHARED_FCNTL_FLAGS);
>        if (ufd < 0)
>                kfree(ctx);
>
> Index: linux-2.6.mod/include/linux/posix-timers.h
> ===================================================================
> --- linux-2.6.mod.orig/include/linux/posix-timers.h     2009-02-08 12:32:25.000000000 -0800
> +++ linux-2.6.mod/include/linux/posix-timers.h  2009-02-08 12:33:12.000000000 -0800
> @@ -84,6 +84,7 @@ struct k_clock {
>                           struct itimerspec * cur_setting);
>  };
>
> +int invalid_clockid(const clockid_t which_clock);
>  void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
>
>  /* error handlers for timer_create, nanosleep and settime */
> Index: linux-2.6.mod/kernel/posix-timers.c
> ===================================================================
> --- linux-2.6.mod.orig/kernel/posix-timers.c    2009-02-08 12:32:25.000000000 -0800
> +++ linux-2.6.mod/kernel/posix-timers.c 2009-02-08 12:32:57.000000000 -0800
> @@ -205,7 +205,7 @@ static int no_timer_create(struct k_itim
>  /*
>  * Return nonzero if we know a priori this clockid_t value is bogus.
>  */
> -static inline int invalid_clockid(const clockid_t which_clock)
> +int invalid_clockid(const clockid_t which_clock)
>  {
>        if (which_clock < 0)    /* CPU clock, posix_cpu_* will check it */
>                return 0;
> Index: linux-2.6.mod/include/linux/timerfd.h
> ===================================================================
> --- linux-2.6.mod.orig/include/linux/timerfd.h  2009-02-08 12:34:25.000000000 -0800
> +++ linux-2.6.mod/include/linux/timerfd.h       2009-02-08 12:36:09.000000000 -0800
> @@ -11,13 +11,20 @@
>  /* For O_CLOEXEC and O_NONBLOCK */
>  #include <linux/fcntl.h>
>
> -/* Flags for timerfd_settime.  */
> +/*
> + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> + * new flags, since they might collide with O_* ones. We want
> + * to re-use O_* flags that couldn't possibly have a meaning
> + * from eventfd, in order to leave a free define-space for
> + * shared O_* flags.
> + */
>  #define TFD_TIMER_ABSTIME (1 << 0)
> -
> -/* Flags for timerfd_create.  */
>  #define TFD_CLOEXEC O_CLOEXEC
>  #define TFD_NONBLOCK O_NONBLOCK
>
> +#define TFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)

s/O_/TFD_/g above

> +#define TFD_FLAGS_SET (TFD_SHARED_FCNTL_FLAGS | TFD_TIMER_ABSTIME)
> +
>
>  #endif /* _LINUX_TIMERFD_H */

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
