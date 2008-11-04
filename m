Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYKDOyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYKDOyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYKDOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60518 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYKDOxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:36 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 06/16] x86: Move nmi_shootdown_cpus() to reboot.c
Date: Tue,  4 Nov 2008 12:52:34 -0200
Message-Id: <1225810364-8990-7-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now nmi_shootdown_cpus() is ready to be used by non-kdump code also.
Move it to reboot.c.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c  |   73 ------------------------------------------
 arch/x86/kernel/reboot.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 84d6338..d84a852 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -32,12 +32,6 @@
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
-/* This keeps a track of which one is crashing cpu. */
-static int crashing_cpu;
-static nmi_shootdown_cb shootdown_callback;
-
-static atomic_t waiting_for_crash_ipi;
-
 static void kdump_nmi_callback(int cpu, struct die_args *args)
 {
 	struct pt_regs *regs;
@@ -58,73 +52,6 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 	disable_local_APIC();
 }
 
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
-{
-	int cpu;
-
-	if (val != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	cpu = raw_smp_processor_id();
-
-	/* Don't do anything if this handler is invoked on crashing cpu.
-	 * Otherwise, system will completely hang. Crashing cpu can get
-	 * an NMI if system was initially booted with nmi_watchdog parameter.
-	 */
-	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
-	local_irq_disable();
-
-	shootdown_callback(cpu, (struct die_args*)data);
-
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	halt();
-	for (;;)
-		cpu_relax();
-
-	return 1;
-}
-
-static void smp_send_nmi_allbutself(void)
-{
-	send_IPI_allbutself(NMI_VECTOR);
-}
-
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-};
-
-void nmi_shootdown_cpus(nmi_shootdown_cb callback)
-{
-	unsigned long msecs;
-
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
-	crashing_cpu = safe_smp_processor_id();
-
-	shootdown_callback = callback;
-
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	/* Would it be better to replace the trap vector here? */
-	if (register_die_notifier(&crash_nmi_nb))
-		return;		/* return what? */
-	/* Ensure the new callback function is set before sending
-	 * out the NMI
-	 */
-	wmb();
-
-	smp_send_nmi_allbutself();
-
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
-
-	/* Leave the nmi callback set */
-}
-
 static void kdump_nmi_shootdown_cpus(void)
 {
 	nmi_shootdown_cpus(kdump_nmi_callback);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f4c93f1..b65fc86 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -21,6 +21,8 @@
 # include <asm/iommu.h>
 #endif
 
+#include <mach_ipi.h>
+
 /*
  * Power off function, if any
  */
@@ -518,3 +520,80 @@ void machine_crash_shutdown(struct pt_regs *regs)
 	machine_ops.crash_shutdown(regs);
 }
 #endif
+
+
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
+
+/* This keeps a track of which one is crashing cpu. */
+static int crashing_cpu;
+static nmi_shootdown_cb shootdown_callback;
+
+static atomic_t waiting_for_crash_ipi;
+
+static int crash_nmi_callback(struct notifier_block *self,
+			unsigned long val, void *data)
+{
+	int cpu;
+
+	if (val != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	cpu = raw_smp_processor_id();
+
+	/* Don't do anything if this handler is invoked on crashing cpu.
+	 * Otherwise, system will completely hang. Crashing cpu can get
+	 * an NMI if system was initially booted with nmi_watchdog parameter.
+	 */
+	if (cpu == crashing_cpu)
+		return NOTIFY_STOP;
+	local_irq_disable();
+
+	shootdown_callback(cpu, (struct die_args*)data);
+
+	atomic_dec(&waiting_for_crash_ipi);
+	/* Assume hlt works */
+	halt();
+	for (;;)
+		cpu_relax();
+
+	return 1;
+}
+
+static void smp_send_nmi_allbutself(void)
+{
+	send_IPI_allbutself(NMI_VECTOR);
+}
+
+static struct notifier_block crash_nmi_nb = {
+	.notifier_call = crash_nmi_callback,
+};
+
+void nmi_shootdown_cpus(nmi_shootdown_cb callback)
+{
+	unsigned long msecs;
+
+	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	crashing_cpu = safe_smp_processor_id();
+
+	shootdown_callback = callback;
+
+	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	/* Would it be better to replace the trap vector here? */
+	if (register_die_notifier(&crash_nmi_nb))
+		return;		/* return what? */
+	/* Ensure the new callback function is set before sending
+	 * out the NMI
+	 */
+	wmb();
+
+	smp_send_nmi_allbutself();
+
+	msecs = 1000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+		mdelay(1);
+		msecs--;
+	}
+
+	/* Leave the nmi callback set */
+}
+#endif
-- 
1.5.5.GIT

