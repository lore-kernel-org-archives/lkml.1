Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab0CKPl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:41:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:56091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab0CKPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:41:26 -0500
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100311152201.GA13888@redhat.com>
References: <20100309180615.GA11681@redhat.com>
	 <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com>
	 <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com>
	 <20100311145248.GA12907@redhat.com>  <20100311152201.GA13888@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 16:41:18 +0100
Message-ID: <1268322078.5037.118.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 16:22 +0100, Oleg Nesterov wrote:
> On 03/11, Oleg Nesterov wrote:
> >
> > How can we fix this later? Perhaps we can change
> > cpuset_track_online_cpus(CPU_DEAD) to scan all affected cpusets and
> > fixup the tasks with the wrong ->cpus_allowed == cpu_possible_mask.
> 
> Wait. We need to fix the CPU_DEAD case anyway?
> 
> Hmm. 6ad4c18884e864cf4c77f9074d3d1816063f99cd
> "sched: Fix balance vs hotplug race" did s/CPU_DEAD/CPU_DOWN_PREPARE/
> in cpuset_track_online_cpus(). This doesn't look exactly right to me,
> we shouldn't do remove_tasks_in_empty_cpuset() at CPU_DOWN_PREPARE
> stage, it can fail.

Sure, tough luck for those few tasks.

> Otoh. This means that move_task_of_dead_cpu() can never see the
> task without active cpus in ->cpus_allowed, it is called later by
> CPU_DEAD. So, cpuset_lock() is not needed at all.

Right,.. so the whole problem is cpumask ops are terribly expensive
since we got this CONFIG_CPUMASK_OFFSTACK muck, so we try to reduce
these ops in the regular scheduling paths, in the patch you referenced
above the tradeof was between fixing the sched_domains up too often vs
adding a cpumask_and in a hot-path, guess who won ;-)



