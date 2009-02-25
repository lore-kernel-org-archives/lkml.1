Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbZBYQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbZBYQAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZBYQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:00:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43055 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbZBYQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:00:46 -0500
Date: Wed, 25 Feb 2009 17:00:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090225160024.GB12732@elte.hu>
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225141945.GA28455@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +/* Internal to kernel, but needed by rcupreempt.h. */
> +extern int rcu_idle_cpu_truthful;

The name sucks a bit ;-) 'truthful' is an emotionally laden 
statement and distracts from the technical purpose when reading 
it ;)

Same for:

> +extern void rcu_idle_now_means_idle(void);

Also, i'm wondering, is there really no way to avoid this quirk. 
We almost got away without it for a long time.

This one:

>  void rcu_check_callbacks(int cpu, int user)
>  {
>  	if (user ||
> -	    (idle_cpu(cpu) && !in_softirq() &&
> -				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> +	    (idle_cpu(cpu) && rcu_idle_cpu_truthful &&
> +	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {

Is a hotpath called very often ...

	Ingo
