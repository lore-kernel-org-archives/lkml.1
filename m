Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbXFENLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbXFENLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbXFENLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:11:15 -0400
Received: from ozlabs.org ([203.10.76.45]:59506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbXFENLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:11:15 -0400
Subject: [PATCH] lguest-fix-divide-error-implement-sched_clock
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200706051201.32137.ak@suse.de>
References: <20070522223828.GV11115@waste.org>
	 <200706042012.15915.ak@suse.de>
	 <1181011737.25878.146.camel@localhost.localdomain>
	 <200706051201.32137.ak@suse.de>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 23:11:00 +1000
Message-Id: <1181049060.14054.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 12:01 +0200, Andi Kleen wrote:
> > But TSC is a "required feature", so "cpu_has_tsc" is always true.
> 
> Hmm? It isn't. What makes you think so?

Interestingly it seems to be only in -mm.

> > How about this patch:
> > ===
> > Don't try to disable the TSC: it's a required feature under modern
> > configurations, so just mark the sched clock unstable which has the
> > same effect.
> 
> No, using the cpuid bit is the correct way. Or better fix lguest to support
> TSC properly.

I have a patch for a tsc-based clock, but that's a little orthogonal: I
actually need to override sched_clock.

(I'd really like to do stolen time and everything, but looking at Xen
it's a lot of code to do right, and noone's asked for it yet).

This time for sure!

===
In recent -mm kernels, the TSC capability cannot be disabled,
resulting in a divide by zero error in the normal sched_clock.

The correct fix is to have a special lguest sched_clock
implementation: this is as simple as it gets.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -351,11 +351,18 @@ static void lguest_time_irq(unsigned int
 	update_process_times(user_mode_vm(get_irq_regs()));
 }
 
+static u64 sched_clock_base;
 static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
 	hcall(LHCALL_TIMER_READ, 0, 0, 0);
+	sched_clock_base = jiffies_64;
 	enable_lguest_irq(0);
+}
+
+static unsigned long long lguest_sched_clock(void)
+{
+	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
 }
 
 static void lguest_load_esp0(struct tss_struct *tss,
@@ -494,6 +501,7 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
+	paravirt_ops.sched_clock = lguest_sched_clock;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 
@@ -507,8 +515,6 @@ __init void lguest_init(void *boot)
 	cpu_detect(&new_cpu_data);
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
-
-	tsc_disable = 1;
 
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;



