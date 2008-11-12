Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbYKLNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbYKLNgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYKLNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:35:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYKLNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:35:45 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 4/8] x86 kdump: Make kdump_nmi_callback() a function ptr on crash_nmi_callback()
Date: Wed, 12 Nov 2008 11:34:40 -0200
Message-Id: <1226496884-24628-5-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
References: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reboot code will use a different function on crash_nmi_callback().
Adding a function pointer parameter to nmi_shootdown_cpus() for that.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/crash.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 75c468c..f23c2be 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -29,10 +29,13 @@
 
 #include <mach_ipi.h>
 
+typedef void (*nmi_shootdown_cb)(int, struct die_args*);
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
+static nmi_shootdown_cb shootdown_callback;
 
 static atomic_t waiting_for_crash_ipi;
 
@@ -74,7 +77,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 		return NOTIFY_STOP;
 	local_irq_disable();
 
-	kdump_nmi_callback(cpu, (struct die_args *)data);
+	shootdown_callback(cpu, (struct die_args *)data);
 
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -97,13 +100,15 @@ static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
 };
 
-static void nmi_shootdown_cpus(void)
+static void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
 
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = safe_smp_processor_id();
 
+	shootdown_callback = callback;
+
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
 	if (register_die_notifier(&crash_nmi_nb))
@@ -126,7 +131,7 @@ static void nmi_shootdown_cpus(void)
 
 static void kdump_nmi_shootdown_cpus(void)
 {
-	nmi_shootdown_cpus();
+	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
 }
-- 
1.5.5.GIT

