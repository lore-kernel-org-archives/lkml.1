Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYKLNin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYKLNin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKLNgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:36:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYKLNfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:35:53 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 2/8] x86 kdump: Move crashing_cpu assignment to nmi_shootdown_cpus()
Date: Wed, 12 Nov 2008 11:34:38 -0200
Message-Id: <1226496884-24628-3-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
References: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable will be moved to non-kdump-specific code.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 6047542..ed2f0f9 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -29,10 +29,11 @@
 
 #include <mach_ipi.h>
 
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
+
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 static atomic_t waiting_for_crash_ipi;
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -100,6 +101,9 @@ static void nmi_shootdown_cpus(void)
 {
 	unsigned long msecs;
 
+	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	crashing_cpu = safe_smp_processor_id();
+
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
 	if (register_die_notifier(&crash_nmi_nb))
@@ -140,8 +144,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
 
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
-	crashing_cpu = safe_smp_processor_id();
 	nmi_shootdown_cpus();
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
-- 
1.5.5.GIT

