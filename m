Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYGMIu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYGMIu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYGMIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:50:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:1094 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYGMIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j3mB26z9QibO8LYri/leauRtefIwS7Ar5yAqN6gcS3/8AfyLt0wxU6w7PslP7kUqSc
         nAJevEEQXufIZe2m0i1OHIVaUCq6c3BonMQIsk6Ao1Wal5G9HTJLbpeb85uuPkI3rX2s
         tCVu9xLCmqZcY6tmPKJXbB5PU0ZUzGDj1Vbdk=
Message-ID: <19f34abd0807130150y581abe07j29765a9424cdb02@mail.gmail.com>
Date: Sun, 13 Jul 2008 10:50:12 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1215907829.8998.23.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215859526.5405.3.camel@earth> <1215861285.5405.6.camel@earth>
	 <1215907829.8998.23.camel@earth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 2:10 AM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> Subject: fix cpuset_handle_cpuhp()
>
> The following commit
>
> ---
> commit f18f982abf183e91f435990d337164c7a43d1e6d
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Thu May 29 11:17:01 2008 -0700
>
> sched: CPU hotplug events must not destroy scheduler domains created by
> the cpusets
> ---
>
> [ Note, with this commit arch_update_cpu_topology is not called any more for CPUSETS. But it's just a nop.
> The whole scheme should be probably reworked later. ]
>
>
> introduced a hotplug-related problem as described below:
>
> [ Basically the fix below just emulates the 'old' behavior of update_sched_domains().
> We call rebuild_sched_domains() for the same hotplug-events as it was called (and is still called
> for !CPUSETS case) in update_sched_domains(). ]
>
>
> Upon CPU_DOWN_PREPARE, update_sched_domains() -> detach_destroy_domains(&cpu_online_map)
> does the following:
>
> /*
>  * Force a reinitialization of the sched domains hierarchy. The domains
>  * and groups cannot be updated in place without racing with the
> balancing
>  * code, so we temporarily attach all running cpus to the NULL domain
>  * which will prevent rebalancing while the sched domains are
> recalculated.
>  */
>
> The sched-domains should be rebuilt when a CPU_DOWN ops. has been
> completed, effectively either upon CPU_DEAD{_FROZEN} (upon success) or
> CPU_DOWN_FAILED{_FROZEN} (upon failure -- restore the things to their
> initial state). That's what update_sched_domains() also does but only
> for !CPUSETS case.
>
> With Max's patch, sched-domains' reinitialization is delegated to
> CPUSETS code:
>
> cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
> rebuild_sched_domains()
>
> Being called for CPU_UP_PREPARE and if its callback is called after
> update_sched_domains()), it just negates all the work done by
> update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
> the sched-domains and that makes it visible for the load-balancer
> while the CPU_DOWN ops. is in progress.
>
> __migrate_live_tasks() moves the tasks off a 'dead' cpu (it's already
> "offline" when this function is called).
>
> try_to_wake_up() is called for one of these tasks from another CPU ->
> the load-balancer (wake_idle()) picks up a "dead" CPU and places the
> task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later
> -> oops.
>
>
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Tested-by: Vegard Nossum <vegard.nossum@gmail.com>

Works :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
