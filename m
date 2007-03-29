Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXC2LXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXC2LXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXC2LXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:23:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbXC2LXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:23:32 -0400
Date: Thu, 29 Mar 2007 13:22:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
Message-ID: <20070329112249.GA32665@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Con Kolivas <kernel@kolivas.org> wrote:
> 
> > I'm cautiously optimistic that we're at the thin edge of the bugfix 
> > wedge now.
[...]

> and the numbers he posted:
> 
>  http://marc.info/?l=linux-kernel&m=117448900626028&w=2
> 
> his test conclusion was that under CPU load, RSDL (SD) generally does 
> not hold up to mainline's interactivity.

Today i've done some hackbench.c (which is similar to VolanoMark) 
interactivity testing on SD-latest (v0.37), doing "hackbench 10", 
"hackbench 50" and "hackbench 100" runs, comparing it to 
vanilla+Mike's-task-promotion-patch.

Performance
-----------

performance was largely comparable, within noise: the vanilla scheduler 
was slightly (~5%) better at "hackbench 10", SD and vanilla was within 
noise on "hackbench 50" and "hackbench 100" runs. (I think vanilla's 
better results might be due to the longer timeslices vanilla can give 
out - SD has to operate via short timeslices, by design.)

Shell interactivity
-------------------

The vanilla scheduler kept the shell completely usable during all tests: 
'ls' output was instantaneous and characters could be typed without 
delay.

The SD/RSDL scheduler kept the shell barely usable during the hackbench 
10 test, and it was completely unusable during the hackbench 50 and 100 
tests. A simple 'ls' took 2-3 seconds to complete (up to 6 seconds at 
times) and the shell printed characters in a very laggy way. 'vi' was 
totally unusable, etc. etc.

[ i've also re-tested this with RSDL 0.34, and there interactivity got 
  better although it still didnt match that of the vanilla scheduler's
  interactivity. So this is a definitive SD regression. ]

[ A quick guess: could SD's substandard interactivity in this test be 
  due to the SMP migration logic inconsistencies Mike noticed? This is 
  an SMP system and the hackbench workload is very scheduling intense 
  and tasks are frequently queued from one CPU to another. ]

Conclusion
----------

i consider this a must-fix item as SD badly misbehaves under this 
workload.

Test environment details
------------------------

the test system is a 2GHz Athlon64 dual-core box. All tests were running 
on default nice 0 levels. All tests were done 10 times on a totally idle 
test-system. Mike's patch is the one that improves vanilla scheduler's 
anti-starvation code:

   http://marc.info/?l=linux-kernel&m=117507110922009&w=2

( Mike's patch does not make a measurable performance difference in
  hackbench, nor does it make a visible interactivity difference for 
  this workload, but since i think Mike's patch improves the vanilla 
  scheduler i included it in the test for completeness, so that both 
  variants of interactivity code are at the 'bleeding edge'. )

	Ingo
