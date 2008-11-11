Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbYKKQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbYKKQIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYKKQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:08:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYKKQIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:08:10 -0500
Date: Tue, 11 Nov 2008 18:03:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Q: force_quiescent_state && cpu_online_map
Message-ID: <20081111170327.GB18214@redhat.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <20081110120401.GA15518@osiris.boeblingen.de.ibm.com> <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl> <20081111105214.GA15645@elte.hu> <20081111113134.GA5653@osiris.boeblingen.de.ibm.com> <20081111124201.GA9459@osiris.boeblingen.de.ibm.com> <20081111143505.GA6923@linux.vnet.ibm.com> <20081111150225.GA10743@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111150225.GA10743@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this matters, but still...

	force_quiescent_state:

			 * cpu_online_map is updated by the _cpu_down()
			 * using __stop_machine(). Since we're in irqs disabled
			 * section, __stop_machine() is not exectuting, hence
			 * the cpu_online_map is stable.
			 *
			 * However,  a cpu might have been offlined _just_ before
			 * we disabled irqs while entering here.
			 * And rcu subsystem might not yet have handled the CPU_DEAD
			 * notification, leading to the offlined cpu's bit
			 * being set in the rcp->cpumask.
			 *
			 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
			 * sending smp_reschedule() to an offlined CPU.
			 */
			cpus_and(cpumask, rcp->cpumask, cpu_online_map);
			cpu_clear(rdp->cpu, cpumask);
			for_each_cpu_mask_nr(cpu, cpumask)
				smp_send_reschedule(cpu);

However,

	// called by __stop_machine take_cpu_down()
	arch/x86/kernel/smpboot.c:cpu_disable_common()

		/*
		 * HACK:
		 * Allow any queued timer interrupts to get serviced
		 * This is only a temporary solution until we cleanup
		 * fixup_irqs as we do for IA64.
		 */
		local_irq_enable();
		mdelay(1);
		local_irq_disable();
		...
		remove_cpu_from_maps(cpu);

So it is possible to send the ipi to the dying CPU. I know nothing
about this low-level irq code, most probably this is harmless. We
already did clear_local_APIC(), but I don't understand what it does.

Oleg.

