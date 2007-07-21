Return-Path: <linux-kernel-owner+w=401wt.eu-S938222AbXGUPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938222AbXGUPA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbXGUO5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:57:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:45574 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXGUO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:57:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] [msr driver] Simplify smp_call_function_single() call sequence
Date: Sat, 21 Jul 2007 17:57:56 +0300
Message-Id: <1185029877171-git-send-email-avi@qumranet.com>
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
 arch/i386/lib/msr-on-cpu.c |   62 +++++++++++++++----------------------------
 1 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/arch/i386/lib/msr-on-cpu.c b/arch/i386/lib/msr-on-cpu.c
index 7767962..57d043f 100644
--- a/arch/i386/lib/msr-on-cpu.c
+++ b/arch/i386/lib/msr-on-cpu.c
@@ -26,27 +26,18 @@ static void __rdmsr_safe_on_cpu(void *info)
 static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
 {
 	int err = 0;
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		if (safe)
-			err = rdmsr_safe(msr_no, l, h);
-		else
-			rdmsr(msr_no, *l, *h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		if (safe) {
-			smp_call_function_single(cpu, __rdmsr_safe_on_cpu,
-						 &rv, 0, 1);
-			err = rv.err;
-		} else {
-			smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
-		}
-		*l = rv.l;
-		*h = rv.h;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	if (safe) {
+		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 0, 1);
+		err = rv.err;
+	} else {
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
 	}
-	preempt_enable();
+	*l = rv.l;
+	*h = rv.h;
+
 	return err;
 }
 
@@ -67,27 +58,18 @@ static void __wrmsr_safe_on_cpu(void *info)
 static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
 {
 	int err = 0;
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		if (safe)
-			err = wrmsr_safe(msr_no, l, h);
-		else
-			wrmsr(msr_no, l, h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		rv.l = l;
-		rv.h = h;
-		if (safe) {
-			smp_call_function_single(cpu, __wrmsr_safe_on_cpu,
-						 &rv, 0, 1);
-			err = rv.err;
-		} else {
-			smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
-		}
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	rv.l = l;
+	rv.h = h;
+	if (safe) {
+		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 0, 1);
+		err = rv.err;
+	} else {
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
 	}
-	preempt_enable();
+
 	return err;
 }
 
-- 
1.5.2.4

