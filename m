Return-Path: <linux-kernel-owner+w=401wt.eu-S1763817AbXGaOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763817AbXGaOTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXGaOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:19:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36410 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759951AbXGaOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:19:07 -0400
Date: Tue, 31 Jul 2007 16:18:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Kenneth Prugh <ken69267@gmail.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070731141857.GA22209@elte.hu>
References: <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com> <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com> <20070731094526.GA16300@elte.hu> <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Hawkins <darthmdh@gmail.com> wrote:

> On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> > * Kenneth Prugh <ken69267@gmail.com> wrote:
> > > CFS generally seemed a lot smoother as the load increased, while 
> > > SD broke down to a highly unstable fps count that fluctuated 
> > > massively around the third loop. Seems like I will stick to CFS 
> > > for gaming now.
>
> My experience was quite similar.  I noticed after launching the second 
> loop that the FPS stuck down to 15 for about 20 seconds, then climbed 
> back up to 48.  After that it went rapidly downhill.  This is similar 
> to other benchmarks I've done of SD versus CFS in the past.  At a 
> "normal" load they're fairly similar but SD breaks down under 
> pressure.

ok, thanks for testing it!

> The only other thing of interest is that the -ck kernel had the WM 
> menus appear in about 3 seconds rather than 5-8 under the other two.

under what load is that - 10 loops? There's no disk or network IO going 
on during a WM menu appearance, correct?

This could be a time-slicing difference perhaps - if you have 
CONFIG_HZ=100 could you change it to 1000 (or if you have it at 1000, 
could you change it to 100) - does it show any sensitivity to that?

the other difference could be SCHED_FEAT_START_DEBIT, does that WM menu 
latency go down if you clear it from sched_features, i.e. to subtract 16 
from sched_features:

  echo 15 > /proc/sys/kernel/sched_features

to restore the default, do:

  echo 31 > /proc/sys/kernel/sched_features

(if you have CONFIG_SCHED_DEBUG=y). You might also want to try changing 
/proc/sys/kernel/sched_granularity_ns. Boundary conditions: make sure 
that if you change the sched_granularity value you also set 
/proc/sys/kernel/sched_runtime_limit_ns to 2*sched_granularity and set 
/proc/sys/kernel/sched_wakeup_granularity_ns to sched_granularity/2. 

Other interesting bits to experiment with in sched_features would be 
SCHED_FEAT_FAIR_SLEEPERS (mask '1' in the bitmask) and 
SCHED_FEAT_SKIP_INITIAL (mask '32' in the bitmask).

	Ingo
