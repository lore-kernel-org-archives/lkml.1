Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZKLE5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZKLE5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbZKLE5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:57:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:48873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759625AbZKLE5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:57:39 -0500
Message-ID: <4AFB9595.1030002@kernel.org>
Date: Thu, 12 Nov 2009 13:56:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on	resume
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <4AFA70FB.60706@kernel.org> <20091111181349.GA30638@redhat.com>
In-Reply-To: <20091111181349.GA30638@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oleg Nesterov wrote:
> Well, "more than two instances" is not possible in this particular
> case.

Right, the second one won't leave the cpu and cpu downs don't overlap.

> But in general I agree. If a self-requeueing work assumes it stays on
> the same CPU or it assumes it can never race with itself, it should hook
> CPU_DOWN_PREPARE and cancel the work. Like slab.c does with reap_work.
> 
> This is even documented, the comment above queue_work() says:
> 
> 	* We queue the work to the CPU on which it was submitted, but if the CPU dies
> 	* it can be processed by another CPU.
> 
> We can improve things, see http://marc.info/?l=linux-kernel&m=125562105103769
> 
> But then we should also change workqueue_cpu_callback(CPU_POST_DEAD).
> Instead of flushing, we should carefully move the pending works to
> another CPU, otherwise the self-requeueing work can block cpu_down().

That looks like an excellent idea and I don't think it will add
noticeable overhead even done by default and it will magically make
the "how to implement single-threaded wq semantics in conccurrency
managed wq" problem go away.  I'll work on it.

>> Another related issue is the behavior flush_work() when a work ends up
>> scheduled on a different cpu.  flush_work() will only look at a single
>> cpu workqueue on each flush attempt and if the work is not on the cpu
>> or there but also running on other cpus, it won't do nothing about it.
>> So, it's not too difficult to write code where the caller incorrectly
>> assumes the work is done after flush_work() is finished while the work
>> actually ended up being scheduled on a different cpu.
> 
> Yes, flush_work() is not even supposed to work "correctly" in this case.
> Please note the changelog for db700897224b5ebdf852f2d38920ce428940d059
> In particular:
> 
> 	More precisely, it "flushes" the result of of the last
> 	queue_work() which is visible to the caller.
> 
> but we can add flush_work_sync().
> 
> But flush_work() do not have too much callers. Instead people often
> use flush_workqueue() which just can't help if the work_struct is
> self-requeueing or if it is delayed_work.

If you look at the workqueue code itself very closely, all subtleties
are properly defined and described.  The problem is that it's not very
clear and way too subtle when seen from outside and workqueue is
something used very widely.  I think if we enforce global single
threadedness with the above change, making flush_work() behave as
flush_work_sync() by default should be doable without too much
overhead.  I'll give it a shot.

>> One way to debug I can think of is to record work pointer -> function
>> mapping in a percpu ring buffer
> 
> We can record work->func in work->entry.prev, which is either another
> work or cwq. Please see the debugging patch I sent.

That's much better.  It would be nice to have such debug code in
upstream dependent on a debug config.

> Not sure this patch will help, but I bet that the actual reason for
> this bug is much simpler than the subtle races above ;)

And yes it was but still I'm fairly sure unexpected races described
above are happening.  They would probably be quite infrequent and the
outcome in many cases not bad enough to be noticed.  I think we really
need to plug the hole.  It's scary.

Thanks.

-- 
tejun
