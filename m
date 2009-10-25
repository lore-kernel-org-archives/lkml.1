Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZJYGzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZJYGzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 02:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZJYGzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 02:55:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:59335 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbZJYGzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 02:55:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Cv75JCh2Cz0h95ffcdCOCVWODkRf0NWct1KsyYV
	v026H5KtQpKZBo
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091024130728.051c4d7c@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 07:55:25 +0100
Message-Id: <1256453725.12138.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 13:07 -0700, Arjan van de Ven wrote:
> Subject: sched: Disable affine wakeups by default
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The global affine wakeup scheduler feature sounds nice, but there is a problem
> with this: This is ALSO a per scheduler domain feature already.
> By having the global scheduler feature enabled by default, the scheduler domains
> no longer have the option to opt out.

? The affine decision is qualified by SD_WAKE_AFFINE.

                if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
                    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {

                        affine_sd = tmp;
                        want_affine = 0;
                }

> There are domains (for example the HT/SMT domain) that have good reason to want
> to opt out of this feature.

Even if you're sharing a cache, there are reasons to wake affine.  If
the wakee can preempt the waker while it's still eligible to run, wakee
not only eats toasty warm data, it can hand the cpu back to the waker so
it can make more and repeat this procedure for a while without someone
else getting in between, and trashing cache.  Also, for a task which
wakes another, then checks to see if it has more work, sleeps if not,
this preemption can keep that task running, saving wakeups.  If you put
the wakee on a runqueue where it may have to wait even a tiny bit, buddy
goes to sleep, so that benefit is gone.  These things have a HUGE effect
on scalability, as you can see below.

There are times when not waking affine is good, eg immediately after
fork(), it's _generally_ a good idea to not wake affine, because there
may be more no the way, a work generator like make, for example doing
it's thing, and fork() also frequently means an exec is on the way.
That's not usually a producer/consumer situation.

At low load, with producer/consumer, iff you can hit a shared cache,
it's a good idea to not wake affine, any waker/wakee overlap is pure
performance loss in that case.  On my Q6600, there's a 1:3 chance of
hitting if left to random chance.  You can see that case happening in
the pgsql+oltp numbers below.  That wants further examination.

> With this patch they can opt out, while all other domains currently default to
> the affine setting anyway.

Patch globally disabled affine wakeups.  Not good.

Oh, btw, wrt affinity vs interrupt, a long time ago, I tried disabling
affine wakeups in hard/soft and both contexts.  In all cases, it was a
losing proposition here.

One thing that would be nice for some mixed loads, including the desktop
is, if a cpu is doing high frequency sync/affine wakeups, try to keep
other things away from that cpu by considering synchronous tasks to
count as two instead of one load balancing wise.

(damn, i'm rambling.. time to shut up;)

Sorry for verbosity, numbers probably would have sufficed.  I've been
overdosing on boring affinity/scalability testing ;-)

tip v2.6.32-rc5-1691-g9a8523b

tbench 4
tip           936.314 MB/sec 8 procs
tip+patches   869.153 MB/sec 8 procs
                 .928

vmark
tip           125307 messages per second
tip+patches   103743 messages per second
                .827
              
mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10013.90   18526.84   34900.38   34420.14   33069.83   32083.40   30578.30   28010.71   25605.47
tip+patches   8436.34   17826.34   34524.32   31471.92   29188.59   27896.10   26036.43   23774.57   19524.33
                 .842       .962       .989       .914       .882       .869       .851       .848       .762

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13907.85   27135.87   52951.98   52514.04   51742.52   50705.43   49947.97   48374.19   46227.94
tip+patches  15277.63   23050.99   51943.13   51937.16   42246.60   38397.86   34998.71   31154.21   26335.68
                1.098       .849       .980       .989       .816       .757       .700       .644       .569


