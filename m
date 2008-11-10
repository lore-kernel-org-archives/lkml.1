Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYKJJaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYKJJaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYKJJ3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:29:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYKJJ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:29:49 -0500
Date: Mon, 10 Nov 2008 10:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] restore sched_exec load balance heuristics
Message-ID: <20081110092937.GJ22392@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com> <20081106200746.GA3578@elte.hu> <1226307053.2697.3993.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226307053.2697.3993.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>  void sched_exec(void)
>  {
>  	int new_cpu, this_cpu = get_cpu();
> -	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
> +	struct task_group *tg;
> +	long weight, eload;
> +
> +	tg = task_group(current);
> +	weight = current->se.load.weight;
> +	eload = -effective_load(tg, this_cpu, -weight, -weight);
> +
> +	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC, eload);

okay, i think this will work.

it feels somewhat backwards though on a conceptual level.

There's nothing particularly special about exec-balancing: the load 
picture is in equilibrium - it is in essence a rebalancing pass done 
not in the scheduler tick but in a special place in the middle of 
exec() where the old-task / new-task cross section is at a minimum 
level.

_fork_ balancing is what is special: there we'll get a new context so 
we have to take the new load into account. It's a bit like wakeup 
balancing. (just done before the new task is truly woken up)

OTOH, triggering the regular busy-balance at exec() time isnt totally 
straightforward either: the 'old' task is the current task so it 
cannot be balanced away. We have to trigger all the active-migration 
logic - which again makes exec() balancing special.

So maybe this patch is the best solution after all. Ken, does it do 
the trick for your workload, when applied against v2.6.28-rc4?

You might even try to confirm that your testcase still works fine even 
if you elevate the load average with +1.0 on every cpu by starting 
infinite CPU eater loops on every CPU, via this bash oneliner:

  for ((i=0;i<2;i++)); do while :; do :; done & done

(change the '2' to '4' if you test this on a quad, not on a dual-core 
box)

the desired behavior would be for your "exec hopper" testcase to not 
hop between cpus, but to stick the same CPU most of the time.

	Ingo
