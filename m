Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbZEARLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbZEARLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbZEARK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:43330 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762306AbZEARKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:24 -0400
Date: Fri, 1 May 2009 17:07:37 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F6557E.3080101@kernel.org>
References: <49F6557E.3080101@kernel.org>
Subject: [tip:irq/numa] irq: change io_apic_set_pci_routing() to use device parameter
Message-ID: <tip-024154cfdd802654cb236a18c78b6e37351e2c49@git.kernel.org>
Git-Commit-ID: 024154cfdd802654cb236a18c78b6e37351e2c49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:07:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  024154cfdd802654cb236a18c78b6e37351e2c49
Gitweb:     http://git.kernel.org/tip/024154cfdd802654cb236a18c78b6e37351e2c49
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 18:01:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:18 +0200

irq: change io_apic_set_pci_routing() to use device parameter

Make actual use of the device parameter passed down to
io_apic_set_pci_routing() - to have the IRQ descriptor
on the home node of the device.

If no device has been passed down, we assume it's a platform
device and use the boot node ID for the IRQ descriptor.

[ Impact: optimization, make IO-APIC code more NUMA aware ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F6557E.3080101@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d934662..82376e0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3963,7 +3963,7 @@ int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node;
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3971,6 +3971,11 @@ int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 		return -EINVAL;
 	}
 
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
