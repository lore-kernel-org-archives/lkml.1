Return-Path: <linux-kernel-owner+w=401wt.eu-S1764783AbYCSUMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764783AbYCSUMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbYCSTiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbYCSTif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:35 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 77/79] [PATCH] merge cpu_exit_clear
Date: Wed, 19 Mar 2008 14:26:12 -0300
Message-Id: <12059479201170-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059479154173-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

this is the last remaining function in smpboot_32.c
Since it is i386 specific, move it around an ifdef to
smpboot.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   18 ++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   19 -------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 45119d3..6a7fb13 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1207,6 +1207,24 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+#  ifdef CONFIG_X86_32
+void cpu_exit_clear(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	idle_task_exit();
+
+	cpu_uninit();
+	irq_ctx_exit(cpu);
+
+	cpu_clear(cpu, cpu_callout_map);
+	cpu_clear(cpu, cpu_callin_map);
+
+	unmap_cpu_to_logical_apicid(cpu);
+}
+#  endif /* CONFIG_X86_32 */
+
 void remove_siblinginfo(int cpu)
 {
 	int sibling;
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 3a1b9e4..5469207 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -74,25 +74,6 @@ EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-extern void unmap_cpu_to_logical_apicid(int cpu);
-
-#ifdef CONFIG_HOTPLUG_CPU
-void cpu_exit_clear(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	cpu_uninit();
-	irq_ctx_exit(cpu);
-
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	unmap_cpu_to_logical_apicid(cpu);
-}
-#endif
-
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
 void *xquad_portio;
 #ifdef CONFIG_X86_NUMAQ
-- 
1.5.0.6

