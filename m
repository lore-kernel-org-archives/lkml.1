Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbZLGKz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbZLGKz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZLGKzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:55:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbZLGKzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:55:24 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1CDA1C.3000802@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 11:54:38 +0100
Message-ID: <1260183278.8223.1500.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 19:34 +0900, Tejun Heo wrote:
> Hello,
> 
> On 12/07/2009 05:35 PM, Peter Zijlstra wrote:
> >> * PF_THREAD_BOUND.  This is used to mark tasks which are bound to a
> >>   cpu using kthread_bind() to be bound permanently.  However, new
> >>   trustee based workqueue hotplugging decouples per-cpu workqueue
> >>   flushing with cpu hot plug/unplugging.  This is necessary because
> >>   with cmwq, long running works can be served by regular workqueues,
> >>   so delaying completion of hot plug/unplugging till certain works are
> >>   flushed isn't feasible.  So, what becomes necessary is the ability
> >>   to re-bind tasks which has PF_THREAD_BOUND set but unbound from its
> >>   now offline cpu which is coming online again.
> > 
> > I'm not at all sure I like that. I'd be perfectly happy with delaying
> > the hot-unplug.
> > 
> > The whole cpu hotplug mess is tricky enough as it is and I see no
> > compelling reason to further complicate it. If people are really going
> > to enqueue strict per-cpu worklets (queue_work_on()) that takes seconds
> > to complete, then they get to keep the results of that, which includes
> > slow hot unplug.
> > 
> > Having an off-line cpu still process code like it was online is asking
> > for trouble, don't go there.
> 
> We're already there.  Users of workqueue which require strict CPU
> affinity are required to flush respective works from CPU down
> notifiers and fire them as necessary on up notifiers; otherwise, works
> will continue to run until they're done after the cpu went down
> regardless of whether explicit queue_work_on() was used or not.

So we seem to do cleanup_workqueue_thread() from CPU_POST_DEAD, but at
that time any thread that might still be around will most certainly not
be running on the offlined cpu anymore.

If you really want to ensure you remain on the cpu, you have to complete
from CPU_DOWN_PREPARE.

We're not running things from offline CPUs.



