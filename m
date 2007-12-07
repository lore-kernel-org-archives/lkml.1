Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXLGKAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXLGKAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXLGKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:00:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35235 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXLGKAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:00:07 -0500
Date: Fri, 7 Dec 2007 10:59:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207095931.GA27307@elte.hu>
References: <20071207021952.6f0ac922@morte> <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain> <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com> <20071207090252.1caf1509@inria.fr> <20071207085121.GA12625@elte.hu> <20071207102938.5ca48859@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207102938.5ca48859@inria.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> I'll clean it up and resend it later. As I don't have the necessary 
> knowledge to do the tsc_{32,64}.c unification, should I copy paste 
> common functions into tsc_32.c and tsc_64.c to ease later unification 
> or should I start a common .c file?

note that there are a couple of existing patches in this area. One is 
the fix below. There's also older frequency-scaling TSC patches - i'll 
try to dig them out.

	Ingo

---------------->
Subject: x86: idle wakeup event in the HLT loop
From: Ingo Molnar <mingo@elte.hu>

do a proper idle-wakeup event on HLT as well - some CPUs stop the TSC
in HLT too, not just when going through the ACPI methods.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/process_32.c
===================================================================
--- linux.orig/arch/x86/kernel/process_32.c
+++ linux/arch/x86/kernel/process_32.c
@@ -113,10 +113,19 @@ void default_idle(void)
 		smp_mb();
 
 		local_irq_disable();
-		if (!need_resched())
+		if (!need_resched()) {
+			ktime_t t0, t1;
+			u64 t0n, t1n;
+
+			t0 = ktime_get();
+			t0n = ktime_to_ns(t0);
 			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
+			local_irq_disable();
+			t1 = ktime_get();
+			t1n = ktime_to_ns(t1);
+			sched_clock_idle_wakeup_event(t1n - t0n);
+		}
+		local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		/* loop is done by the caller */
