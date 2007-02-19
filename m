Return-Path: <linux-kernel-owner+w=401wt.eu-S1750834AbXBSKWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbXBSKWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXBSKWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:22:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:58903 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbXBSKWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:22:52 -0500
Subject: [PATCH 2/13] KVM: Move virtualization deactivation from CPU_DEAD
	state to CPU_DOWN_PREPARE
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:22:51 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102251.A2C7525016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Katz <katzj@redhat.com>

This gives it more chances of surviving suspend.

Signed-off-by: Jeremy Katz <katzj@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -2080,13 +2080,17 @@ static int kvm_cpu_hotplug(struct notifi
 	int cpu = (long)v;
 
 	switch (val) {
-	case CPU_DEAD:
+	case CPU_DOWN_PREPARE:
 	case CPU_UP_CANCELED:
+		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
+		       cpu);
 		decache_vcpus_on_cpu(cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
 					 NULL, 0, 1);
 		break;
-	case CPU_UP_PREPARE:
+	case CPU_ONLINE:
+		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
+		       cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
 					 NULL, 0, 1);
 		break;
