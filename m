Return-Path: <linux-kernel-owner+w=401wt.eu-S938354AbXFHJe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938354AbXFHJe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937198AbXFHJes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:34:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937147AbXFHJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:34:47 -0400
Date: Fri, 8 Jun 2007 11:34:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070608093429.GA22699@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu> <20070605140342.GR11115@waste.org> <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com> <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com> <20070605195015.GA24348@elte.hu> <20070606202314.GH11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606202314.GH11115@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Tue, Jun 05, 2007 at 09:50:15PM +0200, Ingo Molnar wrote:
> > Matt, could you run this for 1-2 minutes and send us the sched_debug.txt 
> > output?
> 
> http://selenic.com/sched_debug.txt.gz

thanks. It shows the anomaly in action:

  now at 365294215491977 nsecs

  .jiffies               : 91248553
  .next_balance          : 0
  .curr->pid             : 18589
  .clock                 : 125652924079659272
  .prev_clock_raw        : 365201238127457
  .clock_warps           : 9
  .clock_unstable_events : 61896358
  .clock_max_delta       : 3997813

next one is:

  now at 365295219388142 nsecs

  .jiffies               : 91248804
  .next_balance          : 0
  .curr->pid             : 18591
  .clock                 : 125653018059166371
  .prev_clock_raw        : 365295217642619
  .clock_warps           : 9
  .clock_unstable_events : 61896359
  .clock_max_delta       : 92976502936

251 jiffies passed, at 250 Hz that's 1 second - this proves that the 
sample is indeed an accurate once-per-second sample according to the 
timer interrupt. The 'now' timestamp (ktime_get() based) shows 
1003896165 nanosecs passed - this too is showing a precise 1 second 
sample, according to GTOD.

So all the time references we have show that (no surprise here) 1 second 
passed between the two samples. But sched_clock() shows a _large_ jump:

  .clock                 : 125652924079659272
  .clock                 : 125653018059166371

also reflected in .clock_max_delta:

  .clock_max_delta       : 92976502936

that's a 93 seconds jump (!) in a single 1-second sample. We also had a 
single sched-clock-unstable event:

  .clock_unstable_events : 61896358
  .clock_unstable_events : 61896359

could you please try a test-boot with 'notsc' - do the scheduling 
weirdnesses go away? Also, 

There are two reasons why the sched_clock() in -mm could behave like 
that - either the sched-clock-share patches in it are buggy and we do 
not smoothly switch over from sc->unstable == 1 to sc->unstable == 0, or 
the TSC itself is unstable. To test the latter theory, could you run a 1 
minute tsc-dump on your box:

	./tsc-dump > tsc-dump.txt

You can pick tsc-dump up from:

	http://redhat.com/~mingo/time-warp-test/

(please run this on a recent -mm kernel so that we have the same 
ACPI-idle characteristics as on the buggy kernel.)

to test the former theory, could you boot with 'notsc' - do the 
weirdnesses go away? (please create another sched-debug.txt as well)

	Ingo
