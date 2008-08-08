Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbYHHGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbYHHGze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYHHGxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:53:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:59870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbYHHGxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="324325045"
Subject: [PATCH -v2 8/8] kexec jump: fix for ftrace
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:49 +0800
Message-Id: <1218178369.22039.81.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace depends on some processor state that we destroyed during kexec
and restored by restore_processor_state(). So save_processor_state()
and restore_processor_state() are moved into machine_kexec() and
ftrace is restored after restore_processor_state().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c |   16 +++++++++++++++-
 kernel/kexec.c                     |    2 --
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/numa.h>
 #include <linux/ftrace.h>
+#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -113,6 +114,7 @@ void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
+	int save_ftrace_enabled;
 	asmlinkage unsigned long
 		(*relocate_kernel_ptr)(unsigned long indirection_page,
 				       unsigned long control_page,
@@ -120,7 +122,12 @@ void machine_kexec(struct kimage *image)
 				       unsigned int has_pae,
 				       unsigned int preserve_context);
 
-	tracer_disable();
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		save_processor_state();
+#endif
+
+	save_ftrace_enabled = ftrace_enabled_save();
 
 	/* Interrupts aren't acceptable while we reboot */
 	raw_local_irq_disable();
@@ -178,6 +185,13 @@ void machine_kexec(struct kimage *image)
 					   (unsigned long)page_list,
 					   image->start, cpu_has_pae,
 					   image->preserve_context);
+
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		restore_processor_state();
+#endif
+
+	ftrace_enabled_restore(save_ftrace_enabled);
 }
 
 void arch_crash_save_vmcoreinfo(void)
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1469,7 +1469,6 @@ int kernel_kexec(void)
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
 			goto Enable_irqs;
-		save_processor_state();
 	} else
 #endif
 	{
@@ -1482,7 +1481,6 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-		restore_processor_state();
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();


