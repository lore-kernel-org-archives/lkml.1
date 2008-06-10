Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYFJQaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYFJQaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYFJQaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:30:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52831 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYFJQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:30:06 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3639169"
Message-ID: <484EAC2F.5020103@qualcomm.com>
Date: Tue, 10 Jun 2008 09:30:39 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>, mingo@elte.hu
CC: David Rientjes <rientjes@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: cpusets and kthreads, inconsistent behaviour
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pointed this out in the email thread about PF_THREAD_BOUND patch and wanted
to restart the thread to make sure that people pay attention :).
I was going to cook up a patch for this and wanted to get some early feedback
to avoid time waste.

Basically the issue is that current behaviour of the cpusets is inconsistent
with regards to kthreads. Kthreads inherit cpuset from a parent properly but
they simply ignore cpuset.cpus when their cpu affinity is set/updated.
I think the behaviour must be consistent across the board. cpuset.cpus must
apply to _all_ the tasks in the set, not just some of the tasks. If kthread
must run on the cpus other than current_cpuset.cpus then it should detach from
the cpuset.

To give you an example kthreads like scsi_eh, kswapd, kacpid, pdflush,
kseriod, etc are all started with cpus_allows=ALL_CPUS even though they
inherit a cpuset from kthreadd. Yes they can moved manually (with
sched_setaffinity) but the behaviour is not consistent, and for no good
reason. kthreads can be stopped/started at any time (module load for example)
which means that the user will have to keep moving them.

To sum it up here is what I'm suggesting:
kthread_bind(task, cpu)
{
   // Set PF_THREAD_BOUND
   // Move into root cpuset
   // Bind to the cpu
}

kthread_setaffinity(task, cpumask)
{
   // Enforce cpuset.cpus_allowed
   // Updated affinity mask and migrate kthread (if needed)
}

Kthreads that do not require strict cpu binding will be calling
kthread_setaffinity() instead of set_cpus_allowed_ptr() and such.

Kthreads that require strict cpu binding will be calling kthread_bind() and
detach from the cpuset they inherit from their parent.

That way the behaviour is consistent across the board.

Comments ?

Max

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
