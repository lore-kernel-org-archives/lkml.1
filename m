Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXDWTPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXDWTPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXDWTPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:15:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbXDWTPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:15:13 -0400
Date: Mon, 23 Apr 2007 21:11:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070423191143.GA16849@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
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

> but the point I'm trying to make is that X shouldn't get more CPU-time 
> because it's "more important" (it's not: and as noted earlier, 
> thinking that it's more important skews the problem and makes for too 
> *much* scheduling). X should get more CPU time simply because it 
> should get it's "fair CPU share" relative to the *sum* of the clients, 
> not relative to any client individually.

yeah. And this is not a pipe dream and i think it does not need a 
'wakeup matrix' or other complexities.

I am --->.<---- this close to being able to do this very robustly under 
CFS via simple rules of economy and trade: there the p->wait_runtime 
metric is intentionally a "physical resource" of "hard-earned right to 
execute on the CPU, by having waited on it" the sum of which is bound 
for the whole system.

So while with other, heuristic approaches we always had the problem of 
creating a "hyper-inflation" of an uneconomic virtual currency that 
could be freely printed by certain tasks, in CFS the economy of this is 
strict and the finegrained plus/minus balance is strictly managed by a 
conservative and independent central bank.

So we can actually let tasks "trade" in these very physical units of 
"right to execute on the CPU". A task giving it to another task means 
that this task _already gave up CPU time in the past_. So it's the 
robust equivalent of an economy's "money earned" concept, and this 
"money"'s distribution (and redistribution) is totally fair and totally 
balanced and is not prone to "inflation".

The "give scheduler money" transaction can be both an "implicit 
transaction" (for example when writing to UNIX domain sockets or 
blocking on a pipe, etc.), or it could be an "explicit transaction": 
sched_yield_to(). This latter i've already implemented for CFS, but it's 
much less useful than the really significant implicit ones, the ones 
which will help X.

	Ingo
