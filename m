Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZCSOGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZCSOGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZCSOGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:06:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZCSOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:06:30 -0400
Date: Thu, 19 Mar 2009 10:06:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ring-buffer: fix non cpu hotplug case
In-Reply-To: <1237470453-5427-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903191006010.16987@gandalf.stny.rr.com>
References: <1237470453-5427-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Mar 2009, Frederic Weisbecker wrote:

> Impact: fix warning with irqsoff tracer
> 
> The ring buffer allocates its buffers on pre-smp time (early_initcall).
> It means that, at first, only the boot cpu buffer is allocated and
> the ring-buffer cpumask only has the boot cpu set (cpu_online_mask).
> 
> Later, the secondary cpu will show up and the ring-buffer will be notified
> about this event: the appropriate buffer will be allocated and the cpumask
> will be updated.
> 
> Unfortunately, if !CONFIG_CPU_HOTPLUG, the ring-buffer will not be
> notified about the secondary cpus, meaning that the cpumask will have
> only the cpu boot set, and only one cpu buffer allocated.
> 
> We fix that by using cpu_possible_mask if !CONFIG_CPU_HOTPLUG.
> 
> This patch fixes the following warning with irqsoff tracer running:
> 
> [  169.317794] WARNING: at kernel/trace/trace.c:466 update_max_tr_single+0xcc/0xf3()
> [  169.318002] Hardware name: AMILO Li 2727
> [  169.318002] Modules linked in:
> [  169.318002] Pid: 5624, comm: bash Not tainted 2.6.29-rc8-tip-02636-g6aafa6c #11
> [  169.318002] Call Trace:
> [  169.318002]  [<ffffffff81036182>] warn_slowpath+0xea/0x13d
> [  169.318002]  [<ffffffff8100b9d6>] ? ftrace_call+0x5/0x2b
> [  169.318002]  [<ffffffff8100b9d6>] ? ftrace_call+0x5/0x2b
> [  169.318002]  [<ffffffff8100b9d1>] ? ftrace_call+0x0/0x2b
> [  169.318002]  [<ffffffff8101ef10>] ? ftrace_modify_code+0xa9/0x108
> [  169.318002]  [<ffffffff8106e27f>] ? trace_hardirqs_off+0x25/0x27
> [  169.318002]  [<ffffffff8149afe7>] ? _spin_unlock_irqrestore+0x1f/0x2d
> [  169.318002]  [<ffffffff81064f52>] ? ring_buffer_reset_cpu+0xf6/0xfb
> [  169.318002]  [<ffffffff8106637c>] ? ring_buffer_reset+0x36/0x48
> [  169.318002]  [<ffffffff8106aeda>] update_max_tr_single+0xcc/0xf3
> [  169.318002]  [<ffffffff8100bc17>] ? sysret_check+0x22/0x5d
> [  169.318002]  [<ffffffff8106e3ea>] stop_critical_timing+0x142/0x204
> [  169.318002]  [<ffffffff8106e4cf>] trace_hardirqs_on_caller+0x23/0x25
> [  169.318002]  [<ffffffff8149ac28>] trace_hardirqs_on_thunk+0x3a/0x3c
> [  169.318002]  [<ffffffff8100bc17>] ? sysret_check+0x22/0x5d
> [  169.318002] ---[ end trace db76cbf775a750cf ]---
> 
> Because this tracer may try to swap two cpu ring buffers for an
> unregistered cpu on the ring buffer.
> 
> This patch might also fix a fair loss of traces due to unallocated buffers
> for secondary cpus.

Thanks Frederic!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ring_buffer.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index c9ca8a8..bc74f00 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -578,8 +578,17 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
>  	if (buffer->pages == 1)
>  		buffer->pages++;
>  
> +	/*
> +	 * In case of non-hotplug cpu, if the ring-buffer is allocated
> +	 * in early initcall, it will not be notified of secondary cpus.
> +	 * In that off case, we need to allocate for all possible cpus.
> +	 */
> +#ifdef CONFIG_HOTPLUG_CPU
>  	get_online_cpus();
>  	cpumask_copy(buffer->cpumask, cpu_online_mask);
> +#else
> +	cpumask_copy(buffer->cpumask, cpu_possible_mask);
> +#endif
>  	buffer->cpus = nr_cpu_ids;
>  
>  	bsize = sizeof(void *) * nr_cpu_ids;
> -- 
> 1.6.1
> 
> 
