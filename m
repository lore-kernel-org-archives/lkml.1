Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZBLMot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZBLMot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbZBLMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:40:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49252 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492AbZBLMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:40:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212139.634236515@firstfloor.org>
In-Reply-To: <20090212139.634236515@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/10] x86: MCE: Disable machine checks on suspend v2
Message-Id: <20090212123932.C11FF3E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:39:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Bug fix

During suspend it is not reliable to process machine check
exceptions, because CPUs disappear but can still get machine check
broadcasts.  Also the system is slightly more likely to 
machine check them, but the handler is typically not a position
to handle them in a meaningfull way.

So disable them during suspend and enable them during resume.

Also make sure they are always disabled on hot-unplugged CPUs.

This new code assumes that suspend always hotunplugs all
non BP CPUs.


v2: Remove the WARN_ONs Thomas objected to.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:20.000000000 +0100
@@ -735,6 +735,29 @@
  * Sysfs support
  */
 
+/*
+ * Disable machine checks on suspend and shutdown. We can't really handle
+ * them later.
+ */
+static int mce_disable(void)
+{
+	int i;
+
+	for (i = 0; i < banks; i++)
+		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	return 0;
+}
+
+static int mce_suspend(struct sys_device *dev, pm_message_t state)
+{
+	return mce_disable();
+}
+
+static int mce_shutdown(struct sys_device *dev)
+{
+	return mce_disable();
+}
+
 /* On resume clear all MCE state. Don't want to see leftovers from the BIOS.
    Only one CPU is active at this time, the others get readded later using
    CPU hotplug. */
@@ -761,6 +784,8 @@
 }
 
 static struct sysdev_class mce_sysclass = {
+	.suspend = mce_suspend,
+	.shutdown = mce_shutdown,
 	.resume = mce_resume,
 	.name = "machinecheck",
 };
