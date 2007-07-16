Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXGPHGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXGPHGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbXGPHGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:06:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXGPHGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:06:38 -0400
Date: Mon, 16 Jul 2007 09:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bruce <bruce@andrew.cmu.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716070610.GA10907@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469B0D9E.3030402@andrew.cmu.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bruce <bruce@andrew.cmu.edu> wrote:

> While we're at it, isn't the comment above the wmult table incorrect? 
> The multiplier is 1.25, meaning a 25% change per nice level, not 10%.

yes, the weight multiplier 1.25, but the actual difference in CPU 
utilization, when running two CPU intense tasks, is ~10%:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8246 mingo     20   0  1576  244  196 R   55  0.0   0:11.96 loop
 8247 mingo     21   1  1576  244  196 R   45  0.0   0:10.52 loop

so the first task 'wins' +10% CPU utilization (relative to the 50% it 
had before), the second task 'loses' -10% CPU utilization (relative to 
the 50% it had before).

so what the comment says is true:

 * The "10% effect" is relative and cumulative: from _any_ nice level,
 * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
 * it's +10% CPU usage.

for there to be a ~+10% change in CPU utilization for a task that races 
against another CPU-intense task there needs to be a ~25% change in the 
weight.

	Ingo
