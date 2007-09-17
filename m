Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXIQNFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXIQNFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXIQNFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:05:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXIQNF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:05:29 -0400
Date: Mon, 17 Sep 2007 15:05:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917130524.GA10707@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Hussey <robjhussey@gmail.com> wrote:

> http://www.healthcarelinen.com/misc/benchmarks/BOUND_hackbench_benchmark2.png

heh - am i the only one impressed by the consistency of the blue line in 
this graph? :-) [ and the green line looks a bit like a .. staircase? ]

i've meanwhile tested hackbench 90 and the performance difference 
between -ck and -cfs-devel seems to be mostly down to the more precise 
(but slower) sched_clock() introduced in v2.6.23 and to the startup 
penalty of freshly created tasks.

Putting back the 2.6.22 version and tweaking the startup penalty gives 
this:

                             [hackbench 90, smaller is better]

            sched-devel.git      sched-devel.git+lowres-sched-clock+dsp
            ---------------      --------------------------------------
                      5.555                  5.149
                      5.641                  5.149
                      5.572                  5.171
                      5.583                  5.155
                      5.532                  5.111
                      5.540                  5.138
                      5.617                  5.176
                      5.542                  5.119
                      5.587                  5.159
                      5.553                  5.177
            --------------------------------------
                 avg: 5.572             avg: 5.150 (-8.1%)

('lowres-sched-clock' is the patch i sent in the previous mail. 'dsp' is 
a disable-startup-penalty patch that is in the latest sched-devel.git)

i have used your .config to conduct this test.

can you reproduce this with the (very-) latest sched-devel git tree:

  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

plus with the low-res-sched-clock patch (re-) attached below?

	Ingo
---
 arch/i386/kernel/tsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -110,9 +110,9 @@ unsigned long long native_sched_clock(vo
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
+	if (1 || unlikely(!tsc_enabled && !tsc_unstable))
 		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+		return jiffies_64 * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
 	rdtscll(this_offset);
