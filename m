Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYKQVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYKQVIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYKQVEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYKQVEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:41 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 11/12] kdump: forcibly disable VMX and SVM on machine_crash_shutdown()
Date: Mon, 17 Nov 2008 19:03:23 -0200
Message-Id: <1226955804-16802-12-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to disable virtualization extensions on all CPUs before booting
the kdump kernel, otherwise the kdump kernel booting will fail, and
rebooting after the kdump kernel did its task may also fail.

We do it using cpu_emergency_vmxoff() and cpu_emergency_svm_disable(),
that should always work, because those functions check if the CPUs
support SVM or VMX before doing their tasks.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
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
1.5.5.GIT

