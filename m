Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZJWXqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZJWXqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZJWXqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:46:01 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41928 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbZJWXqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:46:01 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 19:46:01 EDT
Message-Id: <20091023233747.905291000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:45 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] SGI x86_64 UV: Limit the number of processor bootup messages
Content-Disposition: inline; filename=limit_boot_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of processor bootup messages when
system_state == SYSTEM_BOOTING.  Limit the number of
offline messages when system is shutting down.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
Example output...

Before:

[   36.305264] Booting processor 1/2 ip 6000
..
[   36.420549] Booting processor 2/4 ip 6000
..
[  101.352770] Booting processor 383/759 ip 6000
..
[  101.524209] Brought up 384 CPUs
[  101.528277] Total of 384 processors activated (1741075.97 BogoMIPS).

After:

[   36.189152] Booting processor 1/2 ip 6000
..
[   36.304541] Booting processor 2/4 ip 6000
..
[   36.464533] printk: further related messages suppressed
[   76.536185] Brought up 384 CPUs
[   76.539894] Total of 384 processors activated (1741015.43 BogoMIPS).
---
 arch/x86/kernel/smpboot.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/smpboot.c
+++ linux/arch/x86/kernel/smpboot.c
@@ -741,6 +741,9 @@
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
 
+	if (cpu > 2 && system_state == SYSTEM_BOOTING)
+		limit_console_output(true);
+
 	/* So we see what's up   */
 	printk(KERN_INFO "Booting processor %d APIC 0x%x ip 0x%lx\n",
 			  cpu, apicid, start_ip);
@@ -838,6 +841,9 @@
 		smpboot_restore_warm_reset_vector();
 	}
 
+	if (cpu > 2 && system_state == SYSTEM_BOOTING)
+		end_limit_console_output();
+
 	return boot_error;
 }
 
@@ -1308,7 +1314,10 @@
 	for (i = 0; i < 10; i++) {
 		/* They ack this in play_dead by setting CPU_DEAD */
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk(KERN_INFO "CPU %d is now offline\n", cpu);
+			if (cpu < 4 || system_state == SYSTEM_RUNNING ||
+					!limit_console_output(false))
+				printk(KERN_INFO
+					"CPU %d is now offline\n", cpu);
 			if (1 == num_online_cpus())
 				alternatives_smp_switch(0);
 			return;

-- 
