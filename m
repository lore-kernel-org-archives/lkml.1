Return-Path: <linux-kernel-owner+w=401wt.eu-S1765851AbXIUVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765851AbXIUVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbXIUUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763445AbXIUUp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:29 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: avi@qumranet.com, hpa@zytor.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [45/45] i386: simplify smp_call_function_single() call sequence
Message-Id: <20070921204528.BA65214EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Avi Kivity <avi@qumranet.com>

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/msr-on-cpu.c |   62 +++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

Index: linux/arch/i386/lib/msr-on-cpu.c
===================================================================
--- linux.orig/arch/i386/lib/msr-on-cpu.c
+++ linux/arch/i386/lib/msr-on-cpu.c
@@ -26,27 +26,18 @@ static void __rdmsr_safe_on_cpu(void *in
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
 
@@ -67,27 +58,18 @@ static void __wrmsr_safe_on_cpu(void *in
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
 
