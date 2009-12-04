Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZLDKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZLDKne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZLDKnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:43:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZLDKnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:43:31 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <1259923259.3977.1928.camel@laptop>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 11:43:01 +0100
Message-ID: <1259923381.3977.1934.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 11:40 +0100, Peter Zijlstra wrote:
> On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:
> > set_cpus_allowed_ptr() modifies the allowed cpu mask of a task.  The
> > function performs the following checks before applying new mask.
> > 
> > * Check whether PF_THREAD_BOUND is set.  This is set for bound
> >   kthreads so that they can't be moved around.
> > 
> > * Check whether the target cpu is still marked active - cpu_active().
> >   Active state is cleared early while downing a cpu.
> > 
> > This patch adds force_cpus_allowed() which bypasses the above two
> > checks.  The caller is responsible for guaranteeing that the
> > destination cpu doesn't go down until force_cpus_allowed() finishes.
> > 
> > The first check is bypassed by factoring out actual migration part
> > into __set_cpus_allowed() from set_cpus_allowed_ptr() and calling the
> > inner function from force_cpus_allowed().
> > 
> > The second check is buried deep down in __migrate_task() which is
> > executed by migration threads.  @force parameter is added to
> > __migrate_task().  As the only way to pass parameters from
> > __set_cpus_allowed() is through migration_req, migration_req->force is
> > added and the @force parameter is passed down to __migrate_task().
> > 
> > Please note the naming discrepancy between set_cpus_allowed_ptr() and
> > the new functions.  The _ptr suffix is from the days when cpumask api
> > wasn't mature and future changes should drop it from
> > set_cpus_allowed_ptr() too.
> > 
> > force_cpus_allowed() will be used for concurrency-managed workqueue.
> 
> Would still like to know why all this is needed.

That is, what problem do these new-fangled workqueues have and why is
this a good solution.

