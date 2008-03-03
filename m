Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYCCR03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYCCR03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbYCCRPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472AbYCCRPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:44 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 40/52] make x86_64 accept the max_cpus parameter
Date: Mon,  3 Mar 2008 14:13:08 -0300
Message-Id: <1204564400-17636-41-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-40-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter passing parsing is done in the common smpboot.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/mpparse_64.c |    7 +++++++
 arch/x86/kernel/smpboot.c    |   12 ++++++++++++
 arch/x86/kernel/smpboot_32.c |   13 -------------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/mpparse_64.c b/arch/x86/kernel/mpparse_64.c
index 72ab140..2a1f788 100644
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -32,6 +32,7 @@
 
 /* Have we found an MP table */
 int smp_found_config;
+unsigned int __cpuinitdata maxcpus = NR_CPUS;
 
 /*
  * Various Linux-internal data structures created from the
@@ -115,6 +116,12 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
 		return;
 	}
 
+	if (num_processors >= maxcpus) {
+		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
+			" Processor ignored.\n", maxcpus);
+		return;
+	}
+
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c35cd31..34c3117 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -268,3 +268,15 @@ void __cpu_die(unsigned int cpu)
 }
 #endif
 
+/*
+ * If the BIOS enumerates physical processors before logical,
+ * maxcpus=N at enumeration-time can be used to disable HT.
+ */
+static int __init parse_maxcpus(char *arg)
+{
+	extern unsigned int maxcpus;
+
+	maxcpus = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+early_param("maxcpus", parse_maxcpus);
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 00b1b59..3236e84 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1113,16 +1113,3 @@ void __init smp_intr_init(void)
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 }
-
-/*
- * If the BIOS enumerates physical processors before logical,
- * maxcpus=N at enumeration-time can be used to disable HT.
- */
-static int __init parse_maxcpus(char *arg)
-{
-	extern unsigned int maxcpus;
-
-	maxcpus = simple_strtoul(arg, NULL, 0);
-	return 0;
-}
-early_param("maxcpus", parse_maxcpus);
-- 
1.5.0.6

