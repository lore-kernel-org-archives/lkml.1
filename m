Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYLIUjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYLIUjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYLIUYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34862 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 27/44] kdump: forcibly disable VMX and SVM on machine_crash_shutdown()
Date: Tue,  9 Dec 2008 22:22:42 +0200
Message-Id: <1228854179-23002-28-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

We need to disable virtualization extensions on all CPUs before booting
the kdump kernel, otherwise the kdump kernel booting will fail, and
rebooting after the kdump kernel did its task may also fail.

We do it using cpu_emergency_vmxoff() and cpu_emergency_svm_disable(),
that should always work, because those functions check if the CPUs
support SVM or VMX before doing their tasks.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/crash.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index d84a852..c689d19 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 #include <asm/reboot.h>
+#include <asm/virtext.h>
 
 #include <mach_ipi.h>
 
@@ -49,6 +50,15 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 #endif
 	crash_save_cpu(regs, cpu);
 
+	/* Disable VMX or SVM if needed.
+	 *
+	 * We need to disable virtualization on all CPUs.
+	 * Having VMX or SVM enabled on any CPU may break rebooting
+	 * after the kdump kernel has finished its task.
+	 */
+	cpu_emergency_vmxoff();
+	cpu_emergency_svm_disable();
+
 	disable_local_APIC();
 }
 
@@ -80,6 +90,14 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	local_irq_disable();
 
 	kdump_nmi_shootdown_cpus();
+
+	/* Booting kdump kernel with VMX or SVM enabled won't work,
+	 * because (among other limitations) we can't disable paging
+	 * with the virt flags.
+	 */
+	cpu_emergency_vmxoff();
+	cpu_emergency_svm_disable();
+
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
-- 
1.6.0.3

