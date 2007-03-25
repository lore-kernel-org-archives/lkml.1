Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXCYCOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXCYCOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 22:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXCYCOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 22:14:55 -0400
Received: from mail10.syd.optusnet.com.au ([211.29.132.191]:42039 "EHLO
	mail10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964804AbXCYCOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 22:14:54 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] sched: accurate user accounting
Date: Sun, 25 Mar 2007 12:14:04 +1000
User-Agent: KMail/1.9.5
Cc: malc <av1474@comtv.ru>, zwane@infradead.org, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>
References: <200703251159.03616.kernel@kolivas.org>
In-Reply-To: <200703251159.03616.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703251214.05058.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 11:59, Con Kolivas wrote:
> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>
> ---
> Currently we only do cpu accounting to userspace based on what is actually
> happening precisely on each tick. The accuracy of that accounting gets
> progressively worse the lower HZ is. As we already keep accounting of
> nanosecond resolution we can accurately track user cpu, nice cpu and idle
> cpu if we move the accounting to update_cpu_clock with a nanosecond
> cpu_usage_stat entry. This increases overhead slightly but avoids the
> problem of tick aliasing errors making accounting unreliable.

Vale, this fixes your testcase you sent. Attached below for reference. 

P.S. Sorry about one of the cc email addresses in the first email; I succumbed 
to a silly practical joke unwittingly so you'll have to remove it when 
replying to all.

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

-- 
-ck
