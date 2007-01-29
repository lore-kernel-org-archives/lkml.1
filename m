Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXA2BN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXA2BN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbXA2BN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:13:27 -0500
Received: from mail.screens.ru ([213.234.233.54]:35176 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033AbXA2BN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:13:26 -0500
Date: Mon, 29 Jan 2007 04:13:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129011301.GA844@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For the beginning, about another (but related) minor problem,

	debug_smp_processor_id:

		/*
		 * Kernel threads bound to a single CPU can safely use
		 * smp_processor_id():
		 */

This is only true without CONFIG_HOTPLUG_CPU. Otherwise CPU can go away when
the task takes a preemption or sleeps. I think we need #ifndef here.


Now,
	static void __devinit start_cpu_timer(int cpu)
	{
		struct delayed_work *reap_work = &per_cpu(reap_work, cpu);

		if (keventd_up() && reap_work->work.func == NULL) {
			init_reap_node(cpu);
			INIT_DELAYED_WORK(reap_work, cache_reap);
			schedule_delayed_work_on(cpu, reap_work,
						__round_jiffies_relative(HZ, cpu));
		}
	}

This is wrong. Suppose we have a CPU_UP,CPU_DOWN,CPU_UP sequence. The last
CPU_UP will not restart a per-cpu "cache_reap timer".


With or without recent changes, it is possible that work->func() will run on
another CPU (not that to which it was submitted) if CPU goes down. In fact,
this can happen while work->func() is running, so even smp_processor_id()
is not safe to use in work->func().

However, cache_reap() seems to wrongly assume that smp_processor_id() is stable,
this is the second problem.

Is my understanding correct?

Oleg.

