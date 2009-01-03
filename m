Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZACSOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZACSOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZACSO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:14:27 -0500
Received: from relay3.sgi.com ([192.48.171.31]:53728 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758904AbZACSO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:14:27 -0500
Message-ID: <495FAAFF.608@sgi.com>
Date: Sat, 03 Jan 2009 10:14:23 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu> <495F84D8.1070404@sgi.com> <20090103154733.GA8111@elte.hu> <20090103160017.GA8920@elte.hu> <495F8DCA.1060905@sgi.com> <20090103174520.GA16704@elte.hu>
In-Reply-To: <20090103174520.GA16704@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>> yep, that's the bad one. Should i revert it or do you have a safe fix 
>>> in mind?
>> Probably revert for now. [...]
> 
> done.
> 
> But -tip testing found another bug today as well, a boot crash with 
> certain (rare) 64-bit configs:
> 
> [    1.588202] ACPI: PCI Interrupt Link [LNKA] (IRQs<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [    1.588012] IP: [<ffffffff80239778>] find_busiest_group+0x198/0xa20
> 
> [    1.588048] Call Trace:
> [    1.588049]  <IRQ> <0> [<ffffffff80240f96>] rebalance_domains+0x196/0x5e0
> [    1.588052]  [<ffffffff80270b15>] ? lock_release_holdtime+0x35/0x1e0
> [    1.588055]  [<ffffffff80983f70>] ? _spin_unlock_irq+0x30/0x40
> [    1.588058]  [<ffffffff8024300e>] run_rebalance_domains+0x4e/0x120
> [    1.588060]  [<ffffffff8024f80c>] __do_softirq+0xac/0x190
> [    1.588063]  [<ffffffff8020d13c>] call_softirq+0x1c/0x30
> [    1.588066]  [<ffffffff8020ef35>] do_softirq+0x75/0xa0
> [    1.588067]  [<ffffffff8024f47d>] irq_exit+0x9d/0xb0
> [    1.588069]  [<ffffffff80984f5d>] smp_apic_timer_interrupt+0x8d/0xc3
> [    1.588071]  [<ffffffff8020cb73>] apic_timer_interrupt+0x13/0x20
> 
> i just bisected it back to:
> 
> | 74c5409893751c400547184751410c61930043b2 is first bad commit
> | commit 74c5409893751c400547184751410c61930043b2
> | Author: Mike Travis <travis@sgi.com>
> | Date:   Wed Dec 31 18:08:45 2008 -0800
> |
> |     x86: cleanup remaining cpumask_t ops in smpboot code
> |    
> |     Impact: Reduce memory usage and use new cpumask API.
> 
> this is in the final pieces of changes you did after pulling Rusty's tree:
> 
> 26e2013: x86: setup_per_cpu_areas() cleanup
> 44aa683: cpumask: fix compile error when CONFIG_NR_CPUS is not defined
> eeff031: cpumask: use alloc_cpumask_var_node where appropriate
> 40fbcb0: cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var
> 197e99c: x86: use cpumask_var_t in acpi/boot.c
> 2d22bd5: x86: cleanup remaining cpumask_t code in microcode_core.c
> 22022f5: x86: cleanup remaining cpumask_t code in mce_amd_64.c
> b5f3096: x86: cleanup some remaining usages of NR_CPUS where s/b nr_cpu_ids
> efb897c: sched: put back some stack hog changes that were undone in kernel/sched.c
> 74c5409: x86: cleanup remaining cpumask_t ops in smpboot code
> 8627b2a: x86: enable cpus display of kernel_max and offlined cpus
> 095fb96: Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/ru
> 
> i think i'll just rebase the tail portion of cpus4096 starting at 8627b2a 
> - this keeps most of the history intact and avoids these ugly reverts. 
> 
> Also, while bisecting this window of commits i found that neither would 
> build successfully due to a typo - and the typo is fixed in 095fb96. So 
> since we rebase this portion anyway due to excessive amount of bugs, i'll 
> make it fully bisectable by rebasing right at 095fb96, backmerge the 
> fixlet from eeff031 and redo the whole series dropping the two bad 
> patches. Since this portion of the tree has no appreciable testing value 
> the rebase is the right thing to do here.
> 
> 	Ingo

Ok, thanks.  Still working through my queue...  I'll re-pull when you've
got your part done.

Mike

