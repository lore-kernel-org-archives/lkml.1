Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbYDCTmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbYDCTmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbYDCTd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:27 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39113
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760707AbYDCTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 26/35] x86: KVM guest: disable clock before rebooting.
Date: Thu,  3 Apr 2008 22:32:41 +0300
Message-Id: <1207251170-5013-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This patch writes 0 (actually, what really matters is that the
LSB is cleared) to the system time msr before shutting down
the machine for kexec.

Without it, we can have a random memory location being written
when the guest comes back

It overrides the functions shutdown, used in the path of kernel_kexec() (sys.c)
and crash_shutdown, used in the path of crash_kexec() (kexec.c)

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/kvmclock.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index b999f5e..ddee040 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+#include <asm/reboot.h>
 
 #define KVM_SCALE 22
 
@@ -143,6 +144,28 @@ static void kvm_setup_secondary_clock(void)
 	setup_secondary_APIC_clock();
 }
 
+/*
+ * After the clock is registered, the host will keep writing to the
+ * registered memory location. If the guest happens to shutdown, this memory
+ * won't be valid. In cases like kexec, in which you install a new kernel, this
+ * means a random memory location will be kept being written. So before any
+ * kind of shutdown from our side, we unregister the clock by writting anything
+ * that does not have the 'enable' bit set in the msr
+ */
+#ifdef CONFIG_KEXEC
+static void kvm_crash_shutdown(struct pt_regs *regs)
+{
+	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	native_machine_crash_shutdown(regs);
+}
+#endif
+
+static void kvm_shutdown(void)
+{
+	native_write_msr_safe(MSR_KVM_SYSTEM_TIME, 0, 0);
+	native_machine_shutdown();
+}
+
 void __init kvmclock_init(void)
 {
 	if (!kvm_para_available())
@@ -155,6 +178,10 @@ void __init kvmclock_init(void)
 		pv_time_ops.set_wallclock = kvm_set_wallclock;
 		pv_time_ops.sched_clock = kvm_clock_read;
 		pv_apic_ops.setup_secondary_clock = kvm_setup_secondary_clock;
+		machine_ops.shutdown  = kvm_shutdown;
+#ifdef CONFIG_KEXEC
+		machine_ops.crash_shutdown  = kvm_crash_shutdown;
+#endif
 		clocksource_register(&kvm_clock);
 	}
 }
-- 
1.5.4.5

