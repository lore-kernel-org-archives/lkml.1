Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZAZVCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZAZVCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZAZVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:01:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbZAZVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:01:48 -0500
Date: Mon, 26 Jan 2009 13:00:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126130046.37b8f34e.akpm@linux-foundation.org>
In-Reply-To: <20090126202022.GA8867@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<20090116191108.533053000@polaris-admin.engr.sgi.com>
	<20090124001537.7cfde78e.akpm@linux-foundation.org>
	<200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<20090126171618.GA32091@elte.hu>
	<20090126103529.cb124a58.akpm@linux-foundation.org>
	<20090126202022.GA8867@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 21:20:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 26 Jan 2009 18:16:18 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > > Yet another kernel thread for each CPU.  All because of some dung 
> > > > > > way down in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c.
> > > > > > 
> > > > > > Is there no other way?
> > > > > 
> > > > > Perhaps, but this works.  Trying to be clever got me into this mess in 
> > > > > the first place.
> > > > > 
> > > > > We could stop using workqueues and change work_on_cpu to create a 
> > > > > thread every time, which would give it a new failure mode so I don't 
> > > > > know that everyone could use it any more.  Or we could keep a single 
> > > > > thread around to do all the cpus, and duplicate much of the workqueue 
> > > > > code.
> > > > > 
> > > > > None of these options are appealing...
> > > > 
> > > > Can we try harder please?  10 screenfuls of kernel threads in the ps 
> > > > output is just irritating.
> > > > 
> > > > How about banning the use of work_on_cpu() from schedule_work() handlers 
> > > > and then fixing that driver somehow?
> > > 
> > > Yes, but that's fundamentally fragile: anyone who happens to stick the 
> > > wrong thing into keventd (and it's dead easy because schedule_work() is 
> > > easy to use) will lock up work_on_cpu() users.
> > > 
> > 
> > --- a/kernel/workqueue.c~a
> > +++ a/kernel/workqueue.c
> > @@ -998,6 +998,8 @@ long work_on_cpu(unsigned int cpu, long 
> >  {
> >  	struct work_for_cpu wfc;
> >  
> > +	BUG_ON(current_is_keventd());
> > +
> >  	INIT_WORK(&wfc.work, do_work_for_cpu);
> >  	wfc.fn = fn;
> >  	wfc.arg = arg;
> > _
> > 
> > 
> > That wasn't so hard.
> 
> What is the purpose of your change? I'm not sure you understood the 
> problem.

Well.  That's because I was forced to resort to guesswork.

> The problem is not with work_on_cpu() usage. The problem is:
> 
>  1) holding locks while calling work_on_cpu()
> 
>  2) same locks being taken by a worklet used by some other code
> 
> work_on_cpu() really wants to serialize on its own workload only, not on 
> the other stuff that might be sometimes be queued up in the keventd 
> workqueue.

but but but, we fixed that ages ago, I think.  But I don't see the code
there.

If we want to wait on a *particular* keventd work item then we
shouldn't wait on all the other queued ones.

- If it's currently running, wait on it

- If it isn't yet running, detach it from the queue and run it directly.

Maybe I'm thinking of a different subsystem, but I don't think so. 
Maybe Oleg recalls what happened to that?

> > > work_on_cpu() is an important (and lowlevel enough) facility to be 
> > > isolated from casual interaction like that.
> > 
> > We have one single (known) caller in the whole kernel.  This is not 
> > worth adding another great pile of kernel threads for!
> 
> i'd expect there to be more as part of the cpumask stack reduction 
> patches that Rusty and Mike are working on.
> 
> in any case it's a correctness issue: work_on_cpu() is a just as generic 
> facility as on_each_cpu() - with the difference that it can handle 
> blocking contexts too.

Well on_each_cpu() has restrictions.  Can't all it with local
interrupts disabled.  Can't call it (synchronously) while holding locks
which the callback takes.

> So if it's generic it ought to be implemented in a generic way - not a 
> "dont use from any codepath that has a lock held that might occasionally 
> also be held in a keventd worklet". (which is a totally unmaintainable 
> proposition and which would just cause repeat bugs again and again.)

That's different.  The core fault here lies in the keventd workqueue
handling code.  If we're flushing work A then we shouldn't go and block
behind unrelated work B.

