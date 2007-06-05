Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXFEP15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXFEP15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763597AbXFEP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:27:46 -0400
Received: from ozlabs.org ([203.10.76.45]:37496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763236AbXFEP1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:27:44 -0400
Subject: [PATCH 2/6] lguest tsc fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <1181055308.14054.36.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 00:56:36 +1000
Message-Id: <1181055396.14054.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


