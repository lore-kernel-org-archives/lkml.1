Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbZLGIf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbZLGIf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbZLGIf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:35:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZLGIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:35:58 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1C85D3.3080401@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 09:35:00 +0100
Message-ID: <1260174900.8223.1159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 13:34 +0900, Tejun Heo wrote:
> Hello, Peter.
> 
> On 12/04/2009 07:43 PM, Peter Zijlstra wrote:
> >>> force_cpus_allowed() will be used for concurrency-managed workqueue.
> >>
> >> Would still like to know why all this is needed.
> > 
> > That is, what problem do these new-fangled workqueues have and why is
> > this a good solution.
> 
> This is the original RFC posting of cmwq which includes the whole
> thing.  I'm a few days away from posting a new version but the usage
> of force_cpus_allowed() remains the same.
> 
>   http://thread.gmane.org/gmane.linux.kernel/896268/focus=896294
> 
> There are two tests which are bypassed by the force_ variant.
> 
> * PF_THREAD_BOUND.  This is used to mark tasks which are bound to a
>   cpu using kthread_bind() to be bound permanently.  However, new
>   trustee based workqueue hotplugging decouples per-cpu workqueue
>   flushing with cpu hot plug/unplugging.  This is necessary because
>   with cmwq, long running works can be served by regular workqueues,
>   so delaying completion of hot plug/unplugging till certain works are
>   flushed isn't feasible.  So, what becomes necessary is the ability
>   to re-bind tasks which has PF_THREAD_BOUND set but unbound from its
>   now offline cpu which is coming online again.

I'm not at all sure I like that. I'd be perfectly happy with delaying
the hot-unplug.

The whole cpu hotplug mess is tricky enough as it is and I see no
compelling reason to further complicate it. If people are really going
to enqueue strict per-cpu worklets (queue_work_on()) that takes seconds
to complete, then they get to keep the results of that, which includes
slow hot unplug.

Having an off-line cpu still process code like it was online is asking
for trouble, don't go there.

> * cpu_active() test.  CPU activeness encloses cpu online status which
>   is the actual on/offline state.  Workqueues need to keep running
>   while a cpu is going down and with cmwq keeping workqueues running
>   involves creation of new workers (it consists part of
>   forward-progress guarantee and one of cpu down callbacks might end
>   up waiting on completion of certain works).
> 
>   The problem with active state is that during cpu down, active going
>   off doesn't mean all tasks have been migrated off the cpu, so
>   without a migration interface which is synchronized with the actual
>   offline migration, it is difficult to guarantee that all works are
>   either running on the designated cpu if the cpu is online or all
>   work on other cpus if the cpu is offline.
> 
>   Another related problem is that there's no way to monitor the cpu
>   activeness change notifications.

cpu_active() is basically meant for the scheduler to not stick new tasks
on a dying cpu.

So on hot-unplug you'd want to splice your worklets to another cpu,
except maybe those strictly enqueued to the dying cpu, and since there
was work on the dying cpu, you already had a task processing them, so
you don't need new tasks, right?




