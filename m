Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZAZRQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZAZRQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZAZRQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:16:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZAZRQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:16:43 -0500
Date: Mon, 26 Jan 2009 18:16:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126171618.GA32091@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <20090116191108.533053000@polaris-admin.engr.sgi.com> <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125230130.bcdab2e5.akpm@linux-foundation.org>
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

> > > Yet another kernel thread for each CPU.  All because of some dung 
> > > way down in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c.
> > > 
> > > Is there no other way?
> > 
> > Perhaps, but this works.  Trying to be clever got me into this mess in 
> > the first place.
> > 
> > We could stop using workqueues and change work_on_cpu to create a 
> > thread every time, which would give it a new failure mode so I don't 
> > know that everyone could use it any more.  Or we could keep a single 
> > thread around to do all the cpus, and duplicate much of the workqueue 
> > code.
> > 
> > None of these options are appealing...
> 
> Can we try harder please?  10 screenfuls of kernel threads in the ps 
> output is just irritating.
> 
> How about banning the use of work_on_cpu() from schedule_work() handlers 
> and then fixing that driver somehow?

Yes, but that's fundamentally fragile: anyone who happens to stick the 
wrong thing into keventd (and it's dead easy because schedule_work() is 
easy to use) will lock up work_on_cpu() users.

work_on_cpu() is an important (and lowlevel enough) facility to be 
isolated from casual interaction like that.

> What _is_ the bug anyway?  The only description we were given was
> 
>   Impact: remove potential clashes with generic kevent workqueue
> 
>   Annoyingly, some places we want to use work_on_cpu are already in
>   workqueues.  As per Ingo's suggestion, we create a different
>   workqueue for work_on_cpu.
> 
> which didn't bother telling anyone squat.
> 
> When was this bug added?  Was it added into that driver or was it due to 
> infrastructural changes?

This fixes lockups during bootup caused by the cpumask changes/cleanups 
which changed set_cpus_allowed()+on-kernel-stack-cpumask_t to 
work_on_cpu().

Which was fine except it didnt take into account the interaction with the 
kevents workqueue and the very wide cross section for worklet dependencies 
that this brings with itself. work_on_cpu() was rarely used before so this 
didnt show up.

	Ingo
