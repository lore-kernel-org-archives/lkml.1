Return-Path: <linux-kernel-owner+w=401wt.eu-S1030268AbXFHH7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbXFHH7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938433AbXFHHZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55395 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938424AbXFHHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:43 -0400
Message-Id: <20070608072147.243526000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/54] Ignore bogus ACPI info for offline CPUs
Content-Disposition: inline; filename=ignore-bogus-acpi-info-for-offline-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
hang, because ACPI ignores the maxcpus setting and sends timer broadcast
info for the offline CPUs. This results in a stuck for ever call to
smp_call_function_single() on an offline CPU.

Ignore the bogus information and print a kernel error to remind ACPI
folks to fix it.

Affects 2.6.21 / 2.6.22-rc

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- linux-2.6.21.4.orig/kernel/time/tick-broadcast.c
+++ linux-2.6.21.4/kernel/time/tick-broadcast.c
@@ -243,11 +243,18 @@ void tick_broadcast_on_off(unsigned long
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
 

-- 
