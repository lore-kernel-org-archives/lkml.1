Return-Path: <linux-kernel-owner+w=401wt.eu-S1422860AbXBANPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860AbXBANPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422855AbXBANPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:15:15 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53175 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422862AbXBANPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:15:14 -0500
From: Magnus Damm <magnus@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, Magnus Damm <magnus@valinux.co.jp>
Date: Thu, 01 Feb 2007 22:13:47 +0900
Message-Id: <20070201131347.3807.87075.sendpatchset@localhost>
Subject: [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kexec: Fix CONFIG_SMP=n compilation (ia64)

This patch makes it possible to compile kexec for ia64 without SMP support.

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
---

 Applies on top of 2.6.20-rc7.

 arch/ia64/kernel/crash.c         |   11 +++++++----
 arch/ia64/kernel/machine_kexec.c |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- 0002/arch/ia64/kernel/crash.c
+++ work/arch/ia64/kernel/crash.c	2007-02-01 12:42:38.000000000 +0900
@@ -79,6 +79,7 @@ crash_save_this_cpu()
 	final_note(buf);
 }
 
+#ifdef CONFIG_SMP
 static int
 kdump_wait_cpu_freeze(void)
 {
@@ -91,6 +92,7 @@ kdump_wait_cpu_freeze(void)
 	}
 	return 1;
 }
+#endif
 
 void
 machine_crash_shutdown(struct pt_regs *pt)
@@ -132,11 +134,12 @@ kdump_cpu_freeze(struct unw_frame_info *
 	atomic_inc(&kdump_cpu_freezed);
 	kdump_status[cpuid] = 1;
 	mb();
-	if (cpuid == 0) {
-		for (;;)
-			cpu_relax();
-	} else
+#ifdef CONFIG_HOTPLUG_CPU
+	if (cpuid != 0)
 		ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
+#endif
+	for (;;)
+		cpu_relax();
 }
 
 static int
--- 0002/arch/ia64/kernel/machine_kexec.c
+++ work/arch/ia64/kernel/machine_kexec.c	2007-02-01 12:35:46.000000000 +0900
@@ -70,12 +70,14 @@ void machine_kexec_cleanup(struct kimage
 
 void machine_shutdown(void)
 {
+#ifdef CONFIG_SMP
 	int cpu;
 
 	for_each_online_cpu(cpu) {
 		if (cpu != smp_processor_id())
 			cpu_down(cpu);
 	}
+#endif
 	kexec_disable_iosapic();
 }
