Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYCSUQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYCSUQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYCSTjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYCSTiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:55 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 78/79] [PATCH] move apicid mappings to smpboot.c
Date: Wed, 19 Mar 2008 14:26:13 -0300
Message-Id: <12059479243480-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059479201170-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

They are i386 specific (the x86_64 definitions live
elsewhere, and should remain there), so are enclosed around
an ifdef

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   21 +++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   13 -------------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6a7fb13..75637fb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -25,6 +25,27 @@
 #include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 
+/*
+ * FIXME: For x86_64, those are defined in other files. But moving them here,
+ * would make the setup areas dependent on smp, which is a loss. When we
+ * integrate apic between arches, we can probably do a better job, but
+ * right now, they'll stay here -- glommer
+ */
+#ifdef CONFIG_X86_32
+/* which logical CPU number maps to which CPU (physical APIC ID) */
+u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
+			{ [0 ... NR_CPUS-1] = BAD_APICID };
+void *x86_cpu_to_apicid_early_ptr;
+DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+
+u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
+				= { [0 ... NR_CPUS-1] = BAD_APICID };
+void *x86_bios_cpu_apicid_early_ptr;
+DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+#endif
+
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 5469207..3590afe 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -59,19 +59,6 @@
 #include <asm/vmi.h>
 #include <asm/mtrr.h>
 
-/* which logical CPU number maps to which CPU (physical APIC ID) */
-u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
-			{ [0 ... NR_CPUS-1] = BAD_APICID };
-void *x86_cpu_to_apicid_early_ptr;
-DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
-
-u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
-				= { [0 ... NR_CPUS-1] = BAD_APICID };
-void *x86_bios_cpu_apicid_early_ptr;
-DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 u8 apicid_2_node[MAX_APICID];
 
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
-- 
1.5.0.6

