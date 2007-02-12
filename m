Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbXBLSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbXBLSFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965260AbXBLSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:05:24 -0500
Received: from comtv.ru ([217.10.32.17]:47113 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965248AbXBLSFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:05:23 -0500
X-UCL: actv
Date: Mon, 12 Feb 2007 21:05:38 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@home.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: CPU load
In-Reply-To: <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702122101001.2345@home.oyster.ru>
References: <loom.20070212T063225-663@post.gmane.org>
 <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Con Kolivas wrote:

> On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:
>> Hello,

[..snip..]

>
> The kernel looks at what is using cpu _only_ during the timer
> interrupt. Which means if your HZ is 1000 it looks at what is running
> at precisely the moment those 1000 timer ticks occur. It is
> theoretically possible using this measurement system to use >99% cpu
> and record 0 usage if you time your cpu usage properly. It gets even
> more inaccurate at lower HZ values for the same reason.

And indeed it appears to be possible to do just that. Example:

/* gcc -o hog smallhog.c */
#include <time.h>
#include <limits.h>
#include <signal.h>
#include <sys/time.h>

#define HIST 10

static sig_atomic_t stop;

static void sighandler (int signr)
{
     (void) signr;
     stop = 1;
}

static unsigned long hog (unsigned long niters)
{
     stop = 0;
     while (!stop && --niters);
     return niters;
}

int main (void)
{
     int i;
     struct itimerval it = { .it_interval = { .tv_sec = 0, .tv_usec = 1 },
                             .it_value = { .tv_sec = 0, .tv_usec = 1 } };
     sigset_t set;
     unsigned long v[HIST];
     double tmp = 0.0;
     unsigned long n;

     signal (SIGALRM, &sighandler);
     setitimer (ITIMER_REAL, &it, NULL);

     for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog (ULONG_MAX);
     for (i = 0; i < HIST; ++i) tmp += v[i];
     tmp /= HIST;
     n = tmp - (tmp / 3.0);

     sigemptyset (&set);
     sigaddset (&set, SIGALRM);

     for (;;) {
         hog (n);
         sigwait (&set, &i);
     }
     return 0;
}
/* end smallhog.c */

Might need some adjustment for a particular system but ran just fine here
on:
2.4.30   + Athlon tbird (1Ghz)
2.6.19.2 + Athlon X2 3800+ (2Ghz)

Showing next to zero load in top(1) and a whole lot more in APC.

http://www.boblycat.org/~malc/apc/load-tbird-hog.png
http://www.boblycat.org/~malc/apc/load-x2-hog.png

Not quite 99% but nevertheless scary.

-- 
vale
