Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXBJXyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXBJXyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXBJXyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:54:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38784 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXBJXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:54:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ashok Raj <ashok.raj@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Zwane Mwaikambo <zwane@holomorphy.com>,
       Coywolf Qi Hunt <coywolf@lovecn.org>
Subject: What are the real ioapic rte programming constraints?
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
Date: Sat, 10 Feb 2007 16:52:42 -0700
In-Reply-To: <m1veib6dgi.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Thu, 08 Feb 2007 23:40:29 -0700")
Message-ID: <m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have recently been investigating why we reprogram ioapic irqs in the
interrupt handler, because it significantly complicates the code, and
makes things more fragile.  Eventually I found the commit with the
justification, see below.

There are not enough details in the justification to really understand
the issue so I'm asking to see if someone has some more details.

The description makes the assertion that reprograming the ioapic
when an  interrupt is pending is the only safe way to handle this.
Since edge triggered interrupts cannot be pending at the ioapic I know
it is not talking level triggered interrupts.

However it is not possible to fully reprogram a level triggered
interrupt when the interrupt is pending as the ioapic will not
receive the interrupt acknowledgement.  So it turns out I have
broken this change for several kernel releases without people
screaming at me about io_apic problems.

Currently I am disabling the irq on the ioapic before reprogramming
it so I do not run into issues.  Does that solve the concerns that
were patched around by only reprogramming interrupt redirection
table entry in interrupt handlers?

If it does I can solve and simply the code by moving it all back
into process context.

commit 54d5d42404e7705cf3804593189e963350d470e5
Author: Ashok Raj <ashok.raj@intel.com>
Date:   Tue Sep 6 15:16:15 2005 -0700

    [PATCH] x86/x86_64: deferred handling of writes to /proc/irqxx/smp_affinity
    
    When handling writes to /proc/irq, current code is re-programming rte
    entries directly. This is not recommended and could potentially cause
    chipset's to lockup, or cause missing interrupts.
    
    CONFIG_IRQ_BALANCE does this correctly, where it re-programs only when the
    interrupt is pending. The same needs to be done for /proc/irq handling as well.
    Otherwise user space irq balancers are really not doing the right thing.
    
    - Changed pending_irq_balance_cpumask to pending_irq_migrate_cpumask for
      lack of a generic name.
    - added move_irq out of IRQ_BALANCE, and added this same to X86_64
    - Added new proc handler for write, so we can do deferred write at irq
      handling time.
    - Display of /proc/irq/XX/smp_affinity used to display CPU_MASKALL, instead
      it now shows only active cpu masks, or exactly what was set.
    - Provided a common move_irq implementation, instead of duplicating
      when using generic irq framework.
    
    Tested on i386/x86_64 and ia64 with CONFIG_PCI_MSI turned on and off.
    Tested UP builds as well.
    
    MSI testing: tbd: I have cards, need to look for a x-over cable, although I
    did test an earlier version of this patch.  Will test in a couple days.
    
    Signed-off-by: Ashok Raj <ashok.raj@intel.com>
    Acked-by: Zwane Mwaikambo <zwane@holomorphy.com>
    Grudgingly-acked-by: Andi Kleen <ak@muc.de>
    Signed-off-by: Coywolf Qi Hunt <coywolf@lovecn.org>
    Signed-off-by: Ashok Raj <ashok.raj@intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
