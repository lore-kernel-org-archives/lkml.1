Return-Path: <linux-kernel-owner+w=401wt.eu-S934345AbXHYXPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbXHYXPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 19:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXHYXPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 19:15:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52529 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXHYXPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 19:15:38 -0400
Date: Sun, 26 Aug 2007 01:15:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070825231525.GA334@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu> <200708260127.32238.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708260127.32238.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4755]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > ok. I think i might finally have found the bug causing this. Could 
> > you try the fix below, does your webserver thread-startup test work 
> > any better?
> 
> It seems to help somewhat, but the problem is still visible.  Even 
> v20.3 on 2.6.22.5 didn't help.
> 
> It does look related to ia-boosting, so I turned off __update_curr 
> like Roman mentioned, which had an enormous smoothing effect, but then 
> nice levels completely break down and lockup the system.

you can turn sleeper-fairness off via:

   echo 28 > /proc/sys/kernel/sched_features

another thing to try would be:

   echo 12 > /proc/sys/kernel/sched_features

(that's the new-task penalty turned off.)

Another thing to try would be to edit this:

        if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
                p->se.wait_runtime = -(sched_granularity(cfs_rq) / 2);

to:

        if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
                p->se.wait_runtime = -(sched_granularity(cfs_rq);

and could you also check 20.4 on 2.6.22.5 perhaps, or very latest -git? 
(Peter has experienced smaller spikes with that.)

	Ingo
