Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbXECGi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbXECGi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXECGi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:38:58 -0400
Received: from [212.12.190.91] ([212.12.190.91]:33028 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754972AbXECGi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:38:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Date: Thu, 3 May 2007 09:42:51 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200705030211.39345.a1426z@gawab.com> <200705030651.43865.a1426z@gawab.com> <20070503043541.GC19966@holomorphy.com>
In-Reply-To: <20070503043541.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rRYOGVjnqf7VW4k"
Message-Id: <200705030942.51301.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary-00=_rRYOGVjnqf7VW4k
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> >> That's odd. The ->load_weight changes should've improved that quite
> >> a bit. There may be something slightly off in how lag is computed,
> >> or maybe the O(n) lag issue Ying Tang spotted is biting you.
>
> On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> > Is it not biting you too?
>
> I'm a kernel programmer. I'm not an objective tester.
>
> It also happens to be the case that I personally have never encountered
> a performance problem with any of the schedulers, mainline included, on
> any system I use interactively. So my "user experience" is not valuable.
>
> William Lee Irwin III wrote:
> >> Also, I should say that the nice number affairs don't imply fairness
> >> per se. The way that works is that when tasks have "weights" (like
> >> nice levels in UNIX) the definition of fairness changes so that each
> >> task gets shares of CPU bandwidth proportional to its weight instead
> >> of one share for one task.
>
> On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> > Ok, but you can easily expose scheduler unfairness by using nice levels
> > as relative magnifiers; provided nice levels are implemented correctly.
>
> This doesn't really fit in with anything I'm aware of.

You are not the first person that doesn't understand what I'm talking about.  
Don't worry about it.

> William Lee Irwin III wrote:
> >> The other thing to do is try a different number of tasks with a
> >> different mix of nice levels. The weight w_i for a given nice
> >> level n_i should be the same even in a different mix of tasks
> >> and nice levels if the nice levels are the same.
> >> If this sounds too far out, there's nothing to worry about. You can
> >> just run the different numbers of tasks with different mixes of nice
> >> levels and post the %cpu numbers. Or if that's still a bit far out
> >> for you, a test that does all this is eventually going to get written.
>
> On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> > chew.c does exactly that, just make sure sched_granularity_ms >=
> > 5,000,000.
>
> Please post the source of chew.c

Attached.


Thanks!

--
Al



--Boundary-00=_rRYOGVjnqf7VW4k
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="chew.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="chew.c"

/*
 * original idea by Chris Friesen.  Thanks.
 */

#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>

#define THRESHOLD_USEC 2000

unsigned long long stamp()
{
        struct timeval tv;
        gettimeofday(&tv, 0);
        return (unsigned long long) tv.tv_usec + ((unsigned long long) tv.tv_sec)*1000000;
}


int main()
{
        unsigned long long thresh_ticks = THRESHOLD_USEC;
        unsigned long long cur, last, start, act, delta;
        struct timespec ts;

        sched_rr_get_interval(0, &ts);
        printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

        start = last = stamp();
        while(1) {
                cur = stamp();
                delta = cur-last;
                if (delta > thresh_ticks) {
			act = last - start;
                        printf("pid %d, prio %3d, out for %4llu ms, ran for %4llu ms, load %3llu%\n"
			, getpid(), getpriority(PRIO_PROCESS, 0), delta/1000, act/1000,(act*100)/(cur-start));
                        start = cur = stamp();
                }
                last = cur;
        }

        return 0;
}

--Boundary-00=_rRYOGVjnqf7VW4k--

