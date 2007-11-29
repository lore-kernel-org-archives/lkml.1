Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXK2K6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXK2K6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXK2K6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:58:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXK2K57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:57:59 -0500
Date: Thu, 29 Nov 2007 11:57:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129105744.GI10577@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> I can't say I'm understading these traces very well, but here's a 
> snippet that looks a bit strange.  I'm running 'while true; do date; 
> done' in parallel with the dd.
> 
> For some time it is doing 100% CPU as expected, then it goes into a 
> second or so of mosty idle (afaics), and then returns to the normal 
> pattern again.

try:

  echo 1 > /proc/sys/kernel/stackframe_tracing

to get symbolic stack backdumps for the wakeup points, and add 
trace_special_sym() calls to generate extra stackdump entries at 
arbitrary places. schedule() does not have it right now - it might make 
sense to add it.

also, enabling mcount:

 echo 1 > /proc/sys/kernel/mcount_enabled

will give you a _lot_ more verbose trace. Likewise:

 echo 1 > /proc/sys/kernel/syscall_tracing

(but for that you'd have to add the sys_call()/sys_ret() instrumentation 
that x86 has in entry_32.S)

but even this highlevel trace shows something weird:

> events/0-4     0.... 16044512us+: schedule <<idle>-0> (20 -5)
>   <idle>-0     0.... 16044564us!: schedule <events/0-4> (-5 20)
>   <idle>-0     0.Nh. 16076072us+: __trace_start_sched_wakeup <date-7133> (120 -1)
>   <idle>-0     0.Nh. 16076075us+: __trace_start_sched_wakeup <dd-6444> (120 -1)
>   <idle>-0     0.Nh. 16076078us+: __trace_start_sched_wakeup <kswapd0-33> (115 -1)
>       dd-6444  0.... 16076104us+: schedule <<idle>-0> (20 0)

how come UML idled for 30 msecs here, while the workload was supposed to 
be CPU-bound? It's not IO bound anywhere, right? No SMP artifacts 
either, right?

	Ingo
