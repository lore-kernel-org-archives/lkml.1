Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab0CKPXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:23:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643Ab0CKPXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:23:32 -0500
Date: Thu, 11 Mar 2010 16:22:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100311152201.GA13888@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com> <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com> <20100311145248.GA12907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311145248.GA12907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Oleg Nesterov wrote:
>
> How can we fix this later? Perhaps we can change
> cpuset_track_online_cpus(CPU_DEAD) to scan all affected cpusets and
> fixup the tasks with the wrong ->cpus_allowed == cpu_possible_mask.

Wait. We need to fix the CPU_DEAD case anyway?

Hmm. 6ad4c18884e864cf4c77f9074d3d1816063f99cd
"sched: Fix balance vs hotplug race" did s/CPU_DEAD/CPU_DOWN_PREPARE/
in cpuset_track_online_cpus(). This doesn't look exactly right to me,
we shouldn't do remove_tasks_in_empty_cpuset() at CPU_DOWN_PREPARE
stage, it can fail.

Otoh. This means that move_task_of_dead_cpu() can never see the
task without active cpus in ->cpus_allowed, it is called later by
CPU_DEAD. So, cpuset_lock() is not needed at all.

Oleg.

