Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXKTBYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXKTBYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbXKTBOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36892 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756053AbXKTBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011339.631643143@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:05 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 33/45] x86_64: Use CPU ops for nmi alert counter
Content-Disposition: inline; filename=local_t_nmi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are critical fast paths. Using a segment override instead of an address
calculation is reducing overhead.

Signed-off-by: Christoph LAmeter <clameter@sgi.com>
---
 arch/x86/kernel/nmi_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/nmi_64.c	2007-11-19 15:38:59.522056618 -0800
+++ linux-2.6/arch/x86/kernel/nmi_64.c	2007-11-19 15:40:04.481556226 -0800
@@ -291,7 +291,7 @@ void stop_apic_nmi_watchdog(void *unused
  */
 
 static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(int, alert_counter);
 static DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
@@ -355,13 +355,13 @@ int __kprobes nmi_watchdog_tick(struct p
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5*nmi_hz)
+		CPU_INC(get_cpu_var(alert_counter));
+		if (CPU_READ(get_cpu_var(alert_counter)) == 5*nmi_hz)
 			die_nmi("NMI Watchdog detected LOCKUP on CPU %d\n", regs,
 				panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
-		local_set(&__get_cpu_var(alert_counter), 0);
+		CPU_WRITE(get_cpu_var(alert_counter), 0);
 	}
 
 	/* see if the nmi watchdog went off */

-- 
