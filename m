Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbZEGJYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbZEGJYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761466AbZEGJXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:40440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761447AbZEGJXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:30 -0400
Date: Thu, 7 May 2009 09:22:42 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144554.738772000@intel.com>
References: <20090403144554.738772000@intel.com>
Subject: [tip:tracing/core] x86, debugctlmsr: add _on_cpu variants to debugctlmsr functions
Message-ID: <tip-35bb7600c17762bb129588c1877d2717fe325289@git.kernel.org>
Git-Commit-ID: 35bb7600c17762bb129588c1877d2717fe325289
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:22:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35bb7600c17762bb129588c1877d2717fe325289
Gitweb:     http://git.kernel.org/tip/35bb7600c17762bb129588c1877d2717fe325289
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:19 +0200

x86, debugctlmsr: add _on_cpu variants to debugctlmsr functions

Add functions to get and set the debugctlmsr on different cpus.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144554.738772000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2483807..1efeb49 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -785,6 +785,21 @@ static inline unsigned long get_debugctlmsr(void)
     return debugctlmsr;
 }
 
+static inline unsigned long get_debugctlmsr_on_cpu(int cpu)
+{
+	u64 debugctlmsr = 0;
+	u32 val1, val2;
+
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return 0;
+#endif
+	rdmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR, &val1, &val2);
+	debugctlmsr = val1 | ((u64)val2 << 32);
+
+	return debugctlmsr;
+}
+
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
@@ -794,6 +809,18 @@ static inline void update_debugctlmsr(unsigned long debugctlmsr)
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
+static inline void update_debugctlmsr_on_cpu(int cpu,
+					     unsigned long debugctlmsr)
+{
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return;
+#endif
+	wrmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR,
+		     (u32)((u64)debugctlmsr),
+		     (u32)((u64)debugctlmsr >> 32));
+}
+
 /*
  * from system description table in BIOS. Mostly for MCA use, but
  * others may find it useful:
