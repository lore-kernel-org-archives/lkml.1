Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbXKPCdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbXKPCdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbXKPCdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:33:01 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50814 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763785AbXKPCc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:32:59 -0500
Message-Id: <473D0170.1060304@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:33:20 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 4/5] Fix the configuration dependencies
References: <473CFE14.3010400@mxs.nes.nec.co.jp>
In-Reply-To: <473CFE14.3010400@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the configuration dependencies in the vmcoreinfo data.

i386's "node_data" is defined in arch/x86/mm/discontig_32.c,
and x86_64's one is defined in arch/x86/mm/numa_64.c.
They depend on CONFIG_NUMA:
  arch/x86/mm/Makefile_32:7
    obj-$(CONFIG_NUMA) += discontig_32.o
  arch/x86/mm/Makefile_64:7
    obj-$(CONFIG_NUMA) += numa_64.o

ia64's "pgdat_list" is defined in arch/ia64/mm/discontig.c,
and it depends on CONFIG_DISCONTIGMEM and CONFIG_SPARSEMEM:
  arch/ia64/mm/Makefile:9-10
    obj-$(CONFIG_DISCONTIGMEM) += discontig.o
    obj-$(CONFIG_SPARSEMEM)    += discontig.o

ia64's "node_memblk" is defined in arch/ia64/mm/numa.c,
and it depends on CONFIG_NUMA:
  arch/ia64/mm/Makefile:8
    obj-$(CONFIG_NUMA)         += numa.o

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-11-14 15:39:06.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-11-14 15:41:41.000000000 +0900
@@ -129,10 +129,11 @@ void machine_kexec(struct kimage *image)
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#if defined(CONFIG_ARCH_DISCONTIGMEM_ENABLE) && defined(CONFIG_NUMA)
+#if defined(CONFIG_DISCONTIGMEM) || defined(CONFIG_SPARSEMEM)
 	VMCOREINFO_SYMBOL(pgdat_list);
 	VMCOREINFO_LENGTH(pgdat_list, MAX_NUMNODES);
-
+#endif
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_memblk);
 	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
 	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
diff -rpuN a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c	2007-11-14 15:39:19.000000000 +0900
+++ b/arch/x86/kernel/machine_kexec_32.c	2007-11-14 15:39:33.000000000 +0900
@@ -151,7 +151,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
diff -rpuN a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:19.000000000 +0900
+++ b/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:33.000000000 +0900
@@ -235,7 +235,7 @@ void arch_crash_save_vmcoreinfo(void)
 {
 	VMCOREINFO_SYMBOL(init_level4_pgt);
 
-#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+#ifdef CONFIG_NUMA
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
_


