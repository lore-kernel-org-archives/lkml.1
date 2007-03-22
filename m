Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXCVOhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXCVOhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXCVOhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:37:22 -0400
Received: from [212.12.190.194] ([212.12.190.194]:32866 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932991AbXCVOhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:37:21 -0400
From: Al Boldi <a1426z@gawab.com>
Subject: [patch] 2.6.21-rc4 nicksched v32
Date: Thu, 22 Mar 2007 17:40:47 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vVpAG7TMC0urdWZ"
Message-Id: <200703221740.47801.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary-00=_vVpAG7TMC0urdWZ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Nick Piggin wrote:
> Forward port of nicksched to 2.6.21-rc4.

Great!

> Can't find my old
> design/description document for it, but it is yet another scheduler. Focus
> is on simplicity and fairness.

Simplicity is really key.

> This one tends to require X to be reniced to -10 or so for best results
> (renice -10 `pidof X`).

No problem.

> Timeslices get scaled by /proc/sys/kernel/base_timeslice. If you have bad
> interactivity you could try lowering this and see if it helps.

As I am on 2.6.20, I can't really test this patch, but I tried your sched 
from PlugSched and its not bad.

I'm getting strange numbers with chew.c, though.  Try this:
Boot into /bin/sh
Run ./chew on one console.
Run ./chew on another console.
Watch latencies.

Console 1:
pid 671, prio   0, out for  799 ms, ran for  800 ms, load  50%
pid 671, prio   0, out for  799 ms, ran for  801 ms, load  50%
pid 671, prio   0, out for  799 ms, ran for  799 ms, load  49%
pid 671, prio   0, out for  800 ms, ran for  800 ms, load  49%

Console 2:
pid 672, prio   0, out for  800 ms, ran for  799 ms, load  49%
pid 672, prio   0, out for  799 ms, ran for  800 ms, load  50%
pid 672, prio   0, out for  799 ms, ran for  800 ms, load  50%
pid 672, prio   0, out for  799 ms, ran for  799 ms, load  49%
pid 672, prio   0, out for  799 ms, ran for  799 ms, load  49%

Looks good, but now add a cpu-hog, ie. while :; do :; done

Console 1:

pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%
pid 671, prio   0, out for  799 ms, ran for  399 ms, load  33%

Console 2:
pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%
pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%
pid 672, prio   0, out for 1599 ms, ran for  800 ms, load  33%
pid 672, prio   0, out for 1599 ms, ran for  799 ms, load  33%

It's smooth, but latencies are double on console2.  Easy enough to fix, 
though, just press scrollock to induce a sleep and then release.

Also, latencies are huge.  Is there a way to fix latencies per nice?


Thanks!

--
Al



--Boundary-00=_vVpAG7TMC0urdWZ
Content-Type: text/x-csrc;
  charset="us-ascii";
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
        unsigned long long cur, last, start, act;
        struct timespec ts;

        sched_rr_get_interval(0, &ts);
        printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

        start = last = stamp();
        while(1) {
                cur = stamp();
                unsigned long long delta = cur-last;
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

--Boundary-00=_vVpAG7TMC0urdWZ--

