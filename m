Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZKZIqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZKZIqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbZKZIqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:46:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:58873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760116AbZKZIqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:46:03 -0500
Date: Thu, 26 Nov 2009 08:45:24 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <1259211878-6013-1-git-send-regression-fweisbec@gmail.com>
References: <1259211878-6013-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/hw-breakpoints: Don't lose GE flag while disabling a breakpoint
Message-ID: <tip-2c31b7958fd21df9fa04e5c36cda0f063ac70b27@git.kernel.org>
Git-Commit-ID: 2c31b7958fd21df9fa04e5c36cda0f063ac70b27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c31b7958fd21df9fa04e5c36cda0f063ac70b27
Gitweb:     http://git.kernel.org/tip/2c31b7958fd21df9fa04e5c36cda0f063ac70b27
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 26 Nov 2009 06:04:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:29:22 +0100

x86/hw-breakpoints: Don't lose GE flag while disabling a breakpoint

When we schedule out a breakpoint from the cpu, we also
incidentally remove the "Global exact breakpoint" flag from the
breakpoint control register. It makes us losing the fine grained
precision about the origin of the instructions that may trigger
breakpoint exceptions for the other breakpoints running in this
cpu.

Reported-by: Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259211878-6013-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
