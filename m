Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZAZXyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZAZXyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZAZXxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:53:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZAZXxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:53:52 -0500
Date: Tue, 27 Jan 2009 00:53:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126235331.GA8726@elte.hu>
References: <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126214516.GA22142@elte.hu> <20090126140116.35f9c173.akpm@linux-foundation.org> <20090126220537.GA6755@elte.hu> <20090126141605.707877bb.akpm@linux-foundation.org> <20090126222002.GB10215@elte.hu> <20090126145003.b29b81d7.akpm@linux-foundation.org> <20090126225957.GA3999@elte.hu> <20090126154217.b312e278.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126154217.b312e278.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > The problem is the intrinsic utility of work_on_cpu(): we _really_ 
> > want such a generic facility to be usable from any (blockable) 
> > context, just like on_each_cpu(func, info) does for atomic functions, 
> > without restrictions on locking context.
> 
> Do we?  work_on_cpu() is some last-gasp oh-i-screwed-my-code-up thing. 
> We _really_ want people to use on_each_cpu()!

why? on_each_cpu() is limited and runs in IRQ context. Is there a 
requirement that worklets need to be atomic?

> We should bust a gut to keep the number of callers to the 
> resource-intensive (deadlocky!) work_on_cpu() to a minimum.

i wouldnt call +10K 'resource intensive'.

> (And to think that adding add_timer_on() creeped me out).
> 
> hm.  None of that was very helpful.  How to move forward?
> 
> I think I disagree that work_on_cpu() should be made into some robust, 
> smiled-upon core kernel facility.  It _is_ slow, it _is_ deadlockable. 

uhm, why is it slow? It could be faster in fact in some cases: the main 
overhead in on_each_cpu() is having to wait for the IPIs - with a thread 
based approach if the other CPUs are idle we can get an IPI-less wakeup.

> It should be positioned as something which is only used as a last 
> resort.  And if you _have_ to use it, sort out your locking!
> 
> Plus the number of code sites which want to fiddle with other CPUs in 
> this manner will always be small.  cpufreq, MCE, irq-affinity, things 
> like that.
> 
> What is the deadlock in acpi-cpufreq?  Which lock, and who is the 
> "other" holder of that lock?

a quick look suggests that it's dbs_mutex.

	Ingo
