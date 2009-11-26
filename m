Return-Path: <linux-kernel-owner+w=401wt.eu-S1750998AbZKZFEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbZKZFEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZKZFEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:04:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43628 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZKZFEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mFnIvc4VysgZIGbYbDDXPDoYXe1aoBn9I+4SuZsLMd+wOwQ8dbWDGa2vWsryq2Er51
         9e3/XBooTxSRWIz+z5thjisjQzS9fKl8lmRRqtm8pnVivJdsAzwWuFSLmTwWEeyIcZoP
         I1PehVFdp0m+vQArOV4S+KYlwGxrdc/bBZLGM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 4/3] x86/hw-breakpoints: Don't lose GE flag while disabling a breakpoint
Date: Thu, 26 Nov 2009 06:04:38 +0100
Message-Id: <1259211878-6013-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
References: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we schedule out a breakpoint from the cpu, we also incidentally
remove the "Global exact breakpoint" flag from the breakpoint control
register. It makes us losing the fine grained precision about the
origin of the instructions that may trigger breakpoint exceptions for
the other breakpoints running in this cpu.

Reported-by: Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 92ea5aa..d42f65a 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -59,22 +59,28 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
 static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
 
-/*
- * Encode the length, type, Exact, and Enable bits for a particular breakpoint
- * as stored in debug register 7.
- */
-unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
+static inline unsigned long
+__encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
 	unsigned long bp_info;
 
 	bp_info = (len | type) & 0xf;
 	bp_info <<= (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
-	bp_info |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE)) |
-				DR_GLOBAL_SLOWDOWN;
+	bp_info |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));
+
 	return bp_info;
 }
 
 /*
+ * Encode the length, type, Exact, and Enable bits for a particular breakpoint
+ * as stored in debug register 7.
+ */
+unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
+{
+	return __encode_dr7(drnum, len, type) | DR_GLOBAL_SLOWDOWN;
+}
+
+/*
  * Decode the length and type bits for a particular breakpoint as
  * stored in debug register 7.  Return the "enabled" status.
  */
@@ -154,7 +160,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 		return;
 
 	dr7 = &__get_cpu_var(cpu_dr7);
-	*dr7 &= ~encode_dr7(i, info->len, info->type);
+	*dr7 &= ~__encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
 }
-- 
1.6.2.3

