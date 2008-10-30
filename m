Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYJ3VJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYJ3VJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYJ3VJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:09:42 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42379 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555AbYJ3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:09:41 -0400
Subject: [PATCH] fix smp generic helper voyager breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:09:39 -0500
Message-Id: <1225400980.19324.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c3029f2bac04e387a1eb6aa2967310d61e9f2561 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 14:53:06 -0500
Subject: [VOYAGER] fix generic smp helpers non compile

commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Thu Jun 26 11:21:34 2008 +0200

    Add generic helpers for arch IPI function calls

didn't wire up the voyager smp call function correctly, so do that
here.  Also make CONFIG_USE_GENERIC_SMP_HELPERS a def_bool y again,
since we now use the generic helpers for every x86 architecture.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/Kconfig                    |    4 +++-
 arch/x86/mach-voyager/voyager_smp.c |   16 ++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4e529cc..7e971cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -167,9 +167,11 @@ config GENERIC_PENDING_IRQ
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
-	select USE_GENERIC_SMP_HELPERS
 	default y
 
+config USE_GENERIC_SMP_HELPERS
+	def_bool y
+
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 9cd327a..63ed72b 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -7,6 +7,7 @@
  * This file provides all the same external entries as smp.c but uses
  * the voyager hal to provide the functionality
  */
+#include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
@@ -1783,6 +1784,17 @@ void __init smp_setup_processor_id(void)
 	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
 
+static void voyager_send_call_func(cpumask_t callmask)
+{
+	__u32 mask = cpus_addr(callmask)[0] & ~(1 << smp_processor_id());
+	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
+}
+
+static void voyager_send_call_func_single(int cpu)
+{
+	send_CPI(1 << cpu, VIC_CALL_FUNCTION_SINGLE_CPI);
+}
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = voyager_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = voyager_smp_prepare_cpus,
@@ -1792,6 +1804,6 @@ struct smp_ops smp_ops = {
 	.smp_send_stop = voyager_smp_send_stop,
 	.smp_send_reschedule = voyager_smp_send_reschedule,
 
-	.send_call_func_ipi = native_send_call_func_ipi,
-	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.send_call_func_ipi = voyager_send_call_func,
+	.send_call_func_single_ipi = voyager_send_call_func_single,
 };
-- 
1.5.6.5



