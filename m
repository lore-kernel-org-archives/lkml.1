Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYKEUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYKEUAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbYKET6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbYKET6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:04 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 11/15] x86: disable virtualization on all CPUs if needed, on emergency_restart
Date: Wed,  5 Nov 2008 17:56:54 -0200
Message-Id: <1225915018-6548-12-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On emergency_restart, we may need to use an NMI to disable virtualization
on all CPUs. We do that by using nmi_shootdown_cpus(), but only if a
virt_disable function was set by KVM.

Finding a proper point to hook the nmi_shootdown_cpus() call isn't
trivial, as the non-emergency machine_restart() (that doesn't need the
NMI tricks) uses machine_emergency_restart() directly.

The solution to make this work without adding a new function or argument
to machine_ops was setting a 'reboot_emergency' flag that tells if
native_machine_emergency_restart() needs to do the virt cleanup or not.

[v2: additional source code comments explaining why we do that]

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/reboot.c |   55 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 407106e..3240491 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
+#include <asm/virtext.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/dmi.h>
@@ -42,6 +43,12 @@ int reboot_force;
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
@@ -357,6 +364,40 @@ static inline void kb_wait(void)
 	}
 }
 
+static void disable_virt_nmi(int cpu, struct die_args *args)
+{
+	emergency_virt_disable();
+}
+
+/* Use NMIs as IPIs to tell all CPUs to disable virtualization
+ */
+static void emergency_virt_disable_all(void)
+{
+	/* We need to disable virtualization extensions on all CPUs
+	 * before rebooting, otherwise we risk hanging up the machine,
+	 * because the CPU ignore INIT signals when VMX is enabled.
+	 *
+	 * We can't take any locks and we may be on an inconsistent
+	 * state, so we use NMIs as IPIs to tell the other CPUs to halt.
+	 * 
+	 * For safety, we will try to do this only when we may have
+	 * virtualization enabled.
+	 */
+	if (has_virt_extensions()) {
+		/* Kill the other CPUs */
+		nmi_shootdown_cpus(disable_virt_nmi);
+		/* Disable virt on this CPU */
+		emergency_virt_disable();
+	}
+
+	/* If another CPU call set_virt_disable_func()
+	 * here, we will be lost. Unless we want to add the NMI
+	 * stuff to the reboot path for non-virt users, we will
+	 * have to live with this (unlikely) possibility.
+	 */
+
+}
+
 void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
@@ -365,9 +406,13 @@ static void native_machine_emergency_restart(void)
 {
 	int i;
 
+	if (reboot_emergency)
+		emergency_virt_disable_all();
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
+
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
@@ -456,13 +501,19 @@ void native_machine_shutdown(void)
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
@@ -501,7 +552,7 @@ void machine_shutdown(void)
 
 void machine_emergency_restart(void)
 {
-	machine_ops.emergency_restart();
+	__machine_emergency_restart(1);
 }
 
 void machine_restart(char *cmd)
-- 
1.5.5.GIT

