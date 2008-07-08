Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYGHXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYGHXUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYGHXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:47 -0400
Received: from gw.goop.org ([64.81.55.164]:51212 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 55] xen64: random ifdefs to mask out 32-bit only code
X-Mercurial-Node: 8b08c6cc274c040bb04f9f383736600ce346051f
Message-Id: <8b08c6cc274c040bb04f.1215554799@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1296,6 +1296,7 @@
 
 static void __init xen_reserve_top(void)
 {
+#ifdef CONFIG_X86_32
 	unsigned long top = HYPERVISOR_VIRT_START;
 	struct xen_platform_parameters pp;
 
@@ -1303,6 +1304,7 @@
 		top = pp.virt_start;
 
 	reserve_top_address(-top + 2 * PAGE_SIZE);
+#endif	/* CONFIG_X86_32 */
 }
 
 /* First C function to be called on Xen boot */
@@ -1333,6 +1335,11 @@
 
 	machine_ops = xen_machine_ops;
 
+#ifdef CONFIG_X86_64
+	/* Disable until direct per-cpu data access. */
+	have_vcpu_info_placement = 0;
+#endif
+
 #ifdef CONFIG_SMP
 	smp_ops = xen_smp_ops;
 #endif
@@ -1343,9 +1350,11 @@
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
+#ifdef CONFIG_X86_32
 	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
 	max_pfn_mapped = (init_pg_tables_end + 512*1024) >> PAGE_SHIFT;
+#endif
 
 	init_mm.pgd = pgd; /* use the Xen pagetables to start */
 
@@ -1372,7 +1381,9 @@
 
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
+#ifdef CONFIG_X86_32
 	new_cpu_data.hard_math = 1;
+#endif
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Poke various useful things into boot_params */
@@ -1388,5 +1399,9 @@
 	}
 
 	/* Start the world */
+#ifdef CONFIG_X86_32
 	i386_start_kernel();
+#else
+	x86_64_start_kernel((char *)&boot_params);
+#endif
 }


