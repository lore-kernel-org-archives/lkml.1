Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZHZCwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZHZCwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZHZCwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:52:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59968 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZHZCwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:52:22 -0400
Date: Tue, 25 Aug 2009 22:52:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] ftrace: Add timer-source of walltime for ftrace
In-Reply-To: <4A939D98.7020400@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908252250350.12897@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com> <4A939CDF.2000407@cn.fujitsu.com>
 <4A939D98.7020400@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 25 Aug 2009, Zhaolei wrote:

> We can add a timer-source for ftrace to support wall-time display.
> It is based on Steven Rostedt <rostedt@goodmis.org>'s suggestion in:
> http://lkml.org/lkml/2009/7/24/103
> 
> It need to applys on my patch of:
> [PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use
> 
> We can get following output:
>  # cd /mnt/debugfs/tracing/
>  # cat trace_clock
>  [local] global walltime
>  # echo sched_switch > current_tracer
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-3580  [000]  2916.188093:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000]  2916.188205:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000]  2916.188538:   3580:120:R   + [000]     5:115:S events/0
>              bash-3580  [000]  2916.188599:   3580:120:R ==> [000]     5:115:R events/0
>          events/0-5     [000]  2916.188669:      5:115:S ==> [000]  3580:120:R bash
>  ...
>  # echo walltime > trace_clock
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
>  #              | |       |                        |         |
>              bash-3580  [000] 2009-08-24 18:03:16.500705:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S ==> [000]     5:115:R events/0
>          events/0-5     [000] 2009-08-24 18:03:16.500815:      5:115:R   + [000]  3578:120:S sshd
>  ...
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>


> +
> +static int __init walltime_init(void)
> +{
> +	unsigned long flags;
> +	struct timespec ts;
> +	u64 traceclock;
> +
> +	local_irq_save(flags);
> +	getnstimeofday(&ts);
> +	traceclock = trace_clock();
> +	sync_base_walltime(&ts, traceclock);
> +	local_irq_restore(flags);
> +
> +	register_trace_gtod_update_xtime(probe_gtod_update_xtime);

Because this patch depends on patch 2 that creates the "gtod_update_xtime" 
trace point, I have to hold off on this one too. But the first patch is a 
nice clean up regardless. I'll pull that one in.

Thanks,

-- Steve


> +
> +	return 0;
> +}
> +device_initcall_sync(walltime_init);
> +
> +u64 notrace trace_clock_walltime(void)
> +{
> +	return base_walltime + trace_clock();
> +}
