Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZATPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZATPBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZATPBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:01:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZATPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:01:20 -0500
Date: Tue, 20 Jan 2009 16:00:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120150054.GA21931@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <20090120141454.GI19505@wotan.suse.de> <20090120141735.GA9474@elte.hu> <20090120144109.GK19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120144109.GK19505@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Jan 20, 2009 at 03:17:35PM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > BTW. the lmbench test I run directly (it's called lat_mmap.c, and gets 
> > > compiled into a standalone lat_mmap exec by the standard lmbench build).
> > 
> > doesnt that include an indeterminate number of gettimeofday() based 
> > calibration calls? That would make it harder to measure its total costs in 
> > a comparative way.
> 
> Hmm... yes probably for really detailed profile comparisons or other 
> external measurements it would need modification.

yeah.

Btw., it's a trend to be aware of i think: as our commit flux goes up and 
the average commit size goes down, it becomes harder and harder to measure 
the per commit performance impact.

There's just 3 ways to handle it: decrease commit flux (which is out of 
question), or to increase commits size (wich is out of question as well), 
or to improve the quality of our measurements.

We can improve performance measurement quality in a number of ways:

 - We can (and should) increase instrumentation precision

     /usr/bin/time's 10 msec measurement granularity might have been
     fine a decade ago but it is not fine today.

 - We can (and should) increase the number of 'dimensions' (metrics) we 
   can instrument the kernel with.

     Right now we basically only measure along the time axis, in 99% of 
     the cases. But 'elapsed time' is a tricky, compound and thus noisy 
     unit: it is affected by all delays in a workload. We do profiles 
     occasionally, but they are a lot more difficult to generate and a lot 
     harder to compare and are hard to be plugged into regression 
     analysis.

So if we see a statistically significant shift in one of more metrics of 
something like:

-------------------------------------------------
|
| $ ./timec -e -5,-4,-3,0,1,2,3 make -j16 bzImage
|
| [...]
| Kernel: arch/x86/boot/bzImage is ready  (#28)
|
| Performance counter stats for 'make':
|
|  628315.871980  task clock ticks     (msecs)
|
|          42330  CPU migrations       (events)
|         124980  context switches     (events)
|       18698292  pagefaults           (events)
|  1351875946010  CPU cycles           (events)
|  1121901478363  instructions         (events)
|    10654788968  cache references     (events)
|      633581867  cache misses         (events)
|
| Wall-clock time elapsed: 118348.109066 msecs
|
-----------------------------------------------

Becomes a _lot_ harder to ignore (and talk out of existence) than it is to 
ignore a few minor digits changing in:

---------------------------------
|
| $ time make -j16 bzImage
|
|  real	0m12.146s
|  user	1m30.050s
|  sys	0m12.757s
|
---------------------------------

( Especially as those minor digits tend to be rather noisy to begin with,
  due to us sampling system/user time from the timer interrupt. )

It becomes even harder to ignore statistically significant regressions if 
some of the metrics are hardware-generated hard physical facts - not 
something wishy-washy and statistical as stime/utime statistics.

</plug> ;-)

	Ingo
