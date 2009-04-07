Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbZDGPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbZDGPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZDGPIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbZDGPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:09 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [22/28] x86: MCE: Default to panic timeout for machine checks
Message-Id: <20090407150805.588AA1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fatal machine checks can be logged to disk after boot, but only if
the system did a warm reboot. That's unfortunately difficult with the
default panic behaviour, which waits forever and the admin has to
press the power button because modern systems usually miss a reset button.
This clears the machine checks in the registers and make
it impossible to log them.

This patch changes the default for machine check panic to always
reboot after 30s. Then the mce can be successfully logged after
reboot.

I believe this will improve machine check experience for any 
system running the X server.

This is dependent on successfull boot logging of MCEs. This currently
only works on Intel systems, on AMD there are quite a lot of systems
around which leave junk in the machine check registers after boot,
so it's disabled here. These systems will continue to default
to endless waiting panic.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:10.000000000 +0200
@@ -64,6 +64,7 @@
 static int rip_msr;
 static int mce_bootlog = -1;
 static int monarch_timeout = -1;
+static int mce_panic_timeout;
 
 static char trigger[128];
 static char *trigger_argv[2] = { trigger, NULL };
@@ -171,6 +172,7 @@
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
+	panic_timeout = mce_panic_timeout;
 	panic("Panicing machine check CPU died");
 }
 
@@ -208,6 +210,7 @@
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
+ 	panic_timeout = mce_panic_timeout;
 	panic(msg);
 }
 
@@ -993,6 +996,8 @@
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
+	if (mce_bootlog != 0)
+		mce_panic_timeout = 30;
 }
 
 static void mce_cpu_features(struct cpuinfo_x86 *c)
