Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbXGWSdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbXGWSdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbXGWSdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:33:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760720AbXGWSde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:33:34 -0400
Date: Mon, 23 Jul 2007 20:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070723183319.GA28505@elte.hu>
References: <20070705215152.GA4865@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705215152.GA4865@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Thread Migration Preemption
> 
> This patch adds the ability to protect critical sections from 
> migration to another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for 
> the -rt patch. [...]

unfortunately this abstraction has a number of fundamental 
disadvantages. (and hence the -rt patch does not make use of this 
facility)

firstly, its effects on load-balancing are quite brutal: it disables 
migration to another CPU, hence disturbing SMP load-balancing. It also 
adds an unplannable O(N) overhead into the load-balancer.

secondly, it has similar problems as preempt_disable(): it's opaque (not 
attached to a data structure) and thus it does not truly map the per-CPU 
data structure in any explicit way. It's little more than a per-task BKL 
for per-CPU data structures.

so in -rt we resisted the disable-migration approach from the early days 
on and are using two approaches to 'map' per-cpu data structures to 
PREEMPT_RT: firstly the use of PER_CPU_LOCKED data structures (which 
attach a per-cpu sleeping lock to per_cpu() data structures) - these are 
relatively easy first-approach conversions. As a second approach, if 
performance matters, the use of true atomic data structures.

	Ingo
