Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYLIU2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYLIU2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYLIUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbYLIUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 28/44] x86: disable VMX on all CPUs on reboot
Date: Tue,  9 Dec 2008 22:22:43 +0200
Message-Id: <1228854179-23002-29-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

On emergency_restart, we may need to use an NMI to disable virtualization
on all CPUs. We do that using nmi_shootdown_cpus() if VMX is enabled.

Note: With this patch, we will run the NMI stuff only when the CPU where
emergency_restart() was called has VMX enabled. This should work on most
cases because KVM enables VMX on all CPUs, but we may miss the small
window where KVM is doing that. Also, I don't know if all code using
VMX out there always enable VMX on all CPUs like KVM does. We have two
other alternatives for that:

a) Have an API that all code that enables VMX on any CPU should use
   to tell the kernel core that it is going to enable VMX on the CPUs.
b) Always call nmi_shootdown_cpus() if the CPU supports VMX. This is
   a bit intrusive and more risky, as it would run nmi_shootdown_cpus()
   on emergency_reboot() even on systems where virtualization is never
   enabled.

Finding a proper point to hook the nmi_shootdown_cpus() call isn't
trivial, as the non-emergency machine_restart() (that doesn't need the
NMI tricks) uses machine_emergency_restart() directly.

The solution to make this work without adding a new function or argument
to machine_ops was setting a 'reboot_emergency' flag that tells if
native_machine_emergency_restart() needs to do the virt cleanup or not.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/reboot.c |   62 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0b0d15c..9050491 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
+#include <asm/virtext.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/dmi.h>
@@ -39,6 +40,12 @@ int reboot_force;
 static int reboot_cpu = -1;
 #endif
 
+/* This is set if we need to go through the 'emergency' path.
+ * When machine_emergency_restart() is called, we may be on
+ * an inconsistent state and won't be able to do a clean cleanup
+ */
+static int reboot_emergency;
+
 /* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
@@ -363,6 +370,48 @@ static inline void kb_wait(void)
 	}
 }
 
+static void vmxoff_nmi(int cpu, struct die_args *args)
+{
+	cpu_emergency_vmxoff();
+}
+
+/* Use NMIs as IPIs to tell all CPUs to disable virtualization
+ */
+static void emergency_vmx_disable_all(void)
+{
+	/* Just make sure we won't change CPUs while doing this */
+	local_irq_disable();
+
+	/* We need to disable VMX on all CPUs before rebooting, otherwise
+	 * we risk hanging up the machine, because the CPU ignore INIT
+	 * signals when VMX is enabled.
+	 *
+	 * We can't take any locks and we may be on an inconsistent
+	 * state, so we use NMIs as IPIs to tell the other CPUs to disable
+	 * VMX and halt.
+	 *
+	 * For safety, we will avoid running the nmi_shootdown_cpus()
+	 * stuff unnecessarily, but we don't have a way to check
+	 * if other CPUs have VMX enabled. So we will call it only if the
+	 * CPU we are running on has VMX enabled.
+	 *
+	 * We will miss cases where VMX is not enabled on all CPUs. This
+	 * shouldn't do much harm because KVM always enable VMX on all
+	 * CPUs anyway. But we can miss it on the small window where KVM
+	 * is still enabling VMX.
+	 */
+	if (cpu_has_vmx() && cpu_vmx_enabled()) {
+		/* Disable VMX on this CPU.
+		 */
+		cpu_vmxoff();
+
+		/* Halt and disable VMX on the other CPUs */
+		nmi_shootdown_cpus(vmxoff_nmi);
+
+	}
+}
+
+
 void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
@@ -371,6 +420,9 @@ static void native_machine_emergency_restart(void)
 {
 	int i;
 
+	if (reboot_emergency)
+		emergency_vmx_disable_all();
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
@@ -462,13 +514,19 @@ void native_machine_shutdown(void)
 #endif
 }
 
+static void __machine_emergency_restart(int emergency)
+{
+	reboot_emergency = emergency;
+	machine_ops.emergency_restart();
+}
+
 static void native_machine_restart(char *__unused)
 {
 	printk("machine restart\n");
 
 	if (!reboot_force)
 		machine_shutdown();
-	machine_emergency_restart();
+	__machine_emergency_restart(0);
 }
 
 static void native_machine_halt(void)
@@ -507,7 +565,7 @@ void machine_shutdown(void)
 
 void machine_emergency_restart(void)
 {
-	machine_ops.emergency_restart();
+	__machine_emergency_restart(1);
 }
 
 void machine_restart(char *cmd)
-- 
1.6.0.3

