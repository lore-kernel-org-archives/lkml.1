Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYKEUB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYKEUB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbYKET6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822AbYKET6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:08 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 10/15] kdump: Hook emergency_virt_disable() on crash shutdown code
Date: Wed,  5 Nov 2008 17:56:53 -0200
Message-Id: <1225915018-6548-11-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v2: add comments on source code, explaining why it is needed]

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index d84a852..040f3ca 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 #include <asm/reboot.h>
+#include <asm/virtext.h>
 
 #include <mach_ipi.h>
 
@@ -49,6 +50,11 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 #endif
 	crash_save_cpu(regs, cpu);
 
+	/* We need to disable virtualization on all CPUs.
+	 * Having VMX or SVM enabled on any CPU may break rebooting
+	 * after the kdump kernel has finished its task.
+	 */
+	emergency_virt_disable();
 	disable_local_APIC();
 }
 
@@ -80,6 +86,13 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	local_irq_disable();
 
 	kdump_nmi_shootdown_cpus();
+
+	/* Booting kdump kernel with VMX or SVM enabled won't work,
+	 * because (among other limitations) we can't disable paging
+	 * with the virt flags.
+	 */
+	emergency_virt_disable();
+
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
-- 
1.5.5.GIT

