Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYKDOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYKDOyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYKDOxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYKDOxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:37 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 01/16] x86 kdump: Extract kdump-specific code from crash_nmi_callback()
Date: Tue,  4 Nov 2008 12:52:29 -0200
Message-Id: <1225810364-8990-2-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NMI CPU-halting code will be used on non-kdump cases, also
(e.g. emergency_reboot when virtualization is enabled).

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 81e01f7..e8c58aa 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -35,19 +35,34 @@ static int crashing_cpu;
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 static atomic_t waiting_for_crash_ipi;
 
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
+static void kdump_nmi_callback(int cpu, struct die_args *args)
 {
 	struct pt_regs *regs;
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
+
+	regs = args->regs;
+
+#ifdef CONFIG_X86_32
+	if (!user_mode_vm(regs)) {
+		crash_fixup_ss_esp(&fixed_regs, regs);
+		regs = &fixed_regs;
+	}
+#endif
+	crash_save_cpu(regs, cpu);
+
+	disable_local_APIC();
+}
+
+static int crash_nmi_callback(struct notifier_block *self,
+			unsigned long val, void *data)
+{
 	int cpu;
 
 	if (val != DIE_NMI_IPI)
 		return NOTIFY_OK;
 
-	regs = ((struct die_args *)data)->regs;
 	cpu = raw_smp_processor_id();
 
 	/* Don't do anything if this handler is invoked on crashing cpu.
@@ -58,14 +73,8 @@ static int crash_nmi_callback(struct notifier_block *self,
 		return NOTIFY_STOP;
 	local_irq_disable();
 
-#ifdef CONFIG_X86_32
-	if (!user_mode_vm(regs)) {
-		crash_fixup_ss_esp(&fixed_regs, regs);
-		regs = &fixed_regs;
-	}
-#endif
-	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
+	kdump_nmi_callback(cpu, (struct die_args*)data);
+
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
 	halt();
-- 
1.5.5.GIT

