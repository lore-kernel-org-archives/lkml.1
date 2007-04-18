Return-Path: <linux-kernel-owner+w=401wt.eu-S2992927AbXDRRuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992927AbXDRRuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992956AbXDRRuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:50:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992927AbXDRRuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:50:24 -0400
Date: Wed, 18 Apr 2007 19:49:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418174945.GA7930@elte.hu>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The fact is:
> 
>  - "fairness" is *not* about giving everybody the same amount of CPU 
>    time (scaled by some niceness level or not). Anybody who thinks 
>    that is "fair" is just being silly and hasn't thought it through.

yeah, very much so.

But note that most of the reported CFS interactivity wins, as surprising 
as it might be, were due to fairness between _the same user's tasks_. In 
the typical case, 99% of the desktop CPU time is executed either as X 
(root user) or under the uid of the logged in user, and X is just one 
task. Even with a bad hack of making X super-high-prio, interactivity as 
experienced by users still sucks without having fairness between the 
other 100-200 user tasks that a desktop system is typically using.

'renicing X to -10' is a broken way of achieving: 'root uid should get 
its share of CPU time too, no matter how many user tasks are running'. 
We can do this much cleaner by saying: 'each uid, if it has any tasks 
running, should get its fair share of CPU time, independently of the 
number of tasks it is running'.

In that sense 'fairness' is not global (and in fact it is almost _never_ 
a global property, as X runs under root uid [*]), it is only the most 
lowlevel scheduling machinery that can then be built upon. Higher-level 
controls to allocate CPU power between groups of tasks very much make 
sense - but according to the CFS interactivity test results i got from 
people so far, they very much need this basic fairness machinery 
_within_ the uid group too. So 'fairness' is still a powerful lower 
level scheduling concept. And this all makes lots of sense to me.

One purpose of doing the hierarchical scheduling classes stuff was to 
enable such higher scope task group decisions too. Next i'll try to 
figure out whether 'task group bandwidth' logic should live right within 
sched_fair.c itself, or whether it should be layered separately as a 
sched_group.c. Intutively i'd say it should live within sched_fair.c.

	Ingo

[*] There are distributions where X does not run under root uid anymore.
