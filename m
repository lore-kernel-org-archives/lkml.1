Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYKJWR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYKJWR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKJWRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:17:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51899 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479AbYKJWRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:17:50 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: redundant creation of sgi_uv
Cc: mingo@elte.hu
Message-Id: <E1Kzf3f-0008FR-Nh@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 10 Nov 2008 16:16:31 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

There is a collision between two UV functions:
  both uv_ptc_init() and gru_proc_init() try to make /proc/sgi_uv

So move it's creation to a single place: uv_system_init()

Diffed against 2.6.28-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 ++
 arch/x86/kernel/tlb_uv.c         |    4 ----
 drivers/misc/sgi-gru/gruprocfs.c |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux/arch/x86/kernel/genx2apic_uv_x.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/timer.h>
+#include <linux/proc_fs.h>
 #include <asm/current.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
@@ -569,4 +570,5 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -566,14 +566,10 @@ static int __init uv_ptc_init(void)
 	if (!is_uv_system())
 		return 0;
 
-	if (!proc_mkdir("sgi_uv", NULL))
-		return -EINVAL;
-
 	proc_uv_ptc = create_proc_entry(UV_PTC_BASENAME, 0444, NULL);
 	if (!proc_uv_ptc) {
 		printk(KERN_ERR "unable to create %s proc entry\n",
 		       UV_PTC_BASENAME);
-		remove_proc_entry("sgi_uv", NULL);
 		return -EINVAL;
 	}
 	proc_uv_ptc->proc_fops = &proc_uv_ptc_operations;
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c
+++ linux/drivers/misc/sgi-gru/gruprocfs.c
@@ -317,7 +317,6 @@ int gru_proc_init(void)
 {
 	struct proc_entry *p;
 
-	proc_mkdir("sgi_uv", NULL);
 	proc_gru = proc_mkdir("sgi_uv/gru", NULL);
 
 	for (p = proc_files; p->name; p++)
