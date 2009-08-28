Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZH1TQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZH1TQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZH1TQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:16:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:42835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZH1TQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:16:47 -0400
Date: Fri, 28 Aug 2009 19:16:25 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, johnstul@us.ibm.com, shemminger@vyatta.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, akpm@linux-foundation.org, shemminger@vyatta.com,
       tglx@linutronix.de
In-Reply-To: <1250552447.7212.92.camel@localhost.localdomain>
References: <1250552447.7212.92.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/tsc] x86: Make tsc=reliable override boot time stability checks
Message-ID: <tip-d3b8f889a220aed825accc28eb64ce283a0d51ac@git.kernel.org>
Git-Commit-ID: d3b8f889a220aed825accc28eb64ce283a0d51ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 19:16:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3b8f889a220aed825accc28eb64ce283a0d51ac
Gitweb:     http://git.kernel.org/tip/d3b8f889a220aed825accc28eb64ce283a0d51ac
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Mon, 17 Aug 2009 16:40:47 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Aug 2009 21:13:05 +0200

x86: Make tsc=reliable override boot time stability checks

This patch makes the tsc=reliable option disable the boot time
stability checks. Currently the option only disables the runtime
watchdog checks. This change allows folks who want to override the
boot time TSC stability checks and use the TSC when the system would
otherwise disqualify it.

There still are some situations that the TSC will be disqualified,
such as cpufreq scaling. But these are situations where the box will
hang if allowed.

Patch also includes a fix for an issue found by Thomas Gleixner, where
the TSC disqualification message wouldn't be printed after a call to
unsynchronized_tsc().

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: akataria@vmware.com
Cc: Stephen Hemminger <shemminger@vyatta.com>
LKML-Reference: <1250552447.7212.92.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 Documentation/kernel-parameters.txt |    9 +++++----
 arch/x86/kernel/tsc.c               |    7 +++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7936b80..4c6b415 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2484,12 +2484,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
 
-	tsc=		Disable clocksource-must-verify flag for TSC.
+	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
-			disables clocksource verification at runtime.
-			Used to enable high-resolution timer mode on older
-			hardware, and in virtualized environment.
+			disables clocksource verification at runtime, as well
+			as the stability checks done at bootup.	Used to enable
+			high-resolution timer mode on older hardware, and in
+			virtualized environment.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..648fb26 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -825,6 +825,9 @@ __cpuinit int unsynchronized_tsc(void)
 
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return 0;
+
+	if (tsc_clocksource_reliable)
+		return 0;
 	/*
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
@@ -832,10 +835,10 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}
 
-	return tsc_unstable;
+	return 0;
 }
 
 static void __init init_tsc_clocksource(void)
