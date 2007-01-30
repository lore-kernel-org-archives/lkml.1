Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXA3OxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXA3OxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXA3OxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:53:25 -0500
Received: from il.qumranet.com ([62.219.232.206]:47529 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965543AbXA3OxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:53:24 -0500
Subject: [PATCH 1/5] hotplug: Allow modules to use the cpu hotplug notifiers
	even if !CONFIG_HOTPLUG_CPU
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:53:16 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com>
In-Reply-To: <45BF5B96.1070007@qumranet.com>
Message-Id: <20070130145316.DC710A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM wants the cpu hotplug notifications, both for cpu hotplug itself, but more
commonly for host suspend/resume.

In order to avoid extensive #ifdefs, provide stubs when CONFIG_CPU_HOTPLUG is
not defined.

In all, we have four cases:

- UP: register and unregister stubbed out
- SMP+hotplug: full register and unregister
- SMP, no hotplug, core: register as __init, unregister stubbed
      (cpus are brought up during core initialization)
- SMP, no hotplug, module: register and unregister stubbed out
      (cpus cannot be brought up during module lifetime)

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -49,10 +49,20 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-extern int register_cpu_notifier(struct notifier_block *nb);
 #ifdef CONFIG_HOTPLUG_CPU
+extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
+
+#ifndef MODULE
+extern int register_cpu_notifier(struct notifier_block *nb);
+#else
+static inline int register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+#endif
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
