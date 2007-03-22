Return-Path: <linux-kernel-owner+w=401wt.eu-S965898AbXCVJcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965898AbXCVJcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965900AbXCVJcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:32:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965898AbXCVJcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:32:01 -0400
Date: Thu, 22 Mar 2007 10:31:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] setup_boot_APIC_clock() irq-enable fix
Message-ID: <20070322093119.GA19394@elte.hu>
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Hi Ingo,

> 2.6.21-rc4-rt0

> BUG: at kernel/fork.c:1033 copy_process()

thanks Michal - this is a real bug that affects upstream too. Find the 
fix below - i've test-booted it and it fixes the warning.

Linus, Andrew, this is a must-have for v2.6.21.

	Ingo

--------------->
Subject: [patch] setup_boot_APIC_clock() irq-enable fix
From: Ingo Molnar <mingo@elte.hu>

latest -git triggers an irqtrace/lockdep warning of a leaked
irqs-off condition:

  BUG: at kernel/fork.c:1033 copy_process()

after some debugging it turns out that commit ca1b940c accidentally left 
interrupts disabled - which trickled down all the way to the first time 
we fork a kernel thread and triggered the warning.

the fix is to re-enable interrupts in the 'else' branch of 
setup_boot_APIC_clock()'s pmtimers calibration path.

Reported-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/apic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -507,7 +507,8 @@ void __init setup_boot_APIC_clock(void)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
 		else
 			local_apic_timer_verify_ok = 0;
-	}
+	} else
+		local_irq_enable();
 
 	if (!local_apic_timer_verify_ok) {
 		printk(KERN_WARNING
