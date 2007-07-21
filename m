Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXGUO56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXGUO56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXGUO5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:57:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:45573 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXGUO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:57:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] [cpuid driver] Simplify smp_call_function_single() call sequence
Date: Sat, 21 Jul 2007 17:57:55 +0300
Message-Id: <1185029877880-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11850298772540-git-send-email-avi@qumranet.com>
References: <11850298772540-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/i386/kernel/cpuid.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/i386/kernel/cpuid.c b/arch/i386/kernel/cpuid.c
index 5c2faa1..5665dd2 100644
--- a/arch/i386/kernel/cpuid.c
+++ b/arch/i386/kernel/cpuid.c
@@ -45,8 +45,6 @@
 
 static struct class *cpuid_class;
 
-#ifdef CONFIG_SMP
-
 struct cpuid_command {
 	u32 reg;
 	u32 *data;
@@ -64,25 +62,11 @@ static inline void do_cpuid(int cpu, u32 reg, u32 * data)
 {
 	struct cpuid_command cmd;
 
-	preempt_disable();
-	if (cpu == smp_processor_id()) {
-		cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-	} else {
-		cmd.reg = reg;
-		cmd.data = data;
+	cmd.reg = reg;
+	cmd.data = data;
 
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
-	}
-	preempt_enable();
+	smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
 }
-#else				/* ! CONFIG_SMP */
-
-static inline void do_cpuid(int cpu, u32 reg, u32 * data)
-{
-	cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-}
-
-#endif				/* ! CONFIG_SMP */
 
 static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 {
-- 
1.5.2.4

