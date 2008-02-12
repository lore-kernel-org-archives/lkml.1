Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbYBLX4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbYBLX4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBLX4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:56:40 -0500
Received: from zeus.pimb.org ([80.68.88.21]:1441 "EHLO zeus.pimb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYBLX4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:56:39 -0500
Date: Tue, 12 Feb 2008 23:37:48 +0000
From: Jody Belka <lists-lkml@pimb.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Miguel Boton <mboton@gmail.com>
Subject: [PATCH] x86: fixup machine_ops reboot_{32|64}.c unification fallout
Message-ID: <20080212233748.GX7980@pimb.org>
Reply-To: Jody Belka <lists-lkml@pimb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc on any replies, thanks.
---
When reboot_32.c and reboot_64.c were unified (commit 4d022e35fd...),
the machine_ops code was broken, leading to xen pvops kernels failing
to properly halt/poweroff/reboot etc. This fixes that up.

Signed-off-by: Jody Belka <knew-linux@pimb.org>
---
 arch/x86/kernel/reboot.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5818dc2..7fd6ac4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,7 +326,7 @@ static inline void kb_wait(void)
 	}
 }
 
-void machine_emergency_restart(void)
+static void native_machine_emergency_restart(void)
 {
 	int i;
 
@@ -376,7 +376,7 @@ void machine_emergency_restart(void)
 	}
 }
 
-void machine_shutdown(void)
+static void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
@@ -420,7 +420,7 @@ void machine_shutdown(void)
 #endif
 }
 
-void machine_restart(char *__unused)
+static void native_machine_restart(char *__unused)
 {
 	printk("machine restart\n");
 
@@ -429,11 +429,11 @@ void machine_restart(char *__unused)
 	machine_emergency_restart();
 }
 
-void machine_halt(void)
+static void native_machine_halt(void)
 {
 }
 
-void machine_power_off(void)
+static void native_machine_power_off(void)
 {
 	if (pm_power_off) {
 		if (!reboot_force)
@@ -443,9 +443,35 @@ void machine_power_off(void)
 }
 
 struct machine_ops machine_ops = {
-	.power_off = machine_power_off,
-	.shutdown = machine_shutdown,
-	.emergency_restart = machine_emergency_restart,
-	.restart = machine_restart,
-	.halt = machine_halt
+	.power_off = native_machine_power_off,
+	.shutdown = native_machine_shutdown,
+	.emergency_restart = native_machine_emergency_restart,
+	.restart = native_machine_restart,
+	.halt = native_machine_halt
 };
+
+void machine_power_off(void)
+{
+	machine_ops.power_off();
+}
+
+void machine_shutdown(void)
+{
+	machine_ops.shutdown();
+}
+
+void machine_emergency_restart(void)
+{
+	machine_ops.emergency_restart();
+}
+
+void machine_restart(char *cmd)
+{
+	machine_ops.restart(cmd);
+}
+
+void machine_halt(void)
+{
+	machine_ops.halt();
+}
+
-- 
1.5.2.5


