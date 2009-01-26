Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZAZUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZAZUVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZAZUVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:21:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZAZUVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:21:00 -0500
Date: Mon, 26 Jan 2009 21:20:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126202022.GA8867@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <20090116191108.533053000@polaris-admin.engr.sgi.com> <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126103529.cb124a58.akpm@linux-foundation.org>
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

> On Mon, 26 Jan 2009 18:16:18 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > > Yet another kernel thread for each CPU.  All because of some dung 
> > > > > way down in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c.
> > > > > 
> > > > > Is there no other way?
> > > > 
> > > > Perhaps, but this works.  Trying to be clever got me into this mess in 
> > > > the first place.
> > > > 
> > > > We could stop using workqueues and change work_on_cpu to create a 
> > > > thread every time, which would give it a new failure mode so I don't 
> > > > know that everyone could use it any more.  Or we could keep a single 
> > > > thread around to do all the cpus, and duplicate much of the workqueue 
> > > > code.
> > > > 
> > > > None of these options are appealing...
> > > 
> > > Can we try harder please?  10 screenfuls of kernel threads in the ps 
> > > output is just irritating.
> > > 
> > > How about banning the use of work_on_cpu() from schedule_work() handlers 
> > > and then fixing that driver somehow?
> > 
> > Yes, but that's fundamentally fragile: anyone who happens to stick the 
> > wrong thing into keventd (and it's dead easy because schedule_work() is 
> > easy to use) will lock up work_on_cpu() users.
> > 
> 
> --- a/kernel/workqueue.c~a
> +++ a/kernel/workqueue.c
> @@ -998,6 +998,8 @@ long work_on_cpu(unsigned int cpu, long 
>  {
>  	struct work_for_cpu wfc;
>  
> +	BUG_ON(current_is_keventd());
> +
>  	INIT_WORK(&wfc.work, do_work_for_cpu);
>  	wfc.fn = fn;
>  	wfc.arg = arg;
> _
> 
> 
> That wasn't so hard.

What is the purpose of your change? I'm not sure you understood the 
problem. The problem is not with work_on_cpu() usage. The problem is:

 1) holding locks while calling work_on_cpu()

 2) same locks being taken by a worklet used by some other code

work_on_cpu() really wants to serialize on its own workload only, not on 
the other stuff that might be sometimes be queued up in the keventd 
workqueue.

> > work_on_cpu() is an important (and lowlevel enough) facility to be 
> > isolated from casual interaction like that.
> 
> We have one single (known) caller in the whole kernel.  This is not 
> worth adding another great pile of kernel threads for!

i'd expect there to be more as part of the cpumask stack reduction 
patches that Rusty and Mike are working on.

in any case it's a correctness issue: work_on_cpu() is a just as generic 
facility as on_each_cpu() - with the difference that it can handle 
blocking contexts too.

So if it's generic it ought to be implemented in a generic way - not a 
"dont use from any codepath that has a lock held that might occasionally 
also be held in a keventd worklet". (which is a totally unmaintainable 
proposition and which would just cause repeat bugs again and again.)

	Ingo
