Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZA0R70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZA0R70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZA0R7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:59:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbZA0R7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:59:17 -0500
Date: Tue, 27 Jan 2009 18:55:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090127175556.GA23112@redhat.com>
References: <20090124001537.7cfde78e.akpm@linux-foundation.org> <20090126215049.GA3493@redhat.com> <20090126221729.GA10215@elte.hu> <200901271745.19574.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901271745.19574.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Rusty Russell wrote:
>
> On Tuesday 27 January 2009 08:47:29 Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in
> > > work_on_cpu." removes get_online_cpus/put_online_cpus, this means the
> > > work can run on the wrong CPU anyway. Or work_on_cpu() can hang forever
> > > if CPU has already gone away before queue_work_on().
> > >
> > > Confused.
> >
> > The idea was to require work_on_cpu() users to be CPU hotplug-safe. But
> > ... Rusty pointed it out in the past that this might be fragile, and we
> > could put back the get_online_cpus()/put_online_cpus() calls.
>
> Old code used to do:
>
> 	tmp = current->cpus_allowed;
> 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
> 	function(arg);
> 	set_cpus_allowed(current, tmp);
>
> We replaced it with:
>
> 	work_on_cpu(cpu, function, arg);
>
> I thought I'd be clever and reliably check that the cpu they asked for
> was online inside work_on_cpu.  Leading to locking problems.  But if they
> didn't previously ensure cpu hotplug didn't happen, they were buggy already,
> so I took out the check and hence the hotplug lock.
>
> So we're no *worse* than we were before, but yes, an audit would probably
> lead to fixes.

I agree, we are no worse than we were before.

But I can't understand why we can't be better ;)

If we add the special workqueue for work_on_cpu() (patch 2/3), then why
do we need [PATCH 1/3] ?

IOW, given that the 2nd patch adds the special wq, which locking problems
solves the 1st patch?

Perhaps I missed something, and the patches are questionable anyway,
but I think these 2 patches are "conflicting".

If we use a special wq, then work_on_cpu()->get_online_cpus() is fine,
it can't deadlock with cpu_hotplug_begin().

No?

Oleg.

