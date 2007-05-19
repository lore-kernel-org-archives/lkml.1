Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbXESORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbXESORR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbXESORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 10:17:09 -0400
Received: from www.osadl.org ([213.239.205.134]:45525 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758012AbXESORI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 10:17:08 -0400
Subject: [PATCH] Ignore bogus ACPI info for offline CPUs
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Darren Hart <dvhltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Stable Team <stable@kernel.org>
Content-Type: text/plain
Date: Sat, 19 May 2007 16:22:50 +0200
Message-Id: <1179584570.12981.123.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
hang, because ACPI ignores the maxcpus setting and sends timer broadcast
info for the offline CPUs. This results in a stuck for ever call to
smp_call_function_single() on an offline CPU.

Ignore the bogus information and print a kernel error to remind ACPI
folks to fix it.

Affects 2.6.21 / 2.6.22-rc

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.22-rc/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.22-rc.orig/kernel/time/tick-broadcast.c
+++ linux-2.6.22-rc/kernel/time/tick-broadcast.c
@@ -244,11 +244,18 @@ void tick_broadcast_on_off(unsigned long
 {
 	int cpu = get_cpu();
 
-	if (cpu == *oncpu)
-		tick_do_broadcast_on_off(&reason);
-	else
-		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1, 1);
+	if (!cpu_isset(*oncpu, cpu_online_map)) {
+		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		       "offline CPU #%d\n", *oncpu);
+	} else {
+
+		if (cpu == *oncpu)
+			tick_do_broadcast_on_off(&reason);
+		else
+			smp_call_function_single(*oncpu,
+						 tick_do_broadcast_on_off,
+						 &reason, 1, 1);
+	}
 	put_cpu();
 }
 


