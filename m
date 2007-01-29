Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbXA2QzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbXA2QzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXA2QzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:55:17 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:34878 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751510AbXA2QzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:55:16 -0500
Date: Mon, 29 Jan 2007 08:54:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <20070129011301.GA844@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Oleg Nesterov wrote:

> Now,
> 	static void __devinit start_cpu_timer(int cpu)
> 	{
> 		struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
> 
> 		if (keventd_up() && reap_work->work.func == NULL) {
> 			init_reap_node(cpu);
> 			INIT_DELAYED_WORK(reap_work, cache_reap);
> 			schedule_delayed_work_on(cpu, reap_work,
> 						__round_jiffies_relative(HZ, cpu));
> 		}
> 	}
> 
> This is wrong. Suppose we have a CPU_UP,CPU_DOWN,CPU_UP sequence. The last
> CPU_UP will not restart a per-cpu "cache_reap timer".

Why?

> With or without recent changes, it is possible that work->func() will run on
> another CPU (not that to which it was submitted) if CPU goes down. In fact,
> this can happen while work->func() is running, so even smp_processor_id()
> is not safe to use in work->func().

But the work func was scheduled by schedule_delayed_work_on(). Isnt that a 
general problem with schedule_delayed_work_on() and keventd?

> However, cache_reap() seems to wrongly assume that smp_processor_id() is stable,
> this is the second problem.
> 
> Is my understanding correct?

cache_reap assumes that the processor id is stable based on the kevent 
thread being pinned to a processor.
