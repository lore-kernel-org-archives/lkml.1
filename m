Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYE3EI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYE3EI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYE3EAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40501 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753078AbYE3EAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:23 -0400
Message-Id: <20080530040020.795099870@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:49 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 29/41] x86_64: Use CPU ops for nmi alert counter
Content-Disposition: inline; filename=cpu_alloc_remove_local_t_in_nmi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are critical fast paths. Reduce overhead by using a segment override
instead of an address calculation.

Signed-off-by: Christoph LAmeter <clameter@sgi.com>
---
 arch/x86/kernel/nmi_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/nmi_64.c	2008-04-29 14:55:48.000000000 -0700
+++ linux-2.6/arch/x86/kernel/nmi_64.c	2008-05-21 22:49:33.000000000 -0700
@@ -290,7 +290,7 @@
  */
 
 static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(int, alert_counter);
 static DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
@@ -356,13 +356,13 @@
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5*nmi_hz)
+		CPU_INC(per_cpu_var(alert_counter));
+		if (CPU_READ(per_cpu_var(alert_counter)) == 5*nmi_hz)
 			die_nmi("NMI Watchdog detected LOCKUP on CPU %d\n", regs,
 				panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		local_set(&__get_cpu_var(alert_counter), 0);
+		CPU_WRITE(per_cpu_var(alert_counter), 0);
 	}
 
 	/* see if the nmi watchdog went off */

-- 
