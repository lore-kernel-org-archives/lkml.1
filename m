Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbYDCTnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbYDCTnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760743AbYDCTd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:28 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39112
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 24/35] x86: allow machine_crash_shutdown to be replaced
Date: Thu,  3 Apr 2008 22:32:39 +0300
Message-Id: <1207251170-5013-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This patch a llows machine_crash_shutdown to
be replaced, just like any of the other functions
in machine_ops

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/crash.c  |    3 ++-
 arch/x86/kernel/reboot.c |   11 ++++++++++-
 include/asm-x86/reboot.h |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 9a5fa0a..d262306 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -25,6 +25,7 @@
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/smp.h>
+#include <asm/reboot.h>
 
 #ifdef CONFIG_X86_32
 #include <mach_ipi.h>
@@ -121,7 +122,7 @@ static void nmi_shootdown_cpus(void)
 }
 #endif
 
-void machine_crash_shutdown(struct pt_regs *regs)
+void native_machine_crash_shutdown(struct pt_regs *regs)
 {
 	/* This function is only called after the system
 	 * has panicked or is otherwise in a critical state.
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 484c4a8..708d6f8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -471,7 +471,10 @@ struct machine_ops machine_ops = {
 	.shutdown = native_machine_shutdown,
 	.emergency_restart = native_machine_emergency_restart,
 	.restart = native_machine_restart,
-	.halt = native_machine_halt
+	.halt = native_machine_halt,
+#ifdef CONFIG_KEXEC
+	.crash_shutdown = native_machine_crash_shutdown,
+#endif
 };
 
 void machine_power_off(void)
@@ -499,3 +502,9 @@ void machine_halt(void)
 	machine_ops.halt();
 }
 
+#ifdef CONFIG_KEXEC
+void machine_crash_shutdown(struct pt_regs *regs)
+{
+	machine_ops.crash_shutdown(regs);
+}
+#endif
diff --git a/include/asm-x86/reboot.h b/include/asm-x86/reboot.h
index e9e3ffc..ff9b546 100644
--- a/include/asm-x86/reboot.h
+++ b/include/asm-x86/reboot.h
@@ -16,5 +16,6 @@ struct machine_ops
 extern struct machine_ops machine_ops;
 
 void machine_real_restart(unsigned char *code, int length);
+void native_machine_crash_shutdown(struct pt_regs *regs);
 
 #endif	/* _ASM_REBOOT_H */
-- 
1.5.4.5

