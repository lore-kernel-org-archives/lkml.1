Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZKQMHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZKQMHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZKQMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:07:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35955 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975AbZKQMHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:07:38 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 4/4] powerpc: Avoid reference to XICS-related functions when CONFIG_XICS is not set
Date: Tue, 17 Nov 2009 12:07:39 +0000
Message-Id: <1258459659-11770-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calls to XICS-related functions is open-coded in a number of places even
when CONFIG_XICS is not set resulting in build failures such as

arch/powerpc/platforms/built-in.o: In function `.pseries_kexec_cpu_down_xics':
kexec.c:(.text+0x15558): undefined reference to `.xics_kexec_teardown_cpu'
arch/powerpc/platforms/built-in.o: In function `.pseries_cpu_disable': hotplug-cpu.c:(.text+0x16104): undefined reference to `.xics_migrate_irqs_away'
arch/powerpc/platforms/built-in.o: In function `.pseries_mach_cpu_die': hotplug-cpu.c:(.text+0x1615c): undefined reference to `.xics_teardown_cpu'
arch/powerpc/platforms/built-in.o: In function `.pseries_xics_init_IRQ': setup.c:(.init.text+0x4590): undefined reference to `.xics_init_IRQ'
make: *** [.tmp_vmlinux1] Error 1

This patch fixes up a number of references such as those described above.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    2 ++
 arch/powerpc/platforms/pseries/kexec.c       |    7 +++++++
 arch/powerpc/platforms/pseries/setup.c       |    7 +++++++
 arch/powerpc/platforms/pseries/xics.h        |    8 +++++++-
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index ebff6d9..a2957d6 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -58,7 +58,9 @@ static void pseries_mach_cpu_die(void)
 {
 	local_irq_disable();
 	idle_task_exit();
+#ifdef CONFIG_XICS
 	xics_teardown_cpu();
+#endif
 	unregister_slb_shadow(hard_smp_processor_id(), __pa(get_slb_shadow()));
 	rtas_stop_self();
 	/* Should never get here... */
diff --git a/arch/powerpc/platforms/pseries/kexec.c b/arch/powerpc/platforms/pseries/kexec.c
index 53cbd53..ab79947 100644
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -51,6 +51,7 @@ void __init setup_kexec_cpu_down_mpic(void)
 	ppc_md.kexec_cpu_down = pseries_kexec_cpu_down_mpic;
 }
 
+#ifdef CONFIG_XICS
 static void pseries_kexec_cpu_down_xics(int crash_shutdown, int secondary)
 {
 	pseries_kexec_cpu_down(crash_shutdown, secondary);
@@ -61,6 +62,12 @@ void __init setup_kexec_cpu_down_xics(void)
 {
 	ppc_md.kexec_cpu_down = pseries_kexec_cpu_down_xics;
 }
+#else
+void __init setup_kexec_cpu_down_xics(void)
+{
+	BUG();
+}
+#endif
 
 static int __init pseries_kexec_setup(void)
 {
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index ca5f2e1..a925fbb 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -210,11 +210,18 @@ static void __init pseries_mpic_init_IRQ(void)
 	pseries_setup_i8259_cascade();
 }
 
+#ifdef CONFIG_XICS
 static void __init pseries_xics_init_IRQ(void)
 {
 	xics_init_IRQ();
 	pseries_setup_i8259_cascade();
 }
+#else
+static void __init pseries_xics_init_IRQ(void)
+{
+	BUG();
+}
+#endif
 
 static void pseries_lpar_enable_pmcs(void)
 {
diff --git a/arch/powerpc/platforms/pseries/xics.h b/arch/powerpc/platforms/pseries/xics.h
index d1d5a83..d0a618d 100644
--- a/arch/powerpc/platforms/pseries/xics.h
+++ b/arch/powerpc/platforms/pseries/xics.h
@@ -16,8 +16,14 @@ extern void xics_init_IRQ(void);
 extern void xics_setup_cpu(void);
 extern void xics_teardown_cpu(void);
 extern void xics_kexec_teardown_cpu(int secondary);
-extern void xics_migrate_irqs_away(void);
 extern int smp_xics_probe(void);
 extern void smp_xics_message_pass(int target, int msg);
+#ifdef CONFIG_XICS
+extern void xics_migrate_irqs_away(void);
+#else
+static inline void xics_migrate_irqs_away(void)
+{
+	BUG();
+}
 
 #endif /* _POWERPC_KERNEL_XICS_H */
-- 
1.6.5

