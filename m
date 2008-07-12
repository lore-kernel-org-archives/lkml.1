Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYGLKEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYGLKEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYGLKEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:04:39 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:1675 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYGLKEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P/zq7H6PcsexKou1GT9EvRE9rHU1Mg3jIxw7Aa0pElY34cY1QHWNmJ8BiELxgZPxoF
         mWWHkUR84/kquQadC7XPBjotqaZCeBJSVVP+6QUYDBgswhDgkCYo7gu1OC5KSNtjMmdF
         7svmLQS+KpGgcOY0T+vWpQbpSaGGNuVDlV/CI=
Message-ID: <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
Date: Sat, 12 Jul 2008 12:04:36 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/12 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Sat, 12 Jul 2008, Vegard Nossum wrote:
>>
>> Can somebody else please test/ack/review it too? This should eventually
>> go into 2.6.26 if it doesn't break anything else.
>
> And Dmitry, _please_ also explain what was going on. Why did things break
> from calling common_cpu_mem_hotplug_unplug() too much? That function is
> called pretty randomly anyway (for just about any random CPU event), so
> why did it fail in some circumstances?

Upon CPU_DOWN_PREPARE, update_sched_domains() ->
detach_destroy_domains(&cpu_online_map) ;
does the following:

/*
 * Force a reinitialization of the sched domains hierarchy. The domains
 * and groups cannot be updated in place without racing with the balancing
 * code, so we temporarily attach all running cpus to the NULL domain
 * which will prevent rebalancing while the sched domains are recalculated.
 */

The sched-domains should be rebuilt when a CPU_DOWN ops. is completed,
effectivelly either upon CPU_DEAD{_FROZEN} (upon success) or
CPU_DOWN_FAILED{_FROZEN} (upon failure -- restore the things to their
initial state). That's what update_sched_domains() also does but only
for !CPUSETS case.

With Max's patch, sched-domains' reinitialization is delegated to CPUSETS code:

cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
rebuild_sched_domains()

which as you've said "called pretty randomly anyway", e.g. for CPU_UP_PREPARE.

[ ah, then rebuild_sched_domains() should not be there. It should be
nop for MEMPLUG events I presume - should make another patch. ]

Being called for CPU_UP_PREPARE (and if its callback is called after
update_sched_domains()), it just negates all the work done by
update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
the sched-domains and that makes it visible for the load-balancer
while the CPU_DOWN ops. is in progress.

__migrate_live_tasks() moves the tasks off a 'dead' cpu (it's already
"offline" when this function is called).

try_to_wake_up() is called for one of these tasks from another CPU ->
the load-balancer (wake_idle()) picks up a "dead" CPU and places the
task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later
-> oops.

Now another funny thing is that we probably have a memory leak with
common_cpu_mem_hotplug_unplug() "randomly" calling
rebuild_sched_domains() and sometimes re-allocating domains when they
already exist.


>
>                Linus
>

-- 
Best regards,
Dmitry Adamushko
