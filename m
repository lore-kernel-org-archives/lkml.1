Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZA2VhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZA2VhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZA2Vgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:36:41 -0500
Received: from gw.goop.org ([64.81.55.164]:59819 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbZA2Vgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:36:39 -0500
Message-ID: <49822166.7030401@goop.org>
Date: Thu, 29 Jan 2009 13:36:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: split loading percpu segments from loading gdt
References: <49818842.5020004@goop.org> <1233236625-17928-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1233236625-17928-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen needs to be able to access percpu data from very early on.  For
various reasons, it cannot also load the gdt at that time.   It does,
however, have a pefectly functional gdt at that point, so there's no
pressing need to reload the gdt.

Split the function to load the segment registers off, so Xen can call
it directly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

===================================================================
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -769,6 +769,7 @@
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(int);
+extern void load_percpu_segment(int);
 extern void cpu_init(void);
 
 static inline unsigned long get_debugctlmsr(void)
===================================================================
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -297,6 +297,16 @@
 
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
+void load_percpu_segment(int cpu)
+{
+#ifdef CONFIG_X86_32
+	loadsegment(fs, __KERNEL_PERCPU);
+#else
+	loadsegment(gs, 0);
+	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
+#endif
+}
+
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
 void switch_to_new_gdt(int cpu)
@@ -307,12 +317,8 @@
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 	/* Reload the per-cpu base */
-#ifdef CONFIG_X86_32
-	loadsegment(fs, __KERNEL_PERCPU);
-#else
-	loadsegment(gs, 0);
-	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
-#endif
+
+	load_percpu_segment(cpu);
 }
 
 static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};


