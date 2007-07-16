Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbXGPNlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbXGPNlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbXGPNk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:40:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbXGPNk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:40:57 -0400
Date: Mon, 16 Jul 2007 15:40:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716134036.GA1533@elte.hu>
References: <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161427100.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > It has been a common request for nice levels to be more logical 
> > (i.e. to make them universal and to detach them from HZ) and for 
> > them to be more effective as well.
> 
> Huh? What has this to do with HZ? The scheduler used ticks internally, 
> but it's irrelevant to what the user sees via the nice levels. [...]

unfortunately you are wrong again - there are various HZ related 
artifacts in the nice level support code of the old scheduler.

v2.6.22, CONFIG_HZ=100, nice +19 task against a nice-0 CPU-intense task:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2446 mingo     25   0  1576  244  196 R 90.9  0.0   0:32.79 loop
 2448 mingo     39  19  1580  248  196 R  9.1  0.0   0:02.94 loop

v2.6.22, CONFIG_HZ=250, nice +19 task against a nice-0 CPU-intense task:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2358 mingo     25   0  1576  248  196 R 96.1  0.0   0:31.97 loop_silent
 2363 mingo     39  19  1576  244  196 R  3.9  0.0   0:01.24 loop_silent

v2.6.22, CONFIG_HZ=300, nice +19 task against a nice-0 CPU-intense task:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2332 mingo     25   0  1580  248  196 R 95.1  0.0   0:11.84 loop_silent
 2335 mingo     39  19  1576  244  196 R  3.1  0.0   0:00.39 loop_silent

to sum it up: a nice +19 task (the most commonly used nice level in 
practice) gets 9.1%, 3.9%, 3.1% of CPU time on the old scheduler, 
depending on the value of HZ. This is quite inconsistent and illogical.

this HZ dependency of nice levels existed for many years, and the new 
scheduler solves that inconsistency - every nice level will get the same 
amount of time, regardless of HZ.

	Ingo
