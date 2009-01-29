Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbZA2SX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbZA2SX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZA2SXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:23:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:45864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2SXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:23:19 -0500
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
In-Reply-To: <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <200901290955.38940.rusty@rustcorp.com.au>
	 <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
	 <1233218954.7835.11.camel@twins>
	 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
	 <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 19:23:00 +0100
Message-Id: <1233253380.4495.123.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 10:08 -0800, Linus Torvalds wrote:

> And are you really sure it cannot be called from within interrupts? I'm 
> finding a lot of callers of smp_call_function_single(), and while I 
> couldn't find any that look like interrupts, I also couldn't find any 
> indication that it never happens.

Calls with wait=1 are deadlockable when done from within irqs or irq
disabled sections because two cpus could cross ipi each other and stay
waiting.

That leaves us with the !wait case, which wasn't safe because that
kmalloc could fail, and the fallback was wait, which yields the same
deadlock.

That leaves us with 6 cases,

root@laptop:/usr/src/linux-2.6# git grep "smp_call_function_single(.*0)"
arch/blackfin/kernel/kgdb.c:    smp_call_function_single(cpu, kgdb_passive_cpu_callback, NULL, 0);
arch/ia64/kernel/smpboot.c:     if (smp_call_function_single(master, sync_master, NULL, 0) < 0) {
arch/ia64/kvm/kvm-ia64.c:               smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
arch/x86/kvm/x86.c:             smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
arch/x86/oprofile/nmi_int.c:            smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
arch/x86/pci/amd_bus.c:         smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);

The kgdb one looks to be buggy, as it calls smp_call_function_single()
from under irqs disabled.

Such users should use __smp_call_single_function() with a pre-allocated
csd.

Didn't check the others.



