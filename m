Return-Path: <linux-kernel-owner+w=401wt.eu-S966152AbXDCCiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966152AbXDCCiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXDCCiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:38:12 -0400
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:54365 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934015AbXDCCiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:38:11 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Date: Tue, 3 Apr 2007 12:37:21 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <200703290944.45888.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net>
In-Reply-To: <1175147455.6430.91.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_h3bEGWO6su7lDaf"
Message-Id: <200704031237.21946.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_h3bEGWO6su7lDaf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 29 March 2007 15:50, Mike Galbraith wrote:
> On Thu, 2007-03-29 at 09:44 +1000, Con Kolivas wrote:
> + * This contains a bitmap for each dynamic priority level with empty slots
> + * for the valid priorities each different nice level can have. It allows
> + * us to stagger the slots where differing priorities run in a way that
> + * keeps latency differences between different nice levels at a minimum.
> + * ie, where 0 means a slot for that priority, priority running from left
> to + * right:
> + * nice -20 0000000000000000000000000000000000000000
> + * nice -10 1001000100100010001001000100010010001000
> + * nice   0 0101010101010101010101010101010101010101
> + * nice   5 1101011010110101101011010110101101011011
> + * nice  10 0110111011011101110110111011101101110111
> + * nice  15 0111110111111011111101111101111110111111
> + * nice  19 1111111111111111111011111111111111111111

Try two instances of chew.c at _differing_ nice levels on one cpu on mainline, 
and then SD. This is why you can't renice X on mainline.

> 	-Mike

-- 
-ck

--Boundary-00=_h3bEGWO6su7lDaf
Content-Type: text/x-csrc;
  charset="utf-8";
  name="chew.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="chew.c"

/*
 * orignal idea by Chris Friesen.  Thanks.
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
        unsigned long long cur,last;
        struct timespec ts;

        sched_rr_get_interval(0, &ts);
        printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

        last = stamp();
        while(1) {
                cur = stamp();
                unsigned long long delta = cur-last;
                if (delta > thresh_ticks) {
                        printf("pid %d, prio %3d, out for %4llu ms\n", getpid(), getpriority(PRIO_PROCESS, 0), delta/1000);
                        cur = stamp();
                }
                last = cur;
        }

        return 0;
}

--Boundary-00=_h3bEGWO6su7lDaf--
