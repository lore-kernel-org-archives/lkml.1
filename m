Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZKLTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZKLTNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZKLTNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:13:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:58133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZKLTNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:13:42 -0500
Message-ID: <4AFC5E96.1020609@kernel.org>
Date: Fri, 13 Nov 2009 04:14:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on	resume
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <4AFA70FB.60706@kernel.org> <20091111181349.GA30638@redhat.com> <4AFB9595.1030002@kernel.org> <20091112183508.GA14661@redhat.com>
In-Reply-To: <20091112183508.GA14661@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

11/13/2009 03:35 AM, Oleg Nesterov wrote:
>> That looks like an excellent idea and I don't think it will add
>> noticeable overhead even done by default and it will magically make
>> the "how to implement single-threaded wq semantics in conccurrency
>> managed wq" problem go away.  I'll work on it.
> 
> I am still not sure all work_structs should single-threaded by default.
> 
> To clarify, I am not arguing. Just I don't know. I mean, this change can
> break the existing code, and it is not easy to notice the problem.

Hmm... I can't think of something which will break if single thread
(or execution instance) is enforced.  Are you worrying about ignoring
cpu designation?  I'm still working on it but it seems possible to
honor cpu parameter and enforce single thread.

>> making flush_work() behave as
>> flush_work_sync() by default should be doable without too much
>> overhead.  I'll give it a shot.
> 
> Well, I disagree. Imho it is better to have both flush_work() and
> flush_work_sync(). flush_work() is "special" and should be used with
> care. But this is minor, and if the work_stuct is single-threaded then
> flush_work() == flush_work_sync().
> 
> (Perhaps this is what you meant)

Yeap, that was what I meant.  :-)

> My only point was, it is not that workqueues are buggy, they were
> designed (and even documented) to work this way. I can't judge if it
> was right or not, but personally I think everything is "logical".

Yes, it's very focused on lowering cross-cpu overhead whereever
possible.  I think the one design decision which added most to
complexity and subtlety was allowing work functions to free or reuse
work structs leaving the workqueue code only the pointer value to work
with for synchronization.  Maybe it's worth it.  I don't know.  At any
rate changing it would be too costly at this point.

> That said, I agree that we have too many buggy users, perhaps we
> should simplify the rules.
> 
> I just noticed that schedule_on_each_cpu() was recently changed by
> 
> 	HWPOISON: Allow schedule_on_each_cpu() from keventd
> 	commit: 65a64464349883891e21e74af16c05d6e1eeb4e9
> 
> Surprisingly, even this simple change is not exactly right.
> 
> 	/*
> 	 * when running in keventd don't schedule a work item on itself.
> 	 * Can just call directly because the work queue is already bound.
> 	 * This also is faster.
> 	 * Make this a generic parameter for other workqueues?
> 	 */
> 	if (current_is_keventd()) {
> 		orig = raw_smp_processor_id();
> 		INIT_WORK(per_cpu_ptr(works, orig), func);
> 		func(per_cpu_ptr(works, orig));
> 	}
> 
> OK, but this code should be moved down, under get_online_cpus().

Yeap, I already have the patch in my queue.  It will be going out in a
few days.

> Perhaps you and Linus are right, and we should simplify the rules
> unconditionally. But note that the problem above has nothing to do with
> single-threaded behaviour, and I do not think it is possible to guarantee
> work->func() can't be moved to another CPU.

I don't know about Linus but I definitely would like default single
threaded behavior.  Currently, singlethread workqueue is used for two
things - to limit the number of workers and to avoid works executing
simultaneously on different cpus but I don't think all users are
careful enough about the second point.

Thanks.

-- 
tejun
