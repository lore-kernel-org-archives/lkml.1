Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZEENuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZEENuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZEENt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:49:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZEENt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:49:56 -0400
Date: Tue, 5 May 2009 15:49:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: round-robining per-cpu counters
Message-ID: <20090505134943.GA19122@elte.hu>
References: <18943.47474.963294.862139@drongo.ozlabs.ibm.com> <20090505064051.GA27191@elte.hu> <18944.10637.877638.642187@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18944.10637.877638.642187@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> > I think a better general solution would be to have a single 
> > round-robin list for all currently active counters (both percpu 
> > and task counters) - and fairly round-robin all of them. The 
> > scaling information makes it obvious when this is happening.
> 
> Sounds good, but I'm having trouble visualizing how we combine a 
> fairly static set of per-cpu counters with several sets of 
> per-task counters that come and go as their tasks get scheduled in 
> and out. Is there some clever scheduling technique that sorts all 
> that out?

Fair scheduling techniques would import the complexity of 
kernel/sched*.c into kernel/perf_counter.c - not sure we want that 
(at this stage at least).

So i'd go for the second best option: the simplest one.

One simple option would be to 'interleave' the two lists on sched-in 
(take a counter from one list, then from the other, then from the 
first, etc.), combined with the alternate rotation of both lists.

Another, perhaps even simpler option would be to do the alternation 
on a per list basis: rotate which of the two lists go first on 
sched-in, from the task tick.

Can you see any showstopper artifacts in this scheme?

Later on, if anyone finds this method lacking it can be improved 
gradually either by making the accounting/statistics smarter, or by 
increasing the frequency of rotation events and coupling it not to 
the scheduler tick but to a counter perhaps.

	Ingo
