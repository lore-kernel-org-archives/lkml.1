Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZDNQH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZDNQH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZDNQHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:07:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:46379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZDNQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:07:47 -0400
Subject: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 21:37:20 +0530
Message-Id: <1239725240.2966.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will prepare the report to update cpu_debug.
If files are inappropriate or CPU is not supported.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpu_debug.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..33fde75 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -30,6 +30,8 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
+#define EMAIL	"<linux-kernel@vger.kernel.org>, <jaswinderrajput@gmail.com>"
+
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(unsigned, cpu_modelflag);
@@ -838,6 +840,17 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	return err;
 }
 
+/*
+ * Prepare report for LKML and maintainer if files count are inappropriate
+ * Or CPU is not supported
+ */
+static void send_report(int files, struct cpuinfo_x86 *cpui)
+{
+	WARN_ONCE(1, "Please report \"cpu_debug files %d for %x:%x:%x:%x\" to"
+		  " %s\n", files, cpui->x86_vendor, cpui->x86, cpui->x86_model,
+		  cpui->x86_mask, EMAIL);
+}
+
 static int cpu_init_cpu(void)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -861,9 +874,13 @@ static int cpu_init_cpu(void)
 
 		pr_info("cpu%d(%d) debug files %d\n",
 			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
+		if (!per_cpu(cpu_modelflag, cpu))
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
+
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
 			pr_err("Register files count %d exceeds limit %d\n",
 				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
-- 
1.6.0.6



