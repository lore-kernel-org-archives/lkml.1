Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYHYUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYHYUxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYHYUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:53:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbYHYUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:53:00 -0400
Date: Mon, 25 Aug 2008 13:52:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com>
 <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Linus Torvalds wrote:
> 
> But I'll look at your vmlinux, see what stands out.

Oops. I already see the problem.

Your .config has soem _huge_ CPU count, doesn't it?

checkstack.pl shows these things as the top problems:

	0xffffffff80266234 smp_call_function_mask [vmlinux]:    2736
	0xffffffff80234747 __build_sched_domains [vmlinux]:     2232
	0xffffffff8023523f __build_sched_domains [vmlinux]:     2232
	0xffffffff8021e884 setup_IO_APIC_irq [vmlinux]:         1616
	0xffffffff8021ee24 arch_setup_ht_irq [vmlinux]:         1600
	0xffffffff8021f144 arch_setup_msi_irq [vmlinux]:        1600
	0xffffffff8021e3b0 __assign_irq_vector [vmlinux]:       1592
	0xffffffff8021e626 __assign_irq_vector [vmlinux]:       1592
	0xffffffff8023257e move_task_off_dead_cpu [vmlinux]:    1592
	0xffffffff802326e8 move_task_off_dead_cpu [vmlinux]:    1592
	0xffffffff8025dbc5 tick_handle_oneshot_broadcast [vmlinux]:1544
	0xffffffff8025dcb4 tick_handle_oneshot_broadcast [vmlinux]:1544
	0xffffffff803f3dc4 store_scaling_governor [vmlinux]:    1376
	0xffffffff80279ef4 cpuset_write_resmask [vmlinux]:      1360
	0xffffffff803f465d cpufreq_add_dev [vmlinux]:           1352
	0xffffffff803f495b cpufreq_add_dev [vmlinux]:           1352
	0xffffffff803f3fc4 store_scaling_max_freq [vmlinux]:    1328
	0xffffffff803f4064 store_scaling_min_freq [vmlinux]:    1328
	0xffffffff803f44c4 cpufreq_update_policy [vmlinux]:     1328
	..

and sys_init_module is actually way way down the list. I bet the only 
reason it showed up at all was because dynamically it was such a deep 
callchain, and part of that callchain probably called some of those really 
nasty things.

Anyway, the reason smp_call_function_mask and friends have such _huge_ 
stack usages for you is that they contain a 'cpumask_t' on the stack.

For example, for me, usign a sane NR_CPU, the size of the stack frame for 
smp_call_function_mask is under 200 bytes.  For you, it's 2736 bytes.

How about you make CONFIG_NR_CPU's something _sane_? Like 16? Or do you 
really have four thousand CPU's in that system?

Oh, I guess you have the MAXSMP config enabled? I really think that was a 
bit too aggressive.

		Linus
