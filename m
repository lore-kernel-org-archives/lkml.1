Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZLOEMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZLOEMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbZLOEMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:12:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZLOEHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:03 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 05/20] Fix AMD C1 TSC desynchronization
Date: Mon, 14 Dec 2009 18:08:32 -1000
Message-Id: <1260850127-9766-6-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-5-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD based machines can have TSC drift when in C1 HLT state because
despite attempting to scale the TSC increment when dividing down the
P-state, the processor may return to full P-state to service cache
probes.  This causes unpredictable TSC drift on these machines.
We implement a recommended workaround, which is disabling C1 clock
ramping.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a599c78..4c4d2e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -43,6 +43,12 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+#ifdef CONFIG_K8_NB
+#include <linux/pci.h>
+#include <asm/k8.h>
+#include <asm/smp.h>
+#endif
+
 #include <asm/uaccess.h>
 #include <asm/msr.h>
 #include <asm/desc.h>
@@ -3548,10 +3554,42 @@ static struct notifier_block kvm_x86_cpu_notifier = {
 	.priority = -INT_MAX, /* we want to be called last */
 };
 
+static u8 disabled_c1_ramp = 0;
+
 static void kvm_timer_init(void)
 {
 	int cpu;
 
+	/*
+	 * AMD processors can de-synchronize TSC on halt in C1 state, because
+	 * processors in lower P state will have TSC scaled properly during
+	 * normal operation, but will have TSC scaled improperly while
+	 * servicing cache probes.  Because there is no way to determine how
+	 * TSC was adjusted during cache probes, there are two solutions:
+	 * resynchronize after halt, or disable C1-clock ramping.
+	 *
+	 * We implemenent solution 2.
+	 */
+#ifdef CONFIG_K8_NB
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    boot_cpu_data.x86 == 0x0f &&
+	    !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		struct pci_dev *nb;
+		int i;
+		cache_k8_northbridges();
+		for (i = 0; i < num_k8_northbridges; i++) {
+			u8 byte;
+			nb = k8_northbridges[i];
+			pci_read_config_byte(nb, 0x87, &byte);
+			if (byte & 1) {
+				printk(KERN_INFO "%s: AMD C1 clock ramping detected, performing workaround\n", __func__);
+				disabled_c1_ramp = byte;
+				pci_write_config_byte(nb, 0x87, byte & 0xFC);
+
+			}
+		}
+	}
+#endif
 	register_cpu_notifier(&kvm_x86_cpu_notifier);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
@@ -3627,6 +3665,13 @@ void kvm_arch_exit(void)
 	unregister_cpu_notifier(&kvm_x86_cpu_notifier);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
+#ifdef CONFIG_K8_NB
+	if (disabled_c1_ramp) {
+		struct pci_dev **nb;
+		for (nb = k8_northbridges; *nb; nb++)
+			pci_write_config_byte(*nb, 0x87, disabled_c1_ramp);
+	}
+#endif
 }
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
-- 
1.6.5.2

