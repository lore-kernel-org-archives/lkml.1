Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZKNMn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZKNMn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 07:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZKNMn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 07:43:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:40341 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751417AbZKNMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 07:43:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18SK1o7Y60St2sp9OL9JDw2rM6eb7NovymjUIJOPm
	9DE7VXAhicbfwp
Subject: [patch] cpu_early_init() breakage
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Nov 2009 13:43:22 +0100
Message-Id: <1258202602.6380.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0388423 typo caused loss of vendor data even with CONFIG_PROCESSOR_SELECT.

[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.044003] MCE: unknown CPU type - not enabling MCE support.
...
[    0.437241] Brought up 4 CPUs
[    0.440002] Total of 4 processors activated (19139.97 BogoMIPS).
[    0.448021] CPU0 attaching sched-domain:
[    0.448024]  domain 0: span 0-3 level MC
[    0.448026]   groups: 0 1 2 3
[    0.448031] CPU1 attaching sched-domain:
[    0.448033]  domain 0: span 0-3 level MC
[    0.448035]   groups: 1 2 3 0
[    0.448039] CPU2 attaching sched-domain:
[    0.448041]  domain 0: span 0-3 level MC
[    0.448043]   groups: 2 3 0 1
[    0.448047] CPU3 attaching sched-domain:
[    0.448048]  domain 0: span 0-3 level MC
[    0.448050]   groups: 3 0 1 2

x86: Fix typo in 0388423 "Minimise printk spew from per-vendor init code"

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>
LKML-Reference: <new-submission>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 973080b..3c7f7fd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -651,11 +651,12 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 void __init early_cpu_init(void)
 {
-#ifdef PROCESSOR_SELECT
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
+#ifdef CONFIG_PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
+#endif
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
 		unsigned int j;
@@ -668,11 +669,12 @@ void __init early_cpu_init(void)
 		for (j = 0; j < 2; j++) {
 			if (!cpudev->c_ident[j])
 				continue;
+#ifdef CONFIG_PROCESSOR_SELECT
 			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
 				cpudev->c_ident[j]);
+#endif
 		}
 	}
-#endif
 	early_identify_cpu(&boot_cpu_data);
 }
 


