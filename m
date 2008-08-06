Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbYHFFqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbYHFFqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYHFFqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:46:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51474 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752962AbYHFFqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:46:32 -0400
Date: Wed, 6 Aug 2008 00:46:29 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080806004629.d321f3b0.pj@sgi.com>
In-Reply-To: <489930B5.9030906@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
	<20080804225636.541527e8.pj@sgi.com>
	<4898B873.6000308@qualcomm.com>
	<20080805180521.be7010e1.pj@sgi.com>
	<48991973.90109@qualcomm.com>
	<20080805222927.6dd95f5f.pj@sgi.com>
	<4899202B.6030303@qualcomm.com>
	<20080805232856.78dd50f7.pj@sgi.com>
	<489930B5.9030906@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max, replying to pj:
> > ...  Such naming controversies are usually
> > a sign of code duplication or improper factoring.
> I'm not sure what you're referring to. There was no back an forth.

I was referring to an earlier discussion, which resulted in a patch
which includes the line:

    __rebuild_sched_domains() has been renamed to async_rebuild_sched_domains().

> What I'm saying is that I do not think it's the best
> to change all the paths to be async.

But you seemed to be saying that the reason it was not
best to do so was because it was best not to change more
than necessary.

Perhaps I still don't understand your metric.  Apparently
it is not CPU cycles, nor "least change", but something else?

> I still do not see a good reason why. IMO exceptions are acceptable.
> Only domain rebuilds triggered by cpuset fs writes need to be async.
> I do not see a good technical reason why the rest needs to be converted
> and retested.

Well, your metric seems clear enough there - minimize effort of
code conversion and testing.


How about this ... two routines quite identical and parallel,
even in their names, except that one is async and the other not:

==================================================================

/*
 * Rebuild scheduler domains, asynchronously in a separate thread.
 *
 * If the flag 'sched_load_balance' of any cpuset with non-empty
 * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
 * which has that flag enabled, or if any cpuset with a non-empty
 * 'cpus' is removed, then call this routine to rebuild the
 * scheduler's dynamic sched domains.
 *
 * The rebuild_sched_domains() and partition_sched_domains()
 * routines must nest cgroup_lock() inside get_online_cpus(),
 * but such cpuset changes as these must nest that locking the
 * other way, holding cgroup_lock() for much of the code.
 *
 * So in order to avoid an ABBA deadlock, the cpuset code handling
 * these user changes delegates the actual sched domain rebuilding
 * to a separate workqueue thread, which ends up processing the
 * above rebuild_sched_domains_thread() function.
 */
static void async_rebuild_sched_domains(void)
{
        queue_work(cpuset_wq, &rebuild_sched_domains_work);
}

/*
 * Accomplishes the same scheduler domain rebuild as the above
 * async_rebuild_sched_domains(), however it directly calls the
 * rebuild routine inline, rather than calling it via a separate
 * asynchronous work thread.
 *
 * This can only be called from code that is not holding
 * cgroup_mutex (not nested in a cgroup_lock() call.)
 */
void inline_rebuild_sched_domains(void)
{
        rebuild_sched_domains_thread(NULL);
}

==================================================================

> To be fair the fact that you had trouble understanding my code does
> not automatically mean that it was not artistic ;-).

Quite so ... my mental capacities are modest and easily distracted ;).

Likely this explains in part why I fuss so much over keeping code
straight forward, with minimal twists, and turns, and duplications
with non-essential variations in detail.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
