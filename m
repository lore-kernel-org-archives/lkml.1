Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYKJMyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYKJMyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYKJMyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:54:15 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:54750 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbYKJMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:54:14 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] restore sched_exec load balance heuristics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20081110092937.GJ22392@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
	 <20081106200746.GA3578@elte.hu> <1226307053.2697.3993.camel@twins>
	 <20081110092937.GJ22392@elte.hu>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 13:54:08 +0100
Message-Id: <1226321648.7685.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 10:29 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> >  void sched_exec(void)
> >  {
> >  	int new_cpu, this_cpu = get_cpu();
> > -	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
> > +	struct task_group *tg;
> > +	long weight, eload;
> > +
> > +	tg = task_group(current);
> > +	weight = current->se.load.weight;
> > +	eload = -effective_load(tg, this_cpu, -weight, -weight);
> > +
> > +	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC, eload);
> 
> okay, i think this will work.
> 
> it feels somewhat backwards though on a conceptual level.
> 
> There's nothing particularly special about exec-balancing: the load 
> picture is in equilibrium - it is in essence a rebalancing pass done 
> not in the scheduler tick but in a special place in the middle of 
> exec() where the old-task / new-task cross section is at a minimum 
> level.
> 
> _fork_ balancing is what is special: there we'll get a new context so 
> we have to take the new load into account. It's a bit like wakeup 
> balancing. (just done before the new task is truly woken up)
> 
> OTOH, triggering the regular busy-balance at exec() time isnt totally 
> straightforward either: the 'old' task is the current task so it 
> cannot be balanced away. We have to trigger all the active-migration 
> logic - which again makes exec() balancing special.
> 
> So maybe this patch is the best solution after all. 

Even worse, you want to balance current, the generic load balance might
pick two cpus to balance neither of which will have current on it. But
even if it would pick the queue with current on it as busiest, there is
no saying you'll actually end up moving current.

So this specialized form of moving current to a possibly more idle cpu
is afaics the best solution for balancing a particular task.

